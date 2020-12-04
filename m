Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78924C4361B
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3A41E22C9E
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 23:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725966AbgLDXCa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 18:02:30 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:1374 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726296AbgLDXC2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 18:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607122948; x=1638658948;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=SSTfQIG1JQKmCxs/Dqmm5tVsmIQJNJ0BuY871m9XrKY=;
  b=DEZRxAvXn027lSqEhhaFZ21idAUagbFmedS7aGUqI4m1Dv7Z1bDzgHz6
   WGKr2wTzmOpBGoQYKTCGDV1mwj2LSUCPqB3BQ33jWZj6mQRxYabZHxCBk
   QejB6SRGeiyI0vQYD8BeK+68a/m36ZnKGC1mmqZ4KEL74pg/sX1gKAojy
   oNMkLNhXMHGY76QGsuDWFw4RvIj4tlX4AI8v1nYiNc4LqVX41KyO5Udk1
   tht5UhIIslmwitIXlCIuptTsLyEzjC3ye4sgE6O5ecCKYpCpqMEIKOn2k
   LHOdBoZ4XeWNb6h5DVnv7xuTaUf8Ffgl/MxBxIwVz77f6rHsNDgB5vKxp
   w==;
IronPort-SDR: cJfu8Yer5+C72xRUxNKmDBhZ54NYNGlaN5nw0eodMxGPJvqjJLI0HutwDuyQ8dBBP4xK6n+vKj
 ylYAcFe3YzA7UgTYDJKUCCu5/39xBmbIT5WYyxfsUJKAp/qdgH/d52cB6LcIEfIF4Y7p8v3Ed3
 cRsu6z2yx3HvjpUw9ZJu5zW3OrWWXqwhrL3322a8/3PfBqb7Jh24pwrK59vcZ4PTNFMIRQWKeM
 ZbB+90s7htgf/wK/GDg7Su8ewBlBK0XyfYIc5Wz0UbzPrKEHJpxBY6nfOyo9bEHPQ9jdsS8v1c
 mOQ=
X-IronPort-AV: E=Sophos;i="5.78,393,1599548400"; 
   d="scan'208";a="101548265"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 04 Dec 2020 16:00:59 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Fri, 4 Dec 2020 16:00:51 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Fri, 4 Dec 2020 16:00:50 -0700
Subject: [PATCH 00/25] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Fri, 4 Dec 2020 17:00:50 -0600
Message-ID: <160712276179.21372.51526310810782843.stgit@brunhilda>
User-Agent: StGit/0.23-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Peterson's 5.11/scsi-queue tree

Note that these patches depend on the following three patches
applied to Martin Peterson's tree:
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  5.11/scsi-queue
Depends-on: 5443bdc4cc77 scsi: smartpqi: Update version to 1.2.16-012
Depends-on: 408bdd7e5845 scsi: smartpqi: Correct pqi_sas_smp_handler busy condition
Depends-on: 1bdf6e934387 scsi: smartpqi: Correct driver removal with HBA disks

This set of changes consist of:
  * Add support for newer controller hardware.
    * Refactor AIO and s/g processing code. (No functional changes)
    * Add write support for RAID 5/6/1 Raid bypass path (or accelerated I/O path).
    * Add check for sequential streaming.
    * Add in new PCI-IDs.
  * Format changes to re-align with our in-house driver. (No functional changes)
  * Correct some issues relating to suspend/hibernation/OFA/shutdown.
    * Block I/O requests during these conditions.
  * Add in qdepth limit check to limit outstanding commands.
    to the max values supported by the controller.
  * Correct some minor issues found during regression testing.
  * Update the driver version.

---

Don Brace (7):
      smartpqi: refactor aio submission code
      smartpqi: refactor build sg list code
      smartpqi: add support for raid5 and raid6 writes
      smartpqi: add support for raid1 writes
      smartpqi: add stream detection
      smartpqi: add host level stream detection enable
      smartpqi: update version to 2.1.6-005

Kevin Barnett (14):
      smartpqi: add support for product id
      smartpqi: add support for BMIC sense feature cmd and feature bits
      smartpqi: update AIO Sub Page 0x02 support
      smartpqi: add support for long firmware version
      smartpqi: align code with oob driver
      smartpqi: enable support for NVMe encryption
      smartpqi: disable write_same for nvme hba disks
      smartpqi: fix driver synchronization issues
      smartpqi: convert snprintf to scnprintf
      smartpqi: change timing of release of QRM memory during OFA
      smartpqi: return busy indication for IOCTLs when ofa is active
      smartpqi: add additional logging for LUN resets
      smartpqi: correct system hangs when resuming from hibernation
      smartpqi: add new pci ids

Mahesh Rajashekhara (1):
      smartpqi: fix host qdepth limit

Murthy Bhat (3):
      smartpqi: add phy id support for the physical drives
      smartpqi: update sas initiator_port_protocols and target_port_protocols
      smartpqi: update enclosure identifier in sysf


 drivers/scsi/smartpqi/smartpqi.h              |  301 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 3088 ++++++++++-------
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |    4 +-
 4 files changed, 2137 insertions(+), 1295 deletions(-)

--
Signature
