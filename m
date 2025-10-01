Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E018C2DA743
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 11:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318716; cv=none; b=TSmYxnltDVSftJPPxRda3JuoqskcuzqB1A7TtCR82htZtWLHQWSty8QpVWA0KFa6VwIsgxjNk2M6i2CabMUdZ12W2FRniUgUP96pYOa6MrBUcqb8h0vlgQui8Yqj9ONQbSd2BDnCGctw0eRqMbE/x43iYzb1bNXcHXGDBAF/bos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318716; c=relaxed/simple;
	bh=L4Cyw3GgF6Au8o6Hny+g4N/DoHBQ9SVqEs390lXRzGI=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=Jcc1z5KDpq3hVyuZZMqbf8afct59PrfNeOmbRsDxkG2DyP/BITW54Xf3+K4VCXrcI40PlCHlUfrFlvi08mwVmyGm7Y7MEj0/3pCx/jKgNMoU68sFFvxyZ0334AtHmOKD7QQh4P1W6SPVX6JJvYQE8+BrWLdDtkXbKEt1wQU/UyI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=WVuelvFh; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="WVuelvFh"
Received: from pps.filterd (m0279863.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5917pueL027982
	for <linux-scsi@vger.kernel.org>; Wed, 1 Oct 2025 11:38:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	7yE6v5/M6wV7yegUaBo1axPJLG+xPn73fkfkm/kPY/U=; b=WVuelvFh3tCC8Hra
	AiJBSdi/mvjV/CsWFQiyLIo6iWkbpFnBxkvi7W5CgSlVOgA5drSDoxdBQQ1172yy
	pbOO/pGs/ENmxJwbCQHw2Nr5okuv8gGruorxJYg+PZ236po6EDqB0tCxKv5aCCVX
	IzTkVzKfgILAE1d9Mt5buu2FWmnxs1csOba6Dvd8KqML4gIU+EN0pTc3zsXN0Jfv
	V0PZtEqqTBlLx7qwcLw4V4I4Xs6wnDvqgKw63VETEBXzIL9LWY5MYrzUeg12I0B+
	61cmV0JkRQWd9MI7/yfxxW1ODql1QCYNigkU2FctJt7abgE9WJTcWL2dirLjFf8t
	ZR9dqA==
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com [209.85.216.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49e851meuw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 11:38:34 +0000 (GMT)
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-32edda89a37so6486972a91.1
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 04:38:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318713; x=1759923513;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7yE6v5/M6wV7yegUaBo1axPJLG+xPn73fkfkm/kPY/U=;
        b=Gitf/5FZ7+TkOop95kGlWeuChQl1znE/+FRkZOwlpWaP+WGsp9t7okHm973d1PoX+e
         JWaAsAMXz2sD2w5O9GlNJdcenlC1wFZEo9Zq2/qy70D4Hptv7XitokXkh7M6d6QUuYS6
         r2h2xTD13LV7Ok//SxoLHPiMEG+KGBl/RPSv9wcKPTmn0ogPW8VygR1AwzjaetkbEbx9
         g2WBge+qMkumNoMfXsjtRYZm9cyLqKh/uCdlx8zeLXGm0snas9guJLuDkNQ7PdFk820S
         ysPuMQmAG/XF9kMD/wv0zwL1BtE6a5NwGUg+IwGm10CdvMIm2ZiZ+s7tBqhggJRwL+Un
         0mgA==
X-Forwarded-Encrypted: i=1; AJvYcCXh5TsZfFT/IHqRpS28GF/EYg0lGPx+ghnPQufug3W/+msIK3pJsr6QSpI6RMrAH7tes+Znw1dgAyzH@vger.kernel.org
X-Gm-Message-State: AOJu0YxbXAn4jLF74TaDZEAv/bbxX2j2Vl+OAY308HDF/R9QpIH/F+fT
	3xZLLLjMxNEbbOxcVUQ9GkrDZUKGywco5ujs98zZsdS/jx8q998B49WIK/QOgXZqhm9MqEZnVEW
	aoiArXJOSjeZi1qrl4HXkPC5oMuyno9FiYimF/2QQMPrPYweUko7t2+1jLWYSA8I1
X-Gm-Gg: ASbGnctMq1Fw6kRZ9bB3JUkHrYFkVmhLVn0hJgLVAx0cyxs6cG+ahnTSyY6vX5RCyxg
	YtLlvcLrjol9hYlqVgZnEKmeG8CDjTqlKnGKwVVaQgmZ9IVwdwbDDsuwQayVgRxgo74NFjNx/Ea
	4o3zWQGx8YOGUM+/XkQ0sIoJm7ZPNgbZ0ZPpNk9T6OcW12PhSV6MwJWcQzwwD0ifGuWflO3VFXz
	M6G5NeFEKRKXqhgYY5w1lp+03i5B0BXUbbDSQElw4rU7T2XYClEmU0qdfMhhnleGFyVELMjVUCP
	XWR2rH2GyKPeD/gqHxQK0iPemr4BQYnpdqNsvY0VZohAylVLA2VaWTuu6LEI9TpWlGdLITYwFJM
	fRNoWz0c=
X-Received: by 2002:a17:90b:4ad1:b0:32e:9f1e:4ee4 with SMTP id 98e67ed59e1d1-339a6f2e7e2mr3962095a91.17.1759318713119;
        Wed, 01 Oct 2025 04:38:33 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHIxwvyET/Ieuj5Ju7O5ebre8+IpT9Z4SrRxpt+5+Pe+dnBwvtlu0iBKTtKy6pMTTWKEO/JIg==
X-Received: by 2002:a17:90b:4ad1:b0:32e:9f1e:4ee4 with SMTP id 98e67ed59e1d1-339a6f2e7e2mr3962059a91.17.1759318712660;
        Wed, 01 Oct 2025 04:38:32 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3399ce47d7csm1861646a91.10.2025.10.01.04.38.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 04:38:32 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Date: Wed, 01 Oct 2025 17:08:20 +0530
Subject: [PATCH 2/2] ufs: host: scale ICE clock
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251001-enable-ufs-ice-clock-scaling-v1-2-ec956160b696@oss.qualcomm.com>
References: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
In-Reply-To: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Authority-Analysis: v=2.4 cv=OJoqHCaB c=1 sm=1 tr=0 ts=68dd12ba cx=c_pps
 a=RP+M6JBNLl+fLTcSJhASfg==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=5PmQtxlypCO8_UJlTPUA:9
 a=QEXdDO2ut3YA:10 a=iS9zxrgQBfv6-_F4QbHw:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI3MDAzMiBTYWx0ZWRfXzFpqKe9L/FcX
 Ruhjp0jUDVPDk4e6vy3di8T0B58IJ1xJ0O9Apv/ObNt+tjICZmVL5FYIAQ7VizAO+1Fr6k3P7wZ
 H0TZ9fgtmtw7idApAdvfAk5TNQAqgT5+JCkzs9zex4pKRd5UqNu+tjQxQLlCVQyQQ1gyHU72dkC
 8VnouLXWNNVJAWKSF2jCNRocJk/S5rq4Q72aK88jIZp6v5lXkZiqTJe0Ar31eBIhTtmls9UDIz8
 Q6jcAcFCmKMAnGTH/Z0dQupn4a92Oa3A/y3tV5CVKCzjFFXvez4RFmL4G826rOsxUT489cfU9Pb
 X8BaFyL+a2hj2SoUpM8wDdULGFA+gWTEZfRfuhJxtjoxKP+ERqgSH3rm+sGGpEmLpNIiG1B1XJE
 adqP+x8EkowOggPYgiUVOuDisiEf4g==
X-Proofpoint-ORIG-GUID: pvhHuBqmd7I5ETCxsCBqzXJljVmi5J1l
X-Proofpoint-GUID: pvhHuBqmd7I5ETCxsCBqzXJljVmi5J1l
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 adultscore=0 priorityscore=1501 bulkscore=0 impostorscore=0
 suspectscore=0 lowpriorityscore=0 phishscore=0 malwarescore=0 clxscore=1011
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509270032

Scale ICE clock from ufs controller.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
 drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
 1 file changed, 14 insertions(+)

diff --git a/drivers/ufs/host/ufs-qcom.c b/drivers/ufs/host/ufs-qcom.c
index 3e83dc51d53857d5a855df4e4dfa837747559dad..2964b95a4423e887c0414ed9399cc02d37b5229a 100644
--- a/drivers/ufs/host/ufs-qcom.c
+++ b/drivers/ufs/host/ufs-qcom.c
@@ -305,6 +305,13 @@ static int ufs_qcom_ice_prepare_key(struct blk_crypto_profile *profile,
 	return qcom_ice_prepare_key(host->ice, lt_key, lt_key_size, eph_key);
 }
 
+static int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
+{
+	if (host->hba->caps & UFSHCD_CAP_CRYPTO)
+		return qcom_ice_scale_clk(host->ice, scale_up);
+	return 0;
+}
+
 static const struct blk_crypto_ll_ops ufs_qcom_crypto_ops = {
 	.keyslot_program	= ufs_qcom_ice_keyslot_program,
 	.keyslot_evict		= ufs_qcom_ice_keyslot_evict,
@@ -339,6 +346,11 @@ static void ufs_qcom_config_ice_allocator(struct ufs_qcom_host *host)
 {
 }
 
+static inline int ufs_qcom_ice_scale_clk(struct ufs_qcom_host *host, bool scale_up)
+{
+	return 0;
+}
+
 #endif
 
 static void ufs_qcom_disable_lane_clks(struct ufs_qcom_host *host)
@@ -1636,6 +1648,8 @@ static int ufs_qcom_clk_scale_notify(struct ufs_hba *hba, bool scale_up,
 		else
 			err = ufs_qcom_clk_scale_down_post_change(hba, target_freq);
 
+		if (!err)
+			err = ufs_qcom_ice_scale_clk(host, scale_up);
 
 		if (err) {
 			ufshcd_uic_hibern8_exit(hba);

-- 
2.34.1

