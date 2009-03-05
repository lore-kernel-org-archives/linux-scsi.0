From: Andrew Patterson <andrew.patterson@hp.com>
Subject: Re: [PATCH] hpsa: SCSI driver for HP Smart Array controllers
Date: Thu, 05 Mar 2009 16:54:19 +0000
Message-ID: <1236272059.7050.14.camel@grinch>
References: <20090302145650.GW15340@beardog.cca.cpqcorp.net>
	 <20090303153402A.fujita.tomonori@lab.ntt.co.jp>
	 <20090303162821.GB15340@beardog.cca.cpqcorp.net>
	 <20090305144843N.fujita.tomonori@lab.ntt.co.jp>
	 <20090305142114.GG15340@beardog.cca.cpqcorp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:33775 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752707AbZCEQyZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2009 11:54:25 -0500
In-Reply-To: <20090305142114.GG15340@beardog.cca.cpqcorp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: scameron@beardog.cca.cpqcorp.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-kernel@vger.kernel.org, mike.miller@hp.com, jens.axboe@oracle.com, akpm@linux-foundation.org, linux-scsi@vger.kernel.org, coldwell@redhat.com, hare@novell.com, iss_storagedev@hp.com

On Thu, 2009-03-05 at 08:21 -0600, scameron@beardog.cca.cpqcorp.net
wrote:
> On Thu, Mar 05, 2009 at 02:48:09PM +0900, FUJITA Tomonori wrote:
> > On Tue, 3 Mar 2009 10:28:21 -0600
> > scameron@beardog.cca.cpqcorp.net wrote:
> > 
> > > On Tue, Mar 03, 2009 at 03:35:26PM +0900, FUJITA Tomonori wrote:
> > > > On Mon, 2 Mar 2009 08:56:50 -0600
> > > > scameron@beardog.cca.cpqcorp.net wrote:
> > > > 
> > > > > [...]
> > > > > > > +     .this_id                = -1,
> > > > > > > +     .sg_tablesize           = MAXSGENTRIES,
> > > > > > 
> > > > > > MAXSGENTRIES (32) is the limitation of hardware? If not, it might be
> > > > > > better to enlarge this for better performance?
> > > > > 
> > > > > Yes, definitely, though this value varies from controller to controller,
> > > > > so this is just a default value that needs to be overridden, probably
> > > > > in hpsa_scsi_detect().
> > > > 
> > > > I see. If we override this in hpsa_scsi_detect(), we need a trick for
> > > > SG in CommandList_struct, I guess.
> > > 
> > > Yes.  There are some limits to what can be put into CommandList_struct
> > > directly, but there is also scatter gather chaining, in which we use
> > > the last element in the CommandList_struct to point to another buffer
> > > of SG entries.
> > > 
> > > If you have a system with a lot of controllers, having a large number of 
> > > scatter gathers can be a bit of a memory hog, and since this memory is all
> > > via pci_alloc_consistent, that can be a concern.  It would be nice if
> > > there was a way for the user to specify differing amounts of scatter
> > > gathers for different controller instances so for instance the controller
> > > which he's running his big oracle database, or webserver or whatever on
> > > gets lots, while the controller he's booted from that's mostly idle
> > > gets not so many.  I don't know what a good way for a user to identify
> > > what controller he's talking about in a module parameter would be 
> > > though.  Maybe by pci domain/bus/device/function?  Maybe something along
> > > the lines of:
> > > 
> > > 	modprobe hpsa dev1=0:0e:00.0 sg1=1000 dev2=0:0b:00.0 sg2=31
> > > 
> > > to say that one controller gets 1000 scatter gather elements, but
> > > another gets only 31.  But PCI busses can change if hardware 
> > > configuration changes, and this isn't exactly obvious, so seems less
> > > than ideal.  Any bright ideas on that front?
> > 
> > We have /sys/class/scsi_host/host*/sg_tablesize:
> > 
> > How about modifying this value on the fly?
> > 
> > fujita@clover:/sys/class/scsi_host/host3$ echo 1000 > sg_tablesize
> > 
> 
> We pci_alloc_consistent that space, so... I think that would mean
> we'd have to do things considerably differently.  I think we'd have
> to quit allocating commands in big chunks, and instead of indexing
> into that chunk we'd probably have to have an array of pointers or
> something.  If we wanted sg_tablesize adjustable down to single
> command counts, we'd probably have to allocate each command separately
> and have an array of pointers to those...
> 
> e.g. if you did 
> 
> 	echo 1000 > sg_tablesize
> 	echo 999 > sg_tablesize
> 
> you probably wouldn't want to keep the 1000 commands around,
> and then allocate 999 additional, then let all the outstanding 
> commands using the first 1000 block complete, then finally free
> the first block of 1000, leaving just the 999.  You'd probably want
> instead to free one of the 1000 to get to 999.
> 
> Likewise with this:
> 
> 	echo 999 > sg_tablesize
> 	echo 1000 > sg_tablesize
> 
> These are somewhat pathological cases, granted.
> 
> I'm not sure dynamically modifying the number of SGs a controller
> can do is something that comes up enough to be worth implementing
> something so complicated.
> 
> If it's settable at init time, that would probably be enough for
> the vast majority of uses (and more flexible than what we have now)
> and a lot easier to implement.
> 
> > 
> > Well, this needs more changes (to both the block layer and the scsi
> > mid layer) but is it nice to change this value dynamically?
> > 
> > Anyway, I think that it's better to address this fancy feature later
> > on (after the mainline inclusion). Let's put hpsa driver into mainline
> > first.
> 
> Agreed, we can think about all that stuff later.
> 
> Another fancy feature to think about later which would be nice:
> 
> On Smart arrays you can expand logical drives on the fly by
> adding physical disks, or portions of physical disks into them.
> Would be nice if there was a non-i/o-interrupting way to notify
> the scsi layer of this new space (maybe there already is?) so
> that if there's, say, a filesystem which can also dynamically
> grow on the fly on that embiggened logical drive, it can take
> advantage of that extra space.
> 
> Right now, the driver will do scsi_remove_device() and then
> scsi_add_device() if a logical drive changes size, which isn't
> very nice.
> 

