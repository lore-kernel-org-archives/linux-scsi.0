Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0FABC41513
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Aug 2023 13:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351256AbjHQNMw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Aug 2023 09:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351374AbjHQNM2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Aug 2023 09:12:28 -0400
Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02A183591
        for <linux-scsi@vger.kernel.org>; Thu, 17 Aug 2023 06:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1692277920; x=1723813920;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=sJvnErBOzSXsSIPJZWHGnycYkGaFssUg37w+ziaVPiY=;
  b=Ksir3ZHPJKmCqpV/T/nIsHhwpzjrJJ69ok7IOpuCjruECrPCkRmicAjN
   pWPF8Ewez045frgXJM183mzbqKMpgRf5NQqxDw8xo6l+BVkcg/YMJPGaJ
   9uewhoZM/1brYaLYnxOrZtY7XeIfObcJR9jhb7W7AmK0ZAREaaa0CT/dE
   BnXgTnpwn1DLhYWJ/Xdp/9n+tEob86GimUZkn8bGFCRnOHgDdnXB8RWJf
   zgeQU/xmKmQfA9M4nZPWxa1TnwSFNZBn8fynrQulTqcU8PPEQ+SEHNO9E
   5x0ept+3zZh/A5g2K05R6xJM3PSC294Qen8l5VQdIoke94pdvl99KIZyZ
   Q==;
X-IronPort-AV: E=Sophos;i="6.01,180,1684825200"; 
   d="scan'208";a="242128325"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 17 Aug 2023 06:11:02 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Thu, 17 Aug 2023 06:10:23 -0700
Received: from brunhilda.pdev.net (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2507.21 via Frontend
 Transport; Thu, 17 Aug 2023 06:10:22 -0700
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
Subject: [PATCH 0/9] smartpqi updates
Date:   Thu, 17 Aug 2023 08:12:23 -0500
Message-ID: <20230817131232.86754-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.42.0.rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 6.6/scsi-queue tree
  https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git
  6.6/scsi-queue

There is a large format-only patch to align our kernel.org driver with
our out-of-box driver. We add patches to our oob driver first, run
regression tests on these patches, then apply them to our kernel.org
driver. Having the formatting align facilitates patch management and
internal reviews. The contextual differences was becoming quite
tedious.

The biggest functional change to smartpqi is the addition of an abort
handler. Some customers were complaining about I/O stalls to all devices
when only one device is reset. Adding an abort handler helps to prevent
I/O stalls to all devices.

All of the reset of the patches are small changes to logging messages,
MACRO and variable name changes, and one minor change for LUN assignments.

This set of changes consists of:
* smartpqi-reformat-to-align-with-oob-driver
  There have been a lot of format changes to our out-of-box driver. To
  make adding patches from our oob driver to our kernel.org driver
  (in-box), align formatting.
  This is a format-only patch. No functional changes.
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

---

David Strahan (3):
  smartpqi: simplify lun_number assignment
  smartpqi: enhance shutdown notification
  smartpqi: enhance controller offline notification

Don Brace (1):
  smartpqi: change driver version to 2.1.24-046

Kevin Barnett (4):
  smartpqi: reformat to align with oob driver
  smartpqi: add abort handler
  smartpqi: refactor rename MACRO to clarify purpose
  smartpqi: refactor rename pciinfo to pci_info

Mahesh Rajashekhara (1):
  smartpqi: enhance error messages

 drivers/scsi/smartpqi/smartpqi.h      |   16 +-
 drivers/scsi/smartpqi/smartpqi_init.c | 1852 ++++++++++---------------
 2 files changed, 755 insertions(+), 1113 deletions(-)

-- 
2.42.0.rc2

