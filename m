From: Oliver Neukum <oliver@neukum.org>
Subject: Re: question on flushing buffers and spinning
	down disk
Date: Mon, 24 Sep 2007 18:47:17 +0200
Message-ID: <200709241847.17714.oliver@neukum.org>
References: <Pine.LNX.4.44L0.0709241128520.4920-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0709241128520.4920-100000@iolanthe.rowland.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-usb-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Am Montag 24 September 2007 schrieb Alan Stern:
> On Mon, 24 Sep 2007, Oliver Neukum wrote:
> 
> > > suspend.  The PM and driver cores don't include _any_ provision for
> > > runtime suspend; it has to be managed separately by each subsystem.
> > 
> > There we have a problem. We'd have to solve it for each subsystem transition.
> > Storage has this type of children, other devices will have to care for other
> > types of child devices. If we have a device tree, we should use it.
> 
> It sounds like you want to add the equivalent of
> usb_autopm_get/set_device() and usb_autopm_get/set_interface() into the

That would be an ideal solution, but it is not necessary to solve this
problem.

> driver model.  But it would not be appropriate, since other subsystems
> don't have the same kinds of runtime power levels as USB does.

But we don't bother when suspending the whole system. So why not simply
walk the subtrees under a USB device? Let the subsystem choose what
depth of sleep to use.
 
> There may be no way of getting around the need for specialized 
> communication methods between subsystems for runtime PM.

That's a lot of code duplication and should be a solution of last resort.

	Regards
		Oliver

-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
