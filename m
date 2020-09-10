Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 69291C43461
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BF3720795
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SdrlS8Iy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729935AbgIJHkA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:40:00 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55879 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726746AbgIJHj4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:39:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599723615; x=1631259615;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=3wQ0heKI57j9U4ObElDH9ftAczBfvM624U9466KVJzo=;
  b=SdrlS8Iyow3AdgXQOEpeHl8QOfzgSmq2GU/ieKpXNFc3751AqmrdsMmb
   lIEK74CSoIOrjo3pRytr7PBnRH2PJ7Z48va+WVy0Nh3Kl8gU7E1JMznfL
   huytXlZJDvPA4HMrPn9avIlhq+Y+ic1SJYJtaCQN8ew2lHCca3jmdIIAf
   IMxKd7VoODw2UX/lh4Rj640mdpd6ZYhgkLDBUPPwZj5WKM36KbZt4fitL
   pY+NAXiEhiIEpJbdC5SRDFgvpczsrAdwkbATYNts1nq3x/FEkedWuhZLF
   dFDK8xlYsiChQI7gm+P+gotydRFKn8enElcNJtm7GH9QvU9mnsMFzSQJp
   w==;
IronPort-SDR: V84fSW28X7fbqbqNw8XcTst8JEcnVZ2G72e8D+RplIJNadXGq+2xS/a0l5QTLW56BrOXymn28Y
 pUlxsoIC0eQkToEJy01XN7CbFHyXD114N36IJLW/1cQiPTROxcvuiqs9GwZyvsm+XL0hWEkmS0
 ecw5VkBJlvEwQHe+lmJI9XuxTFZu+q5wldqi++gB3MLRIbxIxwliIymXaw7a4loOf08iIOn6Bf
 INDDSpL+ZoUS7LJcYyWiJMMB/+9WBuv3tRGkOl/CrmPHuczaNkISWMVvZo2CRgVF+Nlhc059yf
 EFg=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="250308635"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:40:15 +0800
IronPort-SDR: WIofeZgQxCGs+9ooRx1Gb7U/OX4qnB/9B5hDcJhtqC4zkW3sXHTiJE8mZAGxEYzmvWmMX72cyo
 ORCdoCGTMR4Q==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:26:19 -0700
IronPort-SDR: czZ5UU1+2IqEJa97A0TdVCd6HF2kBCE85i/s57+GCx6KY+X4v0ip9ObICFUoiQdyvd+WCuaNAA
 Wk2nI7RC/dKg==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Sep 2020 00:39:55 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 0/3] Improve error handling
Date:   Thu, 10 Sep 2020 16:39:49 +0900
Message-Id: <20200910073952.212130-1-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

A small series to improve command error hadling.

The first patch is a simple code cleanup. The second patch updates
asc/ascq sense codes list. Finally, the third patch adds zone resource
errors handling for zoned block deives to return BLK_STS_DEV_RESOURCE,
similarly to what the NVMe driver does for ZNS devices.

Damien Le Moal (3):
  scsi: Cleanup scsi_noretry_cmd()
  scsi: update additional sense codes list
  scsi: handle zone resources errors

 drivers/scsi/scsi_error.c  |  4 +--
 drivers/scsi/scsi_lib.c    | 12 +++++++++
 drivers/scsi/sense_codes.h | 54 +++++++++++++++++++++++++++++++++++++-
 3 files changed, 67 insertions(+), 3 deletions(-)

-- 
2.26.2

