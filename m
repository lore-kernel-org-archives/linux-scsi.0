From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: question on flushing buffers and spinning
 down disk
Date: Mon, 24 Sep 2007 15:39:40 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0709241532380.5920-100000@iolanthe.rowland.org>
References: <200709242116.29635.oliver@neukum.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <200709242116.29635.oliver@neukum.org>
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

On Mon, 24 Sep 2007, Oliver Neukum wrote:

> > subsystem implements its own form of runtime PM support, then you'll be
> > able to use it properly.  But until then, there isn't anything much you
> > can do.
> 
> Well, we can't simply cut power. Buffers must be flushed and the disk
> spun down. The suspend() method of the storage driver will have to become
> complex.

That's right, if the device is a real disk.  If it's a flash memory
device then of course these issues don't arise.  Unfortunately the
driver isn't able to tell one from the other; the user will have to
do that for us.

So for now we can simply rely on the defaults being set right: USB
autosuspend is normally disabled, but the user can enable it if desired
(and if the device can handle it).  It would be nice if we had some way 
to warn people that enabling autosuspend for real disk drives might be 
a bad idea...  Maybe a section in the linux-usb.org FAQ would help, 
plus a file under Documentation/usb.

Alan Stern


-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
