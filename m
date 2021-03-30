Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 824C9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2C6CF61989
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 06:31:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbhC3Gaf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 02:30:35 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:24622 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbhC3Gab (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 02:30:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1617085831; x=1648621831;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=7190iZ7kBCVKYL2aAdkIbWyifq8HBZN8VkDtHzDTvtk=;
  b=JV3s6/Td4uoDJJnUsfyrRcUFcGIaBZER4cDwyULecHCyBAkR8dRHaNsA
   6l5A/iVY6BXhycu0dEusSvyuxYT8HOGFs0bUnNnvcSsNWTGGuSwZctsWY
   9k+ph3HU11lDMc72lM1HKRvbFWsULE7UkoPnNquj0VhSsaKQP3r9pCgsH
   O2SKtJQPuDAc3DfySulb5k+Pr4AOiKxLMBxpZE9ols341zG/lu51HHVll
   PzeZdvnLM2HtSxELFSAzTZy08IJBPmZJCS2Tys21LNPHTbveQHAS9j9mc
   bajsjP/JAkcWti3PRIBbCvcChWOt4JiJITI68GGfiekhA36EGJq3OCEra
   A==;
IronPort-SDR: RU440R5FFaGOJ9ke7VetM1W29obGc4xkAx6g53wOTGgabFPeQtvgJL/QERoKBVcquefEmvXrUm
 4Mjd4sgrKeD9WZmtyqyiN56U6c5JAfGv98r+7PUUIHoyylF/zszCA1YPPTJaVu6uomWEzXBDCN
 cye8RMPuB3Hw5S2hGxHTPWEPSPyGgH5dGyROXptVaza7BayeSew2F2447uRkQTFh96ZTUb81lJ
 d7wcIgWQNNz2SBEev6S9ug0RFdD07gPYnv1nQtFJie/YDdCmcwSXbCD6U9cp1SNfKYbcGZFLcG
 FoU=
X-IronPort-AV: E=Sophos;i="5.81,290,1610434800"; 
   d="scan'208";a="121012007"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Mar 2021 23:30:30 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Mon, 29 Mar 2021 23:30:30 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Mon, 29 Mar 2021 23:30:30 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v3 0/7] pm80xx updates
Date:   Tue, 30 Mar 2021 12:10:01 +0530
Message-ID: <20210330064008.9666-1-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set include some bug fixes and enhancements for pm80xx driver.

Changes from v2 to v3:
	- For "Add sysfs attribute to check mpi state" patch
		Fixed "warn: mask and shift to zero"
		Made mpiStateText static, as suggested by buildbot

Changes from v1 to v2:
	- For sysfs attribute patches
		Used sysfs_emit instead of sprintf for sysfs attribute patches.
		Removed debug message for sysfs attribute patches.
	- For "Reset PI and CI memory during re-initialize" patch
		Improved commit message.

		

Ruksar Devadi (1):
  pm80xx: Completing pending IO after fatal error

Vishakha Channapattan (4):
  pm80xx: Add sysfs attribute to check mpi state
  pm80xx: Add sysfs attribute to track RAAE count
  pm80xx: Add sysfs attribute to track iop0 count
  pm80xx: Add sysfs attribute to track iop1 count

Viswas G (2):
  pm80xx: Reset PI and CI memory during re-initialize
  pm80xx: remove global lock from outbound queue processing

 drivers/scsi/pm8001/pm8001_ctl.c  | 107 +++++++++++++++++++++++++++++++++++++-
 drivers/scsi/pm8001/pm8001_hwi.c  |  68 +++++++++++++++++++++---
 drivers/scsi/pm8001/pm8001_hwi.h  |   1 +
 drivers/scsi/pm8001/pm8001_init.c |   9 ++--
 drivers/scsi/pm8001/pm8001_sas.c  |   2 +-
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c  |   7 ++-
 drivers/scsi/pm8001/pm80xx_hwi.h  |   1 +
 8 files changed, 184 insertions(+), 13 deletions(-)

-- 
2.16.3

