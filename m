From: Mathias Krause <minipli@googlemail.com>
Subject: [PATCH RESEND] aic79xx: fix misuse of static variables
Date: Thu,  1 May 2014 11:48:25 +0200
Message-ID: <1398937706-16337-1-git-send-email-minipli@googlemail.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ee0-f41.google.com ([74.125.83.41]:32884 "EHLO
	mail-ee0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754002AbaEAJtJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 May 2014 05:49:09 -0400
Received: by mail-ee0-f41.google.com with SMTP id t10so2151302eei.28
        for <linux-scsi@vger.kernel.org>; Thu, 01 May 2014 02:49:08 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: linux-scsi@vger.kernel.org, Mathias Krause <minipli@googlemail.com>, PaX Team <pageexec@freemail.hu>

The format strings for various printk()s make use of a temporary
variable that is declared 'static'. This is probably not intended,
so fix those.

Found in the PaX patch, written by the PaX Team.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Acked-by: Hannes Reinecke <hare@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: PaX Team <pageexec@freemail.hu>
---

Resend as this patch hasn't been picked up yet, nor was it declined.

James, I cannot find any hint on the interwebs to the compiler bug you
mentioned in [1] -- neither in [2] (the patch that introduced that code in
2002 for v2.5.53) nor in [3] (which confirms the code in question looked the
same for v2.4.22). Therefore I see no reason to not apply this patch. Even
more so, as Hannes, the maintainer of this driver, already ACK'ed this
patch.

Thanks,
Mathias

[1] http://www.spinics.net/lists/linux-scsi/msg73532.html
[2] https://git.kernel.org/cgit/linux/kernel/git/tglx/history.git/commit/?id=f58eb66c0b0acc97f3787decd9a30694be867dbf
[3] http://lxr.linux.no/linux-old+v2.4.22/drivers/scsi/aic7xxx/aic79xx_pci.c

Remark: Compile tested only! I've no such hardware.

 drivers/scsi/aic7xxx/aic79xx_pci.c |   18 +++++-------------
 1 file changed, 5 insertions(+), 13 deletions(-)

diff --git a/drivers/scsi/aic7xxx/aic79xx_pci.c b/drivers/scsi/aic7xxx/aic79xx_pci.c
index 14b5f8d0e7..cc9bd26f5d 100644
--- a/drivers/scsi/aic7xxx/aic79xx_pci.c
+++ b/drivers/scsi/aic7xxx/aic79xx_pci.c
@@ -827,7 +827,7 @@ ahd_pci_intr(struct ahd_softc *ahd)
 		for (bit = 0; bit < 8; bit++) {
 
 			if ((pci_status[i] & (0x1 << bit)) != 0) {
-				static const char *s;
+				const char *s;
 
 				s = pci_status_strings[bit];
 				if (i == 7/*TARG*/ && bit == 3)
@@ -887,23 +887,15 @@ ahd_pci_split_intr(struct ahd_softc *ahd, u_int intstat)
 
 		for (bit = 0; bit < 8; bit++) {
 
-			if ((split_status[i] & (0x1 << bit)) != 0) {
-				static const char *s;
-
-				s = split_status_strings[bit];
-				printk(s, ahd_name(ahd),
+			if ((split_status[i] & (0x1 << bit)) != 0)
+				printk(split_status_strings[bit], ahd_name(ahd),
 				       split_status_source[i]);
-			}
 
 			if (i > 1)
 				continue;
 
-			if ((sg_split_status[i] & (0x1 << bit)) != 0) {
-				static const char *s;
-
-				s = split_status_strings[bit];
-				printk(s, ahd_name(ahd), "SG");
-			}
+			if ((sg_split_status[i] & (0x1 << bit)) != 0)
+				printk(split_status_strings[bit], ahd_name(ahd), "SG");
 		}
 	}
 	/*
-- 
1.7.10.4

