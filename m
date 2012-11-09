From: Aaron Lu <aaron.lu@intel.com>
Subject: [PATCH v9 06/10] ata: zpodd: check zero power ready status
Date: Fri,  9 Nov 2012 14:51:58 +0800
Message-ID: <1352443922-13734-7-git-send-email-aaron.lu@intel.com>
References: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <1352443922-13734-1-git-send-email-aaron.lu@intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>
Cc: Jeff Wu <jeff.wu@amd.com>, Aaron Lu <aaron.lwe@gmail.com>, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-acpi@vger.kernel.org, Aaron Lu <aaron.lu@intel.com>
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
 drivers/ata/libata-acpi.c  |   8 +++-
 drivers/ata/libata-scsi.c  |   4 ++
 drivers/ata/libata-zpodd.c | 116 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/ata/libata.h       |   4 ++
 4 files changed, 131 insertions(+), 1 deletion(-)

diff --git a/drivers/ata/libata-acpi.c b/drivers/ata/libata-acpi.c
index 6b6819c..13ee178 100644
--- a/drivers/ata/libata-acpi.c
+++ b/drivers/ata/libata-acpi.c
@@ -784,7 +784,13 @@ static int ata_acpi_push_id(struct ata_device *dev)
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
index e3bda07..6f235b9 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -2665,6 +2665,10 @@ static void atapi_qc_complete(struct ata_queued_cmd *qc)
 			ata_scsi_rbuf_put(cmd, true, &flags);
 		}
 
+		if (zpodd_dev_enabled(qc->dev) &&
+				scsicmd[0] == GET_EVENT_STATUS_NOTIFICATION)
+			zpodd_snoop_status(qc->dev, cmd);
+
 		cmd->result = SAM_STAT_GOOD;
 	}
 
diff --git a/drivers/ata/libata-zpodd.c b/drivers/ata/libata-zpodd.c
index ba8c985..533a39e 100644
--- a/drivers/ata/libata-zpodd.c
+++ b/drivers/ata/libata-zpodd.c
@@ -2,13 +2,21 @@
 #include <linux/cdrom.h>
 #include <linux/pm_runtime.h>
 #include <scsi/scsi_device.h>
+#include <scsi/scsi_cmnd.h>
 
 #include "libata.h"
 
+#define POWEROFF_DELAY  (30 * 1000)     /* 30 seconds for power off delay */
+
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
@@ -93,6 +101,114 @@ static bool device_can_poweroff(struct ata_device *ata_dev)
 		return false;
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
diff --git a/drivers/ata/libata.h b/drivers/ata/libata.h
index 5d68210..2b46703 100644
--- a/drivers/ata/libata.h
+++ b/drivers/ata/libata.h
@@ -241,10 +241,14 @@ static inline bool zpodd_dev_enabled(struct ata_device *dev)
 	else
 		return false;
 }
+void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd);
+void zpodd_check_zpready(struct ata_device *dev);
 #else /* CONFIG_SATA_ZPODD */
 static inline void zpodd_init(struct ata_device *dev) {}
 static inline void zpodd_deinit(struct ata_device *dev) {}
 static inline bool zpodd_dev_enabled(struct ata_device *dev) { return false; }
+static inline void zpodd_snoop_status(struct ata_device *dev, struct scsi_cmnd *scmd) {}
+static inline void zpodd_check_zpready(struct ata_device *dev) {}
 #endif /* CONFIG_SATA_ZPODD */
 
 /* libata-atapi.c */
-- 
1.7.12.4

