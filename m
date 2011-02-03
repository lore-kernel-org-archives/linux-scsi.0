From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v5 PATCH 2/4] bnx2fc: Firmware interface and ELS handling
Date: Wed, 02 Feb 2011 21:58:42 -0600
Message-ID: <4D4A27F2.7090502@cs.wisc.edu>
References: <1296266428.268.51.camel@LTLNR-SJCE10.corp.ad.broadcom.com> <4D491744.2020304@cs.wisc.edu> <1296704494.268.549.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:60899 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754971Ab1BCD6V (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 22:58:21 -0500
In-Reply-To: <1296704494.268.549.camel@LTLNR-SJCE10.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "James.Bottomley@suse.de" <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "devel@open-fcoe.org" <devel@open-fcoe.org>, Michael Chan <mchan@broadcom.com>

On 02/02/2011 09:41 PM, Bhanu Gollapudi wrote:
>>
>>> +				spin_unlock_bh(&fps->fp_work_lock);
>>> +
>>> +				/* Pending work request completion */
>>> +				if (fps->iothread&&   work)
>>> +					wake_up_process(fps->iothread);
>>
>>
>> This looks like blk io poll but with a thread instead of a softirq. Use
>> what is in the kernel already.
>
> I'll have to take a look at implementation details of blk io poll. This
> will be a change in IO path, and I'll have to do a lot of testing. So, I
> cannot promise I can do this change in v6 submittal. Probably will stage
> it later.

Did you just add the completion in a thread code? I do not remember it 
being there before.

What is the benefit?

It seems like if you just call bnx2fc_process_cq_compl from here then 
you go from

network driver isr-> wake network soft irq -> network soft irq -> calls 
driver then driver ends up calling bnx2fc_process_new_cqes?

Why do you want to push that to another thread? And then have that 
thread push it to another soft irq (the block irq)?

Are you not supposed to do a lot of work in the network soft irq or did 
I misread the code that this gets run from the network driver isr?
