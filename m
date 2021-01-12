Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 820A9C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 34A5722D3E
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 03:00:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733223AbhALDAa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 22:00:30 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:36613 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730576AbhALDA3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 22:00:29 -0500
Received: from epcas2p4.samsung.com (unknown [182.195.41.56])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20210112025945epoutp01530075bed1bb0d8a4bb73de8e19c9304~ZXM7gTJ512805828058epoutp01T
        for <linux-scsi@vger.kernel.org>; Tue, 12 Jan 2021 02:59:45 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20210112025945epoutp01530075bed1bb0d8a4bb73de8e19c9304~ZXM7gTJ512805828058epoutp01T
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1610420385;
        bh=MGuh82DX6E5g8HiXvy+a7m1va7hecL227AUSV+OV2l8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=dUonYPBbAZukwUKG29S0wnxAICHF/X9Y/64JEHyQ1NMLt9GgpZXdCJuUMFjX2kiii
         rlmcIazEAzdEtDyu0vx17Y1labrMgxmjwtQmUI7C2W7eMTXwqNnwkLvesdPidoQqwu
         R9G7WZlhl7f+xHoOybBi7bNCFaq3BPfCFJNQwDd0=
Received: from epsnrtp4.localdomain (unknown [182.195.42.165]) by
        epcas2p3.samsung.com (KnoxPortal) with ESMTP id
        20210112025944epcas2p3404bd33fe4cf7086b1867ba67ce3bc7f~ZXM6_oCnL1758617586epcas2p3f;
        Tue, 12 Jan 2021 02:59:44 +0000 (GMT)
Received: from epsmges2p1.samsung.com (unknown [182.195.40.187]) by
        epsnrtp4.localdomain (Postfix) with ESMTP id 4DFFfk12fQz4x9Q4; Tue, 12 Jan
        2021 02:59:42 +0000 (GMT)
Received: from epcas2p3.samsung.com ( [182.195.41.55]) by
        epsmges2p1.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.30.10621.D901DFF5; Tue, 12 Jan 2021 11:59:41 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTPA id
        20210112025941epcas2p2dcdeaa23a2728dd478618b750809e875~ZXM33GTnd1168311683epcas2p2U;
        Tue, 12 Jan 2021 02:59:41 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20210112025941epsmtrp1e051ae040fb7d3cc2c9300733f1fa1aa~ZXM32QU022509325093epsmtrp1J;
        Tue, 12 Jan 2021 02:59:41 +0000 (GMT)
X-AuditID: b6c32a45-34dff7000001297d-e9-5ffd109d46d3
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        9C.32.08745.D901DFF5; Tue, 12 Jan 2021 11:59:41 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20210112025941epsmtip1ecfc9c63cf7be0b36d99a2c5d2a49b50~ZXM3pxClY1202812028epsmtip1R;
        Tue, 12 Jan 2021 02:59:41 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RESEND PATCH v3 1/2] ufs: add a quirk not to use default unipro
 timeout values
