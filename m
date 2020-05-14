Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.0 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0088C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C27A9207CD
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 00:53:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="iq9bV2Mv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731079AbgENAxv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 May 2020 20:53:51 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:45937 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727944AbgENAw6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 May 2020 20:52:58 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200514005255epoutp02b2998bb64c0ecbe14cea3d0fa2def2b9~Ovt0SNh1V1742217422epoutp02D
        for <linux-scsi@vger.kernel.org>; Thu, 14 May 2020 00:52:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200514005255epoutp02b2998bb64c0ecbe14cea3d0fa2def2b9~Ovt0SNh1V1742217422epoutp02D
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589417575;
        bh=HK/1/VP5ov7EOoNpQ0X08DtlhI52O+2EyAZ3cTvlQkI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iq9bV2MvKBaOd4OJVeKR6lAshvSH27Q+7A3iAfWowsketrFby9TCRt2YUM7y7pdX1
         Lmd1Spbxo4y04ptgTGF+RPLZd9v6j+1hmvOcudsVMFjAWJ2ljzx0hAv9iWeazxpTft
         C5Jp5AD9GJtDGgeGrPkn2oWVnuw7NdVhBNMxIc0c=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTP id
        20200514005254epcas5p4e1a104efe68d28acdbb3e0768208a94e~OvtznjCWp1376013760epcas5p4-;
        Thu, 14 May 2020 00:52:54 +0000 (GMT)
