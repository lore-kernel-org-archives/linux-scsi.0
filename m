From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 21:09:41 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1683F5.4030107@cyberone.com.au>
References: <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au> <20030717105641.GF833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-246-41.webone.com.au ([210.9.246.41]:6669 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S271420AbTGQKzD
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:55:03 -0400
In-Reply-To: <20030717105641.GF833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, markh@osdl.org, cliffw@osdl.org, linux-scsi@vger.kernel.org



Jens Axboe wrote:

>On Thu, Jul 17 2003, Nick Piggin wrote:
>
>>
>>Jens Axboe wrote:
>>
>>
>>>On Thu, Jul 17 2003, Nick Piggin wrote:
>>>
>>>
>>>>Jens Axboe wrote:
>>>>
>>>>
>>>>
>>>>>On Thu, Jul 17 2003, Andrew Morton wrote:
>>>>>
>>>>>
>>>>>
>>>>>>So this is what I ended up with.  Could we please have confirmation 
>>>>>>that it
>>>>>>fixes the aacraid hang?
>>>>>>
>>>>>>
>>>>>>
>>>>>It doesn't, it's just a pre-requisite to fixing the bug :-)
>>>>>
>>>>>Nick should chime in with how we wants it to be handled from
>>>>>blk_requeue_request(), he needs to decrease dispatched from there. We
>>>>>could always add some hook for it of course, but...
>>>>>
>>>>>
>>>>>
>>>>Well you could just put an elv_completed_request in there, but
>>>>
>>>>
>>>Yeah, I told Andrew to add that for now.
>>>
>>>
>>>
>>>>I suppose it really wants an elv_requeue_request - which would
>>>>just default to elv_add_request for other schedulers.
>>>>
>>>>
>>>I'd rather keep it seperate, ie just a requeue notifier. How's this?
>>>
>>>
>>Well it would be much nicer for AS if it were seperate. Basically
>>AS wants the requeue implemented as as_add_request but without
>>the accounting updates: there has been no request completed, and
>>no really new request.
>>
>>If the requeue were seperate to the add, it would simply be a call
>>to as_completed_request in as-iosched.c.
>>
>
>Like this then? Nicer semantics, too.
>

Jens, this is exactly right. Would you be OK with this? Everyone else?

