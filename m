From: Julia Lawall <julia@diku.dk>
Subject: Re: [PATCH 3/5] drivers/scsi : Correct the size argument to kmalloc
Date: Tue, 29 Dec 2009 21:13:26 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0912292113110.4001@ask.diku.dk>
References: <Pine.LNX.4.64.0912292015420.4001@ask.diku.dk>
 <200912292102.43373.eike-kernel@sf-tec.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mgw1.diku.dk ([130.225.96.91]:53334 "EHLO mgw1.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751554AbZL2UN2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Dec 2009 15:13:28 -0500
In-Reply-To: <200912292102.43373.eike-kernel@sf-tec.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rolf Eike Beer <eike-kernel@sf-tec.de>
Cc: James.Bottomley@suse.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org

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

---
 drivers/scsi/aic94xx/aic94xx_init.c |    4 ++--
 drivers/scsi/ch.c                   |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

diff -u -p a/drivers/scsi/aic94xx/aic94xx_init.c b/drivers/scsi/aic94xx/aic94xx_init.c
--- a/drivers/scsi/aic94xx/aic94xx_init.c
+++ b/drivers/scsi/aic94xx/aic94xx_init.c
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
diff -u -p a/drivers/scsi/ch.c b/drivers/scsi/ch.c
--- a/drivers/scsi/ch.c
+++ b/drivers/scsi/ch.c
@@ -351,7 +351,7 @@ ch_readconfig(scsi_changer *ch)
 	}
 
 	/* look up the devices of the data transfer elements */
-	ch->dt = kmalloc(ch->counts[CHET_DT]*sizeof(struct scsi_device),
+	ch->dt = kcalloc(ch->counts[CHET_DT], sizeof(*ch->dt),
 			 GFP_KERNEL);
 
 	if (!ch->dt) {
