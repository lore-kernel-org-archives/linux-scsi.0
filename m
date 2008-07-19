From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [RFC PATCH] HP (Compaq) Smart Array 5xxx controller SCSI driver
Date: Sat, 19 Jul 2008 19:52:26 +0900
Message-ID: <20080719195150Y.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1754399AbYGSKxu@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: mike.miller@hp.com
Cc: James.Bottomley@HansenPartnership.com, Jens.Axboe@oracle.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

This is a SCSI driver for HP (Compaq) Smart Array 5xxx controllers.

SCSI people can skip the following two paragraphs.

Currently, a driver for HP (Compaq) Smart Array 5xxx controllers is
implemented as a block device driver, block/cciss.c (aka, cciss). But
the controller interface is SCSI-3 compatible. The specification says,
"A controller that supports CISS is considered to be a SCSI storage
array controller". A scsi driver for the controllers was discussed
several times.

I think that a SCSI cciss driver can be much simpler (and
maintainable) than the block cciss driver (the majority of the code
forging SCSI command can go away, we have the proper sysfs entries for
free, we can handle scsi tape drives easily etc). It would be helpful
for distributions too since they don't need stuff specific to cciss
(such as udev rules).


There isn't any easy migration path for users. So I think that we need
to keep the block and scsi drivers for cciss for some time (say two
years).

My scsi driver is still in an early stage (I tried to keep the changes
minimum). I can detect logical units, mount a file system, do lots of
I/Os, however, there are lots of TODOs in the management features.

If I can get an ACK from HP about the long-term migration of cciss to
SCSI, I'm happy to keep working on the SCSI cciss driver and maintain
it until HP takes over the driver.


The patch is available at:

http://www.kernel.org/pub/linux/kernel/people/tomo/ciss/0001-add-HP-Compaq-Smart-Array-5xxx-controller-SCSI-dri.patch

clover:/home/fujita# insmod ciss.ko
clover:/home/fujita# lsscsi
(snip)
[1:0:0:0]    disk    HP       LOGICAL VOLUME   1.66  /dev/sde
[1:0:0:1]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdf
[1:0:0:2]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdg
[1:0:0:3]    disk    HP       LOGICAL VOLUME   1.66  /dev/sdh

Yeah, it just works as SCSI disk, the dmesg says:

sd 1:0:0:0: [sde] Attached SCSI disk
sd 1:0:0:1: [sdf] 143305920 512-byte hardware sectors (73373 MB)
sd 1:0:0:1: [sdf] Write Protect is off
sd 1:0:0:1: [sdf] Mode Sense: 5b 00 00 08
sd 1:0:0:1: [sdf] Write cache: disabled, read cache: enabled, doesn't support DPO or FUA

I needed a different name and just stole 'ciss' from *BSD. But any
names (like hpciss) works for me.


Thanks,
