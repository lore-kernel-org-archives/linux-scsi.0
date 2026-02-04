Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE82328B7DB
	for <linux-scsi@vger.kernel.org>; Wed,  4 Feb 2026 03:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770177176; cv=none; b=tG+NbXMzB655vim7CUhNxtD0HkK6UHMypowKByYKn3d/g9CIIMH6PPHR2xnoSDdLubeDJ3ChzTflVadk+qS1I6eqnfkQo9V2WtumQ1FFVDzmFaBySGoPlqHFpgKOI1RzwZsw3oe3hUKE7Gj76CTZUHp6Ryfk/8B8mvuxVSOYTYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770177176; c=relaxed/simple;
	bh=1icDyqPwbbHqNvfgBvAczi/5pv8lF+2w86Op0tjfJ4E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZsAck4QXnqN4jTg9Yn+3onJypO0h0Lmh0RuU3p976g819mAJdackDs1Kw91hbTbTEtNzk/zEPP7QuFDWjOC3MZyqcmk48wTbkFie62ORYHOw2kSUBhnWO4JrbvdzU+OlHuZSL/ZeywQunMst6nlr3CGcB3+ygCZ0yUmxVU4Qv1Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HS7kExs4; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HS7kExs4"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 613IuJAP4161566;
	Wed, 4 Feb 2026 03:52:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=8NEJ+YgZWU8i5yzE5g0Sdo8KNbVJ2t5OAgdmvg9aJJ4=; b=
	HS7kExs4JYfR+/ZbojGIojOTlT44F8eHy0UfH133xGcgs8gQw9074wQupgTxo3Z4
	XZF4cFdj3nIF7X7UaeBL9xirrZnSuZnTVXcoJImo3+b6/QVAz06PWT0/MR+aIm3G
	oZYCApH9INoJ9ccZozOCh7y0Lcb/1SewAI8si/V6HSayGzsDCo8vs2OG4TO5/Hxe
	e/v9+8muDoqMvng+y9P1ws6L5H3XpRj666m1PA/PoDuDsFT2P1IVn/JWnyYlKA0i
	cMxJLR28WXfp96tJCp4dyHQ4YD+ESOIZDAYLiyWhFjHX9NvOVMK2Ts7d3WLINHDU
	eGbC3SpvrX+jQ0vCgfxC/w==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4c3j8uh6d1-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:50 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61414KKT018713;
	Wed, 4 Feb 2026 03:52:49 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4c186nd330-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 04 Feb 2026 03:52:49 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 6143qllt024698;
	Wed, 4 Feb 2026 03:52:48 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4c186nd32a-4;
	Wed, 04 Feb 2026 03:52:48 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-scsi@vger.kernel.org, Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        chandrakanth.patil@broadcom.com, prayas.patel@broadcom.com,
        salomondush@google.com
Subject: Re: [PATCH v2 0/8] mpi3mr: Enhancements for mpi3mr
Date: Tue,  3 Feb 2026 22:52:43 -0500
Message-ID: <177000116191.3467927.15486886375351802104.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
References: <20260116060719.32937-1-ranjan.kumar@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-03_07,2026-02-03_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 suspectscore=0 mlxlogscore=965 adultscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2601150000
 definitions=main-2602040023
X-Proofpoint-GUID: 7U7nPfKvzg11Tv-6ChgdnyajWgyz9KZ3
X-Proofpoint-ORIG-GUID: 7U7nPfKvzg11Tv-6ChgdnyajWgyz9KZ3
X-Authority-Analysis: v=2.4 cv=BJS+bVQG c=1 sm=1 tr=0 ts=6982c292 b=1 cx=c_pps
 a=zPCbziy225d3KhSqZt3L1A==:117 a=zPCbziy225d3KhSqZt3L1A==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=7sb09Ph35mA_NJgvtq4A:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:12103
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjA0MDAyNCBTYWx0ZWRfX8JxZ2y8Dj6V0
 7kX3req2Tw+W87afbAQRHS7UVkGOct1OQNgoKvk1XIdfzzmaLmbqn8qpPrIcCEhPbolINYnRWRU
 YZLPJnFge4dwR6iZc1ALweUGYw38bLf4ULE9VZUVGJ+iSr9VklJ/6RLykVx3J4OKrkaf1xJgQG8
 op2HRwvW3+1XSeIlfa+5wspKABmEg2U2y33cMJP4Yc9GWYo0MqSAjfcYAi/WK2SQCbvIUQqmner
 S6ZY+OB4BU+Azyxk6LO4rIVou6AKx1m8hU3N2HK7PLLtBBoFkqDf8IOQ3Gnp01MZax68mNH4ClN
 kPDZEap6FaN6s8tCijvIxUeTJ7TDzKch5iakQm/yG/yAeagfs/O+JHnEHZ84FyunYEwyovqC4Gm
 uTpXCZ3F1x9kXO7qZ41e1F4Qxv4ABCmQggO9SXpTF2P1C+tadwM2LZfAlUBdNXWsqUPhhQZnKRY
 /rdvhiacTBVmrRo+gjjFBgElZdm+kNBeSMym5DDk=

On Fri, 16 Jan 2026 11:37:11 +0530, Ranjan Kumar wrote:

> Enhancements for mpi3mr driver
> 
> Changes since v1:
> - Fixed test robot build warning
> - Fixed W=1 warning
> - Addressed review comments from Damien Le Moal
> 
> [...]

Applied to 6.20/scsi-queue, thanks!

[1/8] mpi3mr: Add module parameter to control threaded IRQ polling
      https://git.kernel.org/mkp/scsi/c/24de8b1d243b
[2/8] mpi3mr: Rename log data save helper to reflect threaded/BH context
      https://git.kernel.org/mkp/scsi/c/d0d19250ed81
[3/8] mpi3mr: Avoid redundant diag-fault resets
      https://git.kernel.org/mkp/scsi/c/7a67d9262288
[4/8] mpi3mr: Use negotiated link rate from DevicePage0
      https://git.kernel.org/mkp/scsi/c/c273c14b0294
[5/8] mpi3mr: Update MPI Headers to revision 39
      https://git.kernel.org/mkp/scsi/c/d0654335d900
[6/8] mpi3mr: Record and report controller firmware faults
      https://git.kernel.org/mkp/scsi/c/ec54b348f274
[7/8] mpi3mr: Fixed the W=1 compilation warning
      https://git.kernel.org/mkp/scsi/c/8612d94348f4
[8/8] mpi3mr: Driver version update to 8.17.0.3.50
      https://git.kernel.org/mkp/scsi/c/943e9049e84a

-- 
Martin K. Petersen
