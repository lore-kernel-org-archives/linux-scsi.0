Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 442083D9042
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774602244; cv=none; b=O+e4gjc2TJYeJKEBUJ+RxmxST4jLeuMbTwjFKxSm47BbvF12qInsiaTkHMaT9wfitj2TeW7IZCieoiqA3aaAaTUjZAcW+BEhY8KI+O1L5YMbOZXa0YBS5c100g452Y+jf4rAohOOo8CUSlb88kwAO9hu53Ofxf+oWONexM6q5Yc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774602244; c=relaxed/simple;
	bh=sijOfDCZP5Ip0DhMoFL0SnSyLmFbSo4NH5UDAkeNO/o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BPaISvtQS9qpwFvO7gFxUhAnHiGJ5fxoPb7Rjddt7y6KLcXoVLyimMmOVUoCuxiggwcWci2pMpXohbPi1h1aZenorSZrWKgM94iD7vMausvwoneSFhBKDKO3gny+S31NoC/9rY1jZWKpVXLZ/08YHHhygMgEc/mq1KeIs7iUMqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=GpObczxi; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=RlpouOA5; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="GpObczxi";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="RlpouOA5"
Received: from pps.filterd (m0279871.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62R6vkQq1749209
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=BsP/Cz6pi3D
	/C1lGz2QDJeYO4Xmqw8Q51D0LRWGF6nY=; b=GpObczxiW+hQHa7sdKWJ6hxVIj6
	vsXcQnWfYqyXxW1+NN1v9Me6FVgaDAyj4TiFtbqnpXyyDd7/BJUlQonMJYaWTGoD
	Iwd4KH0G5LyJxTeI0qDp2oz8zpt451EdFolNJxnEOWh0j9IRWoQd0k4T9hEwvUus
	QO/y+OM4OKt8Tan0Yz67j+as/jWNl8JF0Wp/0WPu/d1Mi/pkBPitZGviZOsu4/gS
	aYiewnbAK5150RdcWfJZWMqomNNNvubxfbMbtw6ws3jkIoYwcpT/5gpWcn+sGb63
	mZqcG4+7FAgTMK4nUQbhRuPu7JeQSQnJm3+dnKHk+zlSd5GPhwM4lCkDa0g==
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com [209.85.216.71])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4d5mn10khm-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 09:04:02 +0000 (GMT)
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-35c0abf427aso277821a91.0
        for <linux-scsi@vger.kernel.org>; Fri, 27 Mar 2026 02:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1774602241; x=1775207041; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BsP/Cz6pi3D/C1lGz2QDJeYO4Xmqw8Q51D0LRWGF6nY=;
        b=RlpouOA5avY7/xsr7P3Ieh+m37SWh8eYvgShBCqUwcUW4lMnxfx9PVsVBNram9jrUS
         OZe6UsPVamZO/VpY0tq9TgKb0rCtL+0wuxqoTzkH7Yg4ZJnqYhcUjoH0y/oKB/lPn9F7
         1A28T93b/i3mRVjR/WVHEaYQEVN1n5XMAQGe9GYI9P8rpH9AaRKzsIRHc7GQhyFNmUh3
         hCoQbQN7wEe70iS6DmcT/RfWGggcLpaiN7td4RaeU+iiUYon0XUagv1W2NJ1U2MCNUk4
         oij0l5dKdKFbgx1aC7f9hg+AuSfyXr8TbcYnDE+U2DIV1Mi/VxanNkEOBWHyFlnswaLE
         FbAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774602241; x=1775207041;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BsP/Cz6pi3D/C1lGz2QDJeYO4Xmqw8Q51D0LRWGF6nY=;
        b=QGcJWtqWrPm5acKj8309ggU/AUHsBuLCjzvkWZ1jDIH8JdLQFGvKBnEcbuDFRP0cHi
         Yz6PZBJ31s5hf2Dosmw9vsL6LXs5LaTnS57btdqOYTH920f08p/89EblB4aN6AEEpj4Q
         jSkDZ+HTUJqIjs6z1lbHqpWc8XSnp6Zk7+Hoeoa8UoM5N0x21YjABvgoAyb86qIz2aZj
         89TPA1QmLZzVBjexPBgAbagmZ5cobhR3R66itIAK6FlyC0PXQtslF94q1LKALe+fLJJz
         6QMTyTaOBKy00kpuDNHj+8DkgLIzgB9OAboRRU+nWh2QXvffI152lZ0FysxADzqtsDcm
         x2Wg==
X-Forwarded-Encrypted: i=1; AJvYcCWwcqJjq1A98rVJ5zQvCivPBGZb4E+N3Qr4mqiA8+uXIHaZToG4VzYEc0MAJQlZ3jYkBblAJj2StH08@vger.kernel.org
X-Gm-Message-State: AOJu0Ywpc5sG+ytdLA9GCrwuklVVUFD/8LeyUCAjKVIc9scy0PTLnyAK
	Xy8Mf7c17qkcv4XEH4cQ+4hr8/4LTf5MLLSgU3k3ZOmNQqkt42L5SciycnEi2l4n7txL82L+T4W
	KChiwczHxIV+ohNhGEMxlI009ou6ZV4DC6qB4NvpiRYOe0NEJ0q7plcQIXuJWI8GL
