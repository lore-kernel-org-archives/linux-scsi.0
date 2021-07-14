Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 144F8C11F68
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 028B6613C5
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:28:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240078AbhGNSbs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:31:48 -0400
Received: from esa.microchip.iphmx.com ([68.232.154.123]:36774 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240023AbhGNSbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:31:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1626287329; x=1657823329;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=vYQmGQK8UjM+aNZjkuZZh44lvd20EBVtgaQ8Dm6Cun0=;
  b=2ksP5SHZj6GrtX3wSWrfZ+LSaKRLco96BPsYkvNteCdGb5hf5BRd7z3z
   kSAo79iEiGctbq0toLZ6Fh2rEChFxyTr/Mo4KPuG82LQqmwSEnG5Vw+60
   ZOVfYrOGgi0B6L69//4ZxGaMsEVR3BiYIz0JQ/LvdrdqGokRrzw5B9ooZ
   j001V9Q1dpfxxYa39q9higGQsnsRwGrK+6yDV/7jyoedSWNQWQQZmG0Z6
   8dQbFXHvHJ1WTlH0Ns0xtDwNUtM4FWBcgvrivOFINVsMZBW9VI19hH0Br
   MvaCb1SiK1Gnv339x52IHOdjYzs+mMJwj0fLmhkAKNDPVuZ4bqhLMc+nC
   g==;
IronPort-SDR: Z+vLS+hvyR4xVCCedT7a47LIsJB0zz6Zwc9J0+xBqx+vZfrdgk/LnrDl9uSyxJFJY/qFkf6pdZ
 YfMsJZXswA6cONtTQEaexGm2QcNoFEwieVjBrVQIfErgiZ1ILXQsoW3P84Xp9kuEWk2pKAuyuA
 zRBF9tauc00KzF1669PxJ8XJQyiINXybYBZqfQ7LzAvmrPlC3ZqTs0wTpoJDk+WRycIptusWpw
 P4Doo7mEgPoGTFffK8rLtGmG2qe1ki/zd1JGQ7WTw9xnT1w8U70Fk1nLykFrEYcZAo6uzhcg+q
 G4M=
X-IronPort-AV: E=Sophos;i="5.84,239,1620716400"; 
   d="scan'208";a="124579312"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 14 Jul 2021 11:28:48 -0700
Received: from AVMBX1.microsemi.net (10.10.46.67) by AUSMBX1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 14 Jul
 2021 11:28:47 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by avmbx1.microsemi.net
 (10.10.46.67) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 14 Jul 2021 11:28:47 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 294EA7025B5; Wed, 14 Jul 2021 13:28:47 -0500 (CDT)
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
Subject: [smartpqi updates V3 PATCH 0/9] smartpqi updates
Date:   Wed, 14 Jul 2021 13:28:38 -0500
Message-ID: <20210714182847.50360-1-don.brace@microchip.com>
X-Mailer: git-send-email 2.28.0.rc1.9.ge7ae437ac1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

These patches are based on Martin Petersen's 5.14/scsi-queue tree
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

Change since V2:
Changes resulting from Paul Menzel <pmenzel@molgen.mpg.de>
review:
  * No code changes, just correcting an e-mail.
  * Corrected misspelling on Martin Petersen's e-mail and name.
    Apologies.


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

