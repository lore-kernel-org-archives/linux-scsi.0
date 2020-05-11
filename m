Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EBFEC54E8B
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A0592184D
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 02:14:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="DoB42yWm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729388AbgEKCOs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 22:14:48 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:34194 "EHLO
        mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729379AbgEKCN4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 10 May 2020 22:13:56 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout2.samsung.com (KnoxPortal) with ESMTP id 20200511021353epoutp02338243c3ab1dda73977b54e85efe9304~N14qDyItc3178831788epoutp02n
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2020 02:13:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20200511021353epoutp02338243c3ab1dda73977b54e85efe9304~N14qDyItc3178831788epoutp02n
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1589163233;
        bh=aZlGHc5xTiWwAyuHWOUJ6KyldBblFcw6DUpelUfBEa8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoB42yWmUyX2kuPqwB4/QQ2eeb5Sdic2W6Av2V8OjbpfQYdNQ4/s7/Phggc50uYl5
         OYb9dsEtehX0MjWHKevQHEI15LOCkL8B2035RpN8RUY2Dt7eB3/mKnoVOLxxr0eM8C
         nZAARzCpy9KjXuhiMhtwYKdJsW/FYorLbGGvQ7Gk=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200511021352epcas5p1c18a8a0ea5dd4d15a0bc11bb5af50383~N14pk_q_C1462014620epcas5p1g;
        Mon, 11 May 2020 02:13:52 +0000 (GMT)
