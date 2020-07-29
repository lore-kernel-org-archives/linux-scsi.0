Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 849BBC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 12:41:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F4BC2083E
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 12:41:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="ddzBKBj8"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726476AbgG2MlN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 08:41:13 -0400
Received: from esa3.microchip.iphmx.com ([68.232.153.233]:39713 "EHLO
        esa3.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726353AbgG2MlM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 08:41:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596026471; x=1627562471;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=eMWCRHMM/mET4VW/a1WH79C7b/mLYXL1d1p0jeGXabI=;
  b=ddzBKBj8E3eMh6QY5mdrGEVyCGGl1MwYqiJeQ95sjZ91YIT4qax2EB7A
   1gHl3o0AzYbLkVCFT5IlP7zyIyHPt63JeYQ3KtUvXTQKNFBxCvGwBiRNa
   A+jTA7+WHiVdzzYCyAoNjsKY9Yu9br5lY6q7iW70JobVprL+TZ6OeObep
   nNxUHmPLYwvsXQx3M/yKgMheDF6bXMc8xzeK9COyAu8DA91kHFhD0AHRy
   vQNypEbh3YMY9gipgQpRJTx9H0bMdXJ7l5pb/Du3KPlKMB6pcVLavYYRO
   hNbS3U2jCaOnXtkSaSAZPq5snV5q6KlDFCIz+ocSMOctYqAv5Kp38muN8
   g==;
IronPort-SDR: Mxe19+MdW9ly4S05t51+fk9PJqpITrA5aTg89WLK8hKLqJH3K7ZZqrbrPjqv5mjYJ/rxZkeJpZ
 2Y/IOIuTE8M7t0/JxFl0e71ZQYrExONvLQYiLHWgdQZL92g4C5VwGMd81TVlz1iglsVf8TgIV0
 xXFaDEVz6eBI2k2qNt0RYc7KQ7IqQxkNM300JtbM+kn8UHy8BMffE27UnbKxI6t7CJTD7WISpP
 J53/VRGKX9Gq5A6AdZURPXgGaGg8GYtzK5bw3Iiya35JYj1WbHS5OhEFBuwSaj7LfgwOnOFPGQ
 HFA=
X-IronPort-AV: E=Sophos;i="5.75,410,1589266800"; 
   d="scan'208";a="85810034"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 29 Jul 2020 05:41:11 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 29 Jul
 2020 05:41:10 -0700
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Wed, 29 Jul
 2020 05:41:10 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V4 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Wed, 29 Jul 2020 18:20:48 +0530
Message-ID: <20200729125050.5821-1-deepak.ukey@microchip.com>
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

Changes from V3:
	For "Support for get phy profile functionality."
		-Added fix for sparse warning reported by kerenl test
		robot.

Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

 drivers/scsi/pm8001/pm8001_ctl.h  |  20 ++++
 drivers/scsi/pm8001/pm8001_defs.h |   3 +
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  55 +++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  36 ++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  18 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 213 ++++++++++++++++++++++++++++++++++----
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 8 files changed, 336 insertions(+), 25 deletions(-)

-- 
2.16.3

