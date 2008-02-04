From: Boaz Harrosh <bharrosh@panasas.com>
Subject: [PATCH 21/24][RFC] scsi_tgt: use of sense accessors
Date: Mon,  4 Feb 2008 19:53:15 +0200
Message-ID: <1202147595-5400-1-git-send-email-bharrosh@panasas.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bzq-219-195-70.pop.bezeqint.net ([62.219.195.70]:57530 "EHLO
	bh-buildlin2.bhalevy.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751576AbYBDR6O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2008 12:58:14 -0500
In-Reply-To: 47A72A7F.1050301@panasas.com
References: 47A72A7F.1050301@panasas.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Christoph Hellwig <hch@infradead.org>, Jens Axboe <jens.axboe@oracle.com>J
Cc: Andrew Morton <akpm@linux-foundation.org>

  FIXME: I need help with this driver (Pete?)
    I used scsi_sense() in a none const way. But since
    scsi_tgt is the ULD here, it can just access it's own sense
    buffer directly. I did not use scsi_eh_cpy_sense() because
    I did not want the extra copy. Pete will want to use a 260
    bytes buffer here.

Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>
Need-help-from: Pete Wyckoff <pw@osc.edu>
---
 drivers/scsi/scsi_tgt_lib.c |    3 ++-
 1 files changed, 2 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/scsi_tgt_lib.c b/drivers/scsi/scsi_tgt_lib.c
index e01a985..d42f318 100644
--- a/drivers/scsi/scsi_tgt_lib.c
+++ b/drivers/scsi/scsi_tgt_lib.c
@@ -29,6 +29,7 @@
 #include <scsi/scsi_host.h>
 #include <scsi/scsi_transport.h>
 #include <scsi/scsi_tgt.h>
+#include <scsi/scsi_eh.h>
 
 #include "scsi_tgt_priv.h"
 
@@ -397,7 +398,7 @@ static int scsi_tgt_copy_sense(struct scsi_cmnd *cmd, unsigned long uaddr,
 {
 	char __user *p = (char __user *) uaddr;
 
-	if (copy_from_user(cmd->sense_buffer, p,
+	if (copy_from_user(scsi_sense(cmd), p,
 			   min_t(unsigned, SCSI_SENSE_BUFFERSIZE, len))) {
 		printk(KERN_ERR "Could not copy the sense buffer\n");
 		return -EIO;
-- 
1.5.3.3

