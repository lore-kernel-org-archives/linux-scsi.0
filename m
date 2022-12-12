Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75D9BC001B2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 01:57:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231147AbiLLB5N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 11 Dec 2022 20:57:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230490AbiLLB5K (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 11 Dec 2022 20:57:10 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB8D6DE99
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 17:57:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670810229; x=1702346229;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=c7DlJEoSy5dFeLuCVeM7Q58VrgwXGA454i+kY3FoAZo=;
  b=DwExcBOBlq9aoHPvdygkZijvfLGhR420K8EIJSPCyR4UQWbbB6RnMsSs
   n8PV1ltAD8C9BCkX6a9RyjaTgvucqcG2R5JEDdjkj9pqvt3dkhqheSalo
   Mpvvuxq8Fw0fUVJYd1ct0ISKKnKx84dc1llZ17HHSJRyhyZso5/KXLv9a
   QFfTq4ezA4xk17iUIm75KQ+j44FKiP3cjB94HFGhxia9Fwcxb0BqsRRk6
   ng+SM+qidxYWVEo4vvWJJ02b9GS9VMXFdV1TlXcRVXw3VeB1Dqzys99U7
   zMHUiMAqGnNsjY+0uqZ4wQx6CSAGw1DUALsA7PuLN6KeqS3Ash4EpiEHA
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218660140"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 09:57:09 +0800
IronPort-SDR: oovD4HqZH5jJz/9LT5KMMNczXLiutD3F/2FoH446NlQ36iPj1NF8XuamhC/9SF+MkXUK3h0Clt
 VX00nabdckU5xwEF+eSKfYJs++Wb2Kwm93Wk5Ya0nd3aucEWJedQuSHd8JfBpyPWnRuoxvRo8Y
 w1rKFsimo/7pKmn0Xj3G+IDivPwSuF9WqCcS9Bk67tPC/BAgARWXjo8Zh7rdPZZwOB/ElXZOVp
 gzxxqGNVplsHhzSQkXhU4rqTLrX4LTuo2//M3/MwOiAX0TbIcfIMfKYSrxa6e9sIGBqlNwG1ex
 fKs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 17:15:34 -0800
IronPort-SDR: FMxloDTFd2TgW4l6/ybeUh7LiWh3kqhijoAQWLU5W3XlC0Mrm8xu+yi4SpJz+Y92k95ewPPXWg
 QUNXN3feZbJTI3iLmbPEVWCe4U/9s/R3WREh5p8RNd4olpxGGGAFn0V4NTH8CnZEreFuZ15mly
 CXfgjDNfzsWHIgL32z0fragw4hHYUUCq6DwsKGp5BBjTsfL3El3sHouko8AHyyEkGTKVN2aCdM
 Vr7ryUCLkrzZiepsME1ZpUA2+HzvNmaYOInRvinikHMG0Q0omJx8XabZIL7USi2B3zKCl+g8zv
 MsY=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 11 Dec 2022 17:57:08 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: [PATCH 1/3] scsi: mpi3mr: fix alltgt_info copy size in mpi3mr_get_all_tgt_info
Date:   Mon, 12 Dec 2022 10:57:04 +0900
Message-Id: <20221212015706.2609544-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
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
---
 drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
index 9baac224b213..f14556d50832 100644
--- a/drivers/scsi/mpi3mr/mpi3mr_app.c
+++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
@@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 
 	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
 	size = sizeof(*alltgt_info) + kern_entrylen;
+
+	if (size > job->request_payload.payload_len) {
+		dprint_bsg_err(mrioc, "%s: too small payload length\n",
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

