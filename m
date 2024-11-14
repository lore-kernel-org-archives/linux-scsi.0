Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073C61F5848;
	Thu, 14 Nov 2024 02:51:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731552663; cv=none; b=RBDQjysGEA8BrFjUxmklJpo/aeI0Vte8ElMsgcJHVjF+fkdiZDtx/hS4cuGdHtyDe6te9m+qdCc+MLDHzNgAG6uZ1FQoi+Qh9YXyPHmhC0PvPjJXMiC7C4E+3Sa8xxhommrDeu6rW9VHRY8TWnzjq3qR2VO9D0Q7+Yzlc3QpkfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731552663; c=relaxed/simple;
	bh=q8NUX0onownKbNP+3xOlyyCKxJAraF/phHIr2sM+330=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dDQjJQvErBJr0cMoEPRBYClytzp8bj5tcVt9/ww9DHmvtMfEUC4QA2TwSlN71zAtxEiSuguPi2pq2zSPAqujTexu3yhdpX7k5Fc8K5OoRrhppragWf0GQp2Th1gkjsnLqDFbBJdJzkN9L5ZBwym36fye3/3BlbZA2iC4LfDyo4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=YChX9AzC; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="YChX9AzC"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1fhjc018726;
	Thu, 14 Nov 2024 02:50:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=VQs2ZPLCYhyBIEmiZPdJ5T3BRvYgSyoNAXlQyEYM5B4=; b=
	YChX9AzCQEYY/dIgvpo1qMYeqQmOeFTRpXvhvCvyxeQlshDkbqyFdLsvXL3HnNtf
	sLB6rXErCRZ76qKS+Y4m2QRKFe1Jyny+C+1ugv4S7R5KPnmJig5bAh0ExZmJfUl3
	Fhyog+cVZNoa4w0XWQx/8f8kXQhaQZZRJ7PxD9yvTw9FviVv4KpeKfGrmPhiAPm1
	6ldzK/5jCY9/oahJVDICor3+ryDnphMcr+bQQ3MkgHUGKyyWmzeH3Uby5UKqZ/VO
	OzJZy48JXsTmZh3zlM7k7YK1oG5tZuNBHKSmi17IJEUj5SENuM9dqS1xB8my9mb5
	UyPpOi0sgD/rus5IG0UVbw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42t0kc0bax-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:58 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AE1DZZt022776;
	Thu, 14 Nov 2024 02:50:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42vuw0p233-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 14 Nov 2024 02:50:57 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4AE2ojZ2003527;
	Thu, 14 Nov 2024 02:50:56 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42vuw0p1vg-10;
	Thu, 14 Nov 2024 02:50:56 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Salomon Dushimirimana <salomondush@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bhavesh Jashnani <bjashnani@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Use module param to set pcs event log severity
Date: Wed, 13 Nov 2024 21:50:03 -0500
Message-ID: <173155154784.970810.3218253453488964963.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241016220944.370539-1-salomondush@google.com>
References: <20241016220944.370539-1-salomondush@google.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-14_01,2024-11-13_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411140021
X-Proofpoint-GUID: 0DAspcDxQJu3SbbNRb4akorzjKl-8UFQ
X-Proofpoint-ORIG-GUID: 0DAspcDxQJu3SbbNRb4akorzjKl-8UFQ

On Wed, 16 Oct 2024 22:09:44 +0000, Salomon Dushimirimana wrote:

> The pm8006 driver sets pcs event log threshold very high which causes
> most of the FW logs to not be captured. This adds a module parameter to
> configure pcs event log severity with 3 (medium severity) as the
> default.
> 
> 

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: pm80xx: Use module param to set pcs event log severity
      https://git.kernel.org/mkp/scsi/c/c8d81a438544

-- 
Martin K. Petersen	Oracle Linux Engineering
