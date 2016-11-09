From: Kiwoong Kim <kwmad.kim@samsung.com>
Subject: RE: [PATCH v1] ufs: introduce UFSHCD_QUIRK_BROKEN_DWORD_UTRD quirk
Date: Wed, 09 Nov 2016 11:17:08 +0900
Message-ID: <008a01d23a2f$5f9e27c0$1eda7740$@samsung.com>
References: <002101d23994$a1026f00$e3074d00$@samsung.com>
 <CGME20161108193423epcas3p45129cc699d370dc72b9b76970c550829@epcas3p4.samsung.com>
 <a0c337c3537b86c8cdeb1780958684d0@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout2.samsung.com ([203.254.224.25]:51456 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751638AbcKICRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 21:17:20 -0500
In-reply-to: <a0c337c3537b86c8cdeb1780958684d0@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: "'James E.J. Bottomley'" <jejb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org, "'Martin K. Petersen'" <martin.petersen@oracle.com>, vinholikatti@gmail.com, '???' <hg.chu@samsung.com>, linux-scsi-owner@vger.kernel.org

> > Some UFS host controllers may think
> > granularitys of PRDT length and offset as bytes, not double words.
> >
> > Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
> > ---
> >  drivers/scsi/ufs/ufshcd.c | 24 +++++++++++++++++++-----
> > drivers/scsi/ufs/ufshcd.h |  2 ++
> >  2 files changed, 21 insertions(+), 5 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 8e19631..549e3e8 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -1161,8 +1161,13 @@ static int ufshcd_map_sg(struct ufshcd_lrb
> > *lrbp)
> >  		return sg_segments;
> >
> >  	if (sg_segments) {
> > -		lrbp->utr_descriptor_ptr->prd_table_length =
> > -					cpu_to_le16((u16) (sg_segments));
> > +		if (hba->quirks & UFSHCD_QUIRK_BROKEN_DWORD_UTRD)
> 
> This might sound more specific:
> s/UFSHCD_QUIRK_BROKEN_DWORD_UTRD/UFSHCD_QUIRK_PRDT_BYTE_GRAN .

That sounds good. I'll apply what you said.

> 
> > +			lrbp->utr_descriptor_ptr->prd_table_length =
> > +				cpu_to_le16((u16)(sg_segments *
> > +					sizeof(struct ufshcd_sg_entry)));
> > +		else
> > +			lrbp->utr_descriptor_ptr->prd_table_length =
> > +				cpu_to_le16((u16) (sg_segments));
> >
> >  		prd_table = (struct ufshcd_sg_entry *)lrbp->ucd_prdt_ptr;
> >
> > @@ -2385,12 +2390,21 @@ static void
> > ufshcd_host_memory_configure(struct ufs_hba *hba)
> >
> 	cpu_to_le32(upper_32_bits(cmd_desc_element_addr));
> >
> >  		/* Response upiu and prdt offset should be in double words
> */
> > -		utrdlp[i].response_upiu_offset =
> > +		if (hba->quirks & UFSHCD_QUIRK_BROKEN_DWORD_UTRD) {
> > +			utrdlp[i].response_upiu_offset =
> > +				cpu_to_le16(response_offset);
> > +			utrdlp[i].prd_table_offset =
> > +				cpu_to_le16(prdt_offset);
> > +			utrdlp[i].response_upiu_length =
> > +				cpu_to_le16(ALIGNED_UPIU_SIZE);
> > +		} else {
> > +			utrdlp[i].response_upiu_offset =
> >  				cpu_to_le16((response_offset >> 2));
> > -		utrdlp[i].prd_table_offset =
> > +			utrdlp[i].prd_table_offset =
> >  				cpu_to_le16((prdt_offset >> 2));
> > -		utrdlp[i].response_upiu_length =
> > +			utrdlp[i].response_upiu_length =
> >  				cpu_to_le16(ALIGNED_UPIU_SIZE >> 2);
> > +		}
> >
> >  		hba->lrb[i].utr_descriptor_ptr = (utrdlp + i);
> >  		hba->lrb[i].ucd_req_ptr =
> > diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
> > index 8cf3991..565f005 100644
> > --- a/drivers/scsi/ufs/ufshcd.h
> > +++ b/drivers/scsi/ufs/ufshcd.h
> > @@ -494,6 +494,8 @@ struct ufs_hba {
> >  	#define UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		UFS_BIT(5)
> >
> >  	#define UFSHCD_QUIRK_GET_VS_RESULT			UFS_BIT(6)
> > +	#define UFSHCD_QUIRK_BROKEN_DWORD_UTRD                  UFS_BIT(7)
> > +
> 
> This extra line space isn't needed.

Okay.

> 
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


