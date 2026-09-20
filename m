Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A5F033E348
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 14:50:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789915825; cv=none; b=bJ4q8kLBhozrM+v2hG8Mm/n/i4vqzPFH8nSIpDSD/c82d4Xib8aM1o6KtPAW7dlkY5jPdmmm+4kEpyxpofEfOt5JLzFl1zxJ2bRmsmHyBeacRFjznRNtitY+Rv7ofooIx6W8ALq8E0fMYy8TGMNcZuRYFp6gC8AtTD9HKAu8jDE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789915825; c=relaxed/simple;
	bh=rSBd2s2GbA8RgQqK0yq1irXVSiCXr0AhYQt3vqjf/S0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:Cc; b=SNREhp4ZRWyeWBvmLgh1M7O3U0ONfVCLdbNwAhFzLKdRLbJOCaD5TRsVvvOes0L5CBkVx0zDAqSqkiID3zCf8rVaeU+J6AZOLGXrVSBDpH1kNDBc6WuvSySsC1RZ1Lotu81+j3vY0ymfhD8Ak/nP80hklzzHXOQxqxrZIyCDiic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=a+hLQBL/; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=AQZCt5F0; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="a+hLQBL/";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="AQZCt5F0"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68KBoJ6w2762089
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 14:50:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=OJIDGNCPZenBsjdkhMOANH
	T3w06N4To+c623+yxAc8Y=; b=a+hLQBL/shdz+2XVS9mULsK/BONkrBtl5wOJUX
	xQJ1kc7f+TLFUHMn/Il40oF+MFQelBFQS0ggT3yrz29KbhXqpK2yaiZxHNLYlgYg
	9hWQnyV3jnO2oMwIZd41Ktypp0XN7bKJK1Pa5/48u7aAF4lfrkR4HBi/m8stUgVt
	9xASGFakJgrvFIlVZKz1dQEDGL9lNhLdT6Tnm9HmM74GFff1CB2ANzxd7hj9Pcbz
	cmcxrTHSmk8efT3/iKU2qq/595oDghz0cbhXl56IQm87Kq5pZCmuJrD6cAlUbywc
	Gmapoim00M9rdG3MCxYhsjbnVlrpdhzU2sDtX7rU2m8aioRg==
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4gshd63ad5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 14:50:22 +0000 (GMT)
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-93bfb2da664so195589385a.1
        for <linux-scsi@vger.kernel.org>; Sun, 20 Sep 2026 07:50:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1789915822; x=1790520622; darn=vger.kernel.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=OJIDGNCPZenBsjdkhMOANHT3w06N4To+c623+yxAc8Y=;
        b=AQZCt5F0H/qfbX6gadcfULR1dhKtf5SJBS5g62tjMTRweGJQMPsnhIb4SDuECsSFkU
         /fBh/WbrboUp2rv472/oSMkG7BPnjA5pp1EHRA6y8t73sUJ9NFO2kuAkzMkca15awM/u
         WoMez3RQO88CTRBy9nQD0xSkV776laffziZ8WjE8kJ8BlQGTlaXn61/DjV1Dq4zItzrO
         VvOHULFDJ+fUwAReYbd1ArSj2BS+stWzo9748PTFe5YXnfE5knVksqgsm4BxzG2A1kuk
         ESkRhdCdqQVqYlSdMx6oKIQB+Bwnb8bUrnSXIS0Ob9iAKe27GslSLM+yDt96Ifx+9lDK
         rZ3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789915822; x=1790520622;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=OJIDGNCPZenBsjdkhMOANHT3w06N4To+c623+yxAc8Y=;
        b=xiKdFjTsePZzt/6JZH78IPg1OIa6S52yQjYNY76v9h+ox0gmFk+QM6UKHgYoNb8XKj
         hrNSiZoAGYkuTUKjCVrdcEb5ILAu/MUc75YVs0iNkev6XQu0QEDvxOiZgevD3W0k6HKA
         pbTbfgj8ccwJzjO78PWOE00gIAUNuIU3JB6iceHNuyowPECEhzaD75UEfbGlhRiqMWP1
         QmqJrw+zjPWH/bFGy64AyuSO89sPtyi32z9tDzxu2dJiY1FdfBAaqq2Cis2ljB7XT4eY
         j1G2El9m9YnF5NEQ2EahXat7SxlhWSA+XtWxLGsMyAL0Tt8K8+/fKcJ1SOBXH00RxR4t
         8WiA==
