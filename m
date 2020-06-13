Return-Path: <SRS0=9DJi=72=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDD31C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA1AE2078A
	for <linux-scsi@archiver.kernel.org>; Sat, 13 Jun 2020 03:04:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="Clu3Hz5T"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726520AbgFMDEz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 12 Jun 2020 23:04:55 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:10116 "EHLO
        mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726490AbgFMDEv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Jun 2020 23:04:51 -0400
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
        by mailout1.samsung.com (KnoxPortal) with ESMTP id 20200613030449epoutp01f8ef8a80d9f4f8c6e40f72ae7a9310e7~X_3i7E9NB3225232252epoutp01B
        for <linux-scsi@vger.kernel.org>; Sat, 13 Jun 2020 03:04:49 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.samsung.com 20200613030449epoutp01f8ef8a80d9f4f8c6e40f72ae7a9310e7~X_3i7E9NB3225232252epoutp01B
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1592017489;
        bh=8GKVEUkWRCQ4oEzg+kXJtv/h4uSMVZoIRkh5wQhVTwY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Clu3Hz5T6fZqG68FpAK9ymuG7FPRKkk2/jonrGSlmv/xnMPIVQN6L1B5uxvf2ZSRU
         wva3aGh4uaQIHxkysULzx6nCATXaSHMuZdO+kJk3mLCH8OLzJor4i7vLq2FY5Ve1sv
         N7f+aIjkuhYmF8LA50g/x++uOIi+XFvgTbB7feII=
Received: from epsmges5p1new.samsung.com (unknown [182.195.42.73]) by
        epcas5p1.samsung.com (KnoxPortal) with ESMTP id
        20200613030448epcas5p1a923f0c2380822095392145f40db6615~X_3iX2cY_1950519505epcas5p1I;
        Sat, 13 Jun 2020 03:04:48 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
        epsmges5p1new.samsung.com (Symantec Messaging Gateway) with SMTP id
        67.ED.09467.05244EE5; Sat, 13 Jun 2020 12:04:48 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
        epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
        20200613030447epcas5p4ef2db2121851bdd251d2fd19b3532bb1~X_3hOnmFH1361613616epcas5p4h;
        Sat, 13 Jun 2020 03:04:47 +0000 (GMT)
Received: from epsmgms1p2.samsung.com (unknown [182.195.42.42]) by
        epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20200613030447epsmtrp2a858df4346984dbc984b38971d204984~X_3hNxANF2362123621epsmtrp2v;
        Sat, 13 Jun 2020 03:04:47 +0000 (GMT)
X-AuditID: b6c32a49-a29ff700000024fb-80-5ee44250bcc4
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
        epsmgms1p2.samsung.com (Symantec Messaging Gateway) with SMTP id
        11.C4.08303.F4244EE5; Sat, 13 Jun 2020 12:04:47 +0900 (KST)
Received: from Jaguar.sa.corp.samsungelectronics.net (unknown
        [107.108.73.139]) by epsmtip2.samsung.com (KnoxPortal) with ESMTPA id
        20200613030445epsmtip281234a0cb0717d87937a9195599c8ba5~X_3fUuOK70568705687epsmtip2V;
        Sat, 13 Jun 2020 03:04:45 +0000 (GMT)
From:   Alim Akhtar <alim.akhtar@samsung.com>
To:     robh@kernel.org
Cc:     devicetree@vger.kernel.org, linux-scsi@vger.kernel.org,
        krzk@kernel.org, avri.altman@wdc.com, martin.petersen@oracle.com,
        kwmad.kim@samsung.com, stanley.chu@mediatek.com,
        cang@codeaurora.org, linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kishon@ti.com, Alim Akhtar <alim.akhtar@samsung.com>
Subject: [RESEND PATCH v10 05/10] scsi: ufs: add quirk to fix abnormal ocs
 fatal error
