Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32D1FC4167B
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC6CC23E26
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Dec 2020 20:36:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393790AbgLJUgU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Dec 2020 15:36:20 -0500
Received: from esa.microchip.iphmx.com ([68.232.154.123]:46625 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404455AbgLJUfl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Dec 2020 15:35:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607632540; x=1639168540;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=doYFKZUlImmV9Nua4+/wlhGpQ5LDyeb5bftASqg7Q0M=;
  b=k5+ggaypAKh6pGXJjGwe/70Wxq2lNpU6wynNlqj0p+yYxzBRT7gxw2xH
   DtclQ9WDLPLGzQ8wG3uagCAi/wbvT4cnkzpSLWHAOgjznjNnI13EqpcOt
   vhZCyO6LE18BTmz17XQUn54yh4x0VOlplEIsLGDyWWd3Dk+esnULB7gqD
   FrELT3Tds5pk61Ug6nDsVLNO9G7wYvSXqd3mhqLbC2rsuyAtRzaZqw0IE
   pYTy7RkRUqQkemgm6RMe/SLgMq/HAcn+bKJQIKYyV1Doirc01MVeYm2Yd
   KtjS1ssoLHXAEYV9ujXYt/BTWs9rASsHx6Z8j8Yplqu1HrIU3z3d3P6V7
   g==;
IronPort-SDR: Eq3aMmlt4C3MSjHWt8CeXj1WkO/uUyUxqnCySTy1QuGiuHyKpbCEGH3fptwM+mAE4VTvA0x3f3
 h4tXd0Hxn2gn++xInzJXRs5In0vED6NvWLMrjFy+Q9U6fZuZw38+qQGPXjVP1ZCwsv8ZANHIR6
 OY8p6/v1HRTWJUIhO/j3ON6f6c9T9AVAUyS7zFrmYuXhRukibLz5RVJ8m+TWwBVy9vD1KUxwzo
 xF+Y8sUUlAEAK9INoGXXeiz92U6GA0isOhB3ZNpZTp+V3YR9PZ1yMuqxl6xm7WxsSSatJ3Wj0k
 uoM=
X-IronPort-AV: E=Sophos;i="5.78,409,1599548400"; 
   d="scan'208";a="99412594"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 10 Dec 2020 13:34:21 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Thu, 10 Dec 2020 13:34:20 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Thu, 10 Dec 2020 13:34:20 -0700
Subject: [PATCH V3 00/25] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Thu, 10 Dec 2020 14:34:20 -0600
Message-ID: <160763241302.26927.17487238067261230799.stgit@brunhilda>
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
 drivers/scsi/smartpqi/smartpqi_init.c         | 3123 ++++++++++-------
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |    4 +-
 4 files changed, 2189 insertions(+), 1278 deletions(-)

--
Signature
