Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C62F318637
	for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2024 02:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712887555; cv=none; b=KPAxps5ecscnwO7WGjiBGOZr1KIdHchei/xUJ0OLwltHOjV9i2kiylWfYhmyxE6qnMi389PkoFIpAZvrlKe4P3r25t+Zc5+lpUZrnXZfAEfJV/lOtXtOli9tIWByIKaG0pWkMmxENvLRrdWmP8cd9FdVrGHoJCo1M2KGAsXLd/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712887555; c=relaxed/simple;
	bh=vSBrNE28cD5pw6SKaLeWHCLkW66mqQtYJUbvwNCc+PU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=SR9kIFiIGBm2ZacodHNTgC3maffjKrNYxnGOZtEZ4hiHNl/0iIHi1ryFKr2bjq5HgX3g0pnL6JqmnJ0Qv/Op0S2DqFDw55n9lGoLu514f/TI8Im5gfqIt3BwUlXFCQju9Pyqw498y9+4ClyXHE7pZgfWlhSsxOWi1RjiKjgJ9sE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=iyz80P7E; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="iyz80P7E"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 43BNJ6jC007522;
	Fri, 12 Apr 2024 02:05:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=DTYWJk06Qjc9VXTR9WdSKZXZTlYUpA16tgkFalaD4Qg=;
 b=iyz80P7EJtCu96RIhO4xlhXN8cZgQZfskPwisj5nGvIvPpqazL7WMQDcRaThPWxxkSt9
 HCfzhzo903M1P0WTZC1C1Z2rvVJEUDUULqibctmtenamae2F4ikO9NcEXTrwenBKCISt
 bXNfwiKBdU1qxHRNX6IIXD5GCt3QOGmuEbV6Y4mZwmNqmw/41TZ9G6V9cqHUfCmx1kDz
 hz0LdmbhB6s5J6U8VcjyAKlxskeSyP9GZ/AlFdSyiZzuOcyPoKL6vHvpTHfEb2imIrs+
 YZsHrymGoWmYEtifIDZQ+CxXs/eLqE+iGEqGuh6yBo6/AnTeGjSfWqtyVP+1QaoI6CRa +g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3xavtfape8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:32 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 43BNoGAL040673;
	Fri, 12 Apr 2024 02:05:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3xavugmd2u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 12 Apr 2024 02:05:32 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 43C25UFm013100;
	Fri, 12 Apr 2024 02:05:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 3xavugmd1x-4;
	Fri, 12 Apr 2024 02:05:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Hannes Reinecke <hare@suse.com>, Prasad Pandit <ppandit@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Prasad Pandit <pjp@fedoraproject.org>
Subject: Re: [PATCH] scsi: aic7xxx: indent kconfig help text
Date: Thu, 11 Apr 2024 22:05:11 -0400
Message-ID: <171288602650.3729249.1948864026511470106.b4-ty@oracle.com>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408050110.3679890-1-ppandit@redhat.com>
References: <20240408050110.3679890-1-ppandit@redhat.com>
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
 definitions=2024-04-11_14,2024-04-09_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 mlxlogscore=995
 bulkscore=0 suspectscore=0 adultscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2404010000
 definitions=main-2404120014
X-Proofpoint-GUID: pUCbTwHQDXR3kXd8TibrNHa47kdGEun9
X-Proofpoint-ORIG-GUID: pUCbTwHQDXR3kXd8TibrNHa47kdGEun9

On Mon, 08 Apr 2024 10:31:10 +0530, Prasad Pandit wrote:

> Fix indentation of config option's help text by adding
> leading spaces. Generally help text is indented by two
> more spaces beyond the leading tab <\t> character.
> It helps Kconfig parsers to read file without error.
> 
> 

Applied to 6.10/scsi-queue, thanks!

[1/1] scsi: aic7xxx: indent kconfig help text
      https://git.kernel.org/mkp/scsi/c/6c19ecf4ad1d

-- 
Martin K. Petersen	Oracle Linux Engineering
