Return-Path: <SRS0=rv89=A7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C103AC433E1
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:43:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9445D22BF3
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jul 2020 13:43:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="AM8myZr+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbgGTNn2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jul 2020 09:43:28 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:54484 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbgGTNn2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jul 2020 09:43:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1595252607; x=1626788607;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=KFA457IyjXKAicinr/ZBDxvipU8NFQCHwd9RN0NjAHE=;
  b=AM8myZr+yqiGiNr9k9yUon8p4AFdz7wsl3Lf+xAGRjzK6BNsQddnT+FT
   5wrXLgDxIg1XF3uCRchQ2knwZNBjSWoz3GFDImm/v6wwOC6jiFUtTzQUG
   EOQ51QgNq29ciC9ovCYPYHu/K/a80MNhmlK2FobQrkf7vhQ8V9b7B7SeZ
   0XGOEYSpc9cfgl/POOygPfxyKiYWOOu0FXuZbNpakv8EirB66NBCtHZ+7
   y/z19yWPU6j9FNJ1SzeaeB8hw2Hj069UeBpXr7Se9ksnz42jbXSju7r4k
   42OJX7EoSna3/BtGLUwkWW5eOyx10TWnXIWDtctugPYIUTF2L8Ns0oUF0
   w==;
IronPort-SDR: ztuCyigmUEvqJWwm7t+19SN6ialxA0GW4SHuKo9Wr0B64XC/kd00x2MWictLoqWQkoZ9FOJIty
 rk+cnC5UxS1uXZTaZ3pzowAitkXuHxnJkckC7OJnLEqPlAmojrebRB4TKucX0JaS2yoG14B5dX
 KM2sU4MknDWjxwD08N/tW97IUofe1L4/AZzQDrgjbsPzq0/QyDMHkRO1G2YMBin3PFPJfjvsZt
 DtbM1+Sq1+SUujQtBSoMrknaEcnTOuJ0rJu5/OIMGf73nJnNbNwYZZcwwFkKwqsolDw4llYbxN
 M0Q=
X-IronPort-AV: E=Sophos;i="5.75,375,1589266800"; 
   d="scan'208";a="19826966"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Jul 2020 06:43:25 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 20 Jul
 2020 06:43:25 -0700
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Mon, 20 Jul
 2020 06:43:24 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V3 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Mon, 20 Jul 2020 19:23:01 +0530
Message-ID: <20200720135303.6948-1-deepak.ukey@microchip.com>
X-Mailer: git-send-email 2.19.0-rc1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Deepak Ukey <Deepak.Ukey@microchip.com>

This patch set includes some bug fixes and features for pm80xx driver.

Changes from V2:
	For "Support for get phy profile functionality."
		-Added fix for Wmissing-prototypes warning reported by
		kernel test robot
	For "Staggered spin up support."
		-Added fix for Wmissing-prototypes warning reported by
                kernel test robot
	For "Wait for PHY startup before draining libsas queue."
		-Removed the patch from patchset. According to recommendation
		we need to fix this using udev so planning to submit in future.

Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

 drivers/scsi/pm8001/pm8001_ctl.h  |  20 ++++
 drivers/scsi/pm8001/pm8001_defs.h |   3 +
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  55 +++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  36 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  18 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 208 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 8 files changed, 331 insertions(+), 25 deletions(-)

-- 
2.16.3

