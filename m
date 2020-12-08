Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C6F2C2BBCF
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:26:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5552223A79
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Dec 2020 20:26:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728411AbgLHUZ6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Dec 2020 15:25:58 -0500
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:25999 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726738AbgLHUZ4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Dec 2020 15:25:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1607459155; x=1638995155;
  h=subject:from:to:cc:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rjx1hEZdg50UepevKgr6oYYgNBbk1tPcLa7fZHDURhY=;
  b=FIa/yuB/8qft2N7r084aaVTFEDjAVydI6/qlGPkN5gHcGrcatZbpzdHP
   ziII9F0fQeNzoxmxVQoC2K9MiuxSZEJQymjSyyiijtlw9YbdyDHnDd2/Z
   4x8/ApMrbCCXO3R90QxYc0mvRsakIeGRz2F1jbyBcff+rNCxBed6nKrv0
   CmHYKvU0iOcEiscF3UBseYJu7wJIeGYNcrmv5Kc0t7WLzKHszRxtw0MHh
   PmloafFgY3s7oabaQMIcKcWIRA1OBCF9lNHKWbr/FSyqNTZ5J9fFqdU1h
   crKlmc46Uef0mdC0klx7O2bFGiUnjCOHIuQ3cUgF8swk7UBXxPlZu5X1I
   w==;
IronPort-SDR: GD72SoHAYlwnN8Gy+uObOiHIFXJKOMXnEy8KoeKu3RMZFozhX+dAIjgbzwmn2HblZL0cbSNiro
 D5oNREU61prfYhdMREbN2MCAHMlFSFbksHYOpXFuF1uGaWDltLuUbeEWYFkNm6rHn4h2KcpnLI
 IQyKuQZr5m06acgwGRXgAlJeoHSSta6CjHHP/D03j3XWUpOYYvqHAC893yXV22JNdnlIn0S4Ft
 L6GP+0rLXcf2SVvErA0OfZbxvNOTPYSki9SaAH2h/06L9/I9hlQBzBTLMERMW0Vg8PlT928jQz
 P3g=
X-IronPort-AV: E=Sophos;i="5.78,403,1599548400"; 
   d="scan'208";a="102011964"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 08 Dec 2020 12:36:35 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Tue, 8 Dec 2020 12:36:35 -0700
Received: from [127.0.1.1] (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Tue, 8 Dec 2020 12:36:35 -0700
Subject: [PATCH V2 00/25] smartpqi updates
From:   Don Brace <don.brace@microchip.com>
To:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <hch@infradead.org>, <jejb@linux.vnet.ibm.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>
CC:     <linux-scsi@vger.kernel.org>
Date:   Tue, 8 Dec 2020 13:36:35 -0600
Message-ID: <160745609917.13450.11882890596851148601.stgit@brunhilda>
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
 drivers/scsi/smartpqi/smartpqi_init.c         | 3111 ++++++++++-------
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   39 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |    4 +-
 4 files changed, 2180 insertions(+), 1275 deletions(-)

--
Signature
