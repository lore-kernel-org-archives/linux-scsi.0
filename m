Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75503334374;
	Sat, 23 May 2026 03:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506140; cv=none; b=YqAtDYoj0x2MHhKqOIuZJkAfjeQRKpKQKhMIvT/E0p4t4+DiT0ewk2kNwS4oThGMGK0b5+QrGbNJ23ojcy9lFmorYxoGwCUjjQ5+bw3qxY4GEYpoQy/WcP76hF1sG+5XkQijUCH5kVGN1n3B/bE6gIIwKDMf/8x70vRhgVcrcjc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506140; c=relaxed/simple;
	bh=e0ZJyqGGf4tturPztJYjTedtzszbcbFMNj1hE7+IuEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CQGTM/rYIGn2idROnLps/oD8WQovPjGizE4dDBjn0qRJcJUpUdRuWwKBQSDm9MR/zDIqkGH1Q/pfRAEk04XCWx2hmXWbfuA8VbOobC6h5qFiU4qkAOqfJmd2BNgKs0tUcLjXJCIrtpwr5OjP64Nq6aLrgXtuMdRdiRgSY0UiMx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FVSXw99D; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FVSXw99D"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64MNR269183313;
	Sat, 23 May 2026 03:15:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=WQGUZ9G9X/zjeVA0ZNH07vvPNIXyNgq/Qdw3JCMIk7c=; b=
	FVSXw99DM2Xqzff/VYX3i5/+sf26AwgViSoPoTP8bX16tVvmIWTAmOWgLl5q4FrC
	g152WXk1MlyHFFxxlMgh7mRODlOpZwgn9W5SVWuFy/lnghodlFj7jPxDHroaC7wO
	Hwj8kszspy6gxCRbLEd18WuTdEa4QysoBaM4zMRNi4XWDZsqq4BYOlOIxCZjydDB
	Sh0aaO2EEJfYFJ4eK+y5v2yhhmiRjln+2OPBpFLlfAjJPzXoq2p3YO4RSZrJWHW2
	8wUCSDuvbMQZ5l4ViTA2WLjPtS7BNX5ewkKMk3p5D9sJYt5x8oOgsgUixmrOGVfM
	VsgiETo5iuuyl0R3LuYK0w==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4e6h4qcct0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F6Wa032363;
	Sat, 23 May 2026 03:15:11 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hscg-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:11 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9du032824;
	Sat, 23 May 2026 03:15:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-2;
	Sat, 23 May 2026 03:15:10 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Matthew Wilcox <willy@infradead.org>, Hannes Reinecke <hare@suse.com>,
        Jens Axboe <axboe@kernel.dk>, Arnd Bergmann <arnd@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        John Garry <john.g.garry@oracle.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: advansys: drop ISA_DMA_API remnants
Date: Fri, 22 May 2026 23:14:16 -0400
Message-ID: <177913641744.1181900.4761236465722507016.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260429151623.3899875-1-arnd@kernel.org>
References: <20260429151623.3899875-1-arnd@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=414 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=NdnWEWD4 c=1 sm=1 tr=0 ts=6a111bc0 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=7Gl3-_t3PgB9XO-mQDs3:22 a=VwQbUJbxAAAA:8
 a=JK-S3ZpVlL6AxdlREH8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: DlVWWQTdma4QKBhE3QKTdgrwFRqVBu1o
X-Proofpoint-ORIG-GUID: DlVWWQTdma4QKBhE3QKTdgrwFRqVBu1o
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOSBTYWx0ZWRfX4NzBCGjSE7Br
 19tnIRpByaeS5gCJoTWmnjCXm1wyobq4RipAhlAxrBU2eH4YSlUs0gnR7kG6uEfx7BqvXyA/l6y
 /7a9rwJGrRDwTV4er5ifalpTP7qgYAXlskQvh5ZTTs/4BQ4y/RlMZqOMoyWpY2TeSa4VahorwLs
 VCfvh/D/uDayU9Z1uKwFeQorngACzR/bLxIsSreTus7E0TikRUqZBfMb7r19i9fjSoLf+efP+dP
 eocxT6bSDd1wR44Jm1Lwt/nint4dacbdNH15rH4p0LVNX3kBdxCNQSuV2RJLcvxiTprt/jFh9Kb
 4e17RXPWizS1fQfMfJBQ1IVMisnFK3prQPd9+HDqCYpq+yZ9hduqDX68y4cmF9CW5Wk1LUGQz5d
 e+pcKW0pflCwMA/+zs+xnNrD/k6HMVQHMtRg8SjV9khRB9SAvHKS3vAt5DBC8aDbTA1SURdXyl9
 +IJrJ1OiP6bQzljB5xA==

On Wed, 29 Apr 2026 17:15:37 +0200, Arnd Bergmann wrote:

> Support for ISA bus mastering was removed a few years ago, and the VLB
> mode does not use the ISA DMA API, so drop the dependency and the
> header inclusion.
> 
> 

Applied to 7.2/scsi-queue, thanks!

[1/1] scsi: advansys: drop ISA_DMA_API remnants
      https://git.kernel.org/mkp/scsi/c/c7233b3d99db

-- 
Martin K. Petersen
