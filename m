Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A54D57319
	for <linux-scsi@vger.kernel.org>; Tue,  6 Feb 2024 02:09:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707185360; cv=none; b=oL0NIlOcGD/2M8oskSG8qtGBbkvVdlxpi3iYQLUMjz7xYlJpvjS9tsX3sM6mY0EqKeZogNRRjFUxuviZQ8hiVHqM6GFRrH0Jy/P3eqJVto9wwUSJGlh9wUh8x6h0VAwZUtel7CIRdCnYs1VeaQhZk9c1d0O2lDIQyve0tN/HpHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707185360; c=relaxed/simple;
	bh=oRo4L1KFYmfIN/UWpbdEXT31facsiRQjzEtMoEg/RyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mgvzxbdcWKX7f540ujew6iRcu4eoGpcvuQe/fjFj5XyQ1HScJIlCoe0ezU/KNzMeuyUVDeYKStXqmBf4rlqTsgTL/x642gqS2ZGZSzE0XnxqvREp9HqtmXkna43D3NDaST+8ra7hRLDgZeZNliCyj45iVer+CuK6fHpoJWvjQRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HhCIxwby; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HhCIxwby"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 4161EQd2002420;
	Tue, 6 Feb 2024 02:09:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=zG2zpabKgQs5ssDfqD02p+vef2so3sM905v6AzvsScA=;
 b=HhCIxwby50BSrRQKrDYQWNqoLeLoJ4cZuobmBuC2MZWv7saiDfjmXje74ESmT9wO52z8
 xGfS6VvrMguj20IFbyWwIdXitac5JCm5+BBFmPTlLYD9t42twYfv/KG7PtEnPjpiKb6t
 3T18fj20ixFcE9pMkICBxEb3O6el0okdrntr5ugYciAg5GUrLR6QwcYnE6uc/0WBRnSP
 wOxSua44kmhpAYAhvwFskOTrR0o78JgDCeheAOJA1sYnSVtepkTAA/R7vy5vxS4jNqfw
 yZzQIKZycMpvFRTKwOP09TiZS+zwY+ObsoyV3F5+aYtKFxH/HI4kicihUTmZ3g2qNtP4 +A== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3w1cdcwknf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 02:09:12 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 4160Ytrd039623;
	Tue, 6 Feb 2024 02:09:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3w1bx6ceh8-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 06 Feb 2024 02:09:12 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 416297CO038970;
	Tue, 6 Feb 2024 02:09:11 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3w1bx6cef6-4;
	Tue, 06 Feb 2024 02:09:11 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash Veerichetty <safhya.prakash@broadcom.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "Ewan D . Milne" <emilne@redhat.com>
Subject: Re: [PATCH] scsi: core: move scsi_host_busy() out of host lock if it is for per-command
Date: Mon,  5 Feb 2024 21:08:58 -0500
Message-ID: <170718504169.1101069.13667549110730814817.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20240203024521.2006455-1-ming.lei@redhat.com>
References: <20240203024521.2006455-1-ming.lei@redhat.com>
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
 definitions=2024-02-05_18,2024-01-31_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 phishscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402060014
X-Proofpoint-GUID: NjBR_bmFgaerkFpMpmPTmZlSJ6siSnhP
X-Proofpoint-ORIG-GUID: NjBR_bmFgaerkFpMpmPTmZlSJ6siSnhP

On Sat, 03 Feb 2024 10:45:21 +0800, Ming Lei wrote:

> Commit 4373534a9850 ("scsi: core: Move scsi_host_busy() out of host lock for
> waking up EH handler") is for fixing hard lockup issue triggered by EH.
> 
> The core idea is to move scsi_host_busy() out of host lock if it is
> called for per-command. However, the patch is merged as wrong and
> doesn't move scsi_host_busy() out of host lock, so fix it.
> 
> [...]

Applied to 6.8/scsi-fixes, thanks!

[1/1] scsi: core: move scsi_host_busy() out of host lock if it is for per-command
      https://git.kernel.org/mkp/scsi/c/4e6c90119907

-- 
Martin K. Petersen	Oracle Linux Engineering
