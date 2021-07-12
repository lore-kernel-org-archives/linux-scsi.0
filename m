Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C826C07E9E
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 788C36102A
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:52:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237953AbhGLJzX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:55:23 -0400
Received: from esa2.hgst.iphmx.com ([68.232.143.124]:33194 "EHLO
        esa2.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241681AbhGLJzU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jul 2021 05:55:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1626083553; x=1657619553;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=9DSxUS8WIFDvTZlufvyq8HF9Ro8gnU39eKlN+8oOfI0=;
  b=MyOZfXCYsQ9hMMdc8yDcazT8Gj4ZTp9AWDWKkAQUPtVZU6jurUhImLb+
   Yjn3xP5h8gEMHgOQ2FkcQjZf9PPiKGbXMjoXUH9c79OVNPeT67FCImfAx
   EQR2ZWhL4CMBWmHyGYZG9oY2gJSBpQlKH1Cm5F3VUu3Wjqb/TMpC8VYle
   I79G5JVDNLgyEGmZav4H0QXjgEeAeciFE7Nb6Fjf/cIWvnEQe6rvTiExv
   lX9lkqD1VWXkNXvu0Bh7hPnL4XTBmmewrftrCKdqRL4Nx4ZAWXeR4PXwN
   NTo5RTDqz7WZmsmjr4zRFUTZSpg0YEcsQYC15Rddsaq1TSOtbloQTEM/I
   w==;
IronPort-SDR: K3N6cfqb87aLaUW0ApAZ9PVSQjaHvO8o1oUEQSGKBa1H3XwllvTqvQc4isBxVLofsN/4dBVf84
 tWIiq6PxChQyLIwmrSZluy3tA3OF7mvGP1TTTa75H2PbTlU0UzVlIJnKl4Z/AqbBw5LCcNMjnM
 pOMj8OSDqJio/fx8WIo0cI4lH9E9qvM+9DDz3Vha+L2+e9Su3tudkK9Il6ECiEjq0QepiVUo2o
 Nk+dCe3iOnVa+BTGgithqwUv4ufu1f6BHfmOWplJ4BbxGVYEXAeOrO3lZ7vDInJy5Z3qbeDsRL
 sLY=
X-IronPort-AV: E=Sophos;i="5.84,232,1620662400"; 
   d="scan'208";a="278155986"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2021 17:52:32 +0800
IronPort-SDR: lp3Zts7ZyDzg+7Y4wopMcDAWI8qQ/GB6+mY+dC0azRQGw0STb1O4fCSGqrkYK8M387MVmTXbWn
 L/SvrjCl/WqfQk82PyLE1vwh/kBCx40gHc4y0skC+kfPvvA061u40EP3P3UZbOaMWvLurPoQBw
 qIoomCcElhl2JtdUYz9qPqPyStdnk0SYRszclmDv2288QltOMqJ1im2V8cVmoUSGKaatCT3Iom
 30WFniB3K5D82vK/N3KWYF+irVaQncKEIJAV8FCyw/fFePMhbpwE4f/qxjrciN6Bf9bnj6BNWC
 2Vr7jUlPSrwX2pjdB4WM5GwG
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Jul 2021 02:30:36 -0700
IronPort-SDR: SHWEa9nl+aLpnHUlhZKIBIf/y1v6N36izW9K5tWFs7mN0Q3kijlCHPL9427aIzDYseKo5fmvPg
 TH2VznQvi3fUwAp0/sngFUGNSBWWTV/2WokqCsCwk9zaHMaGv1FVo/EsVkF3o/U1up9yxdKZ3d
 A0+BWf7JLilCXMdgbMovJOP9VWDgcNuOiN9zWMnbCl8uQly8aGtFE3fuygNvLgyZxjOU58h/Ws
 D42r1kOAb3Q5L0fYUltzOzyDYV/ZONMjavoM7IfYkk7EWKQRWrH9ET46RsWsnLj2cSLAoElNKs
 FIg=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 12 Jul 2021 02:52:25 -0700
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
Subject: [PATCH v12 10/12] scsi: ufshpb: Do not send umap_all in host control mode
Date:   Mon, 12 Jul 2021 12:50:37 +0300
Message-Id: <20210712095039.8093-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210712095039.8093-1-avri.altman@wdc.com>
References: <20210712095039.8093-1-avri.altman@wdc.com>
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
index 472633052af1..17767ebf8bd0 100644
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

