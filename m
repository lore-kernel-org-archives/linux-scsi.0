From: Gwendal Grignou <gwendal@google.com>
Subject: [PATCH 2/3] scsi: Allow devices to have arbitrary parent
Date: Thu, 27 Sep 2012 12:04:03 -0700
Message-ID: <1348772644-12486-3-git-send-email-gwendal@google.com>
References: <1348772644-12486-1-git-send-email-gwendal@google.com>
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1348772644-12486-1-git-send-email-gwendal@google.com>
In-Reply-To: <20120920020145.GA23210@mint-spring.sh.intel.com>
References: <20120920020145.GA23210@mint-spring.sh.intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: aaron.lu@intel.com, minggr@gmail.com, tj@kernel.org, jgarzik@pobox.com, james.bottomley@hansenpartnership.com
Cc: Gwendal Grignou <gwendal@google.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Allow driver who calls __scsi_add_device directly to create the scsi
device on any parent, not just scsi_host directly.
This is alreay done for transport with their own class [SAS, iSCSI, FC, ...]

Change-Id: Ibcf132a8959fbf732dcd0b34a7f4a570d7cf394d

Signed-off-by: Gwendal Grignou <gwendal@google.com>
---
 drivers/ata/libata-scsi.c      |    4 ++--
 drivers/firewire/sbp2.c        |    3 ++-
 drivers/message/i2o/i2o_scsi.c |    4 ++--
 drivers/scsi/scsi_scan.c       |    9 +++++----
 include/scsi/scsi_device.h     |    2 +-
 5 files changed, 12 insertions(+), 10 deletions(-)

diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
index be38930..bfda61f 100644
--- a/drivers/ata/libata-scsi.c
+++ b/drivers/ata/libata-scsi.c
@@ -3649,8 +3649,8 @@ void ata_scsi_scan_host(struct ata_port *ap, int sync)
 			else
 				channel = link->pmp;
 
-			sdev = __scsi_add_device(ap->scsi_host, channel, id, 0,
-						 NULL);
+			sdev = __scsi_add_device(&ap->scsi_host->shost_gendev,
+						 channel, id, 0, NULL);
 			if (!IS_ERR(sdev)) {
 				dev->sdev = sdev;
 				scsi_device_put(sdev);
diff --git a/drivers/firewire/sbp2.c b/drivers/firewire/sbp2.c
index 1162d6b..839afa5 100644
--- a/drivers/firewire/sbp2.c
+++ b/drivers/firewire/sbp2.c
@@ -879,7 +879,8 @@ static void sbp2_login(struct work_struct *work)
 		ssleep(SBP2_INQUIRY_DELAY);
 
 	shost = container_of((void *)tgt, struct Scsi_Host, hostdata[0]);
-	sdev = __scsi_add_device(shost, 0, 0, sbp2_lun2int(lu->lun), lu);
+	sdev = __scsi_add_device(&shost->shost_gendev, 0, 0,
+				 sbp2_lun2int(lu->lun), lu);
 	/*
 	 * FIXME:  We are unable to perform reconnects while in sbp2_login().
 	 * Therefore __scsi_add_device() will get into trouble if a bus reset
diff --git a/drivers/message/i2o/i2o_scsi.c b/drivers/message/i2o/i2o_scsi.c
index 1d31d72..ee1353c 100644
--- a/drivers/message/i2o/i2o_scsi.c
+++ b/drivers/message/i2o/i2o_scsi.c
@@ -294,8 +294,8 @@ static int i2o_scsi_probe(struct device *dev)
 	}
 
 	scsi_dev =
-	    __scsi_add_device(i2o_shost->scsi_host, channel, le32_to_cpu(id),
-			      le64_to_cpu(lun), i2o_dev);
+	    __scsi_add_device(&i2o_shost->scsi_host->shost_gendev, channel,
+			      le32_to_cpu(id), le64_to_cpu(lun), i2o_dev);
 
 	if (IS_ERR(scsi_dev)) {
 		osm_warn("can not add SCSI device %03x\n",
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 56a9379..105123c 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1489,11 +1489,11 @@ static int scsi_report_lun_scan(struct scsi_target *starget, int bflags,
 	return ret;
 }
 
-struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
+struct scsi_device *__scsi_add_device(struct device *parent, uint channel,
 				      uint id, uint lun, void *hostdata)
 {
+	struct Scsi_Host *shost = dev_to_shost(parent);
 	struct scsi_device *sdev = ERR_PTR(-ENODEV);
-	struct device *parent = &shost->shost_gendev;
 	struct scsi_target *starget;
 
 	if (strncmp(scsi_scan_type, "none", 4) == 0)
@@ -1524,8 +1524,9 @@ EXPORT_SYMBOL(__scsi_add_device);
 int scsi_add_device(struct Scsi_Host *host, uint channel,
 		    uint target, uint lun)
 {
-	struct scsi_device *sdev = 
-		__scsi_add_device(host, channel, target, lun, NULL);
+	struct scsi_device *sdev =
+		__scsi_add_device(&host->shost_gendev, channel, target,
+				  lun, NULL);
 	if (IS_ERR(sdev))
 		return PTR_ERR(sdev);
 
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 9895f69..9646a1d 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -285,7 +285,7 @@ static inline struct scsi_target *scsi_target(struct scsi_device *sdev)
 #define starget_printk(prefix, starget, fmt, a...)	\
 	dev_printk(prefix, &(starget)->dev, fmt, ##a)
 
-extern struct scsi_device *__scsi_add_device(struct Scsi_Host *,
+extern struct scsi_device *__scsi_add_device(struct device *,
 		uint, uint, uint, void *hostdata);
 extern int scsi_add_device(struct Scsi_Host *host, uint channel,
 			   uint target, uint lun);
-- 
1.7.7.3

