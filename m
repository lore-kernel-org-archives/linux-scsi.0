Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 968A92D7DFE
	for <linux-scsi@vger.kernel.org>; Thu, 20 Nov 2025 04:16:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612194; cv=none; b=sA3Yu+Hd4RFX3FNfk3r2cJb70Er9EibInKhukV4vCP/+4Bk41KSPBd0iyESXu0n9AlUviYqTRz4TaUj9hBN4gjUXNSI3BeIjWY3NNSDkuEqwuW6Llpbny0kufpQl536wfzOoAaaNt0lSGATyxkhRWW8+AqhNjoBRlG29JEIUJUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612194; c=relaxed/simple;
	bh=h1n1IFrZO8vmrk+4GKx87rXQfQIUzkkYnWYvjxw0v1Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ev0A7lEL8uUAgz7DNOFqCLLeApkL+sWIy/w7vf4MrDItyGJ0LweX23aqnbpx5c1MILyCrvRhOZWtU+tPP+tBUp1JqSMrXsTjG52EO0ut7cHODBLGRaNIY7IGLdlj9a8mH0FmXlUxOZVhOpiGwCzucJWsZW2mBPzmLY3JGftChIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kxn1FSmz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kxn1FSmz"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK1NSFW006772;
	Thu, 20 Nov 2025 04:16:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ZnKDae4LtKJrmhFL6S+5tob0O/QNajqnFQsCjhMHDoU=; b=
	kxn1FSmzK+oShv99WpnOnw48/WfwVqoh6zAH915kIQDJHDYRwNejt1vj8wSUns8b
	Z36A8+2fiXG8CNiaUVqknK21864+F87qYKVvPEKoxvJPAeOi0hI2S1vSs18J9pq9
	zZWBDs+UCWKjvWd8b6d5wFEuJZbnENgkFsxG+B5jusoPMwFawaspir2wTLHCIYcu
	0JFY8t/GLhJgD97mMpwExrJRiaUgnWkuOnhObcdRUFitZFroYLzOQjJ7PKryuaWb
	UJCUAL64sERLMBaz7MC/bJAaV1TEt6EBqVYDAaAUbvcaTeCvcALkijX5wiUa5e8g
	5YSNsAjCmU345xaE7/qcPA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aejd1ga3b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK28lZf007971;
	Thu, 20 Nov 2025 04:16:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh49f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:21 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPT012546;
	Thu, 20 Nov 2025 04:16:21 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-2;
	Thu, 20 Nov 2025 04:16:21 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Guixin Liu <kanie@linux.alibaba.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur Simchaev <arthur.simchaev@sandisk.com>
Subject: Re: [PATCH] ufs: core: Remove an unnecessary NULL pointer check
Date: Wed, 19 Nov 2025 23:15:51 -0500
Message-ID: <176357169030.3229299.3812959379271642190.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111184802.125111-1-bvanassche@acm.org>
References: <20251111184802.125111-1-bvanassche@acm.org>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=871 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Proofpoint-GUID: KobVKTLtkC7sOnLzE19n0n3P1dPRBC1H
X-Authority-Analysis: v=2.4 cv=Z/jh3XRA c=1 sm=1 tr=0 ts=691e9616 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=WeGd3k_Ka7LNF8OCTdoA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfX9rI9552HFSod
 9XvcXMmFPGeJvScvpUL92pjAi9zl23OhDsMCVghfXpZsZ8cI0UVBZ+LjbjwJzLpeUAhWRSmYcu5
 y4jyLTWDruzSReWqNKeHsHsOpQxVH8yglvKY6qCGLGvg+wscuqX9R95Q+D0Llpgw1gBtbdUBtjc
 JTozaQAKvgBWbxB/7L9t+OBrJFbGw6w37teGn1LS3TxV3UhHJf3x3YA8VI3iHrm977AP/RUEGeC
 5ptMzboXGViz1xsGpQNnwovnxJHaZqvwsOtnsPYMHGWVSgD0LGYucEebdj25PhafkP87/IdQcq9
 EEuh93rrPHLnJZFImlpEDBswQeOTG8ViLmig08tkDQGwGhdihjj+dW8oy8EYuQ4b0XsuMnshS2b
 Bp7NAqYnOMAPaTHZxnXHgHE5579B3w==
X-Proofpoint-ORIG-GUID: KobVKTLtkC7sOnLzE19n0n3P1dPRBC1H

On Tue, 11 Nov 2025 10:47:59 -0800, Bart Van Assche wrote:

> The !payload check tests the address of a member of a data structure. We
> know that the start address of this data structure (job) is not NULL
> since the 'job' pointer has already been dereferenced. Hence, the
> !payload check is superfluous. Remove this test. This was reported by
> the CodeSonar static analyzer.
> 
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] ufs: core: Remove an unnecessary NULL pointer check
      https://git.kernel.org/mkp/scsi/c/18987143d4b1

-- 
Martin K. Petersen
