Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0D139ECAAD3
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 09:04:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229996AbiIGJE2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 05:04:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbiIGJE0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 05:04:26 -0400
Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 787305FA2
        for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2022 02:04:22 -0700 (PDT)
Received: from epcas1p1.samsung.com (unknown [182.195.41.45])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20220907090420epoutp024e527eacf5e1b300624444a5d54e0d10~SiKY9GXPF1978619786epoutp02u
        for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2022 09:04:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20220907090420epoutp024e527eacf5e1b300624444a5d54e0d10~SiKY9GXPF1978619786epoutp02u
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1662541460;
        bh=n6xTDi1SMkWkVuRNbDVoPzmjCVJER3pdopEC7p/dpjc=;
        h=From:To:Cc:Subject:Date:References:From;
        b=DUGwz/pCFBeVP5AtaG690GYKl38o7XYt98eg2np3uPROC9ZANWfYW1wvCUHIPThkh
         lMhqmbgghePwwYgSQ9ncwobcT4SI4HzsS7iigLVpureG/EYLWY6xNTuiUGI7L1tj1M
         OVpVnW3+sQ3Hrd0BP9QajUpX7JOG0bq11igmcZH0=
Received: from epsnrtp2.localdomain (unknown [182.195.42.163]) by
        epcas1p2.samsung.com (KnoxPortal) with ESMTP id
        20220907090419epcas1p26b6cf1eea4c9b809d73c4aed1d12a1cf~SiKYnynDZ1457814578epcas1p2o;
        Wed,  7 Sep 2022 09:04:19 +0000 (GMT)
Received: from epsmges1p2.samsung.com (unknown [182.195.36.225]) by
        epsnrtp2.localdomain (Postfix) with ESMTP id 4MMxC72Sm3z4x9Q4; Wed,  7 Sep
        2022 09:04:19 +0000 (GMT)
Received: from epcas1p2.samsung.com ( [182.195.41.46]) by
        epsmges1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        8F.C8.11142.19E58136; Wed,  7 Sep 2022 18:04:17 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20220907090416epcas1p12f1b98b307ffe88034a359041bd33bff~SiKVWTAn32916629166epcas1p1O;
        Wed,  7 Sep 2022 09:04:16 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20220907090416epsmtrp1c0c5d3e3ccf817d135f8417ca1f669e5~SiKVVquTX3015830158epsmtrp1V;
        Wed,  7 Sep 2022 09:04:16 +0000 (GMT)
