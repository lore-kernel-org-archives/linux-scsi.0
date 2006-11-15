From: Josha Foust <lightn@lightn.org>
Subject: Re: Sony VGP-XL1B (200 disk CD/DVD jukebox)
Date: Wed, 15 Nov 2006 02:09:50 -0600
Message-ID: <1163578190.7801.187.camel@localhost.localdomain>
References: <1162685269.7801.16.camel@localhost.localdomain>
	<1162713408.7801.86.camel@localhost.localdomain>
	<454DB58F.7060401@s5r6.in-berlin.de>
Reply-To: linux1394@lightn.org
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-user-bounces@lists.sourceforge.net>
In-Reply-To: <454DB58F.7060401@s5r6.in-berlin.de>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-user>
List-Post: <mailto:linux1394-user@lists.sourceforge.net>
List-Help: <mailto:linux1394-user-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-user>,
	<mailto:linux1394-user-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-user-bounces@lists.sourceforge.net
Errors-To: linux1394-user-bounces@lists.sourceforge.net
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-user@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 2006-11-05 at 10:57 +0100, Stefan Richter wrote: 
> > The biggest problem is that it says it only has 38 slots.  Any ideas on
> > that one?
> 
> Hm. I suppose this number is obtained from the NUMBER OF STORAGE
> ELEMENTS in the Element Address Assignment mode page. Perhaps the
> firmware generates a malformed mode page. The sbp2 driver passes all
> these mode parameters from the device through to the SCSI drivers and
> applications as-is. (The contents of this mode page is defined by the
> SMC-3 or SMC-2 or SMC spec at http://www.t10.org/drafts.htm.)

Thanks for the reference, that is very useful information.

I haven't seen any more SCSI kernel errors in the log.  I think it is ok
as long as you are careful to send the unit commands that it likes.  I
am mainly writing this as a status report on making the unit work under
Linux.

I have determined what is occurring with the unit in regard to the
number of storage elements.  Primarily, it is buggy and doesn't follow
the spec (as I understand it).  MODE SENSE reports 200 storage elements,
1 import/export element, 1 data transfer element and 1 medium transport
element.  This is correct.  However, getting all of the data on these
elements is a bit more difficult.

Apparently READ ELEMENT STATUS on this device will only return a maximum
of 40 elements at a time, even if it should have plenty of space in the
element status page.  The kicker is that if you ask for less than *or
equal to* the number of elements it wants to return, it will freak out.
If the previous command was an element status request it will just
return the previous response.  If it wasn't, it will crash the device
and require a power cycle.

So you have to send 6 separate READ ELEMENT STATUS requests with
"starting element addresses" incrementing (by 40) and a "number of
elements" field of at least 41 to be safe, to get all of the information
from the media changer.  I ended up doing this and stitching the data
back together as if I had gotten back all of the information in a single
packet.  Then the standard parsing routines in mtx can read it.

The other problem is that it reports an extra storage element whose
element address is the one for the medium transport element (0).  Oddly,
it comes at the very end of the first element status packet of 40
elements.  That makes a total of 204 elements reported when there should
have only been 203 according to MODE SENSE (which complicates any
generic method for requesting all of the elements' statuses).  I simply
made mtx ignore any storage element information whose element address is
the same as the transport element address.  I don't understand what its
purpose might be, any ideas?

I now have a mtx program that operates all of the basic functions of the
media changer: load, unload, transfer, and status.

My main remaining concern is with the safe operation of the unload
command.  As I mentioned in a previous email, the media changer is
perfectly happy to unload a disk from the drive while it is still
spinning, obviously causing damage to the disk and possibly the changer.
With the stop command that Dan Dennedy added in his patch to mtx, I can
get the drive stopped if I retry until the command succeeds.  I am
worried about race conditions, however.  Is there a way to lock a SCSI
device for exclusive access so that I can guarantee a safe unload?  I.E.
that the disk stays stopped while the media changer unloads it.

> BTW, if you have a reasonably recent version of udev, you could
> certainly also use persistent device file names according to
> /sys/bus/scsi/devices/*/ieee1394_id which has the format
> EUI64_of_node:number_of_unit_directory:logical_unit_number, instead of
> the names /dev/sg* and /dev/sr* which may change by hotplugging.

Thanks for the tip.

Josha Foust



-------------------------------------------------------------------------
Take Surveys. Earn Cash. Influence the Future of IT
Join SourceForge.net's Techsay panel and you'll get the chance to share your
opinions on IT & business topics through brief surveys - and earn cash
http://www.techsay.com/default.php?page=join.php&p=sourceforge&CID=DEVDEV
