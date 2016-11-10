From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Thu, 10 Nov 2016 10:24:54 +0900
Message-ID: <000001d23af1$3e0a56c0$ba1f0440$@samsung.com>
References: <002201d23994$d0aae750$7200b5f0$@samsung.com>
 <CGME20161108194301epcas5p105979259c1ec1e01af1ba28a32029c69@epcas5p1.samsung.com>
 <7334902e3d23dcf5be238d172f9d6fc2@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout1.samsung.com ([203.254.224.24]:41996 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755102AbcKJBY6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2016 20:24:58 -0500
In-reply-to: <7334902e3d23dcf5be238d172f9d6fc2@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

> > Some UFS host controllers may clear a transfer request slot by setting
> > an associated bit in UTLRCLR/UTMLRCLR to 1, not 0.
> 
> s/UTLRCLR/UTRLCLR
> s/UTMLRCLR/UTMRLCLR
> 

Okay

> 
> > That's opposite to what UFS spec decribes.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 32 ++++++++++++++++++++++++++++----
> > drivers/scsi/ufs/ufshcd.h |  1 +
> >  2 files changed, 29 insertions(+), 4 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 549e3e8..24d6ea7 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -392,7 +392,31 @@ static inline void ufshcd_put_tm_slot(struct
> > ufs_hba *hba, int slot)
> >   */
> >  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)  {
> > -	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
> > +	u32 clear;
> > +
> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
> > +		clear = (1 << pos);
> > +	else
> > +		clear = ~(1 << pos);
> > +
> > +	ufshcd_writel(hba, clear, REG_UTP_TRANSFER_REQ_LIST_CLEAR); }
> > +
> > +/**
> > + * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
> > + * @hba: per adapter instance
> > + * @pos: position of the bit to be cleared  */ static inline void
> > +ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos) {
> > +	u32 clear;
> > +
> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
> > +		clear = (1 << pos);
> > +	else
> > +		clear = ~(1 << pos);
> > +
> > +	ufshcd_writel(hba, clear, REG_UTP_TASK_REQ_LIST_CLEAR);
> >  }
> >
> >  /**
> > @@ -1147,7 +1171,7 @@ ufshcd_send_uic_cmd(struct ufs_hba *hba, struct
> > uic_command *uic_cmd)
> >   *
> >   * Returns 0 in case of success, non-zero value in case of failure
> >   */
> > -static int ufshcd_map_sg(struct ufshcd_lrb *lrbp)
> > +static int ufshcd_map_sg(struct ufs_hba *hba, struct ufshcd_lrb
> > +*lrbp)
> 
> unrelated change. Please remove it.
> 

Okay

> >  {
> >  	struct ufshcd_sg_entry *prd_table;
> >  	struct scatterlist *sg;
> > @@ -1529,7 +1553,7 @@ static int ufshcd_queuecommand(struct Scsi_Host
> > *host, struct scsi_cmnd *cmd)
> >
> >  	ufshcd_comp_scsi_upiu(hba, lrbp);
> >
> > -	err = ufshcd_map_sg(lrbp);
> > +	err = ufshcd_map_sg(hba, lrbp);
> 
> unrelated change.  Please remove it.

Okay

> 
> 
> >  	if (err) {
> >  		lrbp->cmd = NULL;
> >  		clear_bit_unlock(tag, &hba->lrb_in_use); @@ -4329,7 +4353,7
> @@
> > static int ufshcd_clear_tm_cmd(struct ufs_hba *hba, int tag)
> >  		goto out;
> >
> >  	spin_lock_irqsave(hba->host->host_lock, flags);
> > -	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
> > +	ufshcd_utmrl_clear(hba, tag);
> >  	spin_unlock_irqrestore(hba->host->host_lock, flags);
> >
> >  	/* poll for max. 1 sec to clear door bell register by h/w */ diff
> > --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h index
> > 565f005..c4abd76 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -495,6 +495,7 @@ struct ufs_hba {
> >
> >  	#define UFSHCD_QUIRK_GET_VS_RESULT			UFS_BIT(6)
> >  	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
> > +	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
> >
> >
> >  	unsigned int quirks;	/* Deviations from standard UFSHCI spec.
> */
> 
> --
> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a
> Linux Foundation Collaborative Project
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org More majordomo info at
> http://vger.kernel.org/majordomo-info.html


