Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F380830C63A
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784538989; cv=none; b=rYRktKG8/P2mmkWs7t77RMtbP6bAnlOk1xJMHhW6jFuZSN+ytLaDCIasXsBnGQBvWiKh00o9u0JoGGrR1qeq2u2yCyJDzxqkuyyyH01ude6hqFB1YOL52/cRTN4Au3CoROBGbKEbaEEKICkuAKCBNMAaNmJXPtxqSG9zFM3qxDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784538989; c=relaxed/simple;
	bh=YCH1yylulf8EbgQrB2WZCIRrwVIgjivx9cOy+yUc6pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GdM7Z/Z6TcSpviDFCryG7UYAT7/x/bqGs8qZ1rU4kSlsWuxrrWf2kfDQXrIXacAO0LP9kVXKzHUCK3yqp9qck03HTPXKpcyGxb5WGRUrNbIPt8ULuECziAJqKxbewDWlpGmJTl4Cmks0gtmeuvX8ekw5K2DiJMpzEl54u5Ra5Xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=K4kwxY9r; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=cvaWQJFB; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="K4kwxY9r";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="cvaWQJFB"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66K76xCb1896182
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WqcCf+Dhdx6
	Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=; b=K4kwxY9rK8TnGL3mvm3P3oFNOLC
	kcHMtlYKiz97ppJ3a+0DgeFKTfBkZIYWAV4iEuHurYoNAJcouz2SGqkpTLALd7qH
	SWD4rClqcpApXIdokAGHZMNHSkzm0zj169O32vQYjMFnCf8yBOBvJXA0Jnmu8zzY
	4ALwwLRlaNj23jkewlWF6cH5hnayyjbL5AMnJI8SM3z74rdbcGd4FCwc1K8bTiJ9
	NrWDydTVulWp3ZIBhetPsArnUX5mzpPVpuUQQ6QwYmZQ65OHMzPjE6zInSgdBKFh
	n/uOPr/K0UI3Yrr/vYv8XpP1SUe/5POlIPnlGnJzeZjqTYPEK373dD7tH4w==
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com [209.85.160.198])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4fhf0krkun-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 09:16:20 +0000 (GMT)
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-520a00c7a03so96634251cf.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Jul 2026 02:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1784538980; x=1785143780; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=cvaWQJFBzAwHhpJHv0n5054MiTWanWuO1/43NwTgVTePeTHKHaZO6ULnv0r3LegWVM
         OFhnXFZCAGRI4F/Dl1R8AVFjsOydKDYhqMfAx39kOhoviwvQoqcFxX5T170adbzPt5Js
         G1sjXGUBmD3noxi0F2rwsqWsqRDWMwb/orSaMycGBMZWahbOB8nLzZCLV4tsVJAtE3Vg
         qPWCMQ/CtHonae8qZ5faRC1dd8jCKZW9rE7EI0rotqKAk3h/9BpXsvudG2bvwF6U5h1M
         k81SJE7KKR5He2t315dvYHKZODNVYwE9rrCwutOaW/MYjGQ6xf+kE+uSj5aIfYkN++Sy
         W8zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784538980; x=1785143780;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=apdW+KMcFADnvl0RjRbaCDe5Vu2OOP2fA4WJlQElZu2xLfcVxtVBy08futzoultwEG
         QQlF3wZXTfNptz7B3k/bfiNhfXnW8buWxEjSXGwRrGF1PyjsIwfk22m54wuxrFYprixz
         EKG3xHPlCBB9EiuAd6YBunFzPcCbG2iwR/o9d2uXloSaUugIhnsc+g20YbHLJOdql2QV
         2Qsm86uQpsafp/jgI0NXqkAdClrOWiYrtbh7uy6v8+bvQbEL3hBTvb/cpVX3lvBV35U5
         vY/f5UlIleKvrgGsgEhj4r8Mms2ISdxeKCKySUohs0PVa8zGymaj1mBYLdC3V0X1ha1n
         8gLQ==
X-Gm-Message-State: AOJu0Yyc7alJho3QqhLXWY2F1i3M3U2WlTwdCG8oK5CfRLu5uf3WcljY
	M+MQNXsMI4NgnGt/NEXeH5acFdwaDywbd3wnMEGLqFk0q1T9thiq+/0fa8nCnwS08Bh/QKTWGJI
	LnYs0zZe/HGu6e6J3lOqGBXnegNkgs5oTpfcMKCM/V64JKJRoV0wG3q5UgxCxwGgO
X-Gm-Gg: AfdE7clhbQZn+nxulA4ottoIGy9+fPH/aTxWzkhvBO9Sw0wnmJ8fqYnf9DnbONZkz5k
	zsvJsjKpOUVDG7TLnNzaNFPUG6Qg0rE0FKbnYr264KoTNBzn+f9HzTZp3uEIz6x6hC54Z3x/p33
	rvnHEJYONGPjn8eB066yNKL8WhXgcxrRuROApHP2zi28JUhj9zQAEhlVc8ovWSt1Rg6fzH6Yfx2
	Wje3mNasW4SUubxC2wKzkj3vK4wvL37i4lpeI21kmU9zZvpooeMUTrw0bLosLh6LjKA395H6l+Q
	HhKy1xEiGZNPniqUDPo9zkbRFh806/NXPDngMu5Dp27KPe0xzEtUgSk+9g0iDTVrqummNdGDjv5
	gsoI0qzBrBrlWoolFa4DHJb7tcCSahLyR1eXZUXzWc6QPI2oZAvs=
