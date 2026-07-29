Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD48D38C42A
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jul 2026 02:58:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785293881; cv=none; b=a0HAZDITGxf59B26XjuW9M9OOv1sef7TJeJ618txiAfPDZyM+xRiItCXEmlzBpPZWW2si9xu/O0TXH2xi2iJyrVamWMFml8DWwPiCqXhtUJAtt8Vsf+1A5kdMs44uk8T87gPAJuTQAf9sfKV5x2eIIRepChdoeEX2knhquUJBmo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785293881; c=relaxed/simple;
	bh=90GhoptoxPDKRc71zaenYWyYDRcxlxLMdvI9H5zgbts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bMTRSxaKADZXXQGzKYPj2dAUh76lDQ2Akhbuy4aGc1VRw3S0cBYENKSWm+rjdWeEfMDznnAVTeMlxWSpatK2dfFVwpoQoqoinfcoaIl7kvUP9HSjS6339qATxlB/7gmw4eF2bnTFUWkJ9EkjGfoeITbyUjVBHmMGeFWU1JXjmdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SYff+djz; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SYff+djz"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 66SItZtU1279355;
	Wed, 29 Jul 2026 02:56:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=2oJxUIQRGSjrTcumOXkPNEExUUUVuOzNl1uXEOsXG/I=; b=
	SYff+djz8pz8eJgccUZ0m4vVmFsx8W8XFJXzlBIbczL60U0q9+uhjLkUtLPut7NK
	Sbt66DsAr0i6v4hTdyPloJC523HE13wx9h3fwy7LMdOpBWefxfs15GazNSchSNB6
	6F0oFxWr6AViTfgbK+UFnKoxsS6dSf8hwYZl6eFIyHRYbgeXKrBjo/016MtnstHO
	nfX00HqcUDdsoRS/ESrfdaiBrNYTG3rLDAXSRub4qH/Ws5OV2cf/vV364V7g0za6
	1NXc+QPxW0/gtkPJtiExYPXp2Y3jYydqB9bZDOdz4mJZt+EaatcQAkSXD67F1IHN
	R59CXDdpwoRJOKNMzdXg/A==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fmr3pn6pa-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:24 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 66T2oXmI034508;
	Wed, 29 Jul 2026 02:56:23 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4fnh6ddkqf-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 29 Jul 2026 02:56:23 +0000 (GMT)
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.18.1.12/8.18.1.12) with ESMTP id 66T2uM9v006812;
	Wed, 29 Jul 2026 02:56:23 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 4fnh6ddkq0-2;
	Wed, 29 Jul 2026 02:56:22 +0000 (GMT)
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>,
        =?UTF-8?q?=E5=AD=99=E9=AD=81=20=28Kui=20Sun=29?= <kui.sun@unisoc.com>,
        =?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
        Gregory CLEMENT <gregory.clement@bootlin.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"
Date: Tue, 28 Jul 2026 22:56:09 -0400
Message-ID: <178529373864.132455.16028860310368534434.b4-ty@oracle.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
References: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
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
 adultscore=0 spamscore=0 suspectscore=0 mlxlogscore=726 malwarescore=0
 phishscore=0 lowpriorityscore=0 bulkscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2607290021
X-Proofpoint-GUID: BOMgp7j9KcEDxmDR1OEUgzkcB7uph0HN
X-Proofpoint-ORIG-GUID: BOMgp7j9KcEDxmDR1OEUgzkcB7uph0HN
X-Authority-Analysis: v=2.4 cv=RKWD2Yi+ c=1 sm=1 tr=0 ts=6a696bd8 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=IkcTkHD0fZMA:10 a=RAioF0-LDSMA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=jiCTI4zE5U7BLdzWsZGv:22 a=EIcjfB9IiI4px24ztqRk:22 a=VwQbUJbxAAAA:8
 a=i5nAqfrxqf76BDmyPzkA:9 a=QEXdDO2ut3YA:10 a=zZCYzV9kfG8A:10
 a=5yU3S35YU4bGjq-dph-N:22 a=Bho9c0fBagfJEIQBS7DQ:22 cc=ntf awl=host:13517
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX5A9IDwpyd/6C
 8U/N1z9PC54dy2SY3/dv/jaOUGdQ5J4i77KS+Lf1uNEuER+5nxIRwAdL8VKWNKD3xYdpzin5vQ9
 7gNQAxb2imaSUYhJoZkFr+M61ou7eI+Rh+gX4+7ojmpeveAeuULvUKKKqirYcpdRo475O56O1GO
 H5ksndBUdG1nP0rBerLKXsIAj5vDGrSxon7FTZ4kHw11NgPumdibtR65PO4yaVVfbXImc9Drvnx
 YpGNs5OdezWoPVAafuaLOHu5ZRTDbGJpg40G5GA7m59A8hgHN63kgqPna1Xkpaqc7tGpULlaNeP
 7x8DwvwkCj93VXylKtL/NsdpiH1TaVotPS8I74JF4erYJLlmQ4wibO7BoA9ns3rxQ1XbiQhtD/0
 IMRElqy2UnmD1Jofz1GhfRgbbvPDGQF0uwrU7mKhcc8PWuTq50GFTUlWqfLhr3PhCHSS28vXHR1
 cMA5GAGC38xyJ6DzAISAJrWlM3edgWeKra6onFzA=
X-Proofpoint-Spam-Info: AW1haW4tMjYwNzI5MDAyMSBTYWx0ZWRfX8dRuXC7k4jk3
 qXEOU1VriPF4MHD8ZYzLuNEuXTK7X3nonkPwwWR7zp6d1CZyeM/scyt/8iG6uty++XNt4tGumJu
 yuF36HWbK2AoQK7jg5l84znkFtB4tKXVjOGKcUmJ+4Opluv2HSra

On Wed, 15 Jul 2026 10:12:28 -0700, Bart Van Assche wrote:

> There have been multiple reports of performance regressions caused by
> commit 3c7ac40d7322. Hence this revert.
> 
> This patch reverts most of the following commits:
> * 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to
>   a threaded IRQ handler")
> * 6475cfb81fc4 ("scsi: ufs: core: Avoid IRQ thread wakeup during active UIC
>   command")
> 
> [...]

Applied to 7.2/scsi-fixes, thanks!

[1/1] ufs: core: Revert "Delegate the interrupt service routine to a threaded IRQ handler"
      https://git.kernel.org/mkp/scsi/c/8a309036f557

-- 
Martin K. Petersen