X-Gm-Gg: ATEYQzwGcrKZNa91xQlnzN0W6XOo7riMj9wJEbtWNGRwWqaV5PYsjBDfFZa1qSytagy
	Ik3VaplT/N40407EtbH25hKd/3LR8lmgqDU7BGQDuPRCnbtmjZNSsZnQsokn4d4xqT2gKXsV5Cl
	QY7JkI3DktCrdOwPJYBWt5hjKYzPJXSmAp5ejlURPaiu6i6IdcDjmIGGoWu88OS2sRy1Kge87Tk
	P25U8eNinN36l7wE5x77Wn58s+pA0/ZEBc0RNwl6oQAYbdLDjGaR7SK7HR28gj898rmZqjijEnB
	EIuqoc7Xu8BYFVl25nEOwhSn9h8+WJGl7Q5BReZcHXo3UR3nLtWdkW7qHJ3T9uaut6UXP5NaFsK
	5jqhHl40aNlmVThbH6+8H+2i/uIueL0JR5icvox0/jvbCEWP5meb3Qw==
X-Received: by 2002:a17:90b:2ecb:b0:35c:2c03:430a with SMTP id 98e67ed59e1d1-35c2ff5074fmr1727780a91.4.1774602241049;
        Fri, 27 Mar 2026 02:04:01 -0700 (PDT)
X-Received: by 2002:a17:90b:2ecb:b0:35c:2c03:430a with SMTP id 98e67ed59e1d1-35c2ff5074fmr1727757a91.4.1774602240516;
        Fri, 27 Mar 2026 02:04:00 -0700 (PDT)
Received: from hu-pkambar-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35c22a81744sm4230006a91.5.2026.03.27.02.03.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Mar 2026 02:04:00 -0700 (PDT)
From: palash.kambar@oss.qualcomm.com
To: mani@kernel.org, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com
Cc: linux-arm-msm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, bvanassche@acm.org,
        shawn.lin@rock-chips.com, nitin.rawat@oss.qualcomm.com,
        Palash Kambar <palash.kambar@oss.qualcomm.com>
Subject: [PATCH V2 1/2] ufs: core: Configure only active lanes during link
Date: Fri, 27 Mar 2026 14:33:45 +0530
Message-Id: <20260327090346.656324-2-palash.kambar@oss.qualcomm.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
References: <20260327090346.656324-1-palash.kambar@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzI3MDA2NiBTYWx0ZWRfX1ppJtZhtpWxK
 0taDGQnJGiNCLa3NI6uJTVrfCwfcNPRvhihUVbqUp8cgZbw6PTu9dpmvjSaZf0dwwM9Y8L8leWQ
 EqvhXfCFb2PDUgg3J2cQ6rImtpdXa4sSEgFg22BAJHAJSwTwOhYl2Al5p6Gn6wfpi+eBtg2emx1
 aQpIZp1HJ6hQ+cqlz6UPheR0PGSTB8LoB5k+5sbkXNtT21gIbSVvAYeIVUTXCjMgnqmXwo0DK/z
 UhhHTPin52tbWr3yFKXBQcx0e6SWwirl5UYCf0CfAO4+O4mhBHFMXL+rGM4915qMOtRkPPeLIpH
 ugU3Hyu2bpognKyfGZ3NtO+iCMgAWmZx4EftFkFDYffQTSJO0TbQFjj3Us+KTcbxz2euy4soYdG
 Jiia+NFPlGeqGt1wgDazXUJmViZqKHUXmSiGnvr+DKVC1OzYMRrlzpjeD4FUcddlQb+3hlwJ472
 te98MA7yG/97a1Ezsdw==
X-Authority-Analysis: v=2.4 cv=CcwFJbrl c=1 sm=1 tr=0 ts=69c64802 cx=c_pps
 a=UNFcQwm+pnOIJct1K4W+Mw==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=Yq5XynenixoA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=3WHJM1ZQz_JShphwDgj5:22 a=EUspDBNiAAAA:8
 a=Z8YMyZzXpU5RQDwMThsA:9 a=uKXjsCUrEbL0IQVhDsJ9:22
X-Proofpoint-ORIG-GUID: k-FOS_1f4wziea4r85BxKHHDIZCzrOMW
X-Proofpoint-GUID: k-FOS_1f4wziea4r85BxKHHDIZCzrOMW
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-03-26_04,2026-03-26_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 spamscore=0 malwarescore=0 adultscore=0 lowpriorityscore=0
 bulkscore=0 impostorscore=0 priorityscore=1501 clxscore=1015 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2603050001 definitions=main-2603270066

From: Palash Kambar <palash.kambar@oss.qualcomm.com>

The number of connected lanes detected during UFS link startup can be
fewer than the lanes specified in the device tree. The current driver
logic attempts to configure all lanes defined in the device tree,
regardless of their actual availability. This mismatch may cause
failures during power mode changes.

Hence, add check to identify only the lanes that were successfully
discovered during link startup, to warn on power mode change errors
caused by mismatched lane counts.

Signed-off-by: Palash Kambar <palash.kambar@oss.qualcomm.com>
---
 drivers/ufs/core/ufshcd.c | 39 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
index 31950fc51a4c..cc291cae79f0 100644
--- a/drivers/ufs/core/ufshcd.c
+++ b/drivers/ufs/core/ufshcd.c
@@ -5035,6 +5035,40 @@ void ufshcd_update_evt_hist(struct ufs_hba *hba, u32 id, u32 val)
 }
 EXPORT_SYMBOL_GPL(ufshcd_update_evt_hist);
 
+static int ufshcd_validate_link_params(struct ufs_hba *hba)
+{
+	int ret = 0;
+	int val = 0;
+
+	ret = ufshcd_dme_get(hba,
+			     UIC_ARG_MIB(PA_CONNECTEDTXDATALANES), &val);
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
+	val = 0;
+
+	ret = ufshcd_dme_get(hba,
+			     UIC_ARG_MIB(PA_CONNECTEDRXDATALANES), &val);
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
@@ -5108,6 +5142,11 @@ static int ufshcd_link_startup(struct ufs_hba *hba)
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

