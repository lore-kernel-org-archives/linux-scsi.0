Return-Path: <SRS0=RSbu=B6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E85ADC433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:42:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA545206DA
	for <linux-scsi@archiver.kernel.org>; Thu, 20 Aug 2020 18:42:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgHTSmC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 20 Aug 2020 14:42:02 -0400
Received: from esa6.microchip.iphmx.com ([216.71.154.253]:44427 "EHLO
        esa6.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgHTSmC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 20 Aug 2020 14:42:02 -0400
IronPort-SDR: f+OqvZMHvGCnxkBFYLJN6nt/8uDDrx+Ds0bv2eC3u4fu2yKw4RZHeQY5vlpJbGvuyOOrhQLq8a
 1Dblsogp8F7iHgod58TwUqEw3SXuaZy/q1EOTJtht+9YE7RR89wtIJERciGZq2zIyS8ep2+FA5
 E2KgVcgehMYswefw1AnkoZN3iYDuFoBz9bjZshhfGAzcYOz/HKUjOUS9WZfrHcIBr+2aZv1u/w
 RTNmsTrHR9NEmhaFDjl2vxk0USaZnFmyyO6a6e0Ji+dHqg3X5lzU3zTP8UjYU7dfLbxsRWjIJ+
 l0A=
X-IronPort-AV: E=Sophos;i="5.76,334,1592895600"; 
   d="scan'208";a="23684695"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.21])
  by esa6.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 20 Aug 2020 11:41:42 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX1.microsemi.net
 (10.100.34.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Thu, 20 Aug
 2020 11:41:42 -0700
Received: from bby1unixsmtp01.microsemi.net (10.180.100.98) by
 avmbx2.microsemi.net (10.100.34.32) with Microsoft SMTP Server id 15.1.1979.3
 via Frontend Transport; Thu, 20 Aug 2020 11:41:42 -0700
Received: from localhost (bby1unixlb02.microsemi.net [10.180.100.121])
        by bby1unixsmtp01.microsemi.net (Postfix) with ESMTP id F0F5DA09C6;
        Thu, 20 Aug 2020 11:41:41 -0700 (PDT)
From:   Viswas G <Viswas.G@microchip.com.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <martin.petersen@oracle.com>, <yuuzheng@google.com>,
        <auradkar@google.com>, <vishakhavc@google.com>,
        <bjashnani@google.com>, <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH v8 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Fri, 21 Aug 2020 00:21:21 +0530
Message-ID: <20200820185123.27354-1-Viswas.G@microchip.com.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Viswas G <Viswas.G@microchip.com>

This patch set includes some bug fixes and features for pm80xx driver.

Changes from v7:
	For "Staggered spin up support"
		- Fixed "reference preceded by free" reported by coccinelle.  

Changes from v6:
	For "Staggered spin up support."
		-Changed DECLARE_COMPLETION to DECLARE_COMPLETION_ONSTACK
		in pm8001_scan_start function.

Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

 drivers/scsi/pm8001/pm8001_ctl.h  |  33 ++++++
 drivers/scsi/pm8001/pm8001_defs.h |   3 +
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  58 ++++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  36 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  18 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 210 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 8 files changed, 348 insertions(+), 26 deletions(-)

-- 
2.16.3

