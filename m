Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26B881E885
	for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2025 01:07:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739927254; cv=none; b=e0QG7MhuCO6bN5EKhTP6v2cIDA+qYCiBc9orJPUZ1Z5QTxNcMaXza1d/DiU6fTq8/yf6pxwFUGsqKjNaly8ptvtWElkl+g/rPpJaITCR3VSlFG8V3HZI/T+S2lpRmFWv64hCWBDNAa8QBIJrfTwcxktnh2bOe6Ymb3cp6Ms4Ro0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739927254; c=relaxed/simple;
	bh=UCllqoHhrQNXM8MmBM44P76s/o9p7I6GnAU6ZLFLWaY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GFLbWk6HqEgSlkJbDB5KfghpbqvozzLuDml7V7LsfiFcpPe0dveYp8MTOiLhsZ2BOgyvYs5QZMw2/ggUVn7bal+Suk7oVGwwFq4Az0EvLWDmJtsRXAfxaVA1fb8ZftODsEYHUKCFEl61Tok8qqJUfo0Rpfx1uhsKrz5YY/YgAao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=NJtVjQ1j; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="NJtVjQ1j"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 51IMgfQM007528;
	Wed, 19 Feb 2025 01:07:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=mqBZIya0Zo9bV0vIxDWGC8d3N0v62vUQUUrJ7AutH7I=; b=
	NJtVjQ1jxmLXG8wxZ65E0snrBbIslFXwWNc5y5tzptclMCp/4rK9rAhzY3uzxsU2
	YkXNzjiFns2H1opOpbCAU3Gi2kCoihvjf78vKo3GrttlM/UXv4SnTrGhEjs1Xh7E
	SV2i7YOjz4qck+kWm2MqmS6V73Aj2GcH/VLvNTG4kVPa+3jc3hKt3BXcJTe5LLzT
	3YDwAPBD7/aPTWvLo0Iz/Fznjc7sdU8wbtG19E/akWeWeup4o19bYHlqRbTp3m0X
	j+xts0a14yMc9ZPGAA8RZpq9gDhF0Vs8/6oEiznLIynzmhvIqaYWFrhs8lmbbUEO
	veoaupZDGdPZHAav085vgw==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44w00ngkp0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:25 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 51J0DSMV002247;
	Wed, 19 Feb 2025 01:07:24 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 44w0tk1rrt-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 19 Feb 2025 01:07:23 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 51J17KeT000669;
	Wed, 19 Feb 2025 01:07:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 44w0tk1rq5-6;
	Wed, 19 Feb 2025 01:07:23 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, open-iscsi@googlegroups.com,
        Eric Biggers <ebiggers@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: iscsi_tcp: switch to using the crc32c library
Date: Tue, 18 Feb 2025 20:06:54 -0500
Message-ID: <173992713070.526057.6348295717628038082.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250207041724.70733-1-ebiggers@kernel.org>
References: <20250207041724.70733-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-18_11,2025-02-18_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 phishscore=0 suspectscore=0 mlxlogscore=853
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502100000
 definitions=main-2502190006
X-Proofpoint-GUID: UwujlG0Jhz3eK6aOGlgvsNPyhvxSx66_
X-Proofpoint-ORIG-GUID: UwujlG0Jhz3eK6aOGlgvsNPyhvxSx66_

On Thu, 06 Feb 2025 20:17:24 -0800, Eric Biggers wrote:

> Now that the crc32c() library function directly takes advantage of
> architecture-specific optimizations, it is unnecessary to go through the
> crypto API.  Just use crc32c().  This is much simpler, and it improves
> performance due to eliminating the crypto API overhead.
> 
> 

Applied to 6.15/scsi-queue, thanks!

[1/1] scsi: iscsi_tcp: switch to using the crc32c library
      https://git.kernel.org/mkp/scsi/c/92186c1455a2

-- 
Martin K. Petersen	Oracle Linux Engineering
