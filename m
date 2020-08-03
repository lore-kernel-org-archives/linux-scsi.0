Return-Path: <SRS0=9rmj=BN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFF52C433DF
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:19:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 761ED204EC
	for <linux-scsi@archiver.kernel.org>; Mon,  3 Aug 2020 12:19:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="q6AIxbTj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726394AbgHCMTs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 Aug 2020 08:19:48 -0400
Received: from esa4.microchip.iphmx.com ([68.232.154.123]:9682 "EHLO
        esa4.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725933AbgHCMTo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2020 08:19:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596457183; x=1627993183;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=X/Rh1NWrG4/khTkdLk7t4ZcYRk15D5W3AWzzQpTI814=;
  b=q6AIxbTjTVdFhxoRnR4ti3uI8rEAvBnyCPwteBFiblNCemiq3WDiiZqQ
   iF2J9imf83nf5kip446CWS4YfgZfXgB/3guKQfeqrgRxDQwXPtekoxPDs
   NKwFlZXurPfame+opqQBkcyso1ARjKDc7mL9O6WOSJX02xNUHDsWWSGlq
   CBSfmFlA+VEKTcG2iVImH6wllZYazrorcUN5ZNa3YTujfyY5p8kxhd62E
   /FZhSjA9xutCUKHdZNs0ZXRGP3eHvZM1QZAnAIZvRwoOV1H5Z5+TtCQuR
   O56NF1l7Z2u1eRogCLaVEwvMSajjRXu1W9i1aq/865AHl8UuPmH/MWnvt
   A==;
IronPort-SDR: V2r8oX5iE8hnr6agykHMWCajNq0MJFaEffyli8RbQ+95lfaPIgm0Pp/fkhKli978Zpg3pP0EGU
 9zz0VzfpJJqMeeUevPmhNESH6yRLjFU6KhWX41m3G6JMURH8dP71KwOLisd1ptOc8C+ApBeykK
 CKl7PyD5ysyIp8VDMtWF6ZKzAuV6z6RLGaJxvRu0wyRdL3nYIMNOrOP6SFQQbSfSqiO8F/qXs4
 yD2MffAOQAZkzOvgd8Q4YD8IqFYvFRfDH72Lw0AIRFULOXBdc/IVN3R9R2gL/XKVPpftNAQ4VH
 NMU=
X-IronPort-AV: E=Sophos;i="5.75,430,1589266800"; 
   d="scan'208";a="82174989"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa4.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2020 05:19:43 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 3 Aug 2020
 05:19:42 -0700
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Mon, 3 Aug
 2020 05:19:42 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V5 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Mon, 3 Aug 2020 17:59:21 +0530
Message-ID: <20200803122923.6826-1-deepak.ukey@microchip.com>
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

Changes from V4:
	For "Support for get phy profile functionality."
		-Added support for big endian system for
		phy_status structure. 

Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

 drivers/scsi/pm8001/pm8001_ctl.h  |  33 ++++++
 drivers/scsi/pm8001/pm8001_defs.h |   3 +
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  55 +++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  36 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  18 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 213 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 8 files changed, 349 insertions(+), 25 deletions(-)

-- 
2.16.3