X-Gm-Message-State: AFuF++mFhiD3L8tBm+v467BTskG6s3DiR5CzJ51m26tW+K8jjNTLSiD/
	hi7iesre0pUcmN8eazibSUKJQZRD69nXHciCKxIrpYQddawvvnbS7TNk65FA5/z4UGn14ZzvtZ2
	AmaSoNiHQjG1yP0yuyv3eUaID14xmqfqF156MB9/JZl3VxryeV+iZJJn5zkAxErsD
X-Gm-Gg: AYBFou0txk7JrKN3AgJ0YS97OqN5CCryV33MHx4zWNW1DvBu9e9KK2+sY4G+G3Wuid1
	wQFnzJvUwfaVzu8InNNDhE90xOv+3Q4JOtXP6aV+y3LLwBu8MLX7WAW6hyYN+hocOKpKqU7V23y
	lts9EAy+PyFoBReG5YM3F9fIhMonKr6Rl9wZBHH7pB2c4JVfZHVEYRrHlGHOh1PN2ibiGuZ8uHa
	ZT+W5tlNIbBNYpHIzU35olKUM2+sedjTHhUmGkVXmUvK9zqOpFU8Z1aKfBrbdoug8c42DTcO4N8
	4/mfCAQVklcmAucyyAAyQKlkJ+7rZxH1N8RDdQi4Y50LuS2eqjK6VhLPgY+sehE8mJkObq6Qm8X
	wCjNVvpbvksgw4yEcXJ+El5Ygjs0oGotD0bvfcrKT5hqUAng7zPwCpjbOubiFxaSGa0fHTR4q0/
	VJaB59HaCxZ1+C
X-Received: by 2002:a05:620a:2913:b0:93a:2e8:5af5 with SMTP id af79cd13be357-93bf552411fmr582045685a.6.1789915822274;
        Sun, 20 Sep 2026 07:50:22 -0700 (PDT)
X-Received: by 2002:a05:620a:2913:b0:93a:2e8:5af5 with SMTP id af79cd13be357-93bf552411fmr582042085a.6.1789915821819;
        Sun, 20 Sep 2026 07:50:21 -0700 (PDT)
Received: from umbar.lan (2001-14ba-a073-af00-264b-feff-fe8b-be8a.rev.dnainternet.fi. [2001:14ba:a073:af00:264b:feff:fe8b:be8a])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8c9411575sm1085755e87.27.2026.09.20.07.50.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Sep 2026 07:50:20 -0700 (PDT)
From: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Date: Sun, 20 Sep 2026 17:50:18 +0300
Subject: [PATCH] scsi: ufs: rpmb: register and unregister the ufs_rpmb bus
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260920-fix-ufs-rpmb-v1-1-560b842c589d@oss.qualcomm.com>
X-B4-Tracking: v=1; b=H4sIAKnyr2oC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzMDU0ND3bTMCt3StGLdooLcJF0TC/MUc+MUA0vDJHMloJaColSgPNi46Fg
 Iv7g0KSs1uQRkhlJtLQBphXovcAAAAA==
X-Change-ID: 20260511-fix-ufs-rpmb-487d73d091b7
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <mkp@kernel.org>,
        Can Guo <can.guo@oss.qualcomm.com>, Bean Huo <beanhuo@micron.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=1407;
 i=dmitry.baryshkov@oss.qualcomm.com; h=from:subject:message-id;
 bh=rSBd2s2GbA8RgQqK0yq1irXVSiCXr0AhYQt3vqjf/S0=;
 b=owGbwMvMwMXYbdNlx6SpcZXxtFoSQ9b6T6uf7Vm7beO5L3F3nt0Ju6VwI+bazBb+zJCv7IZqf
 JnJEd+0OhmNWRgYuRhkxRRZfApapsZsSg77sGNqPcwgViaQKQxcnAIwkfwUDoYWY27XPxkbz0pv
 y+1c4/s7SfLxzzrr0hnsN48Xzd92KNzqWXD0hv8VmivuMBc9FT66ZpWrzb8W61JBHdUvnNmTv1o
 n6Jfd/9yswbOiga0ttW9Hp84kk/Rm+xLpnMOyrPaTvGoDS9JyeNyFLJU4Be7WvL+7+uoiw6aGOh
 3VzYq9n17Eu9z2irf799xtomgu+9n+rrnzuBevPVH+I7XWyt3wFYNN7WMJhoha931B0+2T/aKa9
 j+uWNbu0+ItrVx4Kkxgpf6Ku9v1D2kJfCuS+/frnWpwgG7nrgXH5z2Z1CSpIW5Zfe5Oqf+Tvvev
 HPga3osnzeG9kDPz9R/+9WeSlsTX3GZ07LOSTl27ebMlAA==
