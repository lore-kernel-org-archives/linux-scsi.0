Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7102A1CD21C;
	Wed, 28 May 2025 02:21:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748398878; cv=none; b=irwg7w2iJpFaTGeuSbLeDIfnCMXVPRRA628gVNddKEbXUS5XgsP+5+M8h7ljMhw/fprAsbirv+Bf1vresEtg52VGcghQr12QFebjxtEKN/EMjKiPjzWjxXLFMseurRDuX9LZUlQUhUafe+JJFGcRzZTHzkUpMj9Z69qgbkijNWo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748398878; c=relaxed/simple;
	bh=5I/TEPawiSZDku2Ey8XJmG+G/QnQu2ve2EN4E058V8w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m9WxgrR5H0sQDlLootuUlivpf+Y9jqd6So5G54xqncQr9xNq4XVKutE1oBcWA05dpzMs73c+s9IHNlJ4I0F0q2I9denW0qIiGH/PJrIwGKhaSm7+toqwWEoL6cFOad3GFrX4o+rEj1WtdBFZsi63H2u3hTiBR5qs0Oww7xq7gLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=QS4uLtcO; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="QS4uLtcO"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 54S1g2xd010773;
	Wed, 28 May 2025 02:20:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=04vV7ETGxRQRu3lbl7jrA2zMPlU3f8CteLHTTAqlYfk=; b=
	QS4uLtcOR4OVI2kU77By0xLW5vVJ/1iMppf5dmB/OljHWbYMsTisl2UUtD1y+Aps
	rvmn2WaHrY0WClDW5zjPBsSR95aFOMjIuSlava6i3Uv6TZ8WtHRkCgYvW8LhcrCQ
	1QrPRPmY907DNQZhwFE6NyKefrFe2HN7v7iCcU+A3JgThXca5tRsi0KyF+M7NEx7
	ct7ooNk+ZC+0NqaMnJfZ6Vn5AxcksMGDadreNSSOkeu6fJIeB1BVKHUAe0IeWx/y
	rSuVjR83X3LjUp/mn8ZC/pQqJdu7ZYLgeoFA0v/hWIjjobT6SUGu8iJxyg4+r+IC
	e+nQVYt0WSi9iJ2j41mPtw==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 46v3pd4qc2-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:56 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 54S2D8Hx021345;
	Wed, 28 May 2025 02:20:55 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 46u4jgb22j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 28 May 2025 02:20:55 +0000
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 54S2Kq1C017834;
	Wed, 28 May 2025 02:20:54 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 46u4jgb21n-7;
	Wed, 28 May 2025 02:20:54 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: alim.akhtar@samsung.com, avri.altman@wdc.com, bvanassche@acm.org,
        James.Bottomley@HansenPartnership.com, peter.wang@mediatek.com,
        minwoo.im@samsung.com, manivannan.sadhasivam@linaro.org,
        chenyuan0y@gmail.com, cw9316.lee@samsung.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        "ping.gao" <ping.gao@samsung.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
Date: Tue, 27 May 2025 22:20:21 -0400
Message-ID: <174839736811.456135.18140593406218357928.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250516083812.3894396-1-ping.gao@samsung.com>
References: <CGME20250516083723epcas5p216a21ffb81631d35f0a12f7a583ea248@epcas5p2.samsung.com> <20250516083812.3894396-1-ping.gao@samsung.com>
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
 definitions=2025-05-28_01,2025-05-27_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 phishscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=838 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2505160000
 definitions=main-2505280019
X-Proofpoint-ORIG-GUID: ScLseRK3_Gu0QJtCQHprgQ11Zehu7LOD
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNTI4MDAxOSBTYWx0ZWRfXwJGdT9vAS9gw 2FnEW580JeC6BxV9w/XCtClFRJQFwU9vYp6V9LcJJMtpVwSE8nIuoSNX+2GPH8dovA0Kuosfsib FldBqpuZTWpGnjXWsiot37UW4CuvTzWdOFR/4fcCu0NudWwLqzgBFJ2aYxPIrkOMic4EOLdgOXV
 PMtTlJ8m+f8hp8FNOf73V7XUT8Sx2Jwb8XWtlfHKgqrgL1EhgM5vBPmPmrlus3C+CXErBrmlQto 3HkRVS80dyeZGmmywGyUbnf4JiLpY7LScXGWTMDOAmX46KzUuILXYp1+I1XTdhu0mreyg/JJgvg iAhy1MRkYH+I9+TRZt9EpCLsNJNuuuqc72VxhUZET/u/+bkZJGdTdYvjZk34s1AiShoaLWju1ks
 T4BI6cdqzoe1OfEFm8J+FM9xfxTpUU5s/EhTAFI+XgDPTmzY4kShs2jewBuM0Qgx+dpPUV+d
X-Authority-Analysis: v=2.4 cv=UZNRSLSN c=1 sm=1 tr=0 ts=68367308 b=1 cx=c_pps a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17 a=IkcTkHD0fZMA:10 a=dt9VzEwgFbYA:10 a=VwQbUJbxAAAA:8 a=EKYD-hqyz3SA5wV0YVEA:9 a=QEXdDO2ut3YA:10 cc=ntf
 awl=host:13207
X-Proofpoint-GUID: ScLseRK3_Gu0QJtCQHprgQ11Zehu7LOD

On Fri, 16 May 2025 16:38:12 +0800, ping.gao wrote:

> after ufs UFS_ABORT_TASK process successfully , host will generate
> mcq irq for abort tag with response OCS_ABORTED
> ufshcd_compl_one_cqe ->
>     ufshcd_release_scsi_cmd
> 
> But in ufshcd_mcq_abort already do ufshcd_release_scsi_cmd, this means
>  __ufshcd_release will be done twice.
> 
> [...]

Applied to 6.16/scsi-queue, thanks!

[1/1] scsi: ufs: mcq: delete ufshcd_release_scsi_cmd in ufshcd_mcq_abort
      https://git.kernel.org/mkp/scsi/c/53755903b935

-- 
Martin K. Petersen	Oracle Linux Engineering
