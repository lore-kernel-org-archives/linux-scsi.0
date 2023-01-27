Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7490EC61DA3
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Jan 2023 06:35:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231776AbjA0GfL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 01:35:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbjA0GfJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 01:35:09 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F17F53A85C
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2023 22:35:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674801307; x=1706337307;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6z5ctcjnBNrXYoTY5bxKJZMMqRISGbPVFI9tVKD/VVQ=;
  b=jxCN0cuJTBT8UdncRjQmEHETAwohm/T1p1Z3zPd/O9Oui7IMYbzMkPDu
   PBKjrUvd0FQ54v3S+CsWx/OLbsiB2NqFR9KmY8lWReoePWoHDmf1atTUr
   UMGZCNTiD0zbGYIQqzNcIMl++y20tnPHrvgpKSAEOiW7EwBkDcBxoYp7u
   2PcXLI7SHf3GB3lF87kle6nDQF1Omze1166BlhOle6dYqzZUWLemigkiu
   kcR4VlfThYkiXaAq2BLMoV1uS1aUI6Hn6LHZgrEK69fLwi8F0CeQDLJlx
   tgE07f8JWuoOv3ZzEjJG9cASuaL/l7SGElzoVBoTSKtzKwdiOQi1zSQJ/
   g==;
X-IronPort-AV: E=Sophos;i="5.97,250,1669046400"; 
   d="scan'208";a="221935002"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Jan 2023 14:35:07 +0800
IronPort-SDR: wKG2AGfOM5QZNjWBLsssGAjQ3BUqadWx8Tfcp+X+Iw8PHiN4k6Qy8GBFNFBolAxFpUaf6HDSoG
 yqh1z2lYlYl0oAcFs4Lma8dJPX+fEarR/2AdGUr+kWoGLZltCJpBxD/+CiWBWTjMzNBYkGKBoh
 A0B2/0RYbq046em4UetVFqknDYO00pNmOOF51QQSPlZQZwHZWuEImg/9o3AqB0mP08fqnPNvOz
 K4XEzObXMSgC3VoWFxw87ztui1lK1RyHv97ndFffAncsajOnhEuMh4J8h98Z6OYljjuPsDHaxJ
 c3s=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Jan 2023 21:46:52 -0800
IronPort-SDR: a3dmu5K/0R1deAXWtWZEJZ4Be8lCG/mrH1nGC05RODRvGM9OHT7GWHyW2mjmJyKzmJMw5Km4cW
 /7sJciz9U4iXpbOZ2kFTi+lO9f3mTqiJG6huMXSjM8LlfKz/7lBEeZ9trHxHrim7/MYIcbk/cu
 NpdjqZrjixR8DURAzh4b0eK2k/CQ5kT1L5sZgzV5QCXZN4RD3ONuvuFeT9MOwEqAX0pgrGXyap
 //SzYVpcr/pSzQQU4+xT4x3hzm8IkjdEhoL/O3GC4zFoWyHvzorTunKwfraSi4jt/JwRPsBKCG
 sNo=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip01.wdc.com with ESMTP; 26 Jan 2023 22:35:06 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v4 3/5] scsi: mpi3mr: remove unnecessary memcpy
Date:   Fri, 27 Jan 2023 15:34:58 +0900
Message-Id: <20230127063500.1278068-4-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
References: <20230127063500.1278068-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the function mpi3mr_get_all_tgt_info, devmap_info points to
alltgt_info->dmi then there is no need to memcpy data from devmap_info
to alltgt_info->dmi. Remove the unnecessary memcpy. This also allows to
remove the local variable 'rval' and the goto label 'out'.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 7fb9505723cf..3b4ae044f4c0 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -293,7 +293,6 @@ static long mpi3mr_bsg_pel_enable(struct mpi3mr_ioc *mrioc,
 static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	struct bsg_job *job)
 {
-	long rval = -EINVAL;
 	u16 num_devices = 0, i = 0, size;
 	unsigned long flags;
 	struct mpi3mr_tgt_dev *tgtdev;
@@ -304,7 +303,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	if (job->request_payload.payload_len < sizeof(u32)) {
 		dprint_bsg_err(mrioc, "%s: invalid size argument\n",
 		    __func__);
-		return rval;
+		return -EINVAL;
 	}
 
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
@@ -350,20 +349,12 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		/ sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
-	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
-		dprint_bsg_err(mrioc, "%s:%d: device map info copy failed\n",
-		    __func__, __LINE__);
-		rval = -EFAULT;
-		goto out;
-	}
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
 			    alltgt_info, sizeof(*alltgt_info) + min_entrylen);
-	rval = 0;
-out:
 	kfree(alltgt_info);
-	return rval;
+	return 0;
 }
 /**
  * mpi3mr_get_change_count - Get topology change count
-- 
2.38.1

