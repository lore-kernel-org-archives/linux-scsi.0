From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Fri, 28 Sep 2007 11:07:25 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709281101460.4062-100000@iolanthe.rowland.org>
References: <200709281104.48673.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200709281104.48673.oliver@neukum.org>
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

On Fri, 28 Sep 2007, Oliver Neukum wrote:

> Am Donnerstag 27 September 2007 schrieb Alan Stern:
> > There's also a philosophical objection. =A0Who is in a better position =
to
> > judge when a device like a SCSI drive should be autosuspended: its own
> > driver (sd) or someone else (usb-storage)?
> =

> Then a philosophical answer. The highest entity which understands what
> it is doing when using power management. Highest here to be understood
> not as a position in the device tree, but in the flow of information.

In this sense, sd is higher than usb-storage, right?  Because I/O =

requests pass through sd first, then usb-storage, on their way to the =

device.

My point is that when dealing with SCSI disks, sd understands the =

implications of Power Management better than usb-storage does.  =

Similarly, when dealing with SCSI cd drives, sr understands the =

implications of Power Management better than usb-storage.

Hence by your own argument, the SCSI high-level drivers should be =

responsible for autosuspending their respective devices.  usb-storage, =

on the other hand, should be responsible only for suspending the =

transport, since that's what it does understand.

> That is in our case usb-storage. Sr or sd can't do it because they don't
> and can't understand power management.

That's simply not true.  If sd didn't understand Power Management then =

sd_suspend() and sd_resume() would be empty.

> Now they might be asked to provide some helpers. An open count and
> notifications about the state of the queue would be obvious. Other
> suggestions?

I still think you're trying to go about it all backwards.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
