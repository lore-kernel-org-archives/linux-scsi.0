Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5150C07E96
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7A95261C68
	for <linux-scsi@archiver.kernel.org>; Tue,  6 Jul 2021 18:16:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230032AbhGFSS6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jul 2021 14:18:58 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:56937 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229954AbhGFSS6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jul 2021 14:18:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1625595380; x=1657131380;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=bh9tLpUYfRHpBdEH/hoayQHkE0kEyRqmUgvJ86oiQlw=;
  b=GOihT6itNrhW1WT5t6PdHFjTcuDSb9Hd3XS6b3KPfbsDN1inzKunF0/g
   F5tCZvUvW3DjCvjCm2Xaqbbzdj+7avJpxTuOxq/VK7KF1TOiyRkSsZViV
   AnUI5cdw+JKPmf9tbaC0YTrBSmrTsX4+1q7h99J03Q4VBvU9Tg2VYuZU+
   Z7gJcf0d6QE/EHyh9sxEBZjt1EGATrJnB9PMDwo6p7S/hkgEddcLN/k4H
   ZCvyBQ+ZhO24fpq6JmlFX041c2miyYUntU1nHhKPVo5gGEfW2UhOsOXER
   gHskTAkx08jORQw0ORGXr2Ku5Rjwk0Pa8czMi+IkQHfVc24iVwq+LPNKA
   Q==;
IronPort-SDR: sGyd5kae2XsK8iNkmyY5vn0C3qBMDaZM2tLmfjJ2/UIGyaOApwb6xu9mlhUkCCRWXZsamkuxDs
 iDtK/sMT4ILvTXnThUYGhfAFvLA2o4zbYDoYcNFW78o/04A8EgsxQmoF/IDw1FZAwjgFfJv+AM
 yNGqXB9ywOWi0968vksqKYhrF/QrI/g1Dl1tqiuMoN+G0PY1NIdJYBZJhjLHnRaLB4166QLaKB
 ZKXVbDw2B+D9aAdXsk6Qk9fvds8KbzGMheuW2IdfI+xk2gXMfALzWXMrkb1FV1ohTN/Dklak01
 i54=
X-IronPort-AV: E=Sophos;i="5.83,329,1616482800"; 
   d="scan'208";a="127272694"
Received: from smtpout.microchip.com (HELO smtp.microsemi.com) ([198.175.253.82])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Jul 2021 11:16:20 -0700
Received: from AUSMBX1.microsemi.net (10.10.76.217) by AUSMBX2.microsemi.net
 (10.10.76.218) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Tue, 6 Jul 2021
 11:16:18 -0700
Received: from brunhilda.pdev.net (10.238.32.34) by ausmbx1.microsemi.net
 (10.10.76.217) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Tue, 6 Jul 2021 11:16:18 -0700
Received: by brunhilda.pdev.net (Postfix, from userid 1467)
        id 5495770204B; Tue,  6 Jul 2021 13:16:18 -0500 (CDT)
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
Subject: [smartpqi updates  PATCH 0/9] smartpqi updates
Date:   Tue, 6 Jul 2021 13:16:09 -0500
Message-ID: <20210706181618.27960-1-don.brace@microchip.com>
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
  * Removing unnecessary unsupported feature messages.
  * Update copyright information.
  * Enhance reset messages.
    - Add SCSI command CDB[0] value to message.
    - Also check for a 0 length SCSI command that can occur if
      sg_reset is issued without any outstanding SCSI commands.
  * Clean up a rare initialization issue where interrupts are
    enabled before the supporting controller context has been
    fully initialized causing NULL pointer access.
  * Update the driver version to 2.1.10-020


Balsundar P (2):
  smartpqi: add PCI id for H3C P4408 controller
  smartpqi: add PCI IDs for new ZTE controllers

Don Brace (1):
  smartpqi: update version to 2.1.10-020

Kevin Barnett (2):
  smartpqi: rm unsupported controller features msgs
  smartpqi: update copyright notices

Mahesh Rajashekhara (1):
  smartpqi: add pci id for H3C controller

Mike McGowen (2):
  smartpqi: add PCI-ID for new Norsi controller
  smartpqi: fix isr accessing null structure member

Murthy Bhat (1):
  smartpqi: add SCSI cmd info for resets

 drivers/scsi/smartpqi/smartpqi.h              |  6 +-
 drivers/scsi/smartpqi/smartpqi_init.c         | 69 ++++++++++++++-----
 .../scsi/smartpqi/smartpqi_sas_transport.c    |  4 +-
 drivers/scsi/smartpqi/smartpqi_sis.c          |  4 +-
 drivers/scsi/smartpqi/smartpqi_sis.h          |  4 +-
 5 files changed, 61 insertions(+), 26 deletions(-)

-- 
2.28.0.rc1.9.ge7ae437ac1

