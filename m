Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F77364C6
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jan 2024 02:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706581675; cv=none; b=o2W2so0VKVNqwwsR9IAKy6ZeJmMjEolDGIOP/k+f4sTJun4pOtMLOZHey5oNAfkoOiaYfaSKuQt444J0SAdXdrfDzacKbmEZv4ppHMl4JyEAbZeSCGfeNw+S+iTFlb3FkwAQBBmrIRZgwcHHlIUDIY9poBwuF8BnsjMLXmRf9vQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706581675; c=relaxed/simple;
	bh=VV4frZ3dbOJq8kz91yLwLwaB2woURT60QWBVM0hrXF0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=T4Rq3ImcPpU/LucaG5CNHgFOL1ICcfhNfxZQccpVBRf7uWmXJ4EVxUvupfAd9kb2StlOmHARRSFGwXmp1gpuJNm0UzvfwZKJD2aEOyb+XgrZkT/yaxnWmZQRrf/3lpCdC+hdloKr7VIvwG1D4szS7mcGtDBA4KtinMDU1PfG1vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=AUMcTwcZ; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="AUMcTwcZ"
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40TJiRAR004400;
	Tue, 30 Jan 2024 02:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : mime-version :
 content-type : content-transfer-encoding; s=corp-2023-11-20;
 bh=RzUezpQzBd4n0Tque+IpmQqiRhLzThAx3OoMrn7PN3M=;
 b=AUMcTwcZ8UEuuDLUyYlfGtMtyoq7jmdGTnyrZs4PpAGvv3pad1TJU8eIT/6W3jlpjtjC
 xskEJWM5DPWV29y8aCFfueSsyI2LS5FrUNEGX5PDfJVO+SPSSxP+GI02aCjiZdrQQ85N
 4FHjYhDXG0dLcwyzFaq9uvl6VTD290lFXHpsoiv9fFRQEsp7a3XcA8V+dNg3HbgBVMVa
 iLxIquSQt97v9nDOYOJkVVYE8PyX3vyrrvvp3H5JgHBlxsBPQkNkGHoVfdfD4BYhiCM9
 x5HHpKvxw5YVzx+lQjUKZRkuxgopsI6p4wE4jsLLNj91hOTiYDh/yX5I7lEB7tDOsyfi HA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vvsqawf80-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:43 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40TNuotH014461;
	Tue, 30 Jan 2024 02:27:42 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vvr96g53g-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 30 Jan 2024 02:27:42 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 40U2RP00040916;
	Tue, 30 Jan 2024 02:27:41 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 3vvr96g4y7-11;
	Tue, 30 Jan 2024 02:27:41 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: chun-hung.wu@mediatek.com, linux-scsi@vger.kernel.org, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com, peter.wang@mediatek.com
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        alice.chao@mediatek.com, cc.chou@mediatek.com,
        chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
        powen.kao@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com, chu.stanley@gmail.com
Subject: Re: [PATCH v1 0/3] ufs: host: mediatek: Provide fixes in MediaTek platforms
Date: Mon, 29 Jan 2024 21:27:07 -0500
Message-ID: <170657812662.784857.16191181039085066671.b4-ty@oracle.com>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231221110416.16176-1-peter.wang@mediatek.com>
References: <20231221110416.16176-1-peter.wang@mediatek.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-29_15,2024-01-29_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 mlxlogscore=878 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2401300015
X-Proofpoint-GUID: NJkiV0n_fjGuAiw418eQU27uFr9FqCiD
X-Proofpoint-ORIG-GUID: NJkiV0n_fjGuAiw418eQU27uFr9FqCiD

On Thu, 21 Dec 2023 19:04:13 +0800, peter.wang@mediatek.com wrote:

> This patch fix MediaTek platform exit hibern8 and mcq related error.
> 
> Peter Wang (3):
>   ufs: host: mediatek: check link status after exit hibern8
>   ufs: host: mediatek: fix mcq mode tm cmd timeout
>   ufs: host: mediatek: disable mcq irq when clock off
> 
> [...]

Applied to 6.9/scsi-queue, thanks!

[1/3] ufs: host: mediatek: check link status after exit hibern8
      https://git.kernel.org/mkp/scsi/c/29b3a373e2df
[2/3] ufs: host: mediatek: fix mcq mode tm cmd timeout
      https://git.kernel.org/mkp/scsi/c/468b3e0a3bca
[3/3] ufs: host: mediatek: disable mcq irq when clock off
      https://git.kernel.org/mkp/scsi/c/e0dc13e5a3cb

-- 
Martin K. Petersen	Oracle Linux Engineering
