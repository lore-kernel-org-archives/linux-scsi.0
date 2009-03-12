From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add SCSI FCP handling
Date: Thu, 12 Mar 2009 15:27:35 -0500
Message-ID: <49B97037.7040206@cs.wisc.edu>
References: <20090228022152.12158.11200.stgit@feynman.nuovasystems.com> <20090228023158.12158.63925.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:51664 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751638AbZCLU14 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Mar 2009 16:27:56 -0400
In-Reply-To: <20090228023158.12158.63925.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Abhijeet Joglekar <abjoglek@cisco.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, jeykholt@cisco.com

Abhijeet Joglekar wrote:
> +
> +struct fcpio_lunmap_tbl {
> +	u32                   update_cnt;
> +	struct fcpio_lunmap_entry   lunmaps[FCPIO_LUNMAP_TABLE_SIZE];
> +};


I think this is not used now. You can delete the code related to it.


> +
> +/*
> + * fnic_fcpio_flogi_reg_cmpl_handler
> + * Routine to handle flogi register completion
> + */
> +static int fnic_fcpio_flogi_reg_cmpl_handler(struct fnic *fnic,
> +					     struct fcpio_fw_req *desc)
> +{
> +	u8 type;
> +	u8 hdr_status;
> +	struct fcpio_tag tag;
> +	struct fnic_event *event;
> +	int ret = 0;
> +	struct fc_frame *flogi_resp = NULL;
> +	unsigned long flags;
> +
> +	fcpio_header_dec(&desc->hdr, &type, &hdr_status, &tag);
> +
> +	/* Update fnic state based on status of flogi reg completion */
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +
> +	flogi_resp = fnic->flogi_resp;
> +	fnic->flogi_resp = NULL;
> +
> +	if (fnic->state == FNIC_IN_ETH_TRANS_FC_MODE) {
> +
> +		/* Check flogi registration completion status */
> +		if (!hdr_status) {
> +			FNIC_SCSI_DBG(KERN_DEBUG, DFX "flog reg succeeded\n",
> +				      fnic->fnic_no);
> +			fnic->state = FNIC_IN_FC_MODE;
> +		} else {
> +			FNIC_SCSI_DBG(KERN_DEBUG,
> +				      DFX "fnic flogi reg :failed %s\n",
> +				      fnic->fnic_no,
> +				      fnic_fcpio_status_to_str(hdr_status));
> +			fnic->state = FNIC_IN_ETH_MODE;
> +			ret = -1;
> +		}
> +	} else {
> +		FNIC_SCSI_DBG(KERN_DEBUG, DFX "Unexpected fnic state %s while"
> +			      " processing flogi reg completion\n",
> +			      fnic->fnic_no, fnic_state_to_str(fnic->state));
> +		ret = -1;
> +	}
> +
> +	/* Successful flogi reg cmpl, pass frame to LibFC */
> +	if (!ret && flogi_resp) {
> +		if (fnic->stop_rx_link_events) {
> +			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +			goto reg_cmpl_handler_end;
> +		}
> +
> +		event = kmem_cache_alloc(fnic_ev_cache, GFP_ATOMIC);
> +
> +		if (!event) {
> +			spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +			dev_kfree_skb_irq(fp_skb(flogi_resp));
> +			ret = -1;
> +			goto reg_cmpl_handler_end;
> +		}
> +
> +		memset(event, 0, sizeof(struct fnic_event));
> +
> +		/* initialize the event structure */
> +		event->fp = flogi_resp;
> +		fr_dev(flogi_resp) = fnic->lport;
> +		event->fnic = fnic;
> +		event->ev_type = EV_TYPE_FRAME;
> +		event->is_flogi_resp_frame = 1;
> +		fnic->event_count++;
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +		/* insert it into event queue */
> +		INIT_WORK(&event->event_work, fnic_event_work);
> +		queue_work(fnic_event_queue, &event->event_work);
> +
> +	} else {
> +		spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +		if (flogi_resp)
> +			dev_kfree_skb_irq(fp_skb(flogi_resp));
> +	}
> +
> +reg_cmpl_handler_end:
> +	return ret;
> +}



What happens if this fails? Is this run when we relogin? It seems 
dangerous if there is memory pressure, pages were getting written out to 
this driver to free up mem, and if something bad happened  and we had 
to relogin. If it fails are we stuck? Will something figure this out and 
retry? What about preallacting one event for this? Would that work? Or 
what about allocating the event in the fnic then just queueing the work 
here.

Block/scsi driver/code preallocate pretty much everything they need to 
make forward progress on at least one request. For relogin like this 
though, it seems like some drivers/code does not care, or we are getting 
careless or it is a lot of work and ugly code to make it work. So I am 
not sure if you have to handle the allocation failure here or not. Maybe 
we just have to do this in the main IO path.


> +
> +void fnic_empty_scsi_cleanup(struct fc_lport *lp)
> +{
> +}
> +


This is kind of odd. I guess I will leave it to you and Rob to discuss 
if that is how libfc is supposed to be used or if libfc should be 
modified to handle where you do not want the callout and do not want the 
default libfc gives you.
