Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24643D330B
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784151817; cv=none; b=rNwqIoOISbAAkJuq3aVGkEgaIWfrtZg0qAteaJWw5tFQ6BWBiCdMQePpsYFck3IP7qbVq+GKWniwKnMgxTxjk68Bk68+1WLKnVxcleW1tTCm0IApuf7TDsL1dQ2Nd8qjEluEEP5S0vvE+cNB6RHbzUlTNAn64405Ms1migm9lMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784151817; c=relaxed/simple;
	bh=weDWNYsNhzeRZVUpohEom+lFTgbR2QAn7gYrniDBshk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AxETiDTo1aR25UoSKncqZdLdQ2srC0lxNsaydhk/vsq5fp3Kfyf1cNkQYtvLSqQ+2g1LrLC6rUmvxmzy90rL52uXJYaudpDAELmjUGaZFPxT8UE0Ypd3kJUT4TicGR40mG8ET9HXmHjEthaGiqXmj12PDRYDB3nPyKD2+N9Yaf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eE4jgWwI; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=P8XgXYnm; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eE4jgWwI";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="P8XgXYnm"
Received: from pps.filterd (m0279862.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66FKPoR7477698
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=XtgavnUQZV2
	QvtqzUdQVFLJ04q/RXp08/VIYqL3ZGIQ=; b=eE4jgWwIMZy+SpoT2GeGPBr+xsK
	N+QIRqSvkg2ICkfS1j/TDz60zhRV7LkAIvsc9/a6UMTzr8KaUV1B5SjYL3R/+if/
	R4bDXjKD7Rvqtc7Vey+FXNnHYjXUkokKd0aqYDk491gBifjWxxNCnWXCOVvBqjP8
	XaHpVilRIoKl4EqSkQP9HtEZ/oz/JrzgQtX7MpEjETdXFX8iQyiOY7u97Foo8nn4
	BjSs7welwRvbsq3pNd0Ft1WUaKuxG2bxxJrOwUIwct7UnPs6kbpek+etEX82Jvtt
	dU8bfPpQT3P46CvDpMLWwLP58D3/5AVMYkSAjTa/jQSBEiz4KyWPXxDiT/A==
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4feehv8vc5-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 21:43:35 +0000 (GMT)
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-51c07f25de2so32999851cf.3
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2026 14:43:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784151814; x=1784756614; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XtgavnUQZV2QvtqzUdQVFLJ04q/RXp08/VIYqL3ZGIQ=;
        b=P8XgXYnmolG5i2IxfL0BKrT2Wv7cafTjjbRNTx1fJHg7pZv6COHzNWdplsGIDsnRqo
         xTRvgH+RP0divjh3BLqP+cgSH17PBjKxSUgfanHI0TrWgCvRLpWmjnbNhGbh+Dn0/0t9
         PBDs4cufJlXsr4OnvgW5xjziZy60e5CiPtVGchdx2jagTOQXoxfcMIshkSOA2KNxgZo8
         xpjukvdsfek9zTpHQ/DnrRPZMcVa6Jf/syzREjiBKkAnM9s8lyiGL1b/RbNbEagj48xp
         kFQgyw3Of2Y4NYehwjb39pJt33OehS9ceg1cserZ7FqzMXj4ILr6voHIthwsVGPuvGKv
         n/8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784151814; x=1784756614;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=XtgavnUQZV2QvtqzUdQVFLJ04q/RXp08/VIYqL3ZGIQ=;
        b=s0IGFGVA6uwk8GtLUBgjXMzvMLUkPk0jnJmQFU6BE4YTw98IEW8ZJF50GyoWE2VyJY
         oNDksU8HVLOP9NFGFKFvSC3VdaYPUuQy/wizgODfjKf4+x9zvoYk5QwqzCJ2p0PUcYAM
         ESw0uqmmEWtHOhPliAgFPdcPVJzIP7ivHXoLAiDJ8JJQ7MUno5UZ5eFkGHrzuCeF2WM/
         yNjnuoqQuCt3R23XXjxOyzxlzyHy+TynFMGguzrUzFDLoZ2GO79D3fyt+i+jyv7hnrso
         j6711gaYDh1Y1EqoQJxG7HweMIkmEkiKV5Zkn46OD4W6IqQK8cUcByGPUdXenDLpcQ6o
         NaaA==
X-Gm-Message-State: AOJu0Ywg7d1MFGoJTDhS9NMov8fu84EDIZ9bEHftdNpgDOrenszB+tCP
	c1/PcKKi3hz3sg06zHUG6UGN6lv6eGGOOtmRdi80IirfcU8K1Y9HDZ98vVAoEcxbVTc0r3SwD4S
	HrB6Yv118LFemL1SQbltriuD4pcCPxkHKv8EuVYRuBLSZR/JGcO7dT1J1p8QCF9Mt
X-Gm-Gg: AfdE7clZE2ovsEGwvA/pjItwpxmca42QR80GKa6iqb1x93wpa3NqNPxV2g8bPjrT6Dm
	oyCIe2dPNHbWeAlFckTZjmNwvO+94owZtmiswp8FnICEWZAQ4es/GELWq1aEJ/GKFLzOGNrK/84
	QoZqlVwBdqDeRX9wru49nizCH1B4f9F7ZHbDhCAfGQhnMbK+CadqYJ291dN/g24Iil3eZf+KcnP
	ehOyfZg4e0d/u2kM74gJdUTCKxy9D0vUfM7i8oOZOlX0tnuSOGkJz3UcNpywa28qLYfSLJF9Avd
	XdZwedBWr4Ze8svw6IAu11GAuhYO2agh8as+HPXyN9Bw9T0EibaZOQjro/Uhe/cNX9muo3hK8kB
	GP4CHGkyMnO6jVU+hNqMv0nI7/p9rHFa/NUedwOgHsjQJp0UEZtU=
X-Received: by 2002:a05:622a:5c0b:b0:51c:7d0:7ed7 with SMTP id d75a77b69052e-51cbf24a901mr199687321cf.39.1784151814201;
        Wed, 15 Jul 2026 14:43:34 -0700 (PDT)
X-Received: by 2002:a05:622a:5c0b:b0:51c:7d0:7ed7 with SMTP id d75a77b69052e-51cbf24a901mr199687101cf.39.1784151813809;
        Wed, 15 Jul 2026 14:43:33 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49541eb7372sm14200775e9.13.2026.07.15.14.43.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Jul 2026 14:43:32 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
Date: Wed, 15 Jul 2026 23:39:15 +0200
Message-ID: <20260715214327.1933560-2-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Authority-Analysis: v=2.4 cv=ZpDd7d7G c=1 sm=1 tr=0 ts=6a57ff07 cx=c_pps
 a=JbAStetqSzwMeJznSMzCyw==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_K5XuSEh1TEqbUxoQ0s3:22 a=EUspDBNiAAAA:8
 a=w0io_FmA1e-6CLxyNa8A:9 a=uxP6HrT_eTzRwkO_Te1X:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfX2hxualalkud3
 /CwEFT1rfoKNciU8G/gol80O9gv+MjH8Qe2OD3bElCbMtux04HTgVmNeBc11nnV9TEpSncPs+B2
 i32ttf/mfaBetKN71Qt1eflvqwab0lL4lJhBaoRf1mLkZYrot8ibSSCOS5dAvWQEvqUFE7UVCRI
 qSG8ZA9IMFvSRntd8KaWnqK7kXFRgqOjcHiRs/uAum+ht+ZTj8AJsN/mCQtolai1f/oppAzpwki
 +a+LCipybg5i2li3dqX//jxGgKgQ4v25EhVVKrIsvcFxpQgL9bhYlZgBRhH9mEK1WNmkciLpHRz
 aRSnoGy8OzDw+n8GsOBEOKJ5ptAZAXGEB/6UPPIHjmtC61uULB7Rsrci2BFOpKZQHXm1RmWaBM2
 ofztwcNXaugYM1RQ/Xl5VmF1Qr5wAydh9vcLwqOHHpJyCnsNOl2LJTzmbNJxnLMNx7jwhjHmSyw
 +LkswP9JquB7YYpCZnQ==
X-Proofpoint-GUID: F-jZb9w7JPZtAHmpBzCF23g54IG2gAC0
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzE1MDIxNyBTYWx0ZWRfXxulS2rwSyOM7
 vQJFw99e2snBv+9hvrd+wLNiIYD9drR/XOHyTswuOLw/Zj+btPev4PB/9I+3celN2PLml95gqgm
 JqDqzxgPeTxEKSpm4T1rLbzlQGqQAVI=
X-Proofpoint-ORIG-GUID: F-jZb9w7JPZtAHmpBzCF23g54IG2gAC0
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-15_05,2026-07-15_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 malwarescore=0 bulkscore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 phishscore=0 adultscore=0 suspectscore=0 clxscore=1015 priorityscore=1501
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2607150217

After a power cycle, the first command sent to a UFS logical unit
completes with CHECK CONDITION and a power-on UNIT ATTENTION (ASC
0x29). The SCSI core reports this to the caller instead of retrying
it. For the RPMB well-known LU, that first command is the first RPMB
frame sent after boot, so the frame fails. RPMB has no earlier,
guaranteed access that could clear the condition beforehand, so this
breaks RPMB on every cold boot.

Ask the SCSI core to retry the power-on UNIT ATTENTION on the RPMB WLUN
so that RPMB works from the very first access after a power cycle.

Signed-off-by: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
---
 drivers/ufs/core/ufs-rpmb.c | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9..adbec80cf381 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -40,6 +40,25 @@ struct ufs_rpmb_dev {
 static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
 {
 	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	struct scsi_sense_hdr sshdr;
+	/* Retry the power-on UNIT ATTENTION (ASC 0x29); the SCSI core does not. */
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = SCMD_FAILURE_ASC_ANY,
+			.ascq = SCMD_FAILURE_ASCQ_ANY,
+			.allowed = 3,
+			.result = SAM_STAT_CHECK_CONDITION,
+		},
+		{}
+	};
+	struct scsi_failures failures = {
+		.failure_definitions = failure_defs,
+	};
+	const struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+		.failures = &failures,
+	};
 	u8 cdb[12] = { };
 
 	cdb[0] = send ? SECURITY_PROTOCOL_OUT : SECURITY_PROTOCOL_IN;
@@ -48,7 +67,8 @@ static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t le
 	put_unaligned_be32(len, &cdb[6]);
 
 	return scsi_execute_cmd(sdev, cdb, send ? REQ_OP_DRV_OUT : REQ_OP_DRV_IN,
-				buffer, len, /*timeout=*/30 * HZ, 0, NULL);
+				buffer, len, /*timeout=*/30 * HZ, /*retries=*/0,
+				&exec_args);
 }
 
 /* UFS RPMB route frames implementation */
-- 
2.54.0

