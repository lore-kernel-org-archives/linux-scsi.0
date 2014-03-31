From: James Bottomley <James.Bottomley-d9PhHud1JfjCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Subject: Re: [PATCH 0/3] Fix USB deadlock caused by SCSI error handling
Date: Mon, 31 Mar 2014 08:03:44 -0700
Message-ID: <1396278224.3152.26.camel@dabdike.int.hansenpartnership.com>
References: <Pine.LNX.4.44L0.1403310907150.11739-100000@netrider.rowland.org>
	 <53397DAE.9010801@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <53397DAE.9010801-l3A5Bk7waGM@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hannes Reinecke <hare-l3A5Bk7waGM@public.gmane.org>
Cc: Alan Stern <stern-nwvwT67g6+6dFdvTe/nMLpVzexx5G7lz@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, USB list <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

[lets split the thread]
On Mon, 2014-03-31 at 16:37 +0200, Hannes Reinecke wrote:
> On 03/31/2014 03:33 PM, Alan Stern wrote:
> > On Mon, 31 Mar 2014, Hannes Reinecke wrote:
> >> On 03/28/2014 08:29 PM, Alan Stern wrote:
> >>> On Fri, 28 Mar 2014, James Bottomley wrote:
> >>> Maybe scmd_eh_abort_handler() should check the flag before doing
> >>> anything.  Is there any sort of sychronization to prevent the same
> >>> incarnation of a command from being aborted twice (or by two different
> >>> threads at the same time)?  If there is, it isn't obvious.
> >>>
> >> See above. scsi_times_out() will only ever called once.
> >> What can happen, though, is that _theoretically_ the LLDD might
> >> decide to call ->done() on a timed out command when
> >> scsi_eh_abort_handler() is still pending.
> > 
> > That's okay.  We can expect the LLDD to have sufficient locking to
> > handle that sort of thing without confusion (usb-storage does, for
> > example).
> > 
> >>> (Also, what's going on at the start of scsi_abort_command()?  Contrary
> >>> to what one might expect, the first part of the function _cancels_ a
> >>> scheduled abort.  And it does so without clearing the
> >>> SCSI_EH_ABORT_SCHEDULED flag.)
> >>>
> >> The original idea was this:
> >>
> >> SCSI_EH_ABORT_SCHEDULED is sticky _per command_.
> >> Point is, any command abort is only ever send for a timed-out
> >> command. And the main problem for a timed-out command is that we
> >> simply _do not_ know what happened for that command. So _if_ a
> >> command timed out, _and_ we've send an abort, _and_ the command
> >> times out _again_ we'll be running into an endless loop between
> >> timeout and aborting, and never returning the command at all.
> >>
> >> So to prevent this we should set a marker on that command telling it
> >> to _not_ try to abort the command again.
> > 
> > I disagree.  We _have_ to abort the command again -- how else can we
> > stop a running command?  To prevent the loop you described, we should
> > avoid _retrying_ the command after it is aborted the second time.
> > 
> The actual question is whether it's worth aborting the same command
> a second time.
> In principle any reset (like LUN reset etc) should clear the
> command, too.
> And the EH abort functionality is geared around this.
> If, for some reason, the transport layer / device driver
> requires a command abort to be send then sure, we need
> to accommodate for that.

We already discussed this (that was my first response too).  USB needs
all outstanding commands aborted before proceeding to reset.  I'm
starting to think the actual way to fix this is to reset the abort
scheduled only if we send something else, so this might be a better fix.

It doesn't matter if we finish a command with abort scheduled because
the command then gets freed and the flags cleaned.

We can take our time with this because the other two patches, which I
can send separately fix the current deadlock (we no longer send an
unaborted request sense before the reset), and it can go via rc fixes.

James

---

diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
index 771c16b..3cfd2bf 100644
--- a/drivers/scsi/scsi_error.c
+++ b/drivers/scsi/scsi_error.c
@@ -1007,6 +1007,12 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
 	const unsigned long stall_for = msecs_to_jiffies(100);
 	int rtn;
 
+	/*
+	 * We're sending another command we'll need to abort, so reset the
+	 * abort scheduled flag on the real command before we save its state
+	 */
+	scmd->eh_eflags &= ~SCSI_EH_ABORT_SCHEDULED;
+
 retry:
 	scsi_eh_prep_cmnd(scmd, &ses, cmnd, cmnd_size, sense_bytes);
 	shost->eh_action = &done;


--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
