From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: oops on usb storage device disconnect with
	2.6.14-rc1
Date: Thu, 15 Sep 2005 21:46:41 -0400
Message-ID: <1126835201.4794.14.camel@mulgrave>
References: <20050915190338.GA6807@kroah.com>
	 <Pine.LNX.4.44L0.0509151514460.4493-100000@iolanthe.rowland.org>
	 <20050915192912.GA7077@kroah.com> <1126814226.4821.48.camel@mulgrave>
	 <1126818483.4821.60.camel@mulgrave> <20050915221946.GA28441@us.ibm.com>
	 <1126823917.4821.70.camel@mulgrave>  <20050915235528.GA30185@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <20050915235528.GA30185@us.ibm.com>
Sender: linux-usb-devel-admin@lists.sourceforge.net
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Mike Anderson <andmike@us.ibm.com>
Cc: Greg KH <greg@kroah.com>, Alan Stern <stern@rowland.harvard.edu>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>, mdharm-usb@one-eyed-alien.net
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-09-15 at 16:55 -0700, Mike Anderson wrote:
> James Bottomley <James.Bottomley@SteelEye.com> wrote:
> > On Thu, 2005-09-15 at 15:19 -0700, Mike Anderson wrote:
> > > A side effect of not applying Alan's previous patch that added
> > > SHOST_RECOVERY to the SHOST_CANCEL: state is that we will not move to the
> > > SHOST_CANCEL and subsequently not to SHOST_DEL state if the eh is active
> > > during the start of scsi_remove_host. I sent mail on the 7th indicating to
> > > include that state change hunk of the diff, but I guess that overlapped
> > > with your newer state changes.
> > > http://marc.theaimsgroup.com/?l=linux-scsi&m=112238726326927&w=2
> > 
> > Yes, but that's not really legitimate since it introduces a bifurcation
> > in the state machine ... when the eh terminates it will come back to
> > running even if it went in from cancel.
> 
> Clarification here as I do not see the split in the state machine or the
> transition back to running from cancel. If the above patch is applied we
> can transition to cancel from recovery if eh already has started. When eh
> is complete scsi_restart_operations transition to running will fail as we
> are in the cancel state. 

OK, the current model has 5 states, three of which are relevant:
RUNNING, RECOVER and CANCEL.  The problem is that if the error handler
is operating when someone calls scsi_remove_host() we're actually
simultaneously in the RECOVER and CANCEL states.  This is the
bifurcation.  Currently the model forbids the transition RECOVER-
>CANCEL, so we wrongly stay in the recover state (and even worse
transition back to RUNNING if the eh thread finishes).  The patch would
permit this transition so we'd now wrongly go into the CANCEL state
instead (in spite of the error handler still being active---meaning that
the not in recovery checks all wrongly pass).

The solution is either to update our model to reflect reality:  adding
the parallel CANCEL_RECOVER (and DEL_RECOVER) states that allow our
model to reflect simultaneous cancel and recovery.  Or we update reality
to reflect our model: make scsi_remove_host() wait for the recovery
thread to finish if it's active and never let it start once we
transition to CANCEL.

> That said I like the idea below of waiting / terminating the eh thread
> prior to transitioning to cancel. There is some introduction of asymmetry
> here in scsi_remove_host as the eh thread is created in scsi_host_alloc,
> but possibly later patches could move the eh creation to scsi_add_host
> (unless I forgot the reason it needed to be earlier).

That's the "update reality to reflect our model" option.

> > > I still do not understand as I asked in a previous comment why we are not
> > > shutting down the eh_thread in scsi_remove_host and also why simpler state
> > > model updates could not solve the problem.
> > 
> > Well, it goes back to whether we wait for the thread or not.  To shut
> > the thread down, we also need to wait for it to complete.
> > 
> > As far as the state model goes, we either need to wait for the eh thread
> > before transitioning to cancel or introduce the extra states that
> > reflect the parallel eh transitions.
> 
> I like waiting for the eh thread to complete / shutdown prior to
> transitioning to cancel.

Well ... I'm less keen on this.  Making one thing wait for another
introduces complex dependencies into the system.  Such complex
interactions always seem to come back to bite us one way or another.
Since we can model the system without introducing the dependency I'd
really rather do it that way.

James




-------------------------------------------------------
SF.Net email is sponsored by:
Tame your development challenges with Apache's Geronimo App Server. Download
it for free - -and be entered to win a 42" plasma tv or your very own
Sony(tm)PSP.  Click here to play: http://sourceforge.net/geronimo.php
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
