Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	UNWANTED_LANGUAGE_BODY,URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EC580C2BBD4
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A4F6023A79
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Dec 2020 07:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726612AbgLRHmn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 02:42:43 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:54622 "EHLO
        mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725895AbgLRHmm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 02:42:42 -0500
Received: from epcas2p1.samsung.com (unknown [182.195.41.53])
        by mailout4.samsung.com (KnoxPortal) with ESMTP id 20201218074159epoutp043623aff01ef6eebdbbb451cbff1dfd98~Rv7Ni6q5t1240812408epoutp04i
        for <linux-scsi@vger.kernel.org>; Fri, 18 Dec 2020 07:41:59 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20201218074159epoutp043623aff01ef6eebdbbb451cbff1dfd98~Rv7Ni6q5t1240812408epoutp04i
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608277319;
        bh=z1Bjcdkf+fSfnSu+EZhpZtPGHVBzMaAyX4Cv7V8fVMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=X9jjWl+lDc4ZZ9WInzHVDk18SUlRmC2EW8x2TlAPeVPR8aA0J2NSIBn83Dhm7MvqX
         3zrsy9/cwYPY64N3cORjyWV0a4sJQklB9HCkzRBQ9r4bqZzQAiX8zDWRPkko4U7jdH
         PiPI4HzPEa/ejOghO4KqcLT6Vle00fu+dS4OBqyQ=
Received: from epsnrtp3.localdomain (unknown [182.195.42.164]) by
        epcas2p2.samsung.com (KnoxPortal) with ESMTP id
        20201218074154epcas2p293cf580a93078d4ddf9bf8ee94419c8e~Rv7JGUyx21566415664epcas2p22;
        Fri, 18 Dec 2020 07:41:54 +0000 (GMT)
Received: from epsmges2p2.samsung.com (unknown [182.195.40.191]) by
        epsnrtp3.localdomain (Postfix) with ESMTP id 4Cy15q0WStzMqYkj; Fri, 18 Dec
        2020 07:41:51 +0000 (GMT)
Received: from epcas2p4.samsung.com ( [182.195.41.56]) by
        epsmges2p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        A9.76.56312.E3D5CDF5; Fri, 18 Dec 2020 16:41:50 +0900 (KST)
Received: from epsmtrp1.samsung.com (unknown [182.195.40.13]) by
        epcas2p1.samsung.com (KnoxPortal) with ESMTPA id
        20201218074144epcas2p1dfe10a239993fec0c9998f367a029c51~Rv6-sTmUK2036320363epcas2p1A;
        Fri, 18 Dec 2020 07:41:44 +0000 (GMT)
Received: from epsmgms1p1new.samsung.com (unknown [182.195.42.41]) by
        epsmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20201218074144epsmtrp1b72caaf00bcfa3988484605299177b9b~Rv6-ozrB21822618226epsmtrp1T;
        Fri, 18 Dec 2020 07:41:44 +0000 (GMT)
X-AuditID: b6c32a46-1d9ff7000000dbf8-f4-5fdc5d3e6351
Received: from epsmtip1.samsung.com ( [182.195.34.30]) by
        epsmgms1p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        4F.B4.13470.83D5CDF5; Fri, 18 Dec 2020 16:41:44 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
        20201218074143epsmtip13438079a0ac1ef37534ddfb320d3a40a~Rv6-ZhyOB2784627846epsmtip1n;
        Fri, 18 Dec 2020 07:41:43 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [RFC PATCH v1 1/2] ufs: add a quirk for vendor specifics before pmc