Date:   Sat, 13 Jun 2020 08:17:01 +0530
Message-Id: <20200613024706.27975-6-alim.akhtar@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200613024706.27975-1-alim.akhtar@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFupkleLIzCtJLcpLzFFi42LZdlhTQzfA6UmcwZfnChYP5m1js3j58yqb
        xaf1y1gt5h85x2px4WkPm8X58xvYLW5uOcpisenxNVaLy7vmsFnMOL+PyaL7+g42i+XH/zFZ
        /N+zg91i6dabjA58Hpf7epk8Nq3qZPPYvKTeo+XkfhaPj09vsXj0bVnF6HH8xnYmj8+b5Dza
        D3QzBXBGcdmkpOZklqUW6dslcGVsOvKDraCdr2L95YvMDYxnuLsYOTkkBEwk5s1eygxiCwns
        ZpR4fUO/i5ELyP7EKHHi0hdGCOczo8TDz0dYYTru7D7PDJHYxShxcsdhJoj2FiaJrh0FIDab
        gLbE3elbwOIiAsISR761MYLYzAIvmSR2PQKrERaIkGjd9B5oKAcHi4CqxPT/xSAmr4CNxKP2
        IohV8hKrNxwAO45TwFbi4P8FTCBrJQSmckj8/XafBaLIRWJC/w4oW1ji1fEt7BC2lMTnd3vZ
        QGZKCGRL9OwyhgjXSCyddwyq3F7iwJU5LCAlzAKaEut36UMcySfR+/sJE0Qnr0RHmxBEtapE
        87urUJ3SEhO7u6EB4iExa8lxFkgYTGCUmNldOIFRdhbC0AWMjKsYJVMLinPTU4tNCwzzUsv1
        ihNzi0vz0vWS83M3MYJTi5bnDsa7Dz7oHWJk4mA8xCjBwawkwiso/jBOiDclsbIqtSg/vqg0
        J7X4EKM0B4uSOK/SjzNxQgLpiSWp2ampBalFMFkmDk6pBiaBZyfDTqotigirWnyh2GaDih6P
        77WzOpHWGVZB7A4rFE/OuRC55z3nu2s3gx9EVnYLRMvqV7Vs2zR/JvfOgI0nv108tkb2f2ua
        85wLZ1lOSSWJWYix9ipeX3Fv6Ztp4fOjrL2vvW9+rzh7isR5iaVXeO9ozto4mXFdbpZAEOck
        vVsX7u45/Xr1jIcz2y93dZebL5kb9OTuX7/7M/c33NlxbuX/8rwbzhZmte+8uVvDd29JFRSe
        YMc5sa+YlUsogumtYdTvitMP/NiE3nVWTf/ofrVgcfPJ1qNTTpY9YYlwmRn4eHXun9+VbbXc
        6zgqt10L+7JR4GP6QYMJa8Q6JhiXX0o0WqI/8drtKwfS8kQdlFiKMxINtZiLihMByWbfB5wD
        AAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrDLMWRmVeSWpSXmKPExsWy7bCSvK6/05M4g8cvRC0ezNvGZvHy51U2
        i0/rl7FazD9yjtXiwtMeNovz5zewW9zccpTFYtPja6wWl3fNYbOYcX4fk0X39R1sFsuP/2Oy
        +L9nB7vF0q03GR34PC739TJ5bFrVyeaxeUm9R8vJ/SweH5/eYvHo27KK0eP4je1MHp83yXm0
        H+hmCuCM4rJJSc3JLEst0rdL4MrYdOQHW0E7X8X6yxeZGxjPcHcxcnJICJhI3Nl9nrmLkYtD
        SGAHo8SDVZ/ZIBLSEtc3TmCHsIUlVv57zg5R1MQk8atxDzNIgk1AW+Lu9C1MILYIUNGRb22M
        IEXMAt+ZJA5MmABWJCwQJvFvyhegBAcHi4CqxPT/xSAmr4CNxKP2Ioj58hKrNxwAq+YUsJU4
        +H8B2EghoJLdR3+yTmDkW8DIsIpRMrWgODc9t9iwwCgvtVyvODG3uDQvXS85P3cTIzjAtbR2
        MO5Z9UHvECMTB+MhRgkOZiURXkHxh3FCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeb/OWhgnJJCe
        WJKanZpakFoEk2Xi4JRqYFqwX5vvX9tK7kWpC2PPleQtr2Qtuedi3KGXFhxezyCwxeFD1qMd
        D9q6xaPbM7p4512Wfv6P8b7bmr3n/tzKXajV/KPKQv99md1lxd0h3RueP70V+SQhfD5HSrqL
        fnKZo1uNdWRQoXsGb3Htkx/zdL98mfHoS63wn+b560I3ePiVudiYcguturk2aOUMlolBGZpJ
        W4uvLesT6LUUU7r9ZtsmV1XHTW+EN0f8FCoNN+R9Jpd5NHqhb1pV+YpK8Ze9/ByTol7xXOc5
        r/WWU0TMnr3TUP5iTNvqUKPDHUxMX1zj5vG5rXz69uiKw0tO7QlQztxzj3VL1OvHE94sNu/z
        ZE0u/cISbV9m0j+nk/+QEktxRqKhFnNRcSIA+qeBpN8CAAA=
