Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6833C433C1
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AC16619D5
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Mar 2021 16:55:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236428AbhCXQyd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 12:54:33 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:35685 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236461AbhCXQyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 12:54:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1616604858; x=1648140858;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=EqjzTNHmNVEZYc082RCSSslCH5PHJAmhWM15IKMw8gQ=;
  b=nCdoqF1n2yzEpF87ylltVPX4ctV6NfcNoSywbCivOA2SXkiBBXGnboYI
   xfE0fur1ak+H8UZqjoL/mX+2ou7QO3vj++LtMOk6wq4ymCfkRBOqluk7y
   wgDnGPVdxA4ATaPOz3VCnh6jDsO5XKm8vifCqrUqofW3vSs2Eg8/Fbo7G
   V7Im6eu10oJENR2WfUAkrJtq82xF97u4xNeCgfQJ3bNhJ2OsKaOYVlwi7
   NvKsD5EmMEhjPTM9na/zQJmqHwEa+QgRlDKRY9jlCRas3g1NTWvGTEqWJ
   UPxbJ6JhD82aIWInHAwlIWApqg3XLgjGjJXt8l0H9FA3tfi/QvXn8vbDh
   g==;
IronPort-SDR: AQoTLnhR2u50plQN+RLuJW8w8P9zcX91xfPRwBtgsL2uNU0H0WMQdw30Fja9MIkzrEjd9o4+7n
 jaVnSonsB81cdDXs4CTwwGPcoUn+dTcGqcmomy3c2gmfz6yGLdoNYL+T0UQlwB2hLQwGGwxLsx
 EYSvD11QhURpB7gaRpvH+9255UlS7R3T9nwdDxmEgmIRpb/yFTpltHu8gC+SkQtc4xjs/+Niom
 8q4BEm0uFLHXVKulrhy2piU5gMPItHZjD7Qyj1BK9Qnht8BGKYnH5ufb7Itso6SUGFNvKo92QO
 f6Y=
X-IronPort-AV: E=Sophos;i="5.81,275,1610434800"; 
   d="scan'208";a="120297770"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Mar 2021 09:54:18 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 24 Mar 2021 09:54:17 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.2 via Frontend
 Transport; Wed, 24 Mar 2021 09:54:17 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <vishakhavc@google.com>, <radha@google.com>,
        <jinpu.wang@cloud.ionos.com>,
        Ashokkumar N <Ashokkumar.N@microchip.com>,
        "John Garry" <john.garry@huawei.com>
Subject: [PATCH v2 0/7] pm80xx updates
Date:   Wed, 24 Mar 2021 22:33:50 +0530
Message-ID: <20210324170357.9765-1-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set include some bug fixes and 
enhancementments for pm80xx driver.

Chnges from v2:
	- for sysfs attribute patches
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

