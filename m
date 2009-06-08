From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: 2.6.30-rc8 Oops whilst booting
Date: Mon, 08 Jun 2009 14:23:20 +0000
Message-ID: <1244471000.4079.36.camel@mulgrave.site>
References: <200906061959.55592.chris2553@googlemail.com>
	 <200906062215.30571.chris2553@googlemail.com>
	 <1244381140.30664.12.camel@ht.satnam>
	 <c6b1100b0906071138g2c46fb34vc1a2beb9438f1f1e@mail.gmail.com>
	 <1244413881.18742.31.camel@ht.satnam>
	 <2f9e3044bafcae848f74a1492b0ea471.squirrel@neil.brown.name>
	 <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33278 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754843AbZFHOXW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Jun 2009 10:23:22 -0400
In-Reply-To: <c6b1100b0906080108y191bb157n67ec681ade2a0d13@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Clayton <chris2553@googlemail.com>
Cc: NeilBrown <neilb@suse.de>, Jaswinder Singh Rajput <jaswinder@kernel.org>, linux-kernel@vger.kernel.org, scsi <linux-scsi@vger.kernel.org>, Tejun Heo <tj@kernel.org>, Arjan van de Ven <arjan@infradead.org>

On Mon, 2009-06-08 at 09:08 +0100, Chris Clayton wrote:
> Hi Neil,
> 
> Thanks for the reply.
> 
> 2009/6/7 NeilBrown <neilb@suse.de>:
> > On Mon, June 8, 2009 8:31 am, Jaswinder Singh Rajput wrote:
> >> On Sun, 2009-06-07 at 19:38 +0100, Chris Clayton wrote:
> >>> 2009/6/7 Jaswinder Singh Ra
> >>> >> > http://img231.imageshack.us/img231/8931/dscn0610.jpg
> >
> > This message says that it found a vfat filesystem on 8:3x (I cannot see
> > what digit should be 'x').  That is probably sdc1 or sdc2. Maybe even
> > sdc6 or sdc7.
> > However the vfat filesystem didn't have /sbin/init.
> >
> 
> >>> http://img99.imageshack.us/my.php?image=dscn0617b.jpg
> >
> > This one says it couldn't find anything at 8,22, which I think
> > should be sdb6.
> > It also shows that you have and sdc6, but sdb only goes up to sdb3.
> >
> > So it seems that your disk drives have changed name - not a wholely
> > unexpected event these days.
> >
> > We now need answers to questions like:
> >  - what device do you expect the root filesystem to be on
> >  - how is the kernel being told this?  Maybe it is hard coded
> >    into your initrd.  Knowing which distro and what /etc/fstab
> >    says might help (though it wouldn't help me, I'm just about out
> >    of my depth at this point)
> > Maybe if you changed /etc/fstab to mount by uuid instead of hardcoding
> > e.g. /etc/sdb3, and then run "mkinitramfs" or whatever, it might work.
> >
> 
> Yes, I've just been looking at the photographs of the panics again and
> I've noticed that two of my discs are being detected in the "wrong
> order". There are three HDDS. The first, /dev/sda, is the master on
> the first IDE port and contains sda1..sda7. The second, normally
> /dev/sdb, is the slave on that port and contains sdb1..sdb6. The
> third, normally /dev/sdc, is attached to the first SATA port and
> contains sdc1..sdc3. The second photograph I posted shows that sdb and
> sdc have been reversed. The first partition on the disc that is
> normally /dev/sdb does indeed have a FAT32 filesystem in the first
> partition.
> 
> By the way, I should have said that in between the panics that the two
> photographs show, I copied contents of /dev/sdc1, which I normally
> boot from, to /dev/sdb6, so that I minimised the risk to sdc1 in the
> reboot festival that bisecting would involve. I also, of course,
> changed the name of the root partition that is passed to the kernel by
> GRUB and amended /etc/fstab on /dev/sdb6. That's why the partitions
> shown in the photographs seem inconsistent. Sorry I forgot to mention
> that - I really shouldn't do these things late at night :-).

Actually, you can save yourself a lot of pain by mounting by label
instead ... that way both grub and fstab will find your root disc even
if it has swapped order.

> As I indicate above, when booting the partition I have set up to do
> this bisecting,  I expect the root filesystem to be on /dev/hdb6. As I
> also indicate, this information is passed to the kernel through GRUB's
> /boot/grub/menu.lst. The kernel is configured specifically for my
> system and the drivers needed to boot the system are built in to the
> kernel, so I don't use an initrd. IIRC, that's the way Slackware is
> installed today, except, of course, it's a big fat kernel with all
> drivers needed to boot any system built in. I could be wrong on that
> though, it's a while since I installed

The fact that a slave on the first channel is detected after the SATA
indicates a problem with async probing.  What are the two drivers for
these?

James


