Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D34A735CB6B
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773209378; cv=none; b=lNLspilTUJ7rhG9mowh4zsiIiJJ2A5vUuka/r4XqHitCm1isOgv5juNhsegU8KjoPSZNg0+mW/2yZtwcgfLczfc+e2EkvIl4BIJpH5luXtegTVIlX/3PralONn0V8fFU4MVv0Oz+bWRD3lH4hI6ngsHndBkNiSFBaTk9uAK9+Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773209378; c=relaxed/simple;
	bh=L22x1sAmNTPfVGmo45h6OxTwrRURMxryt2366AE58cQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=W4IxUrgdmEUAFUkb2of6l0LggJtZVXiiaPx5/5bE33wMdnkUlbhaLXjAC6eQd6jwjMVH9RzzRBUX7GXn4eCW5NX2IIL5tC3N1ttHaVC/rCtawiLWjhO5UiqstHpduJXRbOBQgUXYozstVbw0V75Zt8Oj0KiXYO2jqWAPTxCvwmo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=csoOCu7V; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=GXDOh0AG; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="csoOCu7V";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="GXDOh0AG"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62B5wjZD3296521
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=wUm1g75HVM1
	ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=; b=csoOCu7Vfb0N5E75cewFMiSAolf
	C9eHGWSZUiiuBMa9f9VA97Xb2UElA3G3Uv8tRbkv3yyOpnkkO6lj1x6KNUhldQDf
	vwbviMiMXfLSCgaqgIrgPcJ+Wq+hxbiCdBPY2LNHv1tRoogbJwApnePSJ1Bcueuw
	XJ+hQMn8Txb8ZvQzQLa/Zk1pxIy7iAFA1gNxax19JKdCFGbeDSVH9oEDgrMRf7R4
	byzoF9VgnKw3iEQXqg9C16q7XkItqDrd2yoy7muIO9k7QZmCLHcSs31gI+S8FkkB
	jEmzFtDR+MxB2Y2Su6y3xdkSgj4OmYMipRSZiCBpVRV7PQ0B5machuSe6pA==
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com [209.85.214.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4ctg1mv7nt-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 06:09:35 +0000 (GMT)
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-2ae6961bff0so422598175ad.2
        for <linux-scsi@vger.kernel.org>; Tue, 10 Mar 2026 23:09:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1773209375; x=1773814175; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wUm1g75HVM1ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=;
        b=GXDOh0AG3Q9LKIA/6pKPlYWJSQ7j5OCgu9bexUMJbPa9bnFYAlY1lCt/1cgkVcVp1L
         FEXr2G0TZytfH0/lbTSMJtYZiK106IqwuwK/V+jUjv56uRVD+KaoVtBxj/aWujUbf+DM
         oBhC/07u4MfhT5R/LNTOGKYIvLGkaK2q76thBMirnekhV68akzE1Sjdp3pkwojCRVl3p
         qv0A6PN+BkDe6hL//S1wge6/gLRWbz5OSTTBvjJx0t5AdyZGaS30Jfo1ASvGo3moBMSv
         UaNFcbuxkHwL9H5y5n5lZ56Xu3ImrYTORreGyW/TOVZNcgakHQwrOKdfOSq78yX3ovfi
         hi8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773209375; x=1773814175;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wUm1g75HVM1ePzrrQoDeo9sTJxG42J2EjNdxBe1uf3c=;
        b=InXhmApRLhs5viz91Dhmn2dSHFnsTRciK/8F6IEgccyKVIfv9sBnnCsuI1YdSbv28W
         8805qGSUDjfTxqByrTj6b4n4klXO6QvBsafXI02yq60SQshloZl8yS3eXjBAKkX0ljZT
         8rm6PYEIJzttXgR6kPOCkIwRExuzYAkbUbbfOe1Sn2rDnup1Fxk1dcl6RoAwLjWf3moY
         Jzs1gXCevZkZ6ElCLEhcLxxOJhXUMJnlm2YdaTtqtgEeAjp3ZpWX8qfE2y0rzFZ8zAPT
         A3uCdk8zYH58NRqbqGWQTx0vWgXFoB1lTNEaQp70aCgNu+AhsSa/tAMKkEySRyHyuzmM
         f7/g==
X-Forwarded-Encrypted: i=1; AJvYcCX3OZ4Mlx+S1U1rK+OWRaJS99zXI50yNYfiaHWaeho6kaQbM7mvv8GUXlxPreFjFzgF+avic55YrmLa@vger.kernel.org
X-Gm-Message-State: AOJu0YwocMuru66pIHTj5iBqR4tJRl0z2rM8cBdicc5v7NmE/KZoUXa4
	wMDQiwdIJjNZSYnLuI0L3Mq0aS+PhQBKAmvm/4WBuaGhake3HM/R/um7jKIV1NPk7m//9a+YjKW
	qDtJEBkOq0KjgbgtmT+AGfZpq/66Est6X1Ot7b22DLkCbYBWYeeeno5VTEOPr5uwx
X-Gm-Gg: ATEYQzygjy8nWxirEK7s0OZ7bGmWKhi2Rg3GK+PYpAOcEZ62jPuZCI58YCvc0ymN5br
	95kkh802uCkdMonxE+9H/oma9sK78+QH1oe8cC0wU9ov5kHpbZDf/WN5Fk6gK337RZiAJyXp43T
	ApYUFXJdabwTNN+k6nuxRJdZQ7UCI9qessZLSX+l/XhL0ydINZLE+tNqQ51ixVJjR8eiRV8Y7U5
	CEJVEXbNtKhwGa5rpnEmA+DkvOK9cNsznk26DPIJpMXsNXn0uCrU4JdOiaHPoNqP8pBwzvM9tMD
	SvEomzEjAl2OuDQ9K7p0zRrI03mtZzavsKejLkZdbD3o9QKgkB+XF88N/xZ9w0Nkd1mRCYmI5+V
	C6R12rwnB2BzN55Bsve70TSmdnkL2U4tZVib2nea/nSo3JuGZd0zoPg==
X-Received: by 2002:a17:902:ea0c:b0:2ae:4732:2859 with SMTP id d9443c01a7336-2aeae769a08mr17357165ad.3.1773209374939;
        Tue, 10 Mar 2026 23:09:34 -0700 (PDT)
X-Received: by 2002:a17:902:ea0c:b0:2ae:4732:2859 with SMTP id d9443c01a7336-2aeae769a08mr17354555ad.3.1773209369679;
        Tue, 10 Mar 2026 23:09:29 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2aeae246fe5sm12433265ad.28.2026.03.10.23.09.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2026 23:09:29 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH v1 2/2] ufs: ufs-qcom: Enable Auto Hibern8 clock request support
