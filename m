From: Tejun Heo <htejun@gmail.com>
Subject: [PATCH scsi-misc-2.6] SCSI: kill sht->suspend/resume
Date: Wed, 21 Mar 2007 16:05:16 +0900
Message-ID: <20070321070516.GJ6152@htj.dyndns.org>
References: <20070320150718.GF6152@htj.dyndns.org> <20070320151359.GG6152@htj.dyndns.org> <20070320152533.GH6152@htj.dyndns.org> <20070320152919.GA28403@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070320152919.GA28403@infradead.org>
Sender: linux-ide-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>, djwong@us.ibm.com, hmh@hmh.eng.br
List-Id: linux-scsi@vger.kernel.org

With libata converted to use sdev->manage_start_stop for suspend and
resume, sht->suspend/resume() has no user left and low level
suspend/ressume should be taken care of by low level driver's
suspend/resume callbacks (e.g. PCI or PCMCIA driver callbacks).  This
patch removes sht->suspend/resume() callbacks.

This change is suggested by Christoph Hellwig.

Signed-off-by: Tejun Heo <htejun@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>
---
This patch breaks the existing libata suspend/resume support and thus
should not be applied before libata is updated.  So, please don't
apply it yet.

Thanks.

diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 96db51c..ec64aff 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -280,30 +280,18 @@ static int scsi_bus_suspend(struct device * dev, pm_message_t state)
 {
 	struct device_driver *drv = dev->driver;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
 	int err;
 
 	err = scsi_device_quiesce(sdev);
 	if (err)
 		return err;
 
-	/* call HLD suspend first */
 	if (drv && drv->suspend) {
 		err = drv->suspend(dev, state);
 		if (err)
 			return err;
 	}
 
-	/* then, call host suspend */
-	if (sht->suspend) {
-		err = sht->suspend(sdev, state);
-		if (err) {
-			if (drv && drv->resume)
-				drv->resume(dev);
-			return err;
-		}
-	}
-
 	return 0;
 }
 
@@ -311,21 +299,14 @@ static int scsi_bus_resume(struct device * dev)
 {
 	struct device_driver *drv = dev->driver;
 	struct scsi_device *sdev = to_scsi_device(dev);
-	struct scsi_host_template *sht = sdev->host->hostt;
-	int err = 0, err2 = 0;
-
-	/* call host resume first */
-	if (sht->resume)
-		err = sht->resume(sdev);
+	int err = 0;
 
-	/* then, call HLD resume */
 	if (drv && drv->resume)
-		err2 = drv->resume(dev);
+		err = drv->resume(dev);
 
 	scsi_device_resume(sdev);
 
-	/* favor LLD failure */
-	return err ? err : err2;;
+	return err;
 }
 
 struct bus_type scsi_bus_type = {
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 68f461b..4a2e490 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -339,12 +339,6 @@ struct scsi_host_template {
 	enum scsi_eh_timer_return (* eh_timed_out)(struct scsi_cmnd *);
 
 	/*
-	 * suspend support
-	 */
-	int (*resume)(struct scsi_device *);
-	int (*suspend)(struct scsi_device *, pm_message_t state);
-
-	/*
 	 * Name of proc directory
 	 */
 	char *proc_name;

