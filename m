Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3929101C8
	for <linux-scsi@vger.kernel.org>; Fri, 21 Mar 2025 00:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742517445; cv=none; b=AiRqei0lYHw1NZnkuir//v/kuAZFUS2/4q4fc8Suk6ujAh95LbxlqbeZHqmOm6vJsZ/MYrlKEa5pLvQjQw+jXt9Eybpdu5a/QOOhuCrjlFgcl2l2gKascJMlzqPwp8tEyeu/pZCjIQickys2yVPfPg/eAEWUWUeA0HuR5z3dcj4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742517445; c=relaxed/simple;
	bh=P2mDIs00GOVlrgU9p1qR5LA2KvwCM938ESnYIqenfaU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QxukJlBRmCuTnR+9YqEk2+mSHIa5zY1XvtN3FreOzFpHp9CwY+R5mEJ5UsVy282FMb5QSgT1Tl1zXAQefNdv8kPTCKbpg31mgJ9C43Y6W+InR+T6gs8iVozlyRTlraDeSrnijiFdU/NbbMmGZnf1BsgPwLCbJ9FVVyz+xony4pQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=MLCyuQBi; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="MLCyuQBi"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 52KLB6ur006961;
	Fri, 21 Mar 2025 00:37:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=lMwfxYTs5x0weQ+Ah8b8ZOocuyQ5+njeCieaLTEF1qI=; b=
	MLCyuQBiX2Rh7haXaZ4OyxG/ZuhSiEf+De5jkqdksajVauWvddI9/RXVRmLVaIU2
	TSyr97vJlR0XJR9lj9TWAMMj2601ZQnje1nnfok/NvlOG641OtucWq8Gu6lZ20Zy
	MrQWVKX7N/udxc1LhCK2KMzEE0u66IEV2Un3fYoT/CUqti+5icXhk71qdy+baltd
	NoQ7YQ5TKrWU8yMue0kAW5aCXfVUZnLI/fhXz/AZBXK6R+68pd+3OCStKe1++n2j
	X0ODEAe3qXaN1sTnhbqGa9oV1ou4LR3Rd5mHhTWsUWo594iz6dn2tRkcxiE83RPv
	oQ0P42dVf7CKS7wEv6sLsg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45d23s7r6c-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:19 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 52KNb2HK004724;
	Fri, 21 Mar 2025 00:37:18 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 45ftmxt6u5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 21 Mar 2025 00:37:18 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 52L0bHsY024893;
	Fri, 21 Mar 2025 00:37:17 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 45ftmxt6tx-1;
	Fri, 21 Mar 2025 00:37:17 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, "Ewan D. Milne" <emilne@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        dick.kennedy@broadcom.com, james.smart@broadcom.com,
        justin.tee@broadcom.com
Subject: Re: [PATCH] scsi: lpfc: restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
Date: Thu, 20 Mar 2025 20:36:49 -0400
Message-ID: <174251737526.2240574.11196982489638377487.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250317163731.356873-1-emilne@redhat.com>
References: <20250317163731.356873-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1093,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-03-20_09,2025-03-20_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 mlxlogscore=999 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2502280000 definitions=main-2503210002
X-Proofpoint-GUID: mQ9w-C8J2I2JCoKiPthQnzYEiGtJ1F4M
X-Proofpoint-ORIG-GUID: mQ9w-C8J2I2JCoKiPthQnzYEiGtJ1F4M

On Mon, 17 Mar 2025 12:37:31 -0400, Ewan D. Milne wrote:

> Commit "scsi: lpfc: Remove NLP_RELEASE_RPI flag from nodelist structure"
> introduced a regression with SLI-3 adapters (e.g. LPe12000 8Gb) where
> a Link Down / Link Up such as caused by disabling an host FC switch port
> would result in the devices remaining in the transport-offline state
> and multipath reporting them as failed.  This problem was not seen with
> newer SLI-4 adapters.
> 
> [...]

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: lpfc: restore clearing of NLP_UNREG_INP in ndlp->nlp_flag
      https://git.kernel.org/mkp/scsi/c/040492ac2578

-- 
Martin K. Petersen	Oracle Linux Engineering
