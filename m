Received: from mail-m19731103.qiye.163.com (mail-m19731103.qiye.163.com [220.197.31.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E11E43B1ED1;
	Fri, 14 Aug 2026 08:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.31.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786695841; cv=none; b=JpUSYuJZRFTJmm413mZcVfRD04M5brKxr4A5fsAWkGyim2Vu2/R4wrD60LpX0tHplffLPGcbrrnllAuywQmQcJppQuMFhXXP2ZrPjFr1Es2LC5957N9uMc4HufvXEBvwYeHWq4kQYRqS7XJDHttGxBHU90BHyHfVT2q9dZSqFC4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786695841; c=relaxed/simple;
	bh=vmY8hPKX8ohnlyq+vjzKwWnwiqwe8IslfZMrMxaaNd4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a0YNKnyW85MFDIKkO1CLJqvySuLfdlAtpBhKXZi5gMnMMb1FJJ/qNHdK4pkHOHU3ySmcMY8CMHBU0CZk1xRvYPfKG1beOYFBKkOdSJBGrc5vLgCpTkesBb6EjXvRKCHf4BUl+pGFQsfNw+kBKMMSpitWiXCLxKDLppujznBSShc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=II+p1Uw9; arc=none smtp.client-ip=220.197.31.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="II+p1Uw9"
Received: from [10.31.68.69] (unknown [112.48.20.89])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49fe2bd42;
	Fri, 14 Aug 2026 16:08:29 +0800 (GMT+08:00)
Message-ID: <bfbd6122-988c-49fe-a1e6-be082d9f93ff@leap-io-kernel.com>
Date: Fri, 14 Aug 2026 16:08:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/2] scsi: leapraid: serialize firmware log mmap with
 teardown
To: Linmao Li <lilinmao@kylinos.cn>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: hare@kernel.org, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
 <20260814033845.2971706-3-lilinmao@kylinos.cn>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <20260814033845.2971706-3-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9fff50bbf403aekunmdab1131864e1f1
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlDGEIeVkJCHhhCGU1IGkhLH1YVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlKSklVT0NVSUtVQ0JZV1kWGg8SFR0UWUFZT0tIVUpLSU
	9PT0hVSktLVUpCS0tZBg++
DKIM-Signature: a=rsa-sha256;
	b=II+p1Uw9lwrTdnxuVEdKr9nTTIduNaNQDDC+Iw6O5HIAFX2iStIG4lmU4s7w5ZwRu387PnkqK4DJ2boR/+M+lz451oda//zV5f/mwPayb6fdNKIZjV0hGuwz+pHyaEukiYzR4tbg16d97x1J176668hnB+Y/DvN+5vp3S9bZiTJngAOUo42GzIyRq1ypiA+YRHb9NJxojl0X1Kglna0+/uhDSuKP0pI6PZ0msaO04b9tH3DXbOt8k2QVQjlv9wdTB5vx9+Beuujh4duP6spVBlUDsPPEKtfhIJmwozw4QT0WLM4+ajgU+daDAFWRKB+o5ROYltmMr1H/6UeLCKK9mQ==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=NA5AnBAkyEANOx+4jJ8oFk6V2uAVZwmj1HDQsvAGGsY=;
	h=date:mime-version:subject:message-id:from;

在 2026/8/14 11:38, Linmao Li 写道:
> leapraid_fw_log_exit() waits for mmap_refcnt to reach zero before it
> frees the firmware log buffer.  leapraid_fw_mmap() checks
> host_removing, but it does not increment mmap_refcnt until after
> dma_mmap_coherent() succeeds and the VMA open callback runs.
> 
> Removal can set host_removing and observe a zero mmap_refcnt between
> the check and the VMA open.  It can then free the coherent buffer while
> the mmap path is still establishing a userspace mapping of it.
> 
> Claim a temporary mmap reference while looking up the adapter under
> leapraid_adapter_lock.  Removal deletes the adapter from the same
> locked list after setting host_removing, so a mapping is either
> rejected or included in the count that removal waits for.  Drop the
> temporary reference on the common exit path, after a successful VMA
> open has acquired the reference covering the VMA lifetime.
> 
> Fixes: 5597088c9e79 ("scsi: leapraid: Add new SCSI driver")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
> ---
>  drivers/scsi/leapraid/leapraid_app.c | 12 +++++++++---
>  1 file changed, 9 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid/leapraid_app.c
> index 841027ce2501c..84eef50947aea 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
> @@ -171,7 +171,8 @@ static int leapraid_ctl_validate_sge_offset(struct leapraid_adapter *adapter,
>  	return 0;
>  }
>  
> -static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
> +static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id,
> +							    bool track_mmap)
>  {
>  	struct leapraid_adapter *adapter;
>  	struct Scsi_Host *shost;
> @@ -184,6 +185,8 @@ static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
>  			shost = adapter->shost;
>  			if (!shost || !scsi_host_get(shost))
>  				break;
> +			if (track_mmap)
> +				atomic_inc(&adapter->fw_log_desc.mmap_refcnt);
>  			spin_unlock(&leapraid_adapter_lock);
>  			return adapter;
>  		}
> @@ -589,7 +592,7 @@ static int leapraid_ctl_ioctl_main(struct file *file, unsigned int cmd,
>  		return -EFAULT;
>  	}
>  
> -	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id);
> +	adapter = leapraid_ctl_lookup_adapter(ioctl_header.adapter_id, false);
>  	if (!adapter)
>  		return -EFAULT;
>  
> @@ -728,7 +731,7 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
>  
>  	length = vma->vm_end - vma->vm_start;
>  
> -	adapter = leapraid_ctl_lookup_adapter(adapter_id);
> +	adapter = leapraid_ctl_lookup_adapter(adapter_id, true);
>  	if (!adapter) {
>  		pr_err("%s: No adapter found!\n", __func__);
>  		return -EINVAL;
> @@ -771,6 +774,9 @@ static int leapraid_fw_mmap(struct file *filp, struct vm_area_struct *vma)
>  
>  	rc = 0;
>  out_put:
> +	if (adapter &&
> +	    atomic_dec_and_test(&adapter->fw_log_desc.mmap_refcnt))
> +		wake_up(&adapter->fw_log_desc.mmap_waitq);
>  	leapraid_ctl_put_adapter(adapter);
>  	return rc;
>  }

Thanks for fixing this race. Taking the temporary mmap reference under
leapraid_adapter_lock correctly closes the race with adapter removal.

Reviewed-by: Dongdong Hao <doubled@leap-io-kernel.com>
