From: Nick Piggin <piggin@cyberone.com.au>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 21:08:37 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3F1683B5.6070108@cyberone.com.au>
References: <20030716124549.GX833@suse.de> <1058360162.1850.15.camel@mulgrave> <20030716132036.GB833@suse.de> <1058364455.1856.28.camel@mulgrave> <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au> <20030717105718.GG833@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dyn-ctb-210-9-246-41.webone.com.au ([210.9.246.41]:5389 "EHLO
	chimp.local.net") by vger.kernel.org with ESMTP id S271419AbTGQKyA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 06:54:00 -0400
In-Reply-To: <20030717105718.GG833@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, markh@osdl.org, cliffw@osdl.org, linux-scsi@vger.kernel.org



Jens Axboe wrote:

>On Thu, Jul 17 2003, Nick Piggin wrote:
>
>>If the requeue were seperate to the add, it would simply be a call
>>to as_completed_request in as-iosched.c.
>>
>
>Out of laziness, or what? Just the accounting, not the actual completion
>bits.
>

Well no it would have to because it has nothing to associate
the re-add with a re-add and not a new add, if you know what
I mean.

So it would have to do all the cleanup stuff that
as_completed_request does. Its possible I guess, that we could
set a flag in the as_rq's state field, to say that the request
is a re-add, but thats not very clean IMO.

