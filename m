Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1286A39478F
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776679482; cv=none; b=G6aMWhLrzTB+VGDGb5iMa+t22A8DmnjNcGR6U8HEBkXv9xaa7CeRJo/83Ub6EVtU65k6ld9oeiOJgTQykr5fTYGAUr4hmANmb6P8zMPjQGb7hViWAPmXzTzHHmx9Gdy5i69fQxgohLr3rOurdkL6SK/NTtH+9hQcNxSnyPM1qDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776679482; c=relaxed/simple;
	bh=b3zzuY6TUS4lgqMPJCu3ADeR7Fg8Kb0+2YyrmLzQdpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dutTXZ0A1924dRcApyw4Z5uZ/Do1XzA5RSCs4tYwsmXbUJMVhpZciuelmzoizQVcvLXb/WvFuDNMbfrHm2z+VxiZV+2qMT6OquMOlkxVIKF5uD8gR0S411000ewp/lAdDUbq+cS0q7LQsGGnj6siGBeM6ET9ALDsABi8b0dQGSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=deAFQQ7Y; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=B17pk1DW; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="deAFQQ7Y";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="B17pk1DW"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63K97L93084436
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:in-reply-to:message-id
	:mime-version:references:subject:to; s=qcppdkim1; bh=EIaCzSLbPIl
	cN9EEk5IcSefKG1COTkQ/kZY1zJv2364=; b=deAFQQ7YBJL9YY2S1NyUQaqbb3O
	T9raiknYhOqG4WgHnLFA+UkIbNvLu0JmMHwZnj74GglnVVZ5Ouue9kFU5Clpo2pU
	+K3u93EIAKKvmyx4G+Cta7iEXvdZPHwnsZbQvmZmSzYNf+D4LvVr2ZzpXphBDvgX
	JJ7H/FTF8mgthzvPvyfw635f1wt7iKuZ4ubRomItIMTzBL/4AWBgtOKORBkaHhjt
	n8iBuxkbIfQT3efCxVW3rFtenHl/9LRTiM+qzfbgqWcFSeRDBUqXPlWiZSf6stjy
	S8Co/GBgEkLZTkb0GzBp2TkpjJdhZhFNt28FgLE4R5NEMYIXHGFfc3rbUzg==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4dnh81g7fv-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 10:04:39 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2d8a677cdfaso3023469eec.1
        for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 03:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1776679479; x=1777284279; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EIaCzSLbPIlcN9EEk5IcSefKG1COTkQ/kZY1zJv2364=;
        b=B17pk1DW/PJcfgiAzv7U7sZElNO4m87M2sx1/4OIpWvNXw5QE91+kedrJbrXzrW8UV
         xub6HVYsJ0lyWYcUvCpI0eJSaR0hSW8sH1sAZ/jflAvO4aEnyDIhdtQ+Re6qX4cGyDB1
         y+Hit1/3eYaQ49GLYsWTuOh2W9jMFfcl0QxFWG6fYbDAB15aavFvi2l0p/seSVUxxo4a
         G+vQF8bypc1dFcKE7LrrSKktqtnVfM2HXN+2JNfUpCPS6Z7TF/w01ulnvnhQbhf9YWmR
         MyNCo4xqObeU4mM1gDHI9pc0xTNShhoZ96vDmAdIbMvZSH0wH5J+0wnzZ9OboZhS8vYN
         vZXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776679479; x=1777284279;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=EIaCzSLbPIlcN9EEk5IcSefKG1COTkQ/kZY1zJv2364=;
        b=iWYoBePDuMwfI0NIAY7jRQ7njX6g5YAuZ+3/U/mHqq0CA6X0nuSs8D6koaNXcyuK7P
         dP5RDxio2SXQZi5gMGCmlFWeZbyNu3CsP2s1iwAgjOn9o5hq2ht8Sz87qms7LwAWdxyD
         pmaAQpEmAflWgAzTZnF3pRKqvwTn9Pl+AoQu/gvn/WLmDm4Y3Sddc/vyHcErrUp8+umX
         unFRYoX6mT8ulLyhPBR1AOKafhrILMbfPpb+fBfoBwonifdwyIMZ5iwD61sEgPV/RDoF
         ONuoaYaCY2n3PSP4xY/slc+ngXy2jY40Ctq6brmSOPGI0zLgGNU3G5Td5bEd70/QVNOc
         mJFA==
X-Forwarded-Encrypted: i=1; AFNElJ9P0FhP3pwKpYTgiWYugrh1gcTIx0fWTtIFU9ymK6cl1T2oqJKRdg6NZwWIPplwxbkVe/GmjJcqoY1s@vger.kernel.org
X-Gm-Message-State: AOJu0YzWZJ08PMSL2abF3k//wc4gJjDbZBJLjXAP5uRpEwUfL4utcbw7
	xW7KXTb0tT5/oo+3idcfliRQdQ4lciLpL4wpm7YHGOkGP1yikXxZ5CLuTIQcQIWwBMhQ+3IOdSB
	DrkvctzFSJ+hUxYGYM0B3WN5a5ks1B5azzEhuCmeiOsr4GEnGcqYcGjGTwe47920s
