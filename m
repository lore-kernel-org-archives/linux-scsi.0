Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4CC0DC43334
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jul 2022 18:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbiGHSpn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Jul 2022 14:45:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235506AbiGHSpn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2022 14:45:43 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.154.123])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1F85724F
        for <linux-scsi@vger.kernel.org>; Fri,  8 Jul 2022 11:45:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1657305939; x=1688841939;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=wwriwoL3w6Yencd+55q9PLiYVJRkTvUiug4j91TUZJ4=;
  b=W/qLMB5wOtq051F7OtKSvrB2rB4A/WSJj/WfpW7Z9NzoSPCmL3l1ihwW
   Yi/N+vhfC8XnWGCZ+jUNdw5wt9620ga2OcNckdIjdd/zY42fnBr22CJoA
   eMbp3kQqqXR/U3QUWCeis+Q2cdYHpmkDnMFsNDLL0NvOCKYsOTsAXlKD1
   OhopuFUI4gJ7+S5l93q0PBReAWkC8UbgWh2KYOv92K6JLQ8vHcff2iFuB
   LYWefu79ofWBKMSUjhEbn5qPduKyblxfjb/mxQFuj4rhTRzowMU8zRW8a
   Qhp/pb1/dG5hvMK9mfZTmjGRwtXSsVu78BPvCkcpsgSN4dCbdbUFSQzwo
   g==;
X-IronPort-AV: E=Sophos;i="5.92,256,1650956400"; 
   d="scan'208";a="103695498"
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Jul 2022 11:45:38 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Fri, 8 Jul 2022 11:45:37 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.17 via Frontend
 Transport; Fri, 8 Jul 2022 11:45:37 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (8.15.2/8.15.2/Debian-22ubuntu3) with ESMTP id 268IkjVR177245;
        Fri, 8 Jul 2022 13:46:45 -0500
Received: (from brace@localhost)
        by brunhilda.pdev.net (8.15.2/8.15.2/Submit) id 268IkjHp177244;
        Fri, 8 Jul 2022 13:46:45 -0500
X-Authentication-Warning: brunhilda.pdev.net: brace set sender to don.brace@microchip.com using -f
Subject: [PATCH V2 00/16] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <hch@infradead.org>,
        <jejb@linux.vnet.ibm.com>, <joseph.szczypek@hpe.com>,
        <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 8 Jul 2022 13:46:45 -0500
Message-ID: <165730597930.177165.11663580730429681919.stgit@brunhilda>
User-Agent: StGit/1.5.dev2+g9ce680a52bd9
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 5.20/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  5.20/scsi-queue

This set of changes consists of:
 * Remove a device from the OS faster by adding -ENODEV return code check
   in pqi_lun_reset. This status is set in the io_request->status member.
   Schedule the rescan worker thread within 5 seconds to initiate the
   removal. The driver used to retry a reset without checking for a
   device's removal and initiated 3 more retries. Device resets were
   taking up to 30 seconds. We also added a check to see if the controller
   firmware is still responsive during a reset operation.
 * Add the controller firmware version to the console logs. The firmware
   version is still in sysfs firmware_version.
 * Add support for more controllers; Ramaxel, Lenovo, and Adaptec.
 * Close a few rare read/write ordering issues where a register read
   could pass a register write.
 * Add support for multi-actuator devices. Our controllers now support up
   to 256 LUNs per multi-actuator device. We added a feature bit to check
   if the controller supports multi-actuator devices and updated support
   in the driver to support resets, I/O submission, and multi-actuator
   device removals.
 * Correct some rare system hangs that can occur when a PCI link-down
   condition occurs (such as a cable pull). We also fail all outstanding
   requests when a link-down is detected.
 * Correct an issue with setting the DMA direction flag for RAID path
   requests. It should be noted that there are two submission paths for
   requests in the driver, a RAID path and an Accelerated I/O (AIO) path.
   Beginning with firmware version 5.0 for Gen1 controllers and 3.01.x
   for Gen2 controllers, a change was made that removed the SCSI command
   READ BLOCK LIMITS (0x05) from an internal lookup table for RAID path
   requests. As a result of this change, the firmware switched to using
   the DMA direction flag in the request IU, which was incorrect. This
   caused the command to hang the controller. This patch resolves the
   hang. The AIO path is unaffected by the controller firmware change.
 * correct a rare device RAID map access race condition related to
   configuration changes. We do not access the RAID map until after the
   new RAID map is valid.
 * added a module parameter 'disable_managed_interrupts' to allow
   customers to change IRQ affinity. Multi-queue still works properly.
 * Updated device removal to using .slave_destroy instead of using our
   own internal method.
 * Added another module parameter to reduce the amount of time the
   driver waits for a controller to become ready. The default wait time
   is 3 minutes but can be extended to 30 minutes. This change results
   from customers with large installations requesting a longer wait time.
 * Updated copyright information.
 * Bump the driver version to 2.1.18-045

---

Don Brace (2):
      smartpqi: update copyright to current year.
      smartpqi: update version to 2.1.18-045

Gilbert Wu (1):
      smartpqi: add controller fw version to console log

Kevin Barnett (4):
      smartpqi: stop logging spurious PQI reset failures
      smartpqi: fix RAID map race condition
      smartpqi: update deleting a LUN via sysfs
      smartpqi: add ctrl ready timeout module parameter

Kumar Meiyappan (1):
      smartpqi: add driver support for multi-LUN devices

Mahesh Rajashekhara (1):
      smartpqi: fix dma direction for RAID requests

Mike McGowen (5):
      smartpqi: shorten drive visibility after removal
      smartpqi: close write read holes
      smartpqi: add PCI-ID for Adaptec SmartHBA 2100-8i
      smartpqi: add PCI-IDs for Lenovo controllers
      smartpqi: add module param to disable managed ints

Murthy Bhat (1):
      smartpqi: add PCI-IDs for ramaxel controllers

Sagar Biradar (1):
      smartpqi: fix PCI control linkdown system hang


 drivers/scsi/smartpqi/Kconfig                 |   2 +-
 drivers/scsi/smartpqi/smartpqi.h              |  27 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 405 +++++++++++++-----
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   2 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |  11 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |   4 +-
 6 files changed, 339 insertions(+), 112 deletions(-)

--
Signature
