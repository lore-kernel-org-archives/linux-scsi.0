Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DE18DC77B61
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Apr 2023 15:37:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346088AbjD1Pht (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Apr 2023 11:37:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345991AbjD1Pho (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Apr 2023 11:37:44 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 355F74EF2
        for <linux-scsi@vger.kernel.org>; Fri, 28 Apr 2023 08:37:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1682696240; x=1714232240;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=B9Kf+BxSS0xz/pNaUuIFOFeO94HNT+78lgPg2fRvRxc=;
  b=RalZJfAmREFenTsaGCv1WaGHNwGMxLY+PTjhUm35U43bvoEG6a/AIhMR
   Ax0jo9LFSyvGbt1kvj0lXyagjV04iqvqSWvHq3S9kU9XIUVjhxsX3C9Ml
   pmI4xInRJH9yAXq5G9VeIB9Rh04Q1kCBda98UtuTlwH1lIAwfRtwDVQDl
   uG8S3hZfLpCYBDO7XeFbFfiYbkycTiqqnH4cTY4SB3sCTiAoW2S2Get4+
   x+DXmfgzYtImZOlQkeufRlOr27KdJXQ4CVA6hegjqy4axoAIiTXn1uYm6
   W8MaHRH6DtywvT6cfa4mfDtksDoccAw1U4eBZYjMA1OAgjbQDC0fQaLzM
   w==;
X-IronPort-AV: E=Sophos;i="5.99,234,1677567600"; 
   d="scan'208";a="223049382"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Apr 2023 08:36:55 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Fri, 28 Apr 2023 08:36:55 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Fri, 28 Apr 2023 08:36:54 -0700
From:   Don Brace <don.brace@microchip.com>
To:     <don.brace@microchip.com>, <Kevin.Barnett@microchip.com>,
        <scott.teel@microchip.com>, <Justin.Lindley@microchip.com>,
        <scott.benesh@microchip.com>, <gerry.morong@microchip.com>,
        <mahesh.rajashekhara@microchip.com>, <mike.mcgowen@microchip.com>,
        <murthy.bhat@microchip.com>, <kumar.meiyappan@microchip.com>,
        <jeremy.reeves@microchip.com>, <david.strahan@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Subject: [PATCH 00/12] smartpqi updates
Date:   Fri, 28 Apr 2023 10:37:00 -0500
Message-ID: <20230428153712.297638-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.40.1.375.g9ce9dea4e1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 6.4/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.4/scsi-queue

This set of changes consists of:

 * Map entire BAR 0.
   The driver was mapping up to and including the controller registers,
   but not all of BAR 0.
 * Add PCI IDs to support new controllers.
 * Clean up some code by removing unnecessary NULL checks. 
   This cleanup is a result of a Coverity report.
 * Correct a rare memory leak whenever pqi_sas_port_add_rhpy() returns
   an error. This was Suggested by: Yang Yingliang <yangyingliang@huawei.com>
 * Remove atomic operations on variable raid_bypass_cnt. Accuracy is not
   required for driver operation. Change type from atomic_t to unsigned int.
 * Correct a rare drive hot-plug removal issue where we get a NULL
   io_request. We added a check for this condition.
 * Turn on NCQ priority for AIO requests to disks comprising RAID devices.
 * Correct byte aligned writew() operations on some ARM servers. Changed
   the writew() to two writeb() operations.
 * Change how the driver checks for a sanitize operation in progress.
   We were using TEST UNIT READY. We removed the TEST UNIT READY code and
   are now using the controller's firmware information in order to avoid
   issues caused by drives failing to complete TEST UNIT READY.
 * Some customers have been requesting that we add the NUMA node
   to /sys/block/sd<scsi device>/device like the nvme driver does.
 * Update the copyright information to match the current year.
 * Bump the driver version to 2.1.22-040.

---

David Strahan (1):
  smartpqi: Add new controller PCI IDs

Don Brace (5):
  smartpqi: fix-rare-sas-transport-mem-leak
  smartpqi: fix byte aligned writew for ARM servers
  smartpqi: Add sysfs entry for numa node in /sys/block/sdX/device.
  smartpqi: update copyright to 2023
  smartpqi: update version to 2.1.22-040

Gilbert Wu (1):
  smartpqi: Add support for RAID NCQ priority

Kevin Barnett (2):
  smartpqi: remove null pointer check
  smartpqi: stop sending driver initiated TURs

Mike McGowen (2):
  smartpqi: map full length of PCI BAR 0
  smartpqi: Remove contention for raid_bypass_cnt

Murthy Bhat (1):
  smartpqi: validate block layer host tag

 drivers/scsi/smartpqi/Kconfig                 |   2 +-
 drivers/scsi/smartpqi/smartpqi.h              |   6 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 284 ++++++++++--------
 .../scsi/smartpqi/smartpqi_sas_transport.c    |  34 +--
 drivers/scsi/smartpqi/smartpqi_sis.c          |   2 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |   2 +-
 6 files changed, 178 insertions(+), 152 deletions(-)

-- 
2.40.1.375.g9ce9dea4e1

