From: Rob Landley <rob@landley.net>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 2 Aug 2007 20:55:45 -0400
Message-ID: <200708022055.45523.rob@landley.net>
References: <200707252328.28981.rob@landley.net> <46B2256A.3070902@torque.net> <46B24A77.2050809@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:37739
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754287AbXHCAzt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 20:55:49 -0400
In-Reply-To: <46B24A77.2050809@s5r6.in-berlin.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

On Thursday 02 August 2007 5:19:51 pm Stefan Richter wrote:
> > Rob Landley wrote:
> >> On Thursday 26 July 2007 9:15:11 am James Bottomley wrote:
> >>> Users have great difficulty understanding how to
> >>> map sg to sr (or sd), so we're trying to encourage them only to use the
> >>> actual device node, so /dev/sdx or /dev/srn.
> >>
> >> Actually, these days everybody I know uses /dev/cdrom, expects it to be
> >> a symlink, and doesn't care where it points.  Last time I used a system
> >> that had more than one of the suckers I believe it had /dev/cdrom0,
> >> /dev/cdrom1, etc.
> >>
> >> I note that in the ubuntu system on my laptop, /dev/sr0 is a symlink
> >> to /dev/scd0, which is an actual device node with a major and minor that
> >> presumably means something to the system, but not to me personally. 
> >> (Not that I consider Ubuntu 7.04 much of a model on how to arrange
> >> devices considering it put a UUID label on every _partition_ on my hard
> >> drive and mounts them by label in /etc/fstab rather than that having
> >> udev do its job and make stable symlinks.)
> >>
> >> But it seems that users aren't the only ones who have trouble with this,
> >> distro maintainers do too.
>
> Alternatively to partition labels, you can also have udev create
> persistently named symlinks for you.

A) You never need to label the _partition_, you need to consistently identify 
the _device_ and the partitions fall out from that.

landley@dell:/$ cat /sys/block/sr0/device/model
CDRWDVD DW224EV
landley@dell:/$ cat /sys/block/sda/device/model
Hitachi HTS54161

Why exactly do I need a uuid to identify either of these when I only have one 
of each in the system and _know_ I'll never have more than that?  (Sure go 
for a uuid when there's more than one hard drive.  But please explain to me 
how a uuid would help if I had two identical DVD burners with no media in 
them on bootup...)

B) This particular device can't move without a screwdriver, and you can't add 
another sata drive to this laptop without a soldering iron.

The fact that modern Linux kernels can't consistently identify it during 
bootup is a design flaw.  (Yes, I followed the discussion of all this years 
ago, but the fact remains that there are certain very common types of 
hardware that only get confused by things like USB keys because both the USB 
keys, which may speak a scsi-like protocol but aren't actually scsi hardware, 
and SATA drives, ditto, get routed into the same scsi layer heap and 
conflated.  And that's sad.

> The udev rules I have here (Gentoo's) apparently don't do this for
> CD/DVD-ROM/R/Ws although that should be possible as well.

Many things are possible.  It doesn't make them a good idea.  Telling udev to 
do something complicated to keep track of a device that I know, at OS install 
time, _can't_ever_physically_move_, is one of them.

> On the other 
> hand, application programs like K3B already nicely show devices with
> vendor and model strings.  I don't know how much effort that imposes on
> the application programs.

See above, but notice that Greg KH says that any program that follows 
the "device" symlink is buggy, because he doesn't want to be tied down to 
anything as mundane as a stable userspace API.

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.