Date:   Tue, 12 Jan 2021 11:48:26 +0900
Message-Id: <47f41dc96fe0a4143c2acddb0ce28befb1a60b49.1610419672.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1610419672.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1610419672.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprPJsWRmVeSWpSXmKPExsWy7bCmue48gb/xBu3pFg/mbWOz2Nt2gt3i
        5c+rbBYHH3ayWHxd+ozVYtqHn8wWn9YvY7X49Xc9u8XqxQ9YLBbd2MZkcXPLURaL7us72CyW
        H//HZNF19wajxdJ/b1kc+D0uX/H2uNzXy+QxYdEBRo/v6zvYPD4+vcXi0bdlFaPH501yHu0H
        upkCOKJybDJSE1NSixRS85LzUzLz0m2VvIPjneNNzQwMdQ0tLcyVFPISc1NtlVx8AnTdMnOA
        bldSKEvMKQUKBSQWFyvp29kU5ZeWpCpk5BeX2CqlFqTkFBgaFugVJ+YWl+al6yXn51oZGhgY
        mQJVJuRkzFmylr3gv3TF1ROvWRsYV0h0MXJySAiYSBz9eIW5i5GLQ0hgB6PE3GVP2SGcT4wS
        kxsuM0E4nxkl3l9ayATTsvPHdTaIxC5GidcvZzGCJIQEfjBKXDyXBGKzCWhKPL05FaxbROAM
        k8S11rOsIAlmAXWJXRNOgE0SFoiS2PyuAayZRUBV4u/5JSwgNq9AtMTUZXehtslJ3DzXyQxi
        cwpYSnxe1cuCyuYCqpnJITH/SBdUg4vEhIVNULawxKvjW9ghbCmJl/1tUHa9xL6pDawQzT2M
        Ek/3/WOESBhLzHrWDmRzAF2qKbF+lz6IKSGgLHHkFgvE/XwSHYf/skOEeSU62oQgGpUlfk2a
        DDVEUmLmzTtQmzwkvv+dxAoJLKBNiy50sk1glJ+FsGABI+MqRrHUguLc9NRiowJD5OjbxAhO
        qVquOxgnv/2gd4iRiYPxEKMEB7OSCK/Xhj/xQrwpiZVVqUX58UWlOanFhxhNgQE5kVlKNDkf
        mNTzSuINTY3MzAwsTS1MzYwslMR5iw0exAsJpCeWpGanphakFsH0MXFwSjUwBZ35M2nXm3DF
        G/fXzVFNKHxk1B+0Z/2eyA9JNy3Z7LVksgwSXO+dWyhff/+OC2/ah6chrzaaPLE9FlW0aup3
        hTtu9SVTS/u/++9kdNEQtU6Yx8r6ZnfP49a7y8pcCspXBCyJtBRZekTr6G23uf4Hv+9ftqDY
        5FNfV+Mjx0bD+dciOu27957wvJ1wzP5wpNe3h/8V5M/e83ly3FVq7crTn4UXW6WvvOv0/r+L
        Z+pG1n07PnzNTu2do2Z104rziGlpqElYccUHdtfP+bxWh5d8v/E82j+M2TLB4fmKsLolexaz
        vGQKzz515lS2XR+3TeyVEzt427h/M5/Wn1UeN/u2rbS9w9tbdjqn96zcvXXxPyWW4oxEQy3m
        ouJEAItK8wsyBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrGLMWRmVeSWpSXmKPExsWy7bCSnO5cgb/xBu37RS0ezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGXMWbKWveC/dMXVE69ZGxhXSHQxcnJICJhI7Pxxna2LkYtD
        SGAHo8ScP03MEAlJiRM7nzNC2MIS91uOsEIUfWOUWH7yAViCTUBT4unNqUwgCRGBe0wSlybM
        BetmFlCX2DXhBBOILSwQIbH62VQWEJtFQFXi7/klYDavQLTE1GV3mSA2yEncPNcJ1sspYCnx
        eVUvWI2QgIXEsub9jLjEJzAKLGBkWMUomVpQnJueW2xYYJSXWq5XnJhbXJqXrpecn7uJERwV
        Wlo7GPes+qB3iJGJg/EQowQHs5IIr9eGP/FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeS90nYwX
        EkhPLEnNTk0tSC2CyTJxcEo1MJ2R2yihaNIlsTR+4bkbS/fPtE5fGXZcmFWl/M4M6/uP1s+9
        XllXI+hc/4vxirrLlLnXVHYoTlXMbjxverAy/tCyXTIc2wQnc5esy7ui4H1wfdmR5j2uswsf
        3nst1MGxJedLXYT0L8cjiZvu7WOb+9ukkjkssOfe9Kn5LQfSCqeVOTgJR+x51NN74GDZ4Y7I
        nvmJJY/fiDO4mZ9gF9OI33iMu1PJMW+VpOsdN+HzX5Uv/YyUTXzJraYoMPl642veN3cWcz3Y
        NdujZbd2b+iNliKdlim/Zhz6p7pWqKH0/jZ/iyRl+w27FFlj7LYF3+vRF8x/bROc+LHb6o0I
        6+03i74LtMiuWdmRWVohUXA0SomlOCPRUIu5qDgRADmg2fb5AgAA
X-CMS-MailID: 20210112025941epcas2p2dcdeaa23a2728dd478618b750809e875
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20210112025941epcas2p2dcdeaa23a2728dd478618b750809e875
References: <cover.1610419672.git.kwmad.kim@samsung.com>
        <CGME20210112025941epcas2p2dcdeaa23a2728dd478618b750809e875@epcas2p2.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unipro specification says attribute IDs of the following
thing are vendor-specific values, so some SoCs could have
no regions at the defined addresses
- DME_LocalFC0ProtectionTimeOutVal
- DME_LocalTC0ReplayTimeOutVal
- DME_LocalAFC0ReqTimeOutVal

The following things should be set considering the compatibility
between host and device, so those values must not be fixed and
you could use reset values or vendor specific values
- PA_PWRMODEUSERDATA0
- PA_PWRMODEUSERDATA1
- PA_PWRMODEUSERDATA2
- PA_PWRMODEUSERDATA3
- PA_PWRMODEUSERDATA4
- PA_PWRMODEUSERDATA5

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..9d3a41d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4153,25 +4153,27 @@ static int ufshcd_change_power_mode(struct ufs_hba *hba,
 		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_HSSERIES),
 						pwr_mode->hs_rate);
 
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
-			DL_AFC0ReqTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
-			DL_FC1ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
-			DL_TC1ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
-			DL_AFC1ReqTimeOutVal_Default);
-
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
-			DL_FC0ProtectionTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
-			DL_TC0ReplayTimeOutVal_Default);
-	ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
-			DL_AFC0ReqTimeOutVal_Default);
+	if (!(hba->quirks & UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING)) {
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA0),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA1),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA2),
+				DL_AFC0ReqTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA3),
+				DL_FC1ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA4),
+				DL_TC1ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(PA_PWRMODEUSERDATA5),
+				DL_AFC1ReqTimeOutVal_Default);
+
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalFC0ProtectionTimeOutVal),
+				DL_FC0ProtectionTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalTC0ReplayTimeOutVal),
+				DL_TC0ReplayTimeOutVal_Default);
+		ufshcd_dme_set(hba, UIC_ARG_MIB(DME_LocalAFC0ReqTimeOutVal),
+				DL_AFC0ReqTimeOutVal_Default);
+	}
 
 	ret = ufshcd_uic_change_pwr_mode(hba, pwr_mode->pwr_rx << 4
 			| pwr_mode->pwr_tx);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index 61344c4..f36f73c8 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,12 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk needs to disable unipro timeout values
+	 * before power mode change
+	 */
+	UFSHCD_QUIRK_SKIP_DEF_UNIPRO_TIMEOUT_SETTING = 1 << 13,
+
 };
 
 enum ufshcd_caps {
-- 
2.7.4

