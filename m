Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E28DC6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Feb 2023 00:50:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229824AbjBNAuZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 19:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbjBNAuY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 19:50:24 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B66BC164
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 16:50:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676335823; x=1707871823;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=v64dhaCSofyxz21g0iEPtIvpLlKDdYCXUQdm4Yz707A=;
  b=eXmFfeFXCFnNAxri03tTx4z1KWp4G9Uj5FzyDWJDPn65sCGvAnBfB7v/
   mXwX3ixXiSro1byxXzISX/S5JkQiz5E8gPmz99mMvNtgDSGUzq6nv79fi
   A6yKb/o26Dqe/uUkAl3Bd4ozc70tUpXTef7rvTDC/8aPTTtaQRPCnNtEn
   RK7me4Uu80d8HCBO6CXy26Pamo90ncBne0El4KglcO7WXjxYB8HjZnMDi
   ls2ZOXz6Hh085dvP+3j1LeXwaDydxHueVX1EaXcZnPukC4+kNy5jMMhCz
   k6jBrf/qKsH+krwRhsMmHCI7EJ4a69srT00nBYGfJIf2QmooOc1FoZU2n
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,294,1669046400"; 
   d="scan'208";a="228193156"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 14 Feb 2023 08:50:23 +0800
IronPort-SDR: qpOs+zIGR/u+HZlLhP4DTl7IUm+oOr4QAePhIxmRpjoUynv1KZogz9A9fdswCZnCSzWeWT9oIL
 GlAw/1rf8BI3F9KQZ/IJo8c+0Tbjm7pi2as0liecrQi2qM9cKU4/prB97+w0MtbJgbm2HaEReQ
 R5qXbVwLEUUyGps9sAR9v6z7zr+k6mLhZURC6BhOoeDUhSS5xoDCXQvsaK6IY8M/t86DMTUNXw
 EXswpc2KJ9Cf3PhDYy/iDNcedP+NOIdwT/zLmiPluE2bGWzuU79jt+XfXqKv2txz6nW+VAlQWw
 wrU=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Feb 2023 16:07:31 -0800
IronPort-SDR: dBHPrFTFdTThwolCmgMoK5W/QJM7Q0suv1DW5VpcyP+v3+FiHA5zntBF4jFwfZ78m2kWKS0aIN
 uS+bHA1neeoW4d2cgpV5IascdMQiuTjle7f6pNY9hDkFNLMVDazY/L/2IZD3vbYLXrn2pOzyUk
 7Vp5zHRxYe8qq81tJQ3GQUbF8FFFP52bD+hZr/XiFRhiuOpUMJ12CAksKY4ED8alRqdFCa4cG/
 /zhlKbdV7+Kg6JQmvKF7sihitg+mMkqI6GVEKBPI1FxxHGiqwEPGN2DVd/XTtlm71UAEn9zBg2
 cfE=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 13 Feb 2023 16:50:22 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v5 1/4] scsi: mpi3mr: fix issues in mpi3mr_get_all_tgt_info
Date:   Tue, 14 Feb 2023 09:50:16 +0900
Message-Id: <20230214005019.1897251-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
References: <20230214005019.1897251-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpi3mr_get_all_tgt_info has four issues as follow.

1) It calculates valid entry length in alltgt_info assuming the header
   part of the struct mpi3mr_device_map_info would equal to sizeof(u32).
   The correct size is sizeof(u64).
2) When it calculates the valid entry length kern_entrylen, it excludes
   one entry by subtracting 1 from num_devices.
3) It copies num_device by calling memcpy. Substitution is enough.
4) It does not specify the calculated length to sg_copy_from_buffer().
   Instead, it specifies the payload length which is larger than the
   alltgt_info size. It causes "BUG: KASAN: slab-out-of-bounds".

Fix the issues by using the correct header size, removing the subtract
from num_devices, replacing the memcpy with substitution and specifying
the correct length to sg_copy_from_buffer.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9baac224b213..72054e3a26cb 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -312,7 +312,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		num_devices++;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-	if ((job->request_payload.payload_len == sizeof(u32)) ||
+	if ((job->request_payload.payload_len <= sizeof(u64)) ||
 		list_empty(&mrioc->tgtdev_list)) {
 		sg_copy_from_buffer(job->request_payload.sg_list,
 				    job->request_payload.sg_cnt,
@@ -320,14 +320,14 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 		return 0;
 	}
 
-	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
-	size = sizeof(*alltgt_info) + kern_entrylen;
+	kern_entrylen = num_devices * sizeof(*devmap_info);
+	size = sizeof(u64) + kern_entrylen;
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
 
 	devmap_info = alltgt_info->dmi;
-	memset((u8 *)devmap_info, 0xFF, (kern_entrylen + sizeof(*devmap_info)));
+	memset((u8 *)devmap_info, 0xFF, kern_entrylen);
 	spin_lock_irqsave(&mrioc->tgtdev_lock, flags);
 	list_for_each_entry(tgtdev, &mrioc->tgtdev_list, list) {
 		if (i < num_devices) {
@@ -344,9 +344,10 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	num_devices = i;
 	spin_unlock_irqrestore(&mrioc->tgtdev_lock, flags);
 
-	memcpy(&alltgt_info->num_devices, &num_devices, sizeof(num_devices));
+	alltgt_info->num_devices = num_devices;
 
-	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
+	usr_entrylen = (job->request_payload.payload_len - sizeof(u64)) /
+		sizeof(*devmap_info);
 	usr_entrylen *= sizeof(*devmap_info);
 	min_entrylen = min(usr_entrylen, kern_entrylen);
 	if (min_entrylen && (!memcpy(&alltgt_info->dmi, devmap_info, min_entrylen))) {
@@ -358,7 +359,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, (min_entrylen + sizeof(u64)));
 	rval = 0;
 out:
 	kfree(alltgt_info);
-- 
2.38.1

