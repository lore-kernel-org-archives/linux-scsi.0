From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Some quick scsi documentation questions:
Date: Thu, 02 Aug 2007 23:19:51 +0200
Message-ID: <46B24A77.2050809@s5r6.in-berlin.de>
References: <200707252328.28981.rob@landley.net> <1185455711.3501.46.camel@localhost.localdomain> <200707271729.11422.rob@landley.net> <46B2256A.3070902@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:46345 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760832AbXHBVUR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Aug 2007 17:20:17 -0400
In-Reply-To: <46B2256A.3070902@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Rob Landley <rob@landley.net>
Cc: dougg@torque.net, James Bottomley <James.Bottomley@steeleye.com>, linux-scsi@vger.kernel.org

> Rob Landley wrote:
>> On Thursday 26 July 2007 9:15:11 am James Bottomley wrote:
>>> Users have great difficulty understanding how to 
>>> map sg to sr (or sd), so we're trying to encourage them only to use the
>>> actual device node, so /dev/sdx or /dev/srn.
>> Actually, these days everybody I know uses /dev/cdrom, expects it to be a 
>> symlink, and doesn't care where it points.  Last time I used a system that 
>> had more than one of the suckers I believe it had /dev/cdrom0, /dev/cdrom1, 
>> etc.
>>
>> I note that in the ubuntu system on my laptop, /dev/sr0 is a symlink 
>> to /dev/scd0, which is an actual device node with a major and minor that 
>> presumably means something to the system, but not to me personally.  (Not 
>> that I consider Ubuntu 7.04 much of a model on how to arrange devices 
>> considering it put a UUID label on every _partition_ on my hard drive and 
>> mounts them by label in /etc/fstab rather than that having udev do its job 
>> and make stable symlinks.)
>>
>> But it seems that users aren't the only ones who have trouble with this, 
>> distro maintainers do too.

Alternatively to partition labels, you can also have udev create
persistently named symlinks for you.

$ ls /dev/disk/by-id/
ata-HTE721010G9AT00_MPC0J1Y0GRKYGD
ata-HTE721010G9AT00_MPC0J1Y0GRKYGD-part1
ata-HTE721010G9AT00_MPC0J1Y0GRKYGD-part2
ieee1394-00101003ae0001e0:00042c:0000
ieee1394-00101003ae0001e0:00042c:0000-part1
scsi-SATA_ST3750640AS_3QD067RX
scsi-SATA_ST3750640AS_3QD067RX-part1
usb-JetFlash_128MB_39680ADE3E2627FB
usb-JetFlash_128MB_39680ADE3E2627FB-part1

The udev rules I have here (Gentoo's) apparently don't do this for
CD/DVD-ROM/R/Ws although that should be possible as well.  On the other
hand, application programs like K3B already nicely show devices with
vendor and model strings.  I don't know how much effort that imposes on
the application programs.
-- 
Stefan Richter
-=====-=-=== =--- ---=-
http://arcgraph.de/sr/
