Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 653081BC44
	for <linux-scsi@vger.kernel.org>; Tue, 21 May 2024 02:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716259272; cv=none; b=f6j+UBtpjik6jP03F7h8PdII4be4UG39IySa6LClGywOzUCnY546esce8W/Z+EQ8NU0EUxBdGcOvkeqyjB2XTsI4Wyf9vQrFDtmKguIp2UpErXe+c656rig9cQgxTsxCLn0aruVOzFepBrEFLlPmthwSu+cYuXUxyTSMJPIz754=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716259272; c=relaxed/simple;
	bh=P9f17l4ELNU0fSi3k8dZVgWkU+45uxlI+TNflbqcu20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IxppjexErMnNbs0iGoyTv1OEOq3gUEH/LtCeJnMbMcx4hWi6Ah0y4LoXBhl0BhIsVN03AXDy3f8AFM+UVY1aqsYsOTxMsNOAWZNDjHLllFpHUtfkd2C5lJ7WHsG0FgsczrCC1ivoTK7E3GVcp6AUU5i8ZmHrZccS4YNtExg7FFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=h28RPd2q; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="h28RPd2q"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44KNNnmO007591;
	Tue, 21 May 2024 02:41:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=OsHL4EQr3Pz38QrW02bQKSNNRd5XY5Dexk7+9+bVyXE=;
 b=h28RPd2qzvlmTPJ0oaB740ElXckDH7AngYmKtgC+IfiXEr0Dv1b1iOLb/bfayE42vY++
 g4I+KlQxNy7cj3l3pOY7jd8GGucJLdgCuiNlgD1TdgXKqps0vkjlMa0eFYvl8bl4G9VN
 MobN4rlMNuoFScjFcNN1wRFxAs5Jx8D943QIbzc18txgJe0LPvSUFDvY/Sc66fM9lk+1
 +uV1NUP29tnT/1Syxtl39qEM0pfRMKByIRUjUqLRk8/qx7Zhjl20ACuJMsrafNMocAny
 vP6WWF+RKr7hK4J9NBmclD9zS1Wfk2B4l5zNfjmcvIpXtYf/LvNomNBQbxVyEFkiy2Ca 1Q== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y6jx2by7d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:02 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44L2Fs5v002742;
	Tue, 21 May 2024 02:41:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y6js72bgk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 May 2024 02:41:00 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 44L2exco013516;
	Tue, 21 May 2024 02:41:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3y6js72bfn-3;
	Tue, 21 May 2024 02:41:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Tomas Henzl <thenzl@redhat.com>, Nathan Chancellor <nathan@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        patches@lists.linux.dev
Subject: Re: [PATCH] scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()
Date: Mon, 20 May 2024 22:40:16 -0400
Message-ID: <171625915905.2717551.4005718868423470103.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org>
References: <20240514-mpi3mr-fix-wformat-v1-1-f1ad49217e5e@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.12.28.16
 definitions=2024-05-21_01,2024-05-17_03,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 bulkscore=0
 suspectscore=0 spamscore=0 mlxscore=0 adultscore=0 mlxlogscore=807
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2405210020
X-Proofpoint-GUID: YPqcq0ZY9Blm8Ibdg0tDwVrSViMdKeig
X-Proofpoint-ORIG-GUID: YPqcq0ZY9Blm8Ibdg0tDwVrSViMdKeig

On Tue, 14 May 2024 13:47:23 -0700, Nathan Chancellor wrote:

> When building for a 32-bit platform such as ARM or i386, for which
> size_t is unsigned int, there is a warning due to using an unsigned long
> format specifier:
> 
>   drivers/scsi/mpi3mr/mpi3mr_transport.c:1370:11: error: format specifies type 'unsigned long' but the argument has type 'unsigned int' [-Werror,-Wformat]
>    1369 |                         ioc_warn(mrioc, "skipping port %u, max allowed value is %lu\n",
>         |                                                                                 ~~~
>         |                                                                                 %u
>    1370 |                             i, sizeof(mr_sas_port->phy_mask) * 8);
>         |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> [...]

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: mpi3mr: Use proper format specifier in mpi3mr_sas_port_add()
      https://git.kernel.org/mkp/scsi/c/9f365cb8bbd0

-- 
Martin K. Petersen	Oracle Linux Engineering
