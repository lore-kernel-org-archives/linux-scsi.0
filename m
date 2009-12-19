From: Julia Lawall <julia@diku.dk>
Subject: [PATCH 4/7] drivers/scsi/mvsas: Use kzalloc for allocating only one
 thing
Date: Sat, 19 Dec 2009 08:17:10 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912190816540.30546@ask.diku.dk>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw2.diku.dk ([130.225.96.92]:49317 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751473AbZLSHRM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Dec 2009 02:17:12 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

From: Julia Lawall <julia@diku.dk>

Use kzalloc rather than kcalloc(1,...)

The semantic patch that makes this change is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
@@

- kcalloc(1,
+ kzalloc(
          ...)
// </smpl>

Signed-off-by: Julia Lawall <julia@diku.dk>

---
 drivers/scsi/mvsas/mv_init.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
--- a/drivers/scsi/mvsas/mv_init.c 2009-12-12 00:23:19.000000000 +0100
+++ b/drivers/scsi/mvsas/mv_init.c 2009-12-19 07:52:38.000000000 +0100
@@ -541,7 +541,7 @@ static int __devinit mvs_pci_init(struct
 
 	chip = &mvs_chips[ent->driver_data];
 	SHOST_TO_SAS_HA(shost) =
-		kcalloc(1, sizeof(struct sas_ha_struct), GFP_KERNEL);
+		kzalloc(sizeof(struct sas_ha_struct), GFP_KERNEL);
 	if (!SHOST_TO_SAS_HA(shost)) {
 		kfree(shost);
 		rc = -ENOMEM;
