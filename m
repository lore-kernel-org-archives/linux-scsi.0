Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4CCC4430;
	Wed, 21 May 2025 02:19:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747793995; cv=none; b=ainW5DmhERCHY0HZd5eh91eWsV2dCA/+7EwhceHacdQPDBrPPKKQlCwz4ITYT/yczqM68L4GYaSp6db1nUpJYeI9bRHAvB2W0FgrBYqvvQN1uDVJuQj06ISCmuoA6AJJsqPSU+MPWmd0kglL5SKTuPuPBum96Q4HUpmlPZK4im0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747793995; c=relaxed/simple;
	bh=AGT1ZE6/R7v107HaChzUqCzIGgch4xMNDRg3DkmpN4Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bqImbpGdRdujsye81IcaPUXAwjs3FKjksF2uJsQf0uZXtjCxDmXG1Mm+1DdZtTV8AuCebvkffCstknhB6aOsDwd5wwMO+bMOxQ+UAeorrk5dYv1mrfpgf9fioreKCTOQol35wG0RO4fcLrVo6zyZ/RCy6njX1F6dQFCDOks2Av8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=pr8+UwuG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="pr8+UwuG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54L20ZAL019538;
	Wed, 21 May 2025 02:19:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gB9auwAMQ8uG2NCJ5YgMTwqXXKspFiOQZRDIWFE7Zp0=; b=
	pr8+UwuGA/zUx/yrump7KVrS2uCpKPJ1rg6RRgfMU1c4m2oJdmVgGk35DD2OmcqQ
	4b64vO2i0NO1goFVJW+5w6iKZ/AGdEbbJToEt0CRs42E1iI/Qo/G3tSuAnvXTTo5
	6/nRhIBLh+eszvj2eoYO4d9z68qQeOd1Azw/3eYbb1vaYKkKObxHGJXkeaPkiliQ
	XcWdwKbXzJzKCjIURGHRtTi46H2qqTE45bi5Fx47e5MRTJkhvklHlvGAlFpNj01r
	znZBTHvhIGYbSxlglGFSdu7p4B+HDHnIUIVH1rFVHh9hANm/TG4wGMV33YpUzddj
	7kZa4jIldCou0At+uUeqBQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46s5nng114-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:19:50 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54L2DlIL032202;
	Wed, 21 May 2025 02:19:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46rweks9hk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 21 May 2025 02:19:49 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54L2JmZv004389;
	Wed, 21 May 2025 02:19:49 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46rweks9h2-2;
	Wed, 21 May 2025 02:19:49 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Nihar Panda <niharp@linux.ibm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-s390@vger.kernel.org,
        Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>,
        Alexander Gordeev <agordeev@linux.ibm.com>,
        Christian Borntraeger <borntraeger@linux.ibm.com>
Subject: Re: [PATCH] zfcp: simplify workqueue allocation
Date: Tue, 20 May 2025 22:19:17 -0400
Message-ID: <174777706869.55368.13052714087766349823.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250507042854.3607038-3-niharp@linux.ibm.com>
References: <20250507042854.3607038-1-niharp@linux.ibm.com> <20250507042854.3607038-3-niharp@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-21_01,2025-05-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=768
 suspectscore=0 phishscore=0 mlxscore=0 malwarescore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2505210021
X-Authority-Analysis: v=2.4 cv=AKGD+0P9 c=1 sm=1 tr=0 ts=682d3846 cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=uFN64bXh-R9ueDPmG3UA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: RLxVmp8F1BDO6KsLgV2UNiTdoB9pSo-I
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTIxMDAyMSBTYWx0ZWRfXzQaPsuVpLIMz eRm3ZBBXyiiscLfZFthyuKVvZsu6LUfp3o/FBm4xGiO2XGqtKykW1g7UW21UG4bctYO2QSWRFGU TAlANjvoMyfQ27BRIY0oWGRteleKFlCIWd2+wfhLKXX9trPry3DMxvmNb+sPIPo60mWX0d5hg0c
 S621s1TR5tOX6A+bB9TXyz/wbXc4yyQTK6Yta1uFSgdpRa+5dR/ysTRuA8u0Iba+XVcXjuM9BJ4 xmG8/nRoskxaC2RLemQcEnvbmRI+jUdr/ELi3s27R0dUQit8pUQAiuAu7aCndrmXnyCOZVOel0F m9QNfBsT3f7Hv7yWq0fqvndMMVLu51WkpHivcdgvLBYjGUrzbpluZQwILwfUAGcC9WbRyxHBw7h
 SpoeABEx1GODq0EhufGIKCCw7WdPJ3mnB07Rbu616ImaxFpIBJ+3bt2LvPEjoAEfI/lxT97A
X-Proofpoint-GUID: RLxVmp8F1BDO6KsLgV2UNiTdoB9pSo-I

On Wed, 07 May 2025 06:28:07 +0200, Nihar Panda wrote:

> `alloc_ordered_workqueue()` accepts a format string and format arguments
> as part of the call, so there is no need for the indirection of first
> using `snprintf()` to print the name into an local array, and then
> passing that array to the allocation call.
> 
> Also make the error-/non-error-case handling more canonical in that the
> error case is tested in the `if` that follows the allocation call, and
> the default return value of the function is `0`.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] zfcp: simplify workqueue allocation
      https://git.kernel.org/mkp/scsi/c/769d7fbe01f6

-- 
Martin K. Petersen	Oracle Linux Engineering
