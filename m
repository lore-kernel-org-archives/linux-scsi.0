Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6024B393DE0;
	Wed, 29 Jul 2026 02:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293800; cv=none; b=b/2KdFjtI22yNgB8BvMOjm07PKjbU2od70260Jv4FNlH0L6uZo8LXJfTn3V07/b03hySPEwdqmwMacOSZ8/HuoC8eToZNQcpIhLDAKT6IHxGqS5GLu73gscdht2A6Aev1OU9rwV+rG0oXYGq8p+QcDWD6tvvJrYdcPhpS1xZnS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293800; c=relaxed/simple;
	bh=8DsO/OvJj5naiBCPfhRzZheqHjfq4PfOAwK80jt9WBo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=YqvP2Xm03/ZZw6pphErLLDhSUmcWxBScPnkdTMa0Jy5HRu1XCYunupKoiikOerlETt25u66728snHpQjgOAkjUx9NOoY0jLy0QGEHPIw0CSbTljwyTBk/6dvLKJ2H12c9zha+I43U0LFKYJ2zSXD4qNBORdqxTXHXpHrBfn++g4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=EPBILTY/; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EPBILTY/"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItXEw1074594;
	Wed, 29 Jul 2026 02:56:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=s+LE7KNpj96bj3jqFUu86frK/Ule6MIWr1DyGP5J/rc=; b=
	EPBILTY/UZ1vSbGCiFQtuR/Jh9FUua7+wtVDoYz8bOXGnCykJOg9hiKMPIdUkSjE
	Tt9ju3go3hMec/uuMnbFdkrcyrAFvF53rZnWDa3Ulj+6G6fe+yHDOjJae6f1XWHn
	gLgGnk7XPAB3toFzihY7aMns64VYKSxY/Z66cM6GfRi8QM3wertnrxovIlW9OZJc
	u3aNZqTjFeEBL5Xywdpn/V65ce2G7uw5a19F/nKe6187e3QZQiYebiEibgyZEzuR
	xPKYUBAjoyy9ed2bXIqJB3AnT6WJStghUSiSbTzLITQwuLp39jDzGLj179k36/Ao
	TFPqYe8LeHfUr843W9BY6g==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmqyq548n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:26 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oYOM034577;
	Wed, 29 Jul 2026 02:56:25 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkr4-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:25 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uMA5006812;
	Wed, 29 Jul 2026 02:56:24 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-6;
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@sandisk.com>,
        Bart Van Assche <bvanassche@acm.org>,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
        Can Guo <can.guo@oss.qualcomm.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Wang Shuaiwei <wangshuaiwei1@xiaomi.com>, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guangshuo Li <lgs201920130244@gmail.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: ufs: core: cancel RTC work in active-active suspend
Date: Tue, 28 Jul 2026 22:56:13 -0400
Message-ID: <178529373860.132455.11355770016193466344.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260714172726.1736967-1-lgs201920130244@gmail.com>
References: <20260714172726.1736967-1-lgs201920130244@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-07-29_01,2026-07-28_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=996 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX7j1I0zC/J8hP
 9TLxT5hVGcaD6CVfEcQ3X2zKdIALF9ap6Eg8Q1OAm19WaPILLSUR2hSXcnfzFh24cGaNUOseabK
 EnCab8kz6onkpWvsFoxp6TAdaXQCKOING3B8rIWwDEzep+3WpSvDfk134f1p0oN85nxOTMw8Hw9
 QKcqfWm5S4cNw2tgAjjszLLkrvx42JeU4eoJmXCzfW9aeEzJ2E2lbfusebLkk1xix7aXYOAnClM
 85ocTjmhI1xZZ0DZ2fb8aqUWujLJBy7lUIJhT29aX2ivXZ5zqx3B5nm51X+zTfeNnlif2Lm/qFW
 jeXZ7RcuqdTnHTDgwfqb1rQBnYYoDxZSEBhjrXpfyVDV+InFOW+BFsPyg/rttFxrzbO5SulMkHn
 2MAimdYXtsZRoGGG4c59+8jC+URfsLscWBuaQZ/zdGKzI971yA9l3MFo8lJQYD/h7GrDKJHKGr2
 yFYooavwKShlEjuBSGol6Zx0FqEpc3ph3BicUD5Q=
X-Proofpoint-GUID: 7qGZS05goEGryRlQAyl0WBZUjS4vVGOv
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX+GhoP1RGAO14
 jCkKErui/mAyzmqgI47KERKc68P/yS/X8tp1oBb8QgKN193pyeL1k5W5DNlzIvnq3JZQ0hdZnLw
 uMsFMSJrwOMbiSXMhevkSxSdSSMqoUFwFG7/i0hWqz6ZxzcACQ9r
X-Authority-Analysis: v=2.4 cv=X/1i7mTe c=1 sm=1 tr=0 ts=6a696bda b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=x4eqshVgHu-cdnggieHk:22 a=VwQbUJbxAAAA:8
 a=kA30lTTooYvCpAR0rz0A:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-ORIG-GUID: 7qGZS05goEGryRlQAyl0WBZUjS4vVGOv

On Wed, 15 Jul 2026 01:27:26 +0800, Guangshuo Li wrote:

> UFS RTC support schedules ufs_rtc_update_work to periodically update the
> device RTC. The work can issue query commands and access the UFS host
> controller.
> 
> A previous change moved the RTC work cancellation before the PRE_CHANGE
> vendor suspend callback to close a race in the common suspend path.
> However, the active-active path jumps directly to vops_suspend after
> flushing exception handling work and therefore bypasses the
> cancellation.
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] scsi: ufs: core: cancel RTC work in active-active suspend
      https://git.kernel.org/mkp/scsi/c/f71b4a30983b

-- 
Martin K. Petersen
