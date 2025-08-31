Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 231471DED63;
	Sun, 31 Aug 2025 02:11:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756606313; cv=none; b=fPI3xSlR/UtNMjFsUHbC3TJvaN4EX4dPV6FEK10Nhe9djonuG3kx3tDRF+XBMKvYzN+RKr6iDhvYa3tfReo2YATVxQvZMQiT1Fh3h8I4/lFQrciw6U9G2xTzwOaK6B5Xf5tVCu+Q9cUg7YBWS2nM5QoFLsOFRwGsxswmIt69Kqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756606313; c=relaxed/simple;
	bh=DZ5xZYLURQq7ymuM/fSbkYpM366kgzLwlt/Hsx+Hsks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g+YnAnpvMpWTKzi8s3TGUdy/Sf2sO78RvvfdrzYzk+1kVUoedM4mU8EIZJVn4aMEbtdYqbTFGbOd0GSNx+VVCaJC/0uLbJXdxscgyYkImEbJjJnr9BCmYkpcZ5m3cJMdDYT8EQHrLekmSjEG2xAm+FGassw/qt6yy76XW0/OmXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EVKzplBK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EVKzplBK"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57V0EdaS010297;
	Sun, 31 Aug 2025 02:11:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=R/WiPdnMXZZLWe0ZOEXjRWzj8txz+VMrrfGtuW5IiI4=; b=
	EVKzplBKCM2ZeggZ4xXydyNOiftKGRkhhWksIm9yXfMMilR9L2VnqIxGa2Rj3bio
	C93K4YOAAN2WA9jb19y8TibXHj0ubTW/KAVx78guz+hHSYoNIcebmz6Cekqq2cZn
	2Y5FUr/Veowm8JAcnI/4UJq4HQcQzG9sncb9BgQquAvXSStPLexdFJQ1Nz6Em+rw
	tVvhRlB0czLY0H6hBKWdZ/lQF20o4rjzCVrqtFQ51o8WEaRuTOOcKX1pOgXhTJmp
	6w34msBw/ArloJ1m4ZA8+Bbik/Wj4bd7gzB8nWl81Lx6jgzhACS5wdYtMIENfCDt
	r4ZKIaYJidNspArf7RBEtw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48ussygm1s-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:47 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57UK0YcS028686;
	Sun, 31 Aug 2025 02:11:45 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48uqr72m55-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 31 Aug 2025 02:11:45 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57V2BjAq019355;
	Sun, 31 Aug 2025 02:11:45 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48uqr72m4v-2;
	Sun, 31 Aug 2025 02:11:45 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Thomas Fourier <fourier.thomas@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: myrs: Fix dma_alloc_coherent error check
Date: Sat, 30 Aug 2025 22:11:41 -0400
Message-ID: <175660145351.2188324.2843494382433871150.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725083112.43975-2-fourier.thomas@gmail.com>
References: <20250725083112.43975-2-fourier.thomas@gmail.com>
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
 definitions=2025-08-31_01,2025-08-28_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=593 adultscore=0
 suspectscore=0 spamscore=0 phishscore=0 mlxscore=0 malwarescore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2508110000 definitions=main-2508310022
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODMwMDAzNCBTYWx0ZWRfXzq6UV3S2qInY
 zbcpuu3tkB6ZVn0AJWa4PtbwzZuzU06qss7iShi8s5EKcKAnP3JpbjQcywUvjaknEhi57VakBww
 vXmSVjoc5KpDQXXFRzAd5521RGo0dNuepr0m+HmlO3XwqD9YswKQQqiexCtLKDoZ6fzWrdd2iOC
 UJl1zx8JppPq+C63KFoNt2M3sR59NgH1a4GKfo44wwz6ErBSco5OBef1hZpLdl0gwb/367g7HiE
 SmrX85JNRDRTLdyIDx9HzWaVMQ7mdugKDdSiu4QJGdV9gjYemsc5k6QyBFCCY2R/Ac46/nvencj
 hJFn0MEtBb3FAAmQSSKZOI0lUptm+llpy5AJLq61i0yFj8serenSfWac1Q94PZBAXk2Zzvi8d+n
 uPw1PXPolPjHqlrguWxz1kzXBwVbQQ==
X-Authority-Analysis: v=2.4 cv=X/9SKHTe c=1 sm=1 tr=0 ts=68b3af63 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=V2PXUoC8NQQSPf-sLb8A:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13602
X-Proofpoint-ORIG-GUID: UtD2dQ6V0H6Cn5ED-zWXK0Bb0eJ1IG_Z
X-Proofpoint-GUID: UtD2dQ6V0H6Cn5ED-zWXK0Bb0eJ1IG_Z

On Fri, 25 Jul 2025 10:31:06 +0200, Thomas Fourier wrote:

> Check for NULL return value with dma_alloc_coherent, because
> DMA address is not always set by dma_alloc_coherent on failure.
> 
> 

Applied to 6.18/scsi-queue, thanks!

[1/1] scsi: myrs: Fix dma_alloc_coherent error check
      https://git.kernel.org/mkp/scsi/c/edb35b1ffc68

-- 
Martin K. Petersen
