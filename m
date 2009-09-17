From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [PATCH 00/20] cciss: fix scan_thread, sysfs stuff,
	dynamically allocate per drive structure
Date: Thu, 17 Sep 2009 13:46:47 -0500
Message-ID: <20090917184310.15105.43508.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g4t0017.houston.hp.com ([15.201.24.20]:31060 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751745AbZIQSqT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Sep 2009 14:46:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: akpm@linux-foundation.org, axboe@kernel.dk
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, andrew.patterson@hp.com, mikem@beardog.cce.hp.com, scameron@beardog.cce.hp.com

The following series cleans up the broken scan_thread code,
allows triggering of the scan_thread via sysfs, dynamically
allocates the per device structure for each logical drive as needed
instead of all at once at driver init time, fixes a bug in
logical drive addressing (seen on MSA2012), and adds lunid,
raid_level, and usage_count attributes in sysfs for each
logical drive.

---

Andrew Patterson (3):
      cciss: Allow triggering of rescan of logical drive topology via sysfs entry
      cciss: Use one scan thread per controller and fix hang during rmmod
      cciss: Remove sysfs entries for logical drives on driver cleanup.

Stephen M. Cameron (17):
      cciss: Dynamically allocate the drive_info_struct for each logical drive.
      cciss: Add usage_count attribute to each logical drive in /sys
      cciss: Add a "raid_level" attribute to each logical drive in /sys
      cciss: fix some magic numbers in the raid-level decoding
      cciss: Add lunid attribute to each logical drive in /sys
      cciss: Don't check h->busy_initializing in cciss_open().
      cciss: Preserve all 8 bytes of LUN ID for logical drives.
      cciss: Silence noisy per-disk messages output by cciss_read_capacity
      cciss: Fix excessive gendisk freeing bug on driver unload.
      cciss: Fix usage_count check in rebuild_lun_table when triggered via sysfs.
      cciss: Clear all sysfs-exposed data for deleted logical drives.
      cciss: Handle special case for sysfs attributes of the first logical drive.
      cciss: Handle cases when cciss_add_disk fails.
      cciss: Handle failure of blk_init_queue gracefully in cciss_add_disk.
      cciss: Rearrange logical drive sysfs code to make the "changing a disk" path work.
      cciss: Dynamically allocate struct device for each logical drive as needed.
      cciss: Remove some unused code in rebuild_lun_table()


 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   28 +
 drivers/block/cciss.c                              |  743 +++++++++++++++-----
 drivers/block/cciss.h                              |   12 
 3 files changed, 576 insertions(+), 207 deletions(-)

-- 
-- steve
