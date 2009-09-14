From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 35/35] libfc: adds can_queue ramp up
Date: Mon, 14 Sep 2009 12:18:36 -0500
Message-ID: <4AAE7AEC.4090008@cs.wisc.edu>
References: <20090911235655.27223.69728.stgit@localhost.localdomain> <20090912000006.27223.74492.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:38568 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755719AbZINRSl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Sep 2009 13:18:41 -0400
In-Reply-To: <20090912000006.27223.74492.stgit@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robert Love <robert.w.love@intel.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, Vasu Dev <vasu.dev@intel.com>

Robert Love wrote:
> From: Vasu Dev <vasu.dev@intel.com>
> 
> Adds last_can_queue_ramp_down_time and updates this on every
> ramp down. If last_can_queue_ramp_down_time is not zero then
> do ramp up on any IO completion in added fc_fcp_can_queue_ramp_up.
> 
> Reset last_can_queue_ramp_down_time to zero once can_queue
> is ramped up to added max_can_queue limit, this is to avoid any
> more ramp up attempts on subsequent IO completion.
> 
> The ramp down and up are skipped for FC_CAN_QUEUE_PERIOD
> to avoid infrequent changes to can_queue, this required
> keeping track of ramp up time also in last_can_queue_ramp_up_time.
> 
> Adds code to ramp down can_queue if lp->qfull is set, with added
> new ramp up code the can_queue will be increased after
> FC_CAN_QUEUE_PERIOD, therefore it is safe to do ramp down
> without fsp in this case and will avoid thrash. This required
> fc_fcp_can_queue_ramp_down locking change so that it can be
> called with Scsi_Host lock held.
> 

It looks like this could be a more common helper like the sdev ramp 
up/down code. Software drivers like iscsi_tcp and drivers that do not 
have hardware cmd limits like ib_iser, srp and cxgb3i could use it. And 
I think this what lpfc wants in lpfc_queuecommand when lpfc_get_scsi_buf 
fails instead of doing lpfc_rampdown_queue_depth.
