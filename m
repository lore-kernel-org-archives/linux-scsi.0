Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A44778F59
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 00:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742259321; cv=none; b=kmi3VcZe0OePqdPITnEcgWKXYaL6hQVyOfOFUeqXRpdNOGdXiX0ZrOgMoxmW0MS62FjbsbQHKdg4o+oy3iHuitCxNvZ+GBJUJYDqrMdXunurN8uObhvf1YuypFdMNZvkpFZaFpG9T8C+ka3jZ4Xhg42ojlCbY+laQXSv6zUs1x0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742259321; c=relaxed/simple;
	bh=RHu38JpZAxVHN2AXOtIcmfngfAAJZSYTGs9+fQbx83c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gfsSyRjFZth/FLyYOfvkn5jS8+CeXnoMIdIy/KhF4dSAQDubKfjfmrtR5yPGCwmtvOZzq86aVAG0JNTeDPWOS6I+lct2ccj78qygQ09rk8ZX2A3xBEE6qd2+hqr1fX7eWM9gGIaUHw5QBNuVnFj4ArLP3NVxR+Z4T7xZdA+dLzM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MmQsF73n; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MmQsF73n"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52HLtsSG020638;
	Tue, 18 Mar 2025 00:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=FQJFWYjn1deudgHaoxZknEtUcvs+pPyD9KQkR8yMAmY=; b=
	MmQsF73ndl6q3fpIkKengQkS+t9nxyjjEYe665ifsIn+SI2X9TjhZyCFm0kN8nFu
	HnILqPM6ipGb1R+PdTvabEgHznSH4qPVTPk6/aF7QVxGDd+tE6bs85KcdpZ94bjR
	qTDwq0/iPWJopolgswz/BBHdqK49nfK8FBHlToarFgeC8xTweXo99FhLUQqvLtjp
	3psXEIEdm6Gj/wcfSVMT4XUlYs3qxv9pHIxJ/BmH3mD8BS1+aKhnmOUDaDtykNsU
	rA3C9ijpMK1kNtgGb264Sii6QGMZkV5Fid5AWiiz6sBiAnGnEPOKjW5pRm2EMhll
	nUybodKCNkAEUUQNaHKkYg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d1hfv62y-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:17 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52HMAECW022461;
	Tue, 18 Mar 2025 00:55:16 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45dxeen36a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 18 Mar 2025 00:55:16 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52I0tCZE013983;
	Tue, 18 Mar 2025 00:55:16 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 45dxeen34c-4;
	Tue, 18 Mar 2025 00:55:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Chandrakanth Patil <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        prayas.patel@broadcom.com, rajsekhar.chundru@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>
Subject: Re: [PATCH V2] mpi3mr: Task Abort EH Support
Date: Mon, 17 Mar 2025 20:54:44 -0400
Message-ID: <174225924966.1094535.4229513340462607148.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250304191453.12994-1-chandrakanth.patil@broadcom.com>
References: <20250304191453.12994-1-chandrakanth.patil@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-17_10,2025-03-17_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=880 spamscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2503180004
X-Proofpoint-GUID: G0VGS0C5REZOfQ0CPFVE3bXzyPHo_-_p
X-Proofpoint-ORIG-GUID: G0VGS0C5REZOfQ0CPFVE3bXzyPHo_-_p

On Wed, 05 Mar 2025 00:44:53 +0530, Chandrakanth Patil wrote:

> Task Abort support is added to handle SCSI command timeouts, ensuring
> recovery and cleanup of timed-out commands. This completes the error
> handling framework for mpi3mr driver, which already includes device
> reset, target reset, bus reset, and host reset.
> 
> V2:
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] mpi3mr: Task Abort EH Support
      https://git.kernel.org/mkp/scsi/c/bde2ff79ee14

-- 
Martin K. Petersen	Oracle Linux Engineering
