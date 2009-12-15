From: Min Zhang <mzhang@mvista.com>
Subject: Re: [PATCH] scsi: timeout reset timer before command is queued
Date: Tue, 15 Dec 2009 12:53:42 -0800
Message-ID: <4B27F756.3040206@mvista.com>
References: <4B21B143.0@mvista.com> <4B24B962.4070804@panasas.com> <4B26E38C.1000605@mvista.com> <4B278C30.9020209@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hu47.mvista.com ([206.112.117.47]:40037 "HELO
	gateway-1237.mvista.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with SMTP id S933266AbZLOUxr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Dec 2009 15:53:47 -0500
In-Reply-To: <4B278C30.9020209@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Tejun Heo <tj@kernel.org>, James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org

Boaz Harrosh wrote:
>> Also timeout failure can still occur after scsi_request_fn unlock the 
>> host_lock and before scsi_dispatch_cmd re-lock it.
>>
>>     
>
> This was exactly my intention, to do all the things that can fail and the unlocking
> then relocking before we start the request. And leave no failing possibility and lock
> released between the start of the request and the dispatching. I think it would be wroth it.
>
> But it's your call
>
> Boaz
>   
How do you leave no failing possibility? As long as there is unlock and 
then relocking, it is unsafe since timeout could occur right between. 
Unless you meant hold the lock entirely but your patch didn't show.

e.g. the following scsi_request_fn() cmd could be a corrupt point 
already. I thought about removing this unlock call, but 
scsi_dispatch_cmd has this sleep call  need to hack around. 

        /*
         * XXX(hch): This is rather suboptimal, scsi_dispatch_cmd will
         *        take the lock again.
         */
        spin_unlock_irq(shost->host_lock);
        scsi_init_cmd_errh(cmd);

My other wish is to delay the start of timer until command is queued, 
but that has to change upper layer blk_start_request and might change 
entire block layer algorithm, too much impact on the other driver that 
use it.

