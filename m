From: Jens Axboe <axboe@suse.de>
Subject: Re: [PATCH] as i/o hang with aacraid driver 2.6.0-test1
Date: Thu, 17 Jul 2003 13:23:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030717112343.GK833@suse.de>
References: <20030716170456.GK833@suse.de> <20030717015756.135a3f5a.akpm@osdl.org> <20030717085952.GX833@suse.de> <3F1672D9.7070309@cyberone.com.au> <20030717102926.GE833@suse.de> <3F167F98.60006@cyberone.com.au> <20030717105718.GG833@suse.de> <3F1683B5.6070108@cyberone.com.au> <20030717111043.GH833@suse.de> <3F1686CF.70201@cyberone.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ns.virtualhost.dk ([195.184.98.160]:26537 "EHLO virtualhost.dk")
	by vger.kernel.org with ESMTP id S271428AbTGQLIz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Jul 2003 07:08:55 -0400
Content-Disposition: inline
In-Reply-To: <3F1686CF.70201@cyberone.com.au>
List-Id: linux-scsi@vger.kernel.org
To: Nick Piggin <piggin@cyberone.com.au>
Cc: Andrew Morton <akpm@osdl.org>, James.Bottomley@steeleye.com, markh@osdl.org, cliffw@osdl.org, linux-scsi@vger.kernel.org

On Thu, Jul 17 2003, Nick Piggin wrote:
> 
> 
> Jens Axboe wrote:
> 
> >On Thu, Jul 17 2003, Nick Piggin wrote:
> >
> >>
> >>Jens Axboe wrote:
> >>
> >>
> >>>On Thu, Jul 17 2003, Nick Piggin wrote:
> >>>
> >>>
> >>>>If the requeue were seperate to the add, it would simply be a call
> >>>>to as_completed_request in as-iosched.c.
> >>>>
> >>>>
> >>>Out of laziness, or what? Just the accounting, not the actual completion
> >>>bits.
> >>>
> >>>
> >>Well no it would have to because it has nothing to associate
> >>the re-add with a re-add and not a new add, if you know what
> >>I mean.
> >>
> >>So it would have to do all the cleanup stuff that
> >>as_completed_request does. Its possible I guess, that we could
> >>set a flag in the as_rq's state field, to say that the request
> >>is a re-add, but thats not very clean IMO.
> >>
> >
> >Wont that possibly cause it to make bad decisions? From AS pov, it looks
> >like an immediate complete of a request. Which it isn't.
> >
> 
> Yeah thats correct - AS assumes elv_add_request is an entirely new
> request from the process point of view, so yeah the quick fix wasn't
> entirely optimal for AS.

But elv_requeue_req_fn gives you the possibility to do it right, just
wondering since you said you'd just make that basically:

as_requeue_req_fn()
{
	as_completed_req();
	as_add_req();
}

which could done a lot better.

-- 
Jens Axboe

