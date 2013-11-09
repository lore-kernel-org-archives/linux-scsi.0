From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Sat, 09 Nov 2013 16:27:14 +0100
Message-ID: <527E5452.6070109@suse.de>
References: <1383635145-112651-1-git-send-email-hare@suse.de>	 <1383635145-112651-3-git-send-email-hare@suse.de>	 <527944BF.9000507@cs.wisc.edu> <5279E64E.8040005@suse.de>	 <527A7AF7.10809@cs.wisc.edu> <527B3707.9060202@suse.de> <1383986131.18681.15.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752385Ab3KINZQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 9 Nov 2013 08:25:16 -0500
In-Reply-To: <1383986131.18681.15.camel@dabdike>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <jbottomley@parallels.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/09/2013 09:35 AM, James Bottomley wrote:
> On Thu, 2013-11-07 at 07:45 +0100, Hannes Reinecke wrote:
>> On 11/06/2013 06:23 PM, Mike Christie wrote:
>>> On 11/05/2013 10:48 PM, Hannes Reinecke wrote:
>>>> On 11/05/2013 08:19 PM, Mike Christie wrote:
>>>>> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
>>>>>> +
>>>>>> +	scmd->eh_eflags |=3D SCSI_EH_ABORT_SCHEDULED;
>>>>>> +	SCSI_LOG_ERROR_RECOVERY(3,
>>>>>> +		scmd_printk(KERN_INFO, scmd,
>>>>>> +			    "scmd %p abort scheduled\n", scmd));
>>>>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>>>>>> +	return SUCCESS;
>>>>>> +}
>>>>>
>>>>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM se=
t?
>>>>>
>>>> Errm. Yes, why?
>>>>
>>>> I must admit I'm not _that_ familiar with workqueues ...
>>>> Care to explain?
>>>>
>>>
>>> We all share the above workqueue_structs pool of threads, so if we =
get
>>> stuck behind code doing GFP_KERNEL allocs that end up needing to wr=
ite
>>> data to the disk we are now trying to aborts on, then we could get
>>> stuck. With WQ_MEM_RECLAIM, we have our own backup thread that gets
>>> created at workqueue_struct create time which can get used in cases=
 like
>>> that so we can always make forward progress.
>>>
>> Ah. Right. Yes, that makes sense.
>>
>> I guess I'll have to redo the patches _yet again_.
>
> So when were you going to send the redo?  The merge window is now ope=
n
> and Linus was shirty with me about a late merge last time ...
>
Patch is prepared, I'll just have to run a verification on it.
Will be sending the updated patchset on Monday.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
