Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 427E31C27;
	Sat, 17 Aug 2024 01:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723858535; cv=none; b=kEHTcO+X/m2wJEBY1wr7g/tCvhLFOht+9JDnwWEiB7Vm503IRVdGIf7yjCG5hC6R9i0KT+9oHiWEx2hbjD+bOFR2V3s48n9G3ONHfDIf+yQu7Ap0W23H7ScYI44mb3zaHiKuhFfmRi/3jS1mQAXmqRjxMX694yvJCGasw+/fWVs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723858535; c=relaxed/simple;
	bh=4LSvQeTR2aPKJk90n9OzYCXKOmQ2gOVbk/P5PhH72LI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hOzRFaRnFHahxjE6FKybyCPbrj94B9bmCUbxp2jQxtj9qWvwLhUGdM3Tn39wYlENmqVfBkxik5ZppXNkhdLAWMBrmw84ityqk05NOdj3lrRFmscns5wBMew9IIb6tf9YDNJ5cc3eaJNIDJREoVa64a+e4hZyW6WFDSZLLE8LpqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=N1r9KGPA; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="N1r9KGPA"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47H10uBw030485;
	Sat, 17 Aug 2024 01:35:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=RcyIY7dAOLNFoaYnKiwoiE+YLhUZthVQp6jgi3UF3IA=; b=
	N1r9KGPAJL1gy7HT8at+jH4QlAe+Wt0KTYfiwbHyyxUOY92Z5L2LZp9tiIypruYx
	hYmQKepXLP4xHtzZB4VwRLKW68K3XHcwxVmfVbHCAxrAQ75t1MlSDW2ysq3EZAF5
	a/oGPCQ+tMjCZb6cWTZwp1JvviwCvKvPiGNi0AQJJeXT+LHNh6RPeTJwKvMvJtv/
	VM2c+jse6Z2CKitl6CTp2b6f0mohuOSMpsc7z4UmW4UBfods7QmkZsdfKO6kLiIZ
	xJ9V0lrxxMoHfXhBuWs9xCYqzRk3OA9YE62UnG/tgldJbiVqXPnt0oyWNQLtzMpI
	0gFW/4n1I5eUgpDnqhLqag==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40wy035xym-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:35:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47H1XPFw022209;
	Sat, 17 Aug 2024 01:35:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 412ja580ht-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 17 Aug 2024 01:35:26 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 47H1ZP9P025756;
	Sat, 17 Aug 2024 01:35:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 412ja580h7-1;
	Sat, 17 Aug 2024 01:35:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Finn Thain <fthain@linux-m68k.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.com>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Ondrej Zary <linux@zary.sk>,
        Michael Schmitz <schmitzmic@gmail.com>, stable@vger.kernel.org,
        Stan Johnson <userm57@yahoo.com>
Subject: Re: [PATCH 00/11] NCR5380: Bug fixes and other improvements
Date: Fri, 16 Aug 2024 21:34:48 -0400
Message-ID: <172385819634.3430749.6349002426440536098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <cover.1723001788.git.fthain@linux-m68k.org>
References: <cover.1723001788.git.fthain@linux-m68k.org>
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
 definitions=2024-08-16_18,2024-08-16_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=742
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2407110000 definitions=main-2408170009
X-Proofpoint-GUID: 89JdnTe8Igx9IOBdwmUY7bkeQBvCvo6J
X-Proofpoint-ORIG-GUID: 89JdnTe8Igx9IOBdwmUY7bkeQBvCvo6J

On Wed, 07 Aug 2024 13:36:28 +1000, Finn Thain wrote:

> This series begins with some work on the mac_scsi driver to improve
> compatibility with SCSI2SD v5 devices. Better error handling is needed
> there because the PDMA hardware does not tolerate the write latency spikes
> which SD cards can produce.
> 
> A bug is fixed in the 5380 core driver so that scatter/gather can be
> enabled in mac_scsi.
> 
> [...]

Applied to 6.12/scsi-queue, thanks!

[01/11] scsi: mac_scsi: Revise printk(KERN_DEBUG ...) messages
        https://git.kernel.org/mkp/scsi/c/5ec4f820cb97
[02/11] scsi: mac_scsi: Refactor polling loop
        https://git.kernel.org/mkp/scsi/c/5545c3165cbc
[03/11] scsi: mac_scsi: Disallow bus errors during PDMA send
        https://git.kernel.org/mkp/scsi/c/5551bc30e4a6
[04/11] scsi: NCR5380: Check for phase match during PDMA fixup
        https://git.kernel.org/mkp/scsi/c/5768718da941
[05/11] scsi: mac_scsi: Enable scatter/gather by default
        https://git.kernel.org/mkp/scsi/c/2ac6d29716cd
[06/11] scsi: NCR5380: Initialize buffer for MSG IN and STATUS transfers
        https://git.kernel.org/mkp/scsi/c/1c71065df2df
[07/11] scsi: NCR5380: Handle BSY signal loss during information transfer phases
        https://git.kernel.org/mkp/scsi/c/086c4802cf99
[08/11] scsi: NCR5380: Drop redundant member from struct NCR5380_cmd
        https://git.kernel.org/mkp/scsi/c/476f8c82e218
[09/11] scsi: NCR5380: Remove redundant result calculation from NCR5380_transfer_pio()
        https://git.kernel.org/mkp/scsi/c/8663cadefd15
[10/11] scsi: NCR5380: Remove obsolete comment
        https://git.kernel.org/mkp/scsi/c/c331df3d4a8d
[11/11] scsi: NCR5380: Clean up indentation
        https://git.kernel.org/mkp/scsi/c/a8ebca904f8e

-- 
Martin K. Petersen	Oracle Linux Engineering
