From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: mvsas panics and dies when attached to a port extender on newer
 kernels
Date: Wed, 15 Apr 2015 22:16:01 -0700
Message-ID: <1429161361.2608.4.camel@HansenPartnership.com>
References: <CAH_2Ghf565hKovkkccP_z6SO8v=7Ji=wdvL8YPnZNZ9WUUfGWg@mail.gmail.com>
	 <1429046165.2209.54.camel@HansenPartnership.com>
	 <CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:54222 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752664AbbDPFQD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Apr 2015 01:16:03 -0400
In-Reply-To: <CAH_2GhcsaDoxuxBwTT7cUsfp+5e_KjxtkJ4tFE1N05U=FCkJnA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adam Talbot <ajtalbot1@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Tue, 2015-04-14 at 14:41 -0700, Adam Talbot wrote:
> Removing the sas expander and attaching the SATA drives directly works
> just fine. I had to limp along with the drives direct attached for a
> while, while debugging.

Well, that narrows it down.  It looks like there's a longstanding bug in
mvs_task_prep_ata() where the physical PHY field is populated by taking
an index through the HBA phy table.  This field is ignored for STP but
the phy table is too small and it uses the expander phy number to index
it (hence the GPF as we fall off the end of the phy table trying to
dereference sas_phy->id).

This should fix the problem.

James

---

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 2d5ab6d..454536c 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -441,14 +441,11 @@ static u32 mvs_get_ncq_tag(struct sas_task *task, u32 *tag)
 static int mvs_task_prep_ata(struct mvs_info *mvi,
 			     struct mvs_task_exec_info *tei)
 {
-	struct sas_ha_struct *sha = mvi->sas;
 	struct sas_task *task = tei->task;
 	struct domain_device *dev = task->dev;
 	struct mvs_device *mvi_dev = dev->lldd_dev;
 	struct mvs_cmd_hdr *hdr = tei->hdr;
 	struct asd_sas_port *sas_port = dev->port;
-	struct sas_phy *sphy = dev->phy;
-	struct asd_sas_phy *sas_phy = sha->sas_phy[sphy->number];
 	struct mvs_slot_info *slot;
 	void *buf_prd;
 	u32 tag = tei->tag, hdr_tag;
@@ -468,7 +465,7 @@ static int mvs_task_prep_ata(struct mvs_info *mvi,
 	slot->tx = mvi->tx_prod;
 	del_q = TXQ_MODE_I | tag |
 		(TXQ_CMD_STP << TXQ_CMD_SHIFT) |
-		(MVS_PHY_ID << TXQ_PHY_SHIFT) |
+		((sas_port->phy_mask & TXQ_PHY_MASK) << TXQ_PHY_SHIFT) |
 		(mvi_dev->taskfileset << TXQ_SRS_SHIFT);
 	mvi->tx[mvi->tx_prod] = cpu_to_le32(del_q);
 




