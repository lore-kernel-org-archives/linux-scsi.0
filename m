From: Alan <gnomes@lxorguk.ukuu.org.uk>
Subject: [PATCH] lpfc: fix missing zero termination in debugfs
Date: Mon, 15 Feb 2016 19:11:56 +0000
Message-ID: <20160215191142.19028.9220.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:44938 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753025AbcBOTMF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Feb 2016 14:12:05 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jthumshirn@suse.de

If you feed 32 bytes in then the kstrtoull() doesn't receive a terminated
string so will run off the end.

Signed-off-by: Alan Cox <alan@linux.intel.com>
---
 drivers/scsi/lpfc/lpfc_debugfs.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
index 25aa9b9..a63542b 100644
--- a/drivers/scsi/lpfc/lpfc_debugfs.c
+++ b/drivers/scsi/lpfc/lpfc_debugfs.c
@@ -1054,11 +1054,11 @@ lpfc_debugfs_dif_err_write(struct file *file, const char __user *buf,
 {
 	struct dentry *dent = file->f_path.dentry;
 	struct lpfc_hba *phba = file->private_data;
-	char dstbuf[32];
+	char dstbuf[33];
 	uint64_t tmp = 0;
 	int size;
 
-	memset(dstbuf, 0, 32);
+	memset(dstbuf, 0, 33);
 	size = (nbytes < 32) ? nbytes : 32;
 	if (copy_from_user(dstbuf, buf, size))
 		return 0;

