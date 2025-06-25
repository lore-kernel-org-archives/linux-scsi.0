Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77A1A7FBA2;
	Wed, 25 Jun 2025 01:44:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750815886; cv=none; b=RWVd4LdxLCKOYFAORksCRPpw/YvEMSYJdvCEQ9ug4nBa01EBYNjROcMv76NY0Hj/FvLCnxBjMQ0BZvnycE47PbdzMb/704l7h6xqAr4MbKBKvkG6b/p90s7Q2PS2GG7mcMrZYy/93dLEXOvi3v2laCokN3TbwmiGObsK8qQv4x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750815886; c=relaxed/simple;
	bh=63ErxpbuOkJWGd9W9w/NJt/BqDUEcG9zGF5voZ744Ks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EEtYwZ40oI3/71H860E+a6KsrFqw0ae4UAJwi/ldfqwg2+fm1dVb6goRP6wsOWuGEt8TinfGEpRcKAWW0djuFf2pvS1WbuYxhKr1zpkk79nVbXLQtNvFFTQLS2uHyewDkbd7vIkyv32xE0CpkO/5IKnR6qo7mRdXxXdv7nc8Mmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=paNu//Xf; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="paNu//Xf"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 55OMigTu030672;
	Wed, 25 Jun 2025 01:44:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=NwUcU+w7zbW8MdEDc273jVYvYIadkON2Z0ceKpvnZAM=; b=
	paNu//XfZM/oIFb+X+WAmLyZ37ytfAbIPIM1qG275uEx+QbHoFRK5/+oZrq3MPc8
	4wDdxv/JRtUBXaVKgC2xYnPXfmm8tULppcVFb0DCGiGiVt7lwK+FZmJ9RKwpggDn
	966wCumXb5rcW4/zGlFefBhzZOOC0HN7yiJV11KYYQNenlR4451zxW7YufAEwuVs
	gI3ik3o5M8L7Beq5IG3pFb8yPoV4b99vdoWhWNL8fSR7Wt4jb0ryV8lDriY6W2xD
	9cDqCgw7K0vrmqaElEEz80ZvgOGhPKPfNgL5Q+2wUAIUiVVv7miPq118NS2cw5M6
	iX2q8oj8FhJSRhh62kugRQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47ds8mxapw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:32 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55ONhWUJ005652;
	Wed, 25 Jun 2025 01:44:31 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ehq4e6q0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 25 Jun 2025 01:44:31 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 55P1iVG8007157;
	Wed, 25 Jun 2025 01:44:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 47ehq4e6pm-1;
	Wed, 25 Jun 2025 01:44:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: (subset) [PATCH 0/2] scsi: ufs: Two minor optimizations in query UPIU preparation
Date: Tue, 24 Jun 2025 21:44:00 -0400
Message-ID: <175069824517.1717808.11538171341500520014.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250617095611.89229-1-avri.altman@sandisk.com>
References: <20250617095611.89229-1-avri.altman@sandisk.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-06-24_06,2025-06-23_07,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=849
 spamscore=0 malwarescore=0 suspectscore=0 mlxscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506250012
X-Authority-Analysis: v=2.4 cv=IcWHWXqa c=1 sm=1 tr=0 ts=685b5480 cx=c_pps a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=yXgJfXx9OWran6Tt5UoA:9 a=QEXdDO2ut3YA:10 a=zgiPjhLxNE0A:10
X-Proofpoint-ORIG-GUID: L0R2L79yB_Y8clcgfSOdqQ2yhli3MlM5
X-Proofpoint-GUID: L0R2L79yB_Y8clcgfSOdqQ2yhli3MlM5
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjI1MDAxMiBTYWx0ZWRfX8sjwmNnOzJDI xRZS+qSolwStGLG3QtD+0lbqgfQYsutXtLkJYi6FOAkmBw8H+Nc25+bfW46aZKe7KTM1lOXld7W 3vwsy1ptC1IOwUr+2RUBSPsoAiQkapzQi7hEVkAy4+SejDIMPevi1f9Ad+1IYhz5Cdt1P/mHlrm
 omdYqGcDl6i78OoTxUdn6QsQtdaS/TE9UDhqMYkM5NUoUriFZZv+P3VZt6s0RCMXw/v20ro7jII lwmBuzYzbFBOSWvMIoiTDGYVKqFq+gF5808bJmdpk/SZIEDQjxRda3eErAc2p6xvC+hKWAu6NuW l0qiXEXB4aLZJ+nOU0kVVCZaeV+WVYQpuR4iehcIb+2qH3hJdyjrnhcyOwy9P8h+MZGWJRuAID9
 vbZl1qbax7xsi9ABSo/dQAWKHe8hU/Qg2WwOBet/hfhPPrwSw2I2V0+bMrn9cqWdvlf3VI1y

On Tue, 17 Jun 2025 12:56:09 +0300, Avri Altman wrote:

> This short series introduces two minor optimizations to the UPIU
> preparation code in the UFS core driver. Shouldn't have functional
> impact.
> 
> Avri Altman (2):
>   scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
>   scsi: ufs: Document NOP_OUT transaction code
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/2] scsi: ufs: Clear ucd_rsp_ptr for UPIU requests once
      https://git.kernel.org/mkp/scsi/c/d56d980d9b28

-- 
Martin K. Petersen	Oracle Linux Engineering
