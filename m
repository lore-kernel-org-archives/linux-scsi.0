Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4FB2227B9C;
	Tue, 29 Apr 2025 02:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745892524; cv=none; b=i9rDWMGOKf0l7KtFYIDiTkTFXj8nxyFDQNsO3mBoKcJSRikuSmTEMh4mndqJPYsKC5hV8d7NEhCfFMIuIx5sXkmTf5rJA1W710H/ZGoHeHowxhcV6M+TaDPID7t/QjsYNBE8fjHYw2yCxx+VBd8UpoZ4SNCfIQIsBZTxtDTbOzU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745892524; c=relaxed/simple;
	bh=U+yQDJEVqI80IwUjZF3haOp9c0kkgRpTp0+6PQ3+W4Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Y3XUEFbnVLkGpLnE5EWqyaGKUIuRDpqy+wWlsDH0ABJILOLa6t4JAjpkS7yXOz46ny3kcVS0cKgqS6WKFieLvPSuKbXpM8hS9puFxANvuz6oOfps166LmpnuXNlj/CxSjH3bjHJX3cCoTrNsXxfU/Bz7gpf3NK3tcSHnbb5YQB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Dz34NVEb; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Dz34NVEb"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1qYxi004587;
	Tue, 29 Apr 2025 02:08:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=ZursPkqtGpNjOVwLse+FDBNXPsk0K2R8T/sYGn+RBYY=; b=
	Dz34NVEbP0oX7igY6a3JTnrGxP6lwsVi9b7RDkaqwlqYUDwpfKG6r9RZk8pDR2Fl
	BLTF+vNXg7QyZr70+T14X77I/YafOxtOeq2sh1RTr74VK9LFRT0m1zx0ADCCUZIj
	DQW1PnUJOeNaky8+SbCYW3z/MGFl077Xii6R61hQhxRMqsH/hj6MzNofH1PzREi5
	4tVk4qrtBVLtfOUeEl7sMvEYuqwS5DX7SqxHkDSKxhaEsB33LPUiJekS77m5ZTfo
	VyG5JvC0mSsRadzjwlx3FX3r4t1nPgIV12frK+ONOWTsjkDOsspWlfuHm+ey6huB
	eIci/LtcTxOYhTYShwFOug==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46anfwr0m5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:08:36 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53T1AuGQ001389;
	Tue, 29 Apr 2025 02:08:34 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 468nx971k8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 29 Apr 2025 02:08:34 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53T28YCh016718;
	Tue, 29 Apr 2025 02:08:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 468nx971hy-1;
	Tue, 29 Apr 2025 02:08:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@kernel.org>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, Colin Ian King <colin.i.king@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: myrb: Fix spelling mistake "statux" -> "status"
Date: Mon, 28 Apr 2025 22:07:57 -0400
Message-ID: <174589246604.3595313.10268010124527522519.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250422170347.66792-1-colin.i.king@gmail.com>
References: <20250422170347.66792-1-colin.i.king@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-04-29_01,2025-04-24_02,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 bulkscore=0
 mlxlogscore=883 adultscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2504070000
 definitions=main-2504290015
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNDI5MDAxNCBTYWx0ZWRfXyDvEMRqPedfH xR2+HfzJkNykc6geXImDGuy9PKlX8rULqU1PreMFnb3Vmk0e1XmXm6I1Xi+dtw8l2+SdlePZEb/ GOBjgY1NcaNllFAn3A/e0yRMrJCdckDgXgp9NmQlx8s5lljMPLR4svzES0RJ6ZpTT8D2mNcjtln
 lHwdVqXGzERpmznydCE6lZvZ96lLYAAXTarDS4BWRQxTQhidJ7U06b4ec5+Sq7EuUTrJHowd399 M2FKMs7/1rKsJm2NhGHF1c0/zpfLwjPv6e2NNl856Z9lXZA1Fxn9FLB/HQd8y/rzWTo0TzS0QiR R4/7nDk7KKGmSxlbDvDq25leZt0bcdAd04ZzLlvG5KDqN8dZEAKNBLz90cOhJtjLl4jGEKmTgAJ hyTkxEtg
X-Proofpoint-ORIG-GUID: 6SFfeAOgyJQ5kVorZynMSyLdZWeIsJJe
X-Proofpoint-GUID: 6SFfeAOgyJQ5kVorZynMSyLdZWeIsJJe
X-Authority-Analysis: v=2.4 cv=DvlW+H/+ c=1 sm=1 tr=0 ts=681034a4 b=1 cx=c_pps a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=VwQbUJbxAAAA:8 a=uiGyr_lON7rFEZEaJlQA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13129

On Tue, 22 Apr 2025 18:03:47 +0100, Colin Ian King wrote:

> There is a spelling mistake in a dev_err message. Fix it.
> 
> 

Applied to 6.15/scsi-fixes, thanks!

[1/1] scsi: myrb: Fix spelling mistake "statux" -> "status"
      https://git.kernel.org/mkp/scsi/c/9c51f24c1ac7

-- 
Martin K. Petersen	Oracle Linux Engineering
