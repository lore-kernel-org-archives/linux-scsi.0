Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DA861A9F9D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Aug 2025 03:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755229111; cv=none; b=TwK3+N6b+bLBuINZZxUjcShkFvahDGO09yoJXYX6AC4Zq+tgjofL4qtLStKbMUbl3chcbB3UkgOlVkdtpsRcLiRESBw7uG5vBI0xALwAum4H6twHX36g3TeFwTAcgl9fn6dh1kNLE1asolcjwByiNQRI1rN5HlspKUxCvOczbGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755229111; c=relaxed/simple;
	bh=9BzAT0esG0QLzZuxbGuJuhKtcMcYM0+lXw865J+EO/E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=KzxRgi34Ye2duwhIr3GI1qPWBC35gYPKr1O+cjme+/fAp76ZPCMOGcak0v3k8dzcsl6e2PFNJ2N8CwM1BLJ2Z5BkvqV0YqQdw1A4DzGZ1HzccN7wNYCtErLCKorjqJf/tb4O2uXp8cI4nSig6sm25og9mZLctJkQusrakAS2SfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Mj25Cvjx; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Mj25Cvjx"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57EHfqq4025409;
	Fri, 15 Aug 2025 03:38:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=tMP7IJw7Gds6gXBUbBvz9TX5Su/RiYVBiRtlcVYw1aA=; b=
	Mj25CvjxQz6tI5ibCZ8mgoAYq5sYCZKg3tInniBAo77S9DZB0t0hWR0MaKwLm1Jh
	/6bYid6Wg8afZoSOCNdIIpdHKn8sbRVdjbzdIOPaZsgmOPjcTwZlZ+Pfh3IGCBWO
	YuDgcn8/np2VoHWEIdMLuczdkOIWvNoc+4uZzcuk26Gwb1IXZxgYIzXxmooZ9Jw0
	+2a8/fcsOwgIbkxK616niaJ4rawkHphsdQnknao0TOhGt0N5Duwv3F3BtcaNspZK
	TJO3M5LnB6J8c1DpKzZO0Iwm3s3Y+P9frhQf2sn18SLepVNJwTYYqt7EG0a0diFz
	jpEu+rV3Mq8HhtQzzinsGg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48dxvx37jx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:23 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57F2a6do006485;
	Fri, 15 Aug 2025 03:38:22 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48dvsdcuwp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 15 Aug 2025 03:38:22 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 57F3cMAg015669;
	Fri, 15 Aug 2025 03:38:22 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48dvsdcuwe-1;
	Fri, 15 Aug 2025 03:38:22 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Adrian Hunter <adrian.hunter@intel.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        James EJ Bottomley <James.Bottomley@HansenPartnership.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@sandisk.com>,
        Archana Patni <archana.patni@intel.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Wildcat Lake
Date: Thu, 14 Aug 2025 23:38:15 -0400
Message-ID: <175522907871.1556995.13983777419610442620.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812130259.109645-1-adrian.hunter@intel.com>
References: <20250812130259.109645-1-adrian.hunter@intel.com>
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
 definitions=2025-08-15_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 adultscore=0 malwarescore=0
 spamscore=0 bulkscore=0 suspectscore=0 mlxlogscore=855 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508150027
X-Proofpoint-GUID: RMAx2bujEijTqv7CjRj2H_ROHUZBZdFS
X-Proofpoint-ORIG-GUID: RMAx2bujEijTqv7CjRj2H_ROHUZBZdFS
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE1MDAyNyBTYWx0ZWRfX6MKBTTIC0StR
 Y0vhH9uZz3U2yeuAMUyJmWob3OHFkzQcMJr1R5WRWS8mPiNrmdKx781e09jJ+UT1UmeqXdxRaA0
 djmOpJrxH3LJS+5+8FaPz/gwfeiPNgO3lPzSAh427IMBxjtzXSt85biewmfSRiSsQKh/rSK4Ff/
 ELLSibMzcD4nq9lN8iCXpbnSnowI9IYPp60T2pmj7c1j7PhGA70MacW+tmpGQ09CWJ2ODPmanCI
 E7kykpFWOKa1cgBfod0rPost1zoSnEIVxaBysxsPiV1nIUblKfdiGs4p2++J7dNbqvFLbdDum3d
 ajGFmk1Jvh8LOFBJjNPZBohj4GMTxi1476EstTZtNWUq1IlXkUxupeOeJvXErhKqT+QyN/YdJhI
 EMRO3grbBY4A6MbbkVzgE0at9W9x+HepiwhwKiGFDV7N7jY0q5YBamdnr5H/2T/pqXLjd3MK
X-Authority-Analysis: v=2.4 cv=dpnbC0g4 c=1 sm=1 tr=0 ts=689eabb0 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=e-k3FzOx2DXlLekUffoA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13600

On Tue, 12 Aug 2025 16:02:59 +0300, Adrian Hunter wrote:

> Add PCI ID to support Intel Wildcat Lake, same as MTL.
> 
> 

Applied to 6.17/scsi-fixes, thanks!

[1/1] scsi: ufs: ufs-pci: Add support for Intel Wildcat Lake
      https://git.kernel.org/mkp/scsi/c/823f95575d85

-- 
Martin K. Petersen
