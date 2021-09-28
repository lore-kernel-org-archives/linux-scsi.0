Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84C25C43217
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D9FA61357
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Sep 2021 23:54:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243367AbhI1X4e (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Sep 2021 19:56:34 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:25123 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243330AbhI1X4Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Sep 2021 19:56:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1632873284; x=1664409284;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=hb1FDWgitXO93JdrBImUbsvy8DjbfQuOgUxRuHKy6FY=;
  b=oIqP27WSHbpyEyce8cfg8f/I2ciTAYruebdRXXaCwhICjsbwqhTMB0Ni
   /nawHmJd3diJgKRKdfJuuPI51u4S4SUCteRAXjV+JimvcN42x59+3HatD
   uXLfW3h3epoLUgKDfncYB5ZLPbD9Oq3GRWj+CaQBS6y7Mvj/435WV6cYK
   pQmaUZY21jjK75qHnMmuwzMd0nJita9QzuI337rQEq2/PozsxQots10GP
   1O0PW/GUMTLzSuLbLkw23A6HLCdeA/bTqixfHC4nHvn5x5YaziPwfmdBm
   2Sef8ZXDnfXrvMWu+kdUkRK1oVwpWYqRg8ReJbMAgDb+lS8awbG5OxmCj
   Q==;
IronPort-SDR: nYgLiPPRd0zjKz3TcRV3oNRFwlDhPTcRvBwOydMNZlrfNHe+b9tgVk5GFa6qCdr2O1Hk2sm7qb
 hO5uT14VbfawLz4mx5Yfc1Qyy7HTJMowEnUoS7BUVIkDVjwGLeOPfD51cJvA/HmCQWUFoB9iCL
 MHvZUx63Z141jI6GcwJWXUl+p+Ri+Ez3m2c/oEXHBiJL0ZT5jkV8zYs7wAwpX9kMK0EFGW9dEx
 CcljfrGysEzdBhPuPnMJmbZi0qlXuFRAp6tCAaQE8ECrKwKcNsR2g0ldagB3Up4/ALbJTuYHUA
 HJ+1qKUeycMLwfVO0SmJ6Rkw
X-IronPort-AV: E=Sophos;i="5.85,330,1624345200"; 
   d="scan'208";a="131019746"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 28 Sep 2021 16:54:43 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Tue, 28 Sep 2021 16:54:42 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Tue, 28 Sep 2021 16:54:42 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 584177027D4; Tue, 28 Sep 2021 18:54:42 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.petersen@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates PATCH V2 00/11] smartpqi updates
Date:   Tue, 28 Sep 2021 18:54:31 -0500
Message-ID: <20210928235442.201875-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 5.16/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  5.16/scsi-queue

This set of changes consist of:
  * Aligning device removal with our out of box driver.
  * Aligning kdump timing with controller memory dump.
    The OS was rebooting before the controller was finished dumping its own
    memory. Now the driver will wait for the controller to indicate that its
    dump has completed.
  * In rare cases where the controller stops responding to the driver, the
    driver can set reason codes to aid in debugging.
  * Enhance device reset operations. The driver was not obtaining the current
    number of outstanding commands during the check for outstanding command
    completions. This was causing reset hangs.
  * Add in a check for HBA devices undergoing sanitize. This was causing long
    boot up delays while the OS waited for sanitize to complete. The fix is to
    check for sanitize and keep the HBA disk offline. Note that the SSA spec
    states that the disk must be manually re-enabled after sanitize has
    completed. The link to the spec is noted in the patch.
  * When the OS off-lines a disk, the SCSI command pointers are cleaned up.
    The driver was attempting to return some outstanding commands that were
    no longer valid.
  * Add in more enhanced report physical luns (RPL) command. This is an
    internal command that yields more complete WWID information.
  * Correct a rare case where a poll for a register status before the
    register has been updated.
  * When multi-LUN tape devices are added to the OS, the OS does its own
    report LUNs and the tape devices were duplicated. A simple fix was to update
    slave_alloc/slave_configure to prevent this.
  * Add in some new PCI devices.
  * Bump the driver version.

Changes since V1:
  * Corrected issues with my e-mail server.


Don Brace (3):
  smartpqi: update device removal management
  smartpqi: add tur check for sanitize operation
  smartpqi: update version to 2.1.12-055

Kevin Barnett (2):
  smartpqi: update LUN reset handler
  smartpqi: fix duplicate device nodes for tape changers

Mahesh Rajashekhara (2):
  smartpqi: add controller handshake during kdump
  smartpqi: avoid failing ios for offline devices

Mike McGowen (3):
  smartpqi: add extended report physical luns
  smartpqi: fix boot failure during lun rebuild
  smartpqi: add 3252-8i pci id

Murthy Bhat (1):
  smartpqi: capture controller reason codes

 drivers/scsi/smartpqi/smartpqi.h              |  61 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 540 +++++++++++++-----
 .../scsi/smartpqi/smartpqi_sas_transport.c    |   6 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |  60 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |   4 +-
 5 files changed, 509 insertions(+), 162 deletions(-)

-- 
2.28.0.rc1.9.ge7ae437ac1

