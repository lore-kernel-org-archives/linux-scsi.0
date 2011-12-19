From: David Dillow <dillowda@ornl.gov>
Subject: Re: [PATCH 12/14] ib_srp: Rework error handling
Date: Mon, 19 Dec 2011 17:51:23 -0500
Message-ID: <1324335083.7043.66.camel@lap75545.ornl.gov>
References: <201112011954.25811.bvanassche@acm.org>
	 <201112012010.37276.bvanassche@acm.org>
	 <1324265791.17849.92.camel@obelisk.thedillows.org>
	 <CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mta02.ornl.gov ([128.219.14.62]:9509 "EHLO mta02.ornl.gov"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751570Ab1LSWvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Dec 2011 17:51:25 -0500
In-Reply-To: <CAO+b5-q332RKkLrUV7X_D73SHBrLpt=6Xz=W7ZtOwZ+9iSOyDw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bvanassche@acm.org>
Cc: "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>, Fujita Tomonori <fujita.tomonori@lab.ntt.co.jp>, Brian King <brking@linux.vnet.ibm.com>, Roland Dreier <roland@purestorage.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2011-12-19 at 05:38 -0500, Bart Van Assche wrote:
> On Mon, Dec 19, 2011 at 3:36 AM, David Dillow <dillowda@ornl.gov> wrote:
> > On Thu, 2011-12-01 at 20:10 +0100, Bart Van Assche wrote:
> >> Rework ib_srp transport layer error handling. Instead of letting SCSI
> >> commands time out if a transport layer error occurs,
> >
> > This is good, but should probably be part of the initial disconnect. We
> > want to run the receive queue dry, processing responses to avoid
> > unnecessarily resetting a command that was successful.
> 
> Blocking the SCSI host doesn't prevent ib_srp from continuing to
> process IB completion notifications.

In your series, it doesn't -- and I was wrong about the message spam,
you check for the proper state and the work being queued.

I haven't parsed it all out from your changes just yet, but I think part
of the reason you may have had problems with req->scmd being null in
srp_handle_recv() is due to a new race between the tear down of the
connection and continuing to process completion notifications.

> >> block the SCSI
> >> host and try to reconnect until the reconnect timeout elapses or until
> >> the maximum number of reconnect attempts has been exceeded, whichever
> >> happens first.
> >
> > When we're blocked for a disconnected target, we may want to call the
> > state something other than SRP_TARGET_BLOCKED. I'd like to eventually
> > handle the case where the target leaves the fabric temporarily -- we
> > don't necessarily disconnect in that case, but we need to block commands
> > until it comes back or we give up on it.
> 
> The case where the target leaves the fabric temporarily should already
> be covered by this patch series.

Only once a command is sent to it and timesout or we get a QP error. The
idea here would be to start the dev_loss_tmo timer once it was detected
that it left the fabric. This was handled in OFED via sysfs attributes,
but it seems like we could register for the events ourselves.

This isn't something I expect you to implement, but I'd like to leave
room for it in the future.

> >> +static void srp_remove_target(struct srp_target_port *target)
> >>  {
> >
> >>       srp_del_scsi_host_attr(target->scsi_host);
> >> +     cancel_work_sync(&target->block_work);
> >> +     mutex_lock(&target->mutex);
> >> +     mutex_unlock(&target->mutex);
> >
> > You lock and unlock here without doing anything in the critical section.
> 
> That's on purpose.

I'm assuming you do this to ensure that everyone has seen the
appropriate state and exited the critical section, then? Best to add a
comment to that effect. Actually, is there any reason to unlock it again
since we're removing the target? I don't have the code in front of me
ATM, so I'm assuming that you don't call any other routines that need
the lock after this. sparse may complain, though.

-- 
Dave Dillow
National Center for Computational Science
Oak Ridge National Laboratory
(865) 241-6602 office

