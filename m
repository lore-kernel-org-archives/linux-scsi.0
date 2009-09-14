From: Vasu Dev <vasu.dev@linux.intel.com>
Subject: Re: [PATCH 35/35] libfc: adds can_queue ramp up
Date: Mon, 14 Sep 2009 16:23:56 -0700
Message-ID: <1252970636.2231.40.camel@vi2.jf.intel.com>
References: <20090911235655.27223.69728.stgit@localhost.localdomain>
	 <20090912000006.27223.74492.stgit@localhost.localdomain>
	 <4AAE7AEC.4090008@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:40233 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757498AbZINXYJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 19:24:09 -0400
In-Reply-To: <4AAE7AEC.4090008@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Robert Love <robert.w.love@intel.com>, James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>

On Mon, 2009-09-14 at 12:18 -0500, Mike Christie wrote:
> Robert Love wrote:
> > From: Vasu Dev <vasu.dev@intel.com>
> > 
> > Adds last_can_queue_ramp_down_time and updates this on every
> > ramp down. If last_can_queue_ramp_down_time is not zero then
> > do ramp up on any IO completion in added fc_fcp_can_queue_ramp_up.
> > 
> > Reset last_can_queue_ramp_down_time to zero once can_queue
> > is ramped up to added max_can_queue limit, this is to avoid any
> > more ramp up attempts on subsequent IO completion.
> > 
> > The ramp down and up are skipped for FC_CAN_QUEUE_PERIOD
> > to avoid infrequent changes to can_queue, this required
> > keeping track of ramp up time also in last_can_queue_ramp_up_time.
> > 
> > Adds code to ramp down can_queue if lp->qfull is set, with added
> > new ramp up code the can_queue will be increased after
> > FC_CAN_QUEUE_PERIOD, therefore it is safe to do ramp down
> > without fsp in this case and will avoid thrash. This required
> > fc_fcp_can_queue_ramp_down locking change so that it can be
> > called with Scsi_Host lock held.
> > 
> 
> It looks like this could be a more common helper like the sdev ramp 
> up/down code. Software drivers like iscsi_tcp and drivers that do not 
> have hardware cmd limits like ib_iser, srp and cxgb3i could use it. 

Added handlers for can_queue ramp up and down are independent of libfc
code and can be easily moved up to scsi-ml as exported function to be
used by more LLDs. In that case added three new fields for can_queue
needs to be added to Scsi_Host for can_queue down/up tracking. 

- can_queue_ramp_down_time
- can_queue_ramp_up_time
- max_can_queue

I'm fine doing this move now or perhaps can be moved later when more LLD
needs added can_queue ramp up/down handlers here. I'd prefer to do this
move when needed by other LLDs so that their current user libfc would
have this fix now instead blocking on other LLD changes after the move.
However I'm fine either way.

> And 
> I think this what lpfc wants in lpfc_queuecommand when lpfc_get_scsi_buf 
> fails instead of doing lpfc_rampdown_queue_depth.

Yeap, make sense instead of changing queue_depth of all scsi_devices.

	Tahnks
	Vasu

> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

