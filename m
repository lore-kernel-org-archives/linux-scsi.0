Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6574C433E6
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 893C264F87
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 20:15:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229796AbhCKUPR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 15:15:17 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:63158 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229468AbhCKUO7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2021 15:14:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1615493700; x=1647029700;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wA1WCIngPxVCNi7/8G1HN04dsEDC84w37e/X/0tO4pk=;
  b=DWMjbS8HcK3Mw9lYRFK3TQqtKTbINKMyJbC47wPnL5bm2oTIACmMDTIO
   HvhwxM0Sygv3nCRxjmGv5CssyKySZFyRBI8uwoopR3JUXeylLgAnI+NCy
   SvfVN0xg2EBqRQbkmdPLfCLtHLf32Ay3jgW760isbqIkKjO79aky4Kefs
   KbQjmru153zb9m5q0eU9W0wyIkhwJa8FYZ7HEBd3GjtrmSbuZqrcFHd5Y
   11dRFCaLGSBt7EaN3Azt7tN5fo6W9K7Nz29ledhjwTqZmZE09ucGXOq7a
   QY1I0EJImTQs3n00N3rKHiAvdzKQ3F5ds9w2IC69iFJewQeHnkcqG77D+
   Q==;
IronPort-SDR: dbFAg8enfH+A7q5VqmETbKV9sJkJpvXcLtZr4Nzh9Oy60wzdLBWZCd6Q7PrXguWckp4dCQV2kh
 P1xbYZ63oTzZEroHog3PMR3H6Aqm++sb5NO/ZQ80yIYMsdf9YaGIMz2R3MI87zRXdrj0SYLHOe
 8wL7UwwWRRhTHTkS5ikhBaoPIgK2V3KkDtcW146GHiHesga820i5/ghWrYwcz7G7JnBfarfR3S
 z2hyQyjC6mkT8cg+RundbvBjlFHyFLd5Ez9B5A9UIdAYRDpDJVPa8sYcD5W0Q0Z2iqLTt7hRik
 MbI=
X-IronPort-AV: E=Sophos;i="5.81,241,1610434800"; 
   d="scan'208";a="112405888"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 11 Mar 2021 13:14:59 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Thu, 11 Mar 2021 13:14:52 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Thu, 11 Mar 2021 13:14:52 -0700
Subject: [PATCH V5 00/31] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 11 Mar 2021 14:14:51 -0600
Message-ID: <161549045434.25025.17473629602756431540.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Peterson's 5.13/scsi-queue tree

Note that these patches depend on the following three patches
applied to Martin Peterson's tree:
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  5.13/scsi-queue
Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler busy condition
Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with HBA disks

This set of changes consist of:
  * Add support for newer controller hardware.
    * Refactor AIO and s/g processing code. (No functional changes)
    * Add write support for RAID 5/6/1 Raid bypass path (or accelerated I/O path).
    * Add check for sequential streaming.
    * Add in new PCI-IDs.
  * Format changes to re-align with our in-house driver. (No functional changes.)
  * Correct some issues relating to suspend/hibernation/OFA/shutdown.
    * Block I/O requests during these conditions.
  * Add in qdepth limit check to limit outstanding commands.
    to the max values supported by the controller.
  * Correct some minor issues found during regression testing.
  * Update the driver version.

Changes since V1:
  * Re-added 32bit calculations to correct i386 compile issues
    to patch smartpqi-refactor-aio-submission-code 
    Reported-by: kernel test robot <lkp@intel.com>
    https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/VMBBGGGE5446SVEOQBRCKBTRRWTSH4AB/

Changes since V2:
  * Added 32bit division to correct i386 compile issues
    to patch smartpqi-add-support-for-raid5-and-raid6-writes
    Reported-by: kernel test robot <lkp@intel.com>
    https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org/thread/ZCXJJDGPPTTXLZCSCGWEY6VXPRB3IFOQ/

