Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA21C77B7A
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 06:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235213AbjEWG2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 02:28:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235206AbjEWG2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 02:28:14 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B89F118
        for <linux-scsi@vger.kernel.org>; Mon, 22 May 2023 23:28:13 -0700 (PDT)
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20230523062811epoutp020e87b049adcdb27ced55c2bc3b30eb3b~hsdtuwhLo0917409174epoutp02H
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 06:28:11 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20230523062811epoutp020e87b049adcdb27ced55c2bc3b30eb3b~hsdtuwhLo0917409174epoutp02H
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1684823291;
        bh=VWsy4krq+w5xTRR2JQYWmpMclIIlq9xss0VH2V+/zjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=UWjkfyvHasdY0R8RonSvmy47L4m9/PAxpjPZrZ8Tju7RijiZBcaIfP3vfiRBSj+62
         b+wDoKB4cMiCT+E4+lZ4+bE+hYPItQh6sLoQvhWQSI9CIglVJT9kakf91IbzlQbC1a
         VnbIuKF6Gu3/XtZQ/V0JgK1phn2HaAn3BQdqGNG0=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20230523062810epcas2p3c5da9748b094856926d45c6a8aba8dd5~hsds1HjML0207802078epcas2p38;
        Tue, 23 May 2023 06:28:10 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.36.88]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4QQPWs5bHdz4x9Pr; Tue, 23 May
        2023 06:28:09 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        4A.5B.44220.9FC5C646; Tue, 23 May 2023 15:28:09 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20230523062809epcas2p1a0d5134df7c0f3a40b605326c7ee1987~hsdrY6YSH0164101641epcas2p1N;
        Tue, 23 May 2023 06:28:09 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20230523062809epsmtrp2b37f5ecf9288f722d896e576dd4c97b2~hsdrYGVjP1738517385epsmtrp2a;
        Tue, 23 May 2023 06:28:09 +0000 (GMT)
X-AuditID: b6c32a48-9f1ff7000000acbc-22-646c5cf91e62
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        5A.21.27706.8FC5C646; Tue, 23 May 2023 15:28:09 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [10.229.95.128]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20230523062808epsmtip17a13ca00edfecf6715cbc30ce4893fa5~hsdrMnGIe1634916349epsmtip1H;
        Tue, 23 May 2023 06:28:08 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com, beanhuo@micron.com,
        adrian.hunter@intel.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, kwangwon.min@samsung.com,
        junwoo80.lee@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v1 2/3] ufs: poll HCS.UCRDY before issuing a UIC command
