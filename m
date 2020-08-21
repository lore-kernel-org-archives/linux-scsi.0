Return-Path: <SRS0=brni=B7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4A636C433E1
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 13:00:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 281BB207DE
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Aug 2020 13:00:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="SKFzwkSj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728471AbgHUNA2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Aug 2020 09:00:28 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:55563 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727888AbgHUNAZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2020 09:00:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1598014824; x=1629550824;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=WAKxIe2g/DU6K/n6Phi6bqK/kf/xMjB7uoOuFEtpdwc=;
  b=SKFzwkSjBLIIrcyf0ilRgMw8nlJauOJ5kCO5IsKIkyXPCQtJDcLQXjAt
   AikUMO19AOJafQHF2WFUv+djXQArhaUkb2IK2Ai6LZnm68Y5O1ju38xJM
   NXjajp9qGac9QDY7ulHzYBk0hv+IiCO2vmYQB0Oz1nFcnjNycdO0xf2al
   0v0BtNtnAYCcdPicfBXuHNUHq8lv3XmsZG4NUQKau90p7w/VczRavUqX6
   EvGShJQqwki5wRkuhMUjGs76Nsp2+3HwJqHo3fWthuKFwPhD1gNEyOHjo
   qowKLYz7Y8Kdnx1v+BY6PgU9ONRaEE6BOZc/24BF9+K0qhYTVmx/QsOcP
   A==;
IronPort-SDR: O52R0U1qsEFlfYvXHCenq2O+0JuBwz3YvGpy+VNSpdibe6ICpuwviEJlv5DJLeqd759KjRZnv7
 Ebaq7hN/uhVaLHXwtING03sk1KgTnXedWLihkLYBCEW1u+eB8IaGy1HRNLvqm7Aqb+BWAuK4Dd
 YzlUmKUQVUnUKX/69McBL4OSGMVms/T2YP8OK+jcCSl5GYYZiflgSzRqn5LJ7gnn+BfDFP7kw2
 9ZOMpgWV9KEO6DaDss7z3gXLC6iK1unlWwBu8ML7ShjOjkukYlt3iKx83z0EnE+DzAX5vEJs0X
 lHo=
X-IronPort-AV: E=Sophos;i="5.76,335,1592841600"; 
   d="scan'208";a="145461417"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 21 Aug 2020 21:00:23 +0800
IronPort-SDR: 7WixDaGDzpfa78Ke3EHsM+4qK+SlPPAxglK5+7k9dGnk7oYc9/9DP+3oCdWAms84WtsGvq16Am
 J3qRnNBDnYHQ==
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Aug 2020 05:47:18 -0700
IronPort-SDR: L04YRptmobvqN3BJpLyZuEMHO7kdcUXvLY1EnJxpGGhe22GxcBylNoEuION7kZTo1e4PHitCRM
 TEtuoSSA5zGA==
WDCIronportException: Internal
Received: from 8fr9cg2.ad.shared (HELO localhost.hgst.com) ([10.86.59.94])
  by uls-op-cesaip01.wdc.com with ESMTP; 21 Aug 2020 06:00:21 -0700
From:   Niklas Cassel <niklas.cassel@wdc.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     damien.lemoal@wdc.com, Niklas Cassel <niklas.cassel@wdc.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] scsi: scsi_debug: Remove superfluous close zone in resp_open_zone()
Date:   Fri, 21 Aug 2020 15:00:07 +0200
Message-Id: <20200821130007.39938-1-niklas.cassel@wdc.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

resp_open_zone() always calls zbc_open_zone() with parameter explicit
set to true.

If zbc_open_zone() is called with parameter explicit set to true, and
the current zone state is implicit open, it will call zbc_close_zone()
on the zone before proceeding.

Therefore, there is no need for resp_open_zone() to call zbc_close_zone()
on an implicitly open zone before calling zbc_open_zone().

Remove superfluous close zone in resp_open_zone().

Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
---
 drivers/scsi/scsi_debug.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
index 064ed680c0530..912d6f4878bae 100644
--- a/drivers/scsi/scsi_debug.c
+++ b/drivers/scsi/scsi_debug.c
@@ -4482,8 +4482,6 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
 		goto fini;
 	}
 
-	if (zc == ZC2_IMPLICIT_OPEN)
-		zbc_close_zone(devip, zsp);
 	zbc_open_zone(devip, zsp, true);
 fini:
 	write_unlock(macc_lckp);
-- 
2.26.2

