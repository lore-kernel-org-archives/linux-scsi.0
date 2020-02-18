Return-Path: <SRS0=T7Zk=4G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5CA5C34031
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:31:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E0F624656
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Feb 2020 23:31:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="QULgfRnJ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727958AbgBRXbe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Feb 2020 18:31:34 -0500
Received: from mailout3.samsung.com ([203.254.224.33]:31811 "EHLO
        mailout3.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727872AbgBRXbe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Feb 2020 18:31:34 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout3.samsung.com (KnoxPortal) with ESMTP id 20200218233132epoutp03da31edd06a2d2c6418ab57235fec4d46~0oxfqMuWV0181501815epoutp03F
        for <linux-scsi@vger.kernel.org>; Tue, 18 Feb 2020 23:31:32 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20200218233132epoutp03da31edd06a2d2c6418ab57235fec4d46~0oxfqMuWV0181501815epoutp03F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1582068692;
        bh=cslYReSBZapLvI8+zdNz1kqUOSzc1BYGq+fmYlUJMLg=;
        h=From:To:Cc:Subject:Date:References:From;
        b=QULgfRnJo6wyBXrptf+iWzmIXx8n068zjuKUwk0HBohCEIuQex30CrFrIzSwnZlyd
         71vPONsbm2JWquuXsjnKNdsQO1xOG51PWFpTNyClbSSWscr27BQxCuUObYy+w59rjY
         2016ZgaEIkmAauUNaBtFnsHxPE5JDSU+uVxutDlg=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20200218233130epcas2p46da2798ffa110bed538196cb8203009f~0oxeDKGoj1767017670epcas2p4m;
        Tue, 18 Feb 2020 23:31:30 +0000 (GMT)
Received: from epsmges2p4.samsung.com (unknown [182.195.40.190]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 48McYr2XlyzMqYkf; Tue, 18 Feb
        2020 23:31:28 +0000 (GMT)
Received: from epcas2p2.samsung.com ( [182.195.41.54]) by
        epsmges2p4.samsung.com (Symantec Messaging Gateway) with SMTP id
        9F.AB.17960.FC37C4E5; Wed, 19 Feb 2020 08:31:27 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTPA id
        20200218233124epcas2p3888d2788d42af542cde915df4c4baf23~0oxYRdlC63158431584epcas2p3m;
        Tue, 18 Feb 2020 23:31:24 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200218233124epsmtrp226bd9d60064b67f908e8764e8b2e26f5~0oxYOGYZ92398423984epsmtrp21;
        Tue, 18 Feb 2020 23:31:24 +0000 (GMT)
X-AuditID: b6c32a48-0f5ff70000014628-8a-5e4c73cf297b
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        51.72.10238.CC37C4E5; Wed, 19 Feb 2020 08:31:24 +0900 (KST)
Received: from tiffany.dsn.sec.samsung.com (unknown [12.36.155.63]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20200218233123epsmtip1a667a3cedc671b232c5e9d6fba354997~0oxX-vgpX1769717697epsmtip1j;
        Tue, 18 Feb 2020 23:31:23 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH] ufs: fix a bug on printing PRDT
Date:   Wed, 19 Feb 2020 08:31:15 +0900
Message-Id: <20200218233115.8185-1-kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.14.2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrBKsWRmVeSWpSXmKPExsWy7bCmme75Yp84g82NbBaLbmxjsri55SiL
        Rff1HWwWy4//Y3Jg8Ziw6ACjx8ent1g8+rasYvT4vEkugCUqxyYjNTEltUghNS85PyUzL91W
        yTs43jne1MzAUNfQ0sJcSSEvMTfVVsnFJ0DXLTMHaKWSQlliTilQKCCxuFhJ386mKL+0JFUh
        I7+4xFYptSAlp8DQsECvODG3uDQvXS85P9fK0MDAyBSoMiEnY0m7XsESzooT1z8xNTA+Ye9i
        5OSQEDCRaDz3lbmLkYtDSGAHo8TxOefYQBJCAp8YJdaeVoRIfGOUeD7pLCNMx8S1SxkhEnsZ
        Jf5O+QfV/oNR4vHhBrC5bAKaEk9vTmUCsUUEAiTunNrDAmIzC6hL7JpwAiwuLGAg0TrjDlg9
        i4CqRFvjXWYQm1fAUmLdyltQ2+Ql3i+4D7ZNQuAhq8Si0wuhDneRWHtnHVSRsMSr41ug4lIS
        n9/tZYOw6yX2TW1ghWjuYZR4uu8fVIOxxKxn7UA2B9BFmhLrd+mDmBICyhJHbkHdySfRcfgv
        O0SYV6KjTQiiUVni16TJUEMkJWbevAO11UOiY2UvNORiJSa2LmOZwCg7C2H+AkbGVYxiqQXF
        uempxUYFJshxtIkRnIq0PHYwHjjnc4hRgINRiYf3wEXvOCHWxLLiytxDjBIczEoivN7iXnFC
        vCmJlVWpRfnxRaU5qcWHGE2BgTeRWUo0OR+YJvNK4g1NjczMDCxNLUzNjCyUxHk3cd+MERJI
        TyxJzU5NLUgtgulj4uCUamCc2bSudnd1aufufcc3nc1guJ2btOjH27PbddvYVZk1Q/c0M/97
        nrbk4LMWg7vbWp5fmSTcq2x/Zuu9moD7hq0ywnPrVoQ+2rSk89Pr0OyihvOlygbnvYpUNvnc
        j2BJnb25lvfR8x1uM1L4VJzCxaOeik+4IT5HXG9fZvKUsu91WY6sF7oPTJyrxFKckWioxVxU
        nAgAfbFxBVsDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFvrOJMWRmVeSWpSXmKPExsWy7bCSnO6ZYp84g01n2CwW3djGZHFzy1EW
        i+7rO9gslh//x+TA4jFh0QFGj49Pb7F49G1ZxejxeZNcAEsUl01Kak5mWWqRvl0CV8aSdr2C
        JZwVJ65/YmpgfMLexcjJISFgIjFx7VLGLkYuDiGB3YwSv/o3sEAkJCVO7HzOCGELS9xvOcIK
        UfSNUWLW/etg3WwCmhJPb05lArFFBIIk/i75BNbMLKAusWvCCbC4sICBROuMO2D1LAKqEm2N
        d5lBbF4BS4l1K29BLZCXeL/gPuMERp4FjAyrGCVTC4pz03OLDQsM81LL9YoTc4tL89L1kvNz
        NzGCg0NLcwfj5SXxhxgFOBiVeHgzznvHCbEmlhVX5h5ilOBgVhLh9Rb3ihPiTUmsrEotyo8v
        Ks1JLT7EKM3BoiTO+zTvWKSQQHpiSWp2ampBahFMlomDU6qB0U/G+f5zKzMlk9Xc/6LaT8jp
        LzP3SOt3zdqw6UbwHHlDzeJ+aYb252asx/eEbblXHWu56G6hjao1v8zCfWp11bz7Zyce8D/g
        1lYb839NVZ/A82v/ZRdEKjjJhktZrUx/xjDx8Q0BYY/K9atuJgSkd4sofFI4LJPNsoCZR1Mo
        0jvct7rE8b4SS3FGoqEWc1FxIgCy20M/CgIAAA==
X-CMS-MailID: 20200218233124epcas2p3888d2788d42af542cde915df4c4baf23
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20200218233124epcas2p3888d2788d42af542cde915df4c4baf23
References: <CGME20200218233124epcas2p3888d2788d42af542cde915df4c4baf23@epcas2p3.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

In some architectures, an unit of PRDTO and PRDTL
in UFSHCI spec assume bytes, not double word specified
in the spec. W/o this patch, when the driver executes
this, kernel panic occurres because of abnormal accesses.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f4aa10fdbb0c..94c4a0f9fd9b 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -462,8 +462,12 @@ void ufshcd_print_trs(struct ufs_hba *hba, unsigned long bitmap, bool pr_prdt)
 		ufshcd_hex_dump("UPIU RSP: ", lrbp->ucd_rsp_ptr,
 				sizeof(struct utp_upiu_rsp));
 
-		prdt_length = le16_to_cpu(
-			lrbp->utr_descriptor_ptr->prd_table_length);
+		if (hba->quirks & UFSHCD_QUIRK_PRDT_BYTE_GRAN)
+			prdt_length = le16_to_cpu(lrbp->utr_descriptor_ptr->prd_table_length)
+				/ sizeof(struct ufshcd_sg_entry);
+		else
+			prdt_length = le16_to_cpu(lrbp->utr_descriptor_ptr->prd_table_length);
+
 		dev_err(hba->dev,
 			"UPIU[%d] - PRDT - %d entries  phys@0x%llx\n",
 			tag, prdt_length,
-- 
2.14.2

