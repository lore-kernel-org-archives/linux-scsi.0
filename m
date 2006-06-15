From: Michael Reed <mdr@sgi.com>
Subject: Re: [REPOST][PATCH 1/6] mpt fusion - fibre channel target discovery
 prematurely terminates
Date: Thu, 15 Jun 2006 10:39:20 -0500
Message-ID: <44917F28.2010706@sgi.com>
References: <4474BCDE.5050107@sgi.com> <1148924311.3328.5.camel@mulgrave.il.steeleye.com> <44905CAD.4050601@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:22409 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1030633AbWFOPj0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 11:39:26 -0400
In-Reply-To: <44905CAD.4050601@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Reed <mdr@sgi.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, "Moore, Eric Dean" <Eric.Moore@lsil.com>, linux-scsi <linux-scsi@vger.kernel.org>



Michael Reed wrote:
> James Bottomley wrote:
...snip...
> 
> It appears that the order of execution during "lsiutil 99" testing
> has changed.  Once the driver marks the fibre targets missing, they
> never return.  Hmmm....  Until this is resolved, this patch cannot
> be applied.  I'll see if I can sort out how the execution order
> has changed.
> 

I found the problem with the order of execution and it's my own doing.
When I added the setup_reset_work, it can get queued while the
rescan work is running, and THEN the rescan work count can be bumped.
As the rescan work loops on the work count, this changes the exec
order.  Doh.  The second rescan needs to execute after the setup reset
work.

Mike

> 
> 
> Mike
> 
>> James
>>
>> diff --git a/drivers/message/fusion/mptbase.c b/drivers/message/fusion/mptbase.c
>> index a300840..585f42f 100644
>> --- a/drivers/message/fusion/mptbase.c
>> +++ b/drivers/message/fusion/mptbase.c
>> @@ -121,6 +121,11 @@ static int	mpt_base_index = -1;
>>  static int	last_drv_idx = -1;
>>  
>>  static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);
>> +/* This waitq is used for mpt_get_msg_frame failures which may be
>> + * caused either by the ioc->active being zero or by the adapter being
>> + * out of frames.  Receiving this event doesn't guarantee that a frame
>> + * is available, so you must check */
>> +static DECLARE_WAIT_QUEUE_HEAD(mpt_config_waitq);
>>  
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>>  /*
>> @@ -722,6 +727,13 @@ mpt_device_driver_deregister(int cb_idx)
>>  	MptDeviceDriverHandlers[cb_idx] = NULL;
>>  }
>>  
>> +static void
>> +mpt_ioc_activate(MPT_ADAPTER *ioc)
>> +{
>> +	ioc->active = 1;
>> +	wake_up(&mpt_config_waitq);
>> +}
>> +
>>  
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>>  /**
>> @@ -835,6 +847,7 @@ #endif
>>  	mf_dma_addr = (ioc->req_frames_low_dma + req_offset) | ioc->RequestNB[req_idx];
>>  	dsgprintk((MYIOC_s_INFO_FMT "mf_dma_addr=%x req_idx=%d RequestNB=%x\n", ioc->name, mf_dma_addr, req_idx, ioc->RequestNB[req_idx]));
>>  	CHIPREG_WRITE32(&ioc->chip->RequestFifo, mf_dma_addr);
>> +	wake_up(&mpt_config_waitq);
>>  }
>>  
>>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>> @@ -1582,7 +1595,7 @@ mpt_resume(struct pci_dev *pdev)
>>  
>>  	/* enable interrupts */
>>  	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
>> -	ioc->active = 1;
>> +	mpt_ioc_activate(ioc);
>>  
>>  	printk(MYIOC_s_INFO_FMT
>>  		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
>> @@ -1682,7 +1695,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>>  				dprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
>>  						ioc->alt_ioc->name));
>>  				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
>> -				ioc->alt_ioc->active = 1;
>> +				mpt_ioc_activate(ioc->alt_ioc);
>>  			}
>>  
>>  		} else {
>> @@ -1798,7 +1811,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>>  	if (ret == 0) {
>>  		/* Enable! (reply interrupt) */
>>  		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
>> -		ioc->active = 1;
>> +		mpt_ioc_activate(ioc);
>>  	}
>>  
>>  	if (reset_alt_ioc_active && ioc->alt_ioc) {
>> @@ -1806,7 +1819,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>>  		dinitprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
>>  				ioc->alt_ioc->name));
>>  		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
>> -		ioc->alt_ioc->active = 1;
>> +		mpt_ioc_activate(ioc->alt_ioc);
>>  	}
>>  
>>  	/*  Enable MPT base driver management of EventNotification
>> @@ -4069,7 +4082,6 @@ #endif
>>   *	Return: 0 for success
>>   *	-ENOMEM if no memory available
>>   *		-EPERM if not allowed due to ISR context
>> - *		-EAGAIN if no msg frames currently available
>>   *		-EFAULT for non-successful reply or no reply (timeout)
>>   */
>>  static int
>> @@ -4181,7 +4193,6 @@ GetLanConfigPages(MPT_ADAPTER *ioc)
>>   *	Return: 0 for success
>>   *	-ENOMEM if no memory available
>>   *		-EPERM if not allowed due to ISR context
>> - *		-EAGAIN if no msg frames currently available
>>   *		-EFAULT for non-successful reply or no reply (timeout)
>>   */
>>  int
>> @@ -4493,7 +4504,6 @@ mptbase_raid_process_event_data(MPT_ADAP
>>   *	Returns: 0 for success
>>   *	-ENOMEM if no memory available
>>   *		-EPERM if not allowed due to ISR context
>> - *		-EAGAIN if no msg frames currently available
>>   *		-EFAULT for non-successful reply or no reply (timeout)
>>   */
>>  static int
>> @@ -5156,7 +5166,6 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
>>   *
>>   *	Returns 0 for success
>>   *	-EPERM if not allowed due to ISR context
>> - *	-EAGAIN if no msg frames currently available
>>   *	-EFAULT for non-successful reply or no reply (timeout)
>>   */
>>  int
>> @@ -5182,10 +5191,10 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
>>  
>>  	/* Get and Populate a free Frame
>>  	 */
>> -	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
>> +	while ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
>>  		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
>>  				ioc->name));
>> -		return -EAGAIN;
>> +		wait_event(mpt_config_waitq, pCfg->wait_done);
>>  	}
>>  	pReq = (Config_t *)mf;
>>  	pReq->Action = pCfg->action;
>>
>>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
