Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 667D1C433F5
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Feb 2022 21:47:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236002AbiBAVrw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Feb 2022 16:47:52 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:30945 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235995AbiBAVru (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Feb 2022 16:47:50 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1643752072; x=1675288072;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i7t6twWJtGx527hDAFMsn/ovZ0axPhc7on7nZmlIvio=;
  b=pM0P5S4lyrwT3E/G1BJCPapizZp4p4pn6/m52N9xN+9BbOsKlP0Ivphk
   tf01KwepQ1gok/8CYNYJt3D3/N8xD0RtUmt1QhnM8zHW3Pukf6NTOwMGi
   rXewNdCkVZZiHJ1YogMMMTQ1e+zTScWbBn0ngjRRvccCSyVTuHCVTkGKe
   vJVR+0cVBdwo9BY600QHfZiPdUeuNsXzC9LdGdbGSd0EmRld1tMVRZIdH
   owItgvs6Yg90Jt436n1y/9dhBQCLITd1Lhif9Cwd9Pi1bHSkbgEzzImUm
   TEhStSzFj5/oR+JtwXzsNfokscOgj/7pr0aqyIqxqgX4Fe9vAsFngqHJu
   Q==;
IronPort-SDR: pax7antPe+f7hRpa2RFfP4vmYohPSNX3x0HHvHNy8w/pH0NDK3uwJt3sYt3VEqFkGO2w88SlMY
 fpzXRgPZiDCOXpzqwRqwLda3Yz6+NCO5mOc4P3OqmzHa8gvMPO9Nz84XAcFAuzrxQ09sijyaaT
 75NIcoEy0EPIfUz5NX/Sw5WyjLFNnrtga6XGYGkxMJe7c7sKBQ7faOXTJ7O8iMOZmbubk6QfzR
 Y8GMoFO9jeSJJ85PKVHVXu5OtLv9X4fxIzdTuEAXWRMrNrTFh40D5NPmxjtQcEkoaMUi6aFdvV
 NHT9XQJwVlHT4rprorRl5091
X-IronPort-AV: E=Sophos;i="5.88,335,1635231600"; 
   d="scan'208";a="151639032"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 01 Feb 2022 14:47:51 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.17; Tue, 1 Feb 2022 14:47:48 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2375.17 via Frontend
 Transport; Tue, 1 Feb 2022 14:47:48 -0700
Received: from brunhilda.pdev.net (localhost [127.0.0.1])
        by brunhilda.pdev.net (Postfix) with ESMTP id E84FE70236E;
        Tue,  1 Feb 2022 15:47:47 -0600 (CST)
Subject: [PATCH 00/18] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 1 Feb 2022 15:47:47 -0600
Message-ID: <164375113574.440833.13174600317115819605.stgit@brunhilda.pdev.net>
User-Agent: StGit/1.4.dev36+g39bf3b02665a
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 5.18/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  5.18/scsi-queue

This set of changes consist of:
 * Correcting a stack trace when the driver is unloaded. The driver was
   holding a spin lock when calling scsi_remove_device. 
 * Adding in new PCI device IDs and aligning the device order with our
   out-of-box driver. No functional changes.
 * Allow NCQ to be enabled for SATA disks. The controller firmware has
   to have support for this feature.
 * Enhance reboot performance by now issuing disk spin-downs during
   reboots. This eliminates spin-up time required doing the boot up.
 * Speed up multipath failover detection by returning DID_NO_CONNECT
   when the controller returns a path failure. Previously, the driver was
   waiting on an internal re-scan to detect the path failure.
 * Change function name pqi_is_io_high_priority() to
   pqi_is_io_high_priority() for better readability. Remove some white
   spaces from the same function.
 * Correct the structure used for AIO command submission. The structure
   used was pqi_raid_path_request, but needs to be pqi_aio_path_request.
   Both structure are the same size and have the same member offsets,
   so no issues were reported.
 * A PQI_HZ MACRO was introduced some time ago to resolve some timing
   issues. This definition is not needed. Switch back to using HZ.
 * For certain controllers, there was a request to avoid a drive
   spin-down for suspend (S3) state transitions.
 * For small drive expansions, the driver was not detecting the new
   size changes. We added a rescan whenever the driver receives an
   event from the controller.
 * In some rare cases, the controller can be locked up when a kdump
   is requested. When this occurs, the kdump is failed. This helps
   in debugging the cause of the lockup.
 * For RAID 10 disks, only one set of disks were used for read
   operations. Now we spread out I/O to all volumes. This resolves
   some inconsistent performance issues.
 * Export SAS addresses for all disks instead of only SAS disks.
 * Correct NUMA node association during pci_probe. A small typo
   was causing a different NUMA node to be set.
 * Not all structures were checked with BUILD_BUG_ON.
 * Correct some rare Hibernate/Suspend issues. Newer controllers
   may boot up with different timings.
 * Correct WWID output for lsscsi -t. The wrong part of the 16-byte WWID
   was used for the SAS address field.
 * Bump the driver version to 2.1.14-035

---

Balsundar P (1):
      smartpqi: resolve delay issue with PQI_HZ value

Don Brace (3):
      smartpqi: fix rmmod stack trace
      smartpqi: add PCI IDs
      smartpqi: update version to 2.1.14-035

Gilbert Wu (1):
      smartpqi: enable SATA NCQ priority in sysfs

Kevin Barnett (5):
      smartpqi: fix a name typo and cleanup code
      smartpqi: fix a typo in func pqi_aio_submit_io
      smartpqi: expose SAS address for SATA drives
      smartpqi: fix hibernate and suspend
      smartpqi: fix lsscsi-t SAS addresses

Mahesh Rajashekhara (2):
      smartpqi: update volume size after expansion
      smartpqi: fix kdump issue when ctrl is locked up

Mike McGowen (3):
      smartpqi: speed up RAID 10 sequential reads
      smartpqi: fix NUMA node not updated during init
      smartpqi: fix BUILD_BUG_ON() statements

Murthy Bhat (1):
      smartpqi: propagate path failures to SML quickly

Sagar Biradar (2):
      smartpqi: eliminate drive spin down on warm boot
      smartpqi: avoid drive spin-down during suspend


 drivers/scsi/smartpqi/smartpqi.h      |  16 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 541 +++++++++++++++++++-------
 drivers/scsi/smartpqi/smartpqi_sis.c  |  10 +-
 drivers/scsi/smartpqi/smartpqi_sis.h  |   1 +
 4 files changed, 414 insertions(+), 154 deletions(-)

--
Signature

