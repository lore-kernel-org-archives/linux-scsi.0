From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: bug 2400
Date: 05 Apr 2004 16:27:41 -0500
Sender: linux-usb-devel-admin@lists.sourceforge.net
Message-ID: <1081200462.2105.63.camel@mulgrave>
References: <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-usb-devel-admin@lists.sourceforge.net>
In-Reply-To: <Pine.LNX.4.44L0.0404042235420.23916-100000@netrider.rowland.org>
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

On Sun, 2004-04-04 at 22:17, Alan Stern wrote:
> On 4 Apr 2004, James Bottomley wrote:
> > On Sun, 2004-04-04 at 12:46, Alan Stern wrote:
> > > Ah, you have left out the third, bad alternative: open succeeds, user gets 
> > > an fd that points to a deallocated device.  More details below...
> > 
> > No, that would be a bug.
> 
> Of course it would!  That's exactly what this thread is about: bugs caused
> by improper handling of open/disconnect races.

So you're quietly shifting your ground away from this assertion:

On Sat, 2004-04-03 at 19:40, Alan Stern wrote:
> The problem _can_ be solved by introducing a lock higher up, such as at
> the driver level or at the bus level.  (A kernel lock would work too but
> it would be extravagantly excessive.)  For example, the bus subsystem
> rwsem in the driver model prevents analogous problems there.  But you
> don't want to get a read lock on a bus-wide semaphore every time your
> open() procedure runs!  A driver-wide lock makes a good solution.
> 
> Another possible solution would be to have disconnect() perform an RCU 
> update to the device pointer.  I haven't seen any code that does this, but 
> I think it ought to work.

?

My contention is that the races can be solved by proper refcounting
(without the need for locks and RCUs) not that we don't have any bugs in
sd.c (I'll be happy if I can pull them all out of sr at the moment).

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
