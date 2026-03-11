Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FE5413FEE
	for <linux-scsi@vger.kernel.org>; Wed, 11 Mar 2026 02:06:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773194806; cv=none; b=oF/wvCmcdRx8YdpKb9b+L1dG/rPpmqFZKns2j7g+2l7G3e6xA0x1ydKHA54MHRWmpdCK6xgHi7PJowqWPnf5GZVDim/WRwCtElhK4a5akJ3MGTm8lOkwb8IEplowIKaHyrStpT7a95ZVkpEA79tmiJ475M81k7YpePdN9wjKxBI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773194806; c=relaxed/simple;
	bh=kr4gbrZro3w0oCcW0DsNe/04hFDSguIIv03vWmfnHvA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CTkBzUecdeKcao2/WcKDvDPc00f0Dof4MFQ9pxzczQQXyvfTh0rtsSmovvt5bUIEuEYR0k2FdcyZSPCCBsIdwNyhJ1zQU48t8WNsqHSWSeBRP2eSZfZPGXrWtQsS041/PpH1o1p9lfIFGkGpK7wIVqbpQZ+a6n6GbNTwFaG+DcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=fWYPa8xG; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="fWYPa8xG"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62AIZq4J2581414;
	Wed, 11 Mar 2026 02:06:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=JTat+aCEOPYu8Fs5dMn+fX6cNiI0SRWHyoz7IxyQMM8=; b=
	fWYPa8xGxeWH/UB84dJY7HSzWdhgPKQoCncsOZX8w11+aAdKLHixgizTHoBQmeB3
	xIQMSGPvRUcwnZsRdrwwqRts/wFJIYNPKtxf4TvtFy4KaLQvfvFsTA7wUTHFq9L6
	K1OW69mWAM5A1NPDOHeTQaSe3Mvce5G/WVUmGB8iguM5gTkgyw4toyzPp4sMmR7l
	RYzIB2lAXh6t3cF2LhsUKVaK1PuglWATAIlVeK5OJbN1uruKB5/GDhATAaCyUuWI
	phPqj7o8AlEuiG6tnqKKEI81d18woLAHT5XVS9kSX9kwhr7vuyB6bgucwT1yPUKg
	jkOFqjxw7htyCn/JDESGrQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4csm9cv4gb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62ANWbDT020597;
	Wed, 11 Mar 2026 02:06:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4crafewwkv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 11 Mar 2026 02:06:25 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62B26M5T002770;
	Wed, 11 Mar 2026 02:06:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4crafewwj6-7;
	Wed, 11 Mar 2026 02:06:24 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: bvanassche@acm.org, dgilbert@interlog.com,
        James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org,
        Yang Erkun <yangerkun@huawei.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        yangerkun@huaweicloud.com
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
Date: Tue, 10 Mar 2026 22:06:18 -0400
Message-ID: <177289787695.2131580.17377295241894855841.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
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
 definitions=2026-03-10_05,2026-03-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 phishscore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2603110016
X-Proofpoint-ORIG-GUID: -cfGeaYbXKtZDbMGle9gYEDoCPBAsPQ2
X-Proofpoint-GUID: -cfGeaYbXKtZDbMGle9gYEDoCPBAsPQ2
X-Authority-Analysis: v=2.4 cv=LeYxKzfi c=1 sm=1 tr=0 ts=69b0ce21 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=mImxZ8mi4X1xoRZLIiMA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12272
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzExMDAxNiBTYWx0ZWRfX3lK2O/rX0noa
 e3nSjb2cCIPhIbOfvdQGOTjLbHx1eiMsKg3TS37Dr9l/AmTOm7v3JQ0yAeuWMNLo6IMtRlT+iLo
 5FKBinRwiJFlPmOemIvGQqLdSU2bbyxWZV6lUGFi2EQAKUTXciWUxVrLOHRv54FzIngu5RsxKNU
 3CTj+JTHcORxRU88zR29yfzuqm/W85ZKwyOUC51iPuskn4nnjPkcCwzDSy4LXVQ1cFYjr+BQOY2
 UCoKatcTx3UuG5ayZahN7B2I8AFdG8jnLAd0v4pk5yZhKc/14hZfGKifWF3uknqpL3reSekw4rn
 7cYS2Psdwcmdl1mrkXy+vw5ZCLDlanHOi3xeYlLf7jmAycs+C6Sz6EYFBhCtM+wE4cRn+mXHBqn
 ELS2GJZ0/0e8T411wOzHPhEBf4OGGFfMDhLKk54uXRhgb92/VQP3wgJNF9GMSaowYsjV9A8UlIH
 0rzp7RYMS0AXeON78Z1wkmXHDDFsN8ExuoErF/AE=

On Tue, 27 Jan 2026 14:20:41 +0800, Yang Erkun wrote:

> v1->v2:
> update commit message as suggested by Bart
> 
> Yang Erkun (3):
>   scsi: sg: Fix sysctl sg-big-buff register during sg_init
>   scsi: sg: Resolve soft lockup issue when opening /dev/sgX
>   scsi: sg: Remove deprecated sg-big-buff
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/3] scsi: sg: Fix sysctl sg-big-buff register during sg_init
      https://git.kernel.org/mkp/scsi/c/3033c471aaf6
[2/3] scsi: sg: Resolve soft lockup issue when opening /dev/sgX
      https://git.kernel.org/mkp/scsi/c/d06a310b45e1
[3/3] scsi: sg: Remove deprecated sg-big-buff
      https://git.kernel.org/mkp/scsi/c/50209dec14f8

-- 
Martin K. Petersen
