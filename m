From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Commit a692b0e broke my mvsas card
Date: Mon, 16 Apr 2012 16:59:40 -0700
Message-ID: <1334620782.23541.2.camel@ultramagnus.opencreations.com>
References: <20120416224250.GA1983@bill-the-cat>
	 <CABE8wwvbSsc02U_m+20-DQgsZ2gQCi_A6susCrmfyx_scQkccw@mail.gmail.com>
	 <4F8CAC6F.6070907@ti.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48833 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753255Ab2DPX7o (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Apr 2012 19:59:44 -0400
Received: by iage36 with SMTP id e36so9966835iag.25
        for <linux-scsi@vger.kernel.org>; Mon, 16 Apr 2012 16:59:43 -0700 (PDT)
In-Reply-To: <4F8CAC6F.6070907@ti.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tom Rini <trini@ti.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <JBottomley@parallels.com>, Xiangliang Yu <yuxiangl@marvell.com>

On Mon, 2012-04-16 at 16:34 -0700, Tom Rini wrote:
> On 04/16/2012 04:12 PM, Dan Williams wrote:
> > On Mon, Apr 16, 2012 at 3:42 PM, Tom Rini<trini@ti.com>  wrote:
> >> Hey all,
> >>
> >> I have an OCZ RevoDrive3 X2 (which the mvsas driver works for).  I've
> >> been running mainline since support for my card was added and I just
> >> went to test 3.3-rc4.  Unpatched I get some sort of recursive fault that
> >
> > I assume this was supposed to be 3.4-rc3?
> 
> Yes, sorry.
> 
> >> locks up the system.  When I revert a692b0e (which I found with a git
> >> bisect) things are working as expected again.  What info do you need
> >> from me to work out the right solution here?  Thanks!
> >
> > Can you post the kernel log of the fault (starting at the first sign
> > of trouble)?
> >
> > I suspect it's one of the known regression fixes [1], but would like
> > to double check.
> 
> I merged those changes in and the problem is now non-fatal but now I'm 
> missing 2 of the 4 drives on the card.  Portion of dmesg is at 
> http://pastebin.com/36K7xwHK and I can email it if needed.
> 

Thanks, yes it looks like a new regression.  Can you tell me if the
following fixes it?

---

mvsas: fix local port name regression

Commit a692b0e "[SCSI] libsas: fix sas port naming" added a dependency
on lldds filling out the id field of registered phys.  Add this for
mvsas.

Note we do this in the lldd rather than the core to allow it the control
of mapping physical phy id to the libsas phy index.

Reported-by: Tom Rini <trini@ti.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/scsi/mvsas/mv_init.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mvsas/mv_init.c b/drivers/scsi/mvsas/mv_init.c
index cc59dff..556fa6c 100644
--- a/drivers/scsi/mvsas/mv_init.c
+++ b/drivers/scsi/mvsas/mv_init.c
@@ -447,7 +447,7 @@ static int pci_go_64(struct pci_dev *pdev)
 static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 				const struct mvs_chip_info *chip_info)
 {
-	int phy_nr, port_nr; unsigned short core_nr;
+	int i, phy_nr, port_nr; unsigned short core_nr;
 	struct asd_sas_phy **arr_phy;
 	struct asd_sas_port **arr_port;
 	struct sas_ha_struct *sha = SHOST_TO_SAS_HA(shost);
@@ -462,6 +462,9 @@ static int __devinit mvs_prep_sas_ha_init(struct Scsi_Host *shost,
 	if (!arr_phy || !arr_port)
 		goto exit_free;
 
+	for (i = 0; i < phy_nr; i++)
+		arr_phy[i]->id = i;
+
 	sha->sas_phy = arr_phy;
 	sha->sas_port = arr_port;
 	sha->core.shost = shost;


