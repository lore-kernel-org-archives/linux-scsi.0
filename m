Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A1F84D2EC5
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787324785; cv=none; b=q1IYHGgR/fwVC7k0ZAZEB9Qzhcqn464EWdQuhnaY+bqaPXLo2VTuwCR0XaRUsagk7UFrAoE0klGgp6BjCagGuiCUmK1MEonfbybWM07iFOJPfAOckaAc+jxXRW+KkrbbUHnV1mNl7nzmI1aYh3sXXQmY8dEckcPwYurxRK0gKgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787324785; c=relaxed/simple;
	bh=YCH1yylulf8EbgQrB2WZCIRrwVIgjivx9cOy+yUc6pQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pKohFFI9dnArNXANH/bZFBpSuBea4wDcj6TNE6KBrV3u/7aLecnztydvrCQM0u3IX2L2RnSojVxd8NJ6so3H2phShocTr99ZaH0M5XiGh9mKqoe3I9E780AmGLxqJr24BZIeR6t2vlXjtx93Fj6aPl55uYJh15iIcSi+Umf6n28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=Sdybhw0F; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=HQAMfg+R; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="Sdybhw0F";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="HQAMfg+R"
Received: from pps.filterd (m0279870.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67LCoY6Z2466889
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=WqcCf+Dhdx6
	Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=; b=Sdybhw0FTGysGHJgAe0wLK1rFvT
	ZYEZNi2NjQ838nO5Ijx2og9/KhbkPqMjewzCeNGEekymYJkBgF7b4F9GBVOsG5WH
	zuX6dD6xAfxgDrknavd7YEDD3ACVzPMVd48uoi1pyLkNO0A0IBpP6ZGjoaffrV3K
	TxH/qs0TVzq29gbSkhXM3dbGvPlYr+NTaLupFySY8Taj2Fd/bcybRxd10OSkqC2/
	GI/MfhzqDU9EVqxoNorp9JJFCAkolia4m9HTWyNCv+bt0RzFKPnwh2qMcxTcQFIb
	B6yBxN0xzJA2lQvBmZyX90n21jcgqJMX5PhqWB3W8IilwJrALlUboj0s8NA==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4g6gddj6gj-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 15:06:23 +0000 (GMT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-9368b4c5964so80998485a.1
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2026 08:06:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1787324783; x=1787929583; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=HQAMfg+RwFC1tjXllNRoJqNnTEQR9rhTlUzqMfINYTtlg1Crwp1P2uEoLjE0BGT/kb
         0/TUAeypMzyOrT5HulMYSOsAgcD+dYlAxIA6isijd3yU33O5nE0pzY8F1K+NKjVNw9p9
         hkJIbIXbHD81TyiS3kUHl+4BxApE9UdQ4tsRs7OQzAhadtPEVI45cKDvczfnI2GmvbKm
         Lzw0e7KkNH0O3S+QAIC3dtqVjxcYy4I+A5jXbhukm6dfQYzEYllJ0G1XfXKSSSvuDZEX
         JbSbySpma5E+NQc42MoGvecqeEd1aEjeavDwA75g8UOrY1EXUMexcO+7CuATU3olxyL2
         Zoag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787324783; x=1787929583;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=WqcCf+Dhdx6Y50GJtvfwTO5MqJahdd7ZlfJbqzun1ro=;
        b=nm4LAl+nrid2jEKbvNEwmxVSGRFVN8KtdbNW8FVas+zJpi8wQW+b4td/d0SwrncSQD
         DqQFKQoz9aRb/bnaDgqR0jltQYn8ffJUCyRqHiqA5zZXCAnL+C3ztVNtIrcMDytAwK9L
         9Vd7sMZxma6R68uFaQZgQ5j234n+4i0qpgpYZjK6eXNN5r36gT51leZTdNzxnZg4wB5h
         zaL1YuSHvoN394DUEg/BWF0Rw6xHKzrt6OwWgVDSZ27HBdZZf4qY+MSNEzY3NIxraw8K
         6Q733R4M0ex4BchcYxf060a2AtnOnLXUI+b5Px61xgZ5xDLLp5MnGYF2Sjg5WZpbWgVN
         C6bw==
X-Gm-Message-State: AOJu0Yz8secMb5rRV8a5Ex5zqPN8nFNUmzoGejdvkbLfZq6ewzgfmM2w
	XnebJNrYBksduY8nwW80NKGjiItTr5pLIpck12xHxyhB+2MuPC9VKdelp7m81z3P0h3ckclbsdS
	FzOFuo9Hrtv7fs4YQPpGi3aePB1g4T2+apa/tLkZG3iiU9Jt6DycAgvwr7bq/+Og1
X-Gm-Gg: AR+sD12059LE9M2SxqkqyJSkbHb4kAOFV0NQGtLV0NOZaOrD6evmtDXYjzUGmFWC96K
	pAWCA5wraXhcT4uuo9SgEAHa+iC3OoL57wzXsnFnQ7761FnrOaSzC4yo21TvVmVN+uzc2cnQiid
	g5stZN3+FSKU7KwvbbgICmsl+NvNOYVs54LPzGdRoFtCQ7SfxKJ/D7HQuhtCJhPFkaQ38th3ppi
	qvbP6eGqY5xbUvO7vX1TJPxf1LAzoehzb0CsLzM8VKomepO/oVlMblR9wRsigIdPORFX5mCXXJj
	cKrV3fO6N+hprhwWfYRkQy3Fws+Bh7fOEoHyQKGDV2vENir1q2U63g75Bk2HPjq/x36AfhvxHGH
	xnjAx6jvsfFtakWwJSRVg0aLzUq1UnQlpn8cWs/iBuQVwezGfJwo=
X-Received: by 2002:a05:620a:6f02:b0:931:4b6:a9e6 with SMTP id af79cd13be357-937396f3282mr631535385a.47.1787324782330;
        Fri, 21 Aug 2026 08:06:22 -0700 (PDT)
X-Received: by 2002:a05:620a:6f02:b0:931:4b6:a9e6 with SMTP id af79cd13be357-937396f3282mr631521885a.47.1787324781737;
        Fri, 21 Aug 2026 08:06:21 -0700 (PDT)
Received: from trex (137.red-79-144-199.dynamicip.rima-tde.net. [79.144.199.137])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-482b14b8050sm17960936f8f.19.2026.08.21.08.06.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 08:06:20 -0700 (PDT)
From: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>
To: jorge.ramirez@oss.qualcomm.com, James.Bottomley@HansenPartnership.com,
        martin.petersen@oracle.com, alim.akhtar@samsung.com,
        avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        beanhuo@iokpp.de, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
        sumit.garg@oss.qualcomm.com
Subject: [PATCH v3 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB WLUN
Date: Fri, 21 Aug 2026 17:06:07 +0200
Message-ID: <20260821150612.3944782-2-jorge.ramirez@oss.qualcomm.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
References: <20260821150612.3944782-1-jorge.ramirez@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Info: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX2x+52MniRiVx
 dTOFK74OYrOx80XsGRHozWoMZvI6lfRyDMupWtd462mEUwob8UqhKNIoRrjntZ+L+cdORje8Ly/
 OH+3qbJPkzhdzj9zR8rt8pJ9jSnx1ZQ=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODIxMDExNyBTYWx0ZWRfX34lR1303axha
 IoVZdRn8c9gHEcXqIpQ953+pzUg+crOAD1p6RoOYJDcY3bg3JXAxs7l4AeBfxy/5QuL4OADpAjD
 +IxkXI+87Xk3TEgnvKEVNqcn9mRMbIRzpIhn42DXTmzoQ9MMk6oqI9pCACYfl7Ion7OVbpjQYYC
 EZvvDpPWkQGw2hr7rJMvGtWdScW79coiIhPavAAQDHVdJmwApeKLSUPRlJ6vCAaOBD+94IIXd4k
 fJYV2ziYvKBsa3e/YlXgaGVnmXhowkepCw1cmWIhpw6zke3oNdPph3xPKzFaTRt5QlMXoBlFTpQ
 IQWK27igcBGufj7MYoKpQymw1SDBsZ2HQHwBQMucphCEKMVRijknHPMjtg65nyAHz8/S8Ydn29i
 QWw5hYRRMSuI3NRZWeqU0u5tnAW2jhGJNZ9k6qkoKjXqvpGaIB+bv7FEfOpQjORGFiCT7pW//mT
 Q6XEbH8XqkXdyZOoZgA==
X-Authority-Analysis: v=2.4 cv=ApHeGu9P c=1 sm=1 tr=0 ts=6a88696f cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=qBhfTSQT0jQfJ5OHMlDVQg==:17
 a=Sv0fKeRqtYgA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=gowsoOTTUOVcmtlkKump:22 a=EUspDBNiAAAA:8
 a=w0io_FmA1e-6CLxyNa8A:9 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-GUID: mQoYmH2omYc9kS5NOQOI2ZWoZwc0JCSM
X-Proofpoint-ORIG-GUID: mQoYmH2omYc9kS5NOQOI2ZWoZwc0JCSM
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-21_04,2026-08-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=0 spamscore=0 bulkscore=0 priorityscore=1501 clxscore=1015
 lowpriorityscore=0 adultscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2606150000 definitions=main-2608210117

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

