From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Mon, 16 Apr 2012 20:25:57 -0700
Message-ID: <1334633159.13899.4.camel@dwillia2-mobl>
References: <20120416224250.GA1983@bill-the-cat>
		 <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
		 <4F8CAC6F.6070907@ti.com>
	 <1334620782.23541.2.camel@ultramagnus.opencreations.com>
	 <4F8CCD0C.5060900@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga07.intel.com ([143.182.124.22]:18878 "EHLO
	azsmga101.ch.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753945Ab2DQD0E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Apr 2012 23:26:04 -0400
Received: by iage36 with SMTP id e36so10211302iag.25
        for <linux-scsi@vger.kernel.org>; Mon, 16 Apr 2012 20:26:02 -0700 (PDT)
In-Reply-To: <4F8CCD0C.5060900@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Rini <trini@ti.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On Mon, 2012-04-16 at 18:53 -0700, Tom Rini wrote:
> > Thanks, yes it looks like a new regression.  Can you tell me if the
> > following fixes it?
> 
> No joy, oopses.  http://alnk.org/43youngkirby for the dmesg and oops.
> 

Agh, sorry, I rushed that one.  The phy array is initialized later, here
is another run at it:

----
mvsas: fix local port name regression

From: Dan Williams <dan.j.williams@intel.com>

Commit a692b0e "[SCSI] libsas: fix sas port naming" added a dependency
on lldds filling out the id field of registered phys.  Add this for
mvsas.

Note we do this in the lldd rather than the core to allow it the control
of mappping physical phy id to the libsas phy index.

Reported-by: Tom Rini <trini@ti.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/mvsas/mv_init.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cc59dff..0c9af72 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -497,10 +497,12 @@ static void  __devinit mvs_post_sas_ha_init(struct Scsi_Host *shost,
 	for (j = 0; j < nr_core; j++) {
 		mvi = ((struct mvs_prv_info *)sha->lldd_ha)->mvi[j];
 		for (i = 0; i < chip_info->n_phy; i++) {
-			sha->sas_phy[j * chip_info->n_phy  + i] =
-				&mvi->phy[i].sas_phy;
-			sha->sas_port[j * chip_info->n_phy + i] =
-				&mvi->port[i].sas_port;
+			struct asd_sas_phy *phy = &mvi->phy[i].sas_phy;
+			int id = j * chip_info->n_phy  + i;
+
+			phy->id = id;
+			sha->sas_phy[id] = phy;
+			sha->sas_port[id] = &mvi->port[i].sas_port;
 		}
 	}
 




