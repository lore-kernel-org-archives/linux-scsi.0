Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0F5CC4167B
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 00:53:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234089AbiLMAxF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 19:53:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234055AbiLMAww (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 19:52:52 -0500
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDE961571A
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 16:52:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670892766; x=1702428766;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=JCxduR2Ll2GzpQ0Vp5prGBit2viTYV2UQ1hkqRQZ03w=;
  b=bePOwpC5SlMm941CPSjYKyn/tFwXtuV77CuhVBCIBL04TLsMvDs0gVCT
   mUcVcf9B3W0dIMHYNzmQZiMmvg8A+u1orLEVXtpx1OgGlpM3PYqxpant9
   zdC1BxsPr0l6HTdfiQduSjH+i4yYuoBJ5rMsDFZ8Oh7gEX9Jf06xfzVAL
   nX7cTvwGYfrF6yOMnAbymzlPlCGf6AnNdpozZA9tjYVqvp6+/ueeONJMb
   56aVtAnZnA9bj9On8LsYTwwdRtV6wAY4r+lXNWJmHS3ZnYnxM2lwUomwT
   DM2VM95JvYND4ZRHPCsl1AppemagF6jUoqELY5w3aqEDELkPe91sWPwPw
   g==;
X-IronPort-AV: E=Sophos;i="5.96,239,1665417600"; 
   d="scan'208";a="223646011"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 08:52:46 +0800
IronPort-SDR: 6LNmyVSM7OzS3pImTb3DzjOn03cv7eF1v8i8WovXQTEZX4rW58WkkmmGJVylPch7lEPleQRvYp
 44pIw26kIKfK4lRJRurMPxX4fhEMrUKZ3F5D5H522d6JZ+W7tBGvjXt7Kgybhh0nCzNvDusdPg
 Duu3ZAdplwwJcg0pDYy2pPvWcPzUK5xBelXYU0MDQGA579E0/2yOJcnDqPPvv/EPhsKlVaNiOz
 K4rY5tNTYc92vW8M6L5CWNG7x09hGvJghBpgeoiw17ncsT9DAFiejayOLK3tFAbXMvL4K7gK73
 hkM=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 16:11:11 -0800
IronPort-SDR: YsYM4I36pnD9OMFVrk/WqLfMRvdgKB/Z9sHGbWeG7fIHaHjPQuxn5I5Zj29Bmtpd4WXxl+SYiZ
 3gnJPkD069CzQCe1dRULC95thDynd5ELFg8XkNGqFaKD2fqHOktFmVkMxaQqI7QL3ZdgAPw44n
 i+sdEdvOk1CwesofbleExE5WjEcDEmeIBYBsWGJqKrJa4J3Pv4zrLrfjzL4X0e/rTfzyiq+MDV
 Y3rt1IO1mXmY8I5cbkz+GLstdgBiGo9LXYBmOWGaxAqCv+bC6VFmQ+shkDBScn2rBstCuDQ1hV
 bSA=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Dec 2022 16:52:46 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v2 1/3] scsi: mpi3mr: fix alltgt_info copy size in mpi3mr_get_all_tgt_info
Date:   Tue, 13 Dec 2022 09:52:41 +0900
Message-Id: <20221213005243.2727877-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The function mpi3mr_get_all_tgt_info calculates size of alltgt_info and
allocate memory for it. After preparing valid data in alltgt_info, it
calls sg_copy_from_buffer to copy alltgt_info to job->request_payload,
specifying length of the payload as copy length. This length is larger
than the calculated alltgt_info size. It causes memory access to invalid
address and results in "BUG: KASAN: slab-out-of-bounds". The BUG was
observed during boot using systems with eHBA-9600. By updating the HBA
firmware to latest version 8.3.1.0 the BUG was not observed during boot,
but still observed when command "storcli2 /c0 show" is executed.

Fix the BUG by specifying the calculated alltgt_info size as copy
length. Also check that the copy destination payload length is larger
than the copy length.

Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
Cc: stable@vger.kernel.org
Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9baac224b213..2e35b0fece9c 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
 	size = sizeof(*alltgt_info) + kern_entrylen;
+
+	if (size > job->request_payload.payload_len) {
+		dprint_bsg_err(mrioc, "%s: payload length is too small\n",
+			       __func__);
+		return rval;
+	}
+
 	alltgt_info = kzalloc(size, GFP_KERNEL);
 	if (!alltgt_info)
 		return -ENOMEM;
@@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	sg_copy_from_buffer(job->request_payload.sg_list,
 			    job->request_payload.sg_cnt,
-			    alltgt_info, job->request_payload.payload_len);
+			    alltgt_info, size);
 	rval = 0;
 out:
 	kfree(alltgt_info);
-- 
2.37.1

