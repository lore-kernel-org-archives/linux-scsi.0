From: Douglas Gilbert <dougg@torque.net>
Subject: sg3_utils-1.02 and sg_utils-1.02 betas
Date: Thu, 12 Dec 2002 23:10:08 +1100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DF87CA0.50702@torque.net>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from torque.net (dm1-49.triode.net.au [202.147.125.49])
	by iggy.triode.net.au (8.11.6/8.11.6) with ESMTP id gBCC7fB15099
	for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2002 23:07:42 +1100
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

There are tarballs of these 2 packages linked at the top
of my http://www.torque.net/sg page.

As noted earlier the addition of some of sg's ioctls in
the block level (from about lk 2.5.48) brings both
advantages and dangers.

The main danger is that utilities (e.g. most of those
in sg_utils) that assume that any device responding to
one of sg's ioctls is an sg device and hence it is safe
to use sg's older write()/read() interface. **

The advantage is that the variant that assumed the version
3 sg driver (i.e. sg3_utils-1.02) can send SG_IO ioctls
straight through to block devices. For example:
   sg_inq /dev/sdb
   sg_logs -p=d /dev/sda    # this is the temperature page
The SG_IO ioctl in the block level still has some rough
edges. Hence utilities like sg_dd still treat block devices
like normal files (although there is an extra option to
send SG_IO ioctls through to block devices).

See the CHANGELOG file for more details.


** I have some practical experience of what happens (with
sginfo). The first 48 bytes (or so) of a disk get overwritten.
This damages the boot loader (grub in my case) so you can no
longer boot with that disk. The good news is that all
partitions and the partition table are still intact.
Luckily the first 48 bytes on a boot disk of redhat's last
few versions (since they defaulted to grub) are invariant.

Doug Gilbert

