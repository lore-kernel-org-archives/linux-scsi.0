Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC5BBC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D10586128B
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 11:29:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232559AbhFPLb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 16 Jun 2021 07:31:58 -0400
Received: from esa4.hgst.iphmx.com ([216.71.154.42]:25378 "EHLO
        esa4.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232604AbhFPLbx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 16 Jun 2021 07:31:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1623842988; x=1655378988;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rqBDSxgR5oeIA+/zf1rkyGQe7vLReilKmsbBFYMY4Wk=;
  b=qXVY6tXTHPzAgsSKaBoCFmzHh3HC/QkjbHWzxf1u/yqdKKR2Du4KjCAf
   56ReK1EZ/PA12hclSZST0T5c/C24/tHpezHeFj4p+EOYF7FV1qTL7GrTt
   BVbJvbItkryfAbn/fSe56FT82W5YJM97gIXuIs0XfWvUnMRSOVJYHf/22
   T9bQcRp7WfqvXnfa/TJnmmUpw9WDZd7Ql1ZyMunMilZXeOfSbQmvghCAI
   odmOMVzXjkY800DF2q3lJ+W6FShXeZzYRIWCBlIrM+926ba+1at7CoN3b
   iJHi7nDRcPR+q0qyGEIZu5U20EhnB6CmHZNHY/UqCj5OgLIE8P4wFFef/
   Q==;
IronPort-SDR: 8dYoY5fBIIZsiavjyIP72UkElbBSLZkMtxotMBg8ZaHk5WkmBJH1veLEMMdvT7Yaa4JjYVUcdZ
 oJM/geEH8guPfD0fJrKZoQTo6WyBJ1GIvxcvu72nC/73R/aCLTshFNHS4jtVTnqIMXGS+iJJHH
 WHh4ZSbuYJzqe99vYvEcukcZqmvMWEz831xzhnXMcc2oIjWXoKCyFlcUvDpKGjTYsUQ2IkYtJN
 bYNY+ezW8tILEoz0NGfzQpMY3J6sHpwl6lOF+fpOLI3TMmxJgDYPMp3VDmevHGahE9/gx8+T2j
 zjU=
X-IronPort-AV: E=Sophos;i="5.83,277,1616428800"; 
   d="scan'208";a="171352811"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 16 Jun 2021 19:29:47 +0800
IronPort-SDR: 8/MRDCkHWb9JMjTOM5oGAJFrzCGFcfd67IxM99NSDulLMYxpoGpCVW76zKCiaA2bXRi/r7rpbg
 Qe+ISjJwvWYvzxAktZsdbg6iLu2G/C1LUsALveiQ0XFZ9gOoxTUOA9iUPqDhFZdJmzDSqKqJRK
 G5A2/ObP6zwi60ROb01cDGSJyxEWZCQ/u5mQbgzPkBBhvsLKPlt6Yp8o+vwD2wQR3hmCGcchNe
 nCqBLtI9ZNjRkZN2l90VYnZjctoGY81YcdVK/YRTYo5A0ax1DVSjWzA09eMZs0lPHE28jdj0nJ
 j7srntrX4oEOWcBIcT7FojKl
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Jun 2021 04:07:15 -0700
IronPort-SDR: js1LC9qOrI7vsXmWnbFXFggYxYv/W7Cm0tuYK4LB5WmNFgBuXdYHq6gPEqXRVFBPc2JAmOJgYo
 daX+wmsBLIWlLggRnV9ieu+m3bchUtgJ248Id4IJYYe84oIzHrnbOMf9QMfkB86UqqCbNKITvV
 ohn6sxOA8DcUv2uwYBxBOcpEd5RcH4Bbj72IX67aif9GmJ1/HycQNo50nS0c3yFeq9u7Easw1x
 N8fr7/HNty2bH/9US9ybRLyU+w9USQA2J+N0N5rPLsvcM8+qS11Liw8KwOzus2oyj49I7NopIK
 TSY=
WDCIronportException: Internal
Received: from bxygm33.sdcorp.global.sandisk.com ([10.0.231.247])
  by uls-op-cesaip01.wdc.com with ESMTP; 16 Jun 2021 04:29:44 -0700
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
Subject: [PATCH v11 11/12] scsi: ufshpb: Add support for host control mode
Date:   Wed, 16 Jun 2021 14:27:59 +0300
Message-Id: <20210616112800.52963-12-avri.altman@wdc.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210616112800.52963-1-avri.altman@wdc.com>
References: <20210616112800.52963-1-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Support devices that report they are using host control mode.

Signed-off-by: Avri Altman <avri.altman@wdc.com>
Reviewed-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 126de2987919..ab66919f4065 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2582,12 +2582,6 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	u32 max_hpb_single_cmd = HPB_MULTI_CHUNK_LOW;
 
 	hpb_dev_info->control_mode = desc_buf[DEVICE_DESC_PARAM_HPB_CONTROL];
-	if (hpb_dev_info->control_mode == HPB_HOST_CONTROL) {
-		dev_err(hba->dev, "%s: host control mode is not supported.\n",
-			__func__);
-		hpb_dev_info->hpb_disabled = true;
-		return;
-	}
 
 	version = get_unaligned_be16(desc_buf + DEVICE_DESC_PARAM_HPB_VER);
 	if ((version != HPB_SUPPORT_VERSION) &&
-- 
2.25.1

