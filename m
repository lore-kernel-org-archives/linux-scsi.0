From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0 of 3] Block Layer Data Integrity
Date: Tue, 17 Jun 2008 11:57:55 -0400
Message-ID: <patchbomb.1213718275@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from jaguar.mkp.net ([192.139.46.146]:59418 "EHLO jaguar.mkp.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751622AbYFQP7b (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jun 2008 11:59:31 -0400
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

 - Add "if in doubt" to Kconfig

 - Make blk_rq_count_integrity_sg() more readable

 - Queue integrity sysfs fixes

 - Fix two struct bi leaks

 - Rename struct bip to bio_integrity_payload

 - Introduce bio_integrity_hw_sectors() that converts from block layer
   (512b) sectors to hardware sectors

 - Fix kunmap_atomic() abuse

 - Replace ?: constructs with if()

 - Add __GFP_NOFAIL to bio_integrity_prep() allocation


