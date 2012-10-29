From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v8 08/11] ata: zpodd: check zero power ready status
Date: Mon, 29 Oct 2012 17:01:35 +0800
Message-ID: <1351501298-3716-9-git-send-email-aaron.lu@intel.com>
References: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1351501298-3716-1-git-send-email-aaron.lu@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>, Oliver Neukum <oliver@neukum.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, Shane Huang <shane.huang@amd.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Per the Mount Fuji spec, the ODD is considered zero power ready when:
- For slot type ODD, no media inside;
- For tray type ODD, no media inside and tray closed.

The information can be retrieved by either the returned information of
command GET_EVENT_STATUS_NOTIFICATION(the command is used to poll for
media event) or sense code.

In this implementation, the zero power ready status is determined by
the following factors:
1 polled media status byte, and this info is recorded in status_ready
  field of zpodd structure;
2 sense code by issuing a TEST_UNIT_READY command after status_ready
  is found to be true.

The information provided by the media status byte is not accurate, it is
possible that after a new disc is just inserted, the status byte still
returns media not present. So this information can not be used as the
final deciding factor. But since SCSI ODD driver sr will always poll the
ODD every 2 seconds, this information is readily available without any
much cost. So it is used as a hint: when we find zero power ready status
in the media status byte, we will see if it is really the case with the
sense code method. This way, we can avoid sending too many
TEST_UNIT_READY commands to the ODD.

When we first sensed the ODD in the zero power ready state, the
timestamp will be recoreded. And after ODD stayed in this state for some
pre-defined period, the ODD is considered as power off ready and the
zp_ready flag will be set. The zp_ready flag serves as the deciding
factor other code will use to see if power off is OK for the ODD. The
Mount Fuji spec suggests a delay should be used here, to avoid the case
user ejects the ODD and then instantly inserts a new one again, so that
we can avoid a power transition. And some ODDs may be slow to place its
head to the home position after disc is ejected, so a delay here is
generally a good idea.

The zero power ready status check is performed in the ata port's runtime
suspend code path, when port is not frozen yet, as we need to issue some
IOs to the ODD.

Signed-off-by: Aaron Lu <aaron.lu@intel.com>
---
 drivers/ata/libata-acpi.c |   8 +++-
 drivers/ata/libata-scsi.c |   5 ++
 drivers/ata/sata_zpodd.c  | 117 ++++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/sata_zpodd.h  |   5 ++
 4 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 3167fc2..5a78cb3 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -785,7 +785,13 @@ static int ata_acpi_push_id(struct ata_device *dev)
  */
 int ata_acpi_on_suspend(struct ata_port *ap)
 {
-	/* nada */
+	struct ata_device *dev;
+
+	ata_for_each_dev(dev, &ap->link, ENABLED) {
+		if (zpodd_dev_enabled(dev))
+			zpodd_check_zpready(dev);
+	}
+
 	return 0;
 }
 
diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index e3bda07..ed3e4d3 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -53,6 +53,7 @@
 
 #include "libata.h"
 #include "libata-transport.h"
+#include "sata_zpodd.h"
 
 #define ATA_SCSI_RBUF_SIZE	4096
 
@@ -2665,6 +2666,10 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 			ata_scsi_rbuf_put(cmd, true, &flags);
 		}
 
+		if (zpodd_dev_enabled(qc->dev) &&
+				scsicmd[0] == GET_EVENT_STATUS_NOTIFICATION)
+			zpodd_snoop_status(qc->dev, cmd);
+
 		cmd->result = SAM_STAT_GOOD;
 	}
 
diff --git a/drivers/ata/sata_zpodd.c b/drivers/ata/sata_zpodd.c
index c7c63a1..0ec62f3 100644
--- a/drivers/ata/sata_zpodd.c
+++ b/drivers/ata/sata_zpodd.c
@@ -2,13 +2,22 @@
 #include <linux/pm_runtime.h>
 #include <linux/cdrom.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "libata.h"
+#include "libata-atapi.h"
+
+#define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
 
 struct zpodd {
 	bool slot:1;
 	bool drawer:1;
 	bool from_notify:1;	/* resumed as a result of acpi notification */
+	bool status_ready:1;	/* ready status derived from media event poll,
+				   it is not accurate, but serves as a hint */
+	bool zp_ready:1;	/* zero power ready state */
+
+	unsigned long last_ready; /* last zero power ready timestamp */
 
 	struct ata_device *dev;
 };
@@ -84,6 +93,114 @@ static int check_loading_mechanism(struct ata_device *dev)
 	return ret;
 }
 
