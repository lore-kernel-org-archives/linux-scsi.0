Return-Path: <SRS0=aJuI=CT=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CE68C2BB84
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA7F5207DE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Sep 2020 07:40:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=wdc.com header.i=@wdc.com header.b="GdMF+t3R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729986AbgIJHkN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Sep 2020 03:40:13 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:55879 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729161AbgIJHj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Sep 2020 03:39:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1599723620; x=1631259620;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=bNxucSJQ2vsEA0ivn//Ho+7RyK9uaBltANYvYr0OAnM=;
  b=GdMF+t3RWUXqgoxO2uAj4LqUt/cRE0A4cKiD8qnvBuIMCJ8U9Thko6w7
   I0O/78IH1Ex+nPZM9MNjtIygVQZM6WEPl+i488i/MWOffO71MBAFRUYCo
   YJU9yk2d4oiy1A0fNVk1R4kJzwYG99hvNlH3ayubWZp2iTMvd6pL9yZog
   h4hZ7jkZnG/IAIgx/n0fj5YVM7OxjlaHy5RyOkmj3F80qnpS7j25j135q
   7bGUgN/QwKWPpaFMWPLz/4/qD6bfeGgc+drlt+WE9N2AuDJ6slff+1476
   koLGUrpWkjcmjh+ZD+3+c8cIMQs5URYx0ulswCeceAtlvZJMFZjYxQ+pR
   A==;
IronPort-SDR: rsKLbiL3Xt/EhJximl3DiRtC7V3ghNmxVEhwWOZJ0hmd3pz6HWLoFkj/B/snwShFFJOjQjHF2c
 8W02w3aSrvBhHUoB2uUiYz1O23/HsAxsuNU77u5Kbrruz/HibT9DB5n0B95QQZ9SXfWMwQAgK+
 CwInq8buHQPQW1k+18bhnWfyksfqmeHLQF8xC506c1DqeZQUlXZLkxOZQTDtcfdDe6l2u6xL1F
 vVf38imdUUAOhQKB5p03I/C3gqc/rHC/VBav+Uj3lqGk1oi6py5DjIwQ3QILSRPeqryOfAVH7O
 LX8=
X-IronPort-AV: E=Sophos;i="5.76,412,1592841600"; 
   d="scan'208";a="250308648"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Sep 2020 15:40:18 +0800
IronPort-SDR: MzOuoeJiXbR3gCwvDUb62sTfVbBIzMP3bmV0trqU3HB/D9J6saZcdv1FU56FCNU0Es+ac0VcU2
 4zqyOGAbNxxQ==
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Sep 2020 00:26:22 -0700
IronPort-SDR: yhhxweRy5zvO9e4ll1zBp+mWjoAl+ZvuLU4tNLOEcxWHXTAK6bFRi8U83STvw+cD+XVBj86AJP
 BkGn0/M/lxyQ==
WDCIronportException: Internal
Received: from washi.fujisawa.hgst.com ([10.149.53.254])
  by uls-op-cesaip02.wdc.com with ESMTP; 10 Sep 2020 00:39:58 -0700
From:   Damien Le Moal <damien.lemoal@wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 3/3] scsi: handle zone resources errors
Date:   Thu, 10 Sep 2020 16:39:52 +0900
Message-Id: <20200910073952.212130-4-damien.lemoal@wdc.com>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200910073952.212130-1-damien.lemoal@wdc.com>
References: <20200910073952.212130-1-damien.lemoal@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

ZBC or ZAC disks that have a limit on the number of open zones may fail
a zone open command or a write to a zone that is not already implicitly
or explicitly open if the total number of open zones is already at the
maximum allowed.

For these operations, instead of returning the generic BLK_STS_IOERR,
return BLK_STS_DEV_RESOURCE which is returned as -EBUSY to the I/O
issuer, allowing the device user to act appropriately on these
relatively benign zone resource errors.

With this change the NVMe (ZNS) and sd drivers both return the same
error code for zone resource errors, facilitating the implementation of
IO error handling by the user with a common code base for both device
types.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/scsi/scsi_lib.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 7c6dd6f75190..7eb4a80c3bbb 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -758,6 +758,18 @@ static void scsi_io_completion_action(struct scsi_cmnd *cmd, int result)
 			/* See SSC3rXX or current. */
 			action = ACTION_FAIL;
 			break;
+		case DATA_PROTECT:
+			sdev_printk(KERN_INFO, cmd->device,
+				    "asc/ascq = 0x%02x 0x%02x\n",
+				    sshdr.asc, sshdr.ascq);
+			action = ACTION_FAIL;
+			if ((sshdr.asc == 0x0C && sshdr.ascq == 0x12) ||
+			    (sshdr.asc == 0x55 &&
+			     (sshdr.ascq == 0x0E || sshdr.ascq == 0x0F))) {
+				/* Insufficient zone resources */
+				blk_stat = BLK_STS_DEV_RESOURCE;
+			}
+			break;
 		default:
 			action = ACTION_FAIL;
 			break;
-- 
2.26.2

