Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBE31346AFB
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787814237; cv=none; b=qt1K5frtUuHmgfl5siLupCTs3Q9XyW3OioG7S4Hg8SB5kpz7qiVvli4irZD97f0GwG9Z3YvIuuWT0jL6jc7b5Wuun3J4nPbh8M4KdHwCl27yO25iezZ0gV2ABeTyk65RAkztIsrboZT+7AaaYkDtFiGmTpILdV9tCJlxMR7mETE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787814237; c=relaxed/simple;
	bh=3WR3nJZ71sntdLGkiurbZ/vhLxzov9K3d+86+CuSQ7k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orvkdu33pWzPGBqvRQSCZplGMryDLOUfZoKMMYhwZ1VBJfOBmB0mYwfdJyQGVcT2aeAt/FPKGR5wqLWt43LscfaRyTwsYzV5wzSDNImh1+sxoGLYJq8c/8KidQ6kTVE/X4rN4QXzdrBRDhMGddyY+uCP2F2PdT90xhTApEqaqHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=VgL3jLqa; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=UkcqGLHc; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="VgL3jLqa";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="UkcqGLHc"
Received: from pps.filterd (m0279864.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67R6RB5O2144173
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=tBTWWbwGu6f
	yxrPIIks9EpvxG4mNZM9tcUk9IzPtvZY=; b=VgL3jLqaiB2zxikTaCZnSAINTmX
	2LhtLDhcPq/DiHIqg0Vs6kWOg7RmDnQohs9R04jD6xWnCvZsvjx7tfacCgUJoCTk
	JivOjF5fqPTlgF+9QVJX4vnSDFVujl+UEcEAYZwu+mL4SllTaW45GZXqofUWYM1/
	Gl18PgSnn9al8LXIKMQdXWZ3oG3hNWmX/QYecyc5M0X6Cj2wKmHT5M/xEnhG+SD1
	319c3ZONLFx8u7nZtB/ULa0jmWeng+b63WKEgWqjzkL2RNEYFGsl0MA8u3DVNAxg
	I+flijSzYGX/wuLO59rMzsdNc9FFZ42dnZSjSxUU7z9i79aMBM3GLpstPGQ==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gab7t1384-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 07:03:54 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-52cd0374265so31908871cf.1
        for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 00:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787814234; x=1788419034; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=tBTWWbwGu6fyxrPIIks9EpvxG4mNZM9tcUk9IzPtvZY=;
        b=UkcqGLHcdK3XnsOu2jxePLbrPmTvbkteojkG7evYgAD9hBvT3LKTiIAMJ7kM9mIdt6
         +37KjLQhip2mB92/N0zUjLhb/MgTPSu4Xa0iH32Knlg6jKYeZOX0Jkhi9LNhg8HeT/BK
         OAeXHbz5gTYNnOTrcaXYcsYwSTRBJ0epUsjhEmkeVegqlGmsBV9kG6ouqsE+gEaClvQ/
         PZNKtfhkNeoscmXgeyhXu9nJp25mbJcg/ETrayLQ4FjbDmoQ6na4StmwYqjeco5bMtje
         uz4Mm4EATWjItELg/GRSCg6bD/pxj2ndVWf5N2sXQx/HfR0WkNjWkSfD8SXxPzBLBJ8O
         EtwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787814234; x=1788419034;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=tBTWWbwGu6fyxrPIIks9EpvxG4mNZM9tcUk9IzPtvZY=;
        b=oICXuQ9+GrRBg2uHUw2AOLTRv+gHFW3EX+9tRzhk9NzjqC7pBcQA7+MgvA0GWWZkCT
         GyYWdPhH9q5LVUE6d0XACfoEUkm8lSgjJglkxRmrL28a3ykGIWYToVWgGaPrMTE2NpsA
         JRCX/KNYIxAz7lYxn/akXaV25/mNrBt/D4tjn7XBCeS0of9+GbQyFIuHWD4f1QqaZE1x
         3bB7J8NKMMgG9oTqex4dHxsneIcNT56/5i8fXeVcG6z0nx2a0z8aLzZWkPVYKAhFjXx0
         Qaea8cG5wEBoeye28rmDQsljtj1G081i+Mjy4Fzh9MlXxyT+6V6Af4ktftmmK/gS8lPN
         kdGQ==
X-Gm-Message-State: AFuF++n+lVf6Whoi0IQeCb8hgA6Rpt0barYwx9e9TquNKrngqgkpNnnZ
	gqiwO8H2B7jCRUsEx2whPbkmz5DQ83vA1Vw/Y+3HD/v5kF0OfQR6tVAP7yuLC8WoiK7zXEXgaR9
	9vxMTf6I7A/EDWuBWzceNG+Vn4ADg4QG8sTydYFa3hFHK0ZQm5LpZ4rJy6fQPfTjV
X-Gm-Gg: AR+sD110pZhELOVgMKDHIM/4brOk5utQedRGbrF5Mh9ykrisHCeiITBP8oyjrGkBu/P
	ViJo1J7Exwmr3iqV8o7xAs17hkBqczk0BeHnvC0xgJccPGcResCrNxlSwPcIujoaj5IL9kdXdhS
	kpxELlMlaEotdQ2LMoNr6TG44CDO+MEB7JV6t/fIR+2mfc/Li68wN7RARFVqOpx4NJTqaIGa+04
	2KyXfpfPOryqjXRIoruBRnceHcg66ZvusC8R27uGyRt8E+zHJB12EhdNjeyNY08GruuO4UerV0H
	GEb9SJxgeQjdrprWiHIr4fwrA/m12pUlzRLONMh1/C16vsYhhPvz4M8YnuOPBPa53lOMumDyWIZ
	1KHzgRbIHGoE5EL8hDu3Lp30AL/7jmMbsPisSgFLDKTypZc3Msw==
X-Received: by 2002:a05:622a:408c:b0:52e:3a51:6fd2 with SMTP id d75a77b69052e-52e424270c9mr153497131cf.31.1787814234051;
        Thu, 27 Aug 2026 00:03:54 -0700 (PDT)
X-Received: by 2002:a05:622a:408c:b0:52e:3a51:6fd2 with SMTP id d75a77b69052e-52e424270c9mr153496551cf.31.1787814233583;
        Thu, 27 Aug 2026 00:03:53 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b0d263dd5sm28306585e9.1.2026.08.27.00.03.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Aug 2026 00:03:51 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, beanhuo@iokpp.de,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        beanhuo@micron.com, can.guo@oss.qualcomm.com,
        sumit.garg@oss.qualcomm.com, jenswi@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org
Subject: [PATCH v4 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
Date: Thu, 27 Aug 2026 09:03:35 +0200
Message-ID: <20260827070345.2853821-2-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
References: <20260827070345.2853821-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=X6Bi7mTe c=1 sm=1 tr=0 ts=6a8fe15b cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=DJpcGTmdVt4CTyJn9g5Z:22 a=EUspDBNiAAAA:8
 a=w0io_FmA1e-6CLxyNa8A:9 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-ORIG-GUID: LU91X7jb_7TBu7b1y8Ioxm2jYOXiLwwU
X-Proofpoint-Spam-Info: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfX//zl9RqEZEfN
 n8Y3R4eYtqW4kV1SnARZiB5D0x/9LhcjJoXF+YVtchtcn/o0PfuVfQlRSIODVq+Q1ndttDbAbzt
 nBSseR8oAj2uEOcalIdKYpjtluoZZgQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODI3MDA1NiBTYWx0ZWRfXwKAvFIdpqyXq
 EjRm+9gUk0nAQiNptD06ZBD5a9FwjcIIabJWKY6cO11oZiNT3Fv2ErOFOWGk7FMbFH4GgKDz7E6
 DSMX1UF0J+e8LP9osx/gl2P0eDWEJJRonL1vM327ocHOK7Ih15wESVOrmh6vD2Utyv50/p1UuVs
 6HvFDJSxVVkP9J/P+eZcV6F38uiPMsuqklVkGT5MSvoQaVNVBdJ1f65/yb5QLLqOQwNtwmHFd5d
 YEBy2Bt4/RNqF1HTTebhgyUlylqzLHbou5Fon43vWcfaQYx4qGUCjymhUVCL26LQdnTtIgh+kIW
 MUBc9WvIvHjohYcrMk5RQkvgBpHXLGyzyFf1UJna2ETObUWRNyNC6DCD0BZf84FRIS0ykz9W8sP
 eFrRZY9NUiKb4+5vnPm8AlF4iR3HnVLo1U0qNchX0FNQmLZvQ5E9JE8rRrOVdmnui8hDp2Z8thb
 pyghH8gkAgtxOPMjMZg==
X-Proofpoint-GUID: LU91X7jb_7TBu7b1y8Ioxm2jYOXiLwwU
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-27_03,2026-08-26_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 lowpriorityscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1015
 priorityscore=1501 suspectscore=0 spamscore=0 phishscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608270056

After a power cycle, the first command sent to any UFS logical unit
completes with CHECK CONDITION reporting a power-on UNIT ATTENTION.
The SCSI core surfaces this condition to the caller rather than
retrying it.

For the RPMB well-known LU the first command after boot is the first
RPMB frame, and RPMB has no earlier, guaranteed access that could clear
the condition beforehand. The power-on UNIT ATTENTION therefore reaches
RPMB and fails that first frame, breaking RPMB on every cold boot.

The RPMB WLUN needs the power-on UNIT ATTENTION to be retried so that
RPMB works from the very first access after a power cycle.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-rpmb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9..79e6cd2b20a0 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -21,6 +21,7 @@
 #include <linux/unaligned.h>
 #include "ufshcd-priv.h"
 
+#define UFS_RPMB_UA_RETRIES		3	/* Retries for the power-on UNIT ATTENTION */
 #define UFS_RPMB_SEC_PROTOCOL		0xEC	/* JEDEC UFS application */
 #define UFS_RPMB_SEC_PROTOCOL_ID	0x01	/* JEDEC UFS RPMB protocol ID, CDB byte3 */
 
@@ -40,6 +41,22 @@ struct ufs_rpmb_dev {
 static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
 {
 	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,	/* power on, reset, or bus device reset occurred */
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = UFS_RPMB_UA_RETRIES,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.failures = &failures,
+	};
 	u8 cdb[12] = { };
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
@@ -48,7 +65,8 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 	put_unaligned_be32(len, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-				buffer, len, /*timeout=*/30 * HZ, 0, NULL);
+				buffer, len, /*timeout=*/30 * HZ, /*retries=*/0,
+				&exec_args);
 }
 
 /* UFS RPMB route frames implementation */
-- 
2.54.0

