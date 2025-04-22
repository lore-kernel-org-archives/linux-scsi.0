Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BE4218AFC
	for <linux-scsi@vger.kernel.org>; Tue, 22 Apr 2025 01:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745287135; cv=none; b=QL9va6D91Rdi/9Z45sCDzym3C1KXEWlmYr5ywIiZm122gX8Viejffu/BFXjyfg6nNSA4FcKKjwayLielkeGyREFvK7gT5kSKaKuOWqNDXU3lpjqREBBLb8eIW3GTwfAO47wOseAGimWRz3dx5qJk/plFGdfpVBojeSeIs/NzhZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745287135; c=relaxed/simple;
	bh=lgFIw3e8Sip3vb+LcJt+0jY37tiGBxEH7Obj3AUrqik=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r2WQBe4DkRSBinp0KZw3FoPSvVxI3ewe8LmmMQ2m2bsjmHXQRPvHq2YuqqMs4Hm4Q2yRmYacs8ZyUq5VDmLHP4RwmLxsxYXFsBJkAh/nNQ91FxoJf9pp7LakFqadMyxXL58VTp1Ov8s5YHgV8/XbrYqUoyUJEM8CyPXzeKShfxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=T08X9sSp; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="T08X9sSp"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53M0fuYJ018080;
	Tue, 22 Apr 2025 01:58:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VQyyucTaMQC+HExNCHoZV5W6Oy/aue5PlKnXLTjswEo=; b=
	T08X9sSps5Be3GAIfXajSrjZyZeRIQJWdR6J91vhhIKatvWucXOEb0pCISaBIDg6
	UuWCG0WKDTwn1k7t9iIyfClh2U2SVI5kC+gu2isiIOVJomJRCQPCHfqUW/avwO8M
	w+QbH66e4zvL6kGtxwCauJTBweK7NESOCNKwPstVNi8yfkchFxtm6VOP4u/ALPaz
	LgkVOu5gIaRFjR/ToWN1qkmJZu3FcSP2mikQ9cSTu0qLWDK5YA77g3+STh+mFuxU
	ogBqWuAIG9v9gH4l2AN56tJg7kIGMyriz0RxyWrd/DLk58zwlGtOQ2DfaQQho22B
	CukBvOzr8B/DHhf3cq3eYA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4643esbk6n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:58:51 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53M1qTwL002853;
	Tue, 22 Apr 2025 01:58:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 464298r1t9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Apr 2025 01:58:51 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 53M1wn3S010103;
	Tue, 22 Apr 2025 01:58:50 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 464298r1s5-2;
	Tue, 22 Apr 2025 01:58:50 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1] mpi3mr: Add logging level check to control event logging
Date: Mon, 21 Apr 2025 21:58:13 -0400
Message-ID: <174528706577.2687990.5189042771404412068.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250415101546.204018-1-ranjan.kumar@broadcom.com>
References: <20250415101546.204018-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-22_01,2025-04-21_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 phishscore=0
 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504220013
X-Proofpoint-GUID: B8sF9RmTdFPO7Z49Y07KqAe0-ZZmdlt5
X-Proofpoint-ORIG-GUID: B8sF9RmTdFPO7Z49Y07KqAe0-ZZmdlt5

On Tue, 15 Apr 2025 15:45:46 +0530, Ranjan Kumar wrote:

> The check ensure event logs are only generated when
> the debug logging level "MPI3_DEBUG_EVENT" is enabled.
> It prevents unnecessary logging.
> 
> 

Applied to 6.15/scsi-fixes, thanks!

[1/1] mpi3mr: Add logging level check to control event logging
      https://git.kernel.org/mkp/scsi/c/b0b7ee3b574a

-- 
Martin K. Petersen	Oracle Linux Engineering
