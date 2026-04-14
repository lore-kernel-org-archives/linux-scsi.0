Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 940233C2761
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776159116; cv=none; b=uj27BUTmnzHlnuH38s9qtheDo3Y5wBgzUc62YT6XqNVyJPeU5Kw280LBQ0dOuMzfXd/EGfacaF4FMxIxHpGls4/SyJXq5yDXcDUw+vuriw/sxo1CI3n+ucPiyf5+8Q/nz4cK4ywuFRj5XoYFvg3uG4drnA9XcuRSKJ29g6cTgcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776159116; c=relaxed/simple;
	bh=rz5+GoubMhAQGVFxb80Ed4CW4c9+EipbDJvn3lW9Fcc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sJuEwkPwq6I1UNnWiywszvMitz9SmhV8bgcRvRZ6b0yLNMzm0X27vL7IjVyrSewdX6DQ8H3yrPYm2g1GGZDIE9+yjvsy6QqCIosbQdqOVQ03hd7Qk6wn/96j6R1ci/Ajtasfvs1+lPaeirUr9eq5Aytsllm4ny0sbCSpeDBKgjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=XXPBsaxs; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=kC7Nmjg3; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="XXPBsaxs";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="kC7Nmjg3"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63E64KAE395771
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=IFe+vV5UrZO
	2TbK2XUaK/lXdSgZTCas250r6F207btA=; b=XXPBsaxs4wzSeq+zdrYABNNlQdV
	9wrIyDTi2xaD/ATnjdaVLK+JRnElu9k0I+f8e7c3TgBUrEuajwpI3+WNq1Ruzcqa
	8PdVC2tCdb4s3TP67gHpzsMJEEhfV5qtwhuxMxRpORWY3d5YcF97qG5CPABnZsVu
	GihQIWXF6p9OrJWn1/X26OQZ8zKQBOHzttHZ9cN/YATpIPaDkioUVP2enT7YUBD3
	AUr+fS9kdR93soJ5ta2eokMBYcevCZmceBuWM16yzTgJp57jH0saIDGvXjalCIy9
	VmclvPF1hoagrA3kVOrtsjSz9/aJfZvxOvYTvU6a/fqszRusN7KIDclLPFQ==
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com [209.85.210.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dh870t3y6-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 09:31:54 +0000 (GMT)
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-82cd9fa609aso3375373b3a.3
        for <linux-scsi@vger.kernel.org>; Tue, 14 Apr 2026 02:31:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776159114; x=1776763914; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFe+vV5UrZO2TbK2XUaK/lXdSgZTCas250r6F207btA=;
        b=kC7Nmjg3GVSdpZqLpOHmuEvruyj2UzqKbem9Z+nwLIdACEIwNF6N/Z4xi4p1JULyrE
         woiOVZO1EG+yuketehwDIHxojOitQh+B2QBxv0RrpQosSjKhC1ZU/zPa7le0JanwLhPv
         7bZrYxkkgwGai+sh0N4VaQOnw1YCtgAPswuHvNPIjcthkDmbnZbo6R6Zvl35moYG80Ag
         i+c1LxJKauAvaCDmkcaqmYgKUrSvkaDo1+0LWggnLjDyJ1Z673d0/rGVegHrVGvG9eNo
         U0xCHQuCEV0KKpND80HGBuMK3kl2XcySa3PbHdVpWcOhREMRlf6AXGtCf2HpqeHV4hma
         i/6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776159114; x=1776763914;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IFe+vV5UrZO2TbK2XUaK/lXdSgZTCas250r6F207btA=;
        b=HGoEBaSZHZ3f72sE9fTd5Ib5zz9B+gcrEfhb89QzKC5R6jsagDDcfIHwqQo4ObhBvt
         UZH14tlLe2E1xmDrA2/MydYRKs/cs8zjRSbFwqO9Phkq1QT++xxcOT4uLt0ia5rc6IlU
         5ZvWn02ttr0LFqHUvWhz0kt8ygArq6UTZPPQyA6FmwYIpcGld7KFq+4bI93G4FAaVoUr
         GoZY3EEkeTGNUoT2s9+zMwKuc5LwmWxZtCwHp76PoZL+wgkdnDMpph/5zIO3yjweURqs
         PESjVwMh/UxxI2xKHqgAXuJCFXTUbEDmN/+SPvSeYDsYu1vLAMNB1xrSsu2AeGv35pEL
         qJYw==
X-Forwarded-Encrypted: i=1; AFNElJ9ssCDBBikDnpqbQmLpH/KGBaIfXn2UMeSInlQVdRblLeWQ2+wv664uBoSli7xMkjZ8EEUCzoEx7W/M@vger.kernel.org
X-Gm-Message-State: AOJu0Yzdp+FUBuVLv+w8FvqWNtnPRrv14YuT2RzdHau3H0YEzyiqeYFy
	Ya9O0VQUzp0uUuZCMmhpIlhNXNYCenQ160AEc5u1aoEB2bGUagpnpvpPhb4ziICeSzkchZH607l
	ZVRCNUooTLpek/GT12OjdbDTkC0clLcJxaamK37sjb7zD7gufxYv5Uam2I53q7v/Z
X-Gm-Gg: AeBDietkmCWIY5dXTfhyY/IyIHX6652TLPw18OS+EZylfuxE4FCQKG6GIIS//oBM5/k
	j+P9OCXf42+Fhj1GLTrXK1o3d/Ar7AdR4ggRUuNhtHiyzMh7SZQ9xGkWmp4d4KvPy1naxo7o+N8
	Trls1/+X8Vkq1TQroYoLpeVn70Ckew2R7aF8sWfIRzq9gjonl0CMNeYp9Jyr57biiCjoRVuWv1h
	K20Yajx5DeAL3fFR3GqW5NopxKGmN5whMruqChx49sfzkdzLuLvYN7tjQaYWBLZqntfnROyluB9
	fWCIoyuQLSB6OaLAX8m/Y+FqG14tkyhRcpQlBZpTgdFxxma4oDOilqxGF5GFE+QDO1h9UdvjcTQ
	j+g72KFkJ/Il1cc7s+CU12Vq2xxR9vtyFd1Py7XekgVy2hC7MCJ3uIA==
X-Received: by 2002:a05:6a00:12dd:b0:82c:215d:5e9d with SMTP id d2e1a72fcca58-82f0c2f73a5mr17278347b3a.32.1776159113549;
        Tue, 14 Apr 2026 02:31:53 -0700 (PDT)
X-Received: by 2002:a05:6a00:12dd:b0:82c:215d:5e9d with SMTP id d2e1a72fcca58-82f0c2f73a5mr17278315b3a.32.1776159112947;
        Tue, 14 Apr 2026 02:31:52 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c35194asm17321642b3a.20.2026.04.14.02.31.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 02:31:52 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, bvanassche@acm.org,
        shawn.lin@rock-chips.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V3 1/2] ufs: core: Configure only active lanes during link
