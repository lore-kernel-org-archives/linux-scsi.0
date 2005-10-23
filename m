From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC] even yet more struct scsi_lun
Date: Sun, 23 Oct 2005 03:16:54 -0400
Message-ID: <20051023071654.GA27738@havoc.gtf.org>
References: <20051023043301.GA22615@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:28129 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751420AbVJWHQz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 23 Oct 2005 03:16:55 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id CE8E91C09611
	for <linux-scsi@vger.kernel.org>; Sun, 23 Oct 2005 03:16:54 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9N7Gsj0027798
	for linux-scsi@vger.kernel.org; Sun, 23 Oct 2005 03:16:54 -0400
Content-Disposition: inline
In-Reply-To: <20051023043301.GA22615@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


And here is, perhaps, a better way to do unlimited luns.

Attempting to pass large luns through the legacy userspace interfaces
may lead to useless results.



 drivers/scsi/scsi_proc.c  |    2 +-
 drivers/scsi/scsi_scan.c  |    5 ++---
 drivers/scsi/scsi_sysfs.c |    2 +-
 include/scsi/scsi.h       |    1 -
 include/scsi/scsi_host.h  |    5 +++++
 5 files changed, 9 insertions(+), 6 deletions(-)

diff --git a/drivers/scsi/scsi_proc.c b/drivers/scsi/scsi_proc.c
index 6eadb5b..dc70188 100644
--- a/drivers/scsi/scsi_proc.c
+++ b/drivers/scsi/scsi_proc.c
@@ -204,7 +204,7 @@ static int scsi_add_single_device(uint h
 	if (IS_ERR(shost))
 		return PTR_ERR(shost);
 
-	if (lun > shost->max_lun)
+	if ((!shost->unlimited_luns) && (lun > shost->max_lun))
 		return -EINVAL;
 
 	int_to_scsilun(lun, &__lun);
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 09df4e7..2edf967 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1201,13 +1201,12 @@ static int scsi_report_lun_scan(struct s
 	 * the header, so start at 1 and go up to and including num_luns.
 	 */
 	for (lunp = &lun_data[1]; lunp <= &lun_data[num_luns]; lunp++) {
-		int lun;
+		unsigned int lun;
 		char lunstr[SCSILUN_STR_LEN];
 
 		lun = scsilun_to_int(lunp);
 
-		if ((sdev->host->max_lun != SCSILUN_UNLIMITED) &&
-		    (lun > sdev->host->max_lun)) {
+		if ((!shost->unlimited_luns) && (lun > sdev->host->max_lun)) {
 			dev_printk(KERN_WARNING, &sdev->sdev_gendev,
 				"lun %s larger"
 				" than allowed by the host adapter\n",
diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
index 63352fc..4c8a4bf 100644
--- a/drivers/scsi/scsi_sysfs.c
+++ b/drivers/scsi/scsi_sysfs.c
@@ -108,7 +108,7 @@ static int scsi_scan(struct Scsi_Host *s
 	if (check_set(&lun, s3))
 		return -EINVAL;
 
-	if (lun > shost->max_lun)
+	if ((!shost->unlimited_luns) && (lun > shost->max_lun))
 		return -EINVAL;
 	int_to_scsilun(lun, &__lun);
 
diff --git a/include/scsi/scsi.h b/include/scsi/scsi.h
index 7876a64..deb1a27 100644
--- a/include/scsi/scsi.h
+++ b/include/scsi/scsi.h
@@ -242,7 +242,6 @@ struct scsi_lun {
 	__u8 scsi_lun[8];
 };
 #define SCSILUN_STR_LEN 33
-#define SCSILUN_UNLIMITED ~0
 
 /*
  *  MESSAGE CODES
diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index 69313ba..e5a276c 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -553,6 +553,11 @@ struct Scsi_Host {
 	unsigned ordered_tag:1;
 
 	/*
+	 * unlimited luns
+	 */
+	unsigned unlimited_luns:1;
+
+	/*
 	 * Optional work queue to be utilized by the transport
 	 */
 	char work_q_name[KOBJ_NAME_LEN];
