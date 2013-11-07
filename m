From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/5] scsi: improved eh timeout handler
Date: Thu, 07 Nov 2013 07:45:27 +0100
Message-ID: <527B3707.9060202@suse.de>
References: <1383635145-112651-1-git-send-email-hare@suse.de> <1383635145-112651-3-git-send-email-hare@suse.de> <527944BF.9000507@cs.wisc.edu> <5279E64E.8040005@suse.de> <527A7AF7.10809@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:43991 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751676Ab3KGGp3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Nov 2013 01:45:29 -0500
In-Reply-To: <527A7AF7.10809@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <jbottomley@parallels.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Ren Mingxin <renmx@cn.fujitsu.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>

On 11/06/2013 06:23 PM, Mike Christie wrote:
> On 11/05/2013 10:48 PM, Hannes Reinecke wrote:
>> On 11/05/2013 08:19 PM, Mike Christie wrote:
>>> On 11/04/2013 11:05 PM, Hannes Reinecke wrote:
>>>> +
>>>> +	scmd->eh_eflags |=3D SCSI_EH_ABORT_SCHEDULED;
>>>> +	SCSI_LOG_ERROR_RECOVERY(3,
>>>> +		scmd_printk(KERN_INFO, scmd,
>>>> +			    "scmd %p abort scheduled\n", scmd));
>>>> +	schedule_delayed_work(&scmd->abort_work, HZ / 100);
>>>> +	return SUCCESS;
>>>> +}
>>>
>>> Do we want to use our own workqueue_struct with WQ_MEM_RECLAIM set?
>>>
>> Errm. Yes, why?
>>
>> I must admit I'm not _that_ familiar with workqueues ...
>> Care to explain?
>>
>=20
> We all share the above workqueue_structs pool of threads, so if we ge=
t
> stuck behind code doing GFP_KERNEL allocs that end up needing to writ=
e
> data to the disk we are now trying to aborts on, then we could get
> stuck. With WQ_MEM_RECLAIM, we have our own backup thread that gets
> created at workqueue_struct create time which can get used in cases l=
ike
> that so we can always make forward progress.
>=20
Ah. Right. Yes, that makes sense.

I guess I'll have to redo the patches _yet again_.

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
