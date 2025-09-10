Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FFD325A64C
	for <linux-scsi@vger.kernel.org>; Wed, 10 Sep 2025 03:04:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757473494; cv=none; b=FBTPs8PHVwtISxGoZV01N1uCrCasyB7WrR63BDKeibMd6JimImpU6sm8uu9/+aTeDunZYZ3j0ll6+t36OHarRSv+g169ZUXLCaGiwQ8epzKiuNJxcXJYPSeV1d3fGCeNaLV9QsvlCO6T+/rL/tFZ9RDpVhl9aC8+dxGonmCWFYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757473494; c=relaxed/simple;
	bh=vtwPSPXieZpcbzSUSpoW+RHgsLr1YYqmtd+u1an1dL4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=VCorRNKTRUj9kVbi1cux69/jsK8zVJ0yZlHWx9pUEd6pNqkf5jxyXb1X5cPxxhvUE2y4KS9DakJrHF99MPGMr+xPfWqsQMMB2/54uwDpQyfsYqCiuX1N+LU/fYfybuxtSLL1CilEgMt5R+NJG5GTwz8kCbSkGE4+YF3Gfk9uCmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bQwR4MDw; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bQwR4MDw"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 589L0ag6002105;
	Wed, 10 Sep 2025 03:04:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=U6uFBc0389uMR+6EcBUK1I3AUAZRxeyoJaAqmXzN6U8=; b=
	bQwR4MDwXt8llLZychFbhqy1jV7pj6JX2Fo2bPNVzb7fijCEfxxCNdN3bY7Hw1pj
	v7xahDbAqj5COeNJ1J2BFm/hZihciT1drExzSRE8UcVDLVV92FDdtxiX+G7QB3V1
	vrW3ZGzWA7bgWSm6LNtb10llXl1fCtxO1xuyE95M20sC4oByU9+CRhgsnEbqGTvS
	0RPDmhh54yLG4wIBtBz4nRxsiF0S5JfkbMxlYBzY5El82Sshqfelhh8G8uqjLNyy
	CQv12Eq9k3dhpWGhqWmncXdl5zmTi8GNLiXUysI1uUgVpQMXH2ruCFUnUNnYPq/Q
	0/jOVmgnuYI2mkQnGePwGg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49226su6jj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:44 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58A0GiB3030623;
	Wed, 10 Sep 2025 03:04:43 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 490bdadcvd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 10 Sep 2025 03:04:43 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58A34g5W011326;
	Wed, 10 Sep 2025 03:04:43 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 490bdadcur-2;
	Wed, 10 Sep 2025 03:04:43 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Avri Altman <avri.altman@wdc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Huan Tang <tanghuan@vivo.com>
Subject: Re: [PATCH] ufs: core: Move the tracing enumeration types into a new file
Date: Tue,  9 Sep 2025 23:04:34 -0400
Message-ID: <175746865980.2804493.13129310444073824051.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250829153841.2201700-1-bvanassche@acm.org>
References: <20250829153841.2201700-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1117,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-09-09_03,2025-09-08_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=677 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 bulkscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2509100024
X-Authority-Analysis: v=2.4 cv=QeRmvtbv c=1 sm=1 tr=0 ts=68c0eacc cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=wt1poR6pJfhHg-pYIzkA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: Ka_etdEDnQ-0y1L4i2_PCi0viO6Yjo_B
X-Proofpoint-GUID: Ka_etdEDnQ-0y1L4i2_PCi0viO6Yjo_B
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTA4MDE1OCBTYWx0ZWRfXw7Gqm2yc0svG
 9oIOKxzIkYvE9qy/iUcHNCpHDCSRFe4zPRUQiWvKcW6F8ItYa2EGefJI43t+5DWfU6tDc3c3rZ0
 yPpByktNEv+GGkTGL68N501xQl6jFKFl1Clbv21btznSnz3nBvgGGhenl0GnQadhemJKZL0ztAq
 G+/OulMad5CFKihCWSNksYEzOhgLqp6s2o0T767Mpa+rKy1mVKmBWavmxnl+QQUi7EsJ5NoFeaM
 iiZsKrNvHS1fQvXtV4UOt4j0Uh/23zie7lHestBWmYgWnsM2zALnU3zZgjg1nZltlqeS9zJnOHH
 f/Er94puAY4NpSEAK8Yi7xyQFXpT8dvg/jC2QnxBEnDvBu2wVBxtil38+gOn0AO0U7QVxl3h4vU
 ffyvzIut

On Fri, 29 Aug 2025 08:38:16 -0700, Bart Van Assche wrote:

> The <ufs/ufs.h> header file defines constants and data structures
> related to the UFS standard. Move the enumeration types related to
> tracing into a new header file because these are not defined in the UFS
> standard. An intended side effect of this patch is that the tracing
> enumeration types are no longer visible to UFS host drivers.
> 
> 
> [...]

Applied to 6.18/scsi-queue, thanks!

[1/1] ufs: core: Move the tracing enumeration types into a new file
      https://git.kernel.org/mkp/scsi/c/b620462bba66

-- 
Martin K. Petersen
