Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCCEB7482
	for <linux-scsi@vger.kernel.org>; Tue, 16 Jul 2024 02:30:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721097012; cv=none; b=SXpg4RXbxDwbAp3Ey8ctBPW5zsIVJxnHT7Xa2mWEyT0WJJAgu6+D7KDQjO8y4IpkyE8kmcokJqII+GVQ5geWqVT7Ro1sZcSQk9AK7Hcdj/GQlT0AhV93HUctiMUAXIagWmaT1Jx3bpHkU/oJrXA6xCqvVQJFe+e34yx+/IyLC8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721097012; c=relaxed/simple;
	bh=OFXiqlyFglBpm/sMCO/7gOD7PO1vQUOC3h3PO5TEbqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lM5fId0LbbQ2vzZDMukbBKiDs4KVKpcanrmWuSuaWBciaeRux0rAW80UVdHDEvKBAdzNvhIpd24VAlejwL/89fTnYm1Vg8d+/xvzWIb6KhcJgqoWfybhvvgnNPUAfsPeMeFn3Hmo38hAY2/Vo32GYzXrCX+Hsy6X/JNsA8xfb+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=JS92SVwm; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="JS92SVwm"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46FL1MSW005763;
	Tue, 16 Jul 2024 02:30:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=
	from:to:cc:subject:date:message-id:in-reply-to:references
	:mime-version:content-type:content-transfer-encoding; s=
	corp-2023-11-20; bh=BCYKCxRE+M5IadJrdTP/P2zx6ZKFSbzruGKmfEpfkPs=; b=
	JS92SVwmpXKN8lP4HMf2pcCf1Dx2Am/hFe7RV0lO1IOpPngwmAILjnYL2K/4FD1i
	bw/oYDv5Ng0B6758yrzG+a/lL2V/1JMfnGcAN1v27VBT3jl1h2i6eEPKi8+tk5Gd
	6TrbS8aGxeww7zHwhHKpvtHMUzgbr+B67XMtM3rN750vhbe4SMH9qRjy05V1KguV
	W/LLvmOIMzRBgO4I0wCtw3KTVw0Q/GJgKZmrKNVYvs2RyimL7SY5+5+up45hSWLd
	2rxzJ7sCetqNggRENIrF/CGha0GycFO9y3+wtL4bTuXX4p7hk1XtKbmz6gXyyCX8
	7UJd5vNrDttYmAoC6FU49Q==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40bgc2cu0t-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:04 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46G10Fp4002641;
	Tue, 16 Jul 2024 02:30:03 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40bg1exxcb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 16 Jul 2024 02:30:03 +0000
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 46G2U3A5027682;
	Tue, 16 Jul 2024 02:30:03 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 40bg1exxah-1;
	Tue, 16 Jul 2024 02:30:03 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, peter.wang@mediatek.com,
        manivannan.sadhasivam@linaro.org
Subject: Re: [PATCH v5 00/10] UFS patches for kernel 6.11
Date: Mon, 15 Jul 2024 22:29:20 -0400
Message-ID: <172109323553.941202.15493909377795653078.b4-ty@oracle.com>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240708211716.2827751-1-bvanassche@acm.org>
References: <20240708211716.2827751-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-15_19,2024-07-11_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 adultscore=0
 bulkscore=0 mlxlogscore=934 malwarescore=0 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2406180000
 definitions=main-2407160018
X-Proofpoint-GUID: 3SVmaxWxhUnQHzRxzudXqoE4CLOtZkXN
X-Proofpoint-ORIG-GUID: 3SVmaxWxhUnQHzRxzudXqoE4CLOtZkXN

On Mon, 08 Jul 2024 14:15:55 -0700, Bart Van Assche wrote:

> Please consider this series of UFS driver patches for the next merge window.
> 
> Thank you,
> 
> Bart.
> 
> Changes compared to v4:
>  - Included changes for the MediaTek driver in patch "Inline is_mcq_enabled()".
>    Dropped the Reviewed-by tags from that patch.
>  - Added a patch that moves the "hba->mcq_enabled = true" assignment into
>    ufshcd_mcq_enable(). Later patches have been modified such that
>    hba->mcq_enabled assignments only happen inside ufshcd_mcq_enable() and
>    ufshcd_mcq_disable().
> 
> [...]

Applied to 6.11/scsi-queue, thanks!

[01/10] scsi: ufs: Declare functions once
        https://git.kernel.org/mkp/scsi/c/d502dac69ac0
[02/10] scsi: ufs: Initialize struct uic_command once
        https://git.kernel.org/mkp/scsi/c/93ef12d92f65
[03/10] scsi: ufs: Remove two constants
        https://git.kernel.org/mkp/scsi/c/92c0b10fefe2
[04/10] scsi: ufs: Rename the MASK_TRANSFER_REQUESTS_SLOTS constant
        https://git.kernel.org/mkp/scsi/c/b53eb9a050d7
[05/10] scsi: ufs: Initialize hba->reserved_slot earlier
        https://git.kernel.org/mkp/scsi/c/f4750af7081d
[06/10] scsi: ufs: Inline is_mcq_enabled()
        https://git.kernel.org/mkp/scsi/c/0fca3318e550
[07/10] scsi: ufs: Move the "hba->mcq_enabled = true" assignment
        https://git.kernel.org/mkp/scsi/c/4a8c859b44da
[08/10] scsi: ufs: Move the ufshcd_mcq_enable() call
        https://git.kernel.org/mkp/scsi/c/7e2c268dc306
[09/10] scsi: ufs: Inline ufshcd_mcq_vops_get_hba_mac()
        https://git.kernel.org/mkp/scsi/c/5e2053a41984
[10/10] scsi: ufs: Make .get_hba_mac() optional
        https://git.kernel.org/mkp/scsi/c/af568c7e8292

-- 
Martin K. Petersen	Oracle Linux Engineering
