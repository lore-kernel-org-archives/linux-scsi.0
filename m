From: Fam Zheng <famz@redhat.com>
Subject: [PATCH 0/3] Fix return code for ioctl( BLKRRPART ) if device is down
Date: Tue, 24 Mar 2015 18:16:12 +0800
Message-ID: <1427192175-23802-1-git-send-email-famz@redhat.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45736 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751708AbbCXKQY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Mar 2015 06:16:24 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi@vger.kernel.org, famz@redhat.com

If issued right after link down, "blockdev --rereadpt" will be stuck for a
while and then return normally. Although the underlying capacity and partition
table are not correctly updated. And it means that userspace can't detect the
error at all.

Fix this by propargating the error of "read capacity" command through the
stack, so that the ioctl could fail with -EIO.

Fam Zheng (3):
  block: Return error in rescan_partitions if revalidating disk failed
  sd: Return error in sd_revalidate_disk if read capacity failed
  sd: Return -EIO if read capacity failed

 block/partition-generic.c |  6 +++---
 drivers/scsi/sd.c         | 22 +++++++++++++---------
 2 files changed, 16 insertions(+), 12 deletions(-)

-- 
1.9.3

