From: Douglas Gilbert <dougg@torque.net>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 02 Aug 2007 14:41:46 -0400
Message-ID: <46B2256A.3070902@torque.net>
References: <200707252328.28981.rob@landley.net> <1185455711.3501.46.camel@localhost.localdomain> <200707271729.11422.rob@landley.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:57053 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751921AbXHBSmA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 14:42:00 -0400
In-Reply-To: <200707271729.11422.rob@landley.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

Rob Landley wrote:
> On Thursday 26 July 2007 9:15:11 am James Bottomley wrote:
>> On Wed, 2007-07-25 at 23:28 -0400, Rob Landley wrote:
>>> 1) Is the summary of the scsi subsystem in appendix A of your 2002 OLS
>>> paper still more or less current?  (The scsi mid-layer document never
>>> seems to talk about the _upper_ layer it interfaces with.  Which is
>>> presumably the block layer...)
>> No, the block layer is the service layer.  Upper layer is the SCSI
>> driver layer (top level drivers like sd, sr and st).
> 
> Now that I've noticed that http://sg.torque.net/scsi/SCSI-2.4-HOWTO.html and 
> http://sg.torque.net/scsi/SCSI-Generic-HOWTO.html are separate documents, I 
> see where that's documented. :)
> 
> So upper layer drivers provide /dev nodes, lower level talks to SCSI hardware, 
> and the mid-layer understands scsi commands ala http://www.t10.org/scsi-3.htm  
> 
> Where _does_ the block layer work into this?
> 
>>> 2) Documentation/scsi/scsi_fc_transport.txt is talking about Fiber
>>> Channel, right?  (It never expands the fc, not even in the title...)
>> Yes.
> 
> Already sent a separate email about that one.  (Although I now see that 
> t10.org inclues some fiber channel standards, and what the relationship 
> between it and t11 is I have no idea.)
> 
>>> 3) After reading Documentation/scsi/scsi-generic.txt I'm curious what the
>>> relationships between a given sg device and sd device.  Each sd has a
>>> corresponding sg?  (I can't find where it explicitly says this, but it's
>>> a char device, not a block device, so...)  They're always in the same
>>> order? Does _each_ sd have an sg?  Can I call the SG_IO ioctl on an sd? 
>>> Is there an obvious document on this I've missed?
>> This is one of those evolutionary problems in Linux.  Originally sg
>> existed simply to provide the SG_IO ioctl to SCSI devices.  Then,
>> because it was extremely useful, we made it a core feature of the block
>> layer (in block/scsi_ioctl.c) which extended it as a general packet
>> command feature to devices beyond SCSI.
> 
> But it's still a char device, so you presumably can't mount /dev/sg1 to read 
> the CD in your burner.  You need to burn the CD and mount the CD through 
> separate devices.
> 
> To someone like me from the IDE world, the numbering on scsi is weird.  It 
> won't leave holes like the ATA driver did to avoid renumbering categories of 
> devices that can't be moved without a screwdriver.  (I realize there _are_ 
> truly dynamic devices, but the hard drive in my laptop is not one of them and 
> it's an artifact of the scsi layer that it's considered so.)
> 
> So if you don't attach an sg to every sd, then either there are holes, or they 
> don't line up, in which case how do you tell which sg goes with a given sd?
> 
>> The logical thing then became to 
>> attach sg as an upper driver *only* to devices which otherwise wouldn't
>> have one ... however, the sg maintainer has never accepted this.
> 
> Do you mean only to devices that otherwise wouldn't have an upper driver?  (So 
> there would be an sg for devices that have _no_ sd?  This implies that the 
> answer to my earlier question about whether the SG_IO ioctl can be used on sd 
> block devices is "yes"?  (In which case the bit where the sg document talked 
> about the nonblocking write to sg thing being useful for queueing commands 
> comes back up, is there currently a way to do that through the sd ioctl?)
> 
> It sounds like your preferred solution would be to have either an sg _or_ an 
> sd for each scsi device, so there would be no duplicates but only "no holes" 
> if you look at _both_ groups and interlace them.  And the sg maintainer went 
> with "have both for every device"?
> 
>> Various distros have tried it at various times, though, so currently
>> it's safe to say that if sg is loaded, every SCSI device has an sg node,
>> but it's not safe to assume that universally.
> 
> Ok, so currently, on distros using recent 2.6 kernels, there's an sg 
> corresponding to every sd, using the same number.  Right.
> 
> Did the various distros patch the kernel, or did they do udev rules to filter 
> out the sg they didn't want?  Any idea which distros those were, and whether 
> or not they're still relevant?
> 
>> We can't even agree on 
>> unifying the SG_IO paths, so we have two separate codings, one in sg.c
>> and one in block/scsi_ioctl.c.
> 
> What would unifying the SG_IO paths mean?  Would it have any impact on 
> userspace, or is it just an implementation detail inside the kernel?
> 
>>>  seems that a read-only cd will be an sd, but you talk to a burner
>>> through an sg...)
>> No, they're both sr.
> 
> What was that again?  (Googles...)  Oh yeah, the "upper layer" drivers from 
> the scsi-2.4-howto.  I thought scsi-tape and scsi-cdrom were obsolete, but I 
> guess not. 
> 
> Back in the IDE world, my hard drive was /dev/hda and my CD burner 
> was /dev/hdc.  When /dev/hdc gained the ability to be used directly as a cd 
> burner, I just assumed you could do it to sd as well.  My initial mental 
> model was "sg gives you a char device to pass through scsi commands for a 
> random scsi device, and sd gives you a way to look at it as a block device", 
> which doesn't explain sr and st but as I said I thought they were obsolete...
> 
>> Users have great difficulty understanding how to 
>> map sg to sr (or sd), so we're trying to encourage them only to use the
>> actual device node, so /dev/sdx or /dev/srn.
> 
> Actually, these days everybody I know uses /dev/cdrom, expects it to be a 
> symlink, and doesn't care where it points.  Last time I used a system that 
> had more than one of the suckers I believe it had /dev/cdrom0, /dev/cdrom1, 
> etc.
> 
> I note that in the ubuntu system on my laptop, /dev/sr0 is a symlink 
> to /dev/scd0, which is an actual device node with a major and minor that 
> presumably means something to the system, but not to me personally.  (Not 
> that I consider Ubuntu 7.04 much of a model on how to arrange devices 
> considering it put a UUID label on every _partition_ on my hard drive and 
> mounts them by label in /etc/fstab rather than that having udev do its job 
> and make stable symlinks.)
> 
> But it seems that users aren't the only ones who have trouble with this, 
> distro maintainers do too.
> 
> Question: how much of the difference between /dev/sd* and /dev/sr* do users 
> actually have to care about these days?  (And is st still relevant, or does 
> sg cover that?)
> 
>>> 4) Is http://www.tldp.org/HOWTO/SCSI-Generic-HOWTO/ still current, given
>>> it was last updated in 2002?
>> Probably not ... the transport classes all come after that.
> 
> Unfortunately, Documentation/scsi/scsi-generic.txt (which seems a logical 
> starting point) is essentially nothing more than a link to that document and 
> a note about using scsi drivers as modules.
> 
> It also still seems to be the best introduction to sd vs sr vs sg.  It would 
> be nice if there was some kind of quick reference card listing the 
> concepts...
> 
> Similarly, Documentation/scsi/scsi.txt is a link to the SCSI-2.4-HOWTO and a 
> note about using scsi drivers as modules.  (And the first time I read those 
> two, I didn't notice that the SCSI-2.4-HOWTO and the SCSI-Generic-HOWTO were 
> two separate documents...)
> 
>>> 5) I notice there's a "man 4 sd", from 1992.  Still relevant?
>> Yes .. but only as far as it goes, which isn't very far.
> 
> I noticed.  It'd be nice if it at least explained the differences between sd, 
> sr, st, and sg.  I'll ping the man-pages maintainer about it...
> 
>> Taking this to linux-scsi might be the best course ...
> 
> And now that I've confirmed it's ok with you, I've cc'd this thread there.
> 
>> Doug Gilbert 
>> tends to be the best maintainer of our docs, although he's the sg
>> author, which is why the docs tend to emphasize it as the preferred
>> option ...
> 
> I'm still trying to figure what the other options _are_.
> 
>> James
> 
> Rob