The following might help:

There are several ways to "kick off" a device size change:

1. For SCSI devices do:

  # echo 1 > /sys/class/scsi_device/<device>/device/rescan

  or

  # blockdev --rereadpt <device file>

2. Other devices (not device mapper)

  # blockdev --rereadpt <device file>

See http://marc.info/?l=linux-kernel&m=122056065131792&w=2

Andrew

> > 
> > 
> > > > > Hmm, this doesn't seem all that complicated to me, and this code snippet
> > > > > has been pretty stable for about 10 years. it's nearly identical to what's in
> > > > > cpqarray in the 2.2.13 kernel from 1999:
> > > > > 
> > > > >                 do {
> > > > >                         i = find_first_zero_bit(h->cmd_pool_bits, NR_CMDS);
> > > > >                         if (i == NR_CMDS)
> > > > >                                 return NULL;
> > > > >                 } while(test_and_set_bit(i%32, h->cmd_pool_bits+(i/32)) != 0)
> > > > > 
> > > > > It's fast, works well, and has needed very little maintenance over the 
> > > > > years.  Without knowing what you have in mind specifically, I don't see a
> > > > > big need to change this.
> > > > 
> > > > I see. Seems that some drivers want something similar. I might come
> > > > back later on with a patch to replace this with library
> > > > functions.
> > > 
> > > There was some other discussion about pushing this sort of thing to 
> > > upper layers, using a tag generated in the scsi layer as a means
> > > of allocating driver command buffers, since, presumably there's a
> > > one to one mapping.  (I didn't completely grok it all though.)
> > 
> > Oops, I meant that I might come back with a patch to convert hpsa to
> > use the the block layer tagging, which you and Mike Christie are
> > talking about (yeah, my first suggestion to use lists was wrong. using
> > the block layer tagging looks much better).
> > 
> > 
> > By the way, have you guys started to work on the review comments for
> 
> We haven't really done much.  It's obvious that there's a lot to do
> based on the comments, and it's also obvious how to do most of it,
> and not hard, (e.g. ripping out /proc stuff, etc.), there's just a
> lot of other non-kernel related work keeping us busy at the moment.
> 
> > the next submission? The driver has some minor style issues that have
> > not been mentioned yet. For example, the comment style in the driver
> > is not preferred:
> > 
> > /* If this device a non-zero lun of a multi-lun device */
> > /* byte 4 of the 8-byte LUN addr will contain the logical */
> > /* unit no, zero otherise. */
> > 
> > The preferred style is:
> > 
> > /*
> >  * If this device a non-zero lun of a multi-lun device
> >  * byte 4 of the 8-byte LUN addr will contain the logical
> >  * unit no, zero otherise.
> >  */
> 
> ok.
> 
> > 
> > Another example, I think that the SCSI-ml preferred style is (not
> > documented in CodingStyle though):
> > 
> > 'if (!ptr)' rather than 'if (ptr == NULL)'
> > 'if (!value)' rather than 'if (value == 0)'
> > 'if (ptr)' rather than 'if (ptr != NULL)'
> > 'if (value)' rather than 'if (value != 0)'
> 
> Ok.
> 
> > 
> > 
> > If you are already addressing the review comments, I just wait for the
> > next submission, then I'll send such minor patches. If you are not,
> > I'll send patches to address the review comments (including such minor
> > patches).
> 
> Ok, thanks.
> 
> -- steve
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


