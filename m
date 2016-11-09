From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce UFSHCI_QUIRK_SKIP_INTR_AGGR quirk
Date: Wed, 09 Nov 2016 14:43:31 +0900
Message-ID: <001101d23a4c$34165510$9c42ff30$@samsung.com>
References: <002401d23996$1986d4b0$4c947e10$@samsung.com>
 <CGME20161108195647epcas2p4b49e05b9bd4512a8e6f90280a5f7f40a@epcas2p4.samsung.com>
 <d8123bcfe400777db2b5745a2d2b3d8d@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:34056 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750774AbcKIFne (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 00:43:34 -0500
In-reply-to: <d8123bcfe400777db2b5745a2d2b3d8d@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

> > If UFS driver resets interrupt aggregation timer and counter
> > when there is a pending doorbell, an interrupt of IO completion
> > of a corresponding task may be missed.
> > That would cause a command timeout.
> >
> > If UFS driver resets interrupt aggregation timer and counter
> > when there is a pending doorbell, a competion interrupt
> > of a corresponing task may be issued.
> > That would casue a command timeout.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 4 +++-
> >  drivers/scsi/ufs/ufshcd.h | 1 +
> >  2 files changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index c904854..65bbf59 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -3730,7 +3730,9 @@ static void ufshcd_transfer_req_compl(struct
> > ufs_hba *hba)
> >  	 * false interrupt if device completes another request after
> > resetting
> >  	 * aggregation and before reading the DB.
> >  	 */
> > -	if (ufshcd_is_intr_aggr_allowed(hba))
> > +	if ((ufshcd_is_intr_aggr_allowed(hba))
> > +		&& !(hba->quirks & UFSHCI_QUIRK_SKIP_INTR_AGGR))
> 
> Why do we need this new quirk? If controller has the issue with
> interrupt aggregation, you can remove this UFSHCD_CAP_INTR_AGGR to
> disable the aggregation altogether.

This fragment doesn't mean disabling interrupt aggregation.
It just means that interrupt aggregation logic would not be reset in ISR.

But I think that the name of the quirk doesn't represent the function of it
expectedly.
I'll change the name with another one, such as
UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR.


> 
> > +		ufshcd_reset_intr_aggr(hba);
> >  		ufshcd_reset_intr_aggr(hba);
> >
> >  	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 6a96f24..6a9c6e9 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -497,6 +497,7 @@ struct ufs_hba {
> >  	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
> >  	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
> >  	#define UFSHCD_QUIRK_USE_OF_HCE				UFS_BIT(9)
> > +	#define UFSHCI_QUIRK_SKIP_INTR_AGGR			UFS_BIT(10)
> >
> >
> >  	unsigned int quirks;	/* Deviations from standard UFSHCI spec.
> */
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
> a Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


