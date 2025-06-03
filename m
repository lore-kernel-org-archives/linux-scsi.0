Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13BE0A944;
	Tue,  3 Jun 2025 02:36:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748918181; cv=none; b=E/Z3VFJI8ryOUc12cTNVsBTL7sxOnO0NjytdzUXWLhAU0LWvKh1r5V59Q2J959XiDbd7ByLku4Od2eB2UMlZ+jxwgH3M12e4IRk4G1c0ozC4bFwidc0SaUypLj1fbm8h3P9PmKmjjIPPuWunZm8b0e5eKNAWn8wV9s9cen4/JaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748918181; c=relaxed/simple;
	bh=PLbrIncQTZNf25SSQJU4VBhsCLcnQYITDZamoS0zpho=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Ohs0vnRl0dARSGcQLLMsawT6IT9boINuSA1ld9GwJ9bj3bKz36kdq86Z4To1onAWLZXSTsnzsYbZqVHGJyReU+edjF6ltShU3yPlWdvnnl0t7LlK3J6772gdtAQLrn+7r8LhbjHCiABnETQxvjz+JHZoFapSNeozOuec3DNzSwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ff1qe2e2; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ff1qe2e2"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 552LN0wO026935;
	Tue, 3 Jun 2025 02:36:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=D1b2SUoFaLh5N1PDzjLwDIm1J/89SDZfWxJe2iHPeRs=; b=
	ff1qe2e2v0Egb9lVmn7ssi0UOrD0v9DaghO50HqrQdU57rbLh2MaycEiHSAJ5uKH
	ZK//pLPoRgqF8wGgo6flgK+0b+OtPhpGI7pUavtfIJogyBCn2UHFJQD7QKb9xPI5
	bttxzeRzIbIzqLhMY0vU2oS1pBZWiLqNa0P5zjRZr7EwPShuFgIejn8NsELevsrK
	9DBE7hzTPL3fWXCWnrvqdnOayec0fp22eHiMCT245IzVCR13clt5CbbFDFbIND6T
	qwo4Y7bmVPTGg08GiHw5Jq3Rn0GkAoVYiQmgkh9lJAak/RRI/CzU8Fgs50LC+DU5
	y+yZlihmdStUSwxbaTGxbA==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 471g8k8wgh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 02:36:16 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 552Njsna030643;
	Tue, 3 Jun 2025 02:36:14 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46yr78qkdn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 03 Jun 2025 02:36:14 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5532aEk9008766;
	Tue, 3 Jun 2025 02:36:14 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46yr78qkdh-1;
	Tue, 03 Jun 2025 02:36:14 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: James.Bottomley@HansenPartnership.com,
        mrigendrachaubey <mrigendra.chaubey@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: scsi_devinfo: Fix typo in comment
Date: Mon,  2 Jun 2025 22:35:47 -0400
Message-ID: <174889162399.672400.9949610085993639164.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250524035516.27341-1-mrigendra.chaubey@gmail.com>
References: <20250524035516.27341-1-mrigendra.chaubey@gmail.com>
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
 suspectscore=0 phishscore=0 adultscore=0 spamscore=0 mlxlogscore=942
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2506030021
X-Proofpoint-GUID: ulkaTYvrqtZR2DOG7G0n4sLbdamI0ohX
X-Proofpoint-ORIG-GUID: ulkaTYvrqtZR2DOG7G0n4sLbdamI0ohX
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNjAzMDAyMSBTYWx0ZWRfXyDIcRI8gnVka mhP1r+R4cHJc33SCY5Zwc2KwRAo582f33BLGZ42p5cZBbX/nVk8xHa1RQ2UvduyJjoFj53O/BiR cXVGpztDyLqW4bm61QIXRMTmoe004mWKfqtCZuTqK+T+DwBylVkS5bMiS5K8CBimbPOOQ9h5Urv
 m2U0P7uJgGxHC2oVz5bj7Or1GN+pCLtfEvPz4vJjmhOfTZMrzTvTbiW0hzsQxpN7C+sE1fEsh9/ 06OqBugcOhUgu7VdFcfszsGPdpaTGdexlio8bENOMa/0Dh7qfl1Z34XK5CtSjs3NU0urRfx2xDE EV+/sFXNlVJMxoeK2S0hXPs4+cqPXHTPqJj1BLzGBpX4APmlHqT/n0zxkegv2Jz+P1MKcSljrQe
 NXlrsu/TueUMjDoHcjOFXaG0h4VF1NL6XQbDIGF2Sb/DkBMCHo6Ithgd4SA7liuuHKHSqYcr
X-Authority-Analysis: v=2.4 cv=FM4bx/os c=1 sm=1 tr=0 ts=683e5fa0 b=1 cx=c_pps a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17 a=IkcTkHD0fZMA:10 a=6IFa9wvqVegA:10 a=VwQbUJbxAAAA:8 a=5YornGoTVulL9ZZtH-MA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:14714

On Sat, 24 May 2025 09:25:16 +0530, mrigendrachaubey wrote:

> This patch corrects a minor typo in a comment within scsi_devinfo.c,
> replacing "compatibile" with the correct spelling "compatible".
> 
> 

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: scsi_devinfo: Fix typo in comment
      https://git.kernel.org/mkp/scsi/c/c8426f258a0a

-- 
Martin K. Petersen	Oracle Linux Engineering