Changes since V3:
    Martin Wilck's Review:
    smartpqi-add-support-for-product-id
      * Moved a formatting HUNK to smartpqi-align-code-with-oob-driver
      * Added more patch description detail.
    smartpqi-refactor-aio-submission-code
      * Updated patch description.
    smartpqi-add-support-for-raid5-and-raid6-writes
      * Removed two manifest constants from smartpqi.h
      * Changed scnprintf format from %hhx to %x for sysfs entries:
          pqi_host_enable_r5_writes_show:ctrl_info->enable_r5_writes
          pqi_host_enable_r6_writes_show:ctrl_info->enable_r6_writes
      * Corrected disabling of R1 reads
      * Added comment on raid_map calculations.
        Changed how parity indexes are calculated.
      * Changed DMA direction in function pqi_aio_submit_r56_write_io
        to DMA_TO_DEVICE.
    smartpqi-add-support-for-raid1-writes
      * Changed DMA direction in function pqi_aio_submit_r1_write_io
        to DMA_TO_DEVICE.
    smartpqi-add-support-for-BMIC-sense-feature-cmd-and-feature-bits
      * Squashed smartpqi-update-AIO-Sub-Page-0x02-support
        This effectively moved function pqi_aio_limit_to_bytes into this patch.
      * Squashed smartpqi-enable-support-for-NVMe-encryption since
        this was adding in another feature.
      * Moved formatting HUNK for pqi_scsi_dev_raid_map_data into
        smartpqi-refactor-aio-submission-code.
      * Moved structure pqi_aio_r56_path_request formatting HUNKS into
        smartpqi-add-support-for-raid5-and-raid6-writes.
      * Moved remaining formatting HUNKs into
        smartpqi-align-code-with-oob-driver.
    smartpqi-add-support-for-long-firmware-version
      * Updated setting of ctrl_info->firmware_version to avoid overflows.
      * Moved a formatting HUNK into smartpqi-align-code-with-oob-driver.
    smartpqi-align-code-with-oob-driver
      * Updated with formatting HUNKs in other reviews.
    smartpqi-add-stream-detection
      * Updated patch description to better describe what the patch does.
    smartpqi-add-host-level-stream-detection-enable
      * Changed snprintf formate from 0x%hhx to 0x%x.
    smartpqi-enable-support-for-NVMe-encryption
      * Squashed into patch
        smartpqi-add-support-for-BMIC-sense-feature-cmd-and-feature-bits
    smartpqi-fix-driver-synchronization-issues
      * Split into 10 patches.
        smartpqi-remove-timeouts-from-internal-cmds
        smartpqi-add-support-for-wwid
        smartpqi-update-event-handler
        smartpqi-update-soft-reset-management-for-OFA
          * Squashed smartpqi-change-timing-of-release-of-QRM-memory-during-OFA
        smartpqi-synchronize-device-resets-with-mutex
          * Note: still using mutex. Our OOB driver has been well tested with
                  this synchronization construct. Changing this here will
                  mandate a change in our OOB driver and kick off another
                  round of regression tests that have already passed.
        smartpqi-update-suspend-resume-and-shutdown
          * Note: suspend/resume is not supported on many servers. This
                  has passed our internal tests on the few that do. This
                  patch was originally intended for a workstation platform.
                  So I left the mutex code alone. We would like to address any
                  subsequent issues in the future.
        smartpqi-update-raid-bypass-handling
        smartpqi-update-ofa-management
          * Squashed smartpqi-return-busy-indication-for-IOCTLs-when-ofa-is-active
        smartpqi-update-device-scan-operations
        smartpqi-fix-driver-synchronization-issues
          * Original patch with all un-related HUNKs moved into the above
            9 patches.
    smartpqi-fix_host_qdepth_limit
      * Patch removed and replaced with patch smartpqi-use-host-wide-tagspace
    smartpqi-change-timing-of-release-of-QRM-memory-during-OFA
      * Squashed into patch smartpqi-update-soft-reset-management-for-OFA
    smartpqi-add-additional-logging-for-LUN-resets
      * Updated patch description
    smartpqi-update-enclosure-identifier-in-sysfs
      * Updated patch description.
    smartpqi-correct-system-hangs-when-resuming-from-hibernation
      * Updated patch description.
      * Note: suspend/resume is not widely supported. The platform this
              patch was added for was a workstation. There has been a lot
              of testing on the supported platforms and all of the tests
              have passed. We would rather not make changes to this patch
              because of the rare usage. We would rather correct any issues
              (if any) in subsequent patches.
    smartpqi-update-version-to-2.1.8-045
      * Previous patch was smartpqi-update-version-to-2.1.6-005
        We bumped the version up since the patch set was originally pushed.

Changes since V4:
	smartpqi-use-host-wide-tagspace
            John Garry <john.garry@huawei.com> review:
            https://marc.info/?l=linux-scsi&m=161541732830890&w=2
            * Changed driver to only set shost->host_tagset = 1, and reverted
              setting nm_hw_queue back to original setting.
            * Corrected John's email address.
---

Don Brace (8):
      smartpqi: use host wide tagspace
      smartpqi: refactor aio submission code
      smartpqi: refactor build sg list code
      smartpqi: add support for raid5 and raid6 writes
      smartpqi: add support for raid1 writes
      smartpqi: add stream detection
      smartpqi: add host level stream detection enable
      smartpqi: update version to 2.1.8-045

Kevin Barnett (19):
      smartpqi: add support for product id
      smartpqi: add support for BMIC sense feature cmd and feature bits
      smartpqi: add support for long firmware version
      smartpqi: align code with oob driver
      smartpqi: disable write_same for nvme hba disks
      smartpqi: remove timeouts from internal cmds
      smartpqi: add support for wwid
      smartpqi: update event handler
      smartpqi: update soft reset management for OFA
      smartpqi: synchronize device resets with mutex
      smartpqi: update suspend resume and shutdown
      smartpqi: update raid bypass handling
      smartpqi: update ofa management
      smartpqi: update device scan operations
      smartpqi: fix driver synchronization issues
      smartpqi: convert snprintf to scnprintf
      smartpqi: add additional logging for LUN resets
      smartpqi: correct system hangs when resuming from hibernation
      smartpqi: add new pci ids

Murthy Bhat (4):
      smartpqi: fix request leakage
      smartpqi: add phy id support for the physical drives
      smartpqi: update sas initiator_port_protocols and target_port_protocols
      smartpqi: update enclosure identifier in sysfs


 drivers/scsi/smartpqi/smartpqi.h              |  310 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 3106 ++++++++++-------
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |    9 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |    1 +
 5 files changed, 2184 insertions(+), 1281 deletions(-)

--
Signature
