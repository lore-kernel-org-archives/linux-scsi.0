Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E7A15382E
	for <linux-scsi@vger.kernel.org>; Tue,  3 Jun 2025 02:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748918183; cv=none; b=VADJ7gXpNRnOx/vH4Nwk0FttEvfgI4dD8B/ZWl6wwlgQ3iqGaVwiWuyr8fHer1FaxqHOdzMN+iZuDY2loJOJkGMlFbmhdBRCdVRPkn3NTOESMWt7HYLKoqxzkl4f8wBD6rWLKmOwXniUxQ1Hmggp/N0wUUX62/O9SaX1ll+S5bg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748918183; c=relaxed/simple;
	bh=RyvzYcnUedSOz7+96O+iI/w+5tTvRxkzKtU2fshogV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aDmjRBBl819yKZxRRG3PGfBjc7Lm6HaCp65fGS1qVMtoRaV1q8XtqUYS7IPAwuhdzTZPkIvUs2Ky+1INvQx+c8u7J1jxSHN0/nfPQHq/s4l4Uh7UcyqNRCwvGc6/2vF73MUQ0NaLHeTcGq72rf6xvwzDKrTWrrpnqSasLzZRqPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=KEpAtxMm; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="KEpAtxMm"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552LN0c9010942;
	Tue, 3 Jun 2025 02:36:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=I572RuGzXCoaFsymVRlg30K0JvF8aLYmsUhWCfwnhrw=; b=
	KEpAtxMm8RPfcxPzKdpM/NLcgrPkHtlaGqif8icz9rGN/rq6u2XdzjSIZfy2JY9z
	C0+ervDWdjARkWS305nbHvZXpkxDirqyYOEyX/225UtvItz3GNNgXGQwSuS0rDjy
	BMJn8HVxPYnzeuOxgNmDcA2TlVxamcoApYypnpH5AndnQi71MDD7EJHHepZ+FrsR
	CuPnMdo9njeMtL9B1s+fjPh32AoKtJY8EgDj4sONZrBkdVJkSd+XNNIjvKgMvwyu
	q6gZnVuxIiazJxTsriOIgDJxPtZS3Nso/hzalHonpbufwDfdIhyY68HNDgCNet3e
	xbCR6j2OFPmoqqKpyYMAzg==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8bgw2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 02:36:17 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 55324cUV030620;
	Tue, 3 Jun 2025 02:36:15 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78qkea-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 02:36:15 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5532aEkD008766;
	Tue, 3 Jun 2025 02:36:15 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46yr78qkdh-3;
	Tue, 03 Jun 2025 02:36:15 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tom.White@microchip.com, sagar.biradar@microchip.com
Subject: Re: [PATCH] aacraid: remove useless code
Date: Mon,  2 Jun 2025 22:35:49 -0400
Message-ID: <174889162401.672400.7484413237421345960.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250521165148.8856-1-thenzl@redhat.com>
References: <20250521165148.8856-1-thenzl@redhat.com>
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
 definitions=2025-06-02_08,2025-06-02_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=628
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDAyMSBTYWx0ZWRfXw5raTzqxnWCE hWdDtHgJkW55+NLCr8SuRk1p9VKLQ8lIeT1eo+RRUZR0bkpsTVJlXHlOHoeH4IFpo3FLZKHSrhq SNuPvsDNQ62uzfnFKbm4qQJkkkObusf5W9WJefyg2ruvjNf8CQWjoYNb8/1W+TNxj17EveaBJmR
 f+ju59mNlJVS/9O8HBOSs7nVi5tfcQpycib+4sCavv835cQvvPnoa6FfAiO4A71v/RHXn/5Jb2I pKWyFT0b+9pnPnkigkdkfdBwC5CkFYA3l7I7vLemlywcQfM7cDIKlbKT1Or9J/g82HL8skbdS0I jCCkZAP6OGrNC/x7EuP4t+NkCx/JHKqffiH1Rdyz4Uty4+Bz5AVhcQNWEUktVBuGF4x2OtlNnGV
 yo94lruJEsWZmK9rmDxWtozQhpV42Uq89qh3FjZtlmn04XLSHRjDsonpb03qY1gtmANvSUqc
X-Proofpoint-GUID: qPZMh3pVmfapcCGUF65C1AoA_umAuBT-
X-Proofpoint-ORIG-GUID: qPZMh3pVmfapcCGUF65C1AoA_umAuBT-
X-Authority-Analysis: v=2.4 cv=H+Dbw/Yi c=1 sm=1 tr=0 ts=683e5fa1 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=YzHY8fJFG7DqmIwvmjoA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714

On Wed, 21 May 2025 18:51:48 +0200, Tomas Henzl wrote:

> There isn't a AAC_MIN_NATIVE_SIZE defined so
> remove eight useless lines.
> When at it remove also an unused #define
> 
> No functional change.
> 
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] aacraid: remove useless code
      https://git.kernel.org/mkp/scsi/c/0ae992637cf7

-- 
Martin K. Petersen	Oracle Linux Engineering
