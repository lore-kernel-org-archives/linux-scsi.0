Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A27536B08
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:31:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581878; cv=none; b=nQ/R4BpLAygaZnGg9AbkU3HBS7olDpz331nGYMyihximByWaDmWDE8u9HeWWxhMldZaFJ+ii3QPJP9zbDcDD1JuIPBDKbMhvvakk/+WDxe5zaW7UusVCv8By2LRYv7OcmluCU6P77Fx1t6q2ZRB+4KV9+0JZdS57TGGePVhz5PQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581878; c=relaxed/simple;
	bh=XPLAaKenDGUO1mPVz1THjY4VgmHRKZ7Wlzthj2tLCXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=b+aghedHP0pob5xjAVo2jBuTKetwHZIPrNqXXX+1RkfB5hh6XOORgEaVAHCgBcbEa6WgcCfT8pAc+22+nOGF/fB3i2a/KJIP7h5PFO/eSY606Zc0126uFPO4mfswp+F6ToqxEZXIbf91I8Ss6UEMApyl9sumavMXlD85MEHCM8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=WJSiRMYs; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="WJSiRMYs"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJi4EH021739;
	Tue, 30 Jan 2024 02:27:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=XfBHq4MXhNA7pEbXJB3hoxKtrzy5akOtljkx1TkN/bw=;
 b=WJSiRMYsy+97mGkqYT9mpIecZbcwNmO/YpABL7sIOEK7N5JCftZ0LS8KVrpmsSs2ecS1
 pGC7iPkZst8cFsZKkub3wQGwNR4C38SoXGvM9aFrCFy8H8DBFq8e1h+eUzbi+63kCype
 7RPoYsBj+esCzyIkEeBygdW47zcEaHySxwQzFBgkxtljTqN+gC8cWGP4zXeqyhgnxTFw
 QxoiywnHyif2jyc2YB9YdYD7TZne9c4FS4cGuZWNgB1E+ptBMDDRnnXAhLnNqErij1SF
 OURcfvE/XH4/lFbhuKYXlIKdpGAhoOBztEe5O50NMVs9hBggZE3dYPwvPRY1gejhK/pV bg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvre2dkds-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:27 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40U0EPo6014545;
	Tue, 30 Jan 2024 02:27:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96g4yv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:26 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40U2RPxg040916;
	Tue, 30 Jan 2024 02:27:26 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr96g4y7-2;
	Tue, 30 Jan 2024 02:27:26 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jejb@linux.ibm.com, chenxiang <chenxiang66@hisilicon.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com
Subject: Re: [PATCH 0/4] scsi: hisi_sas: Minor fixes and cleanups
Date: Mon, 29 Jan 2024 21:26:58 -0500
Message-ID: <170657812683.784857.3356216796166694084.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
References: <1705904747-62186-1-git-send-email-chenxiang66@hisilicon.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=917 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-GUID: IkXnqdSOBnq5igerhZhqNz_ujFtQQYEL
X-Proofpoint-ORIG-GUID: IkXnqdSOBnq5igerhZhqNz_ujFtQQYEL

On Mon, 22 Jan 2024 14:25:43 +0800, chenxiang wrote:

> This series contains some fixes and cleanups including:
> - Fix a deadlock issue related to automatic debugfs;
> - Remove redundant checks for automatic debugfs;
> - Check whether debugfs is enabled before removing or releasing it;
> - Remove hisi_hba->timer for v3 hw;
> 
> Xiang Chen (1):
>   scsi: hisi_sas: Remove hisi_hba->timer for v3 hw
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[1/4] scsi: hisi_sas: Fix a deadlock issue related to automatic dump
      https://git.kernel.org/mkp/scsi/c/3c4f53b2c341
[2/4] scsi: hisi_sas: Remove redundant checks for automatic debugfs dump
      https://git.kernel.org/mkp/scsi/c/3f0305504765
[3/4] scsi: hisi_sas: Check whether debugfs is enabled before removing or releasing it
      https://git.kernel.org/mkp/scsi/c/69097a631c03
[4/4] scsi: hisi_sas: Remove hisi_hba->timer for v3 hw
      https://git.kernel.org/mkp/scsi/c/f9242f166770

-- 
Martin K. Petersen	Oracle Linux Engineering
