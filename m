Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B33A282F1C;
	Fri,  3 Apr 2026 02:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775181949; cv=none; b=a566oGqjxmXLErLwAqYIrisL8sC6YB37Jqa9RBGR+i03oyaDUUy8XyRT8HhcvV9wFdyMCHF+4ngw/aqa3bOv5vnB0yppkbSfe9s5yzgYIb9xI+sFFy39nOrwR0XDr7wY6lnudJG/qQhI9PVxj6nZgQjYwhEcyzKYpwWE0IhNNv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775181949; c=relaxed/simple;
	bh=VYSy6ESZC8r0jHsgKcSK1aAlbK4Ge35yovJUgONvpPA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gjBhGmP33/jbM1212AS3gnmi+ShAih06t4Nsi5EjmEdcnFAVKuzbvI2RC2a2nfTABzVeFjL6Eob/kgnj4XsD30WUG/1aSQzyE1sqKHaZOps26Jbjg6XiKsn88/5PdWyBr+TU7opSFh/U7VYpgPG4OCVdJPgoeXipl/7ePtMMlek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=OYUEGFeG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="OYUEGFeG"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 632FC3qc2206959;
	Fri, 3 Apr 2026 02:05:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=F1npotxpqL2VuoLdsfJWW8CHIY7tt9q/R0pNqB7I1oU=; b=
	OYUEGFeGqkHScv9LjpAxD8f9dzFwdnmh1p0EeqrMi0oXdZP6gWpwJyZvNhTEJ2nd
	CN12IiDVQZvhHsPB8HEdP/lGl34SODD9OZDyx4MO0xiy9r7EvH7yOCzrFafCsKx1
	kdWE/4iUSMTcJJj20R8c/6wRvTSQTJ58Zn+2zsWirKUcSgGv1kCKmZYASY5YpFyp
	nSK5nBtNz1tPVVj8d6/wWBRuKrZs4sgtFs+1z4A9+YHuIIhuFBGWoQL0bkYP6pVd
	rmUsnLTgIHkZwd2u3NfPxij9dBqGzgePwJYoOW6Ktk0MIgkxGe0LdvVTTHjI57cg
	XO5ad0zi5V2G5uEBuYf9wQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4d66v5se66-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6331IUv7029094;
	Fri, 3 Apr 2026 02:05:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4d65eddp51-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 03 Apr 2026 02:05:42 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 63325cqd017364;
	Fri, 3 Apr 2026 02:05:42 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4d65eddp33-4;
	Fri, 03 Apr 2026 02:05:42 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Dave Marquardt <davemarq@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix typo in fc_els.h
Date: Thu,  2 Apr 2026 22:05:27 -0400
Message-ID: <177517593433.3522679.1320878625033477186.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260324-fix-typo-v1-1-601f4fde35bc@linux.ibm.com>
References: <20260324-fix-typo-v1-1-601f4fde35bc@linux.ibm.com>
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
 definitions=2026-04-02_04,2026-04-02_05,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 malwarescore=0 mlxlogscore=818 phishscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2604030017
X-Proofpoint-GUID: sRNhvOV54UaEKemjQa_Y4-U8sERDA-v9
X-Authority-Analysis: v=2.4 cv=G7cR0tk5 c=1 sm=1 tr=0 ts=69cf2077 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=A5OVakUREuEA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=XZBULwcgXM_G9RgXwDQA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: sRNhvOV54UaEKemjQa_Y4-U8sERDA-v9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDAzMDAxNyBTYWx0ZWRfX7rBNV+JIWfAs
 P2yVFMuIms1h/PJl0Oz+7FZgCtDlgIo2gZrYgOrjzU/TrxyTEcytD4AlU5cRAKghfGl1x8q7RMy
 CabUh4uUaUaQjaSKMR03OGlKDJYLP7NrVRrkMwMqBFChnsjsZYyJDG7awfxyBB/PSWIzeCmtIEh
 fyg4np6orjy7Bo/6OZ1MIZDUocp5Vmj/zKMLGE/1yJDMDbLhDhRosDMrgu1jeqE+9TX/oGmRpPi
 nEdZ4B0eJRb5/LM5wExet/UrHFkmaLK+pRGyBv9mR4VrQmJ14OSCHgiEdqiWWNoiPnXsmp4mKd/
 c2bQ/CNnXKbGVF8VX1Yt/RiwKDUDNrZT+85KFhgjQtZf3jKg+h8rQTzRmc2n2R9c/dlkZiZy4Gy
 jEBlOuVS2btFsaEw4OSak2BEyUst8Q7b3h301IByG3g64Y7OxHdZR8KSfVj5dZNxcKyiXyBPgRB
 InwZ+lDNpSsbAlB15mQ==

On Tue, 24 Mar 2026 11:56:25 -0500, Dave Marquardt wrote:

> Changed "caause" to "cause".
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: fix typo in fc_els.h
      https://git.kernel.org/mkp/scsi/c/a08d2e05a46f

-- 
Martin K. Petersen
