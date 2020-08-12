Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D6F9C433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 07:16:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7711620768
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 07:16:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="mpoN5IQs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726640AbgHLHQt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 03:16:49 -0400
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:20710 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726255AbgHLHQs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 03:16:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1597216608; x=1628752608;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=xMZTPN5/OceHHXWSyh+lvvsm0NfPAo0gPQVfXYRGXFA=;
  b=mpoN5IQsZ+htJUNLdhdNKOiDUfvxobRPVIaImUEABq6uIy1XNbJKniry
   LUYZY4Hex+1xqPvMiYDcT+M0E1Acz69reBQHkil0xS7FL+4k6o6QEZ/jA
   tZVgo3rapNeBGA2WqMgbT79IRAaDDYt8XjjroQuTna/g2hMgBMYMFUuYf
   iIayg9eHt+yaTHCCGpt/j9wZV4CqQfM6CgeynUfk3w8Si66THstL3FneT
   Yyt1Ohnj36ZntE2cyddPzWYSNr7pRPZhAGy7ZOYtoVpNz0ByOo79Nzbvf
   aWm/DHxSVkXPCxftrmnsWc7IM/9iy3NHJDwPw0uJ6pVYoU1w5YlLtupkI
   A==;
IronPort-SDR: SpTRHHyZ11VIYm2tOE535obpH103QjrfTjjw/3T8GdFqQxncRxTtMhscWyOH610+IB55A/hPp4
 346D5TsB3HXVYng8BA5IayHO/brC5DLvwXrxUVf08i4RD81WaqkJXnszas+48YI64CcKNK40Rc
 VKYYhjath17KlpqEnDVCV34zPnt+yuTmEcTdwn45dUsAbz0vnMIsUbBz+hE/cHgP0U2vawijo7
 iSKw/iD+ciZOr5j/Qnw5i46Xau6LU+dS7EffuH78Bysm+Tn/qMwTctNT/P/vJgK+zgbY1naTAZ
 gIc=
X-IronPort-AV: E=Sophos;i="5.76,303,1592895600"; 
   d="scan'208";a="86856752"
Received: from unknown (HELO smtp.microsemi.com) ([208.19.100.23])
  by esa5.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 12 Aug 2020 00:16:48 -0700
Received: from AVMBX3.microsemi.net (10.100.34.33) by AVMBX3.microsemi.net
 (10.100.34.33) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1979.3; Wed, 12 Aug
 2020 00:16:46 -0700
Received: from localhost (10.41.130.51) by avmbx3.microsemi.net (10.100.34.33)
 with Microsoft SMTP Server id 15.1.1979.3 via Frontend Transport; Wed, 12 Aug
 2020 00:16:46 -0700
From:   Deepak Ukey <deepak.ukey@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <deepak.ukey@microchip.com>,
        <jinpu.wang@profitbricks.com>, <martin.petersen@oracle.com>,
        <yuuzheng@google.com>, <auradkar@google.com>,
        <vishakhavc@google.com>, <bjashnani@google.com>,
        <radha@google.com>, <akshatzen@google.com>
Subject: [PATCH V7 0/2] pm80xx : Updates for the driver version 0.1.39.
Date:   Wed, 12 Aug 2020 12:56:26 +0530
Message-ID: <20200812072628.6339-1-deepak.ukey@microchip.com>
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

Changes from V6:
	For "Staggered spin up support."
		-Changed DECLARE_COMPLETION to DECLARE_COMPLETION_ONSTACK
		in pm8001_scan_start function.

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

