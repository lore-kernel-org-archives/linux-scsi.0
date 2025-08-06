Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5701C4609
	for <linux-scsi@vger.kernel.org>; Wed,  6 Aug 2025 02:40:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754448006; cv=none; b=hWG5K7SOO/GYtjY0JQqIMyBnr7fkAWjvpmINYyapatkW1V9N2eJVNNojDiObGQia5wIGhq83iwIWV0CaObHRwf2deFsOxGtONZrzES+2cuGtwkUepREhuI7ocTqrmY0iIN0cTONTk+oMvZAAn65t7PqpwR+lxJ5mcw96X0ZBXUc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754448006; c=relaxed/simple;
	bh=Q8yujG33uJUgVtjlp8u9jjWA/p6IcGvGve7/mR/yPmQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T8jGXv21uMVWVwpNjP++uQ149rnVLcaB9B/qhd11TVYaD+EzdY2JGrA7x04cOP9ctvzknfa8XDk9k9n/X6qakHQmYTS24qYeorLiGlXpvextv+WfX/DHPe0G5L27q3bzmBsM22paSLh6IZOqRCNywYhG8I0y/YYptQ9vCsiaEUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FwxD+TyI; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FwxD+TyI"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5761ua5I017627;
	Wed, 6 Aug 2025 02:40:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=gqctjd2l6Q9PbZBbeCLicrQ5oNyknplccmiPK/xTqJw=; b=
	FwxD+TyIoHgt8Pe6SEUMyfs4U35dsNWs8Y5Vm9irT9FXih0mIHqJ0R3nO+TbGwUu
	p2L5kbYfUZ5Pg/RBubi8vQ/kU0ML0EebBrnBaJBjnRWeepOziA8AwSkSKysm61Vj
	gFqTCraBWGlSctJ3P6KPvSH83V5S4P8qSpHJL7OWyi3IWmpuxkgPF7SEcRU4K3nJ
	XJuSTKDAS5uKjK/gnE9EyV9Doc651Jc39e7bRO+scxLp6sUJFTh3KBcv6SQbKQwc
	haHIWPGiZUoDMf44jqpRGgEHJeCv3d3wfjanLJVxoxhrBgsMelh4UkLtyA8SrHXx
	igzbqsYSvCBbw3xUOiiOyw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48bpvf0ma0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:02 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 575NP8IA032024;
	Wed, 6 Aug 2025 02:40:01 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 48bpwpx5y2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 06 Aug 2025 02:40:01 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5762e0Q1004349;
	Wed, 6 Aug 2025 02:40:01 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 48bpwpx5w1-3;
	Wed, 06 Aug 2025 02:40:01 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, John Garry <john.g.garry@oracle.com>,
        Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v4 0/5] libsas cleanups
Date: Tue,  5 Aug 2025 22:39:50 -0400
Message-ID: <175444522417.711269.9137917773723926586.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250725015818.171252-1-dlemoal@kernel.org>
References: <20250725015818.171252-1-dlemoal@kernel.org>
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
 definitions=2025-08-05_05,2025-08-04_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 mlxscore=0 malwarescore=0 bulkscore=0 mlxlogscore=673
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2507300000 definitions=main-2508060017
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODA2MDAxNyBTYWx0ZWRfX5ltyeGdNmStT
 WgYPdH8ok+AzpRPk+YINF68tZiZ6QuItx4V5tOajGO/2UYkW0n8m5pQwKOt8kwUWx7AO2XEzZoq
 PfwFbvQqOpjn2/X+NxkPDNco610rn2mhYZZxrpufBlbf2n1/37lTxiOJmIlpnb75XcxifjVctAr
 MuOsHap5GOUpcLsL1UyLu9ekcHaHR0Rl28fuJHn74HaPL0ygkaWciLzC409ltcYFBbIy/5WhQLJ
 QwkiOuCHzn3tBXj6A4gG5pGQl8ZUlYlmwW/loPDep+fQvJI5REM0VRvyjqfhaWrwULsnvcHPgsE
 YeP6NIxSBdLWIjepunF9unm2h1aALk7GYpEOF9AQXme60rxg6OMXi5aalwmujL3IEnNcRRkN9CQ
 r1rH54w0lbOTxC4AYtYwe9z7rR+sUpliji/QdUWX7DzVxwYBvjfP3MJAA++EwMUmQ3PxgzLI
X-Authority-Analysis: v=2.4 cv=RtTFLDmK c=1 sm=1 tr=0 ts=6892c082 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=2OwXVqhp2XgA:10 a=VwQbUJbxAAAA:8 a=Hmj5j2q6NjVHxVe-fuYA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:13596
X-Proofpoint-ORIG-GUID: douq5G7Z6E0EiSWi4JhS9qrHkuVKYroK
X-Proofpoint-GUID: douq5G7Z6E0EiSWi4JhS9qrHkuVKYroK

On Fri, 25 Jul 2025 10:58:13 +0900, Damien Le Moal wrote:

> Martin, John,
> 
> While debugging an issue with the pm8001 driver, I generated these
> cleanup patches. No functional changes overall.
> 
> These patches are against the 6.17/scsi-staging branch of the scsi tree.
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/5] scsi: libsas: Refactor dev_is_sata()
      https://git.kernel.org/mkp/scsi/c/54091eee08ac
[2/5] scsi: libsas: Simplify sas_ata_wait_eh()
      https://git.kernel.org/mkp/scsi/c/0dd03570512a
[3/5] scsi: libsas: Make sas_get_ata_info() static
      https://git.kernel.org/mkp/scsi/c/bd31394aabf3
[4/5] scsi: libsas: Move declarations of internal functions to sas_internal.h
      https://git.kernel.org/mkp/scsi/c/704ed03abf6b
[5/5] scsi: libsas: Use a bool for sas_deform_port() second argument
      https://git.kernel.org/mkp/scsi/c/75fe230b9bed

-- 
Martin K. Petersen	Oracle Linux Engineering
