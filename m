From: akpm@osdl.org
Subject: [patch 12/15] Overrun in drivers/scsi/sim710.c
Date: Mon, 10 Apr 2006 23:27:03 -0700
Message-ID: <200604110727.k3B7Rjrt015343@shell0.pdx.osdl.net>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:15240 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S932234AbWDKH2A (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 03:28:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@steeleye.com
Cc: linux-scsi@vger.kernel.org, akpm@osdl.org, snakebyte@gmx.de


From: Eric Sesterhenn <snakebyte@gmx.de>

This fixes coverity bug id #480.  Since id_array is declared as
id_array[MAX_SLOTS], the check for i>MAX_SLOTS is obviously false.

Signed-off-by: Eric Sesterhenn <snakebyte@gmx.de>
Cc: James Bottomley <James.Bottomley@steeleye.com>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 drivers/scsi/sim710.c |    2 +-
 1 files changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/scsi/sim710.c~overrun-in-drivers-scsi-sim710c drivers/scsi/sim710.c
--- devel/drivers/scsi/sim710.c~overrun-in-drivers-scsi-sim710c	2006-04-10 00:09:58.000000000 -0700
+++ devel-akpm/drivers/scsi/sim710.c	2006-04-10 00:09:58.000000000 -0700
@@ -75,7 +75,7 @@ param_setup(char *str)
 		else if(!strncmp(pos, "id:", 3)) {
 			if(slot == -1) {
 				printk(KERN_WARNING "sim710: Must specify slot for id parameter\n");
-			} else if(slot > MAX_SLOTS) {
+			} else if(slot >= MAX_SLOTS) {
 				printk(KERN_WARNING "sim710: Illegal slot %d for id %d\n", slot, val);
 			} else {
 				id_array[slot] = val;
_
