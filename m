Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B9891E32D8;
	Wed, 30 Oct 2024 13:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730295725; cv=none; b=fZbaPgLjUOYjj4p5UgktHlJkDenN6mS/DplrAcGqRsYQ42lebfvH3MAnRrYk5lHmiT/kYe4lyG5vvx45OPPHf8R4//fFnodCQ0qtF+IDNxJMrbb8uchasl0oKgq8nZDZ0EOv1WcHtK1z6ykjqxNOspVTH47I/gO9NN0MFzEBU5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730295725; c=relaxed/simple;
	bh=QwcAFYePohivBRYb4Lo1h2IcU0/sN1w3jRL3R+xHKMQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=udcmjknUC11xzvNCgM9d1GX0fJ+CKQ8l5migNMMSVoNjNnTJ4fzHKRNZYvfkrdler0ybOVCP/mUXEkrh7A/q3TSM+4Y/eFGgqc3Kg3RN//FEA5ZDs2a3pW8JKjkkPQb5trDdck0VtljciFYu79ipibJWXTmxgUIVm1kDH/yejnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=becUY4MS; arc=none smtp.client-ip=192.198.163.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="becUY4MS"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1730295723; x=1761831723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=QwcAFYePohivBRYb4Lo1h2IcU0/sN1w3jRL3R+xHKMQ=;
  b=becUY4MSAWwiqnCkn6upPp0bZUd0TNILPgIqMq+W9pxAwRmO0+cXlWOT
   bpZBVKgrj8Kqchel6UIEfUp5Kw1K8XkS/tUw+IDbxE2CKVE8T20bKjnjs
   9TyjW7/nTnmSqGCzz8IxYCKeaNVfNKWJQqryEe5rAprCnCiLtrbw8vzLo
   j03RQ4pdnBBNCOtWWADAZac8gekN5lS2p/32i4kD/lyL0ZlLT/dRTFg0g
   yKg0fF5j5TxTFs8/NsCFz55wr7B/vOqaQo8a1A4VM5JqIdY0UFWXYL4Ji
   5KBvvWDlIWsGGZ5nIq8cw+R0802shhAKCH/rMWzWuz8jHdgbBUy3dEQa7
   g==;
X-CSE-ConnectionGUID: Lvg5a3aeR02QVA+q7eQtmA==
X-CSE-MsgGUID: U9X8rwkCRcStilWwAg/p+Q==
X-IronPort-AV: E=McAfee;i="6700,10204,11241"; a="40568749"
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="40568749"
Received: from fmviesa008.fm.intel.com ([10.60.135.148])
  by fmvoesa105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 06:41:50 -0700
X-CSE-ConnectionGUID: vAg+Jr+vTHmz9pTWNsX2Sg==
X-CSE-MsgGUID: I6ZZi7D9RBy+a3Y7fyGW+g==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,245,1725346800"; 
   d="scan'208";a="82428341"
Received: from ahunter6-mobl1.ger.corp.intel.com (HELO [10.0.2.15]) ([10.245.115.59])
  by fmviesa008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Oct 2024 06:41:47 -0700
Message-ID: <f1221990-8d89-4b60-b6f7-25540ad5ea55@intel.com>
Date: Wed, 30 Oct 2024 15:41:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: Replace deprecated PCI functions
To: Philipp Stanner <pstanner@redhat.com>,
 Pedro Sousa <pedrom.sousa@synopsys.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Bart Van Assche <bvanassche@acm.org>, Minwoo Im <minwoo.im@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20241028102428.23118-2-pstanner@redhat.com>
Content-Language: en-US
From: Adrian Hunter <adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki,
 Business Identity Code: 0357606 - 4, Domiciled in Helsinki
In-Reply-To: <20241028102428.23118-2-pstanner@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 28/10/24 12:24, Philipp Stanner wrote:
> pcim_iomap_regions() and pcim_iomap_table() have been deprecated in
> commit e354bb84a4c1 ("PCI: Deprecate pcim_iomap_table(),
> pcim_iomap_regions_request_all()").
> 
> Replace these functions with pcim_iomap_region().
> 
> Signed-off-by: Philipp Stanner <pstanner@redhat.com>

Reviewed-by: Adrian Hunter <adrian.hunter@intel.com>

> ---
>  drivers/ufs/host/tc-dwc-g210-pci.c | 8 +++-----
>  drivers/ufs/host/ufshcd-pci.c      | 8 +++-----
>  2 files changed, 6 insertions(+), 10 deletions(-)
> 
> diff --git a/drivers/ufs/host/tc-dwc-g210-pci.c b/drivers/ufs/host/tc-dwc-g210-pci.c
> index 876781fd6861..0167d8bef71a 100644
> --- a/drivers/ufs/host/tc-dwc-g210-pci.c
> +++ b/drivers/ufs/host/tc-dwc-g210-pci.c
> @@ -80,14 +80,12 @@ tc_dwc_g210_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	pci_set_master(pdev);
>  
> -	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
> -	if (err < 0) {
> +	mmio_base = pcim_iomap_region(pdev, 0, UFSHCD);
> +	if (IS_ERR(mmio_base)) {
>  		dev_err(&pdev->dev, "request and iomap failed\n");
> -		return err;
> +		return PTR_ERR(mmio_base);
>  	}
>  
> -	mmio_base = pcim_iomap_table(pdev)[0];
> -
>  	err = ufshcd_alloc_host(&pdev->dev, &hba);
>  	if (err) {
>  		dev_err(&pdev->dev, "Allocation failed\n");
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 54e0cc0653a2..ea39c5d5b8cf 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -588,14 +588,12 @@ ufshcd_pci_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>  
>  	pci_set_master(pdev);
>  
> -	err = pcim_iomap_regions(pdev, 1 << 0, UFSHCD);
> -	if (err < 0) {
> +	mmio_base = pcim_iomap_region(pdev, 0, UFSHCD);
> +	if (IS_ERR(mmio_base)) {
>  		dev_err(&pdev->dev, "request and iomap failed\n");
> -		return err;
> +		return PTR_ERR(mmio_base);
>  	}
>  
> -	mmio_base = pcim_iomap_table(pdev)[0];
> -
>  	err = ufshcd_alloc_host(&pdev->dev, &hba);
>  	if (err) {
>  		dev_err(&pdev->dev, "Allocation failed\n");

