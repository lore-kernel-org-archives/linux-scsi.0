Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 726D3C54EBD
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Jan 2023 01:55:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjAJBzo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Jan 2023 20:55:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229762AbjAJBzn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Jan 2023 20:55:43 -0500
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EC913F23
        for <linux-scsi@vger.kernel.org>; Mon,  9 Jan 2023 17:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673315741; x=1704851741;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=8QTa+ZXhS+gfABgWpDdnMlCj5JOX+WkkogmapTpAIVY=;
  b=m9F1vtQwAlx5HoK8an2+AGWgNLuJFPFZosWuPh7HQtwBx04QQ4BZhzGi
   MYIcsJ+T57SnCDTbp8oOmGnQeO4pIE+NTNDnEYTE0/f5NcTuKxw24Rv3I
   MU/0X4puUsitjTIs2Lz8IKPz1EukFCdsG3UpeXA+vuY5DtO3Ckso7piU+
   HXtfLowbwZd3zzq2MgTWx64DozEF3BzAxtamQ+h9kbcueIBHY2iZzsb2X
   CjMM9149nSI9Ureg7cTU2zBA1iGBerRENsYc7wlF8j9dxo2Qq4GG7tu/I
   TG7J/vQpPNOsJWNtBIeqHYpmV/j1yfv1i1lSRAk1tcJIps+FxsgD58KUQ
   g==;
X-IronPort-AV: E=Sophos;i="5.96,313,1665417600"; 
   d="scan'208";a="324698278"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Jan 2023 09:55:41 +0800
IronPort-SDR: lvFwycepLoOYg1vUoQ3UPWdg5CZ5lMrjEWNNbEbd4Uyatu0mEA9Rn65GHyvPiSBYAshzzqrpZu
 tjRtUvcP78a1J2LdK2dz+Wnaflks7IZ4buztOPGw0BjkzQUZBi4KJRZAuV7mNCDpOEMoCRrHzu
 4BUmyKmtFL8aPZ7Xjh8Mt/XU0rxcO6o+vPpbsTBSBdbwnO3wIRg+GfUJ11e7m+vs0bSJS4yVDa
 kUQny6NJX8PbO9EMAiy9x2BmCUfUV+z4UXl60/vlN1jEkh3vCOgzC1fH67EX8xq4AwdOU9bFpO
 a8o=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Jan 2023 17:07:47 -0800
IronPort-SDR: KnfoTVmeQn5zM7HhfV1U6wSdrWPqDnTpj0nWkg3vAPR4WtnOzOv8X+4JoTUEd4Rgy+uH3MSFBx
 5eDhxzoIy63cJTcCfzLPfie7sPclUBleDmMcvvpyHVT10ye05s+4sTGi0jBirVgbVLZv1Th9Hh
 QJR1XQjumkLnKOSILF6uCi1v/ooAnDBhW+xrIXU98G3lxz8Z/rpf3WX00E8mHFQ50K1UnAp6+R
 q7SmtZ2626EXbkE/itK4XXqxbyo+k4/YWmHyUs000t4fC5gAuZx12MBGrLCxJ8bFhg20XBlugK
 TM8=
WDCIronportException: Internal
Received: from shindev.dhcp.fujisawa.hgst.com (HELO shindev.fujisawa.hgst.com) ([10.149.52.207])
  by uls-op-cesaip02.wdc.com with ESMTP; 09 Jan 2023 17:55:41 -0800
From:   Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
To:     linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Subject: [PATCH v3 1/5] scsi: mpi3mr: remove unnecessary memcpy
Date:   Tue, 10 Jan 2023 10:55:34 +0900
Message-Id: <20230110015538.201332-2-shinichiro.kawasaki@wdc.com>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
References: <20230110015538.201332-1-shinichiro.kawasaki@wdc.com>
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
index 9baac224b213..5bbfdff70570 100644
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
@@ -349,20 +348,12 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
 	usr_entrylen = (job->request_payload.payload_len - sizeof(u32)) / sizeof(*devmap_info);
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
 			    alltgt_info, job->request_payload.payload_len);
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

