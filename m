Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A116B3D0D5
	for <linux-scsi@vger.kernel.org>; Tue,  5 Nov 2024 02:33:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.165.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730774041; cv=none; b=F6iRCMbnsFCUtBOTekL3QBAe4zEWgHqIh5dp3rJJB1VjPTcL8E/3ceRRS9sJ00dTr1vMr1aCaD4hCBaRztW4jAkTkValTdYf3Tp1uLQpL+Ahbs37STL96cwkeBCxaQrjko0rACw6egYJZtpuSEYWsxf6O/z+PAwG7p31symBkc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730774041; c=relaxed/simple;
	bh=8nRnZlPE7WaHAgmP/xF7tzIWfAE/Ktk48w7olQRkm1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=n2eQfjU/wg8CFWOECtwyb7NvHvPGiY8T0hqBK9+2CxJieBz8BppIc3gxWdI8PecyQ11VKgOQV0ujSSw4s0UbmST5BZO/Q/DM+y4q8zVvKitsIBaSEhFdVxHr8cWOGBaf8HZAi2MurNUmSlWaJdS6QI4o35woXayDNYkMaNhscr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=CP3ng92H; arc=none smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="CP3ng92H"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52Mbrt018794;
	Tue, 5 Nov 2024 02:33:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=jHAvqj2xjQBCMFWQ/H77okJ359NqU/rVwq0b3soq1hA=; b=
	CP3ng92HsSPdUgMyjuui/twjsJ/TnWHoZz8t/t2k9boAPoSv2iBGmTB28YqfyeuE
	FpMxSDW8uwoFL2DgUtCj5bu31bOEaUS5IN6N4J4SRNPLVE6suhATO4rRwoY6GfLC
	WjoRUdJSnnfE1bLaVsIAiuyE0oQL7GfGdYNVlP/kP9xKGtjE//RHLiK/sIzs5Fko
	jraVOPBepCIqzGvw8h/bDRFDWVMrn65ozo/9oAUqEwiSjjntB7XVNqHDIzAQ7yVz
	H1XqQDpJeQYT74SfeO0a42z6XrN2R7xuQBeSVan9Pn9P0efgvFmfYjYXc1wp5SOe
	Xm4HWsx3rUxMcY1SXi3SuA==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42nb0cca5p-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:34 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4A52MtvF036865;
	Tue, 5 Nov 2024 02:33:33 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 42nah6g2ku-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 05 Nov 2024 02:33:33 +0000
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 4A52XVFs017503;
	Tue, 5 Nov 2024 02:33:32 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTP id 42nah6g2k1-4;
	Tue, 05 Nov 2024 02:33:32 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
        Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Peter Wang <peter.wang@mediatek.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Avri Altman <avri.altman@wdc.com>,
        Andrew Halaney <ahalaney@redhat.com>, Bean Huo <beanhuo@micron.com>,
        Maramaina Naresh <quic_mnaresh@quicinc.com>,
        Eric Biggers <ebiggers@google.com>, Minwoo Im <minwoo.im@samsung.com>
Subject: Re: [PATCH v2] scsi: ufs: core: Make DMA mask configuration more flexible
Date: Mon,  4 Nov 2024 21:32:50 -0500
Message-ID: <173077364681.2354920.8655193638396501045.b4-ty@oracle.com>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241018194753.775074-1-bvanassche@acm.org>
References: <20241018194753.775074-1-bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-04_22,2024-11-04_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411050019
X-Proofpoint-ORIG-GUID: EdFNERbQKefubwkaKFu84eyPN1Y0cRbf
X-Proofpoint-GUID: EdFNERbQKefubwkaKFu84eyPN1Y0cRbf

On Fri, 18 Oct 2024 12:47:39 -0700, Bart Van Assche wrote:

> Replace UFSHCD_QUIRK_BROKEN_64BIT_ADDRESS with
> ufs_hba_variant_ops::set_dma_mask. Update the Renesas driver accordingly.
> This patch enables supporting other configurations than 32-bit or 64-bit
> DMA addresses, e.g. 36-bit DMA addresses.
> 
> 

Applied to 6.13/scsi-queue, thanks!

[1/1] scsi: ufs: core: Make DMA mask configuration more flexible
      https://git.kernel.org/mkp/scsi/c/78bc671bd150

-- 
Martin K. Petersen	Oracle Linux Engineering
