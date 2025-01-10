Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20738192D9E
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:17:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543865; cv=none; b=TEgaxhpaSRLIX6UeQ+Ni0B6l4KaHBmH+EFXrper5rLJ7XHU3DBMC6YMvxFhbZodGv/OlQRDDLKvcitabZRJv5Qpd9Kwa9xzDgQIVoMaLL5KffDWLxHcZdSBIfp8PUbwY5Ag39zobyn4yprIuMVRo6vTQVA1I6SAZuyudZEyJrak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543865; c=relaxed/simple;
	bh=JqJR8h0sVz1LBSDoN+7CbVENfg9KNVRvqJP/fILidqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OCHq+NQm86CBDxp9DwJ8TZ4FBcy6BZZ2+iuPLESM6g/mut5psvjhvf8OBPcc9nbj4+g3fPOidTgJps4FISQ7xmqeHmJOIfwesNpxgKWlXqPscwdjCj3rbVUyrnW/dqsZV56UQQrBMpCHGJHIAT/iXjypSD9b1CfkVMxBoqetyz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=D/c4kmk6; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="D/c4kmk6"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBq36014721;
	Fri, 10 Jan 2025 21:17:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VC6G4zkP0hcsJ2LAAnR/nRSMxRhpbAIDzNMjUi9gTUA=; b=
	D/c4kmk6RXcGWxk/diysVaeYlyEjlQZFfJzctHsZMU8Pn/eLW1VCjgrEBllfbH8y
	opG+GC1Tl8UsWOR4j3x6IG+QZtVu+idemx7y4O/93DJZn3w2gFc5VpuazF2VBB1U
	rVHC1cgn5aXL01xCRL/JkSa2WICmhLQ2APLxuyvnJGefAicakrxPsp38zB6mAoWd
	uem9ZZiI74DvzhPPWW6EnM/Xv5fiSbBT4cV/JEUxhJkAwws8S1bwP96Cpvb1C6CU
	6n2XUzHqzMDMMhkEWEB2rIWO4zxJX36oAnr+y+vk37nEy05DsbwikQAJgkzQebVH
	XKyjIixoOaZs4m+LmCTxVQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442b8uka28-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:41 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALFki4025477;
	Fri, 10 Jan 2025 21:17:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:40 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ2A034137;
	Fri, 10 Jan 2025 21:17:40 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-11;
	Fri, 10 Jan 2025 21:17:40 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 0/5] scsi: fix kernel-doc for exported functions
Date: Fri, 10 Jan 2025 16:16:53 -0500
Message-ID: <173654330200.638636.14754099917879197725.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241212205217.597844-1-rdunlap@infradead.org>
References: <20241212205217.597844-1-rdunlap@infradead.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=698 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: ACfKbJG-Rd1c0XZCaGJ8Jy04Np3FDz-b
X-Proofpoint-GUID: ACfKbJG-Rd1c0XZCaGJ8Jy04Np3FDz-b

On Thu, 12 Dec 2024 12:52:12 -0800, Randy Dunlap wrote:

> Add or fix kernel-doc for exported functions so that they can
> be part of the SCSI driver-api docbook.
> 
> 
>  [PATCH 1/5] scsi: scsi_error: add kernel-doc for exported functions
>  [PATCH 2/5] scsi: scsi_ioctl: add kernel-doc for exported functions
>  [PATCH 3/5] scsi: scsi_lib: add kernel-doc for exported functions
>  [PATCH 4/5] scsi: scsi_scan: add kernel-doc for exported function
>  [PATCH 5/5] scsi: transports: fix kernel-doc for exported functions
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/5] scsi: scsi_error: add kernel-doc for exported functions
      https://git.kernel.org/mkp/scsi/c/20b98768c2e7
[2/5] scsi: scsi_ioctl: add kernel-doc for exported functions
      https://git.kernel.org/mkp/scsi/c/f52a04fcf8b0
[3/5] scsi: scsi_lib: add kernel-doc for exported functions
      https://git.kernel.org/mkp/scsi/c/39d2112ab7c8
[4/5] scsi: scsi_scan: add kernel-doc for exported function
      https://git.kernel.org/mkp/scsi/c/d2f4084c5273
[5/5] scsi: transports: fix kernel-doc for exported functions
      https://git.kernel.org/mkp/scsi/c/d4842e578771

-- 
Martin K. Petersen	Oracle Linux Engineering
