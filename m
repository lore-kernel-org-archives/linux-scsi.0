From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Fri, 28 Sep 2007 11:01:37 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709281038180.4062-100000@iolanthe.rowland.org>
References: <200709281017.56901.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200709281017.56901.oliver@neukum.org>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Oliver Neukum <oliver@neukum.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 28 Sep 2007, Oliver Neukum wrote:

> > You're right; there's no showstopping reason particular subsystems like
> > SCSI can't use a different approach.  However bus activity alone isn't
> > a sufficient criterion.  For example, suppose somebody sends a PLAY
> > AUDIO command to a SCSI cdrom drive.  There won't be any bus activity
> > while the music is playing, but the device will be active and so it
> > shouldn't be suspended.  Thus the sr driver would want to fail an
> > autosuspend call.
> 
> sr isn't a device driver.

That's a very surprising statement.  How do you justify it?

Certainly sr is much more of a device driver than something like the 
gendisk layer, which manages logical disks and partitions.  These 
things don't have an independent physical existence, but they show up 
in the device tree anyway.

>  Furthermore it is generic. It can't know whether
> any power saving measure would prevent some activity from being carried
> out.

It might not know in all cases, but it definitely does know in some 
cases.  We must not ignore that knowledge.

The example of suspending the USB transport to a cdrom device playing
music is an interesting one.  We really don't know whether suspending
the link would suspend the device, i.e., whether it would allow the
music to continue playing or not.  The behavior will vary from one
device to another, so we would have to be conservative and avoid
autosuspending the drive.

> It seems to me that we need to be conservative. Any device that
> is opened by user space must not be autosuspended. But how to fit this
> into SCSI?

"Opened by user space" is too strong.  It would include any device with 
a mounted filesystem, I think.  Also it doesn't handle the "cd drive 
playing music" example; once the PLAY AUDIO command has been sent, the 
device file can be closed and the music will continue autonomously.

> We are moving in circles. In an earlier thread you argued that a suspend
> call should not walk the device tree in case of runtime power management.

Shouldn't go down the device tree, yes.  (Runtime PM notifications do 
go up the tree.)  You are claiming that my earlier opinion was wrong; 
I'm not so sure it was.  Even if things could be done another way, my 
approach is the most straightforward.

> > Have you thought about how autoresume would fit into this picture?  I
> > don't think you can rely on usb-storage telling the SCSI core to resume
> > devices when it gets handed a command, because the commands to spin-up
> > the drives would have to be transmitted first.  (The sample patch you
> > posted will deadlock: The other command can't begin until the spin-up
> > command completes, and the spin-up command won't get sent to
> > usb-storage until the original command completes.)  In other words,
> > autoresume must be handled at the level of the SCSI core.
> 
> That's a difficult one. I need to ponder this a bit.

> Actually, it is not a big question. By default sd_resume() is a nop.
> Usually the first SCSI command would return NOT_READY and SCSI core
> do a START_STOP_UNIT only then in response.

Yes, but what about non-default situations where sd_resume() isn't a 
nop?

> > There's also a philosophical objection.  Who is in a better position to
> > judge when a device like a SCSI drive should be autosuspended: its own
> > driver (sd) or someone else (usb-storage)?
> 
> SCSI doesn't know about power management. It cannot, it is not a notion
> native to SCSI. It just knows how to safely put drives into a state other
> than fully active (flushing buffers/spin down)
> You are expecting too much of SCSI core.

I disagree.  While it's true that SCSI isn't cognizant of actual power
levels, Power Management includes several other attributes which _are_
relevant to SCSI, including special states, functionality, and latency.  
To this extent it makes sense for the SCSI drivers to be involved in PM
decisions.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
