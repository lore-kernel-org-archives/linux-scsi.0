From: akpm@linux-foundation.org
Subject: [patch 31/33] scsi_kmap_atomic_sg(): check that local irqs are disabled
Date: Mon, 05 Feb 2007 16:39:03 -0800
Message-ID: <200702060040.l160e66R005054@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.24]:41807 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965362AbXBFAkK (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 5 Feb 2007 19:40:10 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.orgakpm@linux-foundation.org

From: Andrew Morton <akpm@osdl.org>

The KM_BIO_SRC_IRQ kmap slot must be taken with local irqs disabled.  Add a
check into scsi for this.

Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/scsi_lib.c |    2 ++
 1 file changed, 2 insertions(+)

diff -puN drivers/scsi/scsi_lib.c~scsi_kmap_atomic_sg-check-that-local-irqs-are-disabled drivers/scsi/scsi_lib.c
--- a/drivers/scsi/scsi_lib.c~scsi_kmap_atomic_sg-check-that-local-irqs-are-disabled
+++ a/drivers/scsi/scsi_lib.c
@@ -2250,6 +2250,8 @@ void *scsi_kmap_atomic_sg(struct scatter
 	size_t sg_len = 0, len_complete = 0;
 	struct page *page;
 
+	WARN_ON(!irqs_disabled());
+
 	for (i = 0; i < sg_count; i++) {
 		len_complete = sg_len; /* Complete sg-entries */
 		sg_len += sg[i].length;
_
