From: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Subject: [cciss: PATCH 00/17] fix scan_thread, sysfs stuff,
	LUN addressing problem
Date: Thu, 20 Aug 2009 10:17:41 -0500
Message-ID: <20090820151648.22833.14168.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0026.austin.hp.com ([15.216.28.33]:42629 "EHLO
	g1t0026.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbZHTPRk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2009 11:17:40 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, akpm@linux-foundation.org, axboe@kernel.dk, andrew.patterson@hp.com, mikem@c18-ss-1-lb.cnet.com, scameron@beardog.cce.hp.com

The following series cleans up the broken scan_thread code,
allows triggering of the scan_thread via sysfs, dynamically
allocates the struct device for each logical drive as needed
instead of all at once at driver init time, fixes a bug in
logical drive addressing (seen on MSA2012), and adds lunid,
raid_level, and usage_count attributes in sysfs for each
logical drive.

---

Andrew Patterson (3):
      Allow triggering of rescan of logical drive topology via sysfs entry
      Use one scan thread per controller and fix hang during rmmod
      Remove sysfs entries for logical drives on driver cleanup.

Stephen M. Cameron (14):
      Add usage_count attribute to each logical drive in /sys
      Add a "raid_level" attribute to each logical drive in /sys
      Add lunid attribute to each logical drive in /sys
      Preserve all 8 bytes of LUN ID for logical drives.
      Silence noisy per-disk messages output by cciss_read_capacity
      Fix excessive gendisk freeing bug on driver unload.
      Fix usage_count check in rebuild_lun_table when triggered via sysfs.
      Clear all sysfs-exposed data for deleted logical drives.
      Handle special case for sysfs attributes of the first logical drive.
      Handle cases when cciss_add_disk fails.
      Handle failure of blk_init_queue gracefully in cciss_add_disk.
      Rearrange logical drive sysfs code to make the "changing a disk" path work.
      Dynamically allocate struct device for each logical drive as needed.
      Remove some unused code in rebuild_lun_table()


 .../ABI/testing/sysfs-bus-pci-devices-cciss        |   28 +
 drivers/block/cciss.c                              |  551 +++++++++++++++-----
 drivers/block/cciss.h                              |   11 
 3 files changed, 461 insertions(+), 129 deletions(-)

-- 
-- steve

