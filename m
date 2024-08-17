Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B644256E
	for <linux-scsi@vger.kernel.org>; Sat, 17 Aug 2024 01:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858159; cv=none; b=PCjk1R5UGeFH4nc/VoUo3+6bVbXL/6Y6zMkGBRPhBHEBayVkUP09jYrbLFPOLr657P4HinhsoZdsT5CwFwz2ys9YjIIrkXxILwAWskh/otCc7FNFxCvTLFsnh5Fht0eu5ptEjcwN6brVruKfbV+bVXvZ/yVPLopvojcsFTmEE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858159; c=relaxed/simple;
	bh=pE+iDZic6rUV6j3IRmr4g/kMuNWrPGMgCND5vGh1FLQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Wg+Dq/eGsCi4IiItJCk9HQ88rSlUrTs3nBht4Gn50RJKNcQ5+LlkfEjbK6K9bfy/amitqShxJOHauEGF0UFMd4gNRj9RH3AbZ5p4aSB4gU2+Y3VmOHJVf9PTTjkNdMJR6NtgGZfb+zlpqV1NQIf7UN1PTMjS5YhNFwXT+JtBjLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NiVHuRPi; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NiVHuRPi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47GLCCM1002888;
	Sat, 17 Aug 2024 01:29:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=gP66bEPZEXFWhUbhoik2neloX8uhaEV1FqUnbGDbcoQ=; b=
	NiVHuRPiHTHs76ljh06uSi1MjlF8nuby3GPU3zrP7yBse1Qm6DrxCKEQQ51BaSEw
	Ss7eCqHf0xGxL5/tI2Z979MuB4Z52xj2nLnUZO7mpnWUdyj/r775cCxyFLu1IMbA
	O+lyieU166IyAvgybdPQL2fM/FvkXPZCVHR+mZd4bcUqYFcXZw7L+lnwWTHWdioA
	bP7lHMl+PbffBgc4FPECFMc3b7ZKAf5hk36GSPVNSXbFyN7+ZUqw2YFGOdHqcyPt
	ZRhiYZfA8kMdbi0/k38fD4ldL2XApi/zyMx7Sp/HVPShp/JGiilNyG28LdHE9GnC
	HzXuRNMRxEDL/vz6CNhhtw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtws26-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H0ouYh020856;
	Sat, 17 Aug 2024 01:29:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxnkh7wd-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:29:15 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1TDac025300;
	Sat, 17 Aug 2024 01:29:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40wxnkh7vt-4;
	Sat, 17 Aug 2024 01:29:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Chris Bainbridge <chris.bainbridge@gmail.com>,
        Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        John Garry <john.g.garry@oracle.com>
Subject: Re: [PATCH] scsi: sd: Do not attempt to configure discard unless LBPME is set
Date: Fri, 16 Aug 2024 21:28:37 -0400
Message-ID: <172385808997.3430657.12777483385351158455.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240817005325.3319384-1-martin.petersen@oracle.com>
References: <yq1ikw1qg49.fsf@ca-mkp.ca.oracle.com> <20240817005325.3319384-1-martin.petersen@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxlogscore=746
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408170009
X-Proofpoint-ORIG-GUID: VW7j6qJ0OekH7RjQ_QURLH2rIq6vrZlx
X-Proofpoint-GUID: VW7j6qJ0OekH7RjQ_QURLH2rIq6vrZlx

On Fri, 16 Aug 2024 20:53:10 -0400, Martin K. Petersen wrote:

> Commit f874d7210d88 ("scsi: sd: Keep the discard mode stable")
> attempted to address an issue where one mode of discard operation got
> configured prior to the device completing full discovery.
> Unfortunately this change assumed discard was always enabled on the
> device.
> 
> Do not attempt to configure discard unless LBPME is enabled.
> 
> [...]

Applied to 6.11/scsi-fixes, thanks!

[1/1] scsi: sd: Do not attempt to configure discard unless LBPME is set
      https://git.kernel.org/mkp/scsi/c/cbaac68987b8

-- 
Martin K. Petersen	Oracle Linux Engineering
