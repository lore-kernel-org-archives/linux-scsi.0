From: Matthew Wilcox <matthew@wil.cx>
Subject: [PATCH] Fix scsi_add_device() for async scanning
Date: Mon, 15 Jan 2007 18:07:09 -0700
Message-ID: <20070116010709.GA17240@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:41590 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932177AbXAPBHL (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Jan 2007 20:07:11 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I had thought that all drivers which didn't call scsi_scan_host()
called scsi_scan_target().  Some, such as sbp2, mptsas and libata-scsi,
call scsi_add_device() or __scsi_add_device().  We just need to wait
for the currently executing async scans to complete first.  This is the
same code that's in scsi_scan_target(), except that we have to return
an error instead of void when we're declining to scan at all.

Signed-off-by: Matthew Wilcox <matthew@wil.cx>

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 14e635a..1ad06e2 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -1436,6 +1436,12 @@ struct scsi_device *__scsi_add_device(struct Scsi_Host *shost, uint channel,
 	struct device *parent = &shost->shost_gendev;
 	struct scsi_target *starget;
 
+	if (strncmp(scsi_scan_type, "none", 4) == 0)
+		return ERR_PTR(-ENODEV);
+
+	if (!shost->async_scan)
+		scsi_complete_async_scans();
+
 	starget = scsi_alloc_target(parent, channel, id);
 	if (!starget)
 		return ERR_PTR(-ENOMEM);

