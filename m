Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7994246333;
	Thu, 13 Nov 2025 02:47:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763002043; cv=none; b=Wlr5qzeLCvTZuxt7E7SyuRTLxFYkofZ8T3VKsmoYWK2sb8LX0fn/6ixybBJYR89raYBBPqp/o/uVUKPCbkL1Cdfrpp0gdbPFoegmFbX4rRBWY+4mOYfjxeMcH0p3JvK8dMSWcbuE5unRRhGchvdyaCfbPj47Wwq79qhORC7CfX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763002043; c=relaxed/simple;
	bh=7TG16jts3HrD1hpIz+SdCBGZsmsniurVExjce6yyTVM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r5eO/yrIDtq3zxtLiPkCyokohenPkF9R94x+syya3+gmLW5jlOAtYb+/FNtTBK6Mo7NTabUtho0XkaQnjDRMBD/FZ+qSkC+xVE11QTzFDUdg3n5K+Zeo0eU8R5D1wtqagTgoSh3ZtQYGAYqphGKfLwarEypy7Pn3rFItsVwt8Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=BHECX7KE; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="BHECX7KE"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1gejG023286;
	Thu, 13 Nov 2025 02:47:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=fTE2ui0ZWFw+GHvsee6pfdSEQ86xGOf84pLW2R1Onxw=; b=
	BHECX7KEYYjDljiFL72b11PzgL3sVOmUNDzQSfrFiYIAw4guFav7R8hCpDuJ4h7S
	2wa0xCWJnZkltV8e2CMJnPknjFW1xUmC0Ur7vMZfChLRDmIs475EmPVpgXFVw6Lg
	c65EwiMrJpR+aB1dJ1I8mC2gOY665tbAjlnFUc2L470/XG4nwueVCYKBCEMS5lNc
	tAjT8vvnLwIWMqSUqVNcAAo1gcqMbKQ94tcB0C3vCAdN9i0dhwwAAEc/6T9kufsm
	+87DI+pdVEPohlu6No1EsteIsUN/j9K9cMM5Bal2XhyqA0O+6U0zH/maLcLdJP88
	bgqn129aaJ64rc6crZcpEg==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acybqrscn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0OLjN032518;
	Thu, 13 Nov 2025 02:47:13 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9van9qbv-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 02:47:13 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AD2lB8L038323;
	Thu, 13 Nov 2025 02:47:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4a9van9qab-5;
	Thu, 13 Nov 2025 02:47:12 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Damien Le Moal <dlemoal@kernel.org>, Niklas Cassel <cassel@kernel.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Markus Probst <markus.probst@posteo.de>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 0/3] Support power resources defined in acpi on ata
Date: Wed, 12 Nov 2025 21:46:54 -0500
Message-ID: <176298170747.2933492.1138307568642008557.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251104142413.322347-1-markus.probst@posteo.de>
References: <20251104142413.322347-1-markus.probst@posteo.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 mlxscore=0
 phishscore=0 mlxlogscore=837 spamscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511130017
X-Proofpoint-GUID: tCSgM7zqdqWUM03A24EvGtKiBepTVcVQ
X-Proofpoint-ORIG-GUID: tCSgM7zqdqWUM03A24EvGtKiBepTVcVQ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0NyBTYWx0ZWRfXyp4CJlRJ51Yi
 3W4MaNr/8JWPc+/bvvapYG+/Z49NZuq1t4V6P9kK0Gil5nk+EJWtz7URGY2MmGJ+Q16X4HqHLv7
 hNFDS/LuegVHU+t9u/lvH3Oz7r9/UlKOtXqBAmnTv7QGUQIOwGUhjYPyzqTtowk1dRBP3Ftr8fb
 wagf5/5cggvjKdupe4/zb+dfmCWrtG4YapPBYaHyT/F72f3DD925tkOqaWUoGZwkzZga3hya6bZ
 38d1gBRnsFv85CWSl8W+CT6EWjKicV3MRHNpMtdePQ/l0ttO10oJouN+1+14ZUpeA11ITj9aveS
 Tl9KvzmtxROZXuVDwHldCYb2RLct0AYm3NjylRUb+MC+c2vXA0uufdOIxHalJCeIf/RnRk2A+sv
 ceGJms4m6Sz1FCifKs3lLSUQUX0sDy4GTq52ceR4nZAkH0PtTe4=
X-Authority-Analysis: v=2.4 cv=X7hf6WTe c=1 sm=1 tr=0 ts=691546b1 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=KwMgZv5xIcckdayViMQA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12100

On Tue, 04 Nov 2025 14:24:31 +0000, Markus Probst wrote:

> This series adds support for power resources defined in acpi on ata
> ports/devices. A device can define a power resource in an ata port/device,
> which then gets powered on right before the port is probed. This can be
> useful for devices, which have sata power connectors that are:
>   a: powered down by default
>   b: can be individually powered on
> like in some synology nas devices. If thats the case it will be assumed,
> that the power resource won't survive reboots and therefore the disk will
> be stopped.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/3] scsi: sd: Add manage_restart device attribute to scsi_disk
      https://git.kernel.org/mkp/scsi/c/8fdfdb148816
[2/3] ata: Use ACPI methods to power on disks
      https://git.kernel.org/mkp/scsi/c/ce6d26b5330c
[3/3] ata: stop disk on restart if ACPI power resources are found
      https://git.kernel.org/mkp/scsi/c/8c59fc1c90df

-- 
Martin K. Petersen
