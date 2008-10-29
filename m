From: akpm@linux-foundation.org
Subject: [patch 15/17] U14-34F: fix scsi_dma_map failure case
Date: Wed, 29 Oct 2008 14:24:47 -0700
Message-ID: <200810292124.m9TLOlih021304@imap1.linux-foundation.org>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:60007 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755298AbYJ2VYu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Oct 2008 17:24:50 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, roel.kluin@gmail.com

From: roel kluin <roel.kluin@gmail.com>

When unsigned, scsi_dma_map may return -ENOMEM without triggering BUG_ON()

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/u14-34f.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff -puN drivers/scsi/u14-34f.c~u14-34f-fix-scsi_dma_map-failure-case drivers/scsi/u14-34f.c
--- a/drivers/scsi/u14-34f.c~u14-34f-fix-scsi_dma_map-failure-case
+++ a/drivers/scsi/u14-34f.c
@@ -1111,7 +1111,8 @@ static int u14_34f_detect(struct scsi_ho
 
 static void map_dma(unsigned int i, unsigned int j) {
    unsigned int data_len = 0;
-   unsigned int k, count, pci_dir;
+   unsigned int k, pci_dir;
+   int count;
    struct scatterlist *sg;
    struct mscp *cpp;
    struct scsi_cmnd *SCpnt;
_
