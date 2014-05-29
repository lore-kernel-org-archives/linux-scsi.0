From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Copy offload
Date: Wed, 28 May 2014 23:52:39 -0400
Message-ID: <1401335565-29865-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:38835 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755564AbaE2Dwp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:52:45 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, linux-scsi@vger.kernel.org

Several people have poked me about the copy offload patches. Aside from
being able to fit into Jens' 3.16/core branch there hasn't been any
changes, nor any bug reports since LSF/MM.

This patch series implements support for copy offload. Storage arrays
that implement copy operations can be told to clone a block range either
within a storage device or between LUNs. The copy is done entirely
inside the device and no data is moved back and forth across the wire.

[PATCH 1/6] block: Replace bi_integrity with bi_special

       Identical to the patch I just posted in the integrity series.
       Allows us to have other uses for the pointer previously
       exclusively used for the integrity payload.

[PATCH 2/6] block: Implement support for copy offload operations

       General block layer plumbing for REQ_COPY requests.

[PATCH 3/6] block: Introduce copy offload library function

       Helper for filesystems that want to clone block ranges.

[PATCH 4/6] block: Copy offload ioctl

       The ioctl I have been using to test the code.

[PATCH 5/6] [SCSI] Look up and store NAA if VPD page 0x83 is present

       Leverages Hannes' VPD page code to store a pointer to the NAA
       descriptor.

[PATCH 6/6] [SCSI] sd: Implement copy offload support

       The EXTENDED COPY implementation in the SCSI disk driver.

 Documentation/ABI/testing/sysfs-block  |    9 +
 Documentation/block/data-integrity.txt |   10 -
 block/bio-integrity.c                  |   23 +-
 block/blk-core.c                       |    5 
 block/blk-lib.c                        |   85 +++++++++++
 block/blk-merge.c                      |    7 
 block/blk-settings.c                   |   15 +
 block/blk-sysfs.c                      |   10 +
 block/ioctl.c                          |   35 ++++
 drivers/scsi/scsi.c                    |   57 +++++++
 drivers/scsi/sd.c                      |  254 ++++++++++++++++++++++++++++++++-
 drivers/scsi/sd.h                      |    4 
 drivers/scsi/sd_dif.c                  |    8 -
 include/linux/bio.h                    |   25 ++-
 include/linux/blk_types.h              |   21 ++
 include/linux/blkdev.h                 |   22 ++
 include/scsi/scsi_device.h             |    3 
 include/uapi/linux/fs.h                |    1 
 18 files changed, 553 insertions(+), 41 deletions(-)

-- 
Martin K. Petersen	Oracle Linux Engineering

