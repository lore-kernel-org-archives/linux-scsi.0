From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Boot failure with block/for-next
Date: Wed, 22 Dec 2010 11:27:03 -0600
Message-ID: <1293038823.3019.89.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, Tejun Heo <htejun@gmail.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Trying to test out the SCSI post merge tree, I've found it won't boot on
my SCSI test system.  The reason is a failure to read the partition
table of the root disc.  It just gives

sda: unable to read partition table

The other four discs in the system seem to read their partition tables
OK.

The obvious candidate is the partition code rework in block/for-next.
Simply reverting 

commit d2bf1b6723ed0eab378363649d15b7893bf14e91
Author: Tejun Heo <tj@kernel.org>
Date:   Wed Dec 8 20:57:36 2010 +0100

    block: move register_disk() and del_gendisk() to block/genhd.c
 
Doesn't fix the boot failure, so it's obviously something deeper.

James
