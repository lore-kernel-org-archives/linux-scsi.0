From: Seungwon Jeon <tgih.jun@samsung.com>
Subject: RE: [PATCH 2/7] scsi: ufs: find out sense data over scsi status values
Date: Tue, 30 Jul 2013 22:00:45 +0900
Message-ID: <002601ce8d24$ce42b3a0$6ac81ae0$%jun@samsung.com>
References: <1374280885-11526-1-git-send-email-mita@fixstars.com>
 <001d01ce8a06$76bb3420$64319c60$%jun@samsung.com>
 <51F60D14.8070105@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailout3.samsung.com ([203.254.224.33]:30998 "EHLO
	mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751761Ab3G3NAr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Jul 2013 09:00:47 -0400
Received: from epcpsbgr4.samsung.com
 (u144.gpu120.samsung.co.kr [203.254.230.144])
 by mailout3.samsung.com (Oracle Communications Messaging Server 7u4-24.01
 (7.0.4.24.0) 64bit (built Nov 17 2011))
 with ESMTP id <0MQR009772T81960@mailout3.samsung.com> for
 linux-scsi@vger.kernel.org; Tue, 30 Jul 2013 22:00:46 +0900 (KST)
In-reply-to: <51F60D14.8070105@codeaurora.org>
Content-language: ko
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Subhash Jadavani' <subhashj@codeaurora.org>
Cc: linux-scsi@vger.kernel.org, 'Vinayak Holikatti' <vinholikatti@gmail.com>, 'Santosh Y' <santoshsy@gmail.com>, "'James E.J. Bottomley'" <JBottomley@parallels.com>

On Mon, July 29, 2013, Subhash Jadavani wrote:
> On 7/26/2013 7:16 PM, Seungwon Jeon wrote:
> > Except for 'GOOD' and 'CHECK CONDITION', other status value
> This is what UFS device spec says: "A GOOD status indicates successful
> SCSI completion and therefore no Sense Data will be returned." So please
> change the commit text accordingly.
Ok. It may seem vague.


> > in Response UPIU may or may contain sense data. If a non-zero
> 
> s/"may or may contain ..."/"may or may not contain"
Yes.

> > value is in the Data Segment Length field, it means that UPIU
> > has Sense Data in the Data Segment area.
> >
> > Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
> > ---
> >   drivers/scsi/ufs/ufs.h    |    1 +
> >   drivers/scsi/ufs/ufshcd.c |   27 +++++++++++++++++++--------
> >   2 files changed, 20 insertions(+), 8 deletions(-)
> >
> > diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> > index 139bc06..737c31b 100644
> > --- a/drivers/scsi/ufs/ufs.h
> > +++ b/drivers/scsi/ufs/ufs.h
> > @@ -114,6 +114,7 @@ enum {
> >   	MASK_SCSI_STATUS	= 0xFF,
> >   	MASK_TASK_RESPONSE	= 0xFF00,
> >   	MASK_RSP_UPIU_RESULT	= 0xFFFF,
> > +	MASK_RSP_UPIU_DATA_SEG_LEN	= 0xFFFF,
> >   };
> >
> >   /* Task management service response */
> > diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> > index 4cf3a2d..688ae0e 100644
> > --- a/drivers/scsi/ufs/ufshcd.c
> > +++ b/drivers/scsi/ufs/ufshcd.c
> > @@ -218,6 +218,20 @@ ufshcd_get_rsp_upiu_result(struct utp_upiu_rsp *ucd_rsp_ptr)
> >   	return be32_to_cpu(ucd_rsp_ptr->header.dword_1) & MASK_RSP_UPIU_RESULT;
> >   }
> >
> > +/*
> > + * ufshcd_get_rsp_upiu_data_seg_len - Get the data segment length
> > + *				from response UPIU
> > + * @ucd_rsp_ptr: pointer to response UPIU
> > + *
> > + * Return the data segment length.
> > + */
> > +static inline int
> > +ufshcd_get_rsp_upiu_data_seg_len(struct utp_upiu_rsp *ucd_rsp_ptr)
> > +{
> > +	return be32_to_cpu(ucd_rsp_ptr->header.dword_2) &
> > +		MASK_RSP_UPIU_DATA_SEG_LEN;
> > +}
> > +
> >   /**
> >    * ufshcd_config_int_aggr - Configure interrupt aggregation values.
> >    *		Currently there is no use case where we want to configure
> > @@ -298,7 +312,8 @@ void ufshcd_send_command(struct ufs_hba *hba, unsigned int task_tag)
> >   static inline void ufshcd_copy_sense_data(struct ufshcd_lrb *lrbp)
> >   {
> >   	int len;
> > -	if (lrbp->sense_buffer) {
> > +	if (lrbp->sense_buffer &&
> > +	    !ufshcd_get_rsp_upiu_data_seg_len(lrbp->ucd_rsp_ptr)) {
> 
> why if(!data_seg_len)? I guess you want to copy the sense data tot sense
> buffer only if the data segment length is non zero so in that case it
> should be "if(data_seg_len)".
Correct.

Thanks,
Seungwon Jeon

