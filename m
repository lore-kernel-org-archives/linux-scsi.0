Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 630F9C2B9F8
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4206361151
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 11:24:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232822AbhEXLZk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 07:25:40 -0400
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:21990 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232848AbhEXLZV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 May 2021 07:25:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1621855433; x=1653391433;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=2slTZFlzYas3SOwwmRMcQOgCDAott0ELfJUt8Y1jKJ0=;
  b=Xc45/dqkB+vDNLeX0Kg1kqZjJ39zNH/r0uLpgnQ2cdMx4XmFXXxsNZqi
   F7a7m8cli8dZb7dlk+y4wSepbMsj0tDrRqrVxjtVO0n489FBI+SBglcU+
   +YiA1I3vkPEIX+rlPHxtezudk5+u/o3URYcrg6oBCh5EGtnokpH2zjq3+
   jwGT39m1BtDfMPPzyreL8L1bIgqfFE46Z4J6EyUNEYicATYhQmSvgm5ir
   alIZ/msD04xmSEhYGP6s5WRkRM3D267DB2RNi8avscF8MuEaiWweVvpBw
   qx8sAiOqkd6F1wqhcu9ju5xJJDl2ZjY87G1sx2wYxcJ6xGmwiwLCnE6gY
   w==;
IronPort-SDR: ufdYh5Z7vSIzh+jDdEEjma1gpADTpc1NR6Q4K2VfFc4FMnpjKyck7jvPJsY6FTvdcVWMgnlMCv
 6wY5JkhD+dr6hM4UpgfnQvKF/kcrH/t1xuhWBnZn95CbfRMD2b+WrGfLOyXK8TpT3HxF9EYUo3
 dTkoJP0o1GFRsV43H8eUjMuGv4DPEOsUnSk/iwV6p3FaPCdG8CEIiRY43/1bzkePh1kYhVeEhd
 jqcY/CtFcVvADsA0Zae3nJIEHuGdkIbTkg6FFitqjbNHWHl5JNgEOf3OHTuW3f2hKDTh5JcbxZ
 1pc=
X-IronPort-AV: E=Sophos;i="5.82,319,1613404800"; 
   d="scan'208";a="169230689"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 24 May 2021 19:23:53 +0800
IronPort-SDR: 54s55FL/CN7ss4W5Y/rJpbKfaUcdnkCzomxxbbjnmy093ur2OYdmzzMXfNws/iPqCvuCAk8whh
 +IPErjutYxGrQnxzP3akvOU1QMj2XhqYsVQZL0xfKNiYwpzg8gTi9brvwOqy++Nxqvz9lCU8YG
 gDl5BgQ74+4MKgykhalI9q/G0GAk55KZfr/t1XlKokZJlGWE7TAv7nbf7ScGuyD+cO0JyKAsW8
 1DYdljVSEVhFp+Zp0f/YpKNToguMPf2RTaTKN8ChhLbOnHNTG84PGQ9s6SCat4T5rwk9o9QoCY
 Ne6zRKkfGWskeld9ePE8kym7
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 May 2021 04:02:08 -0700
IronPort-SDR: 6uLKFkry0a/w/L1q1ijz/FUQaadZyo8OsBYqPiQg2r3muBehyFlCr/lkvSAqWUPtzBCYWUbBiE
 V4PO5NB65tNLVw2qx+szesq5577Y7CpagcrGCwxp4ITO7t2P14VOf99/1D2WfD9cGth7pa0+IB
 HzQ+N6MvJvE2l9lT9LxAM40SPM65G6dmoFCJnOLuAskTPdzD2GXCDEYRvPDNF+yWY7FKDvD7Ji
 21Qqc5FsGnm3Y9oCqRbhbTyQmtX9y66z5kmjJeVWxMvOOoGJttcCywAGqVI6P40EzNAxGyyMhs
 GiA=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 24 May 2021 04:23:49 -0700
From:   Avri Altman <avri.altman@wdc.com>
To:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com, Avri Altman <avri.altman@wdc.com>
Subject: [PATCH v9 10/12] scsi: ufshpb: Do not send umap_all in host control mode
Date:   Mon, 24 May 2021 14:19:11 +0300
Message-Id: <20210524111913.61303-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210524111913.61303-1-avri.altman@wdc.com>
References: <20210524111913.61303-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

HPB-WRITE-BUFFER with buffer-id = 0x3h is supported in device control
mode only.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshpb.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 47f9021caa29..585515c560a4 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2459,7 +2459,8 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
 			ufshpb_set_state(hpb, HPB_PRESENT);
 			if ((hpb->lu_pinned_end - hpb->lu_pinned_start) > 0)
 				queue_work(ufshpb_wq, &hpb->map_work);
-			ufshpb_issue_umap_all_req(hpb);
+			if (!hpb->is_hcm)
+				ufshpb_issue_umap_all_req(hpb);
 		} else {
 			dev_err(hba->dev, "destroy HPB lu %d\n", hpb->lun);
 			ufshpb_destroy_lu(hba, sdev);
-- 
2.25.1

