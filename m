From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Tue, 15 Dec 2009 15:16:32 +0200
Message-ID: <4B278C30.9020209@panasas.com>
References: <4B21B143.0@mvista.com> <4B24B962.4070804@panasas.com> <4B26E38C.1000605@mvista.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f221.google.com ([209.85.220.221]:61976 "EHLO
	mail-fx0-f221.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753146AbZLONQi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2009 08:16:38 -0500
Received: by fxm21 with SMTP id 21so4347810fxm.21
        for <linux-scsi@vger.kernel.org>; Tue, 15 Dec 2009 05:16:36 -0800 (PST)
In-Reply-To: <4B26E38C.1000605@mvista.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Min Zhang <mzhang@mvista.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

On 12/15/2009 03:17 AM, Min Zhang wrote:
<snip>

> 
> Boaz, i think your patch will make scsi_request_fn always goto not_ready 
> and skip scsi_dispatch_cmd, because after removing blk_queue_start_tag, 
> subsequent if (blk_queue_tagged(q) && !blk_rq_tagged(req)) is always 
> true. The original blk_queue_start_tag is necessary to set REQ_QUEUE so 
> that blk_rq_tagged check can pass for dispatching. I don't see the other 
> blk_queue_start_tag call.
> 

You're absolutely right. I got mixed up between blk_queue_start_tag && blk_rq_tagged
So I missed the call to blk_queue_start_tag.

> Also timeout failure can still occur after scsi_request_fn unlock the 
> host_lock and before scsi_dispatch_cmd re-lock it.
> 

This was exactly my intention, to do all the things that can fail and the unlocking
then relocking before we start the request. And leave no failing possibility and lock
released between the start of the request and the dispatching. I think it would be wroth it.

But it's your call

Boaz