Received: from epcas5p3.samsung.com ( [182.195.41.41]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        95.45.10010.6669CBE5; Thu, 14 May 2020 09:52:54 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005254epcas5p27e2ef61a6d7f595ff2eaf4ec65940cf6~OvtzOhf9E1337713377epcas5p2E;
        Thu, 14 May 2020 00:52:54 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20200514005254epsmtrp1fa7c612eaa29d07db168f66d1a091dae~OvtzNnQGq1028710287epsmtrp1j;
        Thu, 14 May 2020 00:52:54 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-ee-5ebc9666ccf5
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        6C.C3.18461.5669CBE5; Thu, 14 May 2020 09:52:53 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200514005252epsmtip2f8c61bf224dc7b461d8ca8f6611a8818~OvtxTQi6n3205832058epsmtip2k;
        Thu, 14 May 2020 00:52:51 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v9 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Thu, 14 May 2020 06:09:05 +0530
Message-Id: <20200514003914.26052-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200514003914.26052-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmphleLIzCtJLcpLzFFi42LZdlhTUzdt2p44g8eHxC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXxouja1gKdgtU7P9wnLmB8TVvFyMnh4SAicT/nUsZuxi5OIQEdjNKPLu6jxnC
        +cQo8anjNRuE841R4uWKw0wwLWcvLYBq2cso8efUWSYIp4VJ4tG+VlaQKjYBbYm707eAdYgI
        CEsc+dbGCGIzC9xgkniw0gXEFhYIkZi+/AALiM0ioCqxbd5SMJtXwEbi0btHzBDb5CVWbzgA
        ZnMK2Eps+XKMFWSZhEAnh8SxKe/YIYpcgM6DWCwBtOzV8S1QcSmJl/1tQDYHkJ0t0bPLGCJc
        I7F03jEWCNte4sCVOSwgJcwCmhLrd+lDnMkn0fv7CRNEJ69ER5sQRLWqRPO7q1Cd0hITu7uh
        lnpIHJ7SAA25CYwSpzuWsk1glJ2FMHUBI+MqRsnUguLc9NRi0wLDvNRyveLE3OLSvHS95Pzc
        TYzghKLluYPx7oMPeocYmTgYDzFKcDArifD6rd8dJ8SbklhZlVqUH19UmpNafIhRmoNFSZz3
        dNqWOCGB9MSS1OzU1ILUIpgsEwenVANTSJnzMv5rL39Y3Mt0iLvRx/S56k3xjSSHrhmCTzep
        WJ2tOt9iKMnLwf5Hd9/bgjmJL/fFnYsN/fJddLP5IQ0nrssbfn2R8vxs6v/4YsxzLpWUT+er
        dX3XXqp508mrVOOz4XZbYI+2p//pZ1947glPZNnwM806SH4CT/BJ1867W42F65NmXvY3dD6p
        tOPBwhCP2SyJlQ688yy+51fWM86ckSvNXvuHW3TupkzzXsuCKxc4by2Ka8iqP+Ip2X/E5KGY
        90yPxOTYsobjCVuOTPnM1NjHdEh56eLfqqoKs+xt0lwSOLR/qMl1mAezzn1975Pa29T1Z380
        5uhM2niK2/bm2eaPLVoPRIvjy2eHTVNiKc5INNRiLipOBACNXPbjlwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvG7qtD1xBscfWlo8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujBdH17AU7Bao2P/hOHMD42veLkZODgkBE4mzlxYwdjFycQgJ7GaUeLV6BjNE
        Qlri+sYJ7BC2sMTKf8/ZIYqamCTOP1/KBJJgE9CWuDt9C5gtAlR05FsbI4jNLPCMSeLUw1IQ
        W1ggSKKz8wPYIBYBVYlt85aygNi8AjYSj949glomL7F6wwEwm1PAVmLLl2OsILYQUM2yNcsY
        JzDyLWBkWMUomVpQnJueW2xYYJiXWq5XnJhbXJqXrpecn7uJERzOWpo7GLev+qB3iJGJg/EQ
        owQHs5IIr9/63XFCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeW8ULowTEkhPLEnNTk0tSC2CyTJx
        cEo1MEU+O7ZK3TMjRdpH5+OTebG7TsqITjglXarYLNs1qXf95ccX9x7atVxyJRvD1udpddck
        DFm1lu1PW9zU/m75opfzX4Z5qLzdXc3/WIMtY2/D6vt1N0zdX/XczSsIC/njvWr9Qk4Hhazv
        UusYZuinv7cW21vvf+7ppyqlrO2yx7yfVNXbHXqUsWP+RaPjf/sVtCu4lbhCtgdNV9mXLhLp
        /narxgVdC5EraR1FRzlPfMh4bPkn4sMXlwMLn592r5zJbLclNV7V5tZh31kbn0eINi+Y4jBd
        ek35+iMVi2TyfH+KPvpm+FNhL++i3ktyLgzsISK1oTtCLAX4lm6Kelwf97TOWLZRNuBy1f2d
        2zg2hCuxFGckGmoxFxUnAgD+I2701gIAAA==
X-CMS-MailID: 20200514005254epcas5p27e2ef61a6d7f595ff2eaf4ec65940cf6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200514005254epcas5p27e2ef61a6d7f595ff2eaf4ec65940cf6
References: <20200514003914.26052-1-alim.akhtar@samsung.com>
        <CGME20200514005254epcas5p27e2ef61a6d7f595ff2eaf4ec65940cf6@epcas5p2.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

Reviewed-by: Can Guo <cang@codeaurora.org>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 11 +++++++++--
 drivers/scsi/ufs/ufshcd.h |  5 +++++
 2 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 698e8d20b4ba..3655b88fc862 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -645,7 +645,11 @@ static inline int ufshcd_get_tr_ocs(struct ufshcd_lrb *lrbp)
  */
 static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TRANSFER_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos),
+				REG_UTP_TRANSFER_REQ_LIST_CLEAR);
 }
 
 /**
@@ -655,7 +659,10 @@ static inline void ufshcd_utrl_clear(struct ufs_hba *hba, u32 pos)
  */
 static inline void ufshcd_utmrl_clear(struct ufs_hba *hba, u32 pos)
 {
-	ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	if (hba->quirks & UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR)
+		ufshcd_writel(hba, (1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
+	else
+		ufshcd_writel(hba, ~(1 << pos), REG_UTP_TASK_REQ_LIST_CLEAR);
 }
 
 /**
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 6ffc08ad85f6..071f0edf3f64 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -518,6 +518,11 @@ enum ufshcd_quirks {
 	 * ops (get_ufs_hci_version) to get the correct version.
 	 */
 	UFSHCD_QUIRK_BROKEN_UFS_HCI_VERSION		= 1 << 5,
+
+	/*
+	 * Clear handling for transfer/task request list is just opposite.
+	 */
+	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