X-CMS-MailID: 20200613030447epcas5p4ef2db2121851bdd251d2fd19b3532bb1
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
X-CMS-RootMailID: 20200613030447epcas5p4ef2db2121851bdd251d2fd19b3532bb1
References: <20200613024706.27975-1-alim.akhtar@samsung.com>
        <CGME20200613030447epcas5p4ef2db2121851bdd251d2fd19b3532bb1@epcas5p4.samsung.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

From: Kiwoong Kim <kwmad.kim@samsung.com>

Some controller like Exynos determines if FATAL ERROR (0x7)
in OCS field in UTRD occurs for values other than GOOD (0x0)
in STATUS field in response upiu as well as errors that a
host controller can't cover.
This patch is to prevent from reporting command results in
those cases.

Signed-off-by: Kiwoong Kim <kwmad.kim@samsung.com>
Signed-off-by: Alim Akhtar <alim.akhtar@samsung.com>
Reviewed-by: Avri Altman <avri.altman@wdc.com>
---
 drivers/scsi/ufs/ufshcd.c | 6 ++++++
 drivers/scsi/ufs/ufshcd.h | 6 ++++++
 2 files changed, 12 insertions(+)

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index ba093d0d0942..33ebffa8257d 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -4794,6 +4794,12 @@ ufshcd_transfer_rsp_status(struct ufs_hba *hba, struct ufshcd_lrb *lrbp)
 	/* overall command status of utrd */
 	ocs = ufshcd_get_tr_ocs(lrbp);
 
+	if (hba->quirks & UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR) {
+		if (be32_to_cpu(lrbp->ucd_rsp_ptr->header.dword_1) &
+					MASK_RSP_UPIU_RESULT)
+			ocs = OCS_SUCCESS;
+	}
+
 	switch (ocs) {
 	case OCS_SUCCESS:
 		result = ufshcd_get_req_rsp(lrbp->ucd_rsp_ptr);
diff --git a/drivers/scsi/ufs/ufshcd.h b/drivers/scsi/ufs/ufshcd.h
index a9b9ace9fc72..e1d09c2c4302 100644
--- a/drivers/scsi/ufs/ufshcd.h
+++ b/drivers/scsi/ufs/ufshcd.h
@@ -541,6 +541,12 @@ enum ufshcd_quirks {
 	 * resolution of the values of PRDTO and PRDTL in UTRD as byte.
 	 */
 	UFSHCD_QUIRK_PRDT_BYTE_GRAN			= 1 << 9,
+
+	/*
+	 * This quirk needs to be enabled if the host controller reports
+	 * OCS FATAL ERROR with device error through sense data
+	 */
+	UFSHCD_QUIRK_BROKEN_OCS_FATAL_ERROR		= 1 << 10,
 };
 
 enum ufshcd_caps {
-- 
2.17.1

