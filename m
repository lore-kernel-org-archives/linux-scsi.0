Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 794C92472B6
	for <linux-scsi@vger.kernel.org>; Mon, 16 Mar 2026 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625301; cv=none; b=J3OTGBW4HMt7zxYH80sT9QWXrsvk8AdbQ66HsXVJ26dMKrArz3jg+ENVLZaAuOJ0ZSb/xnnS987Cy/n66Y+uheyes4hjf4nl91o1X5eGEvPChgtOm30Vj4vpWgSa4bBUHLX8p7mXLdAlVIZocWEiAwNFugLpNnL83eBAX32XR90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625301; c=relaxed/simple;
	bh=Qwsa7f0y4kjfV8wfPLY4D8p5St5UYcJZoiwIjTZSRjc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=e300zdFUGfunun61yic0nYyhmjwapnEcLZ61/2bwNNEFyqte+2RWK3et1tnRQzstBmCfMzZIfxIiJOP0mTtEB+UmRtiaPdyYAJBWKn6w5fSaoplJsT8RenFRQnat5MSwSmQgOY0msG3pWuMYwhICW8EhPREl9u75qco50FV4NUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cr19lDD0; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cr19lDD0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62FMi7Mr691391;
	Mon, 16 Mar 2026 01:41:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=ElaoSGl1p7DR/vF8ne1hNA6KozgWWDc/t1BPRAV6TUw=; b=
	cr19lDD0C2tGOTl7BUJDR5KlvQrNDlV8ZFOcE3hDxMB1vGOUEx7gEQ9WYlYTYxl3
	9Y1xybu3Cq0VG6U/2aUDprtt1zgM1NHdeVRL86P+tos6jYEl8Bf6mIyB5cwCi9LH
	2aJ5woS4FT0+n5sU8uyrY2qIdpnmdduUzrjGnnAYSN/BUlC/Ais+oREXhmVq8lEw
	bqRatyxwrBv9C8xZ0ilP+9uZPrMxH6w6KDgeKG5TM3dGaymgiP4X9tM2L9ZCUyEO
	y9vMNemCwj5cgCrszlv/Q6Meluqm3bH8xFsgoRIhlDzuL7Xv2ln31rjCiE/V610q
	74moNA6yrCbl0cDuIyaf0Q==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj61ax4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:37 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FKU9df002695;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86ng-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhX032070;
	Mon, 16 Mar 2026 01:41:35 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-7;
	Mon, 16 Mar 2026 01:41:35 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
Subject: Re: [PATCH] qla2xxx: Add support to report MPI FW state
Date: Sun, 15 Mar 2026 21:41:26 -0400
Message-ID: <177362524488.2599440.14732927732533151036.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260305093337.2007205-1-njavali@marvell.com>
References: <20260305093337.2007205-1-njavali@marvell.com>
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
 definitions=2026-03-16_01,2026-03-13_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 spamscore=0
 adultscore=0 malwarescore=0 mlxlogscore=699 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69b75fd1 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=DIStr98s0tHtVxHZW8kA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfX8bR+4VvzWk2w
 LyrKjGhCVwX+FD5A09KUmhWDGWaCb15J1hiLiWnAm+fIRyQJESYlKdo8tDvlb+vMQs4w0Z1xajo
 JOA/ZYQRXWIJBdM2zW+CRYYC6ARVzndCX7gfRZ4KNEEZqELbHBDkyJFRly+8Dr6J9UWDbCTnOFr
 PjtfU0vNfF2Ce3i97Wyx4XpyGc9A0SiQ0bR371iOisXCvfAjCahgETt7ayFeWOba55PuOsBgTWK
 y9vUp5mHnmFqjwa72uG8Cwu3/w/OLmic9xqvXE6C5iB7AZ2CLa/uGfKz0m/99ndTNFgfW6Wkrsi
 0ywHmICBFxvL1XfmRYx1KxD7u2JBr9sKyPrnAS20RuogsYb+94eGsw2dUMnMxdkR0BFlc1Zsjfw
 BEmvYcAT/PFX6kjmF4Xo0K46NLcR8gwdR4gzK8cIAKLdhZcLzFMjZcT9oL1BNAQBxIlAEG8Lbs1
 lsZW7fAiOJeaRBekCW+VIwI2BSM4CS2T3v7ukJYY=
X-Proofpoint-GUID: QsYQQ77nZLvwLqRRXA0AnPT2bKxK1Tge
X-Proofpoint-ORIG-GUID: QsYQQ77nZLvwLqRRXA0AnPT2bKxK1Tge

On Thu, 05 Mar 2026 15:03:37 +0530, Nilesh Javali wrote:

> MPI firmware state was returned as 0.
> Get MPI FW state to proceed with flash
> image validation.
> 
> A new sysfs node 'mpi_fw_state' is added to report MPI
> firmware state:
>     /sys/class/scsi_host/hostXX/mpi_fw_state
> 
> [...]

Applied to 7.1/scsi-queue, thanks!

[1/1] qla2xxx: Add support to report MPI FW state
      https://git.kernel.org/mkp/scsi/c/0e124af675eb

-- 
Martin K. Petersen
