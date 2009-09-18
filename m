From: akpm@linux-foundation.org
Subject: [patch 14/15] zfcp: test kmalloc failure in scsi_get_vpd_page()
Date: Fri, 18 Sep 2009 12:58:23 -0700
Message-ID: <200909181958.n8IJwOL1004491@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50778 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932162AbZIRUCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Sep 2009 16:02:17 -0400
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
@@ -1057,6 +1057,8 @@ unsigned char *scsi_get_vpd_page(struct 
 
 	kfree(buf);
 	buf = kmalloc(len, GFP_KERNEL);
+	if (!buf)
+		return NULL;
 	result = scsi_vpd_inquiry(sdev, buf, page, len);
 	if (result)
 		goto fail;
_