X-Gm-Gg: AeBDiesYxTPzSfzKLWqtWZPXfBowueMQThZAZ/A+Q0dhYQBFZlJIPfoFfzfWW0Y5XoN
	lea5tClLfnBydbug84TYqBrxAVurUcW279RMbfY49S4t0emBj5J1B+RqAMdlkiVtJXTB9FGHUHq
	eA+WZ6B8iPhRyCv8WZPaX/eXnZFZYVJl8MR/68FQGcRqvrTyu4k9EhrOh3dF0xx6iUXUmdwf+g6
	d97To7JqBvB1OZQsuoHGDSMaLgvTTsrSIhso6iYulY1b9mXJngkqazQzrSf5qaxDHU+n3Q3Rl7z
	CiT35yJXSWF0BQDtyjKCPEZ5fBmie1/T6Yf66fe6/C+tkvRWRZb0eQn4SAK/siwH1En2aQpBvD7
	4pnf7y0DGq23eUJeKkbh5ADyk+4hPxYLBbChtRph4Od5VynCiQUPKrQNQc0oUeXTLeIFhgcM1CI
	MUK5AfeOjHKGCFQic7
X-Received: by 2002:a05:693c:3108:b0:2d8:df01:d9f6 with SMTP id 5a478bee46e88-2e478c20551mr6024810eec.23.1776679478999;
        Mon, 20 Apr 2026 03:04:38 -0700 (PDT)
X-Received: by 2002:a05:693c:3108:b0:2d8:df01:d9f6 with SMTP id 5a478bee46e88-2e478c20551mr6024778eec.23.1776679478382;
        Mon, 20 Apr 2026 03:04:38 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53d2cfef3sm13076436eec.24.2026.04.20.03.04.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 03:04:38 -0700 (PDT)
From: Shawn Guo <shengchao.guo@oss.qualcomm.com>
To: "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>, Rob Herring <robh@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Conor Dooley <conor+dt@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Dmitry Baryshkov <lumag@kernel.org>,
        Kumar Dwivedi <ram.dwivedi@oss.qualcomm.com>,
        Bartosz Golaszewski <bartosz.golaszewski@oss.qualcomm.com>,
        Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>,
        linux-scsi@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Shawn Guo <shengchao.guo@oss.qualcomm.com>
Subject: [PATCH 2/2] scsi: ufs: dt-bindings: Add compatible for SA8797P UFS Host Controller
Date: Mon, 20 Apr 2026 18:04:16 +0800
Message-ID: <20260420100416.1252983-3-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
References: <20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDIwMDA5NyBTYWx0ZWRfX0nlLk72PRV1Z
 RWR7sTLwh+FR4QfbhQ+yJNUeCr6nvT1cjBrvdGThu+OcMnShHfTjPvYGD/LBA4WVW8VJKu5xmzQ
 DZS+kHq6netZpsxMGMCvkfo0qQ5J527nWI5g47kZ1x7NV7m45Nwkk79dGZNQ0M+Awads3a27eDH
 knvwAqFYgp9py2LxBpQHKD6QF6Z+SGNJmjuPL+DlBGK/WR9hqvph/vhK5zSxe82uwv9AROq+Fzr
 ydk+vFP8vUPqz1dgY9GMTKBehlgN1mFWGauQVTpBdGUdi5qqGvckmKAh0FJAF2QWyQmCDaynxeO
 DIdvbGnRt6sziI81d9eQoZ7rjH079/jg+wlf3LVPHPJHqj8rRiy4aTQkHl4qK5IiRXhUSC/MXM9
 VZwJGervMZ5Jcxto6GbMiWaqwA8FHGu3KCYdEePvFPzFxLAmpxwnjKqDdw2NuRyWMv8ga9Qu4cC
 15yFYPZYc4O9MqMIHzA==
X-Proofpoint-GUID: tbSKssSeMZ7Dybb-edSkO8joS6myQ1Be
X-Proofpoint-ORIG-GUID: tbSKssSeMZ7Dybb-edSkO8joS6myQ1Be
X-Authority-Analysis: v=2.4 cv=PsKjqQM3 c=1 sm=1 tr=0 ts=69e5fa37 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=EUspDBNiAAAA:8
 a=ld1VxiVWUvbaCiqNsT4A:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-20_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 priorityscore=1501 suspectscore=0 phishscore=0 adultscore=0
 bulkscore=0 lowpriorityscore=0 spamscore=0 impostorscore=0 malwarescore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604070000 definitions=main-2604200097

From: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>

SA8797P is the automotive variant of the Nord SoC.  Like SA8255P, its
platform firmware implements an SCMI server that manages UFS resources
such as the PHY, clocks, regulators and resets via the SCMI power
protocol. As a result, the OS-visible DT only describes the controller's
MMIO, interrupt, IOMMU and power-domain interfaces, making SA8255P the
appropriate fallback compatible.

Signed-off-by: Deepti Jaggi <deepti.jaggi@oss.qualcomm.com>
Signed-off-by: Shawn Guo <shengchao.guo@oss.qualcomm.com>
---
 .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml        | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
index 75fae9f1eba7..f2f3bfc73216 100644
--- a/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
+++ b/Documentation/devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml
@@ -11,8 +11,11 @@ maintainers:
 
 properties:
   compatible:
-    const: qcom,sa8255p-ufshc
-
+    oneOf:
+      - const: qcom,sa8255p-ufshc
+      - items:
+          - const: qcom,sa8797p-ufshc
+          - const: qcom,sa8255p-ufshc
   reg:
     maxItems: 1
 
-- 
2.43.0

