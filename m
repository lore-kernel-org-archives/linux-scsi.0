Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2BA388E6E;
	Wed, 29 Jul 2026 02:56:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293795; cv=none; b=Mgf0I3HjXWyG04DwuvF2X55J0QfxsuduzUhxNyMiPqbJj/PQUa5DieJWxDzI7n3XanObCWjwQSjkN2gax1zMrGGBP9B24rh3rR3N5irorB8h1q4HW5nrVWokYVQD/Z7cibxwPo7SkvG+b30OrRJdIyn1Z1/JY7tdrmYsJlqsmlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293795; c=relaxed/simple;
	bh=ZXzfYdj6v2os9tVcQcrMweo9hW5HjcJt2XugCgpkETQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Xn5hrOSBOgSVcvZXXeooQ6aIQ7alBw3rlQBpoXl0Pj4VubkbblTE7MYaE0EkR8mkjwt1+2nJxlloKbb2pK3ocRQBG4Pu2W5+lB/eA187UXZqmB2V3wNx5NTHri2ZQ2iqYZbBMdrW/Egq9qACUgRd9TV/VRk1VLvlxJcWvRYdzRs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cDwczq6a; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cDwczq6a"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItYut1401731;
	Wed, 29 Jul 2026 02:56:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HvdlPSV/1UwY6axXe1456eKKynl6eAJHiA7Sc2xpWQg=; b=
	cDwczq6aNk+K+ZcwpSqC3W8HkD6AuZa+BDK4kMocUdqj7el35bCB5iK4KuKIGxin
	hW8QefGg7l9su3oEiEIrxOxGckkMNvVHf0CuXKj7QCXD2BfSqXzlZ0qlWil4wAnr
	i83MygEkCJuv5+JrnlvX1G8sDt30ScxDj8tPt2av6cPBdXYKk2ffrAHVNFcN9wL1
	AtuvniEjLzYxo1ZQPhrHWHfGz/7k1N3N37AzIVvRvZJvhkl07eyfaptmSAbOor4M
	10tM+ExAIu1FjtU0Ad+cgJQs2YKmw63GrHPnRwoXUVN4jVdifJAlfE3iXcEwLOd2
	p+GaIZ5ckU5wkwU3v+4c0g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr0158m0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:27 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYOn034630;
	Wed, 29 Jul 2026 02:56:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkre-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMAB006812;
	Wed, 29 Jul 2026 02:56:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-9;
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        Lee Duncan <lduncan@suse.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        HyeongJun An <sammiee5311@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] scsi: libiscsi_tcp: bound SCSI Response data segment to the connection buffer
Date: Tue, 28 Jul 2026 22:56:16 -0400
Message-ID: <178529373834.132455.4134024360463248995.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260716065848.1653431-1-sammiee5311@gmail.com>
References: <20260710050645.1194212-1-sammiee5311@gmail.com> <20260716065848.1653431-1-sammiee5311@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=999 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX49+7wjOlzG1M
 fLW6RiGomTv1Ise+5Ui202bCdyP16WzlolULT4CNEfFknq24xDdoO7mVj0UT01BUx9X0tA9PVCA
 VrzEJ4pa7zm1SZtRk0SqUJvtYF6qxb6KJ/k5My++ADRO9mHHo/Wc
X-Proofpoint-GUID: AZCxJw7QbbWxJWL6Rww08HsP-SItI_Nc
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX1dzaALgLPNBq
 czPoXsIOAwvw+UykcrdvYbrQxwuf6XZeCC56dm+glCXZVVrPFeaQr3c5fLElEXQ2SYWsGsSsDSk
 RlM434iJpq2yncDgnPkRoA9d2iV8OfBU2Ztw/RMmCEuoLHRb+4oNHoWItZk7BfnjJqEGhf1z5bA
 6HWnA4YwCWfzaDvucLW4ZOGE7jP1n+pkg8eHq6Z/wXmB0NcukKAxaBu0TeNfYIU/CkGIIOFPJzC
 B3ielks3fVtuaSpftXDQYnBBtyYyqYNA4RmOuvyzGAuGKCLcOTiHeVI/YmYO3t5C0ECmAr2klSb
 XV67uE5/GlPEh/vaX73mm7hi3j1eJMwNV1n2UgX3NxAkvQpcZJkaHpszJLElju6gvwOIszylcAh
 N2ZaMtmXVuf1S4f3uezHluTvfl5+7ObpVtF3LSs0dAezuU/8vhtYEok8+wp3jFDGqGXHeYKn9r5
 kOJqQTLM1Onf3+6M+f3USmP99L0/ZK/HEXqbxjas=
X-Authority-Analysis: v=2.4 cv=KL1qylFo c=1 sm=1 tr=0 ts=6a696bdb b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x0eKOSpe3m1H3M0S9YoZ:22 a=VwQbUJbxAAAA:8
 a=m7n_kRg1Pt3pLWXinfQA:9 a=QEXdDO2ut3YA:10 a=5yU3S35YU4bGjq-dph-N:22
 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: AZCxJw7QbbWxJWL6Rww08HsP-SItI_Nc

On Thu, 16 Jul 2026 15:58:48 +0900, HyeongJun An wrote:

> iscsi_tcp_hdr_dissect() receives the data segment of several PDU types
> into the fixed-size conn->data buffer, which is allocated for
> ISCSI_DEF_MAX_RECV_SEG_LEN (8192) bytes.  For the LOGIN_RSP, TEXT_RSP,
> REJECT and ASYNC_EVENT opcodes the dissect path already rejects a PDU
> whose DataSegmentLength exceeds that buffer.
> 
> The SCSI Command Response (ISCSI_OP_SCSI_CMD_RSP) path also copies its
> data segment (sense/response data) into conn->data via
> iscsi_tcp_data_recv_prep(), but it does so without the same check.  The
> only upstream bound on in.datalen is conn->max_recv_dlength, the
> initiator's advertised MaxRecvDataSegmentLength, which is commonly
> negotiated well above 8192 (open-iscsi defaults to 262144).  A target
> that returns a SCSI Response with a DataSegmentLength between 8193 and
> max_recv_dlength therefore overflows the 8192-byte conn->data buffer.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: libiscsi_tcp: bound SCSI Response data segment to the connection buffer
      https://git.kernel.org/mkp/scsi/c/c1dea15f819c

-- 
Martin K. Petersen
