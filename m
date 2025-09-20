Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21D12AE99;
	Sat, 20 Sep 2025 02:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758335113; cv=none; b=JYIqmKpPtRvfgfcPeuHPxoBVTTeTXuB1TKiGg0+B4cI+5EGmHNBdRHUA3B0NJe6YP8SkOquObRNdhYevEgkNv2NKx9VztnG4niG7f7Dolwn0u/MgNS8AeKq1y5hPI4ffFgJXGt9VkagNXkzd4u5+YYpfcknyob5R41O0kcDoqFc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758335113; c=relaxed/simple;
	bh=QnShLZkg8/UnFhLj41Nrn/cdTJ5bTk/edIzV1tGTY98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=BKEBxEbEby+uXFPclYF/YRhELu7W2WOccDlxKhmMN5eqmPAM97FmYDcPu5LwBh9eyKAoX3upTsKh/zNUCXqFpEAY7ICKoiVYdYJOZMukMrLXCEagvpjCD1X/rUP6TA8X0qBu0Y6edRc8iEQ60rjyH4FhgvAYB0fwDj2Gaqh6+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fNhuD3PK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fNhuD3PK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58K25eJq029482;
	Sat, 20 Sep 2025 02:25:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=CsJsIHjWIG9kg+Z72lMm4FPPciDowTkHulx54Bh9bag=; b=
	fNhuD3PK3xgchkyrxrFXZsN+t/fWHciOPmYAk/StXaRalhOCtrXcnrziWI1elLbj
	0lora/X878u+VsEBF6amdGRDkuAeN+H6hej8IcuhUCTjlxATdxVJE4rvRNCJqxSO
	F1HagvmUpK4xMUgZESA+LRuqNbXwaP03t4UJrR0D69FoyqVXZTb8LY/lEe5FhBZm
	KxmeSjrClzlM7z8RPupN/mhRugBx5xrdPb0LJmtMj/YjQxuwuMBsl9Hu/PndzaTB
	TSdJut356AjlPxS8fK8k+S04dyyHnnZFC7jt85MRIccrBlaJSN2s54m/3o4BY+KK
	Q/iRXdVS2bHFlqAELVcD2A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 499k6ar0bd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58K1YIui020373;
	Sat, 20 Sep 2025 02:25:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 499jq50p2r-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 20 Sep 2025 02:25:00 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58K2Lxgd016735;
	Sat, 20 Sep 2025 02:25:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 499jq50p2b-2;
	Sat, 20 Sep 2025 02:25:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, krzk@kernel.org, peter.griffin@linaro.org,
        linux-samsung-soc@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Alok Tiwari <alok.a.tiwari@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: exynos: correct sync pattern mask timing comment
Date: Fri, 19 Sep 2025 22:24:52 -0400
Message-ID: <175833431689.3341211.14106616916060311904.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
References: <20250907202752.3613183-1-alok.a.tiwari@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-20_01,2025-09-19_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0
 mlxlogscore=986 suspectscore=0 phishscore=0 adultscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509200020
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTIwMDAxNyBTYWx0ZWRfX89q8ZKWBEisI
 VzWqpWA7RCtrEioss/Ly1xhzBTysjmOPDMw5snOGaaefQUWQAvbSKJuv+aZzrgw9EIznd6tfUf4
 iN0FPFCLMVEQTQia5E+UZJwcbxhQNBQMeKfayFz716a3oUTCbsDrF0OKpSnqGBqo7POwsdc9R/e
 W8DQRa3GxKV+m6fO4pUoDGac/Oio5yrEISBznVZW4WNQtFoJDq/PNyXT/6jjTdumk5XI9UARAJZ
 ZeXGuY+uWKLwXoRq9v6NQTJzW6ywm/vdO79mvkANPUTRVzrcbTZMQjD/QrqNfF6vyrQrxkz55sL
 ZMlpLlKpUhOJM9YJ3oqACi2EL6GacrGENHxkMiyp14MrNfayincIab4ioYzOQ6W8yxV1ZuH5A5O
 eSA+2mBtCgaNKa4sKqHXg2ZTkXmWZg==
X-Proofpoint-GUID: rnn4JSyZ3HsHYDEiN_d_XY6-hUB2SsOv
X-Authority-Analysis: v=2.4 cv=E47Npbdl c=1 sm=1 tr=0 ts=68ce107e b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=erYYR6txwRpVtOmW1J8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13614
X-Proofpoint-ORIG-GUID: rnn4JSyZ3HsHYDEiN_d_XY6-hUB2SsOv

On Sun, 07 Sep 2025 13:27:49 -0700, Alok Tiwari wrote:

> Fix the comment for SYNC_LEN_G2 in exynos_ufs_config_sync_pattern_mask().
> The actual value is 40us, not 44us, matching the configured mask timing.
> This change improves code clarity and avoids potential confusion for
> readers and maintainers.
> 
> No functional changes.
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: ufs: exynos: correct sync pattern mask timing comment
      https://git.kernel.org/mkp/scsi/c/0bd0e43776b6

-- 
Martin K. Petersen