Date:   Tue, 23 May 2023 15:19:09 +0900
Message-Id: <5cd0088bb9fbd75b75638684f22de9710cf5f2c2.1684822284.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1684822284.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1684822284.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprNJsWRmVeSWpSXmKPExsWy7bCmme7PmJwUg5OtahYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8XqxQ9YLBbd2MZksetvM5PF1hs7WSxubjnKYnF51xw2i+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCIyrbJSE1MSS1SSM1Lzk/JzEu3VfIOjneONzUzMNQ1tLQwV1LIS8xNtVVy8QnQdcvM
        ATpeSaEsMacUKBSQWFyspG9nU5RfWpKqkJFfXGKrlFqQklNgXqBXnJhbXJqXrpeXWmJlaGBg
        ZApUmJCdseh6H1vBO+6Ktj0TmRsY73N2MXJySAiYSPRduMDUxcjFISSwg1Hi9/RzbCAJIYFP
        jBKP/rJDJL4xSqye95MdpuPO68nMEIm9jBJtG/9DVf1glDi/6xQTSBWbgKbE05tTwWwRgRtM
        Ek/6RUFsZgF1iV0TToDFhQU8JFo7roLZLAKqEtMetbCA2LwC0RJb/7WyQmyTk7h5rpMZxOYU
        sJTY8KqZDZXNBVQzl0Piw492JogGF4klXY1sELawxKvjW6DOlpL4/G4vUJwDyM6W2LNQDCJc
        IbF42lsWCNtYYtazdkaQEmag+9fv0oeoVpY4cosF4no+iY7DoEABCfNKdLQJQTQqS/yaNJkR
        wpaUmHnzDlSJh8SjTd6QwOlhlJh6uJ95AqP8LIT5CxgZVzGKpRYU56anFhsVmMCjLjk/dxMj
        OJVqeexgnP32g94hRiYOxkOMEhzMSiK8J8qzU4R4UxIrq1KL8uOLSnNSiw8xmgJDcSKzlGhy
        PjCZ55XEG5pYGpiYmRmaG5kamCuJ837sUE4REkhPLEnNTk0tSC2C6WPi4JRqYHL5m1/+wYtP
        4lX5+TM7Nta1uRWFWUzIaXVaEiqXtX/bR/NPLKFM6tybfs/6x9WU0NayxdRqk86KB0GK2mEf
        575RuWe7Q/2K+4SSBRWv7if++3pm5Z0H/W+Wm7y5ft4jg09D8Jrwx2kvOTV5ejxqH7Se6+H9
        VaPN5HPXve2mXM2puRMcV2eaVZyReuJ4Lb2OS/7qf4W2mz6LhY4bHtk624Hv++MDP8/wl2Vl
        qLrNSF3XckKDffOx+ZarzymvKLvJ/DXqsNzqqkyxOs+1AaXfbZcv+pkhKzz9fbsai6S1Ziyf
        2+erTt9OTXFRD2NyPsbFy7b2/e6MSWcttt4U1XNp27Fvzy3T9GaBSU+fPP50+asSS3FGoqEW
        c1FxIgClP7ojLgQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsWy7bCSnO7PmJwUg+6tTBYnn6xhs3gwbxub
        xcufV9ksDj7sZLGY9uEns8XqxQ9YLBbd2MZksetvM5PF1hs7WSxubjnKYnF51xw2i+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9li85yWTx4RFBxg9vq/vYPP4+PQWi0ffllWMHp83yXm0
        H+hmCuCI4rJJSc3JLEst0rdL4MpYdL2PreAdd0XbnonMDYz3ObsYOTkkBEwk7ryezNzFyMUh
        JLCbUWLugi5GiISkxImdz6FsYYn7LUdYIYq+MUrcerWBHSTBJqAp8fTmVCaQhIjAKyaJuf9P
        gXUwC6hL7JpwggnEFhbwkGjtuApmswioSkx71MICYvMKREts/dfKCrFBTuLmuU5mEJtTwFJi
        w6tmti5GDqBtFhKN3/hwCE9gFFjAyLCKUTK1oDg3PbfYsMAwL7Vcrzgxt7g0L10vOT93EyM4
        IrQ0dzBuX/VB7xAjEwfjIUYJDmYlEd4T5dkpQrwpiZVVqUX58UWlOanFhxilOViUxHkvdJ2M
        FxJITyxJzU5NLUgtgskycXBKNTCtWKeh+38/97GjU+2n1GsmPuk54SK7WuQNu/7uFC7G59mb
        VWNmMbOduOJx2OJ1Y33DmZuZ0/rn3vru62Fsf0X/7TSVEL85x3SMDeJ5tPt6Tik9N2pYLd6g
        bbDv+qNa3tUXc0/5SEazTT3rOF86Wsvk4eGdEnvufHnz9uTU9XOm65vP83l2sTT55HRGW9Xy
        ZqWnP5tObNVztfS/3qsz9ZoZxzO/thVdafYBHMdOHdaMjd9d+qLZMNA/dt7CWMWvD/fZu999
        +q7I/HQQi/EB89en00JiTb59KmQWtPlzpydHMbNpb9jL7oizNlIrnJU0J2ZWi/84UeWWWcPw
        8UW7svLxA7kF0fmHLlp7TuGVea3EUpyRaKjFXFScCADttpf+9wIAAA==
X-CMS-MailID: 20230523062809epcas2p1a0d5134df7c0f3a40b605326c7ee1987
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20230523062809epcas2p1a0d5134df7c0f3a40b605326c7ee1987
References: <cover.1684822284.git.kwmad.kim@samsung.com>
        <CGME20230523062809epcas2p1a0d5134df7c0f3a40b605326c7ee1987@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

v1 -> v2: replace usleep_range with udelay
because it's a sleepable period.

With auto hibern8 enabled, UIC could be working
for a while to process a hibern8 operation and HCI
reports UIC not ready for a short term through HCS.UCRDY.
And UFS driver can't recognize the operation.
UFSHCI spec specifies UCRDY like this:
whether the host controller is ready to process UIC COMMAND

The 'ready' could be seen as many different meanings. If the meaning
includes not processing any request from HCI, processing a hibern8
operation can be 'not ready'. In this situation, the driver needs to
wait until the operations is completed.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index e096401..a772f92 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -2365,7 +2365,18 @@ static inline int ufshcd_hba_capabilities(struct ufs_hba *hba)
  */
 static inline bool ufshcd_ready_for_uic_cmd(struct ufs_hba *hba)
 {
-	return ufshcd_readl(hba, REG_CONTROLLER_STATUS) & UIC_COMMAND_READY;
+	ktime_t timeout = ktime_add_ms(ktime_get(), UIC_CMD_TIMEOUT);
+	u32 val = 0;
+
+	do {
+		val = ufshcd_readl(hba, REG_CONTROLLER_STATUS) &
+			UIC_COMMAND_READY;
+		if (val)
+			break;
+		udelay(500);
+	} while (ktime_before(ktime_get(), timeout));
+
+	return val ? true : false;
 }
 
 /**
-- 
2.7.4

