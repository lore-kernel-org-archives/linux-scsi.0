Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB099EE801F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 04:02:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232650AbjIKEC2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 00:02:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbjIKEC0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 00:02:26 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB03AD2;
        Sun, 10 Sep 2023 21:02:21 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 940A9C433C8;
        Mon, 11 Sep 2023 04:02:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1694404941;
        bh=TfhDaF3S0ATCU9aRMX5kSkFK0+cqdLggDLfPiU8jYTM=;
        h=From:To:Cc:Subject:Date:From;
        b=kQ7B49nsKVc/QyOAxuN2adPBemX34iW22RJmuHwptyLeDrbkrPSxLul0ICes1mcK4
         kq6SUwvqnNRfsgp7ViNhnzfqp1rXSFP9at+Gywk2oLswzxAsf6JpAUaNL8oPIcgmeY
         soa5PsgpylumY753lJmqbZkALhWxBHz78zZK6Wn8AH4XQ6bPdi1+y2sr+7sI4kOAeK
         oqdRy6vFVpmhfLurN1GnxZb6cT1iLUhcPTxiUEpFDtmSHiXLBfakPpZ/IeBbkdXYdc
         ebnTzeDHjQRrqN4gn/khxFPDb540NsJVz53YoyIyMzfYiapy8b8a8RD6JaA3+azD7G
         I7m6X8cnsmT6A==
From:   Damien Le Moal <dlemoal@kernel.org>
To:     linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: [PATCH 00/19] Fix libata suspend/resume handling and code cleanup
Date:   Mon, 11 Sep 2023 13:01:58 +0900
Message-ID: <20230911040217.253905-1-dlemoal@kernel.org>
X-Mailer: git-send-email 2.41.0
MIME-Version: 1.0
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

Damien Le Moal (19):
  ata: libata-core: Fix ata_port_request_pm() locking
  ata: libata-core: Fix port and device removal
  ata: libata-scsi: link ata port and scsi device
  ata: libata-scsi: Disable scsi device manage_start_stop
  ata: libata-scsi: Fix delayed scsi_rescan_device() execution
  ata: libata-core: Do not register PM operations for SAS ports
  scsi: sd: Do not issue commands to suspended disks on remove
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

 drivers/ata/libata-core.c      | 239 +++++++++++++++++++++++++--------
 drivers/ata/libata-eh.c        |  74 ++++++++--
 drivers/ata/libata-sata.c      |   5 +-
 drivers/ata/libata-scsi.c      | 143 ++++++++++----------
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
 15 files changed, 370 insertions(+), 164 deletions(-)

-- 
2.41.0

