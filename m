Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C895E1C698
	for <linux-scsi@vger.kernel.org>; Sat, 11 May 2024 18:56:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715453768; cv=none; b=soYZK1J5EoAoOU1nSbsGoONMP2Lat4WXcAsFbGCt1GcNYaiagPaX01sOnhT1oup4d53ixk6f3MvdXQOg5bHvQ6fjRnMn65ZqdfL5H0YnJPWfyiXQ0MHU+WvHpvH+LFTMMqfXB8osZqyOk2NN0JpHm0xgeTRRSKjLzu9Iu3hVDRA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715453768; c=relaxed/simple;
	bh=Peg/soV8og3Nxlkz8ODPO5BlC4MejOnAeWNub/KjPWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pICmHpzp/92vAVaXq9HGkBXtdC4KxtnyaLwSctolKUyD9buXayVElroIkCwF+hcKPepNmYeLdv9MeaZDgg5muqJydmD71Ss/B7RG8bfTrYYjUj4IiyJl8IFkqpt9+HPz3goIX5DbNlRmCId/BOj83hFYAoam9arKhppbGnEZmO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M/Wp5WZK; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M/Wp5WZK"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44BIFSDa002274;
	Sat, 11 May 2024 18:56:06 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=RKgZrjHWZpyHohc24l3jvjz6/Qftssu+aEksoo/4EPE=;
 b=M/Wp5WZKxyNePsYxtS58MrMNU7iljEuMaYml4o+IejV5JThdnHRTsuA61kagbHlteYh+
 wjNw3eQYAd4PMl7xLlZKPOH5X4yuDJ/XDTzQqnwboeme7U7X47bScAkVjBrwJlu+5gFx
 tZSu3kWlQjrTbzRDkF15hAMSx0+5c1nlzmIlckxGnstJ2z6qG7QXW45xH6Du3OStbadK
 jYClW02wgBBpxHpSesPf67efKy4AK7jOIg8XAr39rKn8lmENZo4K55NXPxtV2LeBeFW0
 SXu7oCXPqynn+ymJY1MHLJ033Kcc201ULvqEi2kwsTpaS1AQMLZH5ohtVZil0QiUvF58 1A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y2d1801aj-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:56:05 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44BGC0Le022322;
	Sat, 11 May 2024 18:39:51 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y44fn61-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 11 May 2024 18:39:51 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44BIZYPO028255;
	Sat, 11 May 2024 18:39:51 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3y1y44fn5r-1;
	Sat, 11 May 2024 18:39:51 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: GR-QLogic-Storage-Upstream@marvell.com, linux-scsi@vger.kernel.org,
        himanshu.madhani@oracle.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] qla2xxx: Fix debugfs output for fw_resource_count
Date: Sat, 11 May 2024 14:39:07 -0400
Message-ID: <171545260077.2119337.17295009406216491654.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240426020056.3639406-1-himanshu.madhani@oracle.com>
References: <20240426020056.3639406-1-himanshu.madhani@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-11_06,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=916 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405110139
X-Proofpoint-GUID: hVKHHcdzzmNqSCixPsLrJWVDcF6qloRy
X-Proofpoint-ORIG-GUID: hVKHHcdzzmNqSCixPsLrJWVDcF6qloRy

On Fri, 26 Apr 2024 02:00:56 +0000, himanshu.madhani@oracle.com wrote:

> DebugFS output for fw_resource_count shows:
> 
> estimate exchange used[0] high water limit [1945] n        estimate iocb2 used [0] high water limit [5141]
>         estimate exchange2 used[0] high water limit [1945]
> 
> Which shows incorrect display due to missing newline in seq_print().
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] qla2xxx: Fix debugfs output for fw_resource_count
      https://git.kernel.org/mkp/scsi/c/998d09c5ef61

-- 
Martin K. Petersen	Oracle Linux Engineering
