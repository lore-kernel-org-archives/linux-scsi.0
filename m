Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB8261A01B0
	for <linux-scsi@vger.kernel.org>; Thu, 19 Sep 2024 15:54:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726761243; cv=none; b=tUnStFWvWBzSm9L0yJQ9ybOF9Xhnm0I6Ept681mbrSHxd2+ntragMktSq/UXOP36RUS/a2YV0zyGZvUlGmuY3vVJNhfJtTAoKqsxXcDcgv3kOU/daXNGT/f8NGlICTTneQkYENly6nUPQZOR1XI87xk8SWVDWANqYC4W3Aulocw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726761243; c=relaxed/simple;
	bh=Ru/Tt4I1jp/gT8AlXqZNkn5PJjtudiP7l6PIkF1iKf8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dQ6GuWbQkwuWChK6k12DZbM3jI3OlBm9muTqR17Jf/GxyAY9x0spVs8FQ0S1kqSZC1vLEuQyDKCjv/3oQA4xJgP9K7OVxzKQwYtEY+6tH9jJfUJfXEYo90SLWiKmWfbG+lDxTsR6ekv5/lFuimZkXVVjGcWdw6x2Ppt0FusNE5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kNrqTDQU; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kNrqTDQU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 48J9P3IL015019;
	Thu, 19 Sep 2024 15:53:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=a/jbi4YkmsdlnXhzmpA4+UMp5GZ5mlZ2SLgl/VgORFY=; b=
	kNrqTDQUTXE+FBZvME57AUhWjiDgOEMojpMsf6qDDIwQJCpk3+VpF0F8QbeTsyre
	rXOpT1/m9KQhRYaA89ftr9yqCzTa+qcxWmgnpZiK/CCMjmqk5QKoB4kVxop/IIaW
	+eozbpbA1wI4U/s5NQ9//l1Qp9yQhdfRiDh3NZXWSPnRq+V+UirPBhcbMIJoshrE
	J+Z2jt/UpWrWb6tFhSwRABU6ERFhJOmhl2XT8WqrvJgBenWqbhNvQEzxI118B1p4
	jOPqAMzNQMtHR26uacB8aSHsCxPcFfUz9dJLAY0APlLqHSG7nNQ/Y9hRI99SaQNQ
	lx3Bbx3B/ZZfEcZe/DYyPg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 41n3sfvgd7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 48JFhL4O010398;
	Thu, 19 Sep 2024 15:53:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 41nyb9xjgy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 19 Sep 2024 15:53:57 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 48JFri93031813;
	Thu, 19 Sep 2024 15:53:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 41nyb9xj7h-13;
	Thu, 19 Sep 2024 15:53:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/5] mpi3mr: Few Enhancements and minor fix
Date: Thu, 19 Sep 2024 11:52:59 -0400
Message-ID: <172676112052.1503679.17377925363300953617.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
References: <20240905102753.105310-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.60.29
 definitions=2024-09-19_12,2024-09-19_01,2024-09-02_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2408220000 definitions=main-2409190105
X-Proofpoint-GUID: Z1pVs2sAwWziO9mqVEkPxfrAgF02y7tq
X-Proofpoint-ORIG-GUID: Z1pVs2sAwWziO9mqVEkPxfrAgF02y7tq

On Thu, 05 Sep 2024 15:57:48 +0530, Ranjan Kumar wrote:

> Few Enhancements and minor fix of mpi3mr driver.
> 
> Ranjan Kumar (5):
>   mpi3mr: Enhance the Enable Controller retry logic
>   mpi3mr: use firmware provided timestamp update interval
>   mpi3mr: Update MPI Headers to revision 34
>   mpi3mr: improve wait logic while controller transitions to READY state
>   mpi3mr: Update driver version to 8.12.0.0.50
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[1/5] mpi3mr: Enhance the Enable Controller retry logic
      https://git.kernel.org/mkp/scsi/c/9634bb07083c
[2/5] mpi3mr: use firmware provided timestamp update interval
      https://git.kernel.org/mkp/scsi/c/fc1ddda33094
[3/5] mpi3mr: Update MPI Headers to revision 34
      https://git.kernel.org/mkp/scsi/c/6e4c825f267e
[4/5] mpi3mr: improve wait logic while controller transitions to READY state
      https://git.kernel.org/mkp/scsi/c/4616a4b3cb8a
[5/5] mpi3mr: Update driver version to 8.12.0.0.50
      https://git.kernel.org/mkp/scsi/c/e7d67f3f9f9c

-- 
Martin K. Petersen	Oracle Linux Engineering
