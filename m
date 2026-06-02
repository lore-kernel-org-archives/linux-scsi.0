Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1BEA35677A
	for <linux-scsi@vger.kernel.org>; Tue,  2 Jun 2026 02:11:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780366271; cv=none; b=J+JROTWUzAbUFF4jfEPKE2I9hwpXvDB+KpHeq4meq2QNHYn/oR21Y60efzrftIpy7pU+UPF+9YqwEeOun0cU70higTv2pVEmo+rLDHbVdUbUugHY1eRpMC78kHBS0K+fjjiHG5dPgenSWplXt35IpKQyFm4JESW+kGAEP4S069I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780366271; c=relaxed/simple;
	bh=gIdP5C+ORIl6cGfbFWXYfhjxe/ZRgOhZMJ3/C8k1qrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YlaHRGYGbulgXmDynwCINyAeeZFUCPxQe5BgVoQw9Wu9BbYO35mvxtoHQArQ312qWh0M9ezY15Z6JQnBQSj2Lg9D7c/2j/9BP1F5kL5+qNuwkQADWwtyNFskgiHQH8TOwbEgksdBM6rfWEJHeEcbXwIojVHnFuP7BwxMDeEou78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=K23tA+6P; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="K23tA+6P"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 651GtpZ31123795;
	Tue, 2 Jun 2026 02:11:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=i83nxCliBMzC0liBoIddLGhUtUFs76KwR2kGbpgc28A=; b=
	K23tA+6Pf2LYwFnPmefJkl35gZbRBLXRcdTywHTGsaM6kJ7qB7kbk67MfOnCsQFC
	FK+Wgq7BiKWMUosAl6lDRSigk+/oAbFcEClOhwNtFng0tm/IwzrVsl1KoDNQ6d3T
	ojt2jTVGoguv4Y4nmhuJsljqdmG1Hmmzp06wp6NYRe9lUV16iJDLVqBhwWwpZEQ9
	4gUkM/ma8U/GQXtFSJ1OzaxVJZqRB0IyqmspZm4fb80wh7sWpQjGZcMitGVea2Sa
	AmMcC/TP8pufIQMA9QEFKWz0VZH9Zgcxi9FvHxbjnG/LAHzvI3IWd1J7Nc10nltW
	HrUJEaonUv/srAQn1ubsow==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4efpp1u93v-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:11:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6522A4g0020132;
	Tue, 2 Jun 2026 02:10:58 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4efpbc2x0g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 02 Jun 2026 02:10:58 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6522ArCC023303;
	Tue, 2 Jun 2026 02:10:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4efpbc2ww0-5;
	Tue, 02 Jun 2026 02:10:58 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, mani@kernel.org,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] scsi: ufs: Add quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
Date: Mon,  1 Jun 2026 22:10:46 -0400
Message-ID: <178036282195.1628204.13090055484313727727.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
References: <20260501131641.826258-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-01_07,2026-05-28_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0
 malwarescore=0 spamscore=0 bulkscore=0 mlxscore=0 suspectscore=0
 lowpriorityscore=0 adultscore=0 mlxlogscore=852 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2605130000 definitions=main-2606020018
X-Proofpoint-GUID: zZfPK4OCq7VBNfjpTVHwRTvFmccIOJVs
X-Authority-Analysis: v=2.4 cv=BMWDalQG c=1 sm=1 tr=0 ts=6a1e3bb5 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=QY7j19i87E9t1ugw6lkA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: zZfPK4OCq7VBNfjpTVHwRTvFmccIOJVs
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjAyMDAxOCBTYWx0ZWRfX3O0gOgedmPTo
 jspgzqtSlDbeXg3cMCGkn9Zr9v53Mj0mniZdj2omBVaIOlHrgQI/nwfWrXT0MQ78ZJ9ow4+s+Kv
 AvjsejhF0oDKK271rcl7P7kBuEMvJveklRVk86NpwxocWgDcmDdAUsNU6W8gg0IZfYnvRXXcolT
 Yp4ZMr+efD/bX5I9yiBAB+yTXzUaM+BhDvaOA4+8CayehB2pHKyDWzuF98TBl6GXkgmEx0EqL4f
 KriTzWHO/tIk5+02MpyqPbU8s2ETF6TZpNSFZajfghaZfTM5lN+AXCMqvw+M/PnoB7FESCr+CZi
 mI1tETSycQ5S42rDG93BWbHqwlB77icWaOGbQZKUl6IcNhdbfhqsYB/GoeMfqbjlTY9hHqzRaXt
 OUAld4mCsephPFUfdWRHJ76ehEn8pPyqOcYBGf7WvSHk0Ffq75AfZ+UmLfewqOMHc/m4B25L82r
 o2TJlTjrpJwmbY+T5NQ==

On Fri, 01 May 2026 06:16:39 -0700, Can Guo wrote:

> Add a quirk to support TX Equalization Training (EQTR) using Adapt L0L1L2L3
> length which is larger than what is allowed by M-PHY spec ver 6.0.
> 
> 
> Can Guo (2):
>   scsi: ufs: core: Add a quirk for extended TX EQTR Adapt L0L1L2L3
>     length
>   scsi: ufs: ufs-qcom: Use quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/2] scsi: ufs: core: Add a quirk for extended TX EQTR Adapt L0L1L2L3 length
      https://git.kernel.org/mkp/scsi/c/8933fa6695aa
[2/2] scsi: ufs: ufs-qcom: Use quirk EXTENDED_TX_EQTR_ADAPT_LENGTH_L0L1L2L3
      https://git.kernel.org/mkp/scsi/c/0f51fd846843

-- 
Martin K. Petersen
