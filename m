Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E205CE7D24D
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Sep 2023 08:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233878AbjIZIPV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Sep 2023 04:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43064 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbjIZIPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Sep 2023 04:15:17 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 936ECB4;
        Tue, 26 Sep 2023 01:15:10 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EEDC433C8;
        Tue, 26 Sep 2023 08:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1695716110;
        bh=Ae9fgOKJgOYcoF9tLXrNWjYClA2QHehJv44Xrwl/UXw=;
        h=From:To:Cc:Subject:Date:From;
        b=FqRxt2aRTtsNC25aHqklCgF0i7YLTuk1gr+uQbuLrClQjWkE6U/uL9kNeYnpzBa/o
         ElTx6ez9EW7HhtOEg6dW7l26oIwFnyVnxZ2IcQVVIaQHV9ZB8/bhO8xxs9+0aH8gYV
         /oPt/4svg2VOst1pUy8nxNoPWqEsrJGO2BGPSEYX5txsys1EdePHu+I4gr7eOP+a8V
         Vafo0GYMMlBJ7erRYyTSs6V/TTKw8bz+b1ytEB6EmdovKcTv6+GQZJCB26mgo1PYb4
         S4ieb0ZESQ64p2TJcPEvdm4MyfwOmnd1YRB2LkpeSVXkDSY1foZw1jLwrXZPwl3/Eg
         SJZ4fyWq/AH2Q==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Chia-Lin Kao <acelan.kao@canonical.com>
Subject: [PATCH v7 00/23] Fix libata suspend/resume handling and code cleanup
Date:   Tue, 26 Sep 2023 17:14:44 +0900
Message-ID: <20230926081507.69346-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first 9 patches of this series fix several issues with suspend/resume
power management operations in scsi and libata. The most significant
changes introduced are in patch 4 and 5, where the manage_start_stop
flag of scsi devices is split into the manage_system_start_stop and
manage_runtime_start_stop flags to allow keeping scsi runtime power
operations for spining up/down ATA devices but have libata do its own
system suspend/resume device power state management using EH.

The remaining patches are code cleanup that do not introduce any
significant functional change.

This series was tested on qemu and on various PCs and servers. I am
CC-ing people who recently reported issues with suspend/resume.
Additional testing would be much appreciated.

Changes from v6:
 * Changed patch 9 to use a bool for the new suspended flag.

Changes from v5:
 * Typo and style corrections in patch 4 commit message
 * Changed patch 9 to use a new flag to track a disk suspended state
   instead of using the scsi device state
 * Added review tags

Changes from v4:
 * Remove ata_scsi_dev_alloc() function in patch 3, coding it directly
   in ata_scsi_slave_alloc()
 * Correct typo in patch 19 commit message
 * Added Tested and review tags

Changes from v3:
 * Corrected patch 1 (typo in commit message and WARN_ON() removal)
 * Changed path 3 as suggested by Niklas (moved definition of
   ->slave_alloc)
 * Rebased on rc2
 * Added review tags

Changes from v2:
 * Added patch 4 as simply disabling manage_start_stop from libata was
   breaking individual disk runtime suspend/autosuspend. Patch 5 was
   reworked accordingly to the changes in patch 4.
 * Fixed patch 3: applying the link creation was missing and the link
   creation itself was also incorrect, preventing sd probe to execute
   correctly. Thanks to Geert for testing and reporting this issue.
 * Split the "Fix delayed scsi_rescan_device() execution" patch into
   patch 6 (scsi part) and patch 7 (ata part).
 * Modified patch 9 to not call sd_shutdown() from sd_remove() for
   devices that are not running.
 * Added Chia-Lin Tested tag to unchanged patches

Changes from v1:
 * Added patch 8 and 9 to fix compilation warnings with W=1
 * Addressed John comment in patch 19
 * Fixed patch 20 commit message (Sergei)
 * Added Hannes Review tag

Damien Le Moal (23):
  ata: libata-core: Fix ata_port_request_pm() locking
  ata: libata-core: Fix port and device removal
  ata: libata-scsi: link ata port and scsi device
  scsi: sd: Differentiate system and runtime start/stop management
  ata: libata-scsi: Disable scsi device manage_system_start_stop
  scsi: Do not attempt to rescan suspended devices
  ata: libata-scsi: Fix delayed scsi_rescan_device() execution
  ata: libata-core: Do not register PM operations for SAS ports
  scsi: sd: Do not issue commands to suspended disks on shutdown
  ata: libata-core: Fix compilation warning in ata_dev_config_ncq()
  ata: libata-eh: Fix compilation warning in ata_eh_link_report()
  scsi: Remove scsi device no_start_on_resume flag
  ata: libata-scsi: Cleanup ata_scsi_start_stop_xlat()
  ata: libata-core: Synchronize ata_port_detach() with hotplug
  ata: libata-core: Detach a port devices on shutdown
  ata: libata-core: Remove ata_port_suspend_async()
  ata: libata-core: Remove ata_port_resume_async()
  ata: libata-core: Do not poweroff runtime suspended ports
  ata: libata-core: Do not resume runtime suspended ports
  ata: libata-sata: Improve ata_sas_slave_configure()
  ata: libata-eh: Improve reset error messages
  ata: libata-eh: Reduce "disable device" message verbosity
  ata: libata: Cleanup inline DMA helper functions

 drivers/ata/libata-core.c      | 242 +++++++++++++++++++++++++--------
 drivers/ata/libata-eh.c        |  76 +++++++++--
 drivers/ata/libata-sata.c      |   5 +-
 drivers/ata/libata-scsi.c      | 142 ++++++++++---------
 drivers/ata/libata-transport.c |   9 +-
 drivers/ata/libata.h           |   6 +
 drivers/firewire/sbp2.c        |   9 +-
 drivers/scsi/scsi_scan.c       |  18 ++-
 drivers/scsi/sd.c              | 102 +++++++++++---
 drivers/scsi/sd.h              |   1 +
 include/linux/libata.h         |  26 ++--
 include/scsi/scsi_device.h     |   4 +-
 include/scsi/scsi_host.h       |   2 +-
 13 files changed, 457 insertions(+), 185 deletions(-)

-- 
2.41.0