X-AuditID: b6c32a36-9a3ff70000002b86-3e-63185e91ebdf
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        44.BD.14392.09E58136; Wed,  7 Sep 2022 18:04:16 +0900 (KST)
Received: from localhost.localdomain (unknown [10.253.101.71]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20220907090415epsmtip2c5d4db52c9a68556a7f4b16ccaf7bc0d~SiKVL-93M1266712667epsmtip2E;
        Wed,  7 Sep 2022 09:04:15 +0000 (GMT)
From:   Seunghui Lee <sh043.lee@samsung.com>
To:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Seunghui Lee <sh043.lee@samsung.com>
Subject: [PATCH] scsi: ufs: core: Fix return value to determine power mode
 restore
Date:   Wed,  7 Sep 2022 18:39:35 +0900
Message-Id: <20220907093935.27957-1-sh043.lee@samsung.com>
X-Mailer: git-send-email 2.29.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrIKsWRmVeSWpSXmKPExsWy7bCmnu7EOIlkg5YZihbd13ewWSw//o/J
        ounPPhYHZo+PT2+xePRtWcXo8XmTXABzVLZNRmpiSmqRQmpecn5KZl66rZJ3cLxzvKmZgaGu
        oaWFuZJCXmJuqq2Si0+ArltmDtAiJYWyxJxSoFBAYnGxkr6dTVF+aUmqQkZ+cYmtUmpBSk6B
        WYFecWJucWleul5eaomVoYGBkSlQYUJ2xrGJv5gLprNXvF52kKWBsZmti5GDQ0LAROLwzugu
        Ri4OIYEdjBI/nmxihnA+MUq8ev+aEcL5xijRd3wiUIYTrOP0/oOsEIm9QC2LpkJVfWaU2NY1
        mwWkik1AS2L6pi1MILaIgJXEr5WfwbqZBTQkXjZMYAOxhQVCJG7P+MkIYrMIqEpMn7aRFcTm
        Baq/sf4nO8Q2eYk/93uYIeKCEidnPmGBmCMv0bx1NtitEgLL2CV27JjLCNHgIrF3xStWCFtY
        4tXxLVCDpCRe9rdB2cUSbf/+Qb1TIXGw7wuUbSzx6fNnRlDAMAtoSqzfpQ8RVpTY+RtiPLMA
        n8S7rz2skLDjlehoE4IoUZZ4+WgZE4QtKbGk/RbURA+J0x8/gbUKCcRKzD3RxTqBUX4Wkm9m
        IflmFsLiBYzMqxjFUguKc9NTiw0LjOCRmpyfu4kRnNa0zHYwTnr7Qe8QIxMH4yFGCQ5mJRHe
        lB0iyUK8KYmVValF+fFFpTmpxYcYTYHhO5FZSjQ5H5hY80riDU0sDUzMjEwsjC2NzZTEefW0
        GZOFBNITS1KzU1MLUotg+pg4OKUamNYnSEmcUb+ne3jipncm0WYq7pEX+76eWqnxp7lm5Zq/
        y7Mkn21w/fH2dtqZR8tWz5mwRIzXbsGqRSzHD79c+H1P5q6Y0C7mh7v9Jfa9W/7/Cv/U0JXf
        P1+f7i8qvZFBYep0Ndn09XUVFSLBiyRuVyYoTMk6f1Brju6nk+Y7ZJakbfp2XnEZf17krkVP
        Hu5fNJXFLiH497dHaTMaIxIW5f00PHZxne3ylzz9e+rZw7ZduTzhiNej/182blRtDE7Yt3vV
        6zqjA25XOeVmywU+MGMUnMq0K/XvrIn3Sn8VK7fX92fmz7+nN+WeysXNr/++bgptjCj4qMvP
        p3Dh4RGxWa7Xvy64ZF95hW3LyvnTgoNY7yqxFGckGmoxFxUnAgBIHlLo9AMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprALMWRmVeSWpSXmKPExsWy7bCSvO6EOIlkg6kfWS26r+9gs1h+/B+T
        RdOffSwOzB4fn95i8ejbsorR4/MmuQDmKC6blNSczLLUIn27BK6MYxN/MRdMZ694vewgSwNj
        M1sXIyeHhICJxOn9B1m7GLk4hAR2M0rc+7eEHSIhKbH40UOgIg4gW1ji8OFiiJqPjBIL/5xk
        AalhE9CSmL5pCxOILSJgI3H060RWEJtZQEPiZcMEsAXCAkESu/e8AqthEVCVmD5tI1gNr4CV
        xI31P6F2yUv8ud/DDBEXlDg58wkLxBx5ieats5knMPLNQpKahSS1gJFpFaNkakFxbnpusWGB
        YV5quV5xYm5xaV66XnJ+7iZGcKBpae5g3L7qg94hRiYOxkOMEhzMSiK8KTtEkoV4UxIrq1KL
        8uOLSnNSiw8xSnOwKInzXug6GS8kkJ5YkpqdmlqQWgSTZeLglGpg2vap7XHwTJkLiQtKJ12N
        W3XDqYv/1/STnSZTj+06N9H78I9bAf/ucKrF6QtJvVMVuPDuE7vW7od+84LeFlbbZCbdCH93
        9+erwtTiAk+2Yw4bmgJNm29NX9skmmTtV+r2p/1kp9983sLcS+XVEcrF08PjN+zd9dXtmsCp
        aJfK5/vLoirY2EwVGXc/LX6saJuqtOLU5cnV37rX+V6105A229xzc738DeZjHk/2PnvgcNrs
        xqWWBqaq3tmy80/k8UR7pF79tqK+xEVxnUKDzswT1hMqaoybe15+Sws/cH2u3HarzWo/1z4I
        7Lr5423T688KN075Xl7t/e/k2wMXuiJPPvC5evHGpLlunfsUbmSeu6TEUpyRaKjFXFScCAA4
        5XvkowIAAA==
X-CMS-MailID: 20220907090416epcas1p12f1b98b307ffe88034a359041bd33bff
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: SVC_REQ_APPROVE
CMS-TYPE: 101P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20220907090416epcas1p12f1b98b307ffe88034a359041bd33bff
References: <CGME20220907090416epcas1p12f1b98b307ffe88034a359041bd33bff@epcas1p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

If LINERESET was caught, UFS might have been put to PWM mode,
check if power mode restore is needed.
Once failed to get phy adapter power mode's value,
host can't compare proper mode value.

Signed-off-by: Seunghui Lee <sh043.lee@samsung.com>
---
 drivers/ufs/core/ufshcd.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 7256e6c43ca6..6f20f4655d53 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -6188,7 +6188,8 @@ static bool ufshcd_is_pwr_mode_restore_needed(struct ufs_hba *hba)
 	struct ufs_pa_layer_attr *pwr_info = &hba->pwr_info;
 	u32 mode;
 
-	ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode);
+	if (ufshcd_dme_get(hba, UIC_ARG_MIB(PA_PWRMODE), &mode))
+		return true;
 
 	if (pwr_info->pwr_rx != ((mode >> PWRMODE_RX_OFFSET) & PWRMODE_MASK))
 		return true;
-- 
2.29.0

