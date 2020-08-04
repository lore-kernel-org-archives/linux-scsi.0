Return-Path: <SRS0=m56l=BO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6A27C433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 04:46:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A3681206F6
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Aug 2020 04:46:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="SXd+7aq+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729764AbgHDEqt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Aug 2020 00:46:49 -0400
Received: from esa2.microchip.iphmx.com ([68.232.149.84]:55158 "EHLO
        esa2.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726000AbgHDEqt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2020 00:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1596516408; x=1628052408;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=FUZApadCIEE1YFC8uoB+0bE4Y9BS4jgrPX4sYKb5RVM=;
  b=SXd+7aq+zo62Rv17Vhchjoc82M7LtxmPJuDl544OlcSMIoKiYij5376Y
   YgEMqQs9pQt1lAiyLOKiqGMwd2An2XHpDSkNk1qociFaIWsBFQ342aKP8
   OA5bo09/Tpa+6gWQt75bC8IN5UE5P2E19INxk4W8iEL5/R7YHDdYZHzAl
   pe3e2TjXikZAYlDe26ZemjNAgYxDXjJj+MIn24oF85RZ9ZdPvn5VAILir
   quT2nnv7rFe/uaJDnSDzPSIhVOTzQoatq8/1hCxsCtMuCwKPIIHFSW5WN
   pWTkCYS/P9X+K0oq/NqcEaiJQryAggzED2auAHwRnd0wwdFq1M8BXpOqX
   A==;
IronPort-SDR: Fn3FPRnZF5anWAsckLBsP7A++RrSsLgo4F68+N4tZoi/EKsMYczGvwJ7mytLzpxuUvW7YadpBx
 EtjtSHTs4ixWxgJZ59HlDgfeRWbXREpszT4oJdTgxdGKPNwEg5w397evvBLwRFtBAfcWOuPqld
 1GIRkCQ54tkEXoM3craGxbQ4Wtu7i9wSVQWZLHTSBbKz8o5mBH3z98EDTaRTbkcFAHvUFYgXnv
 ClijPlmMAD4c6aUpjCKdo7igBSZu8FPZfCVVn0sEoHrMZX6FYwV3xzKfZYQf2cgn3G/x5g+SxG
 Bwc=
X-IronPort-AV: E=Sophos;i="5.75,432,1589266800"; 
   d="scan'208";a="84321344"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa2.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 03 Aug 2020 21:46:48 -0700
Received: from AVMBX2.microsemi.net (10.100.34.32) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 3 Aug 2020
 21:46:47 -0700
Received: from localhost (10.41.130.51) by avmbx2.microsemi.net (10.100.34.32)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Mon, 3 Aug
 2020 21:46:46 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V6 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Tue, 4 Aug 2020 10:26:26 +0530
Message-ID: <20200804045628.6590-1-deepak.ukey@microchip.com>
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

Changes from V5:
	For "Support for get phy profile functionality."
		-Added fix for xtensa warning reported by kerenl test
		robot.
		-Corrected the phy_status structure parameter. 

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

