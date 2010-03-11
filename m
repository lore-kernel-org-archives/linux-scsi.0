From: akpm@linux-foundation.org
Subject: [patch 17/26] drivers/scsi/aic94xx/aic94xx_init.c: correct the size argument to kmalloc
Date: Thu, 11 Mar 2010 14:09:49 -0800
Message-ID: <201003112209.o2BM9nEW013664@imap1.linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59498 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758362Ab0CKWKE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Mar 2010 17:10:04 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Bottomley@HansenPartnership.com
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, julia@diku.dk, eike-kernel@sf-tec.de, joe@perches.com

From: Julia Lawall <julia@diku.dk>

In each case, the destination of the allocation has type struct **, so the
elements of the array should have pointer type, not structure type.

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@disable sizeof_type_expr@
type T;
T **x;
@@

  x =
  <+...sizeof(
- T
+ *x
  )...+>
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>
Cc: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: Joe Perches <joe@perches.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 drivers/scsi/ch.c                   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -puN drivers/scsi/aic94xx/aic94xx_init.c~drivers-scsi-correct-the-size-argument-to-kmalloc drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c~drivers-scsi-correct-the-size-argument-to-kmalloc
+++ a/drivers/scsi/aic94xx/aic94xx_init.c
@@ -687,9 +687,9 @@ static int asd_register_sas_ha(struct as
 {
 	int i;
 	struct asd_sas_phy   **sas_phys =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_phy), GFP_KERNEL);
+		kcalloc(ASD_MAX_PHYS, sizeof(*sas_phys), GFP_KERNEL);
 	struct asd_sas_port  **sas_ports =
-		kmalloc(ASD_MAX_PHYS * sizeof(struct asd_sas_port), GFP_KERNEL);
+		kcalloc(ASD_MAX_PHYS, sizeof(*sas_ports), GFP_KERNEL);
 
 	if (!sas_phys || !sas_ports) {
 		kfree(sas_phys);
diff -puN drivers/scsi/ch.c~drivers-scsi-correct-the-size-argument-to-kmalloc drivers/scsi/ch.c
--- a/drivers/scsi/ch.c~drivers-scsi-correct-the-size-argument-to-kmalloc
+++ a/drivers/scsi/ch.c
@@ -351,7 +351,7 @@ ch_readconfig(scsi_changer *ch)
 	}
 
 	/* look up the devices of the data transfer elements */
-	ch->dt = kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_device),
+	ch->dt = kcalloc(ch->counts[CHET_DT], sizeof(*ch->dt),
 			 GFP_KERNEL);
 
 	if (!ch->dt) {
_
