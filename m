From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 04 Apr 2004 13:04:31 -0400
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1081098273.2112.18.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404041216040.14668-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0404041216040.14668-100000@netrider.rowland.org>
Errors-To: linux-usb-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux-usb-devel@lists.sourceforge.net>
List-Help: <mailto:linux-usb-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-usb-devel>,
	<mailto:linux-usb-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux-usb-devel>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mike Anderson <andmike@us.ibm.com>, Andrew Morton <akpm@osdl.org>, greg@kroah.com, Jens Axboe <axboe@suse.de>, linux-usb-devel@lists.sourceforge.net, SCSI Mailing List <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2004-04-04 at 12:46, Alan Stern wrote:
> Ah, you have left out the third, bad alternative: open succeeds, user gets 
> an fd that points to a deallocated device.  More details below...

No, that would be a bug. I'm looking for evidence that such a bug exists
in sd.

> Let's consider a simple example, one that doesn't have all the
> complexities of the sr driver with its multiple driver layers.  The
> usb-skeleton program in drivers/usb makes a good illustration; I added a
> semaphore to it some time ago to protect against exactly this sort of
> race.  Without that semaphore, here's what can happen:
> 
> 	Open process:			Disconnect process:
> 
> 	Get minor number from inode
> 	Lookup USB interface using
> 	  minor number
> 	Get device pointer from the
> 	  interface's private data
> 	  and check it's not NULL

This is what's wrong.  Here you should get a reference to the device
pointer (that's what scsi_device_get() actually does for us).  If the
ref getting routine comes back with an error, you may not proceed.  If
it comes back with a device, you own a reference to it and may go on
(even if the device is now gone, the structure will behave correctly).

> 					Get device pointer from the
> 					  interface's private data
> 					Set the private data to NULL
> 					Lock the device sem
> 					Unregister the minor number
> 					Terminate ongoing I/O operations
> 					Clear the device->present flag
> 					Unlock the device
> 					Since the open count is 0,
> 					  deallocate the device structure

You're not obeying the object lifetime rules here.  The device may be
gone but the device structure must stay around (obviously in a special
state) until the last reference is dropped.  Only after that may you
start nulling things out and killing it.

> 	Lock the device sem --> oops

This is because you're not using refcounted objects correctly.

If anyone can find a similar bug in the SCSI ULD's, I'll fix it, that's
why I asked for an example in sd (or sr with the current fixes) way back
in this thread.

James




-------------------------------------------------------
This SF.Net email is sponsored by: IBM Linux Tutorials
Free Linux tutorial presented by Daniel Robbins, President and CEO of
GenToo technologies. Learn everything from fundamentals to system
administration.http://ads.osdn.com/?ad_id=1470&alloc_id=3638&op=click
_______________________________________________
linux-usb-devel@lists.sourceforge.net
To unsubscribe, use the last form field at:
https://lists.sourceforge.net/lists/listinfo/linux-usb-devel
