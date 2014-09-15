From: Ching Huang <ching2048@areca.com.tw>
Subject: Re: [PATCH v4 1/2] arcmsr: simplify ioctl data read/write
Date: Mon, 15 Sep 2014 18:36:55 +0800
Message-ID: <1410777415.4774.3.camel@Centos6.3-64>
References: <1410506960.5045.250.camel@Centos6.3-64>
	 <5412F680.2070702@redhat.com> <1410749808.4764.5.camel@Centos6.3-64>
	 <5416BE99.3000409@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:55179 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602AbaIOKhE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Sep 2014 06:37:04 -0400
Received: by mail-pa0-f52.google.com with SMTP id kq14so6053051pab.11
        for <linux-scsi@vger.kernel.org>; Mon, 15 Sep 2014 03:37:03 -0700 (PDT)
In-Reply-To: <5416BE99.3000409@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com, agordeev@redhat.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Mon, 2014-09-15 at 12:25 +0200, Tomas Henzl wrote:
> On 09/15/2014 04:56 AM, Ching Huang wrote:
> > On Fri, 2014-09-12 at 15:34 +0200, Tomas Henzl wrote:
> >> On 09/12/2014 09:29 AM, Ching Huang wrote:
> >>> From: Ching Huang <ching2048@areca.com.tw>
> >>>
> >>> This patch is to modify previous patch 13/17 and it is relative to
> >>> http://git.infradead.org/users/hch/scsi-queue.git/tree/arcmsr-for-3.18:/drivers/scsi/arcmsr
> >>>
> >>> change in v4:
> >>> 1. for readability, rename firstindex to getIndex, rename lastindex to putIndex
> >> For some reason, the names head+tail areusual for a circular buffer.
> >> But let us ignore the names, I don't care.
> >>> 2. define ARCMSR_API_DATA_BUFLEN as 1032
> >>> 3. simplify ioctl data read by macro CIRC_CNT_TO_END and CIRC_CNT
> >> It's definitely better when you post renames and other non-functional changes in separate
> >> patches, it's easier for the reviewer. 
> >>> Signed-off-by: Ching Huang <ching2048@areca.com.tw>
> >>> ---
> >>>
> >>> diff -uprN a/drivers/scsi/arcmsr/arcmsr_attr.c b/drivers/scsi/arcmsr/arcmsr_attr.c
> >>> --- a/drivers/scsi/arcmsr/arcmsr_attr.c	2014-08-21 12:14:27.000000000 +0800
> >>> +++ b/drivers/scsi/arcmsr/arcmsr_attr.c	2014-09-12 15:18:46.659125000 +0800
> >>> @@ -50,6 +50,7 @@
> >>>  #include <linux/errno.h>
> >>>  #include <linux/delay.h>
> >>>  #include <linux/pci.h>
> >>> +#include <linux/circ_buf.h>
> >>>  
> >>>  #include <scsi/scsi_cmnd.h>
> >>>  #include <scsi/scsi_device.h>
> >>> @@ -68,7 +69,7 @@ static ssize_t arcmsr_sysfs_iop_message_
> >>>  	struct device *dev = container_of(kobj,struct device,kobj);
> >>>  	struct Scsi_Host *host = class_to_shost(dev);
> >>>  	struct AdapterControlBlock *acb = (struct AdapterControlBlock *) host->hostdata;
> >>> -	uint8_t *pQbuffer,*ptmpQbuffer;
> >>> +	uint8_t *ptmpQbuffer;
> >>>  	int32_t allxfer_len = 0;
> >>>  	unsigned long flags;
> >>>  
> >>> @@ -78,57 +79,22 @@ static ssize_t arcmsr_sysfs_iop_message_
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
> >>> -			} else {
> >>> -				if (((ARCMSR_MAX_QBUFFER - acb->rqbuf_firstindex)
> >>> -					+ acb->rqbuf_lastindex) > 1032) {
> >>> -					memcpy(ptmpQbuffer, pQbuffer,
> >>> -						ARCMSR_MAX_QBUFFER
> >>> -						- acb->rqbuf_firstindex);
> >>> -					ptmpQbuffer += ARCMSR_MAX_QBUFFER
> >>> -						- acb->rqbuf_firstindex;
> >>> -					memcpy(ptmpQbuffer, acb->rqbuffer, 1032
> >>> -						- (ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex));
> >>> -					acb->rqbuf_firstindex = 1032 -
> >>> -						(ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex);
> >>> -					allxfer_len = 1032;
> >>> -				} else {
> >>> -					memcpy(ptmpQbuffer, pQbuffer,
> >>> -						ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex);
> >>> -					ptmpQbuffer += ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex;
> >>> -					memcpy(ptmpQbuffer, acb->rqbuffer,
> >>> -						acb->rqbuf_lastindex);
> >>> -					allxfer_len = ARCMSR_MAX_QBUFFER -
> >>> -						acb->rqbuf_firstindex +
> >>> -						acb->rqbuf_lastindex;
> >>> -					acb->rqbuf_firstindex =
> >>> -						acb->rqbuf_lastindex;
> >>> -				}
> >>> -			}
> >>> -		} else {
> >>> -			if ((acb->rqbuf_lastindex - acb->rqbuf_firstindex) > 1032) {
> >>> -				memcpy(ptmpQbuffer, pQbuffer, 1032);
> >>> -				acb->rqbuf_firstindex += 1032;
> >>> -				allxfer_len = 1032;
> >>> -			} else {
> >>> -				memcpy(ptmpQbuffer, pQbuffer, acb->rqbuf_lastindex
> >>> -					- acb->rqbuf_firstindex);
> >>> -				allxfer_len = acb->rqbuf_lastindex -
> >>> -					acb->rqbuf_firstindex;
> >>> -				acb->rqbuf_firstindex = acb->rqbuf_lastindex;
> >>> -			}
> >>> +	if (acb->rqbuf_getIndex != acb->rqbuf_putIndex) {
> >>> +		unsigned int tail = acb->rqbuf_getIndex;
> >>> +		unsigned int head = acb->rqbuf_putIndex;
> >>> +		unsigned int cnt_to_end = CIRC_CNT_TO_END(head, tail, ARCMSR_MAX_QBUFFER);
> >>> +
> >>> +		allxfer_len = CIRC_CNT(head, tail, ARCMSR_MAX_QBUFFER);
> >>> +		if (allxfer_len > ARCMSR_API_DATA_BUFLEN)
> >>> +			allxfer_len = ARCMSR_API_DATA_BUFLEN;
> >>> +
> >>> +		if (allxfer_len <= cnt_to_end)
> >>> +			memcpy(ptmpQbuffer, acb->rqbuffer + tail, allxfer_len);
> >>> +		else {
> >>> +			memcpy(ptmpQbuffer, acb->rqbuffer + tail, cnt_to_end);
> >>> +			memcpy(ptmpQbuffer + cnt_to_end, acb->rqbuffer, allxfer_len - cnt_to_end);
> >>>  		}
> >>> +		acb->rqbuf_getIndex = (acb->rqbuf_getIndex + allxfer_len) % ARCMSR_MAX_QBUFFER;
> >>>  	}
> >>>  	if (acb->acb_flags & ACB_F_IOPDATA_OVERFLOW) {
> >>>  		struct QBUFFER __iomem *prbuffer;
> >>> @@ -150,33 +116,32 @@ static ssize_t arcmsr_sysfs_iop_message_
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
> >>> -			&(ARCMSR_MAX_QBUFFER - 1);
> >>> +		my_empty_len = ARCMSR_MAX_QBUFFER - 1;
> >> This^ doesn't look like like an rename can you explain?
> > It is just a code simplification.
> 
> Yes it is of some kind. But I think it's also a bug, because you have replaced
> 'firstindex - lastindex' with nothing.
It will be not a bug. At here, firstindex == lastindex, so firstindex-lastindex is 0
> 
> >> Let us stop here, or we end in an endless loop of corrections. The original 13/17
> >> you are trying to improve here was at least without bugs (better said I haven't noticed) so
> >> improving it now only complicates the process.
> >> My suggestion is -let us skip this patch and focus only on fixing the spinlock problem found in 16/17.
> >> OKay?
> > Agree.
> >> Cheers,
> >> Tomas
> >>
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