Received: from epcas5p4.samsung.com ( [182.195.41.42]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        27.B5.10010.0E4B8BE5; Mon, 11 May 2020 11:13:52 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200511021352epcas5p4c6f356db30fbd4905d2c8285ae2aabe6~N14o3_dTa2308823088epcas5p4k;
        Mon, 11 May 2020 02:13:52 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200511021352epsmtrp232d42672481326603c70e2d5b753e9aa~N14o2-bLs1467414674epsmtrp2O;
        Mon, 11 May 2020 02:13:52 +0000 (GMT)
X-AuditID: b6c32a49-71fff7000000271a-70-5eb8b4e0ae09
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        7E.54.25866.FD4B8BE5; Mon, 11 May 2020 11:13:52 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200511021349epsmtip2612251130d76d763b1136a148c5aab91~N14mtxlx20183901839epsmtip21;
        Mon, 11 May 2020 02:13:49 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Alim Akhtar <alim.akhtar@samsung.com>
Subject: [PATCH v8 02/10] scsi: ufs: add quirk to disallow reset of
 interrupt aggregation
Date:   Mon, 11 May 2020 07:30:23 +0530
Message-Id: <20200511020031.25730-3-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200511020031.25730-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFmpileLIzCtJLcpLzFFi42LZdlhTS/fBlh1xBot3GVg8mLeNzeLlz6ts
        Fp/WL2O1mH/kHKvF+fMb2C1ubjnKYrHp8TVWi8u75rBZzDi/j8mi+/oONovlx/8xWfzfs4Pd
        YunWm4wOvB6X+3qZPDat6mTz2Lyk3qPl5H4Wj49Pb7F49G1ZxejxeZOcR/uBbqYAjigum5TU
        nMyy1CJ9uwSujG2737EV3OKpmHD8FnMD42WuLkZODgkBE4nbh78wgthCArsZJZZOF+ti5AKy
        PzFKvG97xgKR+Mwo8aE3F6bh6pIVzBBFuxglXj57ygLhtDBJNC+8wAZSxSagLXF3+hYmEFtE
        QFjiyLc2sBXMAjeYJB6sdAGxhQWiJXacXgG2gUVAVeLEslYwm1fARuLTiulsENvkJVZvOMAM
        YnMK2EpMa9gOtkxCoJNDouf3bBaIIheJlRcPQjUIS7w6voUdwpaS+PxuL1CcA8jOlujZZQwR
        rpFYOu8YVKu9xIErc1hASpgFNCXW79KHOJNPovf3EyaITl6JjjYhiGpVieZ3V6E6pSUmdnez
        QtgeEvd/bGWCBMMERonOJedYJzDKzkKYuoCRcRWjZGpBcW56arFpgWFearlecWJucWleul5y
        fu4mRnAy0fLcwXj3wQe9Q4xMHIyHGCU4mJVEeJfn7ogT4k1JrKxKLcqPLyrNSS0+xCjNwaIk
        zns6bUuckEB6YklqdmpqQWoRTJaJg1OqgSnsx+n4bWd3689Na16fvHO1wsmuQxOtuH7XuMTv
        ++ReZPoihmXzY6s9T058iiz03jRHurnqL4va9gjBoJXuThuXx0iX/FtR/vf0g51uT65VPPp1
        6avn7gkCn5ck3Psn/7WPQ+t4bF0cc/vVG63PRdbEn23Zeclt4rLOGytCN9ibTGvc/+EN34HK
        r0Ve67X+mJVZTHq/LycrI2XXhVzzwNV2VoK1fyI3+13dv9dF4t2J/rmb72lmCjFITOfgSTz+
        7+qaBreTi1yqWMXrXu7kz2GU/qGyd457wYbLhil/7jVVGyoe8Ov10tsxvcT/3OlnkhZ7848u
        ttbepeQn0s6+wfDfrLSs/u0b06R8vxUk6uoqsRRnJBpqMRcVJwIABVaw7ZUDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrMLMWRmVeSWpSXmKPExsWy7bCSvO6DLTviDO5vY7R4MG8bm8XLn1fZ
        LD6tX8ZqMf/IOVaL8+c3sFvc3HKUxWLT42usFpd3zWGzmHF+H5NF9/UdbBbLj/9jsvi/Zwe7
        xdKtNxkdeD0u9/UyeWxa1cnmsXlJvUfLyf0sHh+f3mLx6NuyitHj8yY5j/YD3UwBHFFcNimp
        OZllqUX6dglcGdt2v2MruMVTMeH4LeYGxstcXYycHBICJhJXl6xg7mLk4hAS2MEoceHCcSaI
        hLTE9Y0T2CFsYYmV/56zQxQ1MUn8uLaKFSTBJqAtcXf6FrAGEaCiI9/aGEFsZoFnTBKnHpaC
        2MICkRI/9k8BG8QioCpxYlkrC4jNK2Aj8WnFdDaIBfISqzccYAaxOQVsJaY1bAerEQKqmbFp
        M+sERr4FjAyrGCVTC4pz03OLDQuM8lLL9YoTc4tL89L1kvNzNzGCw1lLawfjnlUf9A4xMnEw
        HmKU4GBWEuFdnrsjTog3JbGyKrUoP76oNCe1+BCjNAeLkjjv11kL44QE0hNLUrNTUwtSi2Cy
        TBycUg1MC22mqp3/525ltLDz+Oboo2K1jP7/RbPd6+WZdbkapz07lN683yx46+Iq3zeV1893
        MyxZm+oTJcLdfKRX+qEaT9Z5hll3HC/zinr8MOffIMu2O/pEsxd3yy/LquPLXRqYjjOtP3rv
        R4d+7+Fj5sVyhkUNb4TP5FslNT59/VTWVbiKZcZzS3llE8+rcXur/RPycybP2nBbXktivvUR
        bbErX9U32xr/TOKcuJlPy/IB51xuD5Yp+usjHqq2TZH2PxZ49XwHN0fXMuOm3S7vky6ZvzJa
        uiFv9tXEsA3ulh8dBH51/AptL4u7l/V2WsAUBYtfN3dP/mh9kFFqgezCV216iWqfa4r/x7hU
        2s+s/aPEUpyRaKjFXFScCABTjJeQ1gIAAA==
X-CMS-MailID: 20200511021352epcas5p4c6f356db30fbd4905d2c8285ae2aabe6
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200511021352epcas5p4c6f356db30fbd4905d2c8285ae2aabe6
References: <20200511020031.25730-1-alim.akhtar@samsung.com>
        <CGME20200511021352epcas5p4c6f356db30fbd4905d2c8285ae2aabe6@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Some host controllers support interrupt aggregation but don't allow
resetting counter and timer in software.

Reviewed-by: Avri Altman <avri.altman@wdc.com>
Signed-off-by: Seungwon Jeon <essuuj@gmail.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 3 ++-
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 3655b88fc862..0e9704da58bd 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4884,7 +4884,8 @@ static irqreturn_t ufshcd_transfer_req_compl(struct ufs_hba *hba)
 	 * false interrupt if device completes another request after resetting
 	 * aggregation and before reading the DB.
 	 */
-	if (ufshcd_is_intr_aggr_allowed(hba))
+	if (ufshcd_is_intr_aggr_allowed(hba) &&
+	    !(hba->quirks & UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR))
 		ufshcd_reset_intr_aggr(hba);
 
 	tr_doorbell = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 071f0edf3f64..53096642f9a8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -523,6 +523,12 @@ enum ufshcd_quirks {
 	 * Clear handling for transfer/task request list is just opposite.
 	 */
 	UFSHCI_QUIRK_BROKEN_REQ_LIST_CLR		= 1 << 6,
+
+	/*
+	 * This quirk needs to be enabled if host controller doesn't allow
+	 * that the interrupt aggregation timer and counter are reset by s/w.
+	 */
+	UFSHCI_QUIRK_SKIP_RESET_INTR_AGGR		= 1 << 7,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

