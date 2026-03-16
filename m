Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A70124BD03;
	Mon, 16 Mar 2026 01:41:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773625301; cv=none; b=Oa+xLmfTPU+SOJKuOnVPhvV+Hz3A9KZFFDYE0s4QXUuvRiVn/CAi/3CdsvezsrmedEvK/BVSEguIqGXl1kr/GFIjPrG8c2hNsn0W1kpqyDMSgXsZVXT6LxCgyjj+MBv9WG1yrWiQi1G40gTDrjKD3raO9Bzz0ud0h3Ql8t7/kI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773625301; c=relaxed/simple;
	bh=Unw4erVM+tPZa7TUFzDYcqwp4LpOh8o686+iKYfVgIU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UQvJIkyJbugEsr6zONHQNH6jV5ZxziUVz1IKmHy0abwou+/ClP9RrENnS7gqGFnyCx1fTrsLAfRNxSa+GxCfFXu53GNMta8MOVN+SLThZuwoDdHUiyLUus6Ppb715P9x1AAeeF+AAM9piunt6VKJI7Z5g6bphld6Y1p0awBbKTk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MTlr35wc; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MTlr35wc"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 62G0fgFG882018;
	Mon, 16 Mar 2026 01:41:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=lcWcxShTPknG1oI5790aMMV3eNCXGL6L5BA0sub9Tm0=; b=
	MTlr35wctbpqPRxSzhloeWI3GODGNUmbwCfdwzbFMhKYoCjaEQ4KXGbzkHKhY8Fe
	6H/bWxbIqwfbBi3yWH7U5/xIpvAjOa1BHFUgC3kjtJ6q1W34VzIW8DwcmPyzR6uY
	CMC7z66ePu50MHw1ln+B3DXFqBjUAQkg2jwSI5pRfOrQYRTh/khgxEAIq+6+5XPv
	3DGR+vZ6YVaojnCBvsckwhyppd3QJIi7QOXBWurMwqRepdISu5lVwYBMAFeIJDwN
	1fWnQKQr96WqKm143zEjaZSru03JN2fbX6a8dd8pSNaDTVYLwQUapzzW/L1s9n0K
	k8uxZjisjn+K9uIk98tzGA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cvyj61ax3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 62FJfYXX002901;
	Mon, 16 Mar 2026 01:41:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4cvx4j86mt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 01:41:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 62G1fXhL032070;
	Mon, 16 Mar 2026 01:41:33 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4cvx4j86mp-1;
	Mon, 16 Mar 2026 01:41:33 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
Date: Sun, 15 Mar 2026 21:41:20 -0400
Message-ID: <177362524495.2599440.9496137085591406119.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260309085815.55216-1-adrian.hunter@intel.com>
References: <20260309085815.55216-1-adrian.hunter@intel.com>
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
 adultscore=0 malwarescore=0 mlxlogscore=999 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2603050001
 definitions=main-2603160011
X-Authority-Analysis: v=2.4 cv=LKFrgZW9 c=1 sm=1 tr=0 ts=69b75fcf b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Yq5XynenixoA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=tVEc8CV4L3vnh73jD9kA:9 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12271
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMzE2MDAxMSBTYWx0ZWRfXzXa4UoNt4mja
 MEjM7zXxbviU1aiccyvBl2fOh3DHknpczhwA6B4fbtZmR8QW02YU+qvvt/WoDBSokQc0rKJIUKv
 KpyA8B4VguVdVAoJa7fie4egGol5Clj+BJJ7yKxH5t4SFw4Uho2FhnTXBMtg0WMZhihZ5NP0qSZ
 eREn70S/KA56/mX8oHE1dXgWFxEirTva2lYZM3zmmGPLoKzuxERXZdMiCY0rNxXxTKSpE7norVf
 7vOuUMnk5vkh+pKmIiSAQI6LIs2oB/EUZVu9hxJAuJVsi77H1bFEk7xlfMurNHbgDH2tCqB8afh
 i5s5K6k68XG66AiZ5uk9H+NztPTpszN1Lh91mR8G6pk6FT0OkDXVi+/q9dEIDnNpdmxyfn8UdNJ
 Fp3iOIq4wGqzlbksm183QGeZkTCd/HvGdrFFvAL7JU2gkTPJ9fCgno/VfE/jOWBggTOzknssWkR
 Hb+EUYpXljo1L1MQTrG+ceq//3/dqycxFsqPWRs8=
X-Proofpoint-GUID: iwTXY5Qrx56a-j7mcSq8QDXJTeQMBFVH
X-Proofpoint-ORIG-GUID: iwTXY5Qrx56a-j7mcSq8QDXJTeQMBFVH

On Mon, 09 Mar 2026 10:58:15 +0200, Adrian Hunter wrote:

> Add PCI ID to support Intel Nova Lake, same as Intel Meteor Lake (MTL).
> 
> 

Applied to 7.1/scsi-queue, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel Nova Lake
      https://git.kernel.org/mkp/scsi/c/096cd6b7adf2

-- 
Martin K. Petersen
