From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v2] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Wed, 16 Nov 2016 10:51:53 +0900
Message-ID: <006801d23fac$014aa680$03dff380$@samsung.com>
References: <00e901d23f2e$4bbf7610$e33e6230$@samsung.com>
 <CGME20161115182843epcas3p35b23ced6b74b52af548810ae70fb8417@epcas3p3.samsung.com>
 <23f918125db0071cc0514c85385c7734@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:47269 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751981AbcKPBwD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2016 20:52:03 -0500
In-reply-to: <23f918125db0071cc0514c85385c7734@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, vinholikatti@gmail.com, cpgs@samsung.com, 'HeonGwang Chu' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

>> > Some UFS host controllers may clear a transfer request slot by setting
>> > an associated bit in UTRLCLR/UTMRLCLR to 1, not 0.
>> > That's opposite to what UFS spec describes.
>> >
>> > v2: modify the commit message, remove unrelated changes
>> 
>> As Martin mentioned in other email, please separate this version history
>> from commit text with line having "----" before the start of version
>> history.

I didn't understand clearly what Martin said.
Thank you for your comment.

>> Rest all looks good but i will wait for updated patch fixing above before
>> giving Reviewed-By.
>> 
>> >
>> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
>> > ---
>> >  drivers/scsi/ufs/ufshcd.c | 28 ++++++++++++++++++++++++++--
>> >  drivers/scsi/ufs/ufshcd.h |  7 +++++++
>> >  2 files changed, 33 insertions(+), 2 deletions(-)
>> >
>> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
>> > index d6e3112..c9cf011 100644
>> > --- a/drivers/scsi/ufs/ufshcd.c
>> > +++ b/drivers/scsi/ufs/ufshcd.c
>> > @@ -392,7 +392,31 @@ static inline void ufshcd_put_tm_slot(struct
>> > ufs_hba *hba, int slot)
>> >   */
>> >  static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
>> >  {
>> > -	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>> > +	u32 clear;
>> > +
>> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
>> > +		clear = (1 << pos);
>> > +	else
>> > +		clear = ~(1 << pos);
>> > +
>> > +	ufshcd_writel(hba, clear, REG_UTP_TRANSFER_REQ_LIST_CLEAR);
>> > +}
>> > +
>> > +/**
>> > + * ufshcd_utmrl_clear - Clear a bit in UTRMLCLR register
>> > + * @hba: per adapter instance
>> > + * @pos: position of the bit to be cleared
>> > + */
>> > +static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
>> > +{
>> > +	u32 clear;
>> > +
>> > +	if (hba->quirks & UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR)
>> > +		clear = (1 << pos);
>> > +	else
>> > +		clear = ~(1 << pos);
>> > +
>> > +	ufshcd_writel(hba, clear, REG_UTP_TASK_REQ_LIST_CLEAR);
>> >  }
>> >
>> >  /**
>> > @@ -4312,7 +4336,7 @@ static int ufshcd_clear_tm_cmd(struct ufs_hba
>> > *hba, int tag)
>> >  		goto out;
>> >
>> >  	spin_lock_irqsave(hba->host->host_lock, flags);
>> > -	ufshcd_writel(hba, ~(1 << tag), REG_UTP_TASK_REQ_LIST_CLEAR);
>> > +	ufshcd_utmrl_clear(hba, tag);
>> >  	spin_unlock_irqrestore(hba->host->host_lock, flags);
>> >
>> >  	/* poll for max. 1 sec to clear door bell register by h/w */
>> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
>> > index 7d9ff22..9838598 100644
>> > --- a/drivers/scsi/ufs/ufshcd.h
>> > +++ b/drivers/scsi/ufs/ufshcd.h
>> > @@ -491,6 +491,13 @@ struct ufs_hba {
>> >  	 */
>> >  	#define UFSHCD_QUIRK_PRDT_BYTE_GRAN			UFS_BIT(7)
>> >
>> > +	/*
>> > +	 * This quirk needs to be enabled if the host contoller has to set
>> > +	 * the bit corresponding the slot to be cleared to 1, not 0 as
>> > +	 * described in UFS spec.
>> > +	 */
>> > +	#define UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR                UFS_BIT(8)
>> > +
>> >  	unsigned int quirks;	/* Deviations from standard UFSHCI spec.
>> */
>> >
>> >  	/* Device deviations from standard UFS device spec. */
>> 
>> --
>> The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
>> a Linux Foundation Collaborative Project
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html


