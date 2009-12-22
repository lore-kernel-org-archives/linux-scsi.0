From: akpm@linux-foundation.org
Subject: [patch 10/19] zfcp: test kmalloc failure in scsi_get_vpd_page()
Date: Mon, 21 Dec 2009 16:27:47 -0800
Message-ID: <200912220027.nBM0Rlpo005388@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44374 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751262AbZLVAeb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Dec 2009 19:34:31 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com, bharrosh@panasas.com, michaelc@cs.wisc.edu, yjwei@cn.fujitsu.com

From: Roel Kluin <roel.kluin@gmail.com>

kmalloc() may fail, so test whether it succeeded.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Wei Yongjun <yjwei@cn.fujitsu.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>
Cc: Boaz Harrosh <bharrosh@panasas.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/scsi.c~zfcp-test-kmalloc-failure-in-scsi_get_vpd_page drivers/scsi/scsi.c
--- a/drivers/scsi/scsi.c~zfcp-test-kmalloc-failure-in-scsi_get_vpd_page
+++ a/drivers/scsi/scsi.c
@@ -1066,6 +1066,8 @@ unsigned char *scsi_get_vpd_page(struct 
 
 	kfree(buf);
 	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return NULL;
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;
_
