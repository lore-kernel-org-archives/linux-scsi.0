Return-Path: <SRS0=7BVi=6B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EA72C3815B
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 148452223C
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Apr 2020 18:10:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qoKCAdng"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730496AbgDQSKS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Apr 2020 14:10:18 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:62494 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730413AbgDQSKO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Apr 2020 14:10:14 -0400
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200417181009epoutp01f4eec86841ecfccda1a2d902f9e74079~GrcvloESj0233302333epoutp01o
        for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2020 18:10:09 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200417181009epoutp01f4eec86841ecfccda1a2d902f9e74079~GrcvloESj0233302333epoutp01o
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1587147009;
        bh=fwMNAQHpcMt9+Q4F9H8f3bsqLQxRec1ZLRJWTWxuzrE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qoKCAdng+v3SI6uki8SAmr0gTcAzBCX8+u8QGvIE+Yw82Zj0/I3qsHvaFpLrTFEzg
         F5Fs8pe2dPJwIAZogPP0nGzvUpKmkG4f2W/zDpfUy8U+61PaIPEB0EXk3GjkTCU6ZG
         cRPlinFnCRw0nnZ2iNjfL8tBRadRmJsKU8WhjsW8=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p2.samsung.com (KnoxPortal) with ESMTP id
        20200417181009epcas5p25aa05076d38edc21856f2afc0fed2ca3~Grcu4L0Sd2908329083epcas5p2w;
        Fri, 17 Apr 2020 18:10:09 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        05.58.04782.101F99E5; Sat, 18 Apr 2020 03:10:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe~Grct1ol391060310603epcas5p4j;
        Fri, 17 Apr 2020 18:10:08 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200417181008epsmtrp265ad757a2816b700daef12e461879989~Grct0y6JR1697716977epsmtrp2i;
        Fri, 17 Apr 2020 18:10:08 +0000 (GMT)
X-AuditID: b6c32a49-89bff700000012ae-e9-5e99f101531b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.D0.04024.FF0F99E5; Sat, 18 Apr 2020 03:10:07 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200417181006epsmtip1c7415a0681d4dcc8347fee899da7a5f2~GrcsDr3UA2251122511epsmtip1j;
        Fri, 17 Apr 2020 18:10:06 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v6 01/10] scsi: ufs: add quirk to fix mishandling
 utrlclr/utmrlclr
Date:   Fri, 17 Apr 2020 23:29:35 +0530
Message-Id: <20200417175944.47189-2-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200417175944.47189-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprAKsWRmVeSWpSXmKPExsWy7bCmhi7jx5lxBr+72SwezNvGZvHy51U2
        i0/rl7FazD9yjtXi/PkN7BY3txxlsdj0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLP7v2cFu
        sXTrTUYHXo/Lfb1MHptWdbJ5bF5S79Fycj+Lx8ent1g8+rasYvT4vEnOo/1AN1MARxSXTUpq
        TmZZapG+XQJXRnfPROaCGQIVb862MzUwnuXtYuTkkBAwkVjS+oOti5GLQ0hgN6PEpVXbWCCc
        T4wSPz/9h8p8Y5Q4c+8JaxcjB1jLsckBEPG9jBJPf66C6mhhktjz/wMjyFw2AW2Ju9O3MIHY
        IgLCEke+tYHFmQVuMEk8WOkCYgsLhEjs27SbFcRmEVCV2N1zGqyGV8BGon/NGlaI++QlVm84
        wAxicwrYSrS1LGUCWSYhcJ9N4tmS90wQRS4Sbcv2MUPYwhKvjm9hh7ClJD6/28sGcXW2RM8u
        Y4hwjcTSecdYIGx7iQNX5rCAlDALaEqs36UPcSafRO/vJ0wQnbwSHW1CENWqEs3vrkJ1SktM
        7O6GutJDYsfmqYyQYJjAKHFu/gOWCYyysxCmLmBkXMUomVpQnJueWmxaYJiXWq5XnJhbXJqX
        rpecn7uJEZxOtDx3MM4653OIUYCDUYmHt6NvZpwQa2JZcWXuIUYJDmYlEd6DbkAh3pTEyqrU
        ovz4otKc1OJDjNIcLErivJNYr8YICaQnlqRmp6YWpBbBZJk4OKUaGNluCR+YP7dOY0HP3gUK
        /CqXecLZv4Wc0wgR27q96wpLfdIyUZGtdc8izutm33kddrom0l7p9oo/v+fPqDrpNvPmFc2o
        Tf1rd0ffb5mrsOz6cmMX5+wAy/w8v/Q7LPUS3Z+ub0x5x3LuunOF3e3prpYOj1w5lBKWXsn6
        Y5i60mSj+6vrx3VD9iqxFGckGmoxFxUnAgDAsGfVIwMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsWy7bCSnO7/DzPjDI4etLF4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGd09E5kLZghUvDnbztTAeJa3i5GDQ0LAROLY5IAuRk4OIYHdjBKdr5VAbAkB
        aYnrGyewQ9jCEiv/PQeyuYBqmpgk1t77wwaSYBPQlrg7fQsTiC0CVHTkWxsjiM0s8IxJ4tTD
        UhBbWCBIYv+/iWA1LAKqErt7ToPV8ArYSPSvWcMKsUBeYvWGA8wgNqeArURby1ImkNuEgGo2
        PImZwMi3gJFhFaNkakFxbnpusWGBYV5quV5xYm5xaV66XnJ+7iZGcCBrae5gvLwk/hCjAAej
        Eg+vQc/MOCHWxLLiytxDjBIczEoivAfdgEK8KYmVValF+fFFpTmpxYcYpTlYlMR5n+YdixQS
        SE8sSc1OTS1ILYLJMnFwSjUwLuWP4YsOywy7bZvFlDTviv/+iIqMOL3CnLP95UZ2RWtiGf56
        rc5IvGe26ihzSrevjVS4jC/vzmebX20oU1+5ZKc8xzVdJ1lhxfNvuhPUuCacMj+674nq7/Vb
        LitK3do3VeFTf+KCVcU35yUfsJ77uLDzUl2azXyjvobV/wWjW75xfGq3FilSYinOSDTUYi4q
        TgQAiLsUbGACAAA=
X-CMS-MailID: 20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
        <CGME20200417181008epcas5p460840c01c2c09ce1a69e83005b4bddbe@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In the right behavior, setting the bit to '0' indicates clear and '1'
indicates no change. If host controller handles this the other way,
UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR can be used.

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

base-commit: 8f3d9f354286745c751374f5f1fcafee6b3f3136
-- 
2.17.1

