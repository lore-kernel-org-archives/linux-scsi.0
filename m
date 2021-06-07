Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 738BFC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:16:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5CAD1611AD
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 06:16:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230373AbhFGGRy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 02:17:54 -0400
Received: from esa1.hgst.iphmx.com ([68.232.141.245]:27093 "EHLO
        esa1.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230353AbhFGGRx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 02:17:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623046563; x=1654582563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=ZJQ/NRNaJlybQ/31KgdHbsj2CZRmUMaLw3D3Q66Q6kY=;
  b=fBY7t35/5eKDT06HWpkVjNO43HQqSSXFtjJ8HMNBSbXn4gEgsAypyQaX
   u0ZTE9h+kCgbeEgl61ODSfNYHqjCFSDwSG6/cBjKHtc+zzNxlf1q9A4m2
   3o62TyDPMzLnH11r0ULRlWIJ7VMZ9s7QAA+VBbhyXinEtWdxJVidH1iwg
   f4BxBUySlwHgpMlGw3POtAQlvFa3p6+56LzpR7Egpa86LcOAl4V+dTasL
   iS6uK/TNIU+T7fF/dOfQeWYM5n1ryrypQq3z6MbmBu1kePrFOM0XkwC4M
   F8voEcY5bGj+YxSaZYAw4E2qSJJG8VAHKQigYtyAnwOUu+Kqn+nIw3Nbv
   A==;
IronPort-SDR: RG8t/6tvLy1wHUj6y3G/Y9NB9BKHZI9zEe0aRAcH+WL2FSAlMLFLQ5WDEs2btB8hUtg7DEgY4r
 pd/Vcg0o/uXR3RIicL6dKTYE7Nn4rxtjydYw2YszZxlcsos0mBZbwdG4kfIUYlBNC720qdpiFX
 oyFcebjVWiTqfeGwySQqUb0znzOhGGeeVH+wZ4Bk70lqEa8EeFtpGIq/qR8EEHTSAVIAfXV/Gd
 Mr4zeBuE4uhowmw+6QxJv377HfzfbxFLTGgR/R6DGj6pJkcj1P9gi0oZODI4sM9Y+/Rw3rp+4c
 dWk=
X-IronPort-AV: E=Sophos;i="5.83,254,1616428800"; 
   d="scan'208";a="282406603"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Jun 2021 14:16:02 +0800
IronPort-SDR: MnCh90/+xdYfMuiresTvgLhnmqFQslpZgXFVI2Ux3HG1DH9RSZzD53RxG5BoYESgD29FzdrdWm
 YRRq9Ghn72W2+aC/oG7rg0F7RIMGfIVn79PBCYGlZt+C6ORCmtdr0xAkSYb65nnV2P+Xr+aYRQ
 IRly5OB3yaJoWlZZZ9iEpF6KmP3NXkp5j0zPpQSkFKcXMUWK95laUR476eGDF5CRAoA9uL5le+
 EkL7gXtcdEe1LGdrObr0dmu6r7Elju6odlbOwoHIWcCgF34I0hGPGUJ8Us0PK92t8B+HJoUj1d
 pu+PUsqn0ieKGo3VIm6Wbn/k
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jun 2021 22:53:45 -0700
IronPort-SDR: ERVSPo22VbVw8JD79DfhN4RDe02aOv6xnDSELMzfcmnkj84WA023GjVqFgYN7n/JLgWteiVClV
 NZ0KBjGtie3XtkR4h9X54LoxgQLbK0Zg5wzH+0lPaU7oNFmA/JmrqczF7mBzLw8RFt6mgCQTuW
 lXcQt/SOLiwWSuIfSJ4hos1Up2y6G09g/ohMMC0tzaTW4G4BDSnlOKvKKvDIqC6DGzJp9fi5Vy
 g0XcLY+gRB0oKecXGMKr7Htq9sdkYHSglx3pEvMIWeMYoIWm0ntYonLS7NyN6+uG40IMPUOdsg
 DuE=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip02.wdc.com with ESMTP; 06 Jun 2021 23:15:59 -0700
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
Subject: [PATCH v10 10/12] scsi: ufshpb: Do not send umap_all in host control mode
Date:   Mon,  7 Jun 2021 09:13:59 +0300
Message-Id: <20210607061401.58884-11-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210607061401.58884-1-avri.altman@wdc.com>
References: <20210607061401.58884-1-avri.altman@wdc.com>
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
index bcfdf338244b..98c107ca4a4e 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2461,7 +2461,8 @@ static void ufshpb_hpb_lu_prepared(struct ufs_hba *hba)
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

