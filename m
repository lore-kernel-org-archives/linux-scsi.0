Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4960428C031
	for <linux-scsi@vger.kernel.org>; Tue, 22 Jul 2025 03:47:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753156065; cv=none; b=WW6zCWBSQb0eFpayn2Qa6Q9VlYimjt5WK5DIt/8EY+a7JZ+kMe4/L/TqOkRI9xxG0Hvei+ktWJ0hMLBgSBHyXZDZoJFOpoGPaje6de+5Qa0onuDAY9Qy3vLal/+8vX9GGEZuThVUxElHfsiJKcbbm6SXbsxV8AppXpW5yzoBqK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753156065; c=relaxed/simple;
	bh=gNKXekLMJ17iwVGLaQiFQ6I5RIe+PC7ObTPnsEdQB/o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=sedSBqe7uTyXvpv0fj1dYWAN/6WoYejQXdu3EyyxB0Fb1zH0PY4u8siSvMqZX0MtF9rhFlKFQAKjaLXcMSfOeZ+XoVCqioejTW6YCdzBuiMaH7LoZGJNjz9dEkPst9vEKjQdWZXGYI+j02tMoZkBJYTFgjLCz/687dtk0ArGNhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=A/nj8gdz; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="A/nj8gdz"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1BtQ2024032;
	Tue, 22 Jul 2025 03:47:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=uWw1UWyJwUMcg0WpeU75bVn3HiCVWRo4pCdCAnEKku4=; b=
	A/nj8gdzrcZzQ+i1SodNB79BPLR0M376gBIA5QEhUtV1zdVxEjHPc+Gfq35NPQzh
	6UTbdixQpnVK6KKtpuMa54UXTyV6mvNtxsbrHRgmJ14OVWBz5gKzKXDr8GvXRQTz
	j4L5hiZl7f1gmncupRnjeCFN0/DU9IYhByYl9bwbshhZeeh9kpDENvgUE2JlSEw6
	Z+OQellpJsH7Kg4RQ0qtyGgt8MCLmS5xulZADvnxczlwXay3/JCey3QPTLRNywO3
	YaR3MAK/U0OpHoHsWphpJQWplgVTVECZjqv7gJY4xhJYuI2Yo4yhsx6JJAlFUrYO
	KJ/k/RI/fQ4pSxoeVoLTRQ==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4805e2c6rh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:40 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56M1RQVU038445;
	Tue, 22 Jul 2025 03:47:40 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4801t8teb1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 22 Jul 2025 03:47:40 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56M3lZjL031915;
	Tue, 22 Jul 2025 03:47:39 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4801t8te8u-12;
	Tue, 22 Jul 2025 03:47:39 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Nilesh Javali <njavali@marvell.com>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        QLOGIC ML <GR-QLogic-Storage-Upstream@marvell.com>,
        LINUX SCSI ML <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] scsi: qla2xxx: remove firmware URL
Date: Mon, 21 Jul 2025 23:47:05 -0400
Message-ID: <175315388512.3946361.1748336153132768021.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250624190926.115009-1-xose.vazquez@gmail.com>
References: <20250624190926.115009-1-xose.vazquez@gmail.com>
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
 bulkscore=0 malwarescore=0 adultscore=0 spamscore=0 mlxlogscore=961
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507220028
X-Authority-Analysis: v=2.4 cv=WaYMa1hX c=1 sm=1 tr=0 ts=687f09dd b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=x48yyBCv10-6fGpxPiQA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12062
X-Proofpoint-GUID: LjAVGLopd-H1l0vPCi-fipR3hfqanp-V
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzIyMDAyOCBTYWx0ZWRfX39601rD+r/Oq
 Brbvm7/sEHhhu4+BTbkhiwDXlvZAqj4GmKPYf/W/Jmch0bCgqnwZ+Gbx8/MRujQM9HlCmemAfbU
 0vKh/k9sxhZ/iGanfGfQUe29/DdyqcOqAdG7f1NXleg6Mp/kWz4YwlhtyV4bjnr0X2BkT3pvhDB
 jDGPQB2PCO0qQMU7jAWy3zf8R2wors29Io4MCMIRBpG5G/6VrV4ZUPv4v0PsLDAcQWB9m/RWJjx
 bvtc281mo/nKQaXDmApuEk20PHZ15FTdMubY6iOGgcoBgAWKCUr29nJ8pEQJOKNjOv5cx+qsDtj
 Gmag0k1dMOWUWdVj/e8bscFlcqkCEf4ZG5utMwZ2+GeS7tgA5o11dPy23H1KfNciQH4v9P0TBIQ
 0zA3P1HIy0puIGGqDJXgJ4NT8OZoLloFHOy3DoRT3ju0OVne8FwA2rdcONUP78DEu9M/JYOA
X-Proofpoint-ORIG-GUID: LjAVGLopd-H1l0vPCi-fipR3hfqanp-V

On Tue, 24 Jun 2025 21:09:25 +0200, Xose Vazquez Perez wrote:

> redirects to a marvell URL, only with drivers.
> 
> 

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: qla2xxx: remove firmware URL
      https://git.kernel.org/mkp/scsi/c/b152f199fa43

-- 
Martin K. Petersen	Oracle Linux Engineering
