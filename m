From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC] more struct scsi_lun
Date: Sun, 23 Oct 2005 00:49:53 -0400
Message-ID: <20051023044953.GA23354@havoc.gtf.org>
References: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:29664 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751229AbVJWEty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 00:49:54 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id B20691C095A8
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 00:49:53 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N4nrLT023378
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 00:49:53 -0400
Content-Disposition: inline
In-Reply-To: <20051023043301.GA22615@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


Minor cleanups following primary scsi_lun patch (just sent):

- create and use SCSILUN_STR_LEN
- pass struct scsi_lun to scsilun_to_str(), not struct scsi_device


 drivers/scsi/scsi_proc.c   |    4 ++--
 drivers/scsi/scsi_scan.c   |   11 +++++------
 drivers/scsi/scsi_sysfs.c  |    6 +++---
 drivers/scsi/sg.c          |    8 ++++----
 include/scsi/scsi.h        |    1 +
 include/scsi/scsi_device.h |    4 ++--
 6 files changed, 17 insertions(+), 17 deletions(-)

7c838ac815a38b5f99bf717b1a7aa2f6b57b51bc
diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index d0c2160..6eadb5b 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -147,12 +147,12 @@ static int proc_print_scsidevice(struct 
 	struct scsi_device *sdev = to_scsi_device(dev);
 	struct seq_file *s = data;
 	int i;
-	char lunstr[33];
+	char lunstr[SCSILUN_STR_LEN];
 
 	seq_printf(s,
 		"Host: scsi%d Channel: %02d Id: %02d Lun: %s\n  Vendor: ",
 		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
-		scsilun_to_str(sdev, lunstr));
+		scsilun_to_str(&sdev->lun, lunstr));
 
 	for (i = 0; i < 8; i++) {
 		if (sdev->vendor[i] >= 0x20)
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 5315beb..fb1d9c7 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -608,7 +608,7 @@ static int scsi_probe_lun(struct scsi_de
  **/
 static int scsi_add_lun(struct scsi_device *sdev, char *inq_result, int *bflags)
 {
-	char lunstr[33];
+	char lunstr[SCSILUN_STR_LEN];
 
 	/*
 	 * XXX do not save the inquiry, since it can change underneath us,
@@ -697,7 +697,7 @@ static int scsi_add_lun(struct scsi_devi
 	sprintf(sdev->devfs_name, "scsi/host%d/bus%d/target%d/lun%s",
 				sdev->host->host_no, sdev_channel(sdev),
 				sdev_id(sdev),
-				scsilun_to_str(sdev, lunstr));
+				scsilun_to_str(&sdev->lun, lunstr));
 
 	/*
 	 * End driverfs/devfs code.
@@ -1421,12 +1421,11 @@ static void scsi_scan_channel(struct Scs
 int scsi_scan_host_selected(struct Scsi_Host *shost, unsigned int channel,
 			    unsigned int id, const struct scsi_lun *lun, int rescan)
 {
-	char lunstr[33];
-
-	sprintf(lunstr, "%d", scsilun_to_int(lun));
+	char lunstr[SCSILUN_STR_LEN];
 
 	SCSI_LOG_SCAN_BUS(3, printk (KERN_INFO "%s: <%u:%u:%u:%s>\n",
-		__FUNCTION__, shost->host_no, channel, id, lunstr));
+		__FUNCTION__, shost->host_no, channel, id,
+		scsilun_to_str(lun, lunstr)));
 
 	if (((channel != SCAN_WILD_CARD) && (channel > shost->max_channel)) ||
 	    ((id != SCAN_WILD_CARD) && (id > shost->max_id)))
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index a52e963..63352fc 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -865,14 +865,14 @@ void scsi_sysfs_device_initialize(struct
 	unsigned long flags;
 	struct Scsi_Host *shost = sdev->host;
 	struct scsi_target  *starget = sdev->sdev_target;
-	char lunstr[33];
+	char lunstr[SCSILUN_STR_LEN];
 
 	device_initialize(&sdev->sdev_gendev);
 	sdev->sdev_gendev.bus = &scsi_bus_type;
 	sdev->sdev_gendev.release = scsi_device_dev_release;
 	sprintf(sdev->sdev_gendev.bus_id,"%d:%d:%d:%s",
 		sdev->host->host_no, sdev_channel(sdev), sdev_id(sdev),
-		scsilun_to_str(sdev, lunstr));
+		scsilun_to_str(&sdev->lun, lunstr));
 	
 	class_device_initialize(&sdev->sdev_classdev);
 	sdev->sdev_classdev.dev = &sdev->sdev_gendev;
@@ -880,7 +880,7 @@ void scsi_sysfs_device_initialize(struct
 	snprintf(sdev->sdev_classdev.class_id, BUS_ID_SIZE,
 		 "%d:%d:%d:%s", sdev->host->host_no,
 		 sdev_channel(sdev), sdev_id(sdev),
-		scsilun_to_str(sdev, lunstr));
+		scsilun_to_str(&sdev->lun, lunstr));
 	sdev->scsi_level = SCSI_2;
 	transport_setup_device(&sdev->sdev_gendev);
 	spin_lock_irqsave(shost->host_lock, flags);
diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
index 3ab60e5..1c2ca07 100644
--- a/drivers/scsi/sg.c
+++ b/drivers/scsi/sg.c
@@ -3003,14 +3003,14 @@ static int sg_proc_seq_show_dev(struct s
 	struct sg_proc_deviter * it = (struct sg_proc_deviter *) v;
 	Sg_device *sdp;
 	struct scsi_device *scsidp;
-	char lunstr[33];
+	char lunstr[SCSILUN_STR_LEN];
 
 	sdp = it ? sg_get_dev(it->index) : NULL;
 	if (sdp && (scsidp = sdp->device) && (!sdp->detached))
 		seq_printf(s, "%d\t%d\t%d\t%s\t%d\t%d\t%d\t%d\t%d\n",
 			      scsidp->host->host_no, sdev_channel(scsidp),
 			      sdev_id(scsidp),
-			      scsilun_to_str(scsidp, lunstr),
+			      scsilun_to_str(&scsidp->lun, lunstr),
 			      (int) scsidp->type,
 			      1,
 			      (int) scsidp->queue_depth,
@@ -3133,12 +3133,12 @@ static int sg_proc_seq_show_debug(struct
 			if (sdp->detached)
 				seq_printf(s, "detached pending close ");
 			else {
-				char lunstr[33];
+				char lunstr[SCSILUN_STR_LEN];
 				seq_printf
 				    (s, "scsi%d chan=%d id=%d lun=%s   em=%d",
 				     scsidp->host->host_no,
 				     sdev_channel(scsidp), sdev_id(scsidp),
-				     scsilun_to_str(scsidp, lunstr),
+				     scsilun_to_str(&scsidp->lun, lunstr),
 				     scsidp->host->hostt->emulated);
 			}
 			seq_printf(s, " sg_tablesize=%d excl=%d\n",
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index b361172..deb1a27 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -241,6 +241,7 @@ struct ccs_modesel_head {
 struct scsi_lun {
 	__u8 scsi_lun[8];
 };
+#define SCSILUN_STR_LEN 33
 
 /*
  *  MESSAGE CODES
diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
index 03b381e..769469c 100644
--- a/include/scsi/scsi_device.h
+++ b/include/scsi/scsi_device.h
@@ -278,9 +278,9 @@ static inline unsigned int sdev_id(struc
 	return sdev->sdev_target->id;
 }
 
-static inline char *scsilun_to_str(struct scsi_device *sdev, char *s)
+static inline char *scsilun_to_str(const struct scsi_lun *lun, char *s)
 {
-	sprintf(s, "%d", scsilun_to_int(&sdev->lun));
+	sprintf(s, "%d", scsilun_to_int(lun));
 	return s;
 }
 
