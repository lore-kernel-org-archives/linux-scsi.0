Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6118BC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4A91461351
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232591AbhFPLbt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:49 -0400
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:65418 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbhFPLbo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842977; x=1655378977;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QEVwtoq6tjmcRLMLSE2RCHvwORFqC9XJA7WfJrOBcd8=;
  b=aoyTtc6K+neQeCZzemqcmCl0tjsfO9q5JdKaSQDpsAE+z2/Wnt19+uCo
   fYXYuF4bGMrmwzbwhYwnUusrUvk24n/bdAVoX59+TlQs1hJ9guIe4JhYI
   3AU2cVRuSPATbC855CdYM72ESC5AQm9ngjbzM8TlYwPI8fuZJlcZgb2ya
   OhQldwRek/BWHBlPdJD4Im0bomF9P5nPxQiscUnYYjWttcBe4RUlKtvN/
   76QQkz3i1jQ2HV+ddq9RGs32cZj+UTAQ57zMAY6Rfg04CgjuVtwr1DfKX
   Zovv13x8kjyTFi3S/CgpsVVE9YkoIZBc/AmjwxhEYIkppTzVJjNbPuDLq
   w==;
IronPort-SDR: 14tP8T/YzwyUJ5/xZ0nTTCB8H9D7d2O2RAU0DPW1Ksf+KSSF98+i8m7OhnXP203QdqblGtSbOU
 T7zUeo+eHOjjf2OCfdjGXvmpF1F10iPrGmPSfD4vDVNuM6H/1KZzSWiKRzXcTvFjvq5wEZdNOz
 HFw8KLHM8ZFI1GNLGUCKozfpvTIrI5t5iJlQrgN5YXdPuSDpzncudzpBp4Q/YVkdy/8IUokvz/
 mrU6OOj2s4Z2JN7XAzwFmUo66pwNG7ql0Eq4PGnRyOYITaZSJyvfP1keu7UKvGJFvsSfW7v4Ii
 5lQ=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="176876353"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:29:37 +0800
IronPort-SDR: K4yqGnX52Kb654057e+nNVfAg92l6rD7jx62gWZrDN9HJ3hmfCoq0GUQMDjexY0PS0Q0pCSWRt
 +3Bd9HDUPeXxPu02JMrUiklBQvmMwOFDSpVgjU1IYkFygMrEp5G0tBNF2SQtT/sMukWJG3GBGV
 6zBa4uUb08m86U5llPtU92TvBlUuLkaH4iIJfHKzMGL/Jjk7Il5Fpj9qciNbhe/ziepQj4xIv2
 gBTPKEaIwg/Ges55lHvVA5oF1LpN2iqgIkDCvP2RjD2mmEaq+4OUce7vwp+26Z8KyuhpWS6qzA
 gBkkK1hBwkMNuMtF5OGZUHbS
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:08:28 -0700
IronPort-SDR: L+93vWasVXbJT+Ub8qCFROmGMY75g3t0i6fBd+093mStB2g55Cjr8C52G7Crm7Aev2c/I6eq8h
 oNW9WP8oRHOENRNIcCiT1oW8aWMaYa/EApKc2rHQ51BftEknVTxKJ+xo5M2a/+vw7DX+zIe6rl
 wGfJ19qFyyDlXSdrv+7diV3B+wYOgiXkg/OHX9ZEMiuZPNM1X4+fxpPvSQG554650WrIINBjWc
 V6IppBAZ4GZ+/A85PB4Yohn0BMsQlw2juQc/ZYAuUxeHr5v2KtUDmIeACFo/yjsWSHx7WP8zIb
 +Rg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:29:34 -0700
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
Subject: [PATCH v11 10/12] scsi: ufshpb: Do not send umap_all in host control mode
Date:   Wed, 16 Jun 2021 14:27:58 +0300
Message-Id: <20210616112800.52963-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
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
index c9c1c39cb269..126de2987919 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2458,7 +2458,8 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
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

