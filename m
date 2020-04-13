Return-Path: <SRS0=9ymf=55=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8178BC2BA19
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 09:40:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 54ECA2073E
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Apr 2020 09:40:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="maaLNqet"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728418AbgDMJkU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Apr 2020 05:40:20 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:60650 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728138AbgDMJkT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2020 05:40:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1586770820; x=1618306820;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=6z7ZtJ8SrUeQXRcjWC+ap3OqVBnVDcWbrXqm0qHsltQ=;
  b=maaLNqetCCb/RZuywfn8jzHjkx8Mdq0pqs4f4ihFE87JyCIhk/qq93E8
   tsc4hXd31kXQOFKB5UBpxSpoc6tBb1hge254GKubxUz91Ic06SQOd9x4f
   RYRZhv2gsOUHBPpZH9xh+IZO3JuP9fAvzUBbrrUrfOCRuL88wlZHdAYXW
   +QRgtS6AA8KaGrJEz5tuTYEuhyMaCk9vm55Uvi0ia+LmgPyJGGVFweNU+
   J2PzjiOoHDZ9zpysPFOjmTlBzJDsj/9n99qXVNCRtAyh1k+0TUdwlLJbx
   YOf8vxfUXukthGu9h/bKz+K3No+2zlAygnTs3djkjQ0NPEnkbvYJIfCWU
   Q==;
IronPort-SDR: PDayw4jJOY3/hkQq2GO4Ao6wzMHyt7d0RIGNUoOr08j4kcOVjmay798FhnsR/Gg450scRY3rbP
 8VQOAnNMGaFRnV6GdvoEVXkOeCkeQRw9z4gNHMIkUK2sBfQ3wwpq6PMivBORjtOEl3+q5pj0KJ
 njHPJmX/1UcBc1T1bWWvGaEoWsUl3zQylTM+AF0EAaIB4eLwMwsZjyeXDHtxgn2ABOsFXimEgD
 NjMscIhAwolt0KrNb/TEfYIYbSclzoldT/YlJSdT3V8TthhF6pE8cuMgJdxfCOZTN1K44nJKfq
 +Mg=
X-IronPort-AV: E=Sophos;i="5.72,378,1580799600"; 
   d="scan'208";a="72253067"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 13 Apr 2020 02:40:19 -0700
Received: from AVMBX1.microsemi.net (10.100.34.31) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Mon, 13 Apr
 2020 02:40:18 -0700
Received: from localhost (10.41.130.51) by avmbx1.microsemi.net (10.100.34.31)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Mon, 13 Apr
 2020 02:40:17 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <dpf@google.com>, <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH 0/3] pm80xx : Updates for the driver version 0.1.39.
Date:   Mon, 13 Apr 2020 15:19:35 +0530
Message-ID: <20200413094938.6182-1-deepak.ukey@microchip.com>
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

Viswas G (2):
  pm80xx : Support for get phy profile functionality.
  pm80xx : Staggered spin up support.

peter chang (1):
  pm80xx : Wait for PHY startup before draining libsas queue.

 drivers/scsi/pm8001/pm8001_ctl.c  |  36 ++++++
 drivers/scsi/pm8001/pm8001_ctl.h  |  27 ++++
 drivers/scsi/pm8001/pm8001_defs.h |   9 +-
 drivers/scsi/pm8001/pm8001_hwi.c  |  14 ++-
 drivers/scsi/pm8001/pm8001_init.c |  79 +++++++++++-
 drivers/scsi/pm8001/pm8001_sas.c  |  99 ++++++++++++++-
 drivers/scsi/pm8001/pm8001_sas.h  |  22 ++++
 drivers/scsi/pm8001/pm80xx_hwi.c  | 252 +++++++++++++++++++++++++++++++++++---
 drivers/scsi/pm8001/pm80xx_hwi.h  |   2 +
 9 files changed, 509 insertions(+), 31 deletions(-)

-- 
2.16.3

