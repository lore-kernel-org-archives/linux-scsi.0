Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA92EA94A
	for <linux-scsi@vger.kernel.org>; Sat, 26 Oct 2024 01:37:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729906627; cv=none; b=Gg7O5pghT13iGFl/y1/ySCSOTjTqY/uV6Qu7rBeMtsZNft4jZgxUq71jgA147HEVzcGoMmUNOwtoGjDpnmVxzh6tx6Lajtxhxu0N65pU9Rot7p7+Qql2J27GChwtpkMm9KSYt9T/S9bhXastftfHXzMT01cv3DMMr/xDQVu4T/o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729906627; c=relaxed/simple;
	bh=I3SR3bH0JHWY7sW7qptFQayw/AGETjEd4aUrcG6+a1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=A4KZHJw1jAgg+whPTtS4lisQZTtUE+uk869IUQfBq25O6RJ7Ed7M+xWCbXFIoJq6CfxEgyV8qPt1hi+7msyipI+jlIgkjeKUJzUj+E/QFYdCpLnkd+zk8FCmRHMCoi1IXnB2Luvye2Tf02nTAy1MgZ8zNYJ0FhdJZK8PjqWq9Q4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ooM2M1mX; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ooM2M1mX"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 49PJeSIP006150;
	Sat, 26 Oct 2024 01:37:01 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=cl+yo+GPKFv2hSmVObNq0NaTGdJ0xufEEoubwDk4Pok=; b=
	ooM2M1mXb2vjuBIzqlq59KYcOhwhnIXFJa09ShdbsovFQB91+IAXvj2d3AMBevvA
	aE6yRVBpcwLTGHExSmCnaSUxw2rX4DHyaYia2HgTnB1gwn4gXrtaYZ1WyspDwowf
	qPmCLCemJpfRr36DXYagLmdiSKFh+xJ+hnaEiNeXn7S/z6rLXTMbfX+RBJGmnhuR
	fuvnF3DaEADfXC1mi1P62S7wPmoS1v1b+7uwf4aKU8vO8cHx3LpA0fSe5HlxI8g0
	6EvwA0TOrvRAaS3d1squB9wCdN5IVA87rYhvamA6rGqjZdcaX1ERwAuBMzeK0QM/
	z6yaxNeMP+3jZ6Gh0Uk4fQ==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42c5asp63a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:37:01 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 49Q1XBwM039539;
	Sat, 26 Oct 2024 01:37:00 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42gpv402h4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 26 Oct 2024 01:37:00 +0000
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 49Q1b06g008403;
	Sat, 26 Oct 2024 01:37:00 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 42gpv402gw-1;
	Sat, 26 Oct 2024 01:37:00 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        John Garry <john.g.garry@oracle.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, colin.i.king@gmail.com,
        dan.carpenter@linaro.org
Subject: Re: [PATCH] scsi: scsi_debug: Fix do_device_access() handling of unexpected SG copy length
Date: Fri, 25 Oct 2024 21:36:26 -0400
Message-ID: <172990647462.1923948.13678399665262765853.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241018101655.4207-1-john.g.garry@oracle.com>
References: <20241018101655.4207-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1051,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-10-25_14,2024-10-25_02,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2410260011
X-Proofpoint-GUID: ulZMENskqfkZhElYdvogUFuFOs5hI616
X-Proofpoint-ORIG-GUID: ulZMENskqfkZhElYdvogUFuFOs5hI616

On Fri, 18 Oct 2024 10:16:55 +0000, John Garry wrote:

> If the sg_copy_buffer() call returns less than sdebug_sector_size, then we
> drop out of the copy loop. However, we still report that we copied the
> full expected amount, which is not proper.
> 
> Fix by keeping a running total and return that value.
> 
> 
> [...]

Applied to 6.12/scsi-fixes, thanks!

[1/1] scsi: scsi_debug: Fix do_device_access() handling of unexpected SG copy length
      https://git.kernel.org/mkp/scsi/c/d28d17a84560

-- 
Martin K. Petersen	Oracle Linux Engineering