Date: Wed, 11 Mar 2026 11:39:12 +0530
Message-Id: <20260311060912.3139257-3-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
References: <20260311060912.3139257-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=YOeSCBGx c=1 sm=1 tr=0 ts=69b1071f cx=c_pps
 a=JL+w9abYAAE89/QcEU+0QA==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=ZpdpYltYx_vBUK5n70dp:22 a=EUspDBNiAAAA:8
 a=gce-7N_bzMkFAa6Kq10A:9 a=324X-CrmTo6CU4MGRt3R:22
X-Proofpoint-ORIG-GUID: _UAjeK9u-i_Z1zfVqK47XnTcRzHoVMu1
X-Proofpoint-GUID: _UAjeK9u-i_Z1zfVqK47XnTcRzHoVMu1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDA1MCBTYWx0ZWRfX2xXnwp7lpL1l
 txZeFW5CZ53NsHzADRNHYMGL+PkldQ606oskr8QadHuH5Yo1rpdSzIzuwRz0q6AUYhDRPBu3hDT
 u5I6y6VORyeIgXwLYXIPsGP4j2sb24D++O5POwrwNIJVSC0R0CgkSnRgO1Qc5ZhJHv78fwf1zDZ
 WKIYNL9epoEocntNgd+lq1A9ja+/AiMlbteD+6CmMMPaGWbL+1JT8W1bC4usMrc4yE0JnBrJ/vm
 ZXhcnxpkShMkhR0+8gX3RQcHad2EEwA8dMy/PemB4F9bGIql8cFwmPhm0YS5RnIyC9tlqaebXlW
 K/1XJS0JfKS/ypzieCDjRPTYsGol3oHObiS582mkSpdwZ6lJTYIgM0J7Swbrm58V4P6cv8tGXQ6
 1Zj1Q+zO9eZmgPsnF5+3VG2BPN5m+6iBCuk1NGSYJz7Uvl+otiqB+RERE7oWeZrz/tybsrH4vsX
 PwuVUuoQ133M1QIVtDA==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 clxscore=1011 spamscore=0 bulkscore=0 suspectscore=0
 priorityscore=1501 malwarescore=0 phishscore=0 adultscore=0
 lowpriorityscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2603110050

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

