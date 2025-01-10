Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F65D204098
	for <linux-scsi@vger.kernel.org>; Fri, 10 Jan 2025 21:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736543857; cv=none; b=t8Limd7eB976xkMP8GgGLD0RpvqUEk6+cIEmZlO5aY8qjeDd22XkePxVPIcWPcQd6gaSo1Fhea4604wZbwy4ubidX6firkdHSVscn8hO81QfdAK13mp/6+soVN9nwUbOwQa6UDDj1TTIl2xZElbf7CWd67JnIDxnlHZ6UN3k7AM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736543857; c=relaxed/simple;
	bh=/Di7beZGI24/u7oP+c13cuuCApFEnntgIkyd5cEWoTM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=H5M1kl10kLUkhEAAvVtjJFasOr5spMBqbCNaxyW6yybU79cFI4b4NhEXGGjB1ubv1xP0f6rbGHTvjjszwsGV8MCRrOy2waIYop9Up+bKPXdFUXgd4pkXdDraFtkuJ+ySdJp9EpZ5xvO9UMm3rESE66XfLRHHfaz5BXDQS/heh6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=RXFTfkZM; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="RXFTfkZM"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50ALBm7X018732;
	Fri, 10 Jan 2025 21:17:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=qzVdnRhld3d25bKnxvboPkigjTPcjfZv609dlNKErYI=; b=
	RXFTfkZMKJU0TlGZy/x9ydRLgXEPvmCCtxWKV9foqIGyGKo3U8cEMbOmb6YiAWoF
	6Kqv2to2EHKyv/D6lEUz4xWORgpebG/Jj5dyIeNGSCCNbKJtmLtfGzxGX0SlDOsj
	dgGnCZkjQYOBxzAiWLEpnKX8aBY8PdO0aRWVlv+AOn56SfN9SjTs3Fomv0hJ/IQb
	H1ePC8D3wDx+WXeceMmhV4tOyIu9LRbeePvnCfElfOYt1ByxHissiLQM0Op7dAuW
	fg31myuLXv3GNHXkBFjpSG1zyyOul/awyBsP8VccCeWvFFMASK6+lC+cdY/5VG+p
	1p6C8L5N5PGE8aOqBVYv6w==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 442kcxabdg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50AK2tYA026550;
	Fri, 10 Jan 2025 21:17:27 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 43xued5r47-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 10 Jan 2025 21:17:27 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 50ALHQ1o034137;
	Fri, 10 Jan 2025 21:17:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 43xued5r3k-1;
	Fri, 10 Jan 2025 21:17:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        Ariel Otilibili <ariel.otilibili-anieli@eurecom.fr>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/1] drivers/scsi: remove dead code
Date: Fri, 10 Jan 2025 16:16:43 -0500
Message-ID: <173654330188.638636.13544089296953730749.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
References: <20241213225852.62741-1-ariel.otilibili-anieli@eurecom.fr> <20241213225852.62741-2-ariel.otilibili-anieli@eurecom.fr>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-10_09,2025-01-10_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=668 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501100164
X-Proofpoint-ORIG-GUID: edzYZMmC2q28SZ0ZOCAGb4LwpeRxsYmt
X-Proofpoint-GUID: edzYZMmC2q28SZ0ZOCAGb4LwpeRxsYmt

On Fri, 13 Dec 2024 23:57:29 +0100, Ariel Otilibili wrote:

> * reported by Coverity ID 1602240
> * ldev_info is always true, therefore the branch statement is never called.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] drivers/scsi: remove dead code
      https://git.kernel.org/mkp/scsi/c/850f814b01a5

-- 
Martin K. Petersen	Oracle Linux Engineering
