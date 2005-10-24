From: Jeff Garzik <jgarzik@pobox.com>
Subject: [PATCH RFC 15/n] HCIL drivers update
Date: Mon, 24 Oct 2005 14:00:38 -0400
Message-ID: <20051024180038.GA29082@havoc.gtf.org>
References: <20051023024104.GA20128@havoc.gtf.org> <20051023195128.GA12102@havoc.gtf.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from havoc.gtf.org ([69.61.125.42]:4234 "EHLO havoc.gtf.org")
	by vger.kernel.org with ESMTP id S1751206AbVJXSAj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 24 Oct 2005 14:00:39 -0400
Received: from havoc.gtf.org (havoc.gtf.org [127.0.0.1])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by havoc.gtf.org (Postfix) with ESMTP id A01671C0A7A2
	for <linux-scsi@vger.kernel.org>; Mon, 24 Oct 2005 14:00:38 -0400 (EDT)
Received: (from garzik@localhost)
	by havoc.gtf.org (8.13.1/8.13.1/Submit) id j9OI0c7t029150
	for linux-scsi@vger.kernel.org; Mon, 24 Oct 2005 14:00:38 -0400
Content-Disposition: inline
In-Reply-To: <20051023195128.GA12102@havoc.gtf.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


fix cases where 0 is passed as lun0, when we really want scsi_lun*

 drivers/scsi/scsi_scan.c |   10 +++++++---
 1 files changed, 7 insertions(+), 3 deletions(-)

1a13759a275199b7b6bb58dbddfee1e843b1ea2a
diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index abf4e42..1ccc4b1 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1074,6 +1074,7 @@ static int scsi_report_lun_scan(struct s
 	unsigned int retries;
 	int result;
 	struct scsi_lun *lunp, *lun_data;
+	struct scsi_lun lun0;
 	u8 *data;
 	struct scsi_sense_hdr sshdr;
 	struct scsi_device *sdev;
@@ -1092,8 +1093,9 @@ static int scsi_report_lun_scan(struct s
 	if (bflags & BLIST_NOLUN)
 		return 0;
 
-	if (!(sdev = scsi_device_lookup_by_target(starget, 0))) {
-		sdev = scsi_alloc_sdev(starget, 0, NULL);
+	int_to_scsilun(0, &lun0);
+	if (!(sdev = scsi_device_lookup_by_target(starget, &lun0))) {
+		sdev = scsi_alloc_sdev(starget, &lun0, NULL);
 		if (!sdev)
 			return 0;
 		if (scsi_device_get(sdev))
@@ -1499,6 +1501,7 @@ struct scsi_device *scsi_get_host_dev(st
 {
 	struct scsi_device *sdev = NULL;
 	struct scsi_target *starget;
+	struct scsi_lun lun0;
 
 	down(&shost->scan_mutex);
 	if (!scsi_host_scan_allowed(shost))
@@ -1507,7 +1510,8 @@ struct scsi_device *scsi_get_host_dev(st
 	if (!starget)
 		goto out;
 
-	sdev = scsi_alloc_sdev(starget, 0, NULL);
+	int_to_scsilun(0, &lun0);
+	sdev = scsi_alloc_sdev(starget, &lun0, NULL);
 	if (sdev) {
 		sdev->sdev_gendev.parent = get_device(&starget->dev);
 		sdev->borken = 0;
