Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E45A2036E9
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777253491; cv=none; b=OdDX2yrpnDO+QzkA67zQ5sY/xiTQrdvCef9rq2XzRsPMZVs18npjK/AbdBtylbDce0hddHvgzxORg2O69H9xuX3mCJLUYXGK7F2oMot9I0/+umksh4dQNPyC05rytrvX3rxB5ti/Vm5uy8cj8FuOt4mpp2zT2dgw7B8c05eUTUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777253491; c=relaxed/simple;
	bh=fyTQen4gxGRWLtVzQALD2SP6tF6oprXtAxdffqT5eCo=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ti2SMMVtNFnx1rqfdX1FqEH8Ghe77yqYR0rr5zoq2m4vIMBJewisi+TYjcjpuFm9HCMEdMbZ70aCxlY8OAAGE+T3BGdIw9fZiZW20FGxYcp8v6lEDN3IWvX+zKGmU5fc60H2Gtoz+8YoxhEb4TpsFY5DcI44Ib5PdmXVzwvYU0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=CmvhDyWO; dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b=R1uoQ9Ck; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="CmvhDyWO";
	dkim=pass (2048-bit key) header.d=oss.qualcomm.com header.i=@oss.qualcomm.com header.b="R1uoQ9Ck"
Received: from pps.filterd (m0279869.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63QJsW7t4090972
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:date:from:message-id:mime-version
	:subject:to; s=qcppdkim1; bh=/0deA0ZT7ywlL3EfI1B58TJqpkBYFgAu1RO
	OeM6Ol5E=; b=CmvhDyWO1R4DJznOWWQnKV+ybh4k4Utzq50ipaUNT/WcqTaVFHB
	HLha+IDZHXnftPqPcfjzcxHMmZcfgDjJfCf93qsamAlSkaNAhc2i/tbukRApEVS5
	dwsR2pb95yCl2mc26MMs+WMfSgnSTH/yqwIt6IGORJ7477/DiOfqOCWWqfC3OGwc
	S+JdtE224EM8IvGTkGne2Xy4adsTnCs1lg45pLNXboboLj1hlCTqWgTsJbSqAgVo
	swzDgyKQyu2J2YOntuoO41tm4QJyDEZ5PMvqIJ9aEJXlE2yLZaSE5C15zXO7FS9a
	kOhQ1kJLqzu5dRFBsZQukYhQ1Rv2XYlTmbA==
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 4drnqrkvas-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Mon, 27 Apr 2026 01:31:29 +0000 (GMT)
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-2dd6fb4c867so18084665eec.0
        for <linux-scsi@vger.kernel.org>; Sun, 26 Apr 2026 18:31:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=oss.qualcomm.com; s=google; t=1777253488; x=1777858288; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/0deA0ZT7ywlL3EfI1B58TJqpkBYFgAu1ROOeM6Ol5E=;
        b=R1uoQ9CkUtlO6I8DcSgFwz3I36TiizQOxIfoXSaXXML3VOtISM9Inxb9PsgXhucES9
         6pNW4AmVIAqwkSSIQBH0NK+/w0n/fNIeSip8yfY4lCSj/UwSnTOd6eo6osab66A4QLjf
         9RTWe9f2vqgdwvRywmSCbT+ZCfbj6b2BGGN1hYJDFRe7zrMJ9V8HumnEIXfjebQ5D+hG
         wxgH1x/eLpOSDy+k4Mc+y5FmuQ7FjZbwFdW2sJcGg1oNUSI9WQFpKwDBawkl3799dDiq
         7JLg8tZrQO7kEJLPMHLkaiYmws7q67vmVVTYIBQjBUOctW0pp31RtCEaemwJGqZqFux/
         7nWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777253488; x=1777858288;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0deA0ZT7ywlL3EfI1B58TJqpkBYFgAu1ROOeM6Ol5E=;
        b=GKw3EyXoaUzWHpWW8kQoQ0ZN7DpzkWTO4GuWK7RVUb/uYz1e+3IKT7IBCEXSOCfTRw
         TYgM2ATII7IFOBqJcA2DJBy/X5P6tGv7knwqxBRVQlYaTd/yDpv9V5dgM7EpO0Solh9w
         kvSH6BZZaVSllV3VJdKc8LueSoBhGpJyl0p+S8zek3mOiK5XghkJao2GZQxicEenaNq3
         3WgNns25g0IPZjxh5a22s/9uhOBJuab30D9nnm9vbW4z70xegcDxbxyO1r2xBVJgNHqL
         ZzDjrRWxg7PAOd6S9KATk1yDbEueZeooz6c/DepDuk8Sp8NDyr/nKWhhThvR4usOWZ6z
         0C7w==
X-Forwarded-Encrypted: i=1; AFNElJ9uzkKaEw2odEPj/N+XaEou3hz33awwf/KtPtTA4KyTRijq0GYJqYpMqElKf1vxaTDyJQwtw+kYAYwU@vger.kernel.org
X-Gm-Message-State: AOJu0Yxl79Lavo5I1Nqgakz7aQazMJ996OT6hEXb1YL5xh1aURCtDob7
	bpsXwFpnSZ9qxvronUoZfnc0/kkAmi4uFUvAXejP/Fab2mNAGw4wagvY7S/uhj4UTptrd1oS0ey
	Gk0u0eGECK6dHwgDm5Ew2cGWPmbF6C/Zb+xPXHONtxDrKOO8xM4AL7GE61BmP+MC3
X-Gm-Gg: AeBDiesjPFzFJ8/iEiCu4j7Y+Sthqi5Fl5Deao6b2uVX4JacK1c71zSZoUIy0MMR4MD
	2ohTe3haVh4U1+ew7LOHD1sBIyInWqiN5+md/voTnrIB5NVBukE22Yq52m6ALLW2n+a7Aj/+pEX
	3P+0650YphXhBUXHXEkkqVN50ZzVhMXxVhvEuaelgrcKziFdqYd6FvyHWd3nlJoNYwuxmBwJtT6
	wyvIpU0iBuA6ekkD0jr5rkCl7IxYrq4VHEuw4DLPJZgRR+kbkVl4TbD/wSXUAapFsJNQF3/nXOu
	y4xNT1+rasvuHFWiUl3b/VjFpAOeMxC5anCMfADacoYm5kgoI0YKKzc50vrWbz9PenTVOC896TN
	UOKN0mzyJdiP0MJj0JPewlzdjPqUqds1m7Gv7CelYuUUliNqBrDmumupl3M+vmKblbXVi2HyhCu
	41PocryBett8EoK1SV
X-Received: by 2002:a05:7300:8c9f:b0:2e2:3381:2fba with SMTP id 5a478bee46e88-2e4660475e5mr20976478eec.3.1777253487988;
        Sun, 26 Apr 2026 18:31:27 -0700 (PDT)
X-Received: by 2002:a05:7300:8c9f:b0:2e2:3381:2fba with SMTP id 5a478bee46e88-2e4660475e5mr20976447eec.3.1777253487461;
        Sun, 26 Apr 2026 18:31:27 -0700 (PDT)
Received: from QCOM-aGQu4IUr3Y.qualcomm.com (i-global052.qualcomm.com. [199.106.103.52])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2e53a4a8018sm52749042eec.8.2026.04.26.18.31.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 18:31:27 -0700 (PDT)
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
Subject: [PATCH v2 0/2] scsi: ufs: dt-bindings: Add compatibles for Nord UFS controller
Date: Mon, 27 Apr 2026 09:31:13 +0800
Message-ID: <20260427013115.231731-1-shengchao.guo@oss.qualcomm.com>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDI3MDAxNCBTYWx0ZWRfX2dt0STzBxGn7
 Acxabl89Cv4tuhAtXjwUrWQEL8Zrv7TerOP8uFtnkS0O8NJoBy/YeKKejjQGUr4o8HFNip1lWHY
 n8nVMClGMiNzDv5CFab1NGacbT8miWVipaXSz9X8Mz2CE56nnZn3kLFnniSEnrW0ONUbiac9QP+
 oftEs/40Rw0E66GzX7s8dxpLMRxaVimH/NC+62d33HGyQKSXc8kRB+PSWXX/3QcXPBdfqASRCt1
 ldFtu3XTA99r/1qbjt81zB8bNEuthlK54ZbRRA2gpDrgtH9IHmcvoFgUNPepAkdi2zhbbIIrVXZ
 lE5AAVLOfAkiXzgzZQf46PXg9g7uiC6fRT4hoQFQ/QQV2c79L0WtosS6Up9eBPSLJN+UCaMd0+t
 /YwmdjaUMf2kNq4qG9yuZdB2tprIlqI9GgfHq202opPDn503ndFRlA81klChxwDIPZcsRHY4Czb
 IqnnNd5Ov5X1ouc4T3w==
X-Proofpoint-ORIG-GUID: vrE1fM7tqDsOFIslPVuEjZM6GCGVFbSF
X-Proofpoint-GUID: vrE1fM7tqDsOFIslPVuEjZM6GCGVFbSF
X-Authority-Analysis: v=2.4 cv=UcthjqSN c=1 sm=1 tr=0 ts=69eebc71 cx=c_pps
 a=PfFC4Oe2JQzmKTvty2cRDw==:117 a=b9+bayejhc3NMeqCNyeLQQ==:17
 a=A5OVakUREuEA:10 a=s4-Qcg_JpJYA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=u7WPNUs3qKkmUXheDGA7:22 a=_glEPmIy2e8OvE2BGh3C:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=85fteHkqF822gKl36b0A:9 a=6Ab_bkdmUrQuMsNx7PHu:22
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-26_07,2026-04-21_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1015 malwarescore=0 spamscore=0 lowpriorityscore=0 impostorscore=0
 adultscore=0 priorityscore=1501 bulkscore=0 suspectscore=0 phishscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2604200000 definitions=main-2604270014

This series documents the UFS host controller on Qualcomm Nord SoC.

Nord is a Qualcomm SoC series. Its UFS controller has a multi-queue
command (MCQ) register range in addition to the standard one,
both of which are required.

Nord also has an automotive variant, SA8797P, where the platform
firmware implements an SCMI server and manages UFS resources such as
the PHY, clocks, regulators and resets. As a result, SA8797P shares
the minimal OS-visible DT interface of SA8255P and uses it as the
fallback compatible

Changes in v2:
 - Keep the newline between compatible and reg in SA8797P patch
 - Link to v1: https://lore.kernel.org/all/20260420100416.1252983-1-shengchao.guo@oss.qualcomm.com/

Deepti Jaggi (1):
  scsi: ufs: dt-bindings: Add compatible for SA8797P UFS Host Controller

Shawn Guo (1):
  scsi: ufs: dt-bindings: Add compatible for Nord UFS Host Controller

 .../devicetree/bindings/ufs/qcom,sa8255p-ufshc.yaml         | 6 +++++-
 .../devicetree/bindings/ufs/qcom,sm8650-ufshc.yaml          | 3 +++
 2 files changed, 8 insertions(+), 1 deletion(-)

-- 
2.43.0

