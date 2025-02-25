Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F8C184
	for <linux-scsi@vger.kernel.org>; Tue, 25 Feb 2025 00:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740443608; cv=none; b=BkZCzeofHStroddODDWeh0w7rUPXdmnk0wij3JvzDP0F+fXdIzpY/KcMwwG4r+GgLhdfI/zbOfLyJGrFc4ofx11/pIsrEuLeccvYgyfshVFUc6uLsA42r9oHeKQXLLvJpcoLAa+KbEKt6gvFhUm64nPy3vTYY+SCDWLn90qIuZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740443608; c=relaxed/simple;
	bh=YbyK4ZRzk/zCZSj+scVFsU1emYDrF8L3yU7G0riCDpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=un06Mg7Rjyc0T8VKeVzqlhjAMnCnPY0WsoyCPN5/wSW2LZ7s/AQccfAUUi6svmRcWOSoT1L/gHTyPfnFVgjQ4NTwq15gvVB+Jf2i5d4AL38XAvA/IcMfGazXCP+NI6ZNuJ7XsxbGRYn/TQlhoTPNukNYSPANgIxlITkPb3qunbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ow2V++xr; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ow2V++xr"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51OMK2sT002411;
	Tue, 25 Feb 2025 00:33:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=2aTRB0mneJl0MMi8mPOiKku7SwXF00gvp3cxqSBkNKc=; b=
	ow2V++xrGjuf+UAiB/YqMnybPeUIQblevx6uNh8kN6CWecUvmlqT3SqQYRw7E6HW
	f6CuEZo/pvOffcttYQxuM28c7XQjVug9M3KUolNJxMxVvLGkRHjvInc0K5T0CUJk
	+2NAtffwx1KZIHUx9gIyLROVD5pb5W/ZkxMyveJpuKmyiWYSQ6rql5YBZfKg+pr/
	28gbrtE9Ih8cxHcZcRINTRzQJJJ90S+f7j8slzInR4FitYQFhZZpvBVbIPkpdbNv
	Ymx0Mwmxynm5y28eaQeR6pmoiO9EkJcx087WwYpNI9Yu5Y2ttiB0DGVLMAUXUtdB
	PaI1nUHTP5n0LoMxIA5J9Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44y5603x5g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:20 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51P01923025293;
	Tue, 25 Feb 2025 00:33:19 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44y51f0q8f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 25 Feb 2025 00:33:19 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51P0XI1r025171;
	Tue, 25 Feb 2025 00:33:18 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44y51f0q87-1;
	Tue, 25 Feb 2025 00:33:18 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/2] Fix locking bugs in error paths
Date: Mon, 24 Feb 2025 19:32:46 -0500
Message-ID: <174044345131.2973737.8766575932057369065.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250210203936.2946494-1-bvanassche@acm.org>
References: <20250210203936.2946494-1-bvanassche@acm.org>
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
 definitions=2025-02-24_11,2025-02-24_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=500
 phishscore=0 mlxscore=0 suspectscore=0 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502250001
X-Proofpoint-GUID: hJ-eIzV5p7Gzh5OsZ1A4HAWKsR_jyrlw
X-Proofpoint-ORIG-GUID: hJ-eIzV5p7Gzh5OsZ1A4HAWKsR_jyrlw

On Mon, 10 Feb 2025 12:39:34 -0800, Bart Van Assche wrote:

> Annotating struct mutex and the mutex_*() functions with Clang thread-safety
> attributes led to the discovery of two locking bugs in error paths of SCSI
> drivers. This patch series fixes these locking bugs. Please consider this
> patch series for the next merge window.
> 
> Thanks,
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/2] scsi: mpi3mr: Fix locking in an error path
      https://git.kernel.org/mkp/scsi/c/c733741ae1c3
[2/2] scsi: mpt3sas: Fix a locking bug in an error path
      https://git.kernel.org/mkp/scsi/c/38afcf0660f5

-- 
Martin K. Petersen	Oracle Linux Engineering
