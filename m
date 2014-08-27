From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v3 13/17] arcmsr: fix ioctl data read/write error for
 adapter type C
Date: Thu, 28 Aug 2014 04:19:01 +0800
Message-ID: <1409170741.9354.3.camel@Centos6.3-64>
References: <1408432665.4748.65.camel@Centos6.3-64>
	 <53F7690D.5070007@redhat.com> <1408989593.5593.26.camel@Centos6.3-64>
	 <53FB1014.4060508@redhat.com> <1409084845.4773.28.camel@Centos6.3-64>
	 <53FC89BA.7060800@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:41992 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755728AbaH0MTM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 27 Aug 2014 08:19:12 -0400
Received: by mail-pa0-f49.google.com with SMTP id hz1so170419pad.22
        for <linux-scsi@vger.kernel.org>; Wed, 27 Aug 2014 05:19:10 -0700 (PDT)
In-Reply-To: <53FC89BA.7060800@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2014-08-26 at 15:20 +0200, Tomas Henzl wrote:
> On 08/26/2014 10:27 PM, Ching Huang wrote:
> > On Mon, 2014-08-25 at 12:29 +0200, Tomas Henzl wrote:
> >> On 08/25/2014 07:59 PM, Ching Huang wrote:
> >>> On Fri, 2014-08-22 at 18:00 +0200, Tomas Henzl wrote:
> >>>> On 08/19/2014 09:17 AM, Ching Huang wrote:
> >>>>> From: Ching Huang <ching2048@areca.com.tw>
> >>>>>
> >>>>> Rewrite ioctl entry and its relate function.
> >>>>> This patch fix ioctl data read/write error and change data I/O access from byte to Dword.
> >>>>>
> >>>>> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> >>>>> ---
> >>>>>
> >>>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
> >>>>> --- a/drivers/scsi/arcmsr/arcmsr_attr.c	2014-02-06 17:47:24.000000000 +0800
> >>>>> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2014-04-29 17:10:42.000000000 +0800
> >>>>> @@ -70,40 +70,75 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
> >>>>>  	uint8_t *pQbuffer,*ptmpQbuffer;
> >>>>>  	int32_t allxfer_len = 0;
> >>>>> +	unsigned long flags;
> >>>>>  
> >>>>>  	if (!capable(CAP_SYS_ADMIN))
> >>>>>  		return -EACCES;
> >>>>>  
> >>>>>  	/* do message unit read. */
> >>>>>  	ptmpQbuffer = (uint8_t *)buf;
> >>>>> -	while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
> >>>>> -		&& (allxfer_len < 1031)) {
> >>>>> +	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>> +	if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
> >>>> Hi - does this condition (acb->rqbuf_firstindex == acb->rqbuf_lastindex) mean we could just release 
> >>>> the spinlock and return ?
> >>>>  
> >>> NO. We have to check the input buffer that may have message data come
> >>> from IOP.
> >>>>>  		pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
> >>>>> -		memcpy(ptmpQbuffer, pQbuffer, 1);
> >>>>> -		acb->rqbuf_firstindex++;
> >>>>> -		acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -		ptmpQbuffer++;
> >>>>> -		allxfer_len++;
> >>>>> +		if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
> >>>>> +			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >= 1032) {
> >>>>> +				memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>>>> +				acb->rqbuf_firstindex += 1032;
> >>>>> +				acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +				allxfer_len = 1032;
> >>>>> +			} else {
> >>>>> +				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)
> >>>>> +					+ acb->rqbuf_lastindex) > 1032) {
> >>>>> +					memcpy(ptmpQbuffer, pQbuffer,
> >>>>> +						ARCMSR_MAX_QBUFFER
> >>>>> +						- acb->rqbuf_firstindex);
> >>>>> +					ptmpQbuffer += ARCMSR_MAX_QBUFFER
> >>>>> +						- acb->rqbuf_firstindex;
> >>>>> +					memcpy(ptmpQbuffer, acb->rqbuffer, 1032
> >>>>> +						- (ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex));
> >>>> This code looks like you were copying some data from a ring buffer,
> >>>> in that case - shouldn't be acb->rqbuf_lastindex used instead of firstindex?
> >>>>
> >>> Yes, there copying data from a ring buffer. firstindex and lastindex are
> >>> bad name. For readability, I rename the firstindex to getIndex,
> >>> lastindex to putIndex. 
> >> My comment is not about names, but in this path '(ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)+ acb->rqbuf_lastindex) > 1032)'
> >> you copy something twice and in both cases the 'firstindex' is used and never the 'lastindex'.
> >> Is this correct?
> > The firstindex is a get index and lastindex is a put index of a ring buffer.
> > At here, firstindex > lastindex, so the data remain in buffer are (ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)+ acb->rqbuf_lastindex
> 
> Yes, it's correct, I misinterpreted the from value with the amount of bytes to copy.
> But well it's also still overcomplicated and I believe that a copy like this could be
> rearranged with just few lines of code as a result - have you looked at the code I sent?
> 
> Let's go with this patch as it is otherwise we will never end, repost is not needed because 
> of this and also not because of arcmsr_Read_iop_rqbuffer_in_DWORD.
> 
> I'll continue with reviewing the remaining patches.
> 
> tomas
> 
I have test the code you sent. It works.
I will modify the code by your idea, then send the patch.

Thanks,
Ching
> >
> >>>> What does the 1032 mean is that a hw. limit, actually could you explain the code 
> >>>> should do? Maybe I'm just wrong with my assumptions.
> >>> 1032 is the API data buffer limitation.
> >>>> Thanks,
> >>>> Tomas
> >>>>
> >>>>> +					acb->rqbuf_firstindex = 1032 -
> >>>>> +						(ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex);
> >>>>> +					allxfer_len = 1032;
> >>>>> +				} else {
> >>>>> +					memcpy(ptmpQbuffer, pQbuffer,
> >>>>> +						ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex);
> >>>>> +					ptmpQbuffer += ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex;
> >>>>> +					memcpy(ptmpQbuffer, acb->rqbuffer,
> >>>>> +						acb->rqbuf_lastindex);
> >>>>> +					allxfer_len = ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex +
> >>>>> +						acb->rqbuf_lastindex;
> >>>>> +					acb->rqbuf_firstindex =
> >>>>> +						acb->rqbuf_lastindex;
> >>>>> +				}
> >>>>> +			}
> >>>>> +		} else {
> >>>>> +			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
> >>>>> +				memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>>>> +				acb->rqbuf_firstindex += 1032;
> >>>>> +				allxfer_len = 1032;
> >>>>> +			} else {
> >>>>> +				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex
> >>>>> +					- acb->rqbuf_firstindex);
> >>>>> +				allxfer_len = acb->rqbuf_lastindex -
> >>>>> +					acb->rqbuf_firstindex;
> >>>>> +				acb->rqbuf_firstindex = acb->rqbuf_lastindex;
> >>>>> +			}
> >>>>> +		}
> >>>>>  	}
> >>>>>  	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>>  		struct QBUFFER __iomem *prbuffer;
> >>>>> -		uint8_t __iomem *iop_data;
> >>>>> -		int32_t iop_len;
> >>>>> -
> >>>>>  		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>>  		prbuffer = arcmsr_get_iop_rqbuffer(acb);
> >>>>> -		iop_data = prbuffer->data;
> >>>>> -		iop_len = readl(&prbuffer->data_len);
> >>>>> -		while (iop_len > 0) {
> >>>>> -			acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
> >>>>> -			acb->rqbuf_lastindex++;
> >>>>> -			acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -			iop_data++;
> >>>>> -			iop_len--;
> >>>>> -		}
> >>>>> -		arcmsr_iop_message_read(acb);
> >>>>> +		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
> >>>>> +			acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
> >>>>>  	}
> >>>>> -	return (allxfer_len);
> >>>>> +	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>> +	return allxfer_len;
> >>>>>  }
> >>>>>  
> >>>>>  static ssize_t arcmsr_sysfs_iop_message_write(struct file *filp,
> >>>>> @@ -117,6 +152,7 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
> >>>>>  	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
> >>>>>  	uint8_t *pQbuffer, *ptmpuserbuffer;
> >>>>> +	unsigned long flags;
> >>>>>  
> >>>>>  	if (!capable(CAP_SYS_ADMIN))
> >>>>>  		return -EACCES;
> >>>>> @@ -125,18 +161,19 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>>>  	/* do message unit write. */
> >>>>>  	ptmpuserbuffer = (uint8_t *)buf;
> >>>>>  	user_len = (int32_t)count;
> >>>>> +	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>>  	wqbuf_lastindex = acb->wqbuf_lastindex;
> >>>>>  	wqbuf_firstindex = acb->wqbuf_firstindex;
> >>>>>  	if (wqbuf_lastindex != wqbuf_firstindex) {
> >>>>> -		arcmsr_post_ioctldata2iop(acb);
> >>>>> +		arcmsr_write_ioctldata2iop(acb);
> >>>>> +		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>>  		return 0;	/*need retry*/
> >>>>>  	} else {
> >>>>>  		my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
> >>>>> -				&(ARCMSR_MAX_QBUFFER - 1);
> >>>>> +			&(ARCMSR_MAX_QBUFFER - 1);
> >>>>>  		if (my_empty_len >= user_len) {
> >>>>>  			while (user_len > 0) {
> >>>>> -				pQbuffer =
> >>>>> -				&acb->wqbuffer[acb->wqbuf_lastindex];
> >>>>> +				pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
> >>>>>  				memcpy(pQbuffer, ptmpuserbuffer, 1);
> >>>>>  				acb->wqbuf_lastindex++;
> >>>>>  				acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> @@ -146,10 +183,12 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>>>  			if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
> >>>>>  				acb->acb_flags &=
> >>>>>  					~ACB_F_MESSAGE_WQBUFFER_CLEARED;
> >>>>> -				arcmsr_post_ioctldata2iop(acb);
> >>>>> +				arcmsr_write_ioctldata2iop(acb);
> >>>>>  			}
> >>>>> +			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>>  			return count;
> >>>>>  		} else {
> >>>>> +			spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>>  			return 0;	/*need retry*/
> >>>>>  		}
> >>>>>  	}
> >>>>> @@ -165,22 +204,24 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>>>  	struct Scsi_Host *host = class_to_shost(dev);
> >>>>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
> >>>>>  	uint8_t *pQbuffer;
> >>>>> +	unsigned long flags;
> >>>>>  
> >>>>>  	if (!capable(CAP_SYS_ADMIN))
> >>>>>  		return -EACCES;
> >>>>>  
> >>>>> -	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> -		acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>> -		arcmsr_iop_message_read(acb);
> >>>>> -	}
> >>>>> +	arcmsr_clear_iop2drv_rqueue_buffer(acb);
> >>>>>  	acb->acb_flags |=
> >>>>>  		(ACB_F_MESSAGE_WQBUFFER_CLEARED
> >>>>>  		| ACB_F_MESSAGE_RQBUFFER_CLEARED
> >>>>>  		| ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> +	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>>  	acb->rqbuf_firstindex = 0;
> >>>>>  	acb->rqbuf_lastindex = 0;
> >>>>> +	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>> +	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>>  	acb->wqbuf_firstindex = 0;
> >>>>>  	acb->wqbuf_lastindex = 0;
> >>>>> +	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>>  	pQbuffer = acb->rqbuffer;
> >>>>>  	memset(pQbuffer, 0, sizeof (struct QBUFFER));
> >>>>>  	pQbuffer = acb->wqbuffer;
> >>>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> >>>>> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:28:38.000000000 +0800
> >>>>> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-05-06 15:28:58.000000000 +0800
> >>>>> @@ -518,6 +518,8 @@ struct AdapterControlBlock
> >>>>>  	uint32_t			reg_mu_acc_handle0;
> >>>>>  	spinlock_t                      			eh_lock;
> >>>>>  	spinlock_t                      			ccblist_lock;
> >>>>> +	spinlock_t			rqbuffer_lock;
> >>>>> +	spinlock_t			wqbuffer_lock;
> >>>>>  	union {
> >>>>>  		struct MessageUnit_A __iomem *pmuA;
> >>>>>  		struct MessageUnit_B 	*pmuB;
> >>>>> @@ -693,8 +695,10 @@ struct SENSE_DATA
> >>>>>  #define     ARCMSR_MU_OUTBOUND_MESSAGE0_INTMASKENABLE               0x01
> >>>>>  #define     ARCMSR_MU_OUTBOUND_ALL_INTMASKENABLE                    0x1F
> >>>>>  
> >>>>> -extern void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *);
> >>>>> -extern void arcmsr_iop_message_read(struct AdapterControlBlock *);
> >>>>> +extern void arcmsr_write_ioctldata2iop(struct AdapterControlBlock *);
> >>>>> +extern uint32_t arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *,
> >>>>> +	struct QBUFFER __iomem *);
> >>>>> +extern void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *);
> >>>>>  extern struct QBUFFER __iomem *arcmsr_get_iop_rqbuffer(struct AdapterControlBlock *);
> >>>>>  extern struct device_attribute *arcmsr_host_attrs[];
> >>>>>  extern int arcmsr_alloc_sysfs_attr(struct AdapterControlBlock *);
> >>>>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> >>>>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:40:38.000000000 +0800
> >>>>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-14 18:40:48.000000000 +0800
> >>>>> @@ -627,6 +627,8 @@ static int arcmsr_probe(struct pci_dev *
> >>>>>  	}
> >>>>>  	spin_lock_init(&acb->eh_lock);
> >>>>>  	spin_lock_init(&acb->ccblist_lock);
> >>>>> +	spin_lock_init(&acb->rqbuffer_lock);
> >>>>> +	spin_lock_init(&acb->wqbuffer_lock);
> >>>>>  	acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>>>  			ACB_F_MESSAGE_RQBUFFER_CLEARED |
> >>>>>  			ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> @@ -1423,68 +1425,174 @@ static struct QBUFFER __iomem *arcmsr_ge
> >>>>>  	return pqbuffer;
> >>>>>  }
> >>>>>  
> >>>>> -static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
> >>>>> -{
> >>>>> -	struct QBUFFER __iomem *prbuffer;
> >>>>> -	struct QBUFFER *pQbuffer;
> >>>>> -	uint8_t __iomem *iop_data;
> >>>>> -	int32_t my_empty_len, iop_len, rqbuf_firstindex, rqbuf_lastindex;
> >>>>> -	rqbuf_lastindex = acb->rqbuf_lastindex;
> >>>>> -	rqbuf_firstindex = acb->rqbuf_firstindex;
> >>>>> -	prbuffer = arcmsr_get_iop_rqbuffer(acb);
> >>>>> -	iop_data = (uint8_t __iomem *)prbuffer->data;
> >>>>> -	iop_len = prbuffer->data_len;
> >>>>> -	my_empty_len = (rqbuf_firstindex - rqbuf_lastindex - 1) & (ARCMSR_MAX_QBUFFER - 1);
> >>>>> +static uint32_t arcmsr_Read_iop_rqbuffer_in_DWORD(struct AdapterControlBlock *acb,
> >>>>> +	struct QBUFFER __iomem *prbuffer) {
> >>>>>  
> >>>>> -	if (my_empty_len >= iop_len)
> >>>>> -	{
> >>>>> -		while (iop_len > 0) {
> >>>>> -			pQbuffer = (struct QBUFFER *)&acb->rqbuffer[rqbuf_lastindex];
> >>>>> -			memcpy(pQbuffer, iop_data, 1);
> >>>>> -			rqbuf_lastindex++;
> >>>>> -			rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +	uint8_t *pQbuffer;
> >>>>> +	uint8_t *buf1 = NULL;
> >>>>> +	uint32_t __iomem *iop_data;
> >>>>> +	uint32_t iop_len, data_len, *buf2 = NULL;
> >>>>> +
> >>>>> +	iop_data = (uint32_t __iomem *)prbuffer->data;
> >>>>> +	iop_len = readl(&prbuffer->data_len);
> >>>>> +	if (iop_len > 0) {
> >>>>> +		buf1 = kmalloc(128, GFP_ATOMIC);
> >>>>> +		buf2 = (uint32_t *)buf1;
> >>>>> +		if (buf1 == NULL)
> >>>>> +			return 0;
> >>>>> +		data_len = iop_len;
> >>>>> +		while (data_len >= 4) {
> >>>>> +			*buf2++ = readl(iop_data);
> >>>>>  			iop_data++;
> >>>>> -			iop_len--;
> >>>>> +			data_len -= 4;
> >>>>>  		}
> >>>>> -		acb->rqbuf_lastindex = rqbuf_lastindex;
> >>>>> -		arcmsr_iop_message_read(acb);
> >>>>> +		if (data_len)
> >>>>> +			*buf2 = readl(iop_data);
> >>>>> +		buf2 = (uint32_t *)buf1;
> >>>>> +	}
> >>>>> +	while (iop_len > 0) {
> >>>>> +		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
> >>>>> +		*pQbuffer = *buf1;
> >>>>> +		acb->rqbuf_lastindex++;
> >>>>> +		/* if last, index number set it to 0 */
> >>>>> +		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +		buf1++;
> >>>>> +		iop_len--;
> >>>>> +	}
> >>>>> +	if (buf2)
> >>>> This test is not needed.
> >>>>
> >>>>> +		kfree(buf2);
> >>>>> +	/* let IOP know data has been read */
> >>>>> +	arcmsr_iop_message_read(acb);
> >>>>> +	return 1;
> >>>>> +}
> >>>>> +
> >>>>> +uint32_t
> >>>>> +arcmsr_Read_iop_rqbuffer_data(struct AdapterControlBlock *acb,
> >>>>> +	struct QBUFFER __iomem *prbuffer) {
> >>>>> +
> >>>>> +	uint8_t *pQbuffer;
> >>>>> +	uint8_t __iomem *iop_data;
> >>>>> +	uint32_t iop_len;
> >>>>> +
> >>>>> +	if (acb->adapter_type & ACB_ADAPTER_TYPE_C)
> >>>>> +		return arcmsr_Read_iop_rqbuffer_in_DWORD(acb, prbuffer);
> >>>>> +	iop_data = (uint8_t __iomem *)prbuffer->data;
> >>>>> +	iop_len = readl(&prbuffer->data_len);
> >>>>> +	while (iop_len > 0) {
> >>>>> +		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
> >>>>> +		*pQbuffer = readb(iop_data);
> >>>>> +		acb->rqbuf_lastindex++;
> >>>>> +		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +		iop_data++;
> >>>>> +		iop_len--;
> >>>>>  	}
> >>>>> +	arcmsr_iop_message_read(acb);
> >>>>> +	return 1;
> >>>>> +}
> >>>>> +
> >>>>> +static void arcmsr_iop2drv_data_wrote_handle(struct AdapterControlBlock *acb)
> >>>>> +{
> >>>>> +	unsigned long flags;
> >>>>> +	struct QBUFFER __iomem  *prbuffer;
> >>>>> +	int32_t buf_empty_len;
> >>>>>  
> >>>>> -	else {
> >>>>> +	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>> +	prbuffer = arcmsr_get_iop_rqbuffer(acb);
> >>>>> +	buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &
> >>>>> +		(ARCMSR_MAX_QBUFFER - 1);
> >>>>> +	if (buf_empty_len >= readl(&prbuffer->data_len)) {
> >>>>> +		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
> >>>>> +			acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
> >>>>> +	} else
> >>>>>  		acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
> >>>>> +	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>> +}
> >>>>> +
> >>>>> +static void arcmsr_write_ioctldata2iop_in_DWORD(struct AdapterControlBlock *acb)
> >>>>> +{
> >>>>> +	uint8_t *pQbuffer;
> >>>>> +	struct QBUFFER __iomem *pwbuffer;
> >>>>> +	uint8_t *buf1 = NULL;
> >>>>> +	uint32_t __iomem *iop_data;
> >>>>> +	uint32_t allxfer_len = 0, data_len, *buf2 = NULL, data;
> >>>>> +
> >>>>> +	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
> >>>>> +		buf1 = kmalloc(128, GFP_ATOMIC);
> >>>>> +		buf2 = (uint32_t *)buf1;
> >>>>> +		if (buf1 == NULL)
> >>>>> +			return;
> >>>>> +
> >>>>> +		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> +		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
> >>>>> +		iop_data = (uint32_t __iomem *)pwbuffer->data;
> >>>>> +		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>>>> +			&& (allxfer_len < 124)) {
> >>>>> +			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
> >>>>> +			*buf1 = *pQbuffer;
> >>>>> +			acb->wqbuf_firstindex++;
> >>>>> +			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +			buf1++;
> >>>>> +			allxfer_len++;
> >>>>> +		}
> >>>>> +		data_len = allxfer_len;
> >>>>> +		buf1 = (uint8_t *)buf2;
> >>>>> +		while (data_len >= 4) {
> >>>>> +			data = *buf2++;
> >>>>> +			writel(data, iop_data);
> >>>>> +			iop_data++;
> >>>>> +			data_len -= 4;
> >>>>> +		}
> >>>>> +		if (data_len) {
> >>>>> +			data = *buf2;
> >>>>> +			writel(data, iop_data);
> >>>>> +		}
> >>>>> +		writel(allxfer_len, &pwbuffer->data_len);
> >>>>> +		kfree(buf1);
> >>>>> +		arcmsr_iop_message_wrote(acb);
> >>>>>  	}
> >>>>>  }
> >>>>>  
> >>>>> -static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
> >>>>> +void
> >>>>> +arcmsr_write_ioctldata2iop(struct AdapterControlBlock *acb)
> >>>>>  {
> >>>>> -	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
> >>>>> -	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex) {
> >>>>> -		uint8_t *pQbuffer;
> >>>>> -		struct QBUFFER __iomem *pwbuffer;
> >>>>> -		uint8_t __iomem *iop_data;
> >>>>> -		int32_t allxfer_len = 0;
> >>>>> +	uint8_t *pQbuffer;
> >>>>> +	struct QBUFFER __iomem *pwbuffer;
> >>>>> +	uint8_t __iomem *iop_data;
> >>>>> +	int32_t allxfer_len = 0;
> >>>>>  
> >>>>> +	if (acb->adapter_type & ACB_ADAPTER_TYPE_C) {
> >>>>> +		arcmsr_write_ioctldata2iop_in_DWORD(acb);
> >>>>> +		return;
> >>>>> +	}
> >>>>> +	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
> >>>>>  		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>>  		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
> >>>>>  		iop_data = (uint8_t __iomem *)pwbuffer->data;
> >>>>> -
> >>>>> -		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex) && \
> >>>>> -							(allxfer_len < 124)) {
> >>>>> +		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>>>> +			&& (allxfer_len < 124)) {
> >>>>>  			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
> >>>>> -			memcpy(iop_data, pQbuffer, 1);
> >>>>> +			writeb(*pQbuffer, iop_data);
> >>>>>  			acb->wqbuf_firstindex++;
> >>>>>  			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>>  			iop_data++;
> >>>>>  			allxfer_len++;
> >>>>>  		}
> >>>>> -		pwbuffer->data_len = allxfer_len;
> >>>>> -
> >>>>> +		writel(allxfer_len, &pwbuffer->data_len);
> >>>>>  		arcmsr_iop_message_wrote(acb);
> >>>>>  	}
> >>>>> +}
> >>>>>  
> >>>>> -	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex) {
> >>>>> +static void arcmsr_iop2drv_data_read_handle(struct AdapterControlBlock *acb)
> >>>>> +{
> >>>>> +	unsigned long flags;
> >>>>> +
> >>>>> +	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>> +	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
> >>>>> +	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>>>> +		arcmsr_write_ioctldata2iop(acb);
> >>>>> +	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
> >>>>>  		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
> >>>>> -	}
> >>>>> +	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>>  }
> >>>>>  
> >>>>>  static void arcmsr_hbaA_doorbell_isr(struct AdapterControlBlock *acb)
> >>>>> @@ -1742,296 +1850,344 @@ static void arcmsr_iop_parking(struct Ad
> >>>>>  	}
> >>>>>  }
> >>>>>  
> >>>>> -void arcmsr_post_ioctldata2iop(struct AdapterControlBlock *acb)
> >>>>> +
> >>>>> +void arcmsr_clear_iop2drv_rqueue_buffer(struct AdapterControlBlock *acb)
> >>>>>  {
> >>>>> -	int32_t wqbuf_firstindex, wqbuf_lastindex;
> >>>>> -	uint8_t *pQbuffer;
> >>>>> -	struct QBUFFER __iomem *pwbuffer;
> >>>>> -	uint8_t __iomem *iop_data;
> >>>>> -	int32_t allxfer_len = 0;
> >>>>> -	pwbuffer = arcmsr_get_iop_wqbuffer(acb);
> >>>>> -	iop_data = (uint8_t __iomem *)pwbuffer->data;
> >>>>> -	if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_READED) {
> >>>>> -		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> -		wqbuf_firstindex = acb->wqbuf_firstindex;
> >>>>> -		wqbuf_lastindex = acb->wqbuf_lastindex;
> >>>>> -		while ((wqbuf_firstindex != wqbuf_lastindex) && (allxfer_len < 124)) {
> >>>>> -			pQbuffer = &acb->wqbuffer[wqbuf_firstindex];
> >>>>> -			memcpy(iop_data, pQbuffer, 1);
> >>>>> -			wqbuf_firstindex++;
> >>>>> -			wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -			iop_data++;
> >>>>> -			allxfer_len++;
> >>>>> +	uint32_t	i;
> >>>>> +
> >>>>> +	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> +		for (i = 0; i < 15; i++) {
> >>>>> +			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> +				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>> +				acb->rqbuf_firstindex = 0;
> >>>>> +				acb->rqbuf_lastindex = 0;
> >>>>> +				arcmsr_iop_message_read(acb);
> >>>>> +				mdelay(30);
> >>>>> +			} else if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
> >>>>> +				acb->rqbuf_firstindex = 0;
> >>>>> +				acb->rqbuf_lastindex = 0;
> >>>>> +				mdelay(30);
> >>>>> +			} else
> >>>>> +				break;
> >>>>>  		}
> >>>>> -		acb->wqbuf_firstindex = wqbuf_firstindex;
> >>>>> -		pwbuffer->data_len = allxfer_len;
> >>>>> -		arcmsr_iop_message_wrote(acb);
> >>>>>  	}
> >>>>>  }
> >>>>>  
> >>>>> -static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb,
> >>>>> -					struct scsi_cmnd *cmd)
> >>>>> +static int arcmsr_iop_message_xfer(struct AdapterControlBlock *acb, struct scsi_cmnd *cmd)
> >>>>>  {
> >>>>> -	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
> >>>>> -	int retvalue = 0, transfer_len = 0;
> >>>>>  	char *buffer;
> >>>>> +	unsigned short use_sg;
> >>>>> +	int retvalue = 0, transfer_len = 0;
> >>>>> +	unsigned long flags;
> >>>>> +	struct CMD_MESSAGE_FIELD *pcmdmessagefld;
> >>>>> +	uint32_t controlcode = (uint32_t)cmd->cmnd[5] << 24 |
> >>>>> +		(uint32_t)cmd->cmnd[6] << 16 |
> >>>>> +		(uint32_t)cmd->cmnd[7] << 8 |
> >>>>> +		(uint32_t)cmd->cmnd[8];
> >>>>>  	struct scatterlist *sg;
> >>>>> -	uint32_t controlcode = (uint32_t ) cmd->cmnd[5] << 24 |
> >>>>> -						(uint32_t ) cmd->cmnd[6] << 16 |
> >>>>> -						(uint32_t ) cmd->cmnd[7] << 8  |
> >>>>> -						(uint32_t ) cmd->cmnd[8];
> >>>>> -						/* 4 bytes: Areca io control code */
> >>>>> +
> >>>>> +	use_sg = scsi_sg_count(cmd);
> >>>>>  	sg = scsi_sglist(cmd);
> >>>>>  	buffer = kmap_atomic(sg_page(sg)) + sg->offset;
> >>>>> -	if (scsi_sg_count(cmd) > 1) {
> >>>>> +	if (use_sg > 1) {
> >>>>>  		retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>>  		goto message_out;
> >>>>>  	}
> >>>>>  	transfer_len += sg->length;
> >>>>> -
> >>>>>  	if (transfer_len > sizeof(struct CMD_MESSAGE_FIELD)) {
> >>>>>  		retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>> +		pr_info("%s: ARCMSR_MESSAGE_FAIL!\n", __func__);
> >>>>>  		goto message_out;
> >>>>>  	}
> >>>>> -	pcmdmessagefld = (struct CMD_MESSAGE_FIELD *) buffer;
> >>>>> -	switch(controlcode) {
> >>>>> -
> >>>>> +	pcmdmessagefld = (struct CMD_MESSAGE_FIELD *)buffer;
> >>>>> +	switch (controlcode) {
> >>>>>  	case ARCMSR_MESSAGE_READ_RQBUFFER: {
> >>>>>  		unsigned char *ver_addr;
> >>>>>  		uint8_t *pQbuffer, *ptmpQbuffer;
> >>>>> -		int32_t allxfer_len = 0;
> >>>>> -
> >>>>> +		uint32_t allxfer_len = 0;
> >>>>>  		ver_addr = kmalloc(1032, GFP_ATOMIC);
> >>>>>  		if (!ver_addr) {
> >>>>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>> +			pr_info("%s: memory not enough!\n", __func__);
> >>>>>  			goto message_out;
> >>>>>  		}
> >>>>> -				
> >>>>>  		ptmpQbuffer = ver_addr;
> >>>>> -		while ((acb->rqbuf_firstindex != acb->rqbuf_lastindex)
> >>>>> -			&& (allxfer_len < 1031)) {
> >>>>> +		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>> +		if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
> >>>>>  			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
> >>>>> -			memcpy(ptmpQbuffer, pQbuffer, 1);
> >>>>> -			acb->rqbuf_firstindex++;
> >>>>> -			acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -			ptmpQbuffer++;
> >>>>> -			allxfer_len++;
> >>>>> +			if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
> >>>>> +				if ((ARCMSR_MAX_QBUFFER -
> >>>>> +					acb->rqbuf_firstindex) >= 1032) {
> >>>>> +					memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>>>> +					acb->rqbuf_firstindex += 1032;
> >>>>> +					acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>>>> +					allxfer_len = 1032;
> >>>>> +				} else {
> >>>>> +					if (((ARCMSR_MAX_QBUFFER -
> >>>>> +						acb->rqbuf_firstindex) +
> >>>>> +						acb->rqbuf_lastindex) > 1032) {
> >>>>> +						memcpy(ptmpQbuffer,
> >>>>> +							pQbuffer, ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->rqbuf_firstindex);
> >>>>> +						ptmpQbuffer +=
> >>>>> +							ARCMSR_MAX_QBUFFER -
> >>>>> +							acb->rqbuf_firstindex;
> >>>>> +						memcpy(ptmpQbuffer,
> >>>>> +							acb->rqbuffer, 1032 -
> >>>>> +							(ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->rqbuf_firstindex));
> >>>>> +						acb->rqbuf_firstindex =
> >>>>> +							1032 - (ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->rqbuf_firstindex);
> >>>>> +						allxfer_len = 1032;
> >>>>> +					} else {
> >>>>> +						memcpy(ptmpQbuffer,
> >>>>> +							pQbuffer, ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->rqbuf_firstindex);
> >>>>> +						ptmpQbuffer +=
> >>>>> +							ARCMSR_MAX_QBUFFER -
> >>>>> +							acb->rqbuf_firstindex;
> >>>>> +						memcpy(ptmpQbuffer,
> >>>>> +							acb->rqbuffer,
> >>>>> +							acb->rqbuf_lastindex);
> >>>>> +						allxfer_len = ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->rqbuf_firstindex +
> >>>>> +							acb->rqbuf_lastindex;
> >>>>> +						acb->rqbuf_firstindex =
> >>>>> +							acb->rqbuf_lastindex;
> >>>>> +					}
> >>>>> +				}
> >>>>> +			} else {
> >>>>> +				if ((acb->rqbuf_lastindex -
> >>>>> +					acb->rqbuf_firstindex) > 1032) {
> >>>>> +					memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>>>> +					acb->rqbuf_firstindex += 1032;
> >>>>> +					allxfer_len = 1032;
> >>>>> +				} else {
> >>>>> +					memcpy(ptmpQbuffer, pQbuffer,
> >>>>> +						acb->rqbuf_lastindex -
> >>>>> +						acb->rqbuf_firstindex);
> >>>>> +					allxfer_len = acb->rqbuf_lastindex
> >>>>> +						- acb->rqbuf_firstindex;
> >>>>> +					acb->rqbuf_firstindex =
> >>>>> +						acb->rqbuf_lastindex;
> >>>>> +				}
> >>>>> +			}
> >>>>>  		}
> >>>>> +		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr,
> >>>>> +			allxfer_len);
> >>>>>  		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> -
> >>>>>  			struct QBUFFER __iomem *prbuffer;
> >>>>> -			uint8_t __iomem *iop_data;
> >>>>> -			int32_t iop_len;
> >>>>> -
> >>>>>  			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>>  			prbuffer = arcmsr_get_iop_rqbuffer(acb);
> >>>>> -			iop_data = prbuffer->data;
> >>>>> -			iop_len = readl(&prbuffer->data_len);
> >>>>> -			while (iop_len > 0) {
> >>>>> -				acb->rqbuffer[acb->rqbuf_lastindex] = readb(iop_data);
> >>>>> -				acb->rqbuf_lastindex++;
> >>>>> -				acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -				iop_data++;
> >>>>> -				iop_len--;
> >>>>> -			}
> >>>>> -			arcmsr_iop_message_read(acb);
> >>>>> -		}
> >>>>> -		memcpy(pcmdmessagefld->messagedatabuffer, ver_addr, allxfer_len);
> >>>>> -		pcmdmessagefld->cmdmessage.Length = allxfer_len;
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode = ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> +			if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
> >>>>> +				acb->acb_flags |= ACB_F_IOPDATA_OVERFLOW;
> >>>>>  		}
> >>>>> +		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>>  		kfree(ver_addr);
> >>>>> -		}
> >>>>> +		pcmdmessagefld->cmdmessage.Length = allxfer_len;
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
> >>>>>  		unsigned char *ver_addr;
> >>>>>  		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
> >>>>>  		uint8_t *pQbuffer, *ptmpuserbuffer;
> >>>>> -
> >>>>>  		ver_addr = kmalloc(1032, GFP_ATOMIC);
> >>>>>  		if (!ver_addr) {
> >>>>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>>  			goto message_out;
> >>>>>  		}
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode = 
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode = 
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> -		}
> >>>>>  		ptmpuserbuffer = ver_addr;
> >>>>>  		user_len = pcmdmessagefld->cmdmessage.Length;
> >>>>> -		memcpy(ptmpuserbuffer, pcmdmessagefld->messagedatabuffer, user_len);
> >>>>> +		memcpy(ptmpuserbuffer,
> >>>>> +			pcmdmessagefld->messagedatabuffer, user_len);
> >>>>> +		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>>  		wqbuf_lastindex = acb->wqbuf_lastindex;
> >>>>>  		wqbuf_firstindex = acb->wqbuf_firstindex;
> >>>>>  		if (wqbuf_lastindex != wqbuf_firstindex) {
> >>>>>  			struct SENSE_DATA *sensebuffer =
> >>>>>  				(struct SENSE_DATA *)cmd->sense_buffer;
> >>>>> -			arcmsr_post_ioctldata2iop(acb);
> >>>>> +			arcmsr_write_ioctldata2iop(acb);
> >>>>>  			/* has error report sensedata */
> >>>>> -			sensebuffer->ErrorCode = 0x70;
> >>>>> +			sensebuffer->ErrorCode = SCSI_SENSE_CURRENT_ERRORS;
> >>>>>  			sensebuffer->SenseKey = ILLEGAL_REQUEST;
> >>>>>  			sensebuffer->AdditionalSenseLength = 0x0A;
> >>>>>  			sensebuffer->AdditionalSenseCode = 0x20;
> >>>>>  			sensebuffer->Valid = 1;
> >>>>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>>  		} else {
> >>>>> -			my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
> >>>>> -				&(ARCMSR_MAX_QBUFFER - 1);
> >>>>> +			my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)
> >>>>> +				& (ARCMSR_MAX_QBUFFER - 1);
> >>>>>  			if (my_empty_len >= user_len) {
> >>>>>  				while (user_len > 0) {
> >>>>> -					pQbuffer =
> >>>>> -					&acb->wqbuffer[acb->wqbuf_lastindex];
> >>>>> -					memcpy(pQbuffer, ptmpuserbuffer, 1);
> >>>>> -					acb->wqbuf_lastindex++;
> >>>>> -					acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>>>> -					ptmpuserbuffer++;
> >>>>> -					user_len--;
> >>>>> +					pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
> >>>>> +					if ((acb->wqbuf_lastindex + user_len)
> >>>>> +						> ARCMSR_MAX_QBUFFER) {
> >>>>> +						memcpy(pQbuffer, ptmpuserbuffer,
> >>>>> +							ARCMSR_MAX_QBUFFER -
> >>>>> +							acb->wqbuf_lastindex);
> >>>>> +						ptmpuserbuffer +=
> >>>>> +							(ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->wqbuf_lastindex);
> >>>>> +						user_len -= (ARCMSR_MAX_QBUFFER
> >>>>> +							- acb->wqbuf_lastindex);
> >>>>> +						acb->wqbuf_lastindex = 0;
> >>>>> +					} else {
> >>>>> +						memcpy(pQbuffer, ptmpuserbuffer,
> >>>>> +							user_len);
> >>>>> +						acb->wqbuf_lastindex += user_len;
> >>>>> +						acb->wqbuf_lastindex %=
> >>>>> +							ARCMSR_MAX_QBUFFER;
> >>>>> +						user_len = 0;
> >>>>> +					}
> >>>>>  				}
> >>>>> -				if (acb->acb_flags & ACB_F_MESSAGE_WQBUFFER_CLEARED) {
> >>>>> +				if (acb->acb_flags &
> >>>>> +					ACB_F_MESSAGE_WQBUFFER_CLEARED) {
> >>>>>  					acb->acb_flags &=
> >>>>>  						~ACB_F_MESSAGE_WQBUFFER_CLEARED;
> >>>>> -					arcmsr_post_ioctldata2iop(acb);
> >>>>> +					arcmsr_write_ioctldata2iop(acb);
> >>>>>  				}
> >>>>>  			} else {
> >>>>> -				/* has error report sensedata */
> >>>>>  				struct SENSE_DATA *sensebuffer =
> >>>>>  					(struct SENSE_DATA *)cmd->sense_buffer;
> >>>>> -				sensebuffer->ErrorCode = 0x70;
> >>>>> +				/* has error report sensedata */
> >>>>> +				sensebuffer->ErrorCode =
> >>>>> +					SCSI_SENSE_CURRENT_ERRORS;
> >>>>>  				sensebuffer->SenseKey = ILLEGAL_REQUEST;
> >>>>>  				sensebuffer->AdditionalSenseLength = 0x0A;
> >>>>>  				sensebuffer->AdditionalSenseCode = 0x20;
> >>>>>  				sensebuffer->Valid = 1;
> >>>>>  				retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>>  			}
> >>>>> -			}
> >>>>> -			kfree(ver_addr);
> >>>>>  		}
> >>>>> +		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>> +		kfree(ver_addr);
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_CLEAR_RQBUFFER: {
> >>>>>  		uint8_t *pQbuffer = acb->rqbuffer;
> >>>>> -		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> -			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>> -			arcmsr_iop_message_read(acb);
> >>>>> -		}
> >>>>> +
> >>>>> +		arcmsr_clear_iop2drv_rqueue_buffer(acb);
> >>>>> +		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>>  		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
> >>>>>  		acb->rqbuf_firstindex = 0;
> >>>>>  		acb->rqbuf_lastindex = 0;
> >>>>>  		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> -		}
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_CLEAR_WQBUFFER: {
> >>>>>  		uint8_t *pQbuffer = acb->wqbuffer;
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> -			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> -		}
> >>>>> -
> >>>>> -		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> -			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>> -			arcmsr_iop_message_read(acb);
> >>>>> -		}
> >>>>> -		acb->acb_flags |=
> >>>>> -			(ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>>> -				ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> +		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>> +		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>>> +			ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>>  		acb->wqbuf_firstindex = 0;
> >>>>>  		acb->wqbuf_lastindex = 0;
> >>>>>  		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
> >>>>> -		}
> >>>>> +		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_CLEAR_ALLQBUFFER: {
> >>>>>  		uint8_t *pQbuffer;
> >>>>> -
> >>>>> -		if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>>> -			acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>>>> -			arcmsr_iop_message_read(acb);
> >>>>> -		}
> >>>>> -		acb->acb_flags |=
> >>>>> -			(ACB_F_MESSAGE_WQBUFFER_CLEARED
> >>>>> -			| ACB_F_MESSAGE_RQBUFFER_CLEARED
> >>>>> -			| ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> +		arcmsr_clear_iop2drv_rqueue_buffer(acb);
> >>>>> +		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>>> +		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
> >>>>>  		acb->rqbuf_firstindex = 0;
> >>>>>  		acb->rqbuf_lastindex = 0;
> >>>>> -		acb->wqbuf_firstindex = 0;
> >>>>> -		acb->wqbuf_lastindex = 0;
> >>>>>  		pQbuffer = acb->rqbuffer;
> >>>>>  		memset(pQbuffer, 0, sizeof(struct QBUFFER));
> >>>>> +		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>>> +		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>>> +		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>>> +			ACB_F_MESSAGE_WQBUFFER_READED);
> >>>>> +		acb->wqbuf_firstindex = 0;
> >>>>> +		acb->wqbuf_lastindex = 0;
> >>>>>  		pQbuffer = acb->wqbuffer;
> >>>>>  		memset(pQbuffer, 0, sizeof(struct QBUFFER));
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> -		}
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_RETURN_CODE_3F: {
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_3F;
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_3F;
> >>>>>  		break;
> >>>>> -		}
> >>>>> +	}
> >>>>>  	case ARCMSR_MESSAGE_SAY_HELLO: {
> >>>>>  		int8_t *hello_string = "Hello! I am ARCMSR";
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}else{
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> -		}
> >>>>> -		memcpy(pcmdmessagefld->messagedatabuffer, hello_string
> >>>>> -			, (int16_t)strlen(hello_string));
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>> +		memcpy(pcmdmessagefld->messagedatabuffer,
> >>>>> +			hello_string, (int16_t)strlen(hello_string));
> >>>>>  		break;
> >>>>> -
> >>>>> -	case ARCMSR_MESSAGE_SAY_GOODBYE:
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +	}
> >>>>> +	case ARCMSR_MESSAGE_SAY_GOODBYE: {
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		arcmsr_iop_parking(acb);
> >>>>>  		break;
> >>>>> -
> >>>>> -	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE:
> >>>>> -		if(acb->fw_flag == FW_DEADLOCK) {
> >>>>> +	}
> >>>>> +	case ARCMSR_MESSAGE_FLUSH_ADAPTER_CACHE: {
> >>>>> +		if (acb->fw_flag == FW_DEADLOCK)
> >>>>>  			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> -			ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> -		}
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_BUS_HANG_ON;
> >>>>> +		else
> >>>>> +			pcmdmessagefld->cmdmessage.ReturnCode =
> >>>>> +				ARCMSR_MESSAGE_RETURNCODE_OK;
> >>>>>  		arcmsr_flush_adapter_cache(acb);
> >>>>>  		break;
> >>>>> -
> >>>>> +	}
> >>>>>  	default:
> >>>>>  		retvalue = ARCMSR_MESSAGE_FAIL;
> >>>>> +		pr_info("%s: unknown controlcode!\n", __func__);
> >>>>> +	}
> >>>>> +message_out:
> >>>>> +	if (use_sg) {
> >>>>> +		struct scatterlist *sg;
> >>>>> +		sg = scsi_sglist(cmd);
> >>>>> +		kunmap_atomic(buffer - sg->offset);
> >>>>>  	}
> >>>>> -	message_out:
> >>>>> -	sg = scsi_sglist(cmd);
> >>>>> -	kunmap_atomic(buffer - sg->offset);
> >>>>>  	return retvalue;
> >>>>>  }
> >>>>>  
> >>>>>
> >>>>>
> >>>>> --
> >>>>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>>>> the body of a message to majordomo@vger.kernel.org
> >>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >>> This patch is relative to branch:
> >>>
> >>> git://git.infradead.org/users/hch/scsi-queue.git arcmsr-for-3.18
> >>>
> >>> change log:
> >>> 1. rename rqbuf_firstindex to rqbuf_getIndex, rqbuf_lastindex to
> >>> rqbuf_putIndex.
> >>> 2. rename wqbuf_firstindex to wqbuf_getIndex, wqbuf_lastindex to
> >>> wqbuf_putIndex.
> >>> 3. replace 1032 by define ARCMSR_API_DATA_BUFLEN
> >>> 4. remove a NULL pointer checking before kfree.
> >>>
> >>> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> >>> ---
> >>>
> >>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
> >>> --- a/drivers/scsi/arcmsr/arcmsr_attr.c	2014-08-21 12:14:27.000000000 +0800
> >>> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2014-08-25 17:24:54.000000000 +0800
> >>> @@ -78,55 +78,55 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>  	/* do message unit read. */
> >>>  	ptmpQbuffer = (uint8_t *)buf;
> >>>  	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>> -	if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
> >>> -		pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
> >>> -		if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
> >>> -			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex) >= 1032) {
> >>> -				memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>> -				acb->rqbuf_firstindex += 1032;
> >>> -				acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>> -				allxfer_len = 1032;
> >>> +	if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
> >>> +		pQbuffer = &acb->rqbuffer[acb->rqbuf_getIndex];
> >>> +		if (acb->rqbuf_getIndex > acb->rqbuf_putIndex) {
> >>> +			if ((ARCMSR_MAX_QBUFFER - acb->rqbuf_getIndex) >= ARCMSR_API_DATA_BUFLEN) {
> >>> +				memcpy(ptmpQbuffer, pQbuffer, ARCMSR_API_DATA_BUFLEN);
> >>> +				acb->rqbuf_getIndex += ARCMSR_API_DATA_BUFLEN;
> >>> +				acb->rqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
> >>> +				allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  			} else {
> >>> -				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)
> >>> -					+ acb->rqbuf_lastindex) > 1032) {
> >>> +				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_getIndex)
> >>> +					+ acb->rqbuf_putIndex) > ARCMSR_API_DATA_BUFLEN) {
> >>>  					memcpy(ptmpQbuffer, pQbuffer,
> >>>  						ARCMSR_MAX_QBUFFER
> >>> -						- acb->rqbuf_firstindex);
> >>> +						- acb->rqbuf_getIndex);
> >>>  					ptmpQbuffer += ARCMSR_MAX_QBUFFER
> >>> -						- acb->rqbuf_firstindex;
> >>> -					memcpy(ptmpQbuffer, acb->rqbuffer, 1032
> >>> +						- acb->rqbuf_getIndex;
> >>> +					memcpy(ptmpQbuffer, acb->rqbuffer, ARCMSR_API_DATA_BUFLEN
> >>>  						- (ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex));
> >>> -					acb->rqbuf_firstindex = 1032 -
> >>> +						acb->rqbuf_getIndex));
> >>> +					acb->rqbuf_getIndex = ARCMSR_API_DATA_BUFLEN -
> >>>  						(ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex);
> >>> -					allxfer_len = 1032;
> >>> +						acb->rqbuf_getIndex);
> >>> +					allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  				} else {
> >>>  					memcpy(ptmpQbuffer, pQbuffer,
> >>>  						ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex);
> >>> +						acb->rqbuf_getIndex);
> >>>  					ptmpQbuffer += ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex;
> >>> +						acb->rqbuf_getIndex;
> >>>  					memcpy(ptmpQbuffer, acb->rqbuffer,
> >>> -						acb->rqbuf_lastindex);
> >>> +						acb->rqbuf_putIndex);
> >>>  					allxfer_len = ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex +
> >>> -						acb->rqbuf_lastindex;
> >>> -					acb->rqbuf_firstindex =
> >>> -						acb->rqbuf_lastindex;
> >>> +						acb->rqbuf_getIndex +
> >>> +						acb->rqbuf_putIndex;
> >>> +					acb->rqbuf_getIndex =
> >>> +						acb->rqbuf_putIndex;
> >>>  				}
> >>>  			}
> >>>  		} else {
> >>> -			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
> >>> -				memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>> -				acb->rqbuf_firstindex += 1032;
> >>> -				allxfer_len = 1032;
> >>> +			if ((acb->rqbuf_putIndex - acb->rqbuf_getIndex) > ARCMSR_API_DATA_BUFLEN) {
> >>> +				memcpy(ptmpQbuffer, pQbuffer, ARCMSR_API_DATA_BUFLEN);
> >>> +				acb->rqbuf_getIndex += ARCMSR_API_DATA_BUFLEN;
> >>> +				allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  			} else {
> >>> -				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex
> >>> -					- acb->rqbuf_firstindex);
> >>> -				allxfer_len = acb->rqbuf_lastindex -
> >>> -					acb->rqbuf_firstindex;
> >>> -				acb->rqbuf_firstindex = acb->rqbuf_lastindex;
> >>> +				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_putIndex
> >>> +					- acb->rqbuf_getIndex);
> >>> +				allxfer_len = acb->rqbuf_putIndex -
> >>> +					acb->rqbuf_getIndex;
> >>> +				acb->rqbuf_getIndex = acb->rqbuf_putIndex;
> >>>  			}
> >>>  		}
> >>>  	}
> >>> @@ -150,33 +150,33 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>  	struct device *dev = container_of(kobj,struct device,kobj);
> >>>  	struct Scsi_Host *host = class_to_shost(dev);
> >>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
> >>> -	int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
> >>> +	int32_t my_empty_len, user_len, wqbuf_getIndex, wqbuf_putIndex;
> >>>  	uint8_t *pQbuffer, *ptmpuserbuffer;
> >>>  	unsigned long flags;
> >>>  
> >>>  	if (!capable(CAP_SYS_ADMIN))
> >>>  		return -EACCES;
> >>> -	if (count > 1032)
> >>> +	if (count > ARCMSR_API_DATA_BUFLEN)
> >>>  		return -EINVAL;
> >>>  	/* do message unit write. */
> >>>  	ptmpuserbuffer = (uint8_t *)buf;
> >>>  	user_len = (int32_t)count;
> >>>  	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>> -	wqbuf_lastindex = acb->wqbuf_lastindex;
> >>> -	wqbuf_firstindex = acb->wqbuf_firstindex;
> >>> -	if (wqbuf_lastindex != wqbuf_firstindex) {
> >>> +	wqbuf_putIndex = acb->wqbuf_putIndex;
> >>> +	wqbuf_getIndex = acb->wqbuf_getIndex;
> >>> +	if (wqbuf_putIndex != wqbuf_getIndex) {
> >>>  		arcmsr_write_ioctldata2iop(acb);
> >>>  		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>  		return 0;	/*need retry*/
> >>>  	} else {
> >>> -		my_empty_len = (wqbuf_firstindex-wqbuf_lastindex - 1)
> >>> +		my_empty_len = (wqbuf_getIndex-wqbuf_putIndex - 1)
> >>>  			&(ARCMSR_MAX_QBUFFER - 1);
> >>>  		if (my_empty_len >= user_len) {
> >>>  			while (user_len > 0) {
> >>> -				pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
> >>> +				pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
> >>>  				memcpy(pQbuffer, ptmpuserbuffer, 1);
> >>> -				acb->wqbuf_lastindex++;
> >>> -				acb->wqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>> +				acb->wqbuf_putIndex++;
> >>> +				acb->wqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
> >>>  				ptmpuserbuffer++;
> >>>  				user_len--;
> >>>  			}
> >>> @@ -215,12 +215,12 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>  		| ACB_F_MESSAGE_RQBUFFER_CLEARED
> >>>  		| ACB_F_MESSAGE_WQBUFFER_READED);
> >>>  	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>> -	acb->rqbuf_firstindex = 0;
> >>> -	acb->rqbuf_lastindex = 0;
> >>> +	acb->rqbuf_getIndex = 0;
> >>> +	acb->rqbuf_putIndex = 0;
> >>>  	spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>  	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>> -	acb->wqbuf_firstindex = 0;
> >>> -	acb->wqbuf_lastindex = 0;
> >>> +	acb->wqbuf_getIndex = 0;
> >>> +	acb->wqbuf_putIndex = 0;
> >>>  	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>  	pQbuffer = acb->rqbuffer;
> >>>  	memset(pQbuffer, 0, sizeof (struct QBUFFER));
> >>> @@ -234,7 +234,7 @@ static struct bin_attribute arcmsr_sysfs
> >>>  		.name = "mu_read",
> >>>  		.mode = S_IRUSR ,
> >>>  	},
> >>> -	.size = 1032,
> >>> +	.size = ARCMSR_API_DATA_BUFLEN,
> >>>  	.read = arcmsr_sysfs_iop_message_read,
> >>>  };
> >>>  
> >>> @@ -243,7 +243,7 @@ static struct bin_attribute arcmsr_sysfs
> >>>  		.name = "mu_write",
> >>>  		.mode = S_IWUSR,
> >>>  	},
> >>> -	.size = 1032,
> >>> +	.size = ARCMSR_API_DATA_BUFLEN,
> >>>  	.write = arcmsr_sysfs_iop_message_write,
> >>>  };
> >>>  
> >>> diff -uprN a/drivers/scsi/arcmsr/arcmsr.h b/drivers/scsi/arcmsr/arcmsr.h
> >>> --- a/drivers/scsi/arcmsr/arcmsr.h	2014-08-21 12:14:27.000000000 +0800
> >>> +++ b/drivers/scsi/arcmsr/arcmsr.h	2014-08-25 17:25:20.000000000 +0800
> >>> @@ -107,10 +107,11 @@ struct CMD_MESSAGE
> >>>  **        IOP Message Transfer Data for user space
> >>>  *******************************************************************************
> >>>  */
> >>> +#define	ARCMSR_API_DATA_BUFLEN	1032
> >>>  struct CMD_MESSAGE_FIELD
> >>>  {
> >>>      struct CMD_MESSAGE			cmdmessage;
> >>> -    uint8_t				messagedatabuffer[1032];
> >>> +    uint8_t				messagedatabuffer[ARCMSR_API_DATA_BUFLEN];
> >>>  };
> >>>  /* IOP message transfer */
> >>>  #define ARCMSR_MESSAGE_FAIL			0x0001
> >>> @@ -678,15 +679,15 @@ struct AdapterControlBlock
> >>>  	unsigned int				uncache_size;
> >>>  	uint8_t				rqbuffer[ARCMSR_MAX_QBUFFER];
> >>>  	/* data collection buffer for read from 80331 */
> >>> -	int32_t				rqbuf_firstindex;
> >>> +	int32_t				rqbuf_getIndex;
> >>>  	/* first of read buffer  */
> >>> -	int32_t				rqbuf_lastindex;
> >>> +	int32_t				rqbuf_putIndex;
> >>>  	/* last of read buffer   */
> >>>  	uint8_t				wqbuffer[ARCMSR_MAX_QBUFFER];
> >>>  	/* data collection buffer for write to 80331  */
> >>> -	int32_t				wqbuf_firstindex;
> >>> +	int32_t				wqbuf_getIndex;
> >>>  	/* first of write buffer */
> >>> -	int32_t				wqbuf_lastindex;
> >>> +	int32_t				wqbuf_putIndex;
> >>>  	/* last of write buffer  */
> >>>  	uint8_t				devstate[ARCMSR_MAX_TARGETID][ARCMSR_MAX_TARGETLUN];
> >>>  	/* id0 ..... id15, lun0...lun7 */
> >>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_hba.c b/drivers/scsi/arcmsr/arcmsr_hba.c
> >>> --- a/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-21 12:14:27.000000000 +0800
> >>> +++ b/drivers/scsi/arcmsr/arcmsr_hba.c	2014-08-25 17:25:14.000000000 +0800
> >>> @@ -1724,16 +1724,15 @@ arcmsr_Read_iop_rqbuffer_in_DWORD(struct
> >>>  		buf2 = (uint32_t *)buf1;
> >>>  	}
> >>>  	while (iop_len > 0) {
> >>> -		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
> >>> +		pQbuffer = &acb->rqbuffer[acb->rqbuf_putIndex];
> >>>  		*pQbuffer = *buf1;
> >>> -		acb->rqbuf_lastindex++;
> >>> +		acb->rqbuf_putIndex++;
> >>>  		/* if last, index number set it to 0 */
> >>> -		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>> +		acb->rqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
> >>>  		buf1++;
> >>>  		iop_len--;
> >>>  	}
> >>> -	if (buf2)
> >>> -		kfree(buf2);
> >>> +	kfree(buf2);
> >>>  	/* let IOP know data has been read */
> >>>  	arcmsr_iop_message_read(acb);
> >>>  	return 1;
> >>> @@ -1752,10 +1751,10 @@ arcmsr_Read_iop_rqbuffer_data(struct Ada
> >>>  	iop_data = (uint8_t __iomem *)prbuffer->data;
> >>>  	iop_len = readl(&prbuffer->data_len);
> >>>  	while (iop_len > 0) {
> >>> -		pQbuffer = &acb->rqbuffer[acb->rqbuf_lastindex];
> >>> +		pQbuffer = &acb->rqbuffer[acb->rqbuf_putIndex];
> >>>  		*pQbuffer = readb(iop_data);
> >>> -		acb->rqbuf_lastindex++;
> >>> -		acb->rqbuf_lastindex %= ARCMSR_MAX_QBUFFER;
> >>> +		acb->rqbuf_putIndex++;
> >>> +		acb->rqbuf_putIndex %= ARCMSR_MAX_QBUFFER;
> >>>  		iop_data++;
> >>>  		iop_len--;
> >>>  	}
> >>> @@ -1771,7 +1770,7 @@ static void arcmsr_iop2drv_data_wrote_ha
> >>>  
> >>>  	spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>  	prbuffer = arcmsr_get_iop_rqbuffer(acb);
> >>> -	buf_empty_len = (acb->rqbuf_lastindex - acb->rqbuf_firstindex - 1) &
> >>> +	buf_empty_len = (acb->rqbuf_putIndex - acb->rqbuf_getIndex - 1) &
> >>>  		(ARCMSR_MAX_QBUFFER - 1);
> >>>  	if (buf_empty_len >= readl(&prbuffer->data_len)) {
> >>>  		if (arcmsr_Read_iop_rqbuffer_data(acb, prbuffer) == 0)
> >>> @@ -1798,12 +1797,12 @@ static void arcmsr_write_ioctldata2iop_i
> >>>  		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
> >>>  		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
> >>>  		iop_data = (uint32_t __iomem *)pwbuffer->data;
> >>> -		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>> +		while ((acb->wqbuf_getIndex != acb->wqbuf_putIndex)
> >>>  			&& (allxfer_len < 124)) {
> >>> -			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
> >>> +			pQbuffer = &acb->wqbuffer[acb->wqbuf_getIndex];
> >>>  			*buf1 = *pQbuffer;
> >>> -			acb->wqbuf_firstindex++;
> >>> -			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>> +			acb->wqbuf_getIndex++;
> >>> +			acb->wqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
> >>>  			buf1++;
> >>>  			allxfer_len++;
> >>>  		}
> >>> @@ -1841,12 +1840,12 @@ arcmsr_write_ioctldata2iop(struct Adapte
> >>>  		acb->acb_flags &= (~ACB_F_MESSAGE_WQBUFFER_READED);
> >>>  		pwbuffer = arcmsr_get_iop_wqbuffer(acb);
> >>>  		iop_data = (uint8_t __iomem *)pwbuffer->data;
> >>> -		while ((acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>> +		while ((acb->wqbuf_getIndex != acb->wqbuf_putIndex)
> >>>  			&& (allxfer_len < 124)) {
> >>> -			pQbuffer = &acb->wqbuffer[acb->wqbuf_firstindex];
> >>> +			pQbuffer = &acb->wqbuffer[acb->wqbuf_getIndex];
> >>>  			writeb(*pQbuffer, iop_data);
> >>> -			acb->wqbuf_firstindex++;
> >>> -			acb->wqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>> +			acb->wqbuf_getIndex++;
> >>> +			acb->wqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
> >>>  			iop_data++;
> >>>  			allxfer_len++;
> >>>  		}
> >>> @@ -1861,9 +1860,9 @@ static void arcmsr_iop2drv_data_read_han
> >>>  
> >>>  	spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>  	acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_READED;
> >>> -	if (acb->wqbuf_firstindex != acb->wqbuf_lastindex)
> >>> +	if (acb->wqbuf_getIndex != acb->wqbuf_putIndex)
> >>>  		arcmsr_write_ioctldata2iop(acb);
> >>> -	if (acb->wqbuf_firstindex == acb->wqbuf_lastindex)
> >>> +	if (acb->wqbuf_getIndex == acb->wqbuf_putIndex)
> >>>  		acb->acb_flags |= ACB_F_MESSAGE_WQBUFFER_CLEARED;
> >>>  	spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>  }
> >>> @@ -2243,14 +2242,14 @@ void arcmsr_clear_iop2drv_rqueue_buffer(
> >>>  		for (i = 0; i < 15; i++) {
> >>>  			if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>  				acb->acb_flags &= ~ACB_F_IOPDATA_OVERFLOW;
> >>> -				acb->rqbuf_firstindex = 0;
> >>> -				acb->rqbuf_lastindex = 0;
> >>> +				acb->rqbuf_getIndex = 0;
> >>> +				acb->rqbuf_putIndex = 0;
> >>>  				arcmsr_iop_message_read(acb);
> >>>  				mdelay(30);
> >>> -			} else if (acb->rqbuf_firstindex !=
> >>> -				   acb->rqbuf_lastindex) {
> >>> -				acb->rqbuf_firstindex = 0;
> >>> -				acb->rqbuf_lastindex = 0;
> >>> +			} else if (acb->rqbuf_getIndex !=
> >>> +				   acb->rqbuf_putIndex) {
> >>> +				acb->rqbuf_getIndex = 0;
> >>> +				acb->rqbuf_putIndex = 0;
> >>>  				mdelay(30);
> >>>  			} else
> >>>  				break;
> >>> @@ -2291,7 +2290,7 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		unsigned char *ver_addr;
> >>>  		uint8_t *pQbuffer, *ptmpQbuffer;
> >>>  		uint32_t allxfer_len = 0;
> >>> -		ver_addr = kmalloc(1032, GFP_ATOMIC);
> >>> +		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
> >>>  		if (!ver_addr) {
> >>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>  			pr_info("%s: memory not enough!\n", __func__);
> >>> @@ -2299,64 +2298,64 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		}
> >>>  		ptmpQbuffer = ver_addr;
> >>>  		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>> -		if (acb->rqbuf_firstindex != acb->rqbuf_lastindex) {
> >>> -			pQbuffer = &acb->rqbuffer[acb->rqbuf_firstindex];
> >>> -			if (acb->rqbuf_firstindex > acb->rqbuf_lastindex) {
> >>> +		if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
> >>> +			pQbuffer = &acb->rqbuffer[acb->rqbuf_getIndex];
> >>> +			if (acb->rqbuf_getIndex > acb->rqbuf_putIndex) {
> >>>  				if ((ARCMSR_MAX_QBUFFER -
> >>> -					acb->rqbuf_firstindex) >= 1032) {
> >>> -					memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>> -					acb->rqbuf_firstindex += 1032;
> >>> -					acb->rqbuf_firstindex %= ARCMSR_MAX_QBUFFER;
> >>> -					allxfer_len = 1032;
> >>> +					acb->rqbuf_getIndex) >= ARCMSR_API_DATA_BUFLEN) {
> >>> +					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_API_DATA_BUFLEN);
> >>> +					acb->rqbuf_getIndex += ARCMSR_API_DATA_BUFLEN;
> >>> +					acb->rqbuf_getIndex %= ARCMSR_MAX_QBUFFER;
> >>> +					allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  				} else {
> >>>  					if (((ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex) +
> >>> -						acb->rqbuf_lastindex) > 1032) {
> >>> +						acb->rqbuf_getIndex) +
> >>> +						acb->rqbuf_putIndex) > ARCMSR_API_DATA_BUFLEN) {
> >>>  						memcpy(ptmpQbuffer,
> >>>  							pQbuffer, ARCMSR_MAX_QBUFFER
> >>> -							- acb->rqbuf_firstindex);
> >>> +							- acb->rqbuf_getIndex);
> >>>  						ptmpQbuffer +=
> >>>  							ARCMSR_MAX_QBUFFER -
> >>> -							acb->rqbuf_firstindex;
> >>> +							acb->rqbuf_getIndex;
> >>>  						memcpy(ptmpQbuffer,
> >>> -							acb->rqbuffer, 1032 -
> >>> +							acb->rqbuffer, ARCMSR_API_DATA_BUFLEN -
> >>>  							(ARCMSR_MAX_QBUFFER
> >>> -							- acb->rqbuf_firstindex));
> >>> -						acb->rqbuf_firstindex =
> >>> -							1032 - (ARCMSR_MAX_QBUFFER
> >>> -							- acb->rqbuf_firstindex);
> >>> -						allxfer_len = 1032;
> >>> +							- acb->rqbuf_getIndex));
> >>> +						acb->rqbuf_getIndex =
> >>> +							ARCMSR_API_DATA_BUFLEN - (ARCMSR_MAX_QBUFFER
> >>> +							- acb->rqbuf_getIndex);
> >>> +						allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  					} else {
> >>>  						memcpy(ptmpQbuffer,
> >>>  							pQbuffer, ARCMSR_MAX_QBUFFER
> >>> -							- acb->rqbuf_firstindex);
> >>> +							- acb->rqbuf_getIndex);
> >>>  						ptmpQbuffer +=
> >>>  							ARCMSR_MAX_QBUFFER -
> >>> -							acb->rqbuf_firstindex;
> >>> +							acb->rqbuf_getIndex;
> >>>  						memcpy(ptmpQbuffer,
> >>>  							acb->rqbuffer,
> >>> -							acb->rqbuf_lastindex);
> >>> +							acb->rqbuf_putIndex);
> >>>  						allxfer_len = ARCMSR_MAX_QBUFFER
> >>> -							- acb->rqbuf_firstindex +
> >>> -							acb->rqbuf_lastindex;
> >>> -						acb->rqbuf_firstindex =
> >>> -							acb->rqbuf_lastindex;
> >>> +							- acb->rqbuf_getIndex +
> >>> +							acb->rqbuf_putIndex;
> >>> +						acb->rqbuf_getIndex =
> >>> +							acb->rqbuf_putIndex;
> >>>  					}
> >>>  				}
> >>>  			} else {
> >>> -				if ((acb->rqbuf_lastindex -
> >>> -					acb->rqbuf_firstindex) > 1032) {
> >>> -					memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>> -					acb->rqbuf_firstindex += 1032;
> >>> -					allxfer_len = 1032;
> >>> +				if ((acb->rqbuf_putIndex -
> >>> +					acb->rqbuf_getIndex) > ARCMSR_API_DATA_BUFLEN) {
> >>> +					memcpy(ptmpQbuffer, pQbuffer, ARCMSR_API_DATA_BUFLEN);
> >>> +					acb->rqbuf_getIndex += ARCMSR_API_DATA_BUFLEN;
> >>> +					allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>>  				} else {
> >>>  					memcpy(ptmpQbuffer, pQbuffer,
> >>> -						acb->rqbuf_lastindex -
> >>> -						acb->rqbuf_firstindex);
> >>> -					allxfer_len = acb->rqbuf_lastindex
> >>> -						- acb->rqbuf_firstindex;
> >>> -					acb->rqbuf_firstindex =
> >>> -						acb->rqbuf_lastindex;
> >>> +						acb->rqbuf_putIndex -
> >>> +						acb->rqbuf_getIndex);
> >>> +					allxfer_len = acb->rqbuf_putIndex
> >>> +						- acb->rqbuf_getIndex;
> >>> +					acb->rqbuf_getIndex =
> >>> +						acb->rqbuf_putIndex;
> >>>  				}
> >>>  			}
> >>>  		}
> >>> @@ -2382,9 +2381,9 @@ static int arcmsr_iop_message_xfer(struc
> >>>  	}
> >>>  	case ARCMSR_MESSAGE_WRITE_WQBUFFER: {
> >>>  		unsigned char *ver_addr;
> >>> -		int32_t my_empty_len, user_len, wqbuf_firstindex, wqbuf_lastindex;
> >>> +		int32_t my_empty_len, user_len, wqbuf_getIndex, wqbuf_putIndex;
> >>>  		uint8_t *pQbuffer, *ptmpuserbuffer;
> >>> -		ver_addr = kmalloc(1032, GFP_ATOMIC);
> >>> +		ver_addr = kmalloc(ARCMSR_API_DATA_BUFLEN, GFP_ATOMIC);
> >>>  		if (!ver_addr) {
> >>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>  			goto message_out;
> >>> @@ -2394,9 +2393,9 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		memcpy(ptmpuserbuffer,
> >>>  			pcmdmessagefld->messagedatabuffer, user_len);
> >>>  		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>> -		wqbuf_lastindex = acb->wqbuf_lastindex;
> >>> -		wqbuf_firstindex = acb->wqbuf_firstindex;
> >>> -		if (wqbuf_lastindex != wqbuf_firstindex) {
> >>> +		wqbuf_putIndex = acb->wqbuf_putIndex;
> >>> +		wqbuf_getIndex = acb->wqbuf_getIndex;
> >>> +		if (wqbuf_putIndex != wqbuf_getIndex) {
> >>>  			struct SENSE_DATA *sensebuffer =
> >>>  				(struct SENSE_DATA *)cmd->sense_buffer;
> >>>  			arcmsr_write_ioctldata2iop(acb);
> >>> @@ -2408,27 +2407,27 @@ static int arcmsr_iop_message_xfer(struc
> >>>  			sensebuffer->Valid = 1;
> >>>  			retvalue = ARCMSR_MESSAGE_FAIL;
> >>>  		} else {
> >>> -			my_empty_len = (wqbuf_firstindex - wqbuf_lastindex - 1)
> >>> +			my_empty_len = (wqbuf_getIndex - wqbuf_putIndex - 1)
> >>>  				& (ARCMSR_MAX_QBUFFER - 1);
> >>>  			if (my_empty_len >= user_len) {
> >>>  				while (user_len > 0) {
> >>> -					pQbuffer = &acb->wqbuffer[acb->wqbuf_lastindex];
> >>> -					if ((acb->wqbuf_lastindex + user_len)
> >>> +					pQbuffer = &acb->wqbuffer[acb->wqbuf_putIndex];
> >>> +					if ((acb->wqbuf_putIndex + user_len)
> >>>  						> ARCMSR_MAX_QBUFFER) {
> >>>  						memcpy(pQbuffer, ptmpuserbuffer,
> >>>  							ARCMSR_MAX_QBUFFER -
> >>> -							acb->wqbuf_lastindex);
> >>> +							acb->wqbuf_putIndex);
> >>>  						ptmpuserbuffer +=
> >>>  							(ARCMSR_MAX_QBUFFER
> >>> -							- acb->wqbuf_lastindex);
> >>> +							- acb->wqbuf_putIndex);
> >>>  						user_len -= (ARCMSR_MAX_QBUFFER
> >>> -							- acb->wqbuf_lastindex);
> >>> -						acb->wqbuf_lastindex = 0;
> >>> +							- acb->wqbuf_putIndex);
> >>> +						acb->wqbuf_putIndex = 0;
> >>>  					} else {
> >>>  						memcpy(pQbuffer, ptmpuserbuffer,
> >>>  							user_len);
> >>> -						acb->wqbuf_lastindex += user_len;
> >>> -						acb->wqbuf_lastindex %=
> >>> +						acb->wqbuf_putIndex += user_len;
> >>> +						acb->wqbuf_putIndex %=
> >>>  							ARCMSR_MAX_QBUFFER;
> >>>  						user_len = 0;
> >>>  					}
> >>> @@ -2468,8 +2467,8 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		arcmsr_clear_iop2drv_rqueue_buffer(acb);
> >>>  		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>  		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
> >>> -		acb->rqbuf_firstindex = 0;
> >>> -		acb->rqbuf_lastindex = 0;
> >>> +		acb->rqbuf_getIndex = 0;
> >>> +		acb->rqbuf_putIndex = 0;
> >>>  		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
> >>>  		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>  		if (acb->fw_flag == FW_DEADLOCK)
> >>> @@ -2485,8 +2484,8 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>  		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>  			ACB_F_MESSAGE_WQBUFFER_READED);
> >>> -		acb->wqbuf_firstindex = 0;
> >>> -		acb->wqbuf_lastindex = 0;
> >>> +		acb->wqbuf_getIndex = 0;
> >>> +		acb->wqbuf_putIndex = 0;
> >>>  		memset(pQbuffer, 0, ARCMSR_MAX_QBUFFER);
> >>>  		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>  		if (acb->fw_flag == FW_DEADLOCK)
> >>> @@ -2502,16 +2501,16 @@ static int arcmsr_iop_message_xfer(struc
> >>>  		arcmsr_clear_iop2drv_rqueue_buffer(acb);
> >>>  		spin_lock_irqsave(&acb->rqbuffer_lock, flags);
> >>>  		acb->acb_flags |= ACB_F_MESSAGE_RQBUFFER_CLEARED;
> >>> -		acb->rqbuf_firstindex = 0;
> >>> -		acb->rqbuf_lastindex = 0;
> >>> +		acb->rqbuf_getIndex = 0;
> >>> +		acb->rqbuf_putIndex = 0;
> >>>  		pQbuffer = acb->rqbuffer;
> >>>  		memset(pQbuffer, 0, sizeof(struct QBUFFER));
> >>>  		spin_unlock_irqrestore(&acb->rqbuffer_lock, flags);
> >>>  		spin_lock_irqsave(&acb->wqbuffer_lock, flags);
> >>>  		acb->acb_flags |= (ACB_F_MESSAGE_WQBUFFER_CLEARED |
> >>>  			ACB_F_MESSAGE_WQBUFFER_READED);
> >>> -		acb->wqbuf_firstindex = 0;
> >>> -		acb->wqbuf_lastindex = 0;
> >>> +		acb->wqbuf_getIndex = 0;
> >>> +		acb->wqbuf_putIndex = 0;
> >>>  		pQbuffer = acb->wqbuffer;
> >>>  		memset(pQbuffer, 0, sizeof(struct QBUFFER));
> >>>  		spin_unlock_irqrestore(&acb->wqbuffer_lock, flags);
> >>>
> >>>
> >>>
> >>> --
> >>> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> >>> the body of a message to majordomo@vger.kernel.org
> >>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


