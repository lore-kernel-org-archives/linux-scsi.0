From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH 1/5] SCSI scanning and removal fixes
Date: Fri, 9 Sep 2005 12:17:54 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0509091146170.5557-100000@iolanthe.rowland.org>
References: <1126280249.4799.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:10152 "HELO
	iolanthe.rowland.org") by vger.kernel.org with SMTP
	id S1030208AbVIIQRz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 9 Sep 2005 12:17:55 -0400
In-Reply-To: <1126280249.4799.21.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

On Fri, 9 Sep 2005, James Bottomley wrote:

> On Fri, 2005-09-09 at 11:16 -0400, Alan Stern wrote:
> > > So which way do you want to go?  Either we wait in recovery for the
> > > error handler to finish and transition the host state to RUNNING or we
> > > introduce the parallel states for the error handler.
> > 
> > For usb-storage it won't make any difference on the whole, as far as I can
> > see.  The important thing is that scsi_remove_host needs to synchronize
> > somehow with the error handler.  Waiting for the host state to go back to
> > RUNNING would be valid.  Introducing the parallel states would mean 
> > waiting for the host to go from CANCEL_RECOVERY to CANCEL, right?
> 
> Actually, no, there would be no waiting.

You mean that there would be no waiting if the parallel states are used -- 
without them we have to wait for the state to go to RUNNING.

>  Once the host gets to DEL or
> CANCEL_DEL, then all the devices should be in DEL and the mid-layer will
> begin rejecting any commands the error handler makes.  So it can
> continue until it's exhausted.  It keeps a reference to the devices it
> needs to operate, so they'll be finally freed when it stops.
> 
> Since the eh has references, module removal would have to wait until it
> had finished, but everything else can proceed without it.

Then what about making scsi_remove_host wait for the current command or
reset to complete?  If you don't wait for the state to change from
CANCEL_RECOVERY to CANCEL before moving to DEL then scsi_remove_host might
return too early, while the error handler is still using the host.  (On
the plus side, if scsi_remove_host always waits for the state to be CANCEL
before making the transition to DEL, then there's no need for DEL_RECOVERY
at all.  The error handler can simply refuse to start when the state is
already DEL.)

The conundrum I'm facing is how to make sure that when scsi_remove_host
returns, the mid-layer is no longer sending anything to the host.  Sure,
no new commands will be issued once the state is set to DEL (or
DEL_RECOVERY).  But what about commands/resets that were already in
progress at that time?  (Especially if they were issued before
scsi_remove_host was called.)  The routine shouldn't return until they
have completed.  This applies to commands coming from either the
high-level driver or from the error handler.

I don't know what the best approach is.  The issue may be unrelated to
whether you use the parallel states; if it is, then I don't care whether
the parallel states are used or not.

Alan Stern

