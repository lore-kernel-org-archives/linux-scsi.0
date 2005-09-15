From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [2.6.14-rc1] sym scsi boot hang
Date: Thu, 15 Sep 2005 10:13:16 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509151006290.4942-100000@iolanthe.rowland.org>
References: <1126792573.4821.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:63896 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP id S965186AbVIOONR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 10:13:17 -0400
In-Reply-To: <1126792573.4821.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Anton Blanchard <anton@samba.org>, Dipankar Sarma <dipankar@in.ibm.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 15 Sep 2005, James Bottomley wrote:

> On Wed, 2005-09-14 at 17:33 -0400, Alan Stern wrote:
> > On Wed, 14 Sep 2005, James Bottomley wrote:
> > > Yes ... really the only case for unprep is when we've partially released
> > > the command (like in scsi_io_completion) where we need to tear the rest
> > > of it down.
> > 
> > In other words, in scsi_requeue_command and nowhere else.
> 
> Pretty much, yes.
> 
> > Or will be prepared for the first time, as in scsi_execute.  As far as I 
> > can tell, a new struct request is not set to all 0's.  So if you queue a 
> > request with REQ_SPECIAL set and you fail to clear req->special, you're in 
> > trouble.  Do you have any idea why this hasn't been causing errors all 
> > along?
> 
> That's true, it's not.  However ll_rq_blk.c:rq_init() clears req-
> >special (and initialises all other important fields).

(*Sigh*...  I'm trying to do this too fast, not following up properly on 
all the code paths.)  Okay, good, glad to hear it.

> > Okay, then how does this patch look (moved the routine over to where it 
> > gets used, plus two real changes)?
> 
> Well ... under pressure to fix this in -mm, I already commited a version
> to rc-fixes.  What I did was fully reverse the changes to the
> scsi_insert_queue() [the patch I sent Anton].  We can move the unprep
> function if you feel strongly about it, but I'm also happy to keep it
> where it is.

I don't care where the function goes, so just leave it.

That leaves only the question of the call to scsi_unprep_request near the 
end of scsi_request_fn, in the not_ready: section.  Looks like that call 
isn't needed and can be taken out also, do you agree?

Alan Stern