Date:   Fri, 18 Dec 2020 16:30:50 +0900
Message-Id: <4fb86180155832d08b4a320fa2153c1b3eb4aa72.1608276380.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608276380.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608276380.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFprLJsWRmVeSWpSXmKPExsWy7bCmha5d7J14g02f+SwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBE5dhkpCampBYppOYl56dk5qXbKnkHxzvHm5oZGOoaWlqYKynkJeam2iq5+AToumXm
        AB2vpFCWmFMKFApILC5W0rezKcovLUlVyMgvLrFVSi1IySkwNCzQK07MLS7NS9dLzs+1MjQw
        MDIFqkzIyTj67htbwXqZiiMbFrA3MF6T6GLk4JAQMJFYcK6ii5GLQ0hgB6PEzmdbmSGcT4wS
        c6+/ZINwvjFK/D6wkR2mY9a6Eoj4XkaJzQtnMEE4PxglTr87wdrFyMnBJqAp8fTmVLCEiMAZ
        JolrrWfBEswC6hK7JpxgArGFBXwkbrdMYwaxWQRUJbo2nACzeQWiJabeOAxWIyEgJ3HzXCdY
        nFPAUmJJH0QvMltCYCaHROtFCwjbRWLp5rfMELawxKvjW9ghbCmJl/1tUHa9xL6pDawgx0kI
        9DBKPN33jxEiYSwx61k7I8ibzEAfrN+lD/GxssSRWywQ5/NJdBz+Cw0IXomONiGIRmWJX5Mm
        Qw2RlJh58w7UJg+JFxMngsWFQDZdXh04gVF+FsL8BYyMqxjFUguKc9NTi40KjJDjbhMjOJ1q
        ue1gnPL2g94hRiYOxkOMEhzMSiK8oQ9uxwvxpiRWVqUW5ccXleakFh9iNAUG40RmKdHkfGBC
        zyuJNzQ1MjMzsDS1MDUzslAS5w1d2RcvJJCeWJKanZpakFoE08fEwSnVwLTy1jfPJUuO/4i5
        tUzmjYoK6xT99862ml/eRj78y+8Q4WdruKzi4uqskyvn3OFi2lyqZ+y1usk8L+dBhdLMRa91
        jl/qaUvUNuWM33meh2liaN2PWbsWRabzHP0l+HHnfxeV9muOkdlPLfwSmdxdit7bVSxRPq3z
        6+7/ufOaXs9Zp+u64Ifzyam5W/fyNyVEmSowTChNbLGvdXEXt1w4a1fjp/zi/TMW6hzecOTg
        vjLWDy/nJ5o/Cqt52NrMwdVceFByZrW2wMWUbc4HZDZqck3Yvz70yo61sa4ct408Dgm7stzh
        X/lEsynE21mWx+H3w/vSAtlr3tl1nE/rnqa2NSn4RG9E5s+dmzL/dArW5SqxFGckGmoxFxUn
        AgBLGhpSMAQAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrKLMWRmVeSWpSXmKPExsWy7bCSnK5F7J14gz8TWCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGUcffeNrWC9TMWRDQvYGxivSXQxcnBICJhIzFpX0sXIxSEk
        sJtR4teuv4xdjJxAcUmJEzufQ9nCEvdbjrBCFH1jlJj+dSETSIJNQFPi6c2pTCAJEYF7TBKX
        JsxlBkkwC6hL7JpwAqxIWMBH4nbLNLA4i4CqRNeGE2A2r0C0xNQbh5kgNshJ3DzXCRbnFLCU
        WNIH0SskYCFx/2c3Ey7xCYwCCxgZVjFKphYU56bnFhsWGOallusVJ+YWl+al6yXn525iBMeE
        luYOxu2rPugdYmTiYDzEKMHBrCTCG/rgdrwQb0piZVVqUX58UWlOavEhRmkOFiVx3gtdJ+OF
        BNITS1KzU1MLUotgskwcnFINTEztZy3P32BYWzjPKdDyPWNOY4VU9tmktxvmPZX1CzwudTAu
        VrppvkStbF3xB/Wmmcyb+a1aWdJOXFCrmjXhS5+xsOpUcc0bU8s/GJyfZBpf1vozZ+O3ayuW
        X5RRuaOWVzX96amMRRZN3nMlutYoXrjyaZXwdI06ozLP7V+sX5VMiradPHPBd2PHoEnqsfwy
        bQw3mosqWdKvCj/oP/2fW1FbqKixaWLLi4v3D5Zxi0co/2JknbNsCevynydTtE1DJiw7UME4
        fea+rLwWldr+jF0etd9f7hXYn3D24XmbC5k+r4UM55w9vl7S8quRi5mMwuMV/RfL5stN9cy4
        GqPtFBHUPykzl+XA4206233klViKMxINtZiLihMBHyhT4fgCAAA=
X-CMS-MailID: 20201218074144epcas2p1dfe10a239993fec0c9998f367a029c51
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201218074144epcas2p1dfe10a239993fec0c9998f367a029c51
References: <cover.1608276380.git.kwmad.kim@samsung.com>
        <CGME20201218074144epcas2p1dfe10a239993fec0c9998f367a029c51@epcas2p1.samsung.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Unipro specification says attribute IDs of the following
thing are vendor-specific values, so some SoCs could have
no regions at the defined address
- DME_LocalFC0ProtectionTimeOutVal
- DME_LocalTC0ReplayTimeOutVal
- DME_LocalAFC0ReqTimeOutVal

The following things should be set considering the compatibility
between host and device, so those values must not be fixed and
could be reset values or vendor specific values
- PA_PWRMODEUSERDATA0
- PA_PWRMODEUSERDATA1
- PA_PWRMODEUSERDATA2
- PA_PWRMODEUSERDATA3
- PA_PWRMODEUSERDATA4
- PA_PWRMODEUSERDATA5

Change-Id: Ifbb55e9ea221156804121c4dedb3a099ce02cb95
Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
---
 drivers/scsi/ufs/ufshcd.c | 40 +++++++++++++++++++++-------------------
 drivers/scsi/ufs/ufshcd.h |  6 ++++++
 2 files changed, 27 insertions(+), 19 deletions(-)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 92d433d..934d96f 100644
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
+	if (!(hba->quirks & UFSHCD_QUIRK_SKIP_VENDOR_SPECIFIC_BEFORE_PMC)) {
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
index 61344c4..ab7af1d 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -549,6 +549,12 @@ enum ufshcd_quirks {
 	 */
 	UFSHCI_QUIRK_SKIP_MANUAL_WB_FLUSH_CTRL		= 1 << 12,
 
+	/*
+	 * This quirk needs to disable vendor specific setting
+	 * before power mode change
+	 */
+	UFSHCD_QUIRK_SKIP_VENDOR_SPECIFIC_BEFORE_PMC = 1 << 13,
+
 };
 
 enum ufshcd_caps {
-- 
2.7.4

