Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E19C5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1B9A60F6B
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 16:09:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243779AbhIFQKE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 12:10:04 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:47951 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243365AbhIFQKE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 12:10:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1630944539; x=1662480539;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=jwq9HvJWA0jP5gqhGPFKhyWRAm0g0Oi4HG0o+ZGIPiU=;
  b=mO+/cPsR2Ls48gaubxFdzMrdGbZYeRBcSpFYFpPVMAgpTmfNNBi/PZH/
   JDRGOExNNJdf9dON0eCzuBy+HOr65h0ZLC4XLSv+pQL7oLNGbPfFa0Cp3
   gJmz7StDOeSI4qiUN35+RBjV9mZom7DZg4Px5DwgV+8cPdfJZQ/39Cbje
   LLbzfF/vaAita9fplbZbbYo2LJEww9htAZTBiRl/cTFwuwb2Rj8jQL49z
   P6bsZwjTezCwd9fd/yIR9nNRNEeGacLtsTR5yGr1EwgK+CQrUEjWCnE3o
   0D8R5LMwTrbOd8Yg9QUd3VTTvYpeqAl6Y/g1p8/RoAqahUDRS8x2dFySt
   A==;
IronPort-SDR: L3cFlyBfDQs8jF7Stje5+dn9pLBWX5V4DFYGgNxxBeGzmnVWItdcijHf1OQ2u5c+wempc5XHdi
 L5arHPHw6hlODugcMtL1hysA2cfo3LwUPI0B3zBeqst0FQKaFbxBSLKbmP3HeFxGN+enSymcYY
 DVgGoW8w1OdNCKgsCT5g8yI3QTinIgFEv8upa8HEtrgYuGK2/z/8Hkm649TWznZYv2G+kwOHov
 +VBwKfoUcye4wegDAILMz7/1tUb2RNCwtziNWQP1O85HQ6bA12L7oWUBQ1CSqxtPu8Ox7I2+1k
 +Bfg8X+K2q6s5V4MvDeEl+EA
X-IronPort-AV: E=Sophos;i="5.85,272,1624345200"; 
   d="scan'208";a="143033425"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 06 Sep 2021 09:08:58 -0700
Received: from chn-vm-ex01.mchp-main.com (10.10.85.143) by
 chn-vm-ex03.mchp-main.com (10.10.85.151) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 6 Sep 2021 09:08:58 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex01.mchp-main.com
 (10.10.85.143) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 6 Sep 2021 09:08:58 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 0/4] pm80xx updates
Date:   Mon, 6 Sep 2021 22:34:00 +0530
Message-ID: <20210906170404.5682-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver

Changes from v1 to v2:
	- For fix incorrect port value patch
		- More detailed commit message now
		  mentioning problem and fix.
	- For fix lockup due to commit patch
		- Commit message includes little detail
		  of previous commit.
		- Added 'Fixes' tag.
		  

Ajish Koshy (3):
  scsi: pm80xx: fix incorrect port value when registering a device
  scsi: pm80xx: fix lockup due to commit <1f02beff224e>
  scsi: pm80xx: fix memory leak during rmmod

Viswas G (1):
  scsi: pm80xx: Corrected Inbound and Outbound queue logging

 drivers/scsi/pm8001/pm8001_ctl.c  |  6 ++--
 drivers/scsi/pm8001/pm8001_hwi.c  |  7 +++-
 drivers/scsi/pm8001/pm8001_init.c | 12 +++++++
 drivers/scsi/pm8001/pm8001_sas.c  | 15 ++++++++
 drivers/scsi/pm8001/pm8001_sas.h  |  6 ++--
 drivers/scsi/pm8001/pm80xx_hwi.c  | 60 +++++++++++++++++++++++++------
 6 files changed, 91 insertions(+), 15 deletions(-)

-- 
2.27.0

