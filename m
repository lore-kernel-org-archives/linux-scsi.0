Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D30A1A29A;
	Tue, 22 Jul 2025 03:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156063; cv=none; b=Grev6DDvk/3+EGbJaXmN3CbdtWTjsYKk7Hs8JZ5UsbD59Vwp87t+iXHm7K+/BtDA9V5KOhIA5mzhkJMv2h4HJ0IN0BQOlUQfNcz/0/Hh82wfZcZm8zI9CJz585hs7sIiKWMDL3xzAWwwyjZb0jnzZ/a91M22lUN0nRMIr3Gn18s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156063; c=relaxed/simple;
	bh=6vxV59r/fQpFfZQrx2c0sQc7NgOsg+5Uxys+roTXrCo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=TKIEEp3iQ+bCFFIhfWiOjk9OpZH7xqgImw2MNPdw0SLXyJPSPRfYmbf+xROr1oxhGATlwqnuovud1fSdFdxBMw2zJEYTsi3g8MBxvtKNxMypnKDCZn9l3oAIZt+RSOY7YyFiOTVIS0IPK3nazJQJXZd/8Xs411knG7QyhAbTHJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=kXbzX+L3; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="kXbzX+L3"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1CWiG024818;
	Tue, 22 Jul 2025 03:47:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vU0ZIu+Wy0lUlYK2AP6UW6yqS6tmF1oeQklH+beMWPE=; b=
	kXbzX+L3rQMtjszsgdBddqeQyHgMU4GIxywW2nfL/twQKrQ0uDWSTWmVDpBOUNnD
	lG+ezz4Cs1HQvnHnRtcQxvGXKuclLSr6GHqm34Vvt/nEF/FbQJwn/qhgAOWeRtDu
	d4l1nEEIwJJz1aRy6LT2KNsxGL1uNmZidkvOR12RZ27YHAFeIT+gIvv0prxyLpTu
	Vx4fR+m2zPSBhF+BTXfcAPa3oZ/radr/Id6gSw6peJJlJam+jLyGF5F1KqyE4UGs
	6btHLsbdMGlprRYrCkbUWTTWppOaeWEyFT64al3iaLEW8PKcNA8R01lSTY6IuUOf
	5xpiaWvl93sEUj0zyisIBA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2c6rf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:39 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M252MD038566;
	Tue, 22 Jul 2025 03:47:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8tea6-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:38 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZjB031915;
	Tue, 22 Jul 2025 03:47:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-7;
	Tue, 22 Jul 2025 03:47:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Dan Williams <dan.j.williams@intel.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] isci: Fix dma_unmap_sg() nents value
Date: Mon, 21 Jul 2025 23:47:00 -0400
Message-ID: <175315388537.3946361.4916520582425782179.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250627142451.241713-2-fourier.thomas@gmail.com>
References: <20250627142451.241713-2-fourier.thomas@gmail.com>
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
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=645
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687f09db b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=HazmFS4AVfT1MZ3w-mIA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: g6qLhbbgqCkbGG1-zTnS5U6XEv3rCEVf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX22wXcHZW16rf
 /IJjsESSbcxQkEoPecWaNw+a9gq48MAwn8YtfnYCPQuEKc4dagRKNl/4mwfYkgbYtEcIk6Xiayc
 FjWtFMyCRtGaseXWlFLyOlWLfIqBXcL7cv4/krUJuGplS87Ci3JSixdp9LqV0sPS83qnORq2Wv9
 gbW9h5mkoYoZiwWOXoLRQiCEqfKseA39R5xrhRNO9hoamy+654l1219A9/LELBiBKrgbxxReqVh
 ltFcgnqqq0Q06GQZbjM9Zoc3b0VlVcj5J1jH87j4AtJTBmbGfRIzw5axC+dRYf9mGiE9ukHpefd
 8IBrgBaZDraOJ776Eg9h3xM4AGhEDoIr1cAY9r7fqI2zSJdgGrR1xBrk5m82EPqdwG+WgsGFmtt
 kNRq/jFtiwHZqYgmkwXSSNxDQJMQ0YiXj9INA9FzG2Fx6TbaGg4OpgBD2fiwfXUw7CXlrRgM
X-Proofpoint-ORIG-GUID: g6qLhbbgqCkbGG1-zTnS5U6XEv3rCEVf

On Fri, 27 Jun 2025 16:24:47 +0200, Thomas Fourier wrote:

> The dma_unmap_sg() functions should be called with the same nents as the
> dma_map_sg(), not the value the map function returned.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] isci: Fix dma_unmap_sg() nents value
      https://git.kernel.org/mkp/scsi/c/063bec4444d5

-- 
Martin K. Petersen	Oracle Linux Engineering
