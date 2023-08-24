Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F38E5C88CB9
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Aug 2023 15:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242285AbjHXP4y (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 11:56:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242383AbjHXP4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 11:56:46 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C1C19A1
        for <linux-scsi@vger.kernel.org>; Thu, 24 Aug 2023 08:56:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692892605; x=1724428605;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=mUUS2NgvIFxg2AnA7mzhtJA5MyS37wGEcpW1aknKLEU=;
  b=RTlU0bZi2eES28+6NKY8kiW8us2IJCHccg1tOibtiu58lHzWgn7eD9Td
   QCwMh0zijKhtk7mtvdJ1R7MOYppAHHPwj+jNgYYd73CyO4b41DTtSJQWn
   cwXG5Cos2KJfz8hMZBHr4xz0u6Dtkh+0JPaIQlGywacBOqGnYU8t1qLqx
   Wst4Q9QIABn9srTyWWGClACQhfsUyPHvC/rLrCd6o8veSZnlRXv+xpe1G
   RSqaZMyv1nP2l9FibPZO5ZCAjoBrDIWOD7XPGdYEHxUihk/NQGSa9DZ0L
   XbO4QsiSG6pCnfVnzmBeNa06rlI33oHOh0EZjqBkVXHFd+PKKsSHzvk2H
   g==;
X-IronPort-AV: E=Sophos;i="6.02,195,1688454000"; 
   d="scan'208";a="1100382"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Aug 2023 08:56:44 -0700
Received: from chn-vm-ex02.mchp-main.com (10.10.85.144) by
 chn-vm-ex04.mchp-main.com (10.10.85.152) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 24 Aug 2023 08:56:10 -0700
Received: from brunhilda.pdev.net (10.10.85.11) by chn-vm-ex02.mchp-main.com
 (10.10.85.144) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 24 Aug 2023 08:56:09 -0700
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
Subject: [PATCH v2 0/8] smartpqi updates
Date:   Thu, 24 Aug 2023 10:58:04 -0500
Message-ID: <20230824155812.789913-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

cat smartpqi_6.6_cover_letter
These patches are based on Martin Petersen's 6.6/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.6/scsi-queue

The biggest functional change to smartpqi is the addition of an abort
handler. Some customers were complaining about I/O stalls to all devices
when only one device is reset. Adding an abort handler helps to prevent
I/O stalls to all devices.

All of the reset of the patches are small changes to logging messages,
MACRO and variable name changes, and one minor change for LUN assignments.

This set of changes consists of:
* smartpqi-add-abort-handler
  When a device reset occurs, the SML pauses I/O to all devices presented
  by a controller instance causing some performance issues.
  To only affect device with a problematic request, we added an abort handler.
  The abort handler is implemented by using a device reset, but I/O to the
  other devices is no longer affected.
* smartpqi-refactor-rename-MACRO-to-clarify-purpose
  The MACRO SOP_RC_INCORRECT_LOGICAL_UNIT was used to check for a condition 
  where a TMF was sent an incorrect LUN. We renamed this MACRO to
  SOP_TMF_INCORRECT_LOGICAL_UNIT for clarity.
* smartpqi-refactor-rename-pciinfo-to-pci_info
  Change the pciinfo variable to pci_info to make more readable code.
  No functional changes.
* smartpqi-simplify-lun_number-assignment
  We simplified the conditional expression used to populate LUN numbers
  for requests.
* smartpqi-enhance-shutdown-notification
  Clarify controller cache flush errors. We added in more precise information
  to the cache flush informational message.
  No functional changes.
* smartpqi-enhance-controller-offline-notification
  The driver can offline a controller for multiple reasons. We added
  a description of why these rare offline actions are taken. And a function
  to provide the specific details of the shutdown.
* smartpqi-enhance-error-messages
  We added host:bus:target:lun to messages emitted in our reset/abort handlers.
  No functional changes.
* smartpqi-change-driver-version-to-2.1.24-046

Changes since v1:
Removed patch smartpqi-reformat-to-align-with-oob-driver based on a review by:
"Martin K. Petersen" <martin.petersen@oracle.com>
Link: https://lore.kernel.org/all/yq1o7j05ae9.fsf@ca-mkp.ca.oracle.com/

David Strahan (3):
  smartpqi: simplify lun_number assignment
  smartpqi: enhance shutdown notification
  smartpqi: enhance controller offline notification

Don Brace (1):
  smartpqi: change driver version to 2.1.24-046

Kevin Barnett (3):
  smartpqi: add abort handler
  smartpqi: refactor rename MACRO to clarify purpose
  smartpqi: refactor rename pciinfo to pci_info

Mahesh Rajashekhara (1):
  smartpqi: enhance error messages

 drivers/scsi/smartpqi/smartpqi.h      |  16 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 254 ++++++++++++++++++++------
 2 files changed, 215 insertions(+), 55 deletions(-)

-- 
2.42.0

