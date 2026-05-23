Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE4133F5BF;
	Sat, 23 May 2026 03:15:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506144; cv=none; b=dcmfK5PBqVidVm9BjuecE/g8enf4CIuNLi+AAMMGpj/eIY73nMHQ8yFsOgvxoJmFXsRbdDqEu7W6tx3YG9f/kiAPfYeJh77kKdZjbK3Q/4Jc7j+7vvEjcCIqZYPl9p5F+ADZTMgqiNy4KkKWAMt9E+ljcdBfzi/B2z5FQkdKIjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506144; c=relaxed/simple;
	bh=May2N/p8OJ+eNr4MwP+GnvkrRTDGjCUKf17QjBOjFf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uAeJ8mPtj862CTarXxCzAdk6tPUpY23jeHuWI5LEvcssTl1SBly8PDLEnPU9yg0Pfx1G8DdpGydPbM3wiNq80pVIgKif/6yMW1BiIWaLqky2lhDcpbzqi7A+hEDi+YZ2ueUmFun7ktdj0WUIpOlFjGkanKktDGu11vLZ9xZV6r0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=E1eZlb2u; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="E1eZlb2u"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N1uvVJ2630594;
	Sat, 23 May 2026 03:15:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=jfTDtOfOt5jXkVQiFPvnQ+oQihqDpZ0jZluqET6rMRA=; b=
	E1eZlb2umFCKjC9lokOX2Qp2ZKnY3PDwwkizq+AfcQ+iGg3M4JcX+QR8Uh4iwTPy
	mx4PJNy9cJF4vnxHzhU21Iyq2dWIT6GzCjz3mZ5UHRDlyf2qcLUvK+tKh/Bn0X3k
	DJOTPINB0/ogXA4XWSEgvzKymu+qL3jyJVnvd1N9lX5q0pB6k/SveH2JsSGZNqw5
	jMeJ93i17gtskLGt4cEo6AR9X+LM1bELk9toZeaj5GkkppfdcTlNC06Sbqrw6xjs
	QYi4vPprwUha+mVrCfic0FJt6KVyOhVk8Lvn+EOwmP5VzyGWmcja6rrcy3vofPSQ
	yrKNdqf7tKT0Eo4nxZe/3A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb314r63k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F7ar032598;
	Sat, 23 May 2026 03:15:30 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsmp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:30 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9eU032824;
	Sat, 23 May 2026 03:15:29 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-19;
	Sat, 23 May 2026 03:15:29 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
        James.Bottomley@HansenPartnership.com, Wang Yan <wangyan01@kylinos.cn>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libiscsi: fix spelling and format errors
Date: Fri, 22 May 2026 23:14:33 -0400
Message-ID: <177913641781.1181900.4118213366990786039.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260511093030.63542-1-wangyan01@kylinos.cn>
References: <20260511093030.63542-1-wangyan01@kylinos.cn>
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
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=900 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Proofpoint-ORIG-GUID: UVs0TcpPABc7XTv4JTDDox-lseg3mRFB
X-Authority-Analysis: v=2.4 cv=V9BNF+ni c=1 sm=1 tr=0 ts=6a111bd3 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=-rbApFkFlrTagX3ycuoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX8NW3r+R5k4cI
 kh4qCVZUwrHyCvZWeLkOs9kr2ZMsf+Cakj8v3rwPi892Tr0FkUiCj23tDpaY2ShfwFsasb5UnV0
 +G/fHmshM1eSoK0uvQ2j2eANboITyWrgEZ/w6Otl7nAH6WbKPjDv4cruNHce5rOlzG1S+xHPryX
 yl7761H+PFp/EryLP3nbGTJnOWNPr76aR3nfEKbi49Xj/FSdkAAkWDJs4NQa0Ki/4HiAr9U5zUz
 Sa/yKCn2qMf8MO8n+imAGyyL8ncLREq8O7HYiHSmjQrDTLiXZHPWwiBjrKVOTlERNHq63YrM0UQ
 xodNmngP205+qkoMAKCfNpU+cYHZ+xwDujxxF9+l4E7qPAu5fV4s+ayMVqRtoeLIsevGhKARMtj
 zMXLzgULQQwUZpTXNT4ObMzKLg8nPs+U873C0qFYSPTUms0z3gT53ckf1ecDM3aD/jL6Ca1x290
 VoaIJcPdqfCOGhOva4Q==
X-Proofpoint-GUID: UVs0TcpPABc7XTv4JTDDox-lseg3mRFB

On Mon, 11 May 2026 17:30:30 +0800, Wang Yan wrote:

> Fix two issues in libiscsi.c:
> - Correct typo "numer" to "number" in iscsi_session_setup() comment
> - Fix format string "seconds\n." to "seconds.\n" in recv timeout warning
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: libiscsi: fix spelling and format errors
      https://git.kernel.org/mkp/scsi/c/250ba648f42d

-- 
Martin K. Petersen
