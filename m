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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 666E5C3526C
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 37C5A22B2E
	for <linux-scsi@archiver.kernel.org>; Sat, 19 Dec 2020 03:08:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726231AbgLSDId (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Dec 2020 22:08:33 -0500
Received: from mailout1.samsung.com ([203.254.224.24]:40696 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726177AbgLSDIc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Dec 2020 22:08:32 -0500
Received: from epcas2p2.samsung.com (unknown [182.195.41.54])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20201219030749epoutp01e860b6842c4f287f19b6b6a7adad0dd4~R-1Hfht1c0413604136epoutp01L
        for <linux-scsi@vger.kernel.org>; Sat, 19 Dec 2020 03:07:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20201219030749epoutp01e860b6842c4f287f19b6b6a7adad0dd4~R-1Hfht1c0413604136epoutp01L
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1608347269;
        bh=4NPqsteJIryDu7M4eLZW8ygMzjHf7MP/2qR/UvWbQeQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:In-Reply-To:References:From;
        b=SYJsr8ur0F8P+dS9Iud6pwAEIoyLDTy7W+qRkGpcOErF3F8V53+hhBHmVJL+AdtNv
         8Um6cGH1M55XxQDb720ptE7rowTGFRp6rkEjROxpy0QKXZbpxy7D0DmrTOOBIKnjnZ
         yDPE9Diw6Vo/6LQEiuE0RhLWsW3lfIXZUHbsHtek=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTP id
        20201219030747epcas2p4a361a9ca9a4102077af8c79064167f42~R-1GHwh3F0753307533epcas2p48;
        Sat, 19 Dec 2020 03:07:47 +0000 (GMT)
Received: from epsmges2p3.samsung.com (unknown [182.195.40.188]) by
        epsnrtp1.localdomain (Postfix) with ESMTP id 4CyVz55l3jz4x9Pr; Sat, 19 Dec
        2020 03:07:45 +0000 (GMT)
Received: from epcas2p1.samsung.com ( [182.195.41.53]) by
        epsmges2p3.samsung.com (Symantec Messaging Gateway) with SMTP id
        42.30.05262.18E6DDF5; Sat, 19 Dec 2020 12:07:45 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas2p4.samsung.com (KnoxPortal) with ESMTPA id
        20201219030745epcas2p465db4e50311807fdd1edffa50b0e6eac~R-1D2ea020753307533epcas2p46;
        Sat, 19 Dec 2020 03:07:45 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20201219030745epsmtrp241ae690acc45b92e0e6a140e4f68c29e~R-1D1oaHE0486804868epsmtrp2B;
        Sat, 19 Dec 2020 03:07:45 +0000 (GMT)
X-AuditID: b6c32a47-b97ff7000000148e-fb-5fdd6e8109f9
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        0D.41.08745.08E6DDF5; Sat, 19 Dec 2020 12:07:44 +0900 (KST)
Received: from ubuntu.dsn.sec.samsung.com (unknown [12.36.155.120]) by
        epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20201219030744epsmtip29d8f52753b080f6c9a75dfe626419157~R-1Dj1ViR0913909139epsmtip2m;
        Sat, 19 Dec 2020 03:07:44 +0000 (GMT)
From:   Kiwoong Kim <kwmad.kim@samsung.com>
To:     linux-scsi@vger.kernel.org, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        asutoshd@codeaurora.org, cang@codeaurora.org, bvanassche@acm.org,
        grant.jung@samsung.com, sc.suh@samsung.com, hy50.seo@samsung.com,
        sh425.lee@samsung.com, bhoon95.kim@samsung.com
Cc:     Kiwoong Kim <kwmad.kim@samsung.com>
Subject: [PATCH v2 1/2] ufs: add a quirk not to use default unipro timeout
 values
Date:   Sat, 19 Dec 2020 11:56:53 +0900
Message-Id: <096dc75c11818ad01bd3422cc0c8ba1fa25cde86.1608346381.git.kwmad.kim@samsung.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1608346381.git.kwmad.kim@samsung.com>
In-Reply-To: <cover.1608346381.git.kwmad.kim@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrAJsWRmVeSWpSXmKPExsWy7bCmqW5j3t14g5MdmhYP5m1js9jbdoLd
        4uXPq2wWBx92slh8XfqM1WLah5/MFp/WL2O1+PV3PbvF6sUPWCwW3djGZHFzy1EWi+7rO9gs
        lh//x2TRdfcGo8XSf29ZHPg9Ll/x9rjc18vkMWHRAUaP7+s72Dw+Pr3F4tG3ZRWjx+dNch7t
        B7qZAjiicmwyUhNTUosUUvOS81My89JtlbyD453jTc0MDHUNLS3MlRTyEnNTbZVcfAJ03TJz
        gI5XUihLzCkFCgUkFhcr6dvZFOWXlqQqZOQXl9gqpRak5BQYGhboFSfmFpfmpesl5+daGRoY
        GJkCVSbkZPw69YixYKtMxa0TzxgbGG9LdDFyckgImEj8vH+RvYuRi0NIYAejRNPWZcwQzidG
        id0ftzFBOJ8ZJTq3vmHsYuQAa3neIwMR38Uocf7iXKj2H4wSsyd9ZAeZyyagKfH05lSwbhGB
        M0wS11rPsoIkmAXUJXZNOMEEYgsLBEs8bn/LDGKzCKhKLFr8gw3E5hWIlpjxsIcJ4kA5iZvn
        OsFqOAUsJc70/mREZXMB1czlkLh5+RszRIOLxMEr81khbGGJV8e3sEPYUhKf3+1lg7DrJfZN
        bWCFaO5hlHi67x8jRMJYYtazdrA/mYFeWL9LH+JlZYkjt1gg7ueT6Dj8lx0izCvR0SYE0ags
        8WvSZKghkhIzb96B2uohMXtbIyskgIA2ff28hGUCo/wshAULGBlXMYqlFhTnpqcWGxUYI0ff
        JkZwUtVy38E44+0HvUOMTByMhxglOJiVRHhDH9yOF+JNSaysSi3Kjy8qzUktPsRoCgzIicxS
        osn5wLSeVxJvaGpkZmZgaWphamZkoSTOG7qyL15IID2xJDU7NbUgtQimj4mDU6qByfLeNOa0
        z2Xs85mF9R19m5wDUri9OrYYOT+7nbxzy5Zvr9Y9lltWt8s2VP/C/A0X1gtZr+DumXn+cF+A
        RGcuM4f2oVnaUlcj7nCnN1+0CL4n/u3rHAmNbVHmn3Ou8hW0cwj58n9yVulxFJau8XoxcdJv
        cZ9fRhXTlHOi7p5/ulA95H15zXvpy5I/NVTd2u67PDU/cf/F3bzQXTEi8vvVLLsOZOSFykxt
        2qWgYZ/ybHW7qVflr7mXq956xDGe7bU57vJBpmrPibrWEK9Tti8WzN/nzuepqLLqYvV5/zOH
        D/CnFy/6/873cOKap12uF5ruRKXK+vLp+v7N+HhRYcO7i74dlreKmKZINk6TSJ6txFKckWio
        xVxUnAgACweGbDMEAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsWy7bCSvG5D3t14g3mLrCwezNvGZrG37QS7
        xcufV9ksDj7sZLH4uvQZq8W0Dz+ZLT6tX8Zq8evvenaL1YsfsFgsurGNyeLmlqMsFt3Xd7BZ
        LD/+j8mi6+4NRoul/96yOPB7XL7i7XG5r5fJY8KiA4we39d3sHl8fHqLxaNvyypGj8+b5Dza
        D3QzBXBEcdmkpOZklqUW6dslcGX8OvWIsWCrTMWtE88YGxhvS3QxcnBICJhIPO+R6WLk4hAS
        2MEosXf5fpYuRk6guKTEiZ3PGSFsYYn7LUdYIYq+MUpcffwfLMEmoCnx9OZUJpCEiMA9JolL
        E+YygySYBdQldk04wQRiCwsESlzZ/oQNxGYRUJVYtPgHmM0rEC0x42EPE8QGOYmb5zrBejkF
        LCXO9P5kBLlOSMBCouVZAA7hCYwCCxgZVjFKphYU56bnFhsWGOWllusVJ+YWl+al6yXn525i
        BMeDltYOxj2rPugdYmTiYDzEKMHBrCTCG/rgdrwQb0piZVVqUX58UWlOavEhRmkOFiVx3gtd
        J+OFBNITS1KzU1MLUotgskwcnFINTG4/1/YvNkyWtZ2m/OJp54pfk3gUtK9nZGpoBkydUMxg
        /jFdeSLjztbUlpqNWrZ7Gu60f1ZPmuwk5P7b5+ej+Ys2pTnprdFXPB7WaX3rt2Pp39U7BK4x
        Tf303bBQ43Mt086p+/mEP+ywZiiaP3/2ywNiIWY3P0X53v0ZrC36/oPz3C0OiQtqCj1OVrz8
        7hs0YVMEe/pei21s3/J1zzuxCtaHZyf6b7qkIhz5vuTTSoaoNqYZx9XfKwkkZmkvFjZWDZdQ
        CDs86fK94EXxsl5OmQqSLSKHP/cWXasQnSMTsLH4fkfn4QehJ1RW6m6c0TJBNdDI4zRz8hSJ
        u3GeB+r8Pnx+PuGT08ntE5+4bstYoMRSnJFoqMVcVJwIADSV4Sj2AgAA
X-CMS-MailID: 20201219030745epcas2p465db4e50311807fdd1edffa50b0e6eac
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-Sendblock-Type: AUTO_CONFIDENTIAL
CMS-TYPE: 102P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20201219030745epcas2p465db4e50311807fdd1edffa50b0e6eac
References: <cover.1608346381.git.kwmad.kim@samsung.com>
        <CGME20201219030745epcas2p465db4e50311807fdd1edffa50b0e6eac@epcas2p4.samsung.com>
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

Change-Id: Ifbb55e9ea221156804121c4dedb3a099ce02cb95
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

