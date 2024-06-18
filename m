Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D462545C16
	for <linux-scsi@vger.kernel.org>; Tue, 18 Jun 2024 16:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718727876; cv=none; b=XaKzv0ySH4ZKMyUzF+IWw6yoFjCB7heGPqZ3yK8guBMhaKa/UP88mwyqilVg+qjid9vChg5Hyv6wKyjhhiEp3BEEDJMTWdHg5ZLibwyar22y4Ny9VerZs3tmRsUdIjBvO2FOq66W1UQj/TjrNmXjtLn/REfKPhlMWVfSuxoBx0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718727876; c=relaxed/simple;
	bh=QkFmj7m57sNbLUIVVTYAXpPgy7Nxs2gw7gUTwTuqPXg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pW0Oy85q6ZhVQJrTIrhTU2E5YWYY6eOY5cJMFblO/Ierzt6A0PEanM3CSLbG5t/PuFRMf1j0FB+JXReLoG9YoQQRxjOdnK6QuB2J9sniOyi3AYZsdvEvxdcYa9hJYOX3mrEl7vvAg7vmqJnmUTfNkA18ZM1bGNNh4JdLbhFxTZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sbA6bl8I; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sbA6bl8I"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4W3XC61YbXzlgMVS;
	Tue, 18 Jun 2024 16:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1718727872; x=1721319873; bh=7tgDTkz5DYbnb7du4KZlpNR4
	kEN+nkZnE+V3YvIyAN4=; b=sbA6bl8I8xufH+lFiuP3wsbeb3GbEGorJVhT4Xua
	LH4Im4w1DU4D20U1mAWWsgBp4WWJBqKMQJjn0IraCVkGBVMJVxJ0s+pVP07o7gLX
	CjAYmhnLGpTrT9V5OTqgyuOdQPME9k5ZQegsuHUNXVTP9z6wAukdjaWxq5xH7Wlk
	HEWwOINvHiRHUn0PIzYUU6c4zD1q8f9MYg/2j2iK/RnXWDBA4fMZfNfYedOPHChx
	pkr0ajT7IFlwepBLBiJJ1zBriMVbjIiNOHriFbLSOitnp3pJNUR1+eSwEK+CrS4M
	P/6BRtO320nyQZ7PtAnpJXOA+h29i2M7DOUhCH/QCcRunQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cuhH5axz6wAD; Tue, 18 Jun 2024 16:24:32 +0000 (UTC)
Received: from [100.96.154.26] (unknown [104.132.0.90])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4W3XC26yDyzlgMVR;
	Tue, 18 Jun 2024 16:24:30 +0000 (UTC)
Message-ID: <b8dde57a-c787-4ed0-a90d-7c4320864b04@acm.org>
Date: Tue, 18 Jun 2024 09:24:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ufs: ufs-pci: Add support for Intel Panther Lake
To: Adrian Hunter <adrian.hunter@intel.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "James E . J . Bottomley" <jejb@linux.ibm.com>,
 Avri Altman <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
 linux-scsi@vger.kernel.org
References: <20240618073158.38504-1-adrian.hunter@intel.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240618073158.38504-1-adrian.hunter@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/18/24 12:31 AM, Adrian Hunter wrote:
> Add PCI ID to support Intel Panther Lake, same as MTL.
> 
> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>   drivers/ufs/host/ufshcd-pci.c | 1 +
>   1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/ufs/host/ufshcd-pci.c b/drivers/ufs/host/ufshcd-pci.c
> index 0aca666d2199..ec675a13c73e 100644
> --- a/drivers/ufs/host/ufshcd-pci.c
> +++ b/drivers/ufs/host/ufshcd-pci.c
> @@ -602,6 +602,7 @@ static const struct pci_device_id ufshcd_pci_tbl[] = {
>   	{ PCI_VDEVICE(INTEL, 0x7E47), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>   	{ PCI_VDEVICE(INTEL, 0xA847), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>   	{ PCI_VDEVICE(INTEL, 0x7747), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
> +	{ PCI_VDEVICE(INTEL, 0xE447), (kernel_ulong_t)&ufs_intel_mtl_hba_vops },
>   	{ }	/* terminate list */
>   };

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