X-Received: by 2002:a05:622a:90b:b0:51e:aa39:4fc6 with SMTP id d75a77b69052e-5213ceccc62mr122232521cf.23.1784538980268;
        Mon, 20 Jul 2026 02:16:20 -0700 (PDT)
X-Received: by 2002:a05:622a:90b:b0:51e:aa39:4fc6 with SMTP id d75a77b69052e-5213ceccc62mr122232241cf.23.1784538979813;
        Mon, 20 Jul 2026 02:16:19 -0700 (PDT)
Received: from trex (182.red-79-144-196.dynamicip.rima-tde.net. [79.144.196.182])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49563969482sm12331985e9.3.2026.07.20.02.16.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 02:16:19 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, can.guo@oss.qualcomm.com,
        beanhuo@micron.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jenswi@kernel.org, sumit.garg@oss.qualcomm.com
Subject: [PATCH v2 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
Date: Mon, 20 Jul 2026 11:16:10 +0200
Message-ID: <20260720091614.544968-2-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
References: <20260720091614.544968-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-ORIG-GUID: PRSuG0vWZr8QkrMf6j8FaDuOUsAH7aUL
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzIwMDEwMyBTYWx0ZWRfX13KBffc5+ypl
 BHcpUin9VCzUZsgwp2fHLsDkOmV4Czp+8Z2oAlYkzhctJTKK84n1cTGD1TWUDDIuZtrTXmKem05
 prtIKR2tRcBOpjIOogI6Wd2fU8OXzI4=
X-Authority-Analysis: v=2.4 cv=G58s1dk5 c=1 sm=1 tr=0 ts=6a5de764 cx=c_pps
 a=mPf7EqFMSY9/WdsSgAYMbA==:117 a=2lELrtOEK2EaG96G7mOeag==:17
 a=RAioF0-LDSMA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=w0io_FmA1e-6CLxyNa8A:9 a=dawVfQjAaf238kedN5IG:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzIwMDEwMyBTYWx0ZWRfX8Kck6ag6jUe4
 EtI/fGVZ2EDgSL/NAW/51YX5eHMQBoGPklLVdX/mdufiZmbFBEaP3m2B2MUGc69GU6006AvbI0C
 B1UKHeWaWuraUTag6334dxIx0jbXc0T9p/6CrKBk74uGsmDR1BmHDrXrBN0iU/8IyGqzCOxPd45
 9vXOsoT2oRsjDQKW96fib67sMblibrM+13iZaMHH1b75q3suc+iXF8Wp4CDUaubiVaWLl04DQNC
 EogbLdly3HbtVNlk4u2st+9AwmWpPtQ28CBovWYCT2UkLPdK7/B7ica8LOFvpvAr5oJNTZdHJQ4
 7o5ukTNOFIgWyLochyo4ppkR6/JwQCHoT4HdbVGXH74lgWHGUIX1r/nW4tK0kwMM0PyCTjAJVDE
 pvKo/6E9uFGLctyG14NHCqc2EzX6+VU7vEdNT6B7bd86ZT65Iq4xrLZaWAn3BVP47SZDxQFVbwQ
 jgnh81ShUelzcuEFoPw==
X-Proofpoint-GUID: PRSuG0vWZr8QkrMf6j8FaDuOUsAH7aUL
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-20_01,2026-07-17_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 priorityscore=1501 impostorscore=0 clxscore=1015 spamscore=0
 lowpriorityscore=0 malwarescore=0 adultscore=0 phishscore=0 bulkscore=0
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2607200103

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
 drivers/ufs/core/ufs-rpmb.c | 20 +++++++++++++++++++-
 1 file changed, 19 insertions(+), 1 deletion(-)

diff --git a/drivers/ufs/core/ufs-rpmb.c b/drivers/ufs/core/ufs-rpmb.c
index ffad049872b9..d0c7ea7a36f4 100644
--- a/drivers/ufs/core/ufs-rpmb.c
+++ b/drivers/ufs/core/ufs-rpmb.c
@@ -40,6 +40,23 @@ struct ufs_rpmb_dev {
 static int ufs_sec_submit(struct ufs_hba *hba, u16 spsp, void *buffer, size_t len, bool send)
 {
 	struct scsi_device *sdev = hba->ufs_rpmb_wlun;
+	/* Retry the power-on UNIT ATTENTION (ASC 0x29); the SCSI core does not. */
+	struct scsi_failure failure_defs[] = {
+		{
+			.sense = UNIT_ATTENTION,
+			.asc = 0x29,
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

