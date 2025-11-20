Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C27C311C3C;
	Thu, 20 Nov 2025 04:16:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763612219; cv=none; b=PAEVvoMQzawQ92l0AGj8oDjFg+P/Fve8F2mBaxnIQUpRLH2ep0F4Hq3f033oB26D0R3VTevgG+jTgjV1NhDQfW07/IoJPvj4NCw3+7V8QHEwby0D2URuDYOM9G1LdYy6JN9du5cWUaFBY++vOFHv78eGj67Cr4SUSV/F0jPYjlc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763612219; c=relaxed/simple;
	bh=MQiDDcfv7kFnlZHptfbOIuJSE8hkf/Xocu4oNMCIRlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uMoOsBZw4uPK02xZ5p7e27jwRZmfqtNVhSKSJHNzD++VgpU1LNUVWw6LME5STYSO+xWJEQaTVvCWYz0UC59sddWJr5Yllr8BEjjNk9BkgIR/wXXG7DxJpwH3nyun3UB0ZHRStLYiCXzrOFG4Ovuo77rN7K2aKkfBYB1ZYKxxpu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=G4AhXmPp; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="G4AhXmPp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK2gjdg011005;
	Thu, 20 Nov 2025 04:16:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=XdLHOsFStG7ehpiMmGwlYG8Mv8yI4tLxek0ion3Y9wg=; b=
	G4AhXmPpBZc+8DHxrFV9CA5U2wOUDEihknFVN+pY3iEleQ1YDn8ggIxcXRnILrHa
	47mwb06bjMU0sNcNFrLcZ2Hlw8LozFhBeJMhk1ULX+Ng+vsBV4lxDNCtRBoxM16H
	v8t9MtTTfthVrCmvSWzs7dJqKV1KXDV3SZfkHbMVLdm7MR6ZdwwTWvy+Svcsw6Vp
	sCSnJJwbZwEPm7Nehb0CKKFpWanmYhCm0Lgw/2w5Fq9OTCe8suUQHFpS5h4vf+oE
	ggahUMIaC38XXTQ5fl+UKrthpXMX8lAwavL6+3hk2I66dme8R//py6/+rppegak3
	elnFBR35FZ8LXgMZ0Q1npA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aej968bhr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AK49KuA007571;
	Thu, 20 Nov 2025 04:16:26 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aefybh4ak-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 20 Nov 2025 04:16:26 +0000
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5AK4GKPb012546;
	Thu, 20 Nov 2025 04:16:25 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 4aefybh471-6;
	Thu, 20 Nov 2025 04:16:25 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        Marco Crivellari <marco.crivellari@suse.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
        Frederic Weisbecker <frederic@kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Michal Hocko <mhocko@suse.com>, Chris Boot <bootc@bootc.net>
Subject: Re: [PATCH] sbp-target: replace use of system_unbound_wq with system_dfl_wq
Date: Wed, 19 Nov 2025 23:15:55 -0500
Message-ID: <176357169041.3229299.6466569342326852297.b4-ty@oracle.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251104104518.102130-1-marco.crivellari@suse.com>
References: <20251104104518.102130-1-marco.crivellari@suse.com>
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
 definitions=2025-11-20_01,2025-11-18_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 adultscore=0 mlxlogscore=920 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511200020
X-Authority-Analysis: v=2.4 cv=DYoaa/tW c=1 sm=1 tr=0 ts=691e961a cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=IkcTkHD0fZMA:10 a=6UeiqGixMTsA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=VwQbUJbxAAAA:8 a=_suGTTe_43wmAZudwJ8A:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: ET1nn_KGmia4Y-OHkCz-EUD6OXUq6W_F
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTE1MDAzMSBTYWx0ZWRfXy1uk4Sibtfji
 FqHl5hfQyE79BHYg+jSLEA6yCNNwEFShC3f+uif1R/OTJyCrgoEB1xZGu6PlAcFqMwcqJtAcDJi
 xV630nKEnUtPW5lLYkE9E2Savv1K7S1VLc9L5+4zvWgbrbPcQH4MiY5HL6IDDCTJsg0j49pfIug
 2ZU+FAWe9m4qF2cZCp9xyXsGgR6OlWbCUspKEtpUBA7WReGfQGelT2W9Tlb4rhDlk9V6YEMHLX+
 MlVQgPEpNsPgTwk6Mngn5fVsTYJyf956hbvHOtdzn+QASPDmj7oTJtm1pojFkiqrML0Sqz9d04p
 vta+N+RybjbiMvu992wcwdfyrF5WbuYSloxLTt1HeZadveqskgI/PDXBEG6y88ond9Nuvs3Q/ZC
 mWvsX2u09vTt4BJCV6/0nWuyschX5Q==
X-Proofpoint-ORIG-GUID: ET1nn_KGmia4Y-OHkCz-EUD6OXUq6W_F

On Tue, 04 Nov 2025 11:45:18 +0100, Marco Crivellari wrote:

> Currently if a user enqueue a work item using schedule_delayed_work() the
> used wq is "system_wq" (per-cpu wq) while queue_delayed_work() use
> WORK_CPU_UNBOUND (used when a cpu is not specified). The same applies to
> schedule_work() that is using system_wq and queue_work(), that makes use
> again of WORK_CPU_UNBOUND.
> 
> This lack of consistentcy cannot be addressed without refactoring the API.
> 
> [...]

Applied to 6.19/scsi-queue, thanks!

[1/1] sbp-target: replace use of system_unbound_wq with system_dfl_wq
      https://git.kernel.org/mkp/scsi/c/0ba2fc767af7

-- 
Martin K. Petersen
