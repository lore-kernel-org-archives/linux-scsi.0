Return-Path: <SRS0=oFF2=AF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C618C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 11:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0FE7120857
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Jun 2020 11:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="EqZ9uVEj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390792AbgFXLxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Jun 2020 07:53:51 -0400
Received: from esa1.microchip.iphmx.com ([68.232.147.91]:9033 "EHLO
        esa1.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389353AbgFXLxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jun 2020 07:53:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1592999630; x=1624535630;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=Ik8z9f7ZDrv6aedif6qm/PU7rFm4Yddd0Kfo11LRwtw=;
  b=EqZ9uVEjnj/AkXXNDYMo7HCD7n1FWlUtdT2wbxYlsyiv9TV5dgGj3UVJ
   rjVFqQvMZNjG860HUcFL0Lrlq0OylMBhBXvmyujjy8aZzGJrso4XGX/tC
   MEmo2ugduWZrQj6HbSc/7CBcX0HxI87qQxOUBgkJ6GPWp+usx3JzUWzWe
   5hMVUBSvHM+hTwXsfJHF2jPb9CxhXdS3iBG/6rEHBVD/9f+hPWUBISqS2
   26QDLgAWZUaN/pEzJQG8Tpk+GbXtjWlNcf9tBT2NvvMT9YBzTeskA7ba6
   mXr7z/DBD0tS00BDsX5h3AnUqwDUv0+tZITl7/L3+mtyRT/k414mxSI4c
   g==;
IronPort-SDR: 5MsI3m58xJC99fRk9R2d46dcERfMdkyMxr8UR/vrJAVNI9HCw0iDTRrCMyrTlAEY0yf2FqA8xn
 g2lRJaE13WrmqbsTHFDJ7XWqJvaKWHuUZRxqbTHP1OMtpq3gPxH7s13mrRYT3YZSP8eHCDJTMV
 1zwAqhPyQHDJCZwe4ozdjmDToKNJuvSsivHIkqb5SCVcw+0jO1JZ+TvG2TtEjYYyN0wzX+e+ut
 o/s4mqoSXYYO+Motetr65/WK/ZcpEgVf26NTvMbK7k9gWUrKatNT/15xRUEc/BvVgXHK5+Xams
 y9Y=
X-IronPort-AV: E=Sophos;i="5.75,275,1589266800"; 
   d="scan'208";a="84901749"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 24 Jun 2020 04:53:50 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 24 Jun
 2020 04:53:49 -0700
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Wed, 24 Jun
 2020 04:53:48 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V2 0/3] pm80xx : Updates for the driver version 0.1.39.
Date:   Wed, 24 Jun 2020 17:33:19 +0530
Message-ID: <20200624120322.6265-1-deepak.ukey@microchip.com>
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

Changes from V1:
	For "Support for get phy profile functionality."
		-Initalized the completion and removed the phy_prof_resp
		structure.
	For "Staggered spin up support."
		-Removed the lock_flags from pm8001_hba_info structure.
	For "Wait for PHY startup before draining libsas queue."
		-Moved the completion initalization in first patch.
		-Added module parameter to wait for phy startup.
		
Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

peter chang (1):
  pm80xx : Wait for PHY startup before draining libsas queue.

 drivers/scsi/pm8001/pm8001_ctl.c  |  36 ++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  20 +++
 drivers/scsi/pm8001/pm8001_defs.h |   9 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  77 +++++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  | 103 +++++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  22 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 253 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 9 files changed, 505 insertions(+), 31 deletions(-)

-- 
2.16.3