On platforms that support Auto Hibern8 (AH8), the UFS controller can
autonomously de-assert clk_req signals to the GCC when entering the
Hibern8 state. This allows GCC to gate unused clocks, improving
power efficiency.

Enable the Clock Request feature by setting the UFS_HW_CLK_CTRL_EN
bit in the UFS_AH8_CFG register, as recommended in the Hardware
Programming Guidelines.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 11 +++++++++++
 drivers/ufs/host/ufs-qcom.h | 11 +++++++++++
 2 files changed, 22 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 8ebee0cc5313..0e653b34b00d 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -683,6 +683,14 @@ static int ufs_qcom_cfg_timers(struct ufs_hba *hba, bool is_pre_scale_up, unsign
 	return 0;
 }
 
+static void ufs_qcom_link_startup_post_change(struct ufs_hba *hba)
+{
+	if (ufshcd_is_auto_hibern8_supported(hba)) {
+		ufshcd_rmwl(hba, UFS_HW_CLK_CTRL_EN, UFS_HW_CLK_CTRL_EN,
+			    UFS_AH8_CFG);
+	}
+}
+
 static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 					enum ufs_notify_change_status status)
 {
@@ -708,6 +716,9 @@ static int ufs_qcom_link_startup_notify(struct ufs_hba *hba,
 		 */
 		err = ufshcd_disable_host_tx_lcc(hba);
 
+		break;
+	case POST_CHANGE:
+		ufs_qcom_link_startup_post_change(hba);
 		break;
 	default:
 		break;
diff --git a/drivers/ufs/host/ufs-qcom.h b/drivers/ufs/host/ufs-qcom.h
index 380d02333d38..f19def37c86f 100644
--- a/drivers/ufs/host/ufs-qcom.h
+++ b/drivers/ufs/host/ufs-qcom.h
@@ -228,6 +228,17 @@ enum {
  */
 #define NUM_TX_R1W1 13
 
+/* bit definitions for UFS_AH8_CFG register */
+#define CC_UFS_SYS_CLK_REQ_EN          BIT(2)
+#define CC_UFS_ICE_CORE_CLK_REQ_EN     BIT(3)
+#define CC_UFS_UNIPRO_CORE_CLK_REQ_EN  BIT(4)
+#define CC_UFS_AUXCLK_REQ_EN           BIT(5)
+
+#define UFS_HW_CLK_CTRL_EN	(CC_UFS_SYS_CLK_REQ_EN |\
+				CC_UFS_ICE_CORE_CLK_REQ_EN |\
+				CC_UFS_UNIPRO_CORE_CLK_REQ_EN |\
+				CC_UFS_AUXCLK_REQ_EN)
+
 static inline void
 ufs_qcom_get_controller_revision(struct ufs_hba *hba,
 				 u8 *major, u16 *minor, u16 *step)
-- 
2.34.1

