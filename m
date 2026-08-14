Received: from mail-m49213.qiye.163.com (mail-m49213.qiye.163.com [45.254.49.213])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE37633F5BC;
	Fri, 14 Aug 2026 08:10:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.213
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695042; cv=none; b=t9BFnR+ctbdflaZO6nePXgXgs7sJQI+uuu8jg0BSenfsHmuClt5Ax6Etqcdvn2KtoSwdndgUOK2Av8bgwWMVTEF4+7aNgsjvkOw1F6rwowOS4Avm26ltk/30gTVEz40AsJ84Gx0JkeJeJBzNclYJdaLsNULxrgoIGXY7SPJfC6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695042; c=relaxed/simple;
	bh=VtaXhFQdMG6DKC1EO82xfC6a8fdEEN+jVFm2eqOF1+k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WHnBb6QhqWxdaymnuvpfGPO71YtZVaLSYPygdf5n8/yFcoyvj1pY4VZM8jRdXb6iInYqxju7NDq3jScKctZMlnpAwgsMFlxdP9npakcuQ7j8JMTkcqdH61YUUIWfPSdnBiLCDusrf1zWijpZLka1Dl4BbJWNsIwmEDaJZRA57K0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=R1EtLt4s; arc=none smtp.client-ip=45.254.49.213
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="R1EtLt4s"
Received: from [IPV6:2001:da8:e800:71f4:5c8e:2823:7a5:5139] (unknown [IPV6:2001:da8:e800:71f4:5c8e:2823:7a5:5139])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49fe00518;
	Fri, 14 Aug 2026 16:05:16 +0800 (GMT+08:00)
Message-ID: <4572b73c-da7a-405b-973d-43f0549082d0@leap-io-kernel.com>
Date: Fri, 14 Aug 2026 16:05:16 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/2] scsi: leapraid: balance host references for
 firmware log VMAs
To: Linmao Li <lilinmao@kylinos.cn>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: hare@kernel.org, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
 <20260814033845.2971706-2-lilinmao@kylinos.cn>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <20260814033845.2971706-2-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fff4dcd4503aekunmf6d0c7a964d747
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGh5OVkoYQkhLGR0dTB0fQ1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJS0tKQR8aQ0EeQ0tLQUxKHU9BThhDHkFJQ0lIQUwaTk
	FOSkhCWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=R1EtLt4s02JTIkaioT5uVW4Ttll3gr/eCBI5J01Q+re0wvYv7SadPBvvB/yYIcyZFlWnIO1kuy1OXedvPsgWiYYF/1nazCnCbus5Oh2K25cHFs36tXorK3S5PRVspLPrnmG2WFcC1Mda5kv9ni/4EXFEKrBWb2GxMechjcsizfOb0gOvhWbci/dpcYA7eBq1XN9bnkNalZn1GTsMn9cN2X5kaGNekuvccSDcGPINc+lqT6fm8U8JLd7u+7qAL37jwKnCt9oFo0/99tGVUSP/dO30FuKF1WbI4ic2kbFmaFsx1+v7IKHvzrdin/MVf8AwupjMCmuwnyR2PxISYMJDiQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=EIr97dwndNeakT2MTGL2cJNRUEW6VZpF9VUT1vIWapM=;
	h=date:mime-version:subject:message-id:from;

在 2026/8/14 11:38, Linmao Li 写道:
> leapraid_fw_mmap() keeps the Scsi_Host reference obtained while
> looking up the adapter for the lifetime of the initial VMA.  The VMA
> close callback drops that reference.
> 
> The open callback is also invoked when a VMA is duplicated or split,
> but it only increments mmap_refcnt.  Since every corresponding close
> callback drops a host reference, cloning the mapping can release the
> host while another VMA still refers to the adapter.
> 
> Take a host device reference for every VMA open and release the lookup
> reference once the initial mapping has acquired its own reference.  Use
> get_device() because a VMA can be cloned after the host enters SHOST_DEL;
> an existing VMA still pins the host at that point and open cannot fail.
> 
> Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  drivers/scsi/leapraid/leapraid_app.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
> index 742f19c07fcbb..841027ce2501c 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
> @@ -697,6 +697,7 @@ static void leapraid_fw_mmap_open(struct vm_area_struct *vma)
>  	if (!adapter)
>  		return;
>  
> +	get_device(&adapter->shost->shost_gendev);
>  	atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
>  }
>  
> @@ -767,7 +768,6 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
>  	vma->vm_private_data = adapter;
>  	vma->vm_ops = &leapraid_fw_mmap_vm_ops;
>  	leapraid_fw_mmap_open(vma);
> -	adapter = NULL;
>  
>  	rc = 0;
>  out_put:

Thanks for the fix. This correctly fixes the issue.

Reviewed-by: Dongdong Hao <doubled@leap-io-kernel.com>
