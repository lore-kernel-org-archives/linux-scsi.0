Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 817F2C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Feb 2022 02:20:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239315AbiBNCUM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 13 Feb 2022 21:20:12 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239308AbiBNCUB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 13 Feb 2022 21:20:01 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4134954BF3
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1644805193; x=1676341193;
  h=from:to:subject:date:message-id:in-reply-to:references:
   mime-version:content-transfer-encoding;
  bh=zGX4y/uzAyw7+WbJOHkm4YfSHUmwMGfVLw4Pra+fZ9Q=;
  b=FlLHr0pFo09kUz1k2ZTrwodnaSFwD6KAv9gXH2TJOmqc3epNQK5Wjc1q
   7fQEzUVrL5bjJ7KfsKX/DyNmAtQoF1Kac70hc2G9nNIB0t1JG9FVZjuUS
   A4EmGpSFm0g8CEB9pNip+9QIwzbxaiyYUkn1YLrWOwxwGnJetUQ6bXD70
   NSlyVwUjtBQZQizp2DNNuYOM9LtRsC0oBsGGNeUVr435Y05vaEQxIgtAl
   /j/IogjF6+iZylETpwmU8jM82eRiAnfqYpBtsb37v4vLcKqIoqrb9zUjk
   16cz3Nz7cv3iwxJ1S27Ir/jkRKyPwojnnhS+ZtcPBHzUMqyYz9Tj3XEIN
   A==;
X-IronPort-AV: E=Sophos;i="5.88,366,1635177600"; 
   d="scan'208";a="192819792"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2022 10:19:53 +0800
IronPort-SDR: XXqzhkSiPGztZHUdebgCjnGxaj9RvOUnFK3nfNSf39DFxsQYSndnUnk6OGB2rmcigVJWowZX/m
 hXa5A3axak4gP9vLw4whw2diTXTcQoCHzPHcC5zlrA8ys567myytIBSHp/RnJTbcQIbrqYAoAG
 RERaHYe34kQ/8cMt8goW2bK+igye/oJ+HSwN615kB0zqBAAz2igzVfk8oRCPXZBC7CZzWQ3Hat
 2vG9Cffzwj9T2dkHrsPM8gAo+OJyMuCNU3vm6kAz4GQaATsfJs6VnkbS+5RmEFC+hbG+OQcTMO
 IxHdmB4Ieew84EjiPwrLcoY3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 17:52:46 -0800
IronPort-SDR: 8E1QdNOWU6XFdbJFavIGPJMEwE/v399FIxNuo9rPjNzkIcMx2bUnRWk1gNL9nWiU5y7xgKyWpf
 UtO0zupmRQ6yoePhTTMSVm4n3wm3dYEeDL0s8BgG/ASp07P7PRX2M3/vAo6Bzm0xHRjunX4eDk
 io6uLhKcth03i6D4PcpAEpLFpxoKzL6pcjQ3h/zo3A4i6ArIYAprZlbAwWXIxxw+wfiGbPPga0
 Qa3JL0DzF1C6HwzxLcxWwhmy11Fl1f3AJOHKwGnrz5ubBqKijF2khPga2Al/ynFkn7Ta3euWXH
 ZyM=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 13 Feb 2022 18:19:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jxnx663c4z1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 13 Feb 2022 18:19:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:mime-version
        :references:in-reply-to:x-mailer:message-id:date:subject:to
        :from; s=dkim; t=1644805194; x=1647397195; bh=zGX4y/uzAyw7+WbJOH
        km4YfSHUmwMGfVLw4Pra+fZ9Q=; b=ThOM/IWA5SNx4vfop/2nHVFj/dFXa+WThh
        sjRdJXhTTKhuEQ8+R3v5cMvIpq0WTaOJRzqB2lo2pXXPpu7oXmH1gDuik8mmNUvx
        ik7ms8DWZV7OoB1MFpCTMqIlbi9ncdRbffUG6wdTqOLffQpMWzYYQ2B24W8pAJLa
        OYJtVVC53kK8lSBYeOQlf3gnly8cH6bbx1vZ5wnkl4h45Njn4U017kV7+SE3AGl5
        4Sgnaa4e/2/qxyFioGziNUqo0DdGoINCeTzVCqjgeW8rDRktBAB7GQ2Z5v/pPBDt
        l0gkcoXc4YoTTKaAIFqSuJQUbA6QI3fQjMslAfk7TylIg0czWZ5w==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 7krUDkQF47US for <linux-scsi@vger.kernel.org>;
        Sun, 13 Feb 2022 18:19:54 -0800 (PST)
Received: from washi.fujisawa.hgst.com (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jxnx53Swcz1Rwrw;
        Sun, 13 Feb 2022 18:19:53 -0800 (PST)
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.garry@huawei.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        Jason Yan <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
Subject: [PATCH v3 19/31] scsi: pm8001: Fix pm8001_mpi_task_abort_resp()
Date:   Mon, 14 Feb 2022 11:17:35 +0900
Message-Id: <20220214021747.4976-20-damien.lemoal@opensource.wdc.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The call to pm8001_ccb_task_free() at the end of
pm8001_mpi_task_abort_resp() already frees the ccb tag. So when the
device NCQ_ABORT_ALL_FLAG is set, the tag should not be freed again.
Also change the hardcoded 0xBFFFFFFF value to ~NCQ_ABORT_ALL_FLAG as it
ought to be.

Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/pm8001/pm8001_hwi.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/pm8001/pm8001_hwi.c b/drivers/scsi/pm8001/pm800=
1_hwi.c
index e801d4b64d09..64a87c5bd66b 100644
--- a/drivers/scsi/pm8001/pm8001_hwi.c
+++ b/drivers/scsi/pm8001/pm8001_hwi.c
@@ -3717,12 +3717,11 @@ int pm8001_mpi_task_abort_resp(struct pm8001_hba_=
info *pm8001_ha, void *piomb)
 	mb();
=20
 	if (pm8001_dev->id & NCQ_ABORT_ALL_FLAG) {
-		pm8001_tag_free(pm8001_ha, tag);
 		sas_free_task(t);
-		/* clear the flag */
-		pm8001_dev->id &=3D 0xBFFFFFFF;
-	} else
+		pm8001_dev->id &=3D ~NCQ_ABORT_ALL_FLAG;
+	} else {
 		t->task_done(t);
+	}
=20
 	return 0;
 }
--=20
2.34.1

