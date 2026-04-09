Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 037FD258EE1
	for <linux-scsi@vger.kernel.org>; Thu,  9 Apr 2026 02:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775702614; cv=none; b=ptoOC40KHHOuiJioybuFPIeE6ERfG7k0Yu6GVtwQ3Llb9AKeJtpw5k8mszZX0rZp4HJYVCSpzEdU4m4KjT/sEcdYF2Dha5pB8it2c1gsKLMASB9khJ83OXT6/LQQNjwp4OdKPZYhcS2wcGw8CBLPzpwY5w37jhXNYoZQjBL/Bf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775702614; c=relaxed/simple;
	bh=A5z//gl513hIevC/W+jeKZKb0hhNjmGtFVbh7a3emKQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HFMbCgp/PuU2135j7Lsoe5WSfl5FeR4mB/QROBd6k9utPsYRbjPEZ+gsawWfpWusSwVJS/oRFMzg1yb8HDCb39rCMTQ/nQbqZOMGmoVP+kGr5U+KmvZXqZgc/03Yl1XKzhI2SNR0mIuATa3R58R6fg4mhimu7BWVM3d41mkrRKs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G0RpzUCm; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G0RpzUCm"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 638Nu55j795409;
	Thu, 9 Apr 2026 02:43:30 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8TEjVwvfFIUL67b99JBaBn9T38EzxTsw+O5S1ldJu4Y=; b=
	G0RpzUCmU8cNiepJOVpe+3UwiAP+WPyQe1T9JiGcryR+LnnU0Ny5NPADp+jgAnyZ
	vZURiqw73XXBOSOvzDkfazXsoiDFKwZjnqrl+ndc/4gJwjLYkD6L5IVz7z7tYBMH
	0YgAXqJ6RVZPnU22y/DgzTy5KUKl5i/eA/ub/8TbGhbCuAKlYNFBVxJO9Vns4QIg
	f9IuVz4vD7cW+SPIfD2B+Ay/0ArjnqVCKmdK1soUO0oEXF09xxMH6oqXNGRnLPi+
	MLPPcONAYb7Ux4epRQgrKPsAIVDvFyjDk5y78ShcPeB5zYpyrrm9UTjNw/fb9Unr
	4Kd8pY024g6u4bDQdPNUzg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dcmqavvdj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:30 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6391JDDe003539;
	Thu, 9 Apr 2026 02:43:29 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dcn5xhray-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 09 Apr 2026 02:43:28 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6392hSUn031599;
	Thu, 9 Apr 2026 02:43:28 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4dcn5xhr6t-1;
	Thu, 09 Apr 2026 02:43:28 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/3] Three small UFS driver patches
Date: Wed,  8 Apr 2026 22:42:57 -0400
Message-ID: <177569866592.3870441.15026127294460486411.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260401202506.1445324-1-bvanassche@acm.org>
References: <20260401202506.1445324-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-08_07,2026-04-08_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxlogscore=763 phishscore=0 adultscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2604010000
 definitions=main-2604090023
X-Proofpoint-ORIG-GUID: mEHv-_Tap_lU3kVJRKiASX90hcvQ2t7L
X-Proofpoint-GUID: mEHv-_Tap_lU3kVJRKiASX90hcvQ2t7L
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDA5MDAyMyBTYWx0ZWRfXyo4GOqNZIzdZ
 O2MtIdipx44LQhugMyG2KEKLECdkumKp0XfQEXqq/NDQou9ErYLOGH54SnkmUBBqMDA3B8sIEn9
 KfvhQCXplLZe+fUVM0BI7AJg45dUjo7pFzaZ2vRuwGpQ2oqqWdCeMxno7LCUaGyzvV0lRcTTsnS
 LLeqKsIO38HWNfzC2RPe6/bZ4Te5FIOkR6cZD12XqqDvnCeMxE4ydjatoApiMLy+VcwiPWyrxkF
 6m1YoQCSVTNVL/+PH86vFt08mI31vMZ/y1tfDEt6CVZTie4Nc4I5AjTS6Qbj7BomGT4/cxc/Ca5
 rXaRmHXRUxjbuZez/I+APNxQ4sq9aVthqv70hmJCbC3XaJDEhp46KnXXvTOzcysrZQwQM+Hjl4Z
 TirWkJSQ4le8URze1jxrtTlbj0T03qE1JETJh4wGerspQ5v2qy6JWWCmRbywsEFUQN7YQSLKm9/
 xUlA/3P3SrUXzAt+2or1sT9TvjO4r3zLanp4k4Yc=
X-Authority-Analysis: v=2.4 cv=NZXWEWD4 c=1 sm=1 tr=0 ts=69d71252 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=B9dnIlp8iAU9UYT2CT0A:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12291

On Wed, 01 Apr 2026 13:24:58 -0700, Bart Van Assche wrote:

> Please consider this series of three small patches for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (3):
>   ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()
>   ufs: core: Remove an include directive from ufshcd-crypto.h
>   ufs: core: Make the header files self-contained
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/3] ufs: core: Add a comment block above ufshcd_mcq_compl_all_cqes_lock()
      https://git.kernel.org/mkp/scsi/c/1373df88d535
[2/3] ufs: core: Remove an include directive from ufshcd-crypto.h
      https://git.kernel.org/mkp/scsi/c/efa1f6a9d7ce
[3/3] ufs: core: Make the header files self-contained
      https://git.kernel.org/mkp/scsi/c/6daa8dd03745

-- 
Martin K. Petersen
