From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Sat, 29 Sep 2007 16:56:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709291640200.1094-100000@netrider.rowland.org>
References: <200709292206.17377.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200709292206.17377.oliver@neukum.org>
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
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, Pavel Machek <pavel@ucw.cz>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 29 Sep 2007, Oliver Neukum wrote:

> > autosuspend. =A0It's not supposed to work by the higher level announcin=
g: =A0
> > "I want to autosuspend now, so all you lower guys had better get
> > ready."
> =

> I see. And there's an appealing simplicity to it. But why insist that
> this is the one true way?

Well, I don't really insist on it.  But keeping things unidirectional =

makes life easier and helps prevent deadlock issues.

Another thing to consider is this: If SCSI autosuspend is initiated by
the host adapter driver, then it won't be possible for different
devices on a SCSI bus to autosuspend at different times.  With
usb-storage this doesn't matter much, because there's almost always
only one target.  But for other buses it could matter.

> > Even in the case of system suspend things don't work that way. =A0We
> > don't have higher-level drivers telling lower-level drivers to suspend.=
 =A0
> > Rather, the PM core (acting on behalf of the user) tells _every_ driver
> > to suspend -- in the correct order, of course.
> =

> True. And putting the notification into a driver is a kludge at best.
> It simply was the only way I could come up with without moving
> autosuspend into generic code.
> Nevertheless, I am not convinced that autosuspend has to work
> on the device level only.

Well, suppose usb-storage decides it is ready to autosuspend and it =

asks sd for permission.  What if sd says "No"?  How long should =

usb-storage wait before asking again?  Why should usb-storage have to =

poll sd, instead of being notified just once when sd is ready?

Another thing: I haven't followed the current work in new SCSI
development, but it wouldn't be at all surprising to learn that Power
Management is one of the topics they are focused on.  We should expect
that it will eventually become part of the standard, with associated
special commands and other requirements.  When that happens, Linux's
SCSI stack should be ready to implement the new specs.  Basing our SCSI
autosuspend on hacky code in usb-storage doesn't seem like a good way
to prepare.

> > Now, how much extra work is involved in having the lower-level drivers =

> > implement autosuspend as opposed to having the higher-level driver ask =

> > permission? =A0Not much more than adding the autosuspend timers. =A0
> > Everything else is needed anyway for supporting manual runtime suspend.
> =

> Move autosuspend into generic code and I'll certainly try to come up with
> something better than what I wrote.

It's hard to make something generic when there's only one example to =

work from!  Suppose we do it the other way: Add autosuspend support =

into the SCSI drivers and then see what common features it shares with =

USB.  Those common parts can be moved into generic code.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
