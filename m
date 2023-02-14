Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B775FC636CC
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:50:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229828AbjBNAu2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:50:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjBNAuZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:50:25 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3D1CC163
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676335824; x=1707871824;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DtUu3s39PRk5T5kcI3t0LAOlSLAzhZQjKGt47QW7SOE=;
  b=mc5GcXsDOXl/KYcsZluXUcwbsfOTwtO4oo4S5IN8rPMKYuFF2ULaaFR9
   9jc9i/Ty5VYLP5MjCns36fH1uk5GeEmVgtHZ2FRmvNEujl5LDhUoqIiZ7
   wazW0fpKK3EW52eJ5nkBQEESIVRnKr+oqsdihNYw6whUWSxjF1elVPoma
   4de9HSYtELQYDsjPxIstv9HCOvifu+X70GBx83KHv1eS7L306d6gCRma8
   3u9a9eCRY8AmVu29oGYBrOSLmJG5cgk+NbumQ8IBJq3cuPFKcAlxt0CS3
   W0z7l7L9XA9uPlRV/HbxW2go3ntVnt28GXku4O/JPHr3hBsj093rpH3ST
   w==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="228193158"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:50:24 +0800
IronPort-SDR: owMKlsZ1d72BWWPVcyxA0vzuN0zQo4CeCAXeouNVSaL9bASJGQUOEcup3iNhNsM842cPfIVQBD
 FAAV5Uv0ntZMQz8anO3RgdIFkqdys7rmMKU6A21OMLMC+HpmFXeL9w6FJkXFtiZPqIbGgBsZAy
 2CYzc8pUc19xQaBokG6RpIgU5Bh+y4Ecp/Gn+2H2hYeyRNAb4ekE/9WPqSAG2qeoJiwFvDSuIq
 B1ML2b7KwvKdw8+66K+ejeUB6sPW4+bwevNykZjnhKUKgFBdbfNKMyNo0JwGzlyP0qfT13JgHp
 Pgw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 16:07:33 -0800
IronPort-SDR: X0oc02ICFwXbaSz8PlbPZDN1z+upYwc+cI9GX9qqtYy0CqBOaUrg9eBmxllt6HZRLUAiPZuXpW
 8uRgBow6v+GPHDSK0Ltn7Ex20F0UqYXtur7awIDl0tl8NJ7CeaUjhKqzRoqVd1ULDCUstzvz5e
 7BgMdRzOobg823+xlSngsWHxQyBWHK0zmF/22RF0qxMZTEat/wcXIu8wJoGPl0PF7o3CKHD4O0
 b4qK8zozIOIO1AyvPk4iMOm4pBNtXymdNcLS/eSfDTfMo+hJNUHIJPQwyUHjFWeGnLDXb/BR19
 1Tk=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2023 16:50:23 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 2/4] scsi: mpi3mr: remove unnecessary memcpy to alltgt_info->dmi
Date:   Tue, 14 Feb 2023 09:50:17 +0900
Message-Id: <20230214005019.1897251-3-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
References: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
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
index 72054e3a26cb..bff637702397 100644
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
 		sizeof(*devmap_info);
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
 			    alltgt_info, (min_entrylen + sizeof(u64)));
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

