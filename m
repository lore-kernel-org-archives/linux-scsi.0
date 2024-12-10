Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D8821A38C2;
	Tue, 10 Dec 2024 02:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798190; cv=none; b=J/YkYpmtrBlf0lsO+KBoi+yMft1MmW6yf8spL2qKTcI9Fo8dIuUXQ/1povEOvEBXrAQn7UDSYIZ4QtTSbyOMNiFRyYpMOyM+UwEBwD0RjiuqRmbk7XwEbz1obWH92GiKWBZ+TEHLHqNSTCLxJRUDaBl5XTYcoFUVjhfxN2I/j9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798190; c=relaxed/simple;
	bh=1nF/tMwLHFZyslqQYn6Z1IOCs4DNSSz6qUxshFYK+Q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=X7KiHfMxTvXFDWY+W1GqJgFrh0YWd5r47pEBbQxURBJl0uPAD0QirMWJj7PFZgFf05cSQilr3OUOa+jv7GCW42pxfp3+i7JDGV8bjHot6cxNDptBcd1xHwuUK0fCsQSI0/sMU31dlIPSYK/lBqgHBKgZaMw0mguTjWD1CdLWIMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mJH0cCwE; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mJH0cCwE"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1BrW9024443;
	Tue, 10 Dec 2024 02:36:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=FLKlZ7pzzj2Up5JV451pmq69Ku9nGTtxoPz72uSJHyY=; b=
	mJH0cCwEJoAKq4FxXb5die4n5RGp1Ps/WNfdyDV8bx+96n2eYPWK6PtkFWE5XZHA
	vonAZvv30tsUCE5KRVif4kw4bd0zfL2bQlMNE6ZQvr+GPSFgzHMjAcpKx+IEKezU
	JAzZGH6HStrXC7lRXNW/xuTearqAWQxVFJXKhba9MKXZBg6luM2OpNHRixU5dM6H
	teVB8JbADYxkK/yHIdCfbaVsM6PObowMtWNJaD4ZaI5h3Qp3PfzQRBSmoDJ8/9H7
	6ZZXHmfs5tQzEBQ5/5vI6jSPQZrSi2dSvhGM7ZOSIofLRqMnp1oGxfeLNa+Yi4D3
	7H40OuvTDUs7ppopGxF/6A==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cewt4qfd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA03bVR034978;
	Tue, 10 Dec 2024 02:36:21 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y7t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIuv010256;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-7;
	Tue, 10 Dec 2024 02:36:20 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        TJ Adams <tadamsjr@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jolly Shah <jollys@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Use dynamic tag numbers for phy start and stop
Date: Mon,  9 Dec 2024 21:35:38 -0500
Message-ID: <173379777411.2787035.3673927873810857111.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241125213343.3272478-1-tadamsjr@google.com>
References: <20241125213343.3272478-1-tadamsjr@google.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=620 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: q_M07Kfyml8v7Hh_SugmNG_D6Cr7yJkG
X-Proofpoint-GUID: q_M07Kfyml8v7Hh_SugmNG_D6Cr7yJkG

On Mon, 25 Nov 2024 13:33:43 -0800, TJ Adams wrote:

> Other commands were not aware if tag 0x01 was in use or not which meant
> multiple commands could share the same tag number. This changes prevents
> tag 0x01 from being used by multiple commands at the same time.
> 
> 

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: pm80xx: Use dynamic tag numbers for phy start and stop
      https://git.kernel.org/mkp/scsi/c/4c567a9d0e00

-- 
Martin K. Petersen	Oracle Linux Engineering