X-Developer-Key: i=dmitry.baryshkov@oss.qualcomm.com; a=openpgp;
 fpr=8F88381DD5C873E4AE487DA5199BF1243632046A
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTIwMDIxNiBTYWx0ZWRfX2LFGTd0Pk2cC
 u8J4nwCci/bDfOTT/XY0QQp8MMolH3QeavY+4s2tL1+7HbKLE1iU0rzqu2Lj7fPq1Z0T3ksDcba
 12BH3rgh0XZVq6/0FvhXLk5oz8Kl62QsJkqAQP8vF4vz4JXFht7hWrIqgJ42V/NA7iD7APxjpiy
 aS/j23opx7iC2aeXCoNebgwKxIUJktyWlodV1H66Jc/OHDo2v7/67lEtJo3gKhx4xHww7pvW5gu
 t54WkadiFK/sfYMII73wEG2Y4q69BsrmcAvonXGc3S3Q1DzSAvrAyvmSvcfSMuokK0pFcOI0GrY
 yCXA8N0WpkQo1oU2PwqMNkb8/livJjT/kxUeBwa/HbogxT6PySpAktX06VA1A5IUU5ZeaARPNRs
 bMOD10mE1JZCUt6SLILNSaj37DuWs5NiOjEh/t1kR/6InKpDO6fVmJpnRK+WcOgUKbKyvX7ylpX
 kyuPGTwAE7NUxxC71bw==
X-Authority-Analysis: v=2.4 cv=RMQmjIi+ c=1 sm=1 tr=0 ts=6aaff2ae cx=c_pps
 a=50t2pK5VMbmlHzFWWp8p/g==:117 a=xqWC_Br6kY4A:10 a=IkcTkHD0fZMA:10
 a=VdqzKS8jKosA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=lT-nI2SPya-u3B85k14A:9 a=QEXdDO2ut3YA:10 a=IoWCM6iH3mJn3m4BftBB:22
X-Proofpoint-ORIG-GUID: T4_8CsJnn9zAnI-vN4wPzfe1ROt3aQyX
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTIwMDIxNiBTYWx0ZWRfX49NQ1MCmgTGZ
 B3DWrom40cD+nu/p/mLYridykIJez2czEPR7ZO/77yGcI4RNPSauw61KMzswWMEwI6IntF4mnKZ
 ebUU+oTTWW2iZ4hYlQrmtBQ0vmvLjQA=
X-Proofpoint-GUID: T4_8CsJnn9zAnI-vN4wPzfe1ROt3aQyX
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-09-20_04,2026-09-16_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 bulkscore=0 impostorscore=0 phishscore=0 priorityscore=1501 adultscore=0
 clxscore=1011 spamscore=0 lowpriorityscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609200216

The ufs_rpmb bus isn't registered in the device framework, so any
attempt to register RPMB devices on UFS will fail with:

 bus_add_device: cannot add device 'ufs_rpmb0' to unregistered bus 'ufs_rpmb'
 ufshcd-qcom 1d84000.ufshc: Failed to register UFS RPMB device 0

Add module_init() / exit() functions to handle bus registration and
unregistration.

Fixes: b06b8c421485 ("scsi: ufs: core: Add OP-TEE based RPMB driver for UFS devices")
Signed-off-by: Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-rpmb.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index 50ef63afd528..8ae917adbc98 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -275,5 +275,18 @@ void ufs_rpmb_remove(struct ufs_hba *hba)
 	dev_info(hba->dev, "All UFS RPMB devices unregistered\n");
 }
 
+static int __init ufs_rpmb_init(void)
+{
+	return bus_register(&ufs_rpmb_bus_type);
+}
+
+static void __exit ufs_rpmb_exit(void)
+{
+	bus_unregister(&ufs_rpmb_bus_type);
+}
+
+module_init(ufs_rpmb_init);
+module_exit(ufs_rpmb_exit);
+
 MODULE_LICENSE("GPL v2");
 MODULE_DESCRIPTION("OP-TEE UFS RPMB driver");

---
base-commit: 3f2425f5b5bbbdd991ca9cdfd5502e68d8895998
change-id: 20260511-fix-ufs-rpmb-487d73d091b7

Best regards,
--  
With best wishes
Dmitry

