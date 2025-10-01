Received: from mx0b-0031df01.pphosted.com (mx0b-0031df01.pphosted.com [205.220.180.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB1272C3266
	for <linux-scsi@vger.kernel.org>; Wed,  1 Oct 2025 11:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.180.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759318711; cv=none; b=SLaxVgedMgoaOcdydSlJhXZDn+cibVrQIOvHZGT9dwhYmESYMGtwYNOaPeRBXnGaWW64xdi/oahJTFAb3zHzb/J72nfrsk7XYAz1+IeoPnRUU6S1BN5Ckyxlw1UGkidBjo6iNVBziqWGAM/nRcyoPMtdGoGZ9I55zJ63UfFcGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759318711; c=relaxed/simple;
	bh=WoyeNOztcb+Vnk81dBOL+aT2GzfNPFRVc4TyK8sgBVE=;
	h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:Cc; b=oQnZSxMKKekUtkFbTqZZSiaERTHPoJ1a6u0gZXnX3qycILp/NQVpkl4mqlw6bfb3rTDk/JRJ38WE9teLbv7dA/4T+AdO7fHSx37F78kULqXUjHXXyX1lNlCsieYTdZsUEV0zvVNQ1Ard9LcF3uZbJOan/pKB97Ch09q74Yw6L9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=JmWaF0kP; arc=none smtp.client-ip=205.220.180.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="JmWaF0kP"
Received: from pps.filterd (m0279868.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59197OhM026935
	for <linux-scsi@vger.kernel.org>; Wed, 1 Oct 2025 11:38:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=qcppdkim1; bh=TD3Ehl3AFe7cNv5YiBoEzt
	pI0Xi1nVstsVb5Bpudtws=; b=JmWaF0kPY4GoXLLokOsdypffGVMatpgqtXiJTc
	Q9ZCEYu2dFrS7pnFi6yj/+CzYk0x3wmidQOqB9vfKbEWbl+W5l6+y4iZWyMrhk7w
	ArnNdQsHArxVW/S73pdzeziQk0R6dSp6+MszYsV9f9yR0Ej16bCG21ezsMGKDHnZ
	2UFY1XacwN0cDDuXMTDQygxRUTrNgSIfYPJkh67O52U+v3MmORtklVMEiQaY0uHs
	pGKvf8HwdjIYZPP4vgyNcQdCqtv3NLiTNs540dZdIJSOErIcFLdihAFMVZzsfCn1
	c2oY0y9xEA0s74Hhxax/xGLWOqfThLKFr5AAuTh+jqmQHH4g==
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com [209.85.215.199])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 49fyrf5ymq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 11:38:28 +0000 (GMT)
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-b550fab38e9so4964787a12.0
        for <linux-scsi@vger.kernel.org>; Wed, 01 Oct 2025 04:38:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759318707; x=1759923507;
        h=cc:to:content-transfer-encoding:mime-version:message-id:date
         :subject:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TD3Ehl3AFe7cNv5YiBoEztpI0Xi1nVstsVb5Bpudtws=;
        b=MweAoZM9Yx85+bMSOZ58jemWIFbWCiZJ5WQ90RmSRsRM+ZGFSjcVUdfYKUske5xOb+
         I/DXyNze0BHW/SdymhCQy134tq9WlaQNO0y6BLTN9i4bkGPyYIqeS29/nmmbMyO5EvFF
         JZLKoMRihlfoE+RKD1c3yQcktovgk/DS8hWkC3ROPCCShL38nDs53siwNoNfVxp02ucM
         BG0Y20CmowUHZX1VXzWa+awo6MF4onjyJdqLTyoGUDUWV7GvsCcYlFBrzNgJ1kxtmRXC
         gM7DRC9zu6uTMRTXv4K7Q2cP0Vi0FQcBnMqvYGl2iJS80YYeOTWJMjlYV5uoHgpAU4sH
         ZknQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+XZ4EJNtcx9+C0iNwu0scSNWlP2UtbH4loHGd7apmpJwmooBUlWPBO6/V0rSZ4jOd6vw7Oe7TTyxa@vger.kernel.org
X-Gm-Message-State: AOJu0YzLKzEZ9AERgrfaBa1hZQJf1OC/VJWMr8OUfsBT2BY2MecPDMt3
	3QKI1svCYs5QSU2dvkKOpz3gn0yb7KG1W3HNBBSqUEUThI1DAouhNEJITDmJR3j6htbfMOwsIu+
	dwCYsx2nzrAvgrpAby+oAjVhr7+qwVaz/poXQGmWUzikcYQN015cGoTT9vP9ZdrtV
X-Gm-Gg: ASbGncs3MuGIW1O5M3RHKCbvNJnXDyMJUtvLiZ/+MePskU0rUzsd+lN9kz+d9P/k52B
	qexaJFeDGWVn4ZUm0ha2dehh6xsvjtRsYDLBYDMgZKQ+fHlk8h2xwgtwpFrbxHl63IG+rbzosKS
	IZ69VWLC5VcfqTd5BCx3D3i37oQHWWKZlReqWSmMUzshRydhUyhax08SjN6pxlk624BlG3DMFMP
	lM2ZCQdzC3VsOnN5GTRvjVDlaUpMqbNOAHtnwBU31shP7eQ+fp9K0QYXVAPDqxkIGGBLsrO59EI
	uOgcwkY7YtrqzZ/0TKP+SO342sjuNKfZRlyabUmPAyk2dSM5Fxnr4a9n8zz3Oa2cHEhKVx1UjcS
	XxRO5OQg=
X-Received: by 2002:a17:90b:3843:b0:332:2773:e7bf with SMTP id 98e67ed59e1d1-339a6f3cd62mr3333620a91.18.1759318706993;
        Wed, 01 Oct 2025 04:38:26 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFMafiEGimHKc0YfesDgOhniAOMnM4qXUrYhpaT/0+SzzXPVKsLHZShVPI8EJXqlbEe44F44w==
X-Received: by 2002:a17:90b:3843:b0:332:2773:e7bf with SMTP id 98e67ed59e1d1-339a6f3cd62mr3333592a91.18.1759318706537;
        Wed, 01 Oct 2025 04:38:26 -0700 (PDT)
Received: from hu-arakshit-hyd.qualcomm.com ([202.46.22.19])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3399ce47d7csm1861646a91.10.2025.10.01.04.38.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 01 Oct 2025 04:38:26 -0700 (PDT)
From: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
Subject: [PATCH 0/2] Enable UFS ICE clock scaling
Date: Wed, 01 Oct 2025 17:08:18 +0530
Message-Id: <20251001-enable-ufs-ice-clock-scaling-v1-0-ec956160b696@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAKoS3WgC/x3MwQqDMAwA0F+RnBdoC5HVXxkeuix1wVKlYWMg/
 vuKx3d5B5g0FYNpOKDJV0232uFvA/A71UVQX90QXCDvnEep6VkEP9lQWZDLxisap6J1wchEFO8
 hUh6hF3uTrL+rf8zn+QekTYxpbgAAAA==
X-Change-ID: 20251001-enable-ufs-ice-clock-scaling-9c55598295f6
To: Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <mani@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org,
        Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
X-Mailer: b4 0.14.2
X-Proofpoint-ORIG-GUID: VIPBtuebB0WZFMJXmle4uggKKdaYXioF
X-Proofpoint-GUID: VIPBtuebB0WZFMJXmle4uggKKdaYXioF
X-Authority-Analysis: v=2.4 cv=etzSD4pX c=1 sm=1 tr=0 ts=68dd12b4 cx=c_pps
 a=Oh5Dbbf/trHjhBongsHeRQ==:117 a=fChuTYTh2wq5r3m49p7fHw==:17
 a=IkcTkHD0fZMA:10 a=x6icFKpwvdMA:10 a=EUspDBNiAAAA:8 a=leelLz0WBGCC_s1OHCUA:9
 a=QEXdDO2ut3YA:10 a=_Vgx9l1VpLgwpw_dHYaR:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTI5MDE3NSBTYWx0ZWRfX+S6rpuQXb+Mu
 32qohB+lZ+M7kznbl24ZVDe2Ya5SdjtiJmR5kfaVV9hoHwqZ3n8p/vzb1d9refT/6ClU1TvY6Or
 p63Bof2b6ZEEEwdMyv4WGa2QjYo3eDxgsqlLlEdFT4dyA2V7CiuKrQzqdMid5bodiOOvl0eIOuQ
 DaqnU9vpyNA69M6JeHbFH8PTCx4JjiwJs+GzA3aig8IZldqgPbBWVm+pGTKOzf/uW4lP/OTrP6Z
 X/b1CedidYwe3zPjmLHHWd8VcP5C/QiruILhwSEl3BVx630WqiXUEADoQeWyleJSQEOJVs0aKDC
 YisXj4+iaYB7kQcuWgx7JjsxmdL/QsWucJg+4U+Tvl38I/VC086N0UT3EhIR8Ta7iUmgsvyQEZU
 NfrE7XgOYQbdMQ5NvvT6dtK5YWB0pQ==
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-01_03,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 phishscore=0 lowpriorityscore=0 clxscore=1011 suspectscore=0 malwarescore=0
 priorityscore=1501 spamscore=0 impostorscore=0 adultscore=0 bulkscore=0
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.19.0-2509150000 definitions=main-2509290175

This API enables dynamic scaling of the ICE (Inline Crypto Engine) clock,
which is tightly integrated with the host controller. It is invoked by the UFS 
host controller driver in response to clock scaling requests, ensuring
coordination between ICE and the host controller.

This API helps prevent degradation in storage read/write KPIs,
maintaining consistent I/O throughput performance.

The implementation has been tested using tiotest to verify that enabling ICE
does not negatively impact host controller I/O performance during
read/write operations.

Signed-off-by: Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>
---
Abhinaba Rakshit (2):
      soc: qcom: ice: enable ICE clock scaling API
      ufs: host: scale ICE clock

 drivers/soc/qcom/ice.c      | 25 +++++++++++++++++++++++++
 drivers/ufs/host/ufs-qcom.c | 14 ++++++++++++++
 include/soc/qcom/ice.h      |  1 +
 3 files changed, 40 insertions(+)
---
base-commit: 3b9b1f8df454caa453c7fb07689064edb2eda90a
change-id: 20251001-enable-ufs-ice-clock-scaling-9c55598295f6

Best regards,
-- 
Abhinaba Rakshit <abhinaba.rakshit@oss.qualcomm.com>

