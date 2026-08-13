Received: from mail-m32113.qiye.163.com (mail-m32113.qiye.163.com [220.197.32.113])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A86330301;
	Thu, 13 Aug 2026 07:12:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=220.197.32.113
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786605130; cv=none; b=Z3xu7LyR6nIm8/fE7waDovB7e9dobfj3A2EVxqG4RyHaQqANn640coT6Vy+EySIOkhBzPFwTaraTIJ5j2duvTJvsrxqFlXVUXA223iGfU6ErpK8RTpljX+cVwiTSghGQ/gKkUxpB0m7kyoflSjq3cySbLoymDhtdBSRJgj7ylTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786605130; c=relaxed/simple;
	bh=YHCvSJNGOvKIH8srICMmwmvs56ymvA0w9uNR6qYykYA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pTh8HyHdcCsRoKGu1Pa/l8SVgiOS8cb6AxSF8h3/dzcR0OWvLcCQzKNFa6sUwbymG3Hrlyj0c8rBnbrYSth1BzWu0J35lYTs5Swi4Wl0R8ECWuif0vUEmjQLZwM9faaZrsq7599OVlKCIf5agDJ4DC82E/hVVEMZ73iRDSdQQwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com; spf=pass smtp.mailfrom=leap-io-kernel.com; dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b=FeMCqx4C; arc=none smtp.client-ip=220.197.32.113
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leap-io-kernel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leap-io-kernel.com header.i=@leap-io-kernel.com header.b="FeMCqx4C"
Received: from [IPV6:2001:da8:e800:71f4:5c8e:2823:7a5:5139] (unknown [IPV6:2001:da8:e800:71f4:5c8e:2823:7a5:5139])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49d523870;
	Thu, 13 Aug 2026 14:36:27 +0800 (GMT+08:00)
Message-ID: <719a2f4c-0198-4d80-8184-5bd5aaa73dfd@leap-io-kernel.com>
Date: Thu, 13 Aug 2026 14:36:25 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: leapraid: serialize firmware log mmap with
 teardown
To: Linmao Li <lilinmao@kylinos.cn>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: hare@kernel.org, dlemoal@kernel.org, linux-kernel@vger.kernel.org
References: <20260811112001.1158587-1-lilinmao@kylinos.cn>
 <20260811112001.1158587-3-lilinmao@kylinos.cn>
From: Hao Dongdong <doubled@leap-io-kernel.com>
In-Reply-To: <20260811112001.1158587-3-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9ff9d61faf03aekunm631be5fd55ce1a
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVlCSUlDVk8YQxhDHhkZGR1NGlYVFA
	kWGhdVEwETFhoSFyQUDg9ZV1kYEgtZQVlJS0tKQR8aQ0EeQ0tLQUxKHU9BThhDHkFJQ0lIQUwaTk
	FOSkhCWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1VKQktLWQY+
DKIM-Signature: a=rsa-sha256;
	b=FeMCqx4CWLyDulyK8/pzvI1nvw1PoKlK2GOBLaEIxVJMXBwCcrB5VXnaIXIxdjJeZ9+KdMeIsC5Ybr19n37YoCm/Tvu8/2yNco+2VU8oftc93+XpzALttpQRpuPztPgQu7wGDheTjxKHfpmR//LAw1EcRipvuE1ipm0CogytvF/s6qEtmp5VFv2Dy8K8oK8IrS1Sqj7AroAEhWIxcdZNmYDP5Se9OGW2NVqWMWWqLGJarp3TYmhoqriDf9iff04+C7SrWt4971/P/+Mj9U4g8SJA58HiZSgFy+wvGMHjwvAVnoeu/f1G7Qk4iqT7odLqczEnlCKJYIi9SM5pmdIHNA==; c=relaxed/relaxed; s=default; d=leap-io-kernel.com; v=1;
	bh=jNqkXuuWzYztlEg1iZKK/WBpPZ9ME5Rx7ycV/xXobek=;
	h=date:mime-version:subject:message-id:from;

在 2026/8/11 19:20, Linmao Li 写道:
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
> index 841027ce2501c..c124f9eaea6ea 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
> @@ -171,7 +171,8 @@ static int leapraid_ctl_validate_sge_offset(struct leapraid_adapter *adapter,
>  	return 0;
>  }
>  
> -static struct leapraid_adapter *leapraid_ctl_lookup_adapter(int adapter_id)
> +static struct leapraid_adapter *
> +leapraid_ctl_lookup_adapter(int adapter_id, bool track_mmap)

Hi Linmao,

Thank you for identifying and fixing this race. Your analysis and fix
are correct.

I have only one minor comment: why the line break here? This declaration
fits within the line-length limit, so please keep the return type and
function name on the same line to follow the usual kernel coding style.

With this minor formatting issue addressed, I will be happy to accept
the patch. Thanks again!

Best regards,
Dongdong

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