Date: Tue, 14 Apr 2026 15:01:34 +0530
Message-Id: <20260414093135.660725-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
References: <20260414093135.660725-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: 9Uzo6vrq3BCua4ZPrk-8dZYoAzmqZ43a
X-Proofpoint-GUID: 9Uzo6vrq3BCua4ZPrk-8dZYoAzmqZ43a
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE0MDA4OCBTYWx0ZWRfXyyBGedoxM4OZ
 A0V8zrLit6lchaSiQiJjBboUGnArXn947NLT5b+Hn27aQDH6boBk+3///uXHg/vsmg6EiEl4Xqs
 THEKDadWsaSVrKsfMa8vG8FOMdzLGt1JClLYkUETdoC0COaSEBuZoQALMKnA+iWFmi8UGYDSGhb
 waqi7oqE8qHntu7KLqpQNLLQSJ1kTTwCBxHwMT5QPZ7Cu+Uc7Mq0xrPbCW7w2S6VM4oRDRDt+gm
 sJhPoETTGI+FwxwJHHdX6XsQo5SMbKO6FVqy9YBK5y48tD7b9meMid5VfIgV18n2JSwrHufsKkh
 6IqL7qQtW178fmRsSmpa3UGYm2gc4og84MMt/jLD8JxKvjC0RyU1+ZWjYPUgTsRSJsrphzKznPO
 Eq3zvgToKcQ9wzfgthQ6Ath4v3Yk75P+IIQUAuTkD5rjm2b7hFtzMRUbY0g0hHCbewIRAklzUMY
 zN0dqP400SqCy9HtSZw==
X-Authority-Analysis: v=2.4 cv=MK9QXsZl c=1 sm=1 tr=0 ts=69de098a cx=c_pps
 a=rEQLjTOiSrHUhVqRoksmgQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=Z8YMyZzXpU5RQDwMThsA:9 a=2VI0MkxyNR6bbpdq8BZq:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-14_02,2026-04-13_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 lowpriorityscore=0 priorityscore=1501 adultscore=0
 clxscore=1015 suspectscore=0 spamscore=0 bulkscore=0 malwarescore=0
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2604070000
 definitions=main-2604140088

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of connected lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, Add a check during link startup to ensure that only the lanes
actually discovered are considered valid. If a mismatch is detected,
fail the initialization early, preventing the driver from entering
an unsupported configuration that could cause power mode transition
failures.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 37 +++++++++++++++++++++++++++++++++++++
 1 file changed, 37 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..754bf4df3016 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,38 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int ret;
+	int val;
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDTXDATALANES),
+			     &val);
+	if (ret)
+		goto out;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Tx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+		goto out;
+	}
+
+	ret = ufshcd_dme_get(hba, UIC_ARG_MIB(PA_CONNECTEDRXDATALANES),
+			     &val);
+	if (ret)
+		goto out;
+
+	if (val != hba->lanes_per_direction) {
+		dev_err(hba->dev, "Rx lane mismatch [config,reported] [%d,%d]\n",
+			hba->lanes_per_direction, val);
+		ret = -ENOLINK;
+	}
+
+out:
+	return ret;
+}
+
 /**
  * ufshcd_link_startup - Initialize unipro link startup
  * @hba: per adapter instance
@@ -5108,6 +5140,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
 			goto out;
 	}
 
+	/* Check successfully detected lanes */
+	ret = ufshcd_validate_link_params(hba);
+	if (ret)
+		goto out;
+
 	/* Include any host controller configuration via UIC commands */
 	ret = ufshcd_vops_link_startup_notify(hba, POST_CHANGE);
 	if (ret)
-- 
2.34.1

