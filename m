Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37F1D1E9B1A
	for <linux-scsi@vger.kernel.org>; Sun,  7 Sep 2025 10:00:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757239236; cv=none; b=PCwUXoSFTcbCLTsLjSoUj/CIDpmQFcmmtlCu6iAY+UDZvIK0Pkxu7Hp6aJqPFOvFOd+2xWLGY2mnclOVDwmTkTBBDKmJTBmKosZ32RIxqGxmimeKCg4U4hMiGoNKx152rClEpUBiSocCLq9lnrpytjg302MIaYUPW3TVMygeAtI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757239236; c=relaxed/simple;
	bh=ZghqaZbP6otsbrM7NnlZiFEc7J4Jwli5zVhs7n7YAXw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=hxGHFi+Na8ZdzHJi28d3LVk1b/LBN+PpjcNaRSc3zvGDnN8wsdAJaZdCxUmT46DewcXInvpUphfK4n6JlBRWxTf2XymQlcZK26aac6DG7Sw4YBQ+rCkyJhhrj/CAO8zCqdwyA7SrLeXDXinG9iT2WB61DAMOEAeBfjMqFAW9OAk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=leQD7IJe; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="leQD7IJe"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20250907100029epoutp022a2804532f7f331c1be519519a4dfe1f~i98TG8AfU0851508515epoutp02Y
	for <linux-scsi@vger.kernel.org>; Sun,  7 Sep 2025 10:00:29 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20250907100029epoutp022a2804532f7f331c1be519519a4dfe1f~i98TG8AfU0851508515epoutp02Y
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1757239229;
	bh=SbHDtPkviZlO/LgkXzGe9eikNE8oo3x9pUKOqZtyP0k=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=leQD7IJe2VjE+EsF4S7jZpFVB8Ok5heo3mOAbvUzL1NbWzHRgZpK+pR48ccgns5S+
	 ytw0LGXloMaBB/8LkcWrbKRsSGhV9lROS8zaqZOABD3Io5HUiq1Orqj6Sxs1Qy892L
	 eU7Ccw/zfXDAXM1Kbp/wc/8V93jOzMgnIWJyW9Zg=
Received: from epsnrtp03.localdomain (unknown [182.195.42.155]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTPS id
	20250907100028epcas5p14ee9dcee16c57c7fc61bbb6b2b5f00c7~i98SwfqVZ1432614326epcas5p1N;
	Sun,  7 Sep 2025 10:00:28 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.86]) by
	epsnrtp03.localdomain (Postfix) with ESMTP id 4cKQZ35nmJz3hhT7; Sun,  7 Sep
	2025 10:00:27 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20250907100027epcas5p249d149f0d10eb6f9dea8f86b59cb34ca~i98Rf9xdi0141601416epcas5p2C;
	Sun,  7 Sep 2025 10:00:27 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20250907100025epsmtip161b00d26b7ac98bc1b1a50a891bd95e8~i98PoOEs10915609156epsmtip1w;
	Sun,  7 Sep 2025 10:00:25 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Alok Tiwari'" <alok.a.tiwari@oracle.com>, <mani@kernel.org>,
	<quic_cang@quicinc.com>, <quic_asutoshd@quicinc.com>,
	<peter.wang@mediatek.com>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>
In-Reply-To: <20250906203636.3103586-1-alok.a.tiwari@oracle.com>
Subject: RE: [PATCH] scsi: ufs: mcq: Fix memory allocation checks for SQE
 and CQE
Date: Sun, 7 Sep 2025 15:30:22 +0530
Message-ID: <473a01dc1fde$3c7df240$b579d6c0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQJ+JsRPtJ5DiQn8XjdVTu6jdShjxwJ7OyEXsy+RRoA=
Content-Language: en-us
X-CMS-MailID: 20250907100027epcas5p249d149f0d10eb6f9dea8f86b59cb34ca
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20250906203658epcas5p335a6395bad2fa2f9f2d629d80a3dcb38
References: <CGME20250906203658epcas5p335a6395bad2fa2f9f2d629d80a3dcb38@epcas5p3.samsung.com>
	<20250906203636.3103586-1-alok.a.tiwari@oracle.com>

Hi Alok

> -----Original Message-----
> From: Alok Tiwari <alok.a.tiwari@oracle.com>
> Sent: Sunday, September 7, 2025 2:06 AM
> To: mani@kernel.org; quic_cang@quicinc.com; quic_asutoshd@quicinc.com;
> peter.wang@mediatek.com; martin.petersen@oracle.com;
> alim.akhtar@samsung.com; avri.altman@wdc.com; bvanassche@acm.org;
> James.Bottomley@HansenPartnership.com; linux-scsi@vger.kernel.org
> Cc: alok.a.tiwari@oracle.com; linux-kernel@vger.kernel.org
> Subject: [PATCH] scsi: ufs: mcq: Fix memory allocation checks for SQE and
> CQE
> 
> The previous checks incorrectly tested the DMA addresses returned by
> dmam_alloc_coherent instead of the returned virtual addresses.
> This could cause allocation failures to go unnoticed.
> 
> dmam_alloc_coherent returns the CPU address, not the DMA address.
> Using DMA pointer for NULL check is incorrect.
> 
Right, Zero/NULL can be a valid DMA address and  NULL retuned by
dmam_alloc_coherent()
Is allocation failure. 
May be rephrase your commit message to be more clearer and this patch is
good to go.

> Change checks to verify sqe_base_addr and cqe_base_addr instead of
> sqe_dma_addr and cqe_dma_addr
> 
> Fixes: 4682abfae2eb ("scsi: ufs: core: mcq: Allocate memory for MCQ mode")
> Signed-off-by: Alok Tiwari <alok.a.tiwari@oracle.com>
> ---
For v2 patch, feel free to add
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

>  drivers/ufs/core/ufs-mcq.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c index
> 1e50675772fe..cc88aaa106da 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -243,7 +243,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
>  		hwq->sqe_base_addr = dmam_alloc_coherent(hba->dev,
> utrdl_size,
>  							 &hwq-
> >sqe_dma_addr,
>  							 GFP_KERNEL);
> -		if (!hwq->sqe_dma_addr) {
> +		if (!hwq->sqe_base_addr) {
>  			dev_err(hba->dev, "SQE allocation failed\n");
>  			return -ENOMEM;
>  		}
> @@ -252,7 +252,7 @@ int ufshcd_mcq_memory_alloc(struct ufs_hba *hba)
>  		hwq->cqe_base_addr = dmam_alloc_coherent(hba->dev,
> cqe_size,
>  							 &hwq-
> >cqe_dma_addr,
>  							 GFP_KERNEL);
> -		if (!hwq->cqe_dma_addr) {
> +		if (!hwq->cqe_base_addr) {
>  			dev_err(hba->dev, "CQE allocation failed\n");
>  			return -ENOMEM;
>  		}
> --
> 2.50.1


