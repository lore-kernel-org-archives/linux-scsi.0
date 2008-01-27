From: FUJITA Tomonori <tomof@acm.org>
Subject: [PATCH] ncr53c8xx: fix sense_buffer access bug
Date: Sun, 27 Jan 2008 12:41:51 +0900
Message-ID: <20080127124127U.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo10.iij4u.or.jp ([210.138.174.78]:34926 "EHLO mo10.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752894AbYA0DmA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Jan 2008 22:42:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

The commit de25deb18016f66dcdede165d07654559bb332bc changed
scsi_cmnd.sense_buffer from a static array to a dynamically allocated
buffer. We can't access to sense_buffer in '&cmd->sense_buffer' way.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
---
 drivers/scsi/ncr53c8xx.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/scsi/ncr53c8xx.c b/drivers/scsi/ncr53c8xx.c
index c02771a..c5ebf01 100644
--- a/drivers/scsi/ncr53c8xx.c
+++ b/drivers/scsi/ncr53c8xx.c
@@ -4967,7 +4967,7 @@ void ncr_complete (struct ncb *np, struct ccb *cp)
 			     sizeof(cp->sense_buf)));
 
 		if (DEBUG_FLAGS & (DEBUG_RESULT|DEBUG_TINY)) {
-			u_char * p = (u_char*) & cmd->sense_buffer;
+			u_char *p = cmd->sense_buffer;
 			int i;
 			PRINT_ADDR(cmd, "sense data:");
 			for (i=0; i<14; i++) printk (" %x", *p++);
-- 
1.5.3.4

