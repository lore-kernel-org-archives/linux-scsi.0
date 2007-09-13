From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [1/4] 2.6.23-rc6: known regressions
Date: Thu, 13 Sep 2007 09:50:21 -0500
Message-ID: <1189695021.4082.10.camel@localhost.localdomain>
References: <20070913093651.GA5077@suse.de>
	<Pine.LNX.4.44L0.0709131013270.3619-100000@iolanthe.rowland.org>
	<20070913144139.GD3309@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20070913144139.GD3309@suse.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-usb-devel>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux-usb-devel-bounces@lists.sourceforge.net
Errors-To: linux-usb-devel-bounces@lists.sourceforge.net
To: Greg KH <gregkh@suse.de>
Cc: Oliver Neukum <oneukum@suse.de>, Alan Stern <stern@rowland.harvard.edu>, USB development list <linux-usb-devel@lists.sourceforge.net>, SCSI development list <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2007-09-13 at 07:41 -0700, Greg KH wrote:
> On Thu, Sep 13, 2007 at 10:19:48AM -0400, Alan Stern wrote:
> > On Thu, 13 Sep 2007, Greg KH wrote:
> > 
> > > Ok, after conferring with Oliver this morning, I think the best solution
> > > here is to both revert the usb-storage suspend patch as it has some
> > > basic problems that can cause data loss, _and_ add the change to the
> > > kernel that by default disables autosuspend on all USB devices except
> > > hubs.
> > 
> > Are you referring to the disk spin-down issue?  As far as I know, 
> > that's the only troublesome aspect of usb-storage autosuspend (apart 
> > from the fact that so many devices don't seem to support it very well, 
> > if at all).
> > 
> > Solving the spin-down problem will require coordination with the SCSI 
> > developers.  Basically, the SCSI core has to notify the HBA driver 
> > whenever the bus has been idle sufficiently long and all its devices 
> > are ready to be suspended.  In particular, all disk heads should be 
> > parked and drives spun down, if they need to be.
> 
> I am not sure.  I will defer to Oliver for the knowledge of the details,
> it was early in the morning and I can't remember them all exactly :)
> 
> (although it might be a few days for him to respond, he's here at a
> conference without a laptop, so his lag time might be a bit longer than
> normal...)

I'll wait, certainly ... enjoy the Czech backwoods.

One thing I would say though is that if there's special action we have
to take after autosuspend, it should probably be built into the
framework Kristen is developing for ACHI link power management (your USB
autosuspend is effectively a simple type of link power management as
well).

James



-------------------------------------------------------------------------
This SF.net email is sponsored by: Microsoft
Defy all challenges. Microsoft(R) Visual Studio 2005.
http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
