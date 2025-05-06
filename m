Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EDED2D47BF
	for <linux-scsi@vger.kernel.org>; Tue,  6 May 2025 04:26:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746505571; cv=none; b=sD4lN2aYP0buYtqpBtKd9bjyoOrqBTEMNP2s/rxzRAGHLBtmHoyL23b/Ym3WyvlOxW7iRueZ2uKrjZwa0NI8qJ/t3lB3h4DknSt21+Lx9IDVk31pSd6GNyiHwSA0oqyeSMDddz5Bt5a1nAgSPl0GeTTCrJ+9VXNOJ5WFSVvkcmE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746505571; c=relaxed/simple;
	bh=TJ6Ihjt0Zkx9ltHJkcl+dBDAG6FzJtOHVAre8+wGAhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bildF/8cFWIRzYrws40Oo7pknGPkAZsQrN4IPzUPrjv6FMKfZ7z//+Wsv9TZOMHK/Wi98tItqn5qKGn8uIjPe9Mk6NLzA0tKJwj0gp0BZugRGXEIymWnR7S4nEHkEDznllaPc33Pk/9EixIvelsc+15Wgm/NaRgZy2UW6ygSGms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ltpx9iiY; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ltpx9iiY"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5463HHgQ000473;
	Tue, 6 May 2025 04:26:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=hjQGVim9BCz8R8NmuS/5HEYuglK5PPoRG2/RtObNkG8=; b=
	Ltpx9iiY5/rcgQuVyabRn/ZcTsvXOoYNaoZ0m4uJhymzeNIF5jwqQYjqDmgg2mhu
	RNb4UFR2vmWjbPnV3g7BUDl+QW4AFPfGAMK5HtQrIB9NrcDm9U+H3r2bC6k9ofDY
	4FPbiaIcWKZZB1YO0fCfLoTsEolTAqh3+eY/S5m8Yb1zyHuw+2SgSDLej3DdWyx9
	zBm6e6Hs8y+qMUreGOhY7DBJCq8PhzhLEj3B9phCNGkjxAh4LrsBYr16dl18qkG6
	9CFh2h2NDXH/HwErfm/A2Vqbd8W0xPwhEsGht1w0E8JwLXQHACCxmIH3UtLxzs7W
	ZFotLnP2nqAG3JRURtRrfg==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46facp01v7-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:26:00 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5461enC2036150;
	Tue, 6 May 2025 04:25:59 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 46d9k8gpq3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 May 2025 04:25:59 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5464Pr4G012838;
	Tue, 6 May 2025 04:25:58 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 46d9k8gpmt-6;
	Tue, 06 May 2025 04:25:58 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: aliakc@web.de, lenehan@twibble.org, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org, colin.i.king@gmail.com,
        Oliver Neukum <oneukum@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: dc395x: remove DEBUG conditional compilation
Date: Tue,  6 May 2025 00:25:24 -0400
Message-ID: <174649624834.3806817.7124676275905925007.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250428124345.520137-1-oneukum@suse.com>
References: <20250428124345.520137-1-oneukum@suse.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.0.736,FMLib:17.12.80.40
 definitions=2025-05-06_02,2025-05-05_01,2025-02-21_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 malwarescore=0 spamscore=0 mlxlogscore=556 bulkscore=0 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2504070000 definitions=main-2505060039
X-Proofpoint-GUID: 0Kwj0_1Ak_ca59ynHzhtbFwP2RaihIsB
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTA2MDAzOSBTYWx0ZWRfX99NLaLYA0MkL jQv1hV8t1vIjysAzeg5ZW5hPE+o5ZO9/7uQ/yC9VtH9LDT7l6/U3/eGVzBHrFmd3esADDK74h3j OvVN35Eql1bmlUsU1W3ocSpOf32psrtc/GlqFUySBPjckJUODA1oNNZYnzeNHmUI6cTtdfRjQKO
 6Vxb2onf6J6MKunOUWCFPXiSIwkLQ7MQ2/dUdtk120uEYlEqNd/YYmbROf/isD+2Yg+OJcNaRGE rt9iyPkO3DPosRX3Doi7+kXM05Z+CVu//2w/pirsIfAOBhTnTjyc2tp0UFEeXjDwZt3lHjzUeYT psJO0mjb+W1Nyr0pr71G8+TomgG/8vDrbNu8leN0/Jg9yxYhC03KYUIExzWDSEORJ3LXfkHx0UX
 f8busa/MeKMDoixlutn3KtliwHnNjUH75CZ/ULOUAOSKfLZBHrUqQ8bQYGppdYb5MBE/0BXK
X-Authority-Analysis: v=2.4 cv=VMbdn8PX c=1 sm=1 tr=0 ts=68198f58 b=1 cx=c_pps a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=GpTLih_sxz3SPXujGuwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: 0Kwj0_1Ak_ca59ynHzhtbFwP2RaihIsB

On Mon, 28 Apr 2025 14:43:45 +0200, Oliver Neukum wrote:

> It has been broken for ages.
> This driver needs to be converted to dynamic debugging.
> Remove the crud.
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: dc395x: remove DEBUG conditional compilation
      https://git.kernel.org/mkp/scsi/c/62b434b0db2c

-- 
Martin K. Petersen	Oracle Linux Engineering
