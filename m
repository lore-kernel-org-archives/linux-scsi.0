Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E2E204F99
	for <linux-scsi@vger.kernel.org>; Tue, 30 Sep 2025 02:37:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759199833; cv=none; b=rkxGHfmjutplFqu0MGr41GL5G6R7cm9zK/DfNuOBM2CFJ8E37KucNYcAWKyZbvXQZpTU7RLdzaiI1fRlAQC4R0UuITX96RuFP1Zr5b4PgttGkfh1tMff15G0YKXO2KxjtlEYqJcJ4Uy8qR6xw3rG27umc8Fy2eZN4M3qRCMpn48=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759199833; c=relaxed/simple;
	bh=hrFIqnF+kHHtvuZeiwESbSHaHEccxXwG48LKyAcU0KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tQeu2Aq8CtY03xQwU7TJC2XLfLvAK1HSYDqKAuHv6SdDxgN1M34/FgVBPjiVBjl16/CSmWwScDMX7i5WdNsRTLVJnGEvSYBpjDvXqIWukvbJke204P189HdW81IzOvI7YqsDIqOiL2ZHQhyCwwSf7tW/b+JRMlZCsROSIf3URck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iWiuoS5L; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iWiuoS5L"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 58U14csg025573;
	Tue, 30 Sep 2025 02:37:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vLNvmAX5Xt8Q/R0A2/3tomgqsbhwzkRUJEIgjrj+27o=; b=
	iWiuoS5LMMbOQC5KaqI32Svtpm/4TQA0tVW6SgmfPWYe7CTMjbtUgGjqShCKKi3Z
	v2ysLDA9MnpV2coA7gS/e2Z4U5SRYtSK1gIkvBcygZ1GdXZwbxz1kDEHaadHaLNH
	fd7P+EK5ByDgxSiYNhOnqARXrZU8jhYy2JDuzHc0NaViY3tWdZFmP3HAykEPL8Ql
	+UAvqkOGklJwYcnl037LIaHHUEu2HTQvRZ3+quHdM/OvdvnQqwha5IH7rzfn/G40
	ff3ZPojO2fqIjmxlPkWs2+Ygfc4NBljxiAesBW5mrlIRL42DJ+xt2PGN1GQ657Mc
	eGz9pNIlplnrN5fvg9YYyA==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49g57j03tf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:37:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 58TNPJfU007737;
	Tue, 30 Sep 2025 02:36:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49e6c86eva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Sep 2025 02:36:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 58U2awVB004400;
	Tue, 30 Sep 2025 02:36:59 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 49e6c86eur-2;
	Tue, 30 Sep 2025 02:36:59 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        James Smart <jsmart2021@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] MAINTAINERS: update FC element owners
Date: Mon, 29 Sep 2025 22:36:48 -0400
Message-ID: <175917739983.3755404.3468767422669757188.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250923153857.100616-1-jsmart2021@gmail.com>
References: <20250923153857.100616-1-jsmart2021@gmail.com>
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
 definitions=2025-09-29_08,2025-09-29_04,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 mlxlogscore=610 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2509150000 definitions=main-2509300021
X-Authority-Analysis: v=2.4 cv=VcH6/Vp9 c=1 sm=1 tr=0 ts=68db424c b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=IkcTkHD0fZMA:10 a=yJojWOMRYYMA:10 a=VwQbUJbxAAAA:8 a=0W-ltN-VO2jgyzCNt1IA:9
 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: IZ5s85aGgnrBVOB17z3qWyXDxoT2NjbE
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwOTMwMDAwNiBTYWx0ZWRfXydp4iuJewIJB
 mZfxTPnataDsZb/Hol8HdEaAqjHAYuxO94eP8PaKMwTEX8nuHl4g5SY4NA7jWAdo2YkCWEIyQX+
 rggRCNBJ5HotQDXTH/xNkq94Imi5DNm0/uiMY/1idkee9Qrh9eDwWBrIpxTD0XJ6vUKPT+u04nO
 3b56epZCbTZqhcN+aCgbR2PEGqSDOdVBWuqgDDpLyL6+A1Wakle4zjX/dp0GrDrweClqSfkC1HM
 xBXWqgGhWep/vNrSkNYUHBOr4IGWWZTc8xjvOw1EBxbxUpNgH9E/dzJA+5GKRevLwG2TljKpoyU
 qUVFdBZz42Xru7UGMvn33SALPuiJvqaQNKDp52zHVnTfhV1Tw6AzubdL82xAzeaf+S/LQCUOLpz
 32RLMbxS94rw9/++g6V7Z8GWH+zLbw==
X-Proofpoint-GUID: IZ5s85aGgnrBVOB17z3qWyXDxoT2NjbE

On Tue, 23 Sep 2025 08:38:57 -0700, James Smart wrote:

> I'm relinquishing my maintainer position on the different FC elements.
> I am updating them to the Emulex folk that have been watching over them
> for a while.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] MAINTAINERS: update FC element owners
      https://git.kernel.org/mkp/scsi/c/fb641516a668

-- 
Martin K. Petersen
