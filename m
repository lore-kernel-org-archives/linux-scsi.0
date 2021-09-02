Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DD9C432BE
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 00:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1BD5261074
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Sep 2021 00:35:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbhIBAgm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Sep 2021 20:36:42 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:27899 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbhIBAgm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Sep 2021 20:36:42 -0400
Received: from epcas2p3.samsung.com (unknown [182.195.41.55])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20210902003542epoutp02dbf4f73f2351068e1dc1f42282417c07~g2irovP5d2715427154epoutp02I
        for <linux-scsi@vger.kernel.org>; Thu,  2 Sep 2021 00:35:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20210902003542epoutp02dbf4f73f2351068e1dc1f42282417c07~g2irovP5d2715427154epoutp02I
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1630542942;
        bh=UBkx3oSc/cwUsSF8cmFNVUeQbPRGX03/Gq8ImmueEZc=;
        h=Subject:Reply-To:From:To:CC:Date:References:From;
        b=uUjexz5HsfkojG6VIz72UJPJF1aBEWjKUPgpon52Cf+nPmBjhVIfyCwmCZOx0+E+z
         iC7n32lxwtgq1pJLg6Ksdvd8W8hkCu48mUoDrg9yof+GeuGVtZubhd/mOU2Ik310dm
         0Il34tzXfKQmoloDHspXJAlGOzBkmXY/76XNiN+Q=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20210902003540epcas2p4801c89bbd2b75f6ab43ee86afce656d0~g2ipz9io50910109101epcas2p48;
        Thu,  2 Sep 2021 00:35:40 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.183]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4H0MQy1g2Gz4x9Q4; Thu,  2 Sep
        2021 00:35:38 +0000 (GMT)
X-AuditID: b6c32a48-d75ff70000002500-fd-61301c573e9f
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        E8.6D.09472.75C10316; Thu,  2 Sep 2021 09:35:35 +0900 (KST)
Mime-Version: 1.0
Subject: [PATCH] scsi: ufs: ufshpb: Use proper power management API
Reply-To: daejun7.park@samsung.com
Sender: Daejun Park <daejun7.park@samsung.com>
From:   Daejun Park <daejun7.park@samsung.com>
To:     ALIM AKHTAR <alim.akhtar@samsung.com>,
        "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        Keoseong Park <keosung.park@samsung.com>,
        "huobean@gmail.com" <huobean@gmail.com>
