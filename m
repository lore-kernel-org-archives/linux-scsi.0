Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A55F4500E;
	Tue, 10 Dec 2024 02:36:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733798187; cv=none; b=gPJkzn5qVpKLzQTeoIUyt1Fkwy6Ch/Hovvnc6XhCICtT+2P8qWKjPFqmpBHUwjpff3DTIBRHABfWb9K9Py6arIFXH4HhTU2U6tL1WMp1oC75/GwGMAMOVMczThLuscYSszZO0ZrNFPZvueqN18GZil1chJwXxHqRMUm6LbkRllI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733798187; c=relaxed/simple;
	bh=1RmWznWTbYjWpcPRz+TUmfbOVQ+sO6c/l9ACKGnjeNo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mn06fgpYMcSwMmbABEZ4V67Eajo22vx0U/hQn/BrxzVOQ8rgcHaW7rLCEDcJY/Cg+qVZt/W6ZqeWZLMrT4yza74cSFv95M5GFJl3kOE2AlwRm31sADr2A7nnOQq8c1hWXTbZfSL/R3kqLt1hQTxZHG7xdENoxYYwg6j43U3lIOU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=VmY1QxJG; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="VmY1QxJG"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4BA1CB7E025117;
	Tue, 10 Dec 2024 02:36:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=R4wkjc2caeYCzNvS+orrf/i3MBNT+E7ItFpc8sFUD8I=; b=
	VmY1QxJGNXaPDLSU43ganEDHmBxNEkkeAkvR/uXw7G2nl+NxV+Mgf+S27t59m2cg
	mGtaRcA6PN7S7v6v1Y3UBv3gBe8+6OAKYlzQy+t40SICCUFxmV4KOXOgFK+EwIi1
	7sqActGpojqWuUBxgZZuIcSvdILOtxfc7SbXESAkaCtV+4YzlWFmNQQauDgE7d1K
	V4eHe79d2jCXB/DvPN0Hwqk4w/3aZa9rEYoxTAK9r/qtF4KKD0f1mksL5tBF0aqY
	Zx2U8olUH4/EsT9coC5eg2gm4c7NEV/IqJzK7fe2/0ki2t0/9bfpL8xXq6uCTmU2
	serX+2LiWPJaLFKywOrWPQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 43cewt4qfa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:21 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4B9NvlK4035825;
	Tue, 10 Dec 2024 02:36:20 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 43cctf7y7f-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 10 Dec 2024 02:36:20 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4BA2aIup010256;
	Tue, 10 Dec 2024 02:36:19 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 43cctf7y6u-4;
	Tue, 10 Dec 2024 02:36:19 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Jack Wang <jinpu.wang@cloud.ionos.com>,
        "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
        Salomon Dushimirimana <salomondush@google.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Vishakha Channapattan <vishakhavc@google.com>
Subject: Re: [PATCH] scsi: pm80xx: Improve debugging for aborted commands
Date: Mon,  9 Dec 2024 21:35:35 -0500
Message-ID: <173379777413.2787035.3179531849378586999.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241126225546.975441-1-salomondush@google.com>
References: <20241126225546.975441-1-salomondush@google.com>
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
 definitions=2024-12-09_22,2024-12-09_05,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=597 adultscore=0
 phishscore=0 malwarescore=0 suspectscore=0 spamscore=0 mlxscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2412100017
X-Proofpoint-ORIG-GUID: jjyHfn-NkDMG3epxGBdrOJLKeugkDLfD
X-Proofpoint-GUID: jjyHfn-NkDMG3epxGBdrOJLKeugkDLfD

On Tue, 26 Nov 2024 22:55:46 +0000, Salomon Dushimirimana wrote:

> This patch improves the debugging capabilities of the driver by adding
> more context to debug messages
> 
> 1. Introduces a new function to show pending commands
> 2. Include the tag number in NCQ EH path debug messages
> 3. Adds logging for ata_tag along with pm80xx tag to map IOs aborted
>    with ata logs.
> 
> [...]

Applied to 6.14/scsi-queue, thanks!

[1/1] scsi: pm80xx: Improve debugging for aborted commands
      https://git.kernel.org/mkp/scsi/c/5efff64c6be9

-- 
Martin K. Petersen	Oracle Linux Engineering
