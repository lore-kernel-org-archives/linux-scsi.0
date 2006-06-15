From: Michael Reed <mdr@sgi.com>
Subject: Re: [REPOST][PATCH 1/6] mpt fusion - fibre channel target
Date: Thu, 15 Jun 2006 16:57:39 -0500
Message-ID: <4491D7D3.7070102@sgi.com>
References: <20060615180514.GA17900@lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx2-ext.sgi.com ([192.48.171.19]:966 "EHLO omx2.sgi.com")
	by vger.kernel.org with ESMTP id S1031495AbWFOV5p (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 17:57:45 -0400
In-Reply-To: <20060615180514.GA17900@lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Moore <eric.moore@lsil.com>
Cc: James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org



Eric Moore wrote:
> On Thursday, June 15, 2006 11:50 AM, Michael Reed wrote:
> 
>> There's another problem.  The routines doing the wakeup don't have
>> access to the sleep variable so the thread sleeps forever.
> 
> Mike - I think I addressed all the concerns with this patch, however
> if mpt_config is re-enterant, then all bets are off. Perhaps a mutex
> might work. Pls review and comment.

Hi Eric,

I looked at the changes and they look okay.  I ran them on my
system and was able to induce the ioc->active==0 sleep.
Thread wakes up as expected.  I'm not able to evaluate if
multiple threads will be calling mpt_config() and needing
to sleep at the same time.  Instead of a mutex, perhaps
pass the sleep variable to mpt_config()?  wake up all threads
sleeping?  But, don't know if this is an issue.

I didn't induce out of frame sleep, so the wakeup for that
is untested.

If questions remain, I'll continue looking when I return
from vacation.

Mike

> 
> Eric Moore
> LSI Logic
> 
> 
> 
> diff -uarpN b/drivers/message/fusion/mptbase.c a/drivers/message/fusion/mptbase.c
> --- b/drivers/message/fusion/mptbase.c	2006-06-13 15:56:02.000000000 -0600
> +++ a/drivers/message/fusion/mptbase.c	2006-06-15 11:58:37.000000000 -0600
> @@ -121,6 +121,11 @@ static int	mpt_base_index = -1;
>  static int	last_drv_idx = -1;
>  
>  static DECLARE_WAIT_QUEUE_HEAD(mpt_waitq);
> +/* This waitq is used for mpt_get_msg_frame failures which may be
> + * caused either by the ioc->active being zero or by the adapter being
> + * out of frames.  Receiving this event doesn't guarantee that a frame
> + * is available, so you must check */
> +static DECLARE_WAIT_QUEUE_HEAD(mpt_mf_waitq);
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /*
> @@ -722,6 +727,13 @@ mpt_device_driver_deregister(int cb_idx)
>  	MptDeviceDriverHandlers[cb_idx] = NULL;
>  }
>  
> +static void
> +mpt_ioc_activate(MPT_ADAPTER *ioc)
> +{
> +	ioc->active = 1;
> +	ioc->mf_wait_done = 1;
> +	wake_up(&mpt_mf_waitq);
> +}
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
>  /**
> @@ -851,15 +863,21 @@ void
>  mpt_free_msg_frame(MPT_ADAPTER *ioc, MPT_FRAME_HDR *mf)
>  {
>  	unsigned long flags;
> +	int	freeq_list_empty;
>  
>  	/*  Put Request back on FreeQ!  */
>  	spin_lock_irqsave(&ioc->FreeQlock, flags);
> +	freeq_list_empty = list_empty(&ioc->FreeQ);
>  	mf->u.frame.linkage.arg1 = 0xdeadbeaf; /* signature to know if this mf is freed */
>  	list_add_tail(&mf->u.frame.linkage.list, &ioc->FreeQ);
>  #ifdef MFCNT
>  	ioc->mfcnt--;
>  #endif
>  	spin_unlock_irqrestore(&ioc->FreeQlock, flags);
> +	if (freeq_list_empty) {
> +		ioc->mf_wait_done = 1;
> +		wake_up(&mpt_mf_waitq);
> +	}
>  }
>  
>  /*=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*/
> @@ -1544,7 +1562,7 @@ mpt_resume(struct pci_dev *pdev)
>  
>  	/* enable interrupts */
>  	CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
> -	ioc->active = 1;
> +	mpt_ioc_activate(ioc);
>  
>  	printk(MYIOC_s_INFO_FMT
>  		"pci-resume: ioc-state=0x%x,doorbell=0x%x\n",
> @@ -1645,7 +1663,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  				dprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
>  						ioc->alt_ioc->name));
>  				CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
> -				ioc->alt_ioc->active = 1;
> +				mpt_ioc_activate(ioc->alt_ioc);
>  			}
>  
>  		} else {
> @@ -1803,7 +1821,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  	if (ret == 0) {
>  		/* Enable! (reply interrupt) */
>  		CHIPREG_WRITE32(&ioc->chip->IntMask, MPI_HIM_DIM);
> -		ioc->active = 1;
> +		mpt_ioc_activate(ioc);
>  	}
>  
>  	if (reset_alt_ioc_active && ioc->alt_ioc) {
> @@ -1811,7 +1829,7 @@ mpt_do_ioc_recovery(MPT_ADAPTER *ioc, u3
>  		dinitprintk((KERN_INFO MYNAM ": alt-%s reply irq re-enabled\n",
>  				ioc->alt_ioc->name));
>  		CHIPREG_WRITE32(&ioc->alt_ioc->chip->IntMask, MPI_HIM_DIM);
> -		ioc->alt_ioc->active = 1;
> +		mpt_ioc_activate(ioc->alt_ioc);
>  	}
>  
>  	/*  Enable MPT base driver management of EventNotification
> @@ -4072,7 +4090,6 @@ WaitForDoorbellReply(MPT_ADAPTER *ioc, i
>   *	Return: 0 for success
>   *	-ENOMEM if no memory available
>   *		-EPERM if not allowed due to ISR context
> - *		-EAGAIN if no msg frames currently available
>   *		-EFAULT for non-successful reply or no reply (timeout)
>   */
>  static int
> @@ -4394,7 +4411,6 @@ mptbase_raid_process_event_data(MPT_ADAP
>   *	Returns: 0 for success
>   *	-ENOMEM if no memory available
>   *		-EPERM if not allowed due to ISR context
> - *		-EAGAIN if no msg frames currently available
>   *		-EFAULT for non-successful reply or no reply (timeout)
>   */
>  static int
> @@ -5057,7 +5073,6 @@ SendEventAck(MPT_ADAPTER *ioc, EventNoti
>   *
>   *	Returns 0 for success
>   *	-EPERM if not allowed due to ISR context
> - *	-EAGAIN if no msg frames currently available
>   *	-EFAULT for non-successful reply or no reply (timeout)
>   */
>  int
> @@ -5083,10 +5098,11 @@ mpt_config(MPT_ADAPTER *ioc, CONFIGPARMS
>  
>  	/* Get and Populate a free Frame
>  	 */
> -	if ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
> +	while ((mf = mpt_get_msg_frame(mpt_base_index, ioc)) == NULL) {
>  		dcprintk((MYIOC_s_WARN_FMT "mpt_config: no msg frames!\n",
>  				ioc->name));
> -		return -EAGAIN;
> +		ioc->mf_wait_done = 0;
> +		wait_event(mpt_mf_waitq, ioc->mf_wait_done);
>  	}
>  	pReq = (Config_t *)mf;
>  	pReq->Action = pCfg->action;
> diff -uarpN b/drivers/message/fusion/mptbase.h a/drivers/message/fusion/mptbase.h
> --- b/drivers/message/fusion/mptbase.h	2006-06-13 15:56:02.000000000 -0600
> +++ a/drivers/message/fusion/mptbase.h	2006-06-15 11:48:58.000000000 -0600
> @@ -602,6 +602,7 @@ typedef struct _MPT_ADAPTER
>  	FCPortPage0_t		 fc_port_page0[2];
>  	struct timer_list	 persist_timer;	/* persist table timer */
>  	int			 persist_wait_done; /* persist completion flag */
> +	int			 mf_wait_done;
>  	u8			 persist_reply_frame[MPT_DEFAULT_FRAME_SIZE]; /* persist reply */
>  	LANPage0_t		 lan_cnfg_page0;
>  	LANPage1_t		 lan_cnfg_page1;
> 
