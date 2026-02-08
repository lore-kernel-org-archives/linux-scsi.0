Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7B862FFDE6
	for <linux-scsi@vger.kernel.org>; Sun,  8 Feb 2026 02:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770516143; cv=none; b=jNVHUpuB03ouYTNFvlTBkxL2eh+aceI7my/Q1emMDOyzaYzgXKdC4J++6gXtA9uF5LPQoFDhqG8BJNWSW+kWMhP+RgvOI9V1upsTDr9ayWEtgzCZcHIFeUjdKnF/PtZCd1z12R3r5BrdNOPkPA9XYlP60QGuK2mdOVYNYS5OGig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770516143; c=relaxed/simple;
	bh=kpD7qWmHOW8IcR/q8vuPYzAtNGDo1xuhBxlmFHgSJ3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dYUYvavNSWed51WnQZIISrryH5/0Dwxi+PgCjEPcb07BMFnzhmZhw1Ktkj1lvDiXXlIZZ8+7lORv3gYHK3yCdCUDvpTZWXJAg1DGRvJbSbSUjUnCiXNJb4nYLhQhzRJ7j4qU6pL+wQqXFz63FY62+4yJmy9tbo7bVLEEtloYzoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Zfj+GFtG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Zfj+GFtG"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 6181iJAD2332077;
	Sun, 8 Feb 2026 02:01:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=/yrRh+oWHu0Vy+Duptm2cwd7fD5R7qEOUmtBo/SFU+o=; b=
	Zfj+GFtGfxG0keADBCTj+R7CHwhhjjH/DdhghvjCPC5UX0iF/iT0Gd+K/68tlK1c
	57ZkqbQm8A4gDwEm1NSDHQLjww7HZSBLnWuc2ksjeDKTVxmig3wguDnVLJaujAhT
	maU96DkB2iNU9Mskz9ud+HDQQtaa6MdqGFvniPU41x0wH1SqHrp9EIhWsm1kn1Oa
	8MhUTQCtXkxDMjB5l2oEvxhBgLCMYVyuVIUfi7J1ktVY8mHx2UHbT88mQulp8NBV
	bngxXgqHAHbTEw+Jo4V5hTJ3fiRgp1Pga5zIlYP3jNAqHXrDVvZ16/JRq1UGBCPC
	Q7twG6zeTwABz8LwOGQmHw==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c5xh8rhma-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:59 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 6181pw70006636;
	Sun, 8 Feb 2026 02:01:57 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c5uubuk54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sun, 08 Feb 2026 02:01:57 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 61821sxR016745;
	Sun, 8 Feb 2026 02:01:57 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c5uubuk3y-4;
	Sun, 08 Feb 2026 02:01:57 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <mani@kernel.org>,
        Alok Tiwari <alok.a.tiwari@oracle.com>,
        Chenyuan Yang <chenyuan0y@gmail.com>,
        vamshi gajjela <vamshigajjela@google.com>,
        "ping.gao" <ping.gao@samsung.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <quic_cang@quicinc.com>,
        "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: Re: [PATCH] ufs: core: Use a host-wide tagset in SDB mode
Date: Sat,  7 Feb 2026 21:01:45 -0500
Message-ID: <177051564407.3805738.2315018742724616325.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260116180800.3085233-1-bvanassche@acm.org>
References: <20260116180800.3085233-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-08_01,2026-02-05_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 mlxlogscore=999 suspectscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602080015
X-Authority-Analysis: v=2.4 cv=YbOwJgRf c=1 sm=1 tr=0 ts=6987ee97 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=Mpw57Om8IfrbqaoTuvik:22 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8
 a=4aFy0jfRyBtO1vcAPgsA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12103
X-Proofpoint-ORIG-GUID: B1KYg0_fdSWnwg6Ih-lAOVJDnrHaS-jR
X-Proofpoint-GUID: B1KYg0_fdSWnwg6Ih-lAOVJDnrHaS-jR
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA4MDAxNSBTYWx0ZWRfX1YCUSZK0SZcb
 u4f1LgnPvy4Py40h5PhC6IHpZCkTKnv+ghgsd2jJ+F46DdGTsOTBpHykjbjl1VS3Tr0kO9idcG3
 NiWBplYmLj1t8hIM6fTSHgmTUAFgf3HRJB3FdZz7INhfYTZx9xjXd34C8xVAyhdX+947h2sXI3N
 HsIxkyBi77TmdSJ284X3BM3St0/41s3/zpDHULzEjJ9izBFqBmpkMKltJwKBZakf+10tihc+jH5
 WAsBkR4tScUSyLE2jHJEVdPoqN4+cyxAzapD+7qf+RyZykZ/resHC0rSM3UTfPwbRtIykzRJ9p0
 c21XEdT/1y8lfSUclWwvh+KXbno16LndCXXxLNQ5VRAtHTXDnYQCq5mKyM85oq5U+ZL0SAgVRVd
 JG4sfMinIBgmkcYWEozy0KHomIxbehCjDHjeiT0qCaqED7N22OLjc3oaTvHh5al5wBbNtHtSVEY
 hsZytDpEg5ZJetdrvKl3FyRUX1hFHHKF7zC1tKZk=

On Fri, 16 Jan 2026 10:07:51 -0800, Bart Van Assche wrote:

> In single-doorbell (SDB) mode there is only a single request queue. Hence,
> it doesn't matter whether or not the SCSI host tagset is configured as
> host-wide. Configure the host tagset as host-wide in SDB mode because
> this enables a simplification of the hot path.
> 
> 

Applied to 6.20/scsi-queue, thanks!

[1/1] ufs: core: Use a host-wide tagset in SDB mode
      https://git.kernel.org/mkp/scsi/c/4d0538dd5d7e

-- 
Martin K. Petersen