CC:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
X-Priority: 3
X-Content-Kind-Code: NORMAL
X-CPGS-Detection: blocking_info_exchange
X-Drm-Type: N,general
X-Msg-Generator: Mail
X-Msg-Type: PERSONAL
X-Reply-Demand: N
Message-ID: <20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
Date:   Thu, 02 Sep 2021 09:35:34 +0900
X-CMS-MailID: 20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
X-CPGSPASS: Y
X-CPGSPASS: Y
CMS-TYPE: 102P
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmmW64jEGiwac9vBYP5m1js3j58yqb
        xbQPP5ktXh7StFj1INxiztkGJotFN7YxWRw/+Y7R4vKuOWwW3dd3sFksP/6PyYHb4/IVb4+d
        s+6ye0xYdIDR4+PTWywefVtWMXp83iTn0X6gmymAPSrHJiM1MSW1SCE1Lzk/JTMv3VbJOzje
        Od7UzMBQ19DSwlxJIS8xN9VWycUnQNctMwfoQiWFssScUqBQQGJxsZK+nU1RfmlJqkJGfnGJ
        rVJqQUpOgaFhgV5xYm5xaV66XnJ+rpWhgYGRKVBlQk7G+/+PGAs+81R8+LGTqYHxLVcXIyeH
        hICJxOcf79hBbCGBHYwSH16kdjFycPAKCEr83SEMYgoLOEs8nCYPUaEksf7iLLBqYQE9iVsP
        1zCC2GwCOhLTT9wHinNxiAi8YZLoWrMArIhZoE5i95w/bBCreCVmtD9lgbClJbYv38oIYWtI
        /FjWywxhi0rcXP2WHcZ+f2w+VI2IROu9s1A1ghIPfu6GiktKHNv9gQnCrpfYeucXI8gREgI9
        jBKHd95ihUjoS1zr2Ai2mFfAV+LE+ylgzSwCqhK370+CanaR2PnwOSPE0fIS29/OYQZ5nllA
        U2L9Ln0QU0JAWeLILRaYVxo2/mZHZzML8El0HP4LF98x7wnUdDWJdT/XM0GMkZG4NY9xAqPS
        LEQ4z0KydhbC2gWMzKsYxVILinPTU4uNCkyQY3YTIzipannsYJz99oPeIUYmDsZDjBIczEoi
        vKwP9RKFeFMSK6tSi/Lji0pzUosPMZoCPTyRWUo0OR+Y1vNK4g1NjczMDCxNLUzNjCyUxHk5
        X8kkCgmkJ5akZqemFqQWwfQxcXBKNTDVsH5+cuxo3eUf81Z5tIgWtxiEFzRX39VkT0n5coxp
        zgERo0u+4vPcj3+66je5JnZS34te2bUn8l2duRLfT2u3unq/59n20zvMfTQ4vI5q3Q+4ENHy
        xe6AA6fe0ymmLxeYSDb72AlJxLM3vmZ/yK8RbVMbPdtcLGL+jivZBwzYdvwocyiYsNhtebzr
        MUfOv2vLpHJ3MEUydC89VvParS5EeZ19dFt29WllVZ16jgf9e9zLQ5jk3801LFd2i9/plOCj
        1NGv/H3+lk+P7+tU/qm6nyOrvLvM8vKK9BeZW1N7NZ4z3t0VpqG4wVJ1/irbj1y6KxccOXiq
        bNq6t0X+f34UvwsL2BLk93q3jXuxjRJLcUaioRZzUXEiAFa+dcozBAAA
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430
References: <CGME20210902003534epcms2p1937a0f0eeb48a441cb69f5ef13ff8430@epcms2p1>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In ufshpb, pm_runtime_{get,put}_sync() are used to avoid unwanted runtime
suspend during query requests. In commit b294ff3e3449 ("scsi: ufs: core:
Enable power management for wlun") has been modified to use
ufshcd_rpm_{get,put}_sync() APIs.

This patch has been modified to use these APIs in HPB module.

Signed-off-by: Daejun Park <daejun7.park@samsung.com>
---
 drivers/scsi/ufs/ufshpb.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
index 02fb51ae8b25..9ea639bf6a59 100644
--- a/drivers/scsi/ufs/ufshpb.c
+++ b/drivers/scsi/ufs/ufshpb.c
@@ -2650,11 +2650,11 @@ static int ufshpb_get_lu_info(struct ufs_hba *hba, int lun,
 
 	ufshcd_map_desc_id_to_length(hba, QUERY_DESC_IDN_UNIT, &size);
 
-	pm_runtime_get_sync(hba->dev);
+	ufshcd_rpm_get_sync(hba);
 	ret = ufshcd_query_descriptor_retry(hba, UPIU_QUERY_OPCODE_READ_DESC,
 					    QUERY_DESC_IDN_UNIT, lun, 0,
 					    desc_buf, &size);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_rpm_put_sync(hba);
 
 	if (ret) {
 		dev_err(hba->dev,
@@ -2877,10 +2877,10 @@ void ufshpb_get_dev_info(struct ufs_hba *hba, u8 *desc_buf)
 	if (version == HPB_SUPPORT_LEGACY_VERSION)
 		hpb_dev_info->is_legacy = true;
 
-	pm_runtime_get_sync(hba->dev);
+	ufshcd_rpm_get_sync(hba);
 	ret = ufshcd_query_attr_retry(hba, UPIU_QUERY_OPCODE_READ_ATTR,
 		QUERY_ATTR_IDN_MAX_HPB_SINGLE_CMD, 0, 0, &max_hpb_single_cmd);
-	pm_runtime_put_sync(hba->dev);
+	ufshcd_rpm_put_sync(hba);
 
 	if (ret)
 		dev_err(hba->dev, "%s: idn: read max size of single hpb cmd query request failed",
-- 
2.25.1

