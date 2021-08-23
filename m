Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8641EC4338F
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5DC2E6121E
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Aug 2021 07:28:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234976AbhHWH3R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Aug 2021 03:29:17 -0400
Received: from esa.microchip.iphmx.com ([68.232.153.233]:17842 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234861AbhHWH3Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2021 03:29:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1629703714; x=1661239714;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=rqwDQN8pNewMTLL9pWFYIShiN1Wfg6z4WLxP74E0RP0=;
  b=2EsPcs1awBiUb0ykiRZMj4VNpa3gKqBhKNVV4U9mGTvrFeWprsq/F771
   N9Rdg0IMTI/VUQ3nb1UDW5AbjmXvOWKu9rJvQMe2fBqGclbEZFIKzOE/z
   nApCibPZ/a1q2etge4j01CIZ/l2ixkq0SlFFY9P5I+kGO3lINnae4i+AK
   VyJXWRfmEuqfB6z3qWVetospZUMTCwA7lFPpVyrTLLs13HAHPgzP1aqGS
   3xiMI25EtAqVGc5AU5WUSJr4LyO+LqwxN6cPIABshQoAIYcqzuxxyGJFH
   CUauOn8J4WFqjMgv/OQfWcFAZDWK5EK7+qdJDUPv4T6B/0l5+LEOV1mNt
   Q==;
IronPort-SDR: 3HGkLZPBJqrrFAW7g11PJNk6h9tnuNN0UMLdpqfWc491n52jGGqmtcRXSUuXTNxCGY+WZK8VY4
 QyYm6MRskiWHvbgjl896HsbanJY6u+xOzH0vYzo0AxRSP9myFF+MY84XjatMVMzFzsqsAg+61D
 8mBXrmVr7X42/ysGRBsBdlsx7Ho71ZL5iOy8rraIaENFUmRxV1PvkzPpiq560OD8VRFPP/lfpA
 mf0wgitwgWy7lDR7XgBUTBjLXT/NKKuEpkty8D22sRVboZlCjMyMqgZQ6F9wuNxTGRngndlOYM
 WBQkpbVYyy04JMU5MjF9cnEu
X-IronPort-AV: E=Sophos;i="5.84,343,1620716400"; 
   d="scan'208";a="141156967"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa1.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 23 Aug 2021 00:28:33 -0700
Received: from chn-vm-ex04.mchp-main.com (10.10.85.152) by
 chn-vm-ex02.mchp-main.com (10.10.85.144) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.14; Mon, 23 Aug 2021 00:28:33 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex04.mchp-main.com
 (10.10.85.152) with Microsoft SMTP Server id 15.1.2176.14 via Frontend
 Transport; Mon, 23 Aug 2021 00:28:32 -0700
From:   Ajish Koshy <Ajish.Koshy@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <Ashokkumar.N@microchip.com>,
        Jinpu Wang <jinpu.wang@cloud.ionos.com>
Subject: [PATCH 0/4] pm80xx updates
Date:   Mon, 23 Aug 2021 13:53:34 +0530
Message-ID: <20210823082338.67309-1-Ajish.Koshy@microchip.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset includes bugfixes for pm80xx driver.

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

