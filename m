From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 3] Block Layer Data Integrity
Date: Mon, 16 Jun 2008 00:10:17 -0400
Message-ID: <patchbomb.1213589417@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:41605 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750804AbYFPENa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 16 Jun 2008 00:13:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jens.axboe@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

These patches allow data integrity information (checksum and more) to
be attached to I/Os at the block/filesystem layers and transferred
through the entire I/O stack all the way to the physical storage
device.

The integrity metadata can be generated in close proximity to the
original data.  Capable host adapters, RAID arrays and physical disks
can verify the data integrity and abort I/Os in case of a mismatch.

Changes:

 - Fix sector calculation for DIF Type 3 devices

 - Use DIV_ROUND_UP()

 - Create bio_integrity_mark_{head,tail} helpers and use them when
   adjusting integrity vectors

 - Consolidate bio_integrity_{set,get} tag

 - sysfs ABI doc

15 files changed, 1732 insertions(+), 31 deletions(-)
Documentation/ABI/testing/sysfs-block  |   34 +
Documentation/block/data-integrity.txt |  327 ++++++++++++++
block/Kconfig                          |   12 
block/Makefile                         |    1 
block/blk-core.c                       |    7 
block/blk-integrity.c                  |  385 +++++++++++++++++
block/blk-merge.c                      |    3 
block/blk.h                            |    8 
block/elevator.c                       |    6 
fs/Makefile                            |    1 
fs/bio-integrity.c                     |  700 ++++++++++++++++++++++++++++++++
fs/bio.c                               |   62 +-
include/linux/bio.h                    |  115 +++++
include/linux/blkdev.h                 |   99 ++++
include/linux/genhd.h                  |    3 


