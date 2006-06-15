From: Frederic TEMPORELLI <frederic.temporelli@ext.bull.net>
Subject: IO blocks are limited to 512KBytes (blk_queue_max_sectors)
Date: Thu, 15 Jun 2006 16:47:47 +0200
Message-ID: <44917313.9040800@ext.bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ecfrec.frec.bull.fr ([129.183.4.8]:3761 "EHLO
	ecfrec.frec.bull.fr") by vger.kernel.org with ESMTP
	id S1030487AbWFOOr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 15 Jun 2006 10:47:56 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

Hello,


Using 2.6.16.20 with lpfc and scsi_debug, I wasn't able to get blocks larger 
than 512KBytes.
(should be the same with 2.6.17-rc6)

My test:
writting 10000 blocks, block size is 1MByte (=> 10 GBytes):

[root@iotiger2 ~]# cat /proc/diskstats | grep sdk
8 160 sdk 3 3 768 28 0 0 0 0 0 28 28
[root@iotiger2 ~]# dd if=/dev/zero of=/dev/sdk bs=1M count=10000
10000+0 records in
10000+0 records out
[root@iotiger2 ~]# cat /proc/diskstats | grep sdk
8 160 sdk 3 3 768 28 20007 139993 20480000 11271532 0 77680 11271556

=> there have been ~20000 ops (which means that block size is 512KBytes)

The 512KBytes size is also reported on the storage array side when using lpfc 
driver with a NEC 2400 system.


Then, I try to change BLK_DEF_MAX_SECTORS in include/linux/blkdev.h.

=> Using a value of 4096, IO blocks where 2MBytes large.


Now, locking at the block layer implementations, seems that there may be 
something wrong with blk_queue_max_sectors.
I know that max_sectors is set to 0xFFFF in the lpfc driver, and I was expecting 
to get the block layer queue max_sectors sized according to the low level driver 
max_sector.
but we have the following affectations:

q->max_hw_sectors = max_sectors
q->max_sectors = BLK_DEF_MAX_SECTORS

why q->max_sectors isn't set to max_sectors too ?
I've did a try with q->max_sectors=max_sectors and I was able to use 8MBytes 
blocks (measured from diskstat and from the NEC storage system too)

So, what is the nice way to change the block layer for getting large IO blocks 
(> 1024 sectors) ?


Best regards


-- 
Frederic TEMPORELLI
