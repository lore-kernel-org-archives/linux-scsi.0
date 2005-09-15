From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with 2.6.14-rc1
Date: Thu, 15 Sep 2005 16:55:28 -0700
Message-ID: <20050915235528.GA30185@us.ibm.com>
References: <20050915190338.GA6807@kroah.com> <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org> <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave> <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com> <1126823917.4821.70.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:55251 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1030490AbVIOXz6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 19:55:58 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j8FNtrvW003547
	for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 19:55:53 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j8FNtrlR082418
	for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 19:55:53 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j8FNtqNh025856
	for <linux-scsi@vger.kernel.org>; Thu, 15 Sep 2005 19:55:53 -0400
Content-Disposition: inline
In-Reply-To: <1126823917.4821.70.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

James Bottomley <James.Bottomley@SteelEye.com> wrote:
> On Thu, 2005-09-15 at 15:19 -0700, Mike Anderson wrote:
> > A side effect of not applying Alan's previous patch that added
> > SHOST_RECOVERY to the SHOST_CANCEL: state is that we will not move to the
> > SHOST_CANCEL and subsequently not to SHOST_DEL state if the eh is active
> > during the start of scsi_remove_host. I sent mail on the 7th indicating to
> > include that state change hunk of the diff, but I guess that overlapped
> > with your newer state changes.
> > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238726326927&w=2
> 
> Yes, but that's not really legitimate since it introduces a bifurcation
> in the state machine ... when the eh terminates it will come back to
> running even if it went in from cancel.

Clarification here as I do not see the split in the state machine or the
transition back to running from cancel. If the above patch is applied we
can transition to cancel from recovery if eh already has started. When eh
is complete scsi_restart_operations transition to running will fail as we
are in the cancel state. 

That said I like the idea below of waiting / terminating the eh thread
prior to transitioning to cancel. There is some introduction of asymmetry
here in scsi_remove_host as the eh thread is created in scsi_host_alloc,
but possibly later patches could move the eh creation to scsi_add_host
(unless I forgot the reason it needed to be earlier).

> 
> > In looking at the state model introduced by your patch I believe there may
> > still be a state model race issue if the recovery completes just after
> > the "if (!scsi_host_set_state(shost, SHOST_CANCEL))" call in
> > scsi_remove_host (maybe I am just looking to quickly at the state
> > updates).
> 
> No, that's true; there's a tiny race that can be mediated by doing
> locking around the state changes ... that was one of the feedback
> comments from Alan.

ok.

> 
> > I still do not understand as I asked in a previous comment why we are not
> > shutting down the eh_thread in scsi_remove_host and also why simpler state
> > model updates could not solve the problem.
> 
> Well, it goes back to whether we wait for the thread or not.  To shut
> the thread down, we also need to wait for it to complete.
> 
> As far as the state model goes, we either need to wait for the eh thread
> before transitioning to cancel or introduce the extra states that
> reflect the parallel eh transitions.

I like waiting for the eh thread to complete / shutdown prior to
transitioning to cancel.

> 
> > I believe I also indicated that we could enhance scsi_error to shutdown
> > faster during this state which should only be a performance improvement.
> 
> Yes, we could ... patches?


ok, I will try, but IBM non-coding activities has made me very
unproductive in the patch department lately :-).

-andmike
--
Michael Anderson
andmike@us.ibm.com
