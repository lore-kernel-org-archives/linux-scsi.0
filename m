Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89646CA0ECD
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 03:01:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241532AbjILDBe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 23:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241754AbjILDBW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 23:01:22 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2126F1A39B0;
        Mon, 11 Sep 2023 18:32:26 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D0E3C116AA;
        Tue, 12 Sep 2023 00:56:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694480218;
        bh=M5RkzXlhvBv3Xf+/vakadnx17akUJYymOOi25bEzTgQ=;
        h=From:To:Cc:Subject:Date:From;
        b=Ox+UGQSRSp3NMNzcwXdN6d0bMTRuL4/NSl8J6/GssPwJwCA6DmOZpm5GWeayVY0pi
         IuZrsGoufTRxrb+zfK0Doi70rBRSGExyCm3cDfSYL1Vzy+JstF0VY8gVrojKhsvdmn
         k3o0psOYw38QcqRj2gTKnEhMEP6e3jpsNnsGNzKqhNGWaHKO/nNijYrM3WWo+xSvfz
         eUVipXVWVNdpMVShSquu14WcU8e3L5hOUXww5IjYx3zQr4sfGC1KhSvDa7vQam+BW7
         0zR1v7XqmAQyr/QTQS6/7fV3qY/fIpssTg5S+IwszlklqM/PbW87XF/ayU4KeSJ5kI
         oWIuoklaSDkFQ==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH v2 00/21] Fix libata suspend/resume handling and code cleanup
Date:   Tue, 12 Sep 2023 09:56:34 +0900
Message-ID: <20230912005655.368075-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The first 7 patch of this series fix several issues with suspend/resume
power management operations in libata. The most important change
introduced is in patch 4, where the manage_start_stop of scsi devices
associated with ata devices is disabled and this functionality replaced
by a direct handling within libata EH of device suspend/resume (i.e.
spin down for suspend and spin up for resume).

The remaining patches are code cleanup that do not introduce any
significant functional change.

This series was tested on qemu and on various PCs and servers. I am
CC-ing people who recently reported issues with suspend/resume.
Additional testing would be much appreciated.

Of note is that there is no change to the overall suspend/resume model
of libata where suspend and resume operations are tied to the ata port.
This is somewhat broken as a port may have multiple devices (e.g. pata
and port multiplier cases). Fixing this model (to be more similar to
what libsas does) will be the next step.

Changes from v1:
 * Added patch 8 and 9 to fix compilation warnings with W=1
 * Addressed John comment in patch 19
 * Fixed patch 20 commit message (Sergei)
 * Added Hannes Review tag

Damien Le Moal (21):
  ata: libata-core: Fix ata_port_request_pm() locking
  ata: libata-core: Fix port and device removal
  ata: libata-scsi: link ata port and scsi device
  ata: libata-scsi: Disable scsi device manage_start_stop
  ata: libata-scsi: Fix delayed scsi_rescan_device() execution
  ata: libata-core: Do not register PM operations for SAS ports
  scsi: sd: Do not issue commands to suspended disks on remove
  ata: libata-core: Fix compilation warning in ata_dev_config_ncq()
  ata: libata-eh: Fix compilation warning in ata_eh_link_report()
  scsi: Remove scsi device no_start_on_resume flag
  ata: libata-scsi: Cleanup ata_scsi_start_stop_xlat()
  ata: libata-core: Synchronize ata_port_detach() with hotplug
  ata: libata-core: Detach a port devices on shutdown
  ata: libata-core: Remove ata_port_suspend_async()
  ata: libata-core: Remove ata_port_resume_async()
  ata: libata-core: skip poweroff for devices that are runtime suspended
  ata: libata-core: Do not resume ports that have been runtime suspended
  ata: libata-sata: Improve ata_sas_slave_configure()
  ata: libata-eh: Improve reset error messages
  ata: libata-eh: Reduce "disable device" message verbosity
  ata: libata: Cleanup inline DMA helper functions

 drivers/ata/libata-core.c      | 241 +++++++++++++++++++++++++--------
 drivers/ata/libata-eh.c        |  76 +++++++++--
 drivers/ata/libata-sata.c      |   5 +-
 drivers/ata/libata-scsi.c      | 143 ++++++++++---------
 drivers/ata/libata-transport.c |   9 +-
 drivers/ata/libata.h           |   7 +
 drivers/ata/pata_macio.c       |   1 +
 drivers/ata/sata_mv.c          |   1 +
 drivers/ata/sata_nv.c          |   2 +
 drivers/ata/sata_sil24.c       |   1 +
 drivers/scsi/scsi_scan.c       |  12 +-
 drivers/scsi/sd.c              |  10 +-
 include/linux/libata.h         |  27 ++--
 include/scsi/scsi_device.h     |   1 -
 include/scsi/scsi_host.h       |   2 +-
 15 files changed, 372 insertions(+), 166 deletions(-)

-- 
2.41.0

