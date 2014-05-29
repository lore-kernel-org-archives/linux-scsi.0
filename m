From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Data integrity update
Date: Wed, 28 May 2014 23:28:34 -0400
Message-ID: <1401334128-15499-1-git-send-email-martin.petersen@oracle.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26856 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753894AbaE2D3D (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 28 May 2014 23:29:03 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com, nab@daterainc.com, sagig@dev.mellanox.co.il, linux-scsi@vger.kernel.org

Here's an update to the block layer and SCSI data integrity code. There
are a whole bunch of cleanups, some as a result of the work that Kent
did to the block layer a while back. A bunch of dead code is removed,
mainly the tagging functionality that nobody ended up using.

There's also some prep work for the copy offload patches (separate
series) that like the integrity code rely on being able to store
additional information in each bio.

The new functionality introduced is:

 - Exposing whether disks are formatted with PI in the bdev integrity
   profile so we can reliably distinguish between DIX Type 0 and DIX
   Type 1

 - Allowing the choice of checksum and tag checking to be specified on a
   per-I/O basis

 - Data integrity specific error numbers

 - Moving the T10 protection information specifics to lib/ so that
   non-sd drivers can benefit from them

 - Adding support for a subset of DIX1.1 to the scsi_cmnd flags. These
   flags instruct the HBA drivers how to set up the protected transfer

 Documentation/ABI/testing/sysfs-block  |    9 
 Documentation/block/data-integrity.txt |   54 -----
 block/Kconfig                          |    1 
 block/bio-integrity.c                  |  273 ++++++--------------------
 block/blk-core.c                       |   12 +
 block/blk-integrity.c                  |  102 ++++++---
 block/blk-merge.c                      |    6 
 drivers/md/dm-mpath.c                  |    9 
 drivers/scsi/Kconfig                   |    2 
 drivers/scsi/scsi_lib.c                |   30 ++
 drivers/scsi/sd.c                      |   56 ++++-
 drivers/scsi/sd.h                      |    4 
 drivers/scsi/sd_dif.c                  |  337 +++++----------------------------
 include/linux/bio.h                    |   62 ++++--
 include/linux/blk_types.h              |   14 -
 include/linux/blkdev.h                 |   54 ++---
 include/linux/crc-t10dif.h             |    5 
 include/linux/t10-pi.h                 |   28 ++
 include/scsi/scsi_cmnd.h               |   29 ++
 include/uapi/asm-generic/errno.h       |   11 +
 lib/Kconfig                            |    7 
 lib/Makefile                           |    2 
 lib/t10-pi.c                           |  164 ++++++++++++++++
 23 files changed, 627 insertions(+), 644 deletions(-)

-- 
Martin K. Petersen	Oracle Linux Engineering
