Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B003C4338F
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:01:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 801B360F9E
	for <linux-scsi@archiver.kernel.org>; Sun,  8 Aug 2021 09:01:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhHHJBl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 8 Aug 2021 05:01:41 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:59571 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231130AbhHHJBk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 8 Aug 2021 05:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1628413281; x=1659949281;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references;
  bh=bjgGRXxjJDNLHzEfzuNKdyk/I6//YiMoxvenotPsMHA=;
  b=chq0CCd2+dy8PTMMG+WrxC6g+2ATXbOd78f3EsUlCKeFdlc4t63uGXZW
   lsVgPljKp9tdxnZYVxh7pjEgX6+xvyuSSldLE0lRcKFF3Z56npu6FWi+m
   1JkPE4f9GHtAN22X4BNJk67awgzA3oioYApobmbpIhWMfFROWtXWEQmlC
   1M8eXyGODR4tZyGtMAUetwCf7KxFhF5RCB07x8FbrQwF/zIZcyF8NV4gF
   55FQUqDvjld0LcisakJNa7joIYF5pMsj+e6eeQeXofOdDTR75YtJv2bg6
   5FCot8nmCq8BR9FVjyM6lX4Nb7u0ukLOaWTKmTcH23OTFvqjFugFB3q5m
   A==;
X-IronPort-AV: E=Sophos;i="5.84,305,1620662400"; 
   d="scan'208";a="280449782"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Aug 2021 17:01:21 +0800
IronPort-SDR: fJaxbcIW++bYCTtmNWhuc3GRBvQE4JfjebWgsmJKzsSxIRwgVeOgPmrnpWS8XD2XeGsw8oGSep
 uVg/QLPX2e0ULpeGMbYF3ymPgVxv557bb2sWPIoSsSqsBl0lc7330kGjuIIlFkSxUWx1yBx8ww
 cfIKgMbYGBQK7hWzx+ZhiGytuW2HsNkp4dyB+o3hA4UZQiICnuEGBT7HlMrlA+crssB/8QX/tA
 ONjkKClXBawQtRK8Vor9uMPa+DDGrVuymehtAsys5kI3tKJ6zcqJWNDdZ3n4SnC4P6EwiC2gko
 Yp0FKtNjhBuiZey7swp5PHD7
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Aug 2021 01:36:56 -0700
IronPort-SDR: lPE7UCqk6qeiVobRoFkeWH+ksh8W4hROFo5RGGkKM71ycIe8DqVLg//RTI76zsRLo2co6DlP3t
 q8MLY3qUtbN7prth2t08xKQmGPpEhp0z33jEjoVILevtBzNxbnvglZwQZcpKKIVIdSVlfJ3ffT
 dqiB2BLmjTjxO976EEK94ipktntTVLoXMlEWO+sWsGTln1lF+Bzs6ik69cfj4L7jUIopJiAy2B
 9mJfktIjNB/xDswzDRDXbB66qYsz8ReDBd38r/KQoSwa4HhE2y3ltMbKOWr7ptjAWobPg8StT4
 wJE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com (HELO BXYGM33.ad.shared) ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 08 Aug 2021 02:01:19 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        Daejun Park <daejun7.park@samsung.com>,
        Avri Altman <avri.altman@wdc.com>
Subject: [PATCH 4/4] scsi: ufshpb: Do not report victim error in HCM
Date:   Sun,  8 Aug 2021 12:00:24 +0300
Message-Id: <20210808090024.21721-5-avri.altman@wdc.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210808090024.21721-1-avri.altman@wdc.com>
References: <20210808090024.21721-1-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In host control mode, eviction is perceived as an extreme measure.
There are several conditions that both the entering and exiting regions
should meet, so that eviction will take place.

The common case however, is that those conditions are rarely met, so it
is normal that the act of eviction fails.  Therefore, Do not report an
error in host control mode if eviction fails.

Fixes: 6c59cb501b86 (scsi: ufs: ufshpb: Make eviction depend on region's reads)
Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index cd48367f94cc..aafb55136c7e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -1385,7 +1385,8 @@ static int ufshpb_add_region(struct ufshpb_lu *hpb, struct ufshpb_region *rgn)
 			victim_rgn = ufshpb_victim_lru_info(hpb);
 			if (!victim_rgn) {
 				dev_warn(&hpb->sdev_ufs_lu->sdev_dev,
-				    "cannot get victim region error\n");
+				    "cannot get victim region %s\n",
+				    hpb->is_hcm ? "" : "error");
 				ret = -ENOMEM;
 				goto out;
 			}
-- 
2.17.1

