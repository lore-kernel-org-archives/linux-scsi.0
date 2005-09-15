From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [linux-usb-devel] oops on usb storage device disconnect with
	2.6.14-rc1
Date: Thu, 15 Sep 2005 18:38:36 -0400
Message-ID: <1126823917.4821.70.camel@mulgrave>
References: <20050915190338.GA6807@kroah.com>
	 <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
	 <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave>
	 <1126818483.4821.60.camel@mulgrave>  <20050915221946.GA28441@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:21890 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161032AbVIOWi7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Sep 2005 18:38:59 -0400
In-Reply-To: <20050915221946.GA28441@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net

On Thu, 2005-09-15 at 15:19 -0700, Mike Anderson wrote:
> A side effect of not applying Alan's previous patch that added
> SHOST_RECOVERY to the SHOST_CANCEL: state is that we will not move to the
> SHOST_CANCEL and subsequently not to SHOST_DEL state if the eh is active
> during the start of scsi_remove_host. I sent mail on the 7th indicating to
> include that state change hunk of the diff, but I guess that overlapped
> with your newer state changes.
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112238726326927&w=2

Yes, but that's not really legitimate since it introduces a bifurcation
in the state machine ... when the eh terminates it will come back to
running even if it went in from cancel.

> In looking at the state model introduced by your patch I believe there may
> still be a state model race issue if the recovery completes just after
> the "if (!scsi_host_set_state(shost, SHOST_CANCEL))" call in
> scsi_remove_host (maybe I am just looking to quickly at the state
> updates).

No, that's true; there's a tiny race that can be mediated by doing
locking around the state changes ... that was one of the feedback
comments from Alan.

> I still do not understand as I asked in a previous comment why we are not
> shutting down the eh_thread in scsi_remove_host and also why simpler state
> model updates could not solve the problem.

Well, it goes back to whether we wait for the thread or not.  To shut
the thread down, we also need to wait for it to complete.

As far as the state model goes, we either need to wait for the eh thread
before transitioning to cancel or introduce the extra states that
reflect the parallel eh transitions.

> I believe I also indicated that we could enhance scsi_error to shutdown
> faster during this state which should only be a performance improvement.

Yes, we could ... patches?

James


