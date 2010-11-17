From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: mvsas errors in 2.6.36
Date: Wed, 17 Nov 2010 00:53:31 -0700
Message-ID: <201011170053.31174.thomas@fjellstrom.ca>
References: <201010290650.32892.thomas@fjellstrom.ca> <201010310911.45738.thomas@fjellstrom.ca>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tomasu.net ([64.85.170.234]:51120 "EHLO mail.tomasu.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759880Ab0KQHxo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 17 Nov 2010 02:53:44 -0500
In-Reply-To: <201010310911.45738.thomas@fjellstrom.ca>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Cc: linux-scsi@vger.kernel.org

On October 31, 2010, Thomas Fjellstrom wrote:
> On October 29, 2010, Thomas Fjellstrom wrote:
> > Good news and bad news, the current mvsas driver in 2.6.36 seems to work
> > better than older kernels with my setup (2 port sas + 5 SATA disks). But
> > I gotten the following messages so far:
> > 
[snip]
> > I did not unplug a disk, the errors seem to be spurious.
> > 
> > Otherwise though things seem to be working. At least so far. The
> > mv_abort_task part is very familiar, the older version of this driver
> > would do it right after attempting to build/activate the md raid5 array
> > that lives on this controller. Except the controller would lock up, and
> > all drives would become inaccessible.
> > 
> > I'm going to attempt to grow this array today, so long as the xfs_fsr
> > that I started doesn't cause the array to fail.
> > 
> > If I keep getting mv_abort_task errors, I'll have to back down to the
> > copy of the driver I got from Andy Yan. I've managed to patch it up to
> > compile for 2.6.36 just now, I just hope it'll work at least as well as
> > it did with 2.6.34. At the very least I didn't get these errors.
> > 
> > Some background, the disks attached to the card are (5) Seagate 7200.12
> > 1TB disks, using SAS->SATA cables. Machine is a amd64 Phenom II X4 810
> > w/4G ram running debian sid and a vanila 2.6.36 kernel. The card is a
> > AOC-SASLP-MV8, according to lspci:
> > 
> > 04:00.0 SCSI storage controller: Marvell Technology Group Ltd.
> > MV64460/64461/64462 System Controller, Revision B (rev 01)
> > 
> > according to dmesg:
> > 
[snip]
> > I just hope the raid5 reshape I'm about to do doesn't crap its pants
> > because of the errors above.
> > 
> > I'd like to help test any fixes or changes if needed. Let me know.
> > 
> > Thanks again.
> 
> After a couple days of uptime, the messages are still happening:
> 
[snip]
> No fatal errors yet.

Still no fatal errors, but the problem is still happening regularly. It causes 
a pause in disk io of a couple seconds at least. Really quite annoying.

One thing thats got me wondering, is could this be a power issue? It almost 
seems like (from the messages) that a single drive (any drive) is freaking 
out, and returning an error that probably shouldn't happen (no CHS 0?), which 
could mean the drive is underpowered and the firmware is flipping out. I'm not 
entirely sure. The system has a 750w decent quality Antec power supply. The 
total power use of the system shouldn't come over half that (phenom II x4 810 
cpu, gigabyte ma790fxtud5p mb, low profile nvidia 9400GS gpu, 8 sata hdds, 3 
fans, etc). I'm /mostly/ sure the 12v rails are spread out evenly, but I have 
yet to make absolutely sure.

But then it doesn't seem as if the root drives are ever flipping out. Theres 
two 500GB Seagate 7200.12 drives md raid1'ed on the motherboard's (SB750) sata 
II controller. They work fine, no messages regarding them at all the entire 
time. However I get frequent and repeated messages from all drives on the 
mvsas based controller.

So color me stumped.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
