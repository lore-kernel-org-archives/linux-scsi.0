From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: Re: USB storage problems on OHCI..
Date: Tue, 23 Sep 2003 11:23:45 -0400 (EDT)
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <Pine.LNX.4.44L0.0309231117240.1869-100000@ida.rowland.org>
References: <1064328668.1832.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <1064328668.1832.30.camel@mulgrave>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: Andries.Brouwer@cwi.nl, david-b@pacbell.net, greg@kroah.com, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-usb-devel@lists.sourceforge.net, mdharm-usb@one-eyed-alien.net, Patrick Mansfield <patmans@us.ibm.com>, Linus Torvalds <torvalds@osdl.org>
List-Id: linux-scsi@vger.kernel.org

On 23 Sep 2003, James Bottomley wrote:

> On Tue, 2003-09-23 at 09:37, Andries.Brouwer@cwi.nl wrote:
> 
> > Pulling out a device while it is actively reading or writing
> > will probably break something. But if a device is hot-pluggable
> > it should be OK to pull it out when it has been inactive for
> > a second or so.
> > 
> > But if that is really true, then it should not be necessary
> > to send the device any "synchronise cache" commands when we
> > shut down.
> 
> For a FC array, suprise unplug would be caveat emptor (possibly because
> fibre connection transience is going to cause it to come back), but
> notified unplug would still want to flush the cache on the assumption
> the next action might be to power down the array.

Is there any way to notify the system that you are about to unplug a 
drive?  It seems to me that the best approach is to flush the cache on an 
unmount.  People naturally assume that it's safe to unplug a device once 
it has been unmounted, and they also realize that it's unsafe to unplug a 
device containing a mounted filesystem.

That doesn't address the problem of raw device access, but perhaps 
whatever ioctl is used by blockdev --flushbufs can also flush the cache.

Is there any harm in sending a SYNCHRONIZE command to a device that
doesn't need it (write-through cache)?  Maybe doing that is less dangerous 
than trying to read mode-sense page 8 on these buggy USB devices.  
(Although I'm not aware of anyone who has tried the experiment.)

Alan Stern



-------------------------------------------------------
This sf.net email is sponsored by:ThinkGeek
Welcome to geek heaven.
http://thinkgeek.com/sf
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
