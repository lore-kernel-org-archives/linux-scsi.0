From: Lad Prabhakar <prabhakar.csengg@gmail.com>
Subject: [PATCH] scsi: ips: fix sparse warnings
Date: Thu,  5 Feb 2015 12:39:54 +0000
Message-ID: <1423139994-13215-1-git-send-email-prabhakar.csengg@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, Adaptec OEM Raid Solutions <aacraid@adaptec.com>
Cc: linux-kernel@vger.kernel.org, "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
List-Id: linux-scsi@vger.kernel.org

From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>

this patch fixes following sparse warnings:

ips.c:784:5: warning: symbol 'ips_eh_abort' was not declared. Should it be static?
ips.c:1277:1: warning: symbol 'ips_intr_copperhead' was not declared. Should it be static?
ips.c:1341:1: warning: symbol 'ips_intr_morpheus' was not declared. Should it be static?

Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
---
 Found this issue on linux-next (gcc  version 4.9.2,
 sparse version  0.4.5-rc1)and applies on top linux-next.

 drivers/scsi/ips.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
index 7542f11..f0d5cd9 100644
--- a/drivers/scsi/ips.c
+++ b/drivers/scsi/ips.c
@@ -781,7 +781,7 @@ ips_halt(struct notifier_block *nb, ulong event, void *buf)
 /*   Abort a command (using the new error code stuff)                       */
 /* Note: this routine is called under the io_request_lock                   */
 /****************************************************************************/
-int ips_eh_abort(struct scsi_cmnd *SC)
+static int ips_eh_abort(struct scsi_cmnd *SC)
 {
 	ips_ha_t *ha;
 	ips_copp_wait_item_t *item;
@@ -1273,7 +1273,7 @@ do_ipsintr(int irq, void *dev_id)
 /*   ASSUMES interrupts are disabled                                        */
 /*                                                                          */
 /****************************************************************************/
-int
+static int
 ips_intr_copperhead(ips_ha_t * ha)
 {
 	ips_stat_t *sp;
@@ -1337,7 +1337,7 @@ ips_intr_copperhead(ips_ha_t * ha)
 /*   ASSUMES interrupts are disabled                                        */
 /*                                                                          */
 /****************************************************************************/
-int
+static int
 ips_intr_morpheus(ips_ha_t * ha)
 {
 	ips_stat_t *sp;
-- 
1.9.1
