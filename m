Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EAA115689A;
	Tue,  4 Feb 2025 03:34:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.177.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738640045; cv=none; b=cHpbTahXGg7dt8K0WopJHUflOHubJLXeYGWMZ8ydCKpXdthyZr1PtkgRmswuS1iJuvijqkE+yyZJCTK1MNEXimtF73AvzO3Fjo4mbU/2FfT8eRE13dAcMKsBbUlcjSPYgNtbGuFqzTldGmoN/J/R5WMpv4Wjzx7+8U2C5BFh0N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738640045; c=relaxed/simple;
	bh=zNbuGSqaphDmTL6rS9GBo0lLdveeEQa4hlqxYLJ4CO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NllSs9R6ukoledbVsFMa1VmV0ceKZrOzNSLYV42n4RmwL0B1y2fFqJvgFF5ySCyED5amwWmkIvF7q1gxPHzwFY2qDyI1kdnL07dNjxYf7MyHIFgaFebip6tDG1GBNhqln4Gw34eIPfADWxp1fhxwTUkDI1J/JAzgZ6bXhp4/Ugg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=j1GCS00g; arc=none smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="j1GCS00g"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141NUID025190;
	Tue, 4 Feb 2025 03:33:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=3R7qKzvu/PcXkRMfHuuClZE1UfgGxQwj7bbt2prTtFQ=; b=
	j1GCS00gVmzonS759N9Fq5cl8gto70zzqhT0KpLp+GwI50aarKntE3Om6XXMfUHu
	mzqT0iEVA5sgLwG4Iq0YUSg9NH5Jm5B+lxI0NhR4oeIPjB5lYfbCxOqSLYxBeTRk
	Q2bqovomaVpz+kC7mMpqKc9hSAj5EW7RjbXAI7AZmcPnr96L+CVM4YzP4BeDE6Af
	6ZA/FeCtiHeiDvbJ4Gsgr6cuefcDDBoodqGvebqY1ffhncd9MpfZjuB1P+ytBs6k
	o/1KMg8sOfJhbxV+IgBE/YgkPY65pPyvLuwCusIJhWC9FErX/58zwlBvcAFf+tPk
	p1XI8ueNdrv+dpgXAhVPMg==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hj7v3usx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:33:57 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5140a4rD039034;
	Tue, 4 Feb 2025 03:33:56 GMT
Received: from pps.reinject (localhost [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e76f0d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 03:33:56 +0000
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by pps.reinject (8.17.1.5/8.17.1.5) with ESMTP id 5143Xs6m015172;
	Tue, 4 Feb 2025 03:33:55 GMT
Received: from ca-mkp2.ca.oracle.com.com (mpeterse-ol9.allregionaliads.osdevelopmeniad.oraclevcn.com [100.100.251.135])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTP id 44j8e76ex2-2;
	Tue, 04 Feb 2025 03:33:55 +0000
From: "Martin K. Petersen" <martin.petersen@oracle.com>
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Manivannan Sadhasivam <manisadhasivam.linux@gmail.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: [PATCH v4 0/2] Fixes for UFS clock gating initialization
Date: Mon,  3 Feb 2025 22:33:05 -0500
Message-ID: <173863996272.4118719.11109252933155321423.b4-ty@oracle.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250128071207.75494-1-avri.altman@wdc.com>
References: <20250128071207.75494-1-avri.altman@wdc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_02,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=734
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040026
X-Proofpoint-ORIG-GUID: ChJkQO8rb6uzzb9nRzNN2GmKJvJ31tWr
X-Proofpoint-GUID: ChJkQO8rb6uzzb9nRzNN2GmKJvJ31tWr

On Tue, 28 Jan 2025 09:12:05 +0200, Avri Altman wrote:

> Martin hi,
> 
> This patch series addresses two issues related to the UFS clock gating
> mechanism. The first patch ensures that the `clk_gating.lock` is used
> only after it has been properly initialized.
> 
> The second patch fixes an issue where `clk_gating.state` is toggled even
> if clock gating is not allowed, which can lead to crashes.
> 
> [...]

Applied to 6.14/scsi-fixes, thanks!

[1/2] scsi: ufs: core: Ensure clk_gating.lock is used only after initialization
      https://git.kernel.org/mkp/scsi/c/3d4114a1d344
[2/2] scsi: ufs: Fix toggling of clk_gating.state when clock gating is not allowed
      https://git.kernel.org/mkp/scsi/c/839a74b5649c

-- 
Martin K. Petersen	Oracle Linux Engineering
