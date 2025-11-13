Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0F5267386
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 02:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002043; cv=none; b=TH2185vomSQASQ8q4q/FVoIYzx9BiR8JPupw9QcTvCLoSflnuJMS0jscd/h4lbthqRGpdCnfxyBnpZgYp2Z6w1GAjrZ3mhT7F5FGRUTDKH4Uh3krcoVictS06Yo9TIYmAogwfOXrEykgSXcBh5NIbdPGF10ifGjrppUIzNOK4zM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002043; c=relaxed/simple;
	bh=qrJAEv1u7phtE/lXsv6QoMSDFUHYBEthI4eVCA5z4yM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aajDxSUU7G0ETBp1+zLYZohF/Ay+KPgyKr02/3d86hbeua86jDhfUQc8gmsjWnnqLjQnHToY13OQXkh2IoEWJZd/JGG3H4RkLCuKcQ7ZabVtcCEFeYIpncjg8SMsu7OHFpynN436QHJmbCmqNdtF1GewyDWaBOjYwoPY7pRbK4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MBA0uj4N; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MBA0uj4N"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1hHEm024203;
	Thu, 13 Nov 2025 02:47:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2Sm09QpcO06Pi9k6YWD8/b2VydzEjrmz6dx90IRa5y4=; b=
	MBA0uj4NEKZ+jkPItQRXiqW11zKBqvB/e093HW7J4+WV7ZTo49J0no1kSv/NVTRz
	Rd2nxjAamFe4xrTmDM7Hd20MSpI/MnnK6H5wqZLQ/AuNBq2Uk6yc5q3QvFCiNcCg
	NDf/2ArsgsbG39Yj3VkrRMapbKzp874XAaY0j/YOLO8qwl8HjIUBJdTICuN4nKj6
	KyjjwlyP7I2Nfzcx/dIQunpxFLW7vJBUMOFVhqNbcNtz7lxcy/rpafyAsPddRwiu
	1X7KWP0IXpb/b8U+pGZpDBCMI0HyqZs+sMVCNFCtw+Oq+sm5ZXvk0S9G3rn4G0pK
	/v8zBkjAwRO0RcCVZK6U8A==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqrscm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:12 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0vAgJ032342;
	Thu, 13 Nov 2025 02:47:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qas-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:11 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8D038323;
	Thu, 13 Nov 2025 02:47:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-1;
	Thu, 13 Nov 2025 02:47:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: =?UTF-8?q?Kai=20M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-scsi@vger.kernel.org, David Jeffery <djeffery@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH 1/2] st: separate st-unique ioctl handling from scsi common ioctl handling
Date: Wed, 12 Nov 2025 21:46:50 -0500
Message-ID: <176298170719.2933492.5461462495121440593.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251104154709.6436-1-djeffery@redhat.com>
References: <20251104154709.6436-1-djeffery@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=753 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-GUID: zsaltMUE1ZCuLToyhEKp4vJauU-dAVKK
X-Proofpoint-ORIG-GUID: zsaltMUE1ZCuLToyhEKp4vJauU-dAVKK
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXxVsIxxdYGIAw
 6tJqaV9jB/oMXkU93TUcVqNXprB65icec71FGfTGRhl6Wsq3Hxy2RjB0sKv4p/Rq8V3Cn2Pmc30
 I0TtD0bVuh7V3+Oac1uy1Jg2WmmfLsf6WBnOwadzKY7m3YADABD1uiDECN660tXzAbL+3lsWz/6
 GjfhCaSOEqSZebU+SLQQ/YegHDiZj/l21xrVPnA8yBOM8x0byGskP66NndSRxsRDc7eQQMRetl2
 xdp7Ro3GpZAVpXMbJv59OO7SlZcSFWKhMw7JADngdF0cRnhjCPER1119NGLCh/AXEI5c1CJ4yk5
 awvZYu3awb5P7/HCb2f1XmVS3G91iEWaw75pq+ZutH0p5F3EFNcuqbMEaZN5IQYhUPh5Xq73GEO
 OhS2sWWdGPw+TDJOZd1m4Q4TOEwG3S0eewTLvbj+yDjXJuQ6Xm8=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=691546b0 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=wTCzT6sautlIf_71sI8A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100

On Tue, 04 Nov 2025 10:46:22 -0500, David Jeffery wrote:

> The st ioctl function currently interleaves code for handling various st
> specific ioctls with parts of code needed for handling ioctls common to
> all scsi devices. Separate out st's code for the common ioctls into a more
> manageable, separate function.
> 
> 

Applied to 6.19/scsi-queue, thanks!

[1/2] st: separate st-unique ioctl handling from scsi common ioctl handling
      https://git.kernel.org/mkp/scsi/c/b37d70c0df85
[2/2] st: skip buffer flush for information ioctls
      https://git.kernel.org/mkp/scsi/c/d27418aaf8bc

-- 
Martin K. Petersen
