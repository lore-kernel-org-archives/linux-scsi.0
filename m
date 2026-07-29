Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CB2B38B124
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 02:55:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293720; cv=none; b=eZRVnfBqJc+AZbQP0D7msc9wsODdg9DOjAdSV+WVu7FBSvDjLNKacwP3y3XiLdgMt9OtbgPVJPfdAW3I2fTp1LZLc2rzRcnFFMzWIU+9GLSQXk83gfa050WMW4bWss5a+5aJL7vPgltQUx6j6iU5apjiP4a6jEzVtCRrtFyRMUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293720; c=relaxed/simple;
	bh=UGhetnqf1C/qF71uAyN7DjW3eWfWMsIQkOIN2L/Exz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=XhmziRP7iAxQwXlKAx7tDKlf5lPh/nZcbRUhe5p99dQ4m2QI1iykzRmzugr+xplNvB8XH0t8Fx4VJ6ZVxrn5Xj2rj/YcgFPOj2L0MGo511I1SGi9ca9KvYgNKAguUjmtJMV0yK3HQTDWiCPfQlGscThl30bB6MO47PkQXfqjfh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=mc+mFURP; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="mc+mFURP"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItaes1279495;
	Wed, 29 Jul 2026 02:55:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=sGjJaykQs5ZIq5+iNHpKyVZxW02c0wuEf3keOP3wJ+E=; b=
	mc+mFURPjHuFP/hMPtNVejPNgLEQWHa3WyEHzHyHr3l2XpMk1lfH7jPafCDy3NJp
	g3rmrfbgGqh8ZIfglYTx1r1SScoWtI/dL4xIK7LYG1KaeEVzyo1QeCxXvl9kXdrf
	Vv8mHJLbvSuMdpE/atUPcp+6LHDC9ZLjJjweYA+VDtErBAJxR3bCn27eWrTjvwJy
	86oKQSxIswk7AISC9WAeJ8GjP6uCkcq3RPFqfieqct1Wswg9Lb/OAbW5yV7g23U3
	FkzHzEXIZRJv7GVFqVD96RUGCpZ7t/wctS5hVosnVWEf0bUTH7N4ziXedyAnCrLC
	EuUeYc/9Yo188K8tb6BFGw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pn6ne-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:10 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2o8AZ001726;
	Wed, 29 Jul 2026 02:55:09 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh87p0k3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:55:09 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2t8jN012133;
	Wed, 29 Jul 2026 02:55:09 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4fnh87p0jb-2;
	Wed, 29 Jul 2026 02:55:09 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: krzk@kernel.org, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, mani@kernel.org,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v10 0/2] scsi: ufs: Add support for static TX Equalization settings
Date: Tue, 28 Jul 2026 22:54:56 -0400
Message-ID: <178508193499.4027291.2183692726917618275.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
References: <20260616113348.1168248-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0
 lowpriorityscore=0 mlxscore=0 suspectscore=0 adultscore=0 mlxlogscore=919
 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-GUID: 650r1Nig9DNFeBOTT8alH52_Ec5Rydn-
X-Proofpoint-ORIG-GUID: 650r1Nig9DNFeBOTT8alH52_Ec5Rydn-
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a696b8e cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=yzc9LB0guGCcMNGqdekA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX5pBZkqHKN07W
 D6XaixjPJPsbCeJd18/d82GBuDdZjc+0gQg97dFAFp3sr9CwAARZLZYZu7qgLd2Nik232hTOh9q
 +OEM+PKYHlvfkQtqEFHTx4eQDDbimq82TZjlp/FgGDEsyVFxQhbxY9+sizuLDM+v8FkPf5ncgYN
 xvpoukgcsuRTwQit944VXHEUWW4Lrsdw7L/ltM1JunyRG7YwnXsU7HCsKLPGxDEVknCbeVcZH+h
 EVvQN6zsMquV40NcP6Ts+CR8MLqSucy33RDMC90vR5wu5v11O6vEeUoRljJyPatCVIrUVx97Qrn
 lQMq9tuY6VqE1ew5C1IMempGTqqmlcSYgdawAIBsChHiKwBMn2NGKPvvt5PjazqaUG4dCBB1Sdv
 FEFXdFGcSZqbiVodR+fi7KvJeLkFpKUk8NpnvVVI78TjPGvDKNZX/QCj54nEK6Hrjel2614Scz9
 1pdudliDqzvqemiZOfQ==
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfXzxR6GGiuZIFY
 X7LVuQt0vV99W5hodwewapJnd7B+iVVDqrSu2LTlp9KJc7wKVYT3SEbW1j9vcC6qGzwMavw65bL
 eXDtEMWqtEtOTmwRXyCp/Xci7PzYIOZQHVStTcneIjkQUnpV7lh/

On Tue, 16 Jun 2026 04:33:46 -0700, Can Guo wrote:

> This series adds support for board-specific static TX Equalization settings
> provided through Device Tree.
> 
> This series is based on the earlier TX Equalization enablement work and
> persistent storage/retrieval of optimal TX Equalization settings work:
> https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
> https://lore.kernel.org/all/20260424151420.111675-1-can.guo@oss.qualcomm.com
> 
> [...]

Applied to 7.3/scsi-queue, thanks!

[1/2] dt-bindings: ufs: Document static TX Equalization settings properties
      https://git.kernel.org/mkp/scsi/c/ce36dbeb2951
[2/2] scsi: ufs: core: Add support for static TX Equalization settings
      https://git.kernel.org/mkp/scsi/c/ecb8d6da1356

-- 
Martin K. Petersen