+/*
+ * Snoop the result of GET_STATUS_NOTIFICATION_EVENT, the media
+ * status byte has information on media present/door closed.
+ *
+ * This information serves only as a hint, as it is not accurate.
+ * The sense code method will be used when deciding if the ODD is
+ * really zero power ready.
+ */
+void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd)
+{
+	bool ready;
+	char buf[8];
+	struct event_header *eh = (void *)buf;
+	struct media_event_desc *med = (void *)(buf + 4);
+	struct sg_table *table = &scmd->sdb.table;
+	struct zpodd *zpodd = dev->private_data;
+
+	if (sg_copy_to_buffer(table->sgl, table->nents, buf, 8) != 8)
+		return;
+
+	if (be16_to_cpu(eh->data_len) < sizeof(*med))
+		return;
+
+	if (eh->nea || eh->notification_class != 0x4)
+		return;
+
+	if (zpodd->slot)
+		ready = !med->media_present;
+	else
+		ready = !(med->media_present || med->door_open);
+
+	zpodd->status_ready = ready;
+}
+
+/* Test if ODD is zero power ready by sense code */
+static bool zpready(struct ata_device *dev)
+{
+	u8 sense_key, *sense_buf;
+	unsigned int ret, asc, ascq, add_len;
+	struct zpodd *zpodd = dev->private_data;
+
+	ret = atapi_eh_tur(dev, &sense_key);
+
+	if (!ret || sense_key != NOT_READY)
+		return false;
+
+	sense_buf = dev->link->ap->sector_buf;
+	ret = atapi_eh_request_sense(dev, sense_buf, sense_key);
+	if (ret)
+		return false;
+
+	/* sense valid */
+	if ((sense_buf[0] & 0x7f) != 0x70)
+		return false;
+
+	add_len = sense_buf[7];
+	/* has asc and ascq */
+	if (add_len < 6)
+		return false;
+
+	asc = sense_buf[12];
+	ascq = sense_buf[13];
+
+	if (zpodd->slot)
+		/* no media inside */
+		return asc == 0x3a;
+	else
+		/* no media inside and door closed */
+		return asc == 0x3a && ascq == 0x01;
+}
+
+/*
+ * Check ODD's zero power ready status.
+ *
+ * This function is called during ATA port's suspend path,
+ * when the port is not frozen yet, so that we can still make
+ * some IO to the ODD to decide if it is zero power ready.
+ *
+ * The ODD is regarded as zero power ready when it is in zero
+ * power ready state for some time(defined by POWEROFF_DELAY).
+ */
+void zpodd_check_zpready(struct ata_device *dev)
+{
+	bool zp_ready;
+	unsigned long expires;
+	struct zpodd *zpodd = dev->private_data;
+
+	if (!zpodd->status_ready) {
+		zpodd->last_ready = 0;
+		return;
+	}
+
+	if (!zpodd->last_ready) {
+		zp_ready = zpready(dev);
+		if (zp_ready)
+			zpodd->last_ready = jiffies;
+		return;
+	}
+
+	expires = zpodd->last_ready + msecs_to_jiffies(POWEROFF_DELAY);
+	if (time_before(jiffies, expires))
+		return;
+
+	zpodd->zp_ready = zpready(dev);
+	if (!zpodd->zp_ready)
+		zpodd->last_ready = 0;
+}
+
 static void zpodd_wake_dev(acpi_handle handle, u32 event, void *context)
 {
 	struct ata_device *ata_dev = context;
diff --git a/drivers/ata/sata_zpodd.h b/drivers/ata/sata_zpodd.h
index e320c6f..03d6b4d 100644
--- a/drivers/ata/sata_zpodd.h
+++ b/drivers/ata/sata_zpodd.h
@@ -2,6 +2,7 @@
 #define __SATA_ZPODD_H__
 
 #include <linux/libata.h>
+#include <scsi/scsi_cmnd.h>
 
 #ifdef CONFIG_SATA_ZPODD
 void zpodd_init(struct ata_device *);
@@ -15,10 +16,14 @@ static bool zpodd_dev_enabled(struct ata_device *dev)
 		return false;
 }
 
+void zpodd_snoop_status(struct ata_device *, struct scsi_cmnd *);
+void zpodd_check_zpready(struct ata_device *);
 #else
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_deinit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+static inline void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *cmd) {}
+static inline void zpodd_check_zpready(struct ata_device *dev) {}
 #endif
 
 #endif
-- 
1.7.12.4

