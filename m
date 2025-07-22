Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB8C728C86F;
	Tue, 22 Jul 2025 03:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156069; cv=none; b=T/wuNDI00Cjy5o7bx062bLUn2CmVEdd6ZPLOUvWMznGQO9rfUkUGYVKCDdlrJxAaQAzweAB/OR/1t6+gsw6XxDAQYHExhTit3OwuGILfRid9sOvAs/aUFHHdZF1ta8apHWNr+U9I89WTfaE7gE7xqI4wppqpqMuCbqwye8782Qs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156069; c=relaxed/simple;
	bh=gVIMYQ5j2AagXpIJ0uMBVoUNtf+0IjZXyodWmxdCY/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XV4gJCURhAeJghhO0svkYM9ljh0ErIqbp5tR96yfCghINGv+tYZJcMwFLk7TBKTUey4F6IMTLiDGYqwG6W2UsSOIJR90nHPsUMFys6jHjjuBawGuLhT7V8vILd3oIvuHwrAs94j3Kt/DVin79zEuYqCgQC5W4a9bxw+tjJMYrIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RASdUTLh; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RASdUTLh"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BtYq018886;
	Tue, 22 Jul 2025 03:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=aiUSZgrEEPeJ1gV9vVCacUT0s1TXJ+BP+RloL3Y5++4=; b=
	RASdUTLhXWXmN0pKIpaWcX3Dngd/E1ZZGaoHmrJFgg2AOW72261xij5GQH2hKVhI
	0N9zSDnCXnwg9hq309Abp+qz899WJGgqMikPcSqtG1KCU1GI79C1CZ1GJJgDFyHU
	wUdRxVPoZ/c0RnYKzNWgu/5fpLg/y4VZPu76hg5/tsoxz1bhct0dmQbQCYajtvvE
	wY+/gw5EeTNwRHrIgEVpJ1gl47iF7fGKZ8kbMUhQuKXADQzV7/5s3WiWgpIjDPqC
	CJe0XRYPIFQyZgbnYmTZSSY7QuyCYwrxnBBGcDm0vvpp4uL8u2Oo0dOpiG03P6JD
	YvYfMDx9TSpj4nc3v6G0cg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 480576m5vs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1W27m038352;
	Tue, 22 Jul 2025 03:47:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8tea9-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZjD031915;
	Tue, 22 Jul 2025 03:47:38 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-8;
	Tue, 22 Jul 2025 03:47:38 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Peter Wang <peter.wang@mediatek.com>, Hannes Reinecke <hare@suse.de>,
        Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: elx: efct: Fix dma_unmap_sg() nents value
Date: Mon, 21 Jul 2025 23:47:01 -0400
Message-ID: <175315388534.3946361.13563089829199949177.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250627114117.188480-2-fourier.thomas@gmail.com>
References: <20250627114117.188480-2-fourier.thomas@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-07-21_05,2025-07-21_02,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 suspectscore=0
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=706
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX/lld8WpQKPBi
 QgWm4kxZTTZBUwagaosrwDznHdBU2aSk+CM52ODXP5uUxW6XJbVMUedHtCJfy51/zi/LlkcVIqN
 CO+vOEnL62SFFcegoXKwMOVvMz6w/Y9U6oV33cnLyDzCR8dNlGdHPCxgrZE53tkUqqyJUxkud/A
 5A4M2sWkkR4kmDHTeDKZiBuRTkc7jDZj6qx1r6gTLSM3iwDvUwMgfhyQKBwtjnRb40JIF3cvGDi
 z42DQLyV0H13l7PHqYBR9oNpJZEuhTQzX79svlD7wNR5aXMB0j62gJbLKzC18wMXHIYfX1PhA4Q
 oB6UQAnCVxcjcrXuRB80cO7NYr3nsznc7ziIie0Ca+OjhY2ujAO5rmlxHkSTZNJM26LH8Hz4BN0
 bb4mvFUncKLkK5Pb6N79/wSO6GJvFCBjrlXcPyTsCGNxJpWfUVTxe3n8chdC0YzBy5+OlL6F
X-Authority-Analysis: v=2.4 cv=doDbC0g4 c=1 sm=1 tr=0 ts=687f09db b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=HazmFS4AVfT1MZ3w-mIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: 66Y9FXSniasOkURNjRvGqeSSxT-smizK
X-Proofpoint-ORIG-GUID: 66Y9FXSniasOkURNjRvGqeSSxT-smizK

On Fri, 27 Jun 2025 13:41:13 +0200, Thomas Fourier wrote:

> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: elx: efct: Fix dma_unmap_sg() nents value
      https://git.kernel.org/mkp/scsi/c/3a988d0b65d7

-- 
Martin K. Petersen	Oracle Linux Engineering
