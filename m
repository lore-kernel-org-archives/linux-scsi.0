Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4B908F6C
	for <linux-scsi@vger.kernel.org>; Thu, 31 Jul 2025 04:44:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753937083; cv=none; b=q16dJxdcCcr2AzPk7CoFfvzU+oimMtjHlxboHGuvMS3nK7aO8hj6tbXFuqJ5Z93L/xCDVowxNlbwD4pPktiJ089E24DzIwObMTOKJ35uMD2fJrYWUZzzK2fX3st/eRj9CzUQJzMkeXzQZ6Pe8frqRoX4nH6q5/tfyiixt7EWWOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753937083; c=relaxed/simple;
	bh=tcJpGq5zdil6akbJLaRvne/yR3S80u5ydDVr9LBY87Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=kfjrrcpJ8VtVCBMLJ2QeXKMiUDl5qDfTSRHEkQwU/LaAKhLXS4DtCirUjAji0iXhr8Fw+ixKomeVufyhs3aMZRwijny+ceuhDIdS7IxcnBwsyXl+wnxs9cflFuzjlwUiqP9SIJwmLujfDnoJ9pK4butD3S6RKrJMnwKCCw4b88s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FrwM+P3W; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FrwM+P3W"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56V2fxPe001040;
	Thu, 31 Jul 2025 04:44:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=vjYMM5iSdJGeIgm9ke7epKdhVk0kW9gv/RPRtsnd+Qo=; b=
	FrwM+P3WB2v0NqYeSeZK7rdpG/9qEbcyxWAlwLTThlKzLL07ApU+1h4KuzOWQdg9
	ghIYE11nuKQb4FTSNcEBm5g80ox1K3fvOrPHCkE4xuEMYoWrI23pXxr+lHKFNl6a
	X1zmNiEk3e2yGeDW0vuB3S8URQxszoutajbwnedakwLNU/y4gMT8Ag22AI6ujLDx
	TUGxUKrDZy3RbXOarFZmnkCfGBsridJHqrrxOu7PoR3jOK7xSnzW5H8TL5HqTnQE
	fV0ZwdDH+mz1UwLVZMBblgNfGHwWW7hz60S5gkLeZKMrotA57SvnsC+hBxuCl0Ll
	acTTO/vV3eWu9QIoC+SMlg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 484q2e3h9u-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56V33FXR016838;
	Thu, 31 Jul 2025 04:44:35 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 484nfjb2tx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 31 Jul 2025 04:44:35 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 56V4iX3x035411;
	Thu, 31 Jul 2025 04:44:34 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 484nfjb2tg-3;
	Thu, 31 Jul 2025 04:44:34 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: jejb@linux.vnet.ibm.com, sagar.biradar@microchip.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, jmeneghi@redhat.com, hare@suse.com,
        ming.lei@redhat.com
Subject: Re: [PATCH] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
Date: Thu, 31 Jul 2025 00:44:21 -0400
Message-ID: <175375581098.455613.2369461313330312314.b4-ty@oracle.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715111535.499853-1-john.g.garry@oracle.com>
References: <20250715111535.499853-1-john.g.garry@oracle.com>
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
 definitions=2025-07-31_01,2025-07-30_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2507310030
X-Proofpoint-GUID: OLH3V2zJoE8SCJxcuKBV9vj9LwIak7QV
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzMxMDAzMCBTYWx0ZWRfX3kVJQJPsI4zK
 rD4gCbkziAv8ozOJ/VjDjHvRpLeXGusp8ZPFHtv5h9XyPm6v/enoErTYIBGySIpbXI0ew6+MODQ
 Mum+Dvm8afDyi7e1UHuIsRrKDN1mn8S321OrG0Z+ftCRzac5OuwbskEPmgSlPKjV3O3LMmYzSxi
 ohHw/YG4MOqWlnQoKE0QUfwUMoTdXtFsJqXhXRm4aHJtG/8jSq7NewVw79G+dcx/MKRZtQAE8ee
 4Hy3xZA+twtAfrJJueEnBe7b8Lu5ha1s2YbeBsCndnH0FcTXv7JECPMiB23cJUec7X7SOzvibH2
 Em5WeEf/kOxXrA7HT7yPzI1ixKJt0/0FzGtjz2hAL+62QOw+Em3WF+F8RiUsmXJmToGxhttpfVs
 oekFshDwE9URdU5jGrKFFKQPTjImktNpI+klc9344NgqqqIaSls4fXzalN2AUWJUjIoQsvPs
X-Proofpoint-ORIG-GUID: OLH3V2zJoE8SCJxcuKBV9vj9LwIak7QV
X-Authority-Analysis: v=2.4 cv=A+5sP7WG c=1 sm=1 tr=0 ts=688af4b3 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=Wb1JkmetP80A:10 a=VwQbUJbxAAAA:8 a=ke5jX5FbGoVysnE3a3wA:9
 a=QEXdDO2ut3YA:10 cc=ntf awl=host:12070

On Tue, 15 Jul 2025 11:15:35 +0000, John Garry wrote:

> When PCI_IRQ_AFFINITY is set for calling pci_alloc_irq_vectors(), it
> means interrupts are spread around the available CPUs. It also means that
> the interrupts become managed, which means that an interrupt is shutdown
> when all the CPUs in the interrupt affinity mask go offline.
> 
> Using managed interrupts in this way means that we should ensure that
> completions should not occur on HW queues where the associated interrupt
> is shutdown. This is typically achieved by ensuring only CPUs which are
> online can generate IO completion traffic to the HW queue which they are
> mapped to (so that they can also serve completion interrupts for that
> HW queue).
> 
> [...]

Applied to 6.17/scsi-queue, thanks!

[1/1] scsi: aacraid: Stop using PCI_IRQ_AFFINITY
      https://git.kernel.org/mkp/scsi/c/dafeaf2c03e7

-- 
Martin K. Petersen	Oracle Linux Engineering
