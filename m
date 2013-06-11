From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 3/9] scsi: improved eh timeout handler
Date: Tue, 11 Jun 2013 20:54:49 +0000
Message-ID: <1370984086.2286.82.camel@dabdike>
References: <1370850058-27613-1-git-send-email-hare@suse.de>
	 <1370850058-27613-4-git-send-email-hare@suse.de>
	 <20130610082001.GB7816@infradead.org>  <1370977067.2286.81.camel@dabdike>
	 <1370983317.3319.918.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:43355 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab3FKUy4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jun 2013 16:54:56 -0400
In-Reply-To: <1370983317.3319.918.camel@localhost.localdomain>
Content-Language: en-US
Content-ID: <D149ADDDCA1040409F18C6D696DC81A9@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "emilne@redhat.com" <emilne@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, Hannes Reinecke <hare@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>

On Tue, 2013-06-11 at 16:41 -0400, Ewan Milne wrote:
> On Tue, 2013-06-11 at 18:57 +0000, James Bottomley wrote:
> > On Mon, 2013-06-10 at 01:20 -0700, Christoph Hellwig wrote:
> > > On Mon, Jun 10, 2013 at 09:40:52AM +0200, Hannes Reinecke wrote:
> > > > When a command runs into a timeout we need to send an 'ABORT TASK'
> > > > TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
> > > > 
> > > > Conceptually, however, this function is a normal SCSI command, so
> > > > there is no need to enter the error handler.
> > > > 
> > > > This patch implements a new scsi_abort_command() function which
> > > > invokes an asynchronous function scsi_eh_abort_handler() to
> > > > abort the commands via 'eh_abort_handler'.
> > > > 
> > > > If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
> > > > command will be retried if possible. If no retries are allowed
> > > > the command will be returned immediately, as we have to assume
> > > > the TMF succeeded and the command is completed with the LLDD.
> > > > If the TMF fails the command will be pushed back onto the
> > > > list of failed commands and the SCSI EH handler will be
> > > > called immediately for all timed-out commands.
> > > 
> > > Why can't we use a work item per command?  Linking things into a list
> > > just to queue it up to workqueues missed half of the point of the
> > > workqueue infrastructure.
> > 
> > Actually, I think we can dump the workqueue altogether.  The only reason
> > we need it is because the current abort handlers wait for the command
> > and return the completion state.  However, all LLDs are capable of
> > emitting TMFs at interrupt level, so if we separated the emit from the
> > wait, we could simply do this sequence:
> > 
> > on timeout, fire the abort from interrupt and mark the command as having
> > an abort issued (possibly by adding a pointer to the abort task), return
> > BLK_EH_RESET_TIMER.
> 
> Doesn't this cause blk_rq_timed_out to reset the timer on the req to
> the original timeout value again?  It seems like this would increase
> the time before any further attempted error handling.  The default
> timeout is 30 seconds for sd, but it could be much longer (e.g.
> WRITE SAME, which was 120 seconds last I looked).

It currently does, but that's fixable via a special return code.

James

