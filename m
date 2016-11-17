From: Subhash Jadavani <subhashj@codeaurora.org>
Subject: Re: [PATCH v3] ufs: introduce UFSHCD_QUIRK_BROKEN_REQ_LIST_CLR quirk
Date: Thu, 17 Nov 2016 11:29:33 -0800
Message-ID: <a72b13619dcc5e059906cf1677369522@codeaurora.org>
References: <000401d23fc6$b6685110$2338f330$@samsung.com>
 <CGME20161116185259epcas5p14aae8bce84e7f2750081139c7a9533af@epcas5p1.samsung.com>
 <4efc79cfcd21ee4044a3d3a2f9551078@codeaurora.org>
 <01f901d240d9$cf715e40$6e541ac0$@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:42410 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbcKQT3e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Nov 2016 14:29:34 -0500
In-Reply-To: <01f901d240d9$cf715e40$6e541ac0$@samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kiwoong Kim <kwmad.kim@samsung.com>
Cc: linux-scsi@vger.kernel.org, cpgs@samsung.com, 'HeonGwang Chu' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

On 2016-11-17 05:52, Kiwoong Kim wrote:
>> On 2016-11-15 21:03, Kiwoong Kim wrote:
>> > Some UFS host controllers may clear a transfer request slot
>> > by setting an associated bit in UTRLCLR/UTMRLCLR to 1, not 0.
>> > That's opposite to what UFS spec describes.
>> >
>> 
>> This was the comment on v2: "As Martin mentioned in other email, 
>> please
>> separate this version history from commit text with line having "----"
>> before the start of version history."
>> So i would have expected the patch version to be still v2 and just add
>> the version history separator added before version history. But you
> 
> Okay. You mean re-sending it with moving the separator to another line,
> don't you? I knew that I should update version even if there is a 
> change
> of commit message and version history. Thank you for your information.
> 
>> posted v3 and removed the version history altogether. As far as patch
>> contents are concerned, it looks good to me hence i am adding by
>> reviewed-by. But please make sure to keep the version history intact 
>> for
>> fewer patches.
> 
> I have one question.
> If I would update v4 of this patch as Martin asked,
> which one should I choose?
> 1) adding changes from v1~v4
> 2) adding just something like 'version update'
> Because there is no difference between v3 and v4.

You should keep the all the previous version history intact and then add 
v4 history saying "rebased to 4.10/scsi-queue tip".

> 
>> 
>> Reviewed-by: Subhash Jadavani <subhashj@codeaurora.org>
>> 
>> 
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
>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
The Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
