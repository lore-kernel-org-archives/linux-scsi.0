Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9775250
	for <linux-scsi@vger.kernel.org>; Wed, 12 Jun 2024 01:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718157524; cv=none; b=JxBMI7Acxxm0YFKkAkyRvzJRnsxv9yKN3WR0ndOGY3TeqPmm+EvrOvtY1C6QBRDkjfB4yT99dX5g7HCAW7BFOe8hvSKxfHnCZPLuv8clk3t8c16uqRtKoGWD9n6zMblvtPiPigED8g4Jmr4JMjrciTOjk21k+gsST3znEVvVN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718157524; c=relaxed/simple;
	bh=aDtXfOOXTPWNXdcwD4MvKRZRdYfiP0YcORC/kbAKT2U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=oUSlnSkqGnYhidHD/KwbXmeXgdQ/oc5pg4Wyvv7MUqQtJUk3SXJcMbAvKfVODlpqkJtDiXYdT80yYUykzODCJR/eGGaA++F+lPTr86eG7VOsKQePpSPPsBGZpL00LGG1BQBwPQvS1AoG4mifOb8zIqM88sieE6gCv2Ka9oLwxNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=bi46Ilk1; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="bi46Ilk1"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 45C1tWMZ023951;
	Wed, 12 Jun 2024 01:58:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=BoUasUMrmwmhl1uR6UDfLMgE4JtJDZpwOlYxAXA5L6w=; b=
	bi46Ilk1NHvorz40xx9W6bbt/xQTkthptdSohytKiliQ2L9DdZNivU0L7wtl5r8x
	ZSaJWj0e0QId8myWokZQ98366BTyHSE82QbbuzfSFuoStEMgjkXxuQbbLRHLSd1d
	XbklUN3Zz00f1be2BpzXzno0lry8n965/ADTBNfdwuuEgafMwTG0zlxUzRK0rCI9
	OV93DNjSPaNRDHPe10yxU9w80RRLn1f/mNU0Rz97iwcmMG4K/LJcSkkYpsE5DiLM
	l5zxgXgxrm5sSEi8B6cTVKBYlUwy4bKM32yVD9OWd8XuYbyC3fhdSnZ9cPMm+wkj
	GuJznoMgdBM8FTE2g7UYiw==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ymh7fp2tv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:58:38 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 45C0PmrF014455;
	Wed, 12 Jun 2024 01:58:38 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ynceusfva-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Jun 2024 01:58:38 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 45C1wbsY031272;
	Wed, 12 Jun 2024 01:58:37 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3ynceusfuq-1;
	Wed, 12 Jun 2024 01:58:37 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Igor Pylypiv <ipylypiv@google.com>
Subject: Re: [PATCH v2] scsi: core: Disable CDL by default
Date: Tue, 11 Jun 2024 21:57:59 -0400
Message-ID: <171815745544.194120.12562653811725212031.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240607012507.111488-1-dlemoal@kernel.org>
References: <20240607012507.111488-1-dlemoal@kernel.org>
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
 definitions=2024-06-11_13,2024-06-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 phishscore=0 bulkscore=0 malwarescore=0 spamscore=0 mlxscore=0
 mlxlogscore=952 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2405010000 definitions=main-2406120011
X-Proofpoint-GUID: fqX5c-fyIS5iypNg8aIK9m5detqccjJe
X-Proofpoint-ORIG-GUID: fqX5c-fyIS5iypNg8aIK9m5detqccjJe

On Fri, 07 Jun 2024 10:25:07 +0900, Damien Le Moal wrote:

> For scsi devices supporting the Command Duration Limits feature set, the
> user can enable/disable this feature use through the sysfs device
> attribute cdl_enable. This attribute modification triggers a call to
> scsi_cdl_enable() to enable and disable the feature for ATA devices and
> set the scsi device cdl_enable field to the user provided bool value.
> For SCSI devices supporting CDL, the feature set is always enabled and
> scsi_cdl_enable() is reduced to setting the cdl_enable field.
> 
> [...]

Applied to 6.10/scsi-fixes, thanks!

[1/1] scsi: core: Disable CDL by default
      https://git.kernel.org/mkp/scsi/c/52912ca87e2b

-- 
Martin K. Petersen	Oracle Linux Engineering
