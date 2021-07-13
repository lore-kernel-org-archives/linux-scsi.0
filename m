Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71579C07E96
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F74761152
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Jul 2021 21:02:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229478AbhGMVFg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Jul 2021 17:05:36 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:24255 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234172AbhGMVFf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Jul 2021 17:05:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626210165; x=1657746165;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=umlABZkJHw7V4iWPgz6fu0Xhlp40mzDNKgz22ICVX5s=;
  b=P1QCtU+wUSYvdklh9tiBYsmenEvN1fqDR1JBwMemn/Yiz7/D9CKnu4TE
   Xk1jlbGmfcT/ipI6HMJeIkrXMV3zen+MTXleajvCKPtdBVXoiDk9XxCV8
   /rqivqziG9Q1RoxG+jDHVqBLrYcnutCWwdWDFmrTPyltfaoMZQEVBRV68
   6hd/a2sDOAWj17s9eTFfkifi2+e/Kjp1Zmqyt9wUQKvZo1MU4KwxxSvtf
   NDRaz36bOJP6BgcwAlN2YWWgXhbeqKT7+vBDMY6dVPEReEokogLp7oIC5
   XXP8ozkHyJaaKAfFWB9YRxKnmKqA/XUgHii338249Kk+qd8EbA7RwPkrI
   g==;
IronPort-SDR: 0Kk7kLlKdu0GP4wHWN8T6uCrlaX+9yShksQXlYqKjw5FHfj98zsF5nOftCvtddPaSrcWXihXzC
 6tKFKRN3d1hQfCumUsWaCiKTOPVCnWcDBkIFQCxFis3kC9MVAeZAiNor8tlrq2DCyHQejWJzcn
 aO5fx/3Pa9u9A63ONWPM3BB+OB7+NG5SBYkXRCptLmXJQ4W6NgQ5jgKjFfBIKk9/jZZXKd181c
 NZuzinVplXg43FAIpq3cmOUDP76A2hl5oIoGC02v3lrRIvg8ULY41FdiTiFK0NzBtlAIk+LUEu
 9xc=
X-IronPort-AV: E=Sophos;i="5.84,237,1620716400"; 
   d="scan'208";a="124447483"
Received: from f5out.microchip.com (HELO smtp.microsemi.com) ([198.175.253.81])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Jul 2021 14:02:44 -0700
Received: from AVMBX2.microsemi.net (10.10.46.68) by AVMBX1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 13 Jul
 2021 14:02:43 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx2.microsemi.net
 (10.10.46.68) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 13 Jul 2021 14:02:43 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 620E6703479; Tue, 13 Jul 2021 16:02:43 -0500 (CDT)
From:   Don Brace <don.brace@microchip.com>
To:     <hch@infradead.org>, <martin.peterson@oracle.com>,
        <jejb@linux.vnet.ibm.com>, <linux-scsi@vger.kernel.org>
CC:     <Kevin.Barnett@microchip.com>, <scott.teel@microchip.com>,
        <Justin.Lindley@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <balsundar.p@microchip.com>, <joseph.szczypek@hpe.com>,
        <jeff@canonical.com>, <POSWALD@suse.com>,
        <john.p.donnelly@oracle.com>, <mwilck@suse.com>,
        <pmenzel@molgen.mpg.de>, <linux-kernel@vger.kernel.org>
Subject: [smartpqi updates V2 PATCH 0/9] smartpqi updates
Date:   Tue, 13 Jul 2021 16:02:34 -0500
Message-ID: <20210713210243.40594-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Peterson's 5.14/scsi-queue tree
https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git 
      5.14/scsi-queue

Most of these patches consist of adding new PCI devices. The remainder
are simple updates to correct some rare issues and clean up some
driver messages.

This set of changes consist of:
  * Add in new PCI-IDs.
    5 of these patches are adding in new PCI-IDs.
  * Update copyright information.
  * Enhance reset messages.
    - Add SCSI command CDB[0] value to message.
    - Also check for a 0 length SCSI command that can occur if
      sg_reset is issued without any outstanding SCSI commands.
  * Clean up a rare initialization issue where interrupts are
    enabled before the supporting controller context has been
    fully initialized. Found by internal testing only.
  * Update the driver version to 2.1.10-020

Change since V1:
Changes resulting from Paul Menzel <pmenzel@molgen.mpg.de>
review:
  * Renamed some PCI-ID patches to reflect controller name
  * Renamed patch smartpqi: fix isr accessing null structure member
    to smartpqi: fix isr accessing uninitialized data
  * Split copyright patch. Removed driver name updates and placed
    them in a separate patch.
  * Removed patch ("smartpqi: rm unsupported controller features msgs")
    May remove them in a future patch.


Balsundar P (1):
  smartpqi: add PCI IDs for new ZTE controllers

Don Brace (3):
  smartpqi: change driver module MACROS to microchip
  smartpqi: change Kconfig menu entry to microchip
  smartpqi: update version to 2.1.10-020

Kevin Barnett (1):
  smartpqi: update copyright notices

Mahesh Rajashekhara (1):
  smartpqi: add pci ids for H3C P4408 controllers

Mike McGowen (2):
  smartpqi: add PCI-ID for new ntcom controller
  smartpqi: fix isr accessing uninitialized data

Murthy Bhat (1):
  smartpqi: add SCSI cmd info for resets

 drivers/scsi/smartpqi/Kconfig                 |  8 +--
 drivers/scsi/smartpqi/smartpqi.h              |  6 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 64 +++++++++++++++----
 .../scsi/smartpqi/smartpqi_sas_transport.c    |  4 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |  4 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |  4 +-
 6 files changed, 64 insertions(+), 26 deletions(-)

-- 
2.28.0.rc1.9.ge7ae437ac1

