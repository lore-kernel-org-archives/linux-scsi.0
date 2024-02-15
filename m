Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A6F0132469
	for <linux-scsi@vger.kernel.org>; Thu, 15 Feb 2024 20:39:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708029585; cv=none; b=bvPWEQzjlOufWKk663mnuIySUqCblKHcWJXxMOdEZOcWYqG9OB12VD4ZIcLfnsTqSYSZbh0r9bI6E2fP3204Dr4MoWUu0dVMS8HtvLvKPWkaVvos8qSfHJtiM08KdWSaA4Lx7rDmFYh9esJa2dKWGyJruMAznVplPYnxl+KdBOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708029585; c=relaxed/simple;
	bh=UO2V9hk05Bqem6L14w3LE6ZnW0MXIN0/UjSBrzT2qvE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fNAu66vNI7gXha31kW4Uttq7sqMXufU3W0dS3frxyI5/dgaYeg+OZbfcftVvdhx/BKCy8yeY8zKHLSi5OnWzQxr4S44Cjsj7Wqw6cZuSfeolMuCZLoDVLONjQhXdu0ILSbCUox47sSNnyQntP2Onv4Q5C3fHxTU1IV5kj0PvE6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZkogP4G8; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZkogP4G8"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41FFSw9S006155;
	Thu, 15 Feb 2024 20:39:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=7g+cys/6M6BU1/EvBAmH3JTh9n0SayLKIlinxCpJCiM=;
 b=ZkogP4G8tKw7nhEOVlV/wTLlZmBBPPKudlkLFe5hNO2kfg4rMcYEDdiUtMEOCcI8BKrq
 JgWOgc9j8LjUQmSwSWJRVMBYYXvR3iK27nRrVS5bKChoXBlnF81aVveGEUHXFXEkeb7D
 3YCBlR2krWm9ntbRJCXodEt2uFlSUOQD79hSV14FYSwbV6bfbayHBFIZMb//1EcEUK13
 ucKc30jDAPM0i2zRi8EosI0ocdxbZ3rjgp0AgvEk9Je58aOl474pXPr6dF5Ji4L3l7pj
 OzMyFnphQSzGpTpHFNSBKDpGSsacqF3SiMt9xONfhk3ZPmzOxrFjH+jvD8S/s7BNfuMB pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w9301372k-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 20:39:33 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41FKQi7u015037;
	Thu, 15 Feb 2024 20:39:32 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w5ykats48-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 15 Feb 2024 20:39:32 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 41FKdVPL012444;
	Thu, 15 Feb 2024 20:39:31 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w5ykats32-1;
	Thu, 15 Feb 2024 20:39:31 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Kevin.Barnett@microchip.com, scott.teel@microchip.com,
        Justin.Lindley@microchip.com, scott.benesh@microchip.com,
        gerry.morong@microchip.com, mahesh.rajashekhara@microchip.com,
        mike.mcgowen@microchip.com, murthy.bhat@microchip.com,
        kumar.meiyappan@microchip.com, jeremy.reeves@microchip.com,
        david.strahan@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com,
        Don Brace <don.brace@microchip.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] smartpqi: fix disable_managed_interrupts
Date: Thu, 15 Feb 2024 15:39:22 -0500
Message-ID: <170802930861.3317154.3628888067289523734.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240213162200.1875970-1-don.brace@microchip.com>
References: <20240213162200.1875970-1-don.brace@microchip.com>
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
 definitions=2024-02-15_19,2024-02-14_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 spamscore=0
 mlxlogscore=999 bulkscore=0 phishscore=0 mlxscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2402150166
X-Proofpoint-GUID: bDVsGXHk4EM-Cu5QH5yH4RF9JHhAcHue
X-Proofpoint-ORIG-GUID: bDVsGXHk4EM-Cu5QH5yH4RF9JHhAcHue

On Tue, 13 Feb 2024 10:21:59 -0600, Don Brace wrote:

> Correct blk-mq registration issue with module parameter
> disable_managed_interrupts enabled.
> 
> When we turn off the default PCI_IRQ_AFFINITY flag, the driver needs to
> register with blk-mq using blk_mq_map_queues(). The driver is currently
> calling blk_mq_pci_map_queues() which results in a stack trace and
> possibly undefined behavior.
> 
> [...]

Applied to 6.8/scsi-fixes, thanks!

[1/1] smartpqi: fix disable_managed_interrupts
      https://git.kernel.org/mkp/scsi/c/5761eb9761d2

-- 
Martin K. Petersen	Oracle Linux Engineering