Interesting discussion.

However I think that I would object to this statement by James:
" The logical thing then became to attach sg as an upper driver
  *only* to devices which otherwise wouldn't have one ... however,
  the sg maintainer has never accepted this."

It is interesting to note that the new bsg driver follows the
approach by the sg driver: mapping all ** devices irrespective
of whether they "belong" to other drivers or not.

In the case of the sg driver, there was backward compatibility
to worry about. In the case of bsg it is just a mistake, IMO.
The bsg driver should be doing what it did in its original
incarnation: have one char device called /dev/bsg (why not
/dev/csg ??) and let apps open that device to get a file
descriptor context from which they could bind to any entity
that would permit it. That entity might be:
   - the SCSI mid layer
   - a (SCSI) transport
   - a host driver
   - a host device (SCSI initiator device or port)
   - a SCSI target
   - a SCSI logical unit
   - an active element in a SCSI delivery subsystem
     (e.g. a switch in FC or and expander in SAS)


We continue to have a model where the mid-level's scan
algorithm (and perhaps the transport) decide what "devices"
will be shown. As an example will they show a SCSI target
(perhaps a bridge) with no logical units visible, even
though lun 0 replies [peri_qual=3 and pdt=0x1f]? I
suspect not. Such a target might support an access control
well known logical unit which, given the correct interaction,
may expose otherwise hidden storage logical units.

In the same way a pass-through is a nuisance to many
overarching OS designs, the reverse is true for some
pass-through users.


** As noted above "all" is an overestimate. The pass-through
only gets to map to devices that the sysfs/udev mess decides
are relevant.


Doug Gilbert
