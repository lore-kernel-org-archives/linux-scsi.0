Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DBF5330B11
	for <linux-scsi@vger.kernel.org>; Sat, 23 May 2026 03:15:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779506122; cv=none; b=tes+8f/0iEMthSqYyc2g6axF/yjNjMyiUG7DcYBf0AqX8VJynPWm4pyJulR/GpzgplUcGUuOFSEpagJdDQpaVQv5eBfEJLZE5w/f8pTCZlPaCd85Z8e1UiOxKrjar+iOC3fdSB8U5286oT239MOy6ZBfTiO6xeTASEMpNRdtc+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779506122; c=relaxed/simple;
	bh=8JB3qnICV+YvBygFnt7xOmhmUeMJ5agmHWOROFopX/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EROG8VbB2LLiTcR4tbpheMDASrETZ+gf+OB+UOl3JELSCTq11EefU7248R749ScUDYIs7hmb0QIQLEMn/+4nfFOcnVkbYFDtLCp0G6YEnbGfdwWwCsNs1p1rMBN62qmquAelDjlRG9c27eru1W2skS/FkD5Mkf59VwZMV9U+I/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SgwAX8V0; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SgwAX8V0"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64N3BcnI1942559;
	Sat, 23 May 2026 03:15:13 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=cvO5gS43VbZ4/TfCzYsTHdN8ND1TUp8vPuYSEbqSRjk=; b=
	SgwAX8V0F3ogHuqLSZhw074od2dyPiyUTQMPpohVHqQusTU+rWVk2MwiQMBJqPIU
	MiXYmU1NxcX3qRgSU7+B2AC8RtFtNnjMHzLq3UFuJtSXSCZ3AblOFey41q8CKHcg
	3Z/AU88f8Ium+GkdNA+AaCaifawMZdSMw6Xzqj/qpNJKeD5GefDLeRmWQqG9PtsO
	XaKh57mVkYfXDjEr2ZJZ1Ibi7FurrSuPuTY0op+1b3wcvoYKAvwj8CL+3X+jpAN9
	RCDmQ/JSqSQIYlaxH+7kEdCNfmXz0XgRrtzXdXUnu/9Y9Sm9NRISHtYByf/D+e3W
	9pyi1Ms18QwPdRgpTnvM0Q==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4eb447g05e-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:13 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 64N3F7SR032484;
	Sat, 23 May 2026 03:15:12 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4eb2p6hsdb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 23 May 2026 03:15:12 +0000 (GMT)
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 64N3F9dw032824;
	Sat, 23 May 2026 03:15:12 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4eb2p6hs6k-3;
	Sat, 23 May 2026 03:15:11 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: avri.altman@wdc.com, bvanassche@acm.org, beanhuo@micron.com,
        peter.wang@mediatek.com, mani@kernel.org,
        Can Guo <can.guo@oss.qualcomm.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] scsi: ufs: Add persistent TX Equalization settings support
Date: Fri, 22 May 2026 23:14:17 -0400
Message-ID: <177913641758.1181900.18191875593794268088.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
References: <20260424151420.111675-1-can.guo@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-05-23_01,2026-05-18_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0
 suspectscore=0 malwarescore=0 spamscore=0 phishscore=0 lowpriorityscore=0
 mlxlogscore=909 bulkscore=0 mlxscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2605130000 definitions=main-2605230029
X-Authority-Analysis: v=2.4 cv=Ecn4hvmC c=1 sm=1 tr=0 ts=6a111bc1 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=EUspDBNiAAAA:8 a=2KOae6bPlC11d1FYIIIA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-ORIG-GUID: y4VzHBfR-NH7pSGNrZ3yT7LpokhJib33
X-Proofpoint-GUID: y4VzHBfR-NH7pSGNrZ3yT7LpokhJib33
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIzMDAyOCBTYWx0ZWRfXzpjuLa6NaG0n
 8MzN2cUflio9sXzTy1Oc7TuJt/IBhUn9ZBdNAEm3vJz2zahp488MWcz/y7NY2QKa0xtfvxBylE3
 HidQTsVoxAIy5cokpO2lASL4M843fFSRo6/Wi5Kby4YaN1EVQeNh6t6o9DqxhbrYesLCBxBLEFy
 gpa665gzqWcCZSTT8noWRncPOo5ScJ0+a0nwVJL5WDPMkal3ZiO1uMthl9q1aRGkApJ6P75BtCs
 1y7r+kuTr/Pa2UeVm+oUrNi18XHCAHBJxw7gTgA6cNa8th8DvGOrS0Tu2DZEVK3NKfyk7zE/EDE
 SwxggEwBfuI1rEmHvYKrPRRcttN6S1KTyLwsg6l9HUxUKsX/lAu0jGFF5FkDjBT11sKEDijTyQL
 YUH+aEZUjdHQTXQo/ZVsTtHWBa+724zV0FcsyoJAnIU4a/IrkHfuhBprGc6hBd/ysZpie+ArND3
 hIsutNtEVfUAwYACIFg==

On Fri, 24 Apr 2026 08:14:18 -0700, Can Guo wrote:

> This series is a follow-up to the earlier TX Equalization enablement series:
> 
> https://lore.kernel.org/all/20260325152154.1604082-1-can.guo@oss.qualcomm.com
> 
> In that cover letter, the "Next" section mentioned adding support for
> UFS v5.0 Attributes qTxEQGnSettings and wTxEQGnSettingsExt, and enabling
> persistent storage/retrieval of optimal TX Equalization settings. This
> 2-patch series implements that part.
> 
> [...]

Applied to 7.2/scsi-queue, thanks!

[1/2] scsi: ufs: core: Introduce function ufshcd_query_attr_qword()
      https://git.kernel.org/mkp/scsi/c/f2cb7c01f48c
[2/2] scsi: ufs: core: Add support to retrieve and store TX Equalization settings
      https://git.kernel.org/mkp/scsi/c/949af038b6d2

-- 
Martin K. Petersen
