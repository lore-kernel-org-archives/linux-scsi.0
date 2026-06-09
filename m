Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B80CB30E0FB;
	Tue,  9 Jun 2026 01:39:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780969174; cv=none; b=ICmN9jignwETrnKTFIhLnSs9aKKdAmcH3GRpNC0dljQ/Sh9U+Edp4U4Wqrcel9KdREOmBXZWJWvHrlkoDYaCS3Ah8wz+mQ4OJPyixeM+mWDSpDxAXIIwrIKJNiAQfdHhqTvU46HLuBsm78Z7sx7nTCJXz4IatFM/8I6cGftBIEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780969174; c=relaxed/simple;
	bh=jPr3bw3y4iOnV0cMOk+Zu/DAivUcOCD3d5Rq9Z1qq9w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rBShmzT1/t4TDbOAr0WXAzYB/4Y5rv+j1/2YC1wvXEfesoHjNvqGox4t4CjoHQEl0xLmKk+IXzPXEtfbru4YJw0Q4ICsCbDJPJZSAiF1hS13lumNeDd+Q3Zc16ts3KFvgvhxmo4L+RF3R18VRoTGVvdGmKnfGGTkYckc0UgMl+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=q1BzmG/s; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="q1BzmG/s"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 658HSUaI1690093;
	Tue, 9 Jun 2026 01:39:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=IvJ/OP8BmyxjZ/E+K1UO316wfhfyls0xhc+riDZgKZM=; b=
	q1BzmG/st85ypKL6ajTypY4rltK0CM+THtgZVSVn5p0fxDOiYwNtF+JWKjEZMohB
	oIqx8AQZHZWasHWjozVKpRcGnlLh2JBOurFx/XRD1vTcO7hmfCXwJDVN2BN8HLjy
	/Zhfq+5QQgImejly4ieOs6OXcg+YfLxGbv/Gmqe9znaZzoOGkggc6ejk/m3l+bOL
	ubw9ZZS7Fvd5MEHFDk0CQNY3YWHOFe9CNJy/L//UASe+FB3GP3q9XnGwKcDrSFT8
	OHbz1W/3bP1Xo9ACaj2fOGQaZ7EASCu41LBbmzJBqIhdmbITPD6JFJa7nF17TLVd
	a/NXfK2LToge4yNS6wB70A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4emab4kh1g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:11 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 6591caME028076;
	Tue, 9 Jun 2026 01:39:10 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4ema0pges4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 09 Jun 2026 01:39:10 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 6591d6Ar030153;
	Tue, 9 Jun 2026 01:39:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4ema0pgepy-8;
	Tue, 09 Jun 2026 01:39:09 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        "Ionut Nechita (Wind River)" <ionut.nechita@windriver.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, hch@lst.de, dlemoal@kernel.org,
        robin.murphy@arm.com, john.g.garry@oracle.com, axboe@kernel.dk,
        m.szyprowski@samsung.com, ahuang12@lenovo.com, ionut_n2001@yahoo.com,
        sunlightlinux@gmail.com
Subject: Re: [PATCH v8 0/1] scsi: sas: fix mkfs.xfs failure due to bogus optimal_io_size
Date: Mon,  8 Jun 2026 21:39:01 -0400
Message-ID: <178094912072.1810714.9115795923804476782.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260519135238.373784-1-ionut.nechita@windriver.com>
References: <20260519135238.373784-1-ionut.nechita@windriver.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.125,FMLib:17.12.100.49
 definitions=2026-06-08_06,2026-06-09_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0
 lowpriorityscore=0 spamscore=0 mlxscore=0 malwarescore=0 mlxlogscore=372
 adultscore=0 suspectscore=0 phishscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2606090013
X-Authority-Analysis: v=2.4 cv=cL/QdFeN c=1 sm=1 tr=0 ts=6a276ebf b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=FelO9ux0wxsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=o5oIOnhZENCTenyL_yNV:22 a=VwQbUJbxAAAA:8
 a=t7CeM3EgAAAA:8 a=EwlQa_qvEpErnvP18DcA:9 a=3ZKOabzyN94A:10 a=QEXdDO2ut3YA:10
 a=FdTzh2GWekK77mhwV6Dw:22 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22
 cc=ntf awl=host:13723
X-Proofpoint-GUID: qHGR5GtSfRdE37XMffGVzBXrewjRwIt1
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNjA5MDAxMyBTYWx0ZWRfXxhTicKgkslf1
 KOzBJppRa40qbTjnWcE/BDQnXhn4hkV1e4cuOpCmxr/RLME/GeSuYBSR4cRBydl3OOIgKMW+Ny9
 00M/R1dplfYYCsNM2vna3DLJEWnXtuinT1rONOBOK27aj6XE+4uVrPJBBrRmBVJP2Un185As1x3
 Y2PA2HXvenw+X6cN4Q3xVUOwb0TC+GiUpj3ZCjr3M1uUBLYvjyNvAxy5jXYslxC1qKn8HJfjw9C
 kor3AL3mdQH5xN5yVoIQCJR+0W5bA1eXaeTmdN/Qw1p3tSZFYteQqr9b+lV67hagU+/7hiYJcjM
 PxmnAbCywlaKHpEjXg6Qx/Y8jbQEfmBD3k00IMZ41pvpYmkEaS4QvV2YlpTXjwu8qXladxaGjO7
 vzGgI1PU5PgfZ1HP4SigBrt57Ap3vxYkC8fPW+cXNOHTbo/tSV4QXiscSLnmV7HV3ZasrgJ8BcR
 0wSegLjCHdtMhC7WNZKKI3CNMc9NE/BIwLRQcCgQ=
X-Proofpoint-ORIG-GUID: qHGR5GtSfRdE37XMffGVzBXrewjRwIt1

On Tue, 19 May 2026 16:52:32 +0300, Ionut Nechita (Wind River) wrote:

> From: Ionut Nechita <ionut.nechita@windriver.com>
> 
> v8 (per Christoph Hellwig's review of v7):
>   - Removed the dma_dev->dma_mask guard — dma_opt_mapping_size() and
>     dma_max_mapping_size() both return SIZE_MAX when no DMA ops are
>     present, so the opt >= max early-return already covers this case.
>   - Added inline comments explaining each conditional in the helper.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: sas: skip opt_sectors when DMA reports no real optimization hint
      https://git.kernel.org/mkp/scsi/c/be8fcd4a8217

-- 
Martin K. Petersen
