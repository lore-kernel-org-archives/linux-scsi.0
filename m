Received: from mta1.migadu.com (out-144.mta1.migadu.com [95.215.58.144])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62ABE3F326F
	for <linux-scsi@vger.kernel.org>; Tue, 25 Aug 2026 10:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.144
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787654703; cv=none; b=npfijeR8byBaK3lYXyNGP6iysFtiteq4tgFe9RbLsQGSm3r035cHdmAz8IMxSR/+Naux4mEgXG8EIUFwkbrgHg7f4WCun3vbJ/IxioxRFH8Mc0otOyMERDDVoVzR9FA+PS7QROqu6d6FEF1iZKLqYFKju8xMivkjC/SJnZXgLK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787654703; c=relaxed/simple;
	bh=5WC2UZBXgeTyuTj/TpglhebfH9qrWxZpjz+I4+99Hto=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=SCEI+HWFPF1UFFJNk7nm5d522fY0lPusf6swvAemlpv0x4ah3IihySiRprh7Y10w0G6beHRQEJwYJK6beZ0FnlaBVLCzVCLOLEVA7NavWPzYCarqYH2AZ9TkmUMhWJeVfujD6OttsjerDUFbCB2OR7OBDCM5gdSEtebpazYoAvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=baW23DUW; arc=none smtp.client-ip=95.215.58.144
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="baW23DUW"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=5WC2UZBXgeTyuTj/TpglhebfH9qrWxZpjz+I4+99Hto=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1787654699; v=1; x=1788259499;
 b=baW23DUWc1lQWVwR1fDzFRcA6Ec0CHv/09y/9xFcLv8nqLDEwkCvwmWONRNOfNxwbLFKq53w
 hERXNFmrfplOu8t58h4c8E4JZGDo3L6yG12q9hyTMV9rPQvuYOzfAw9rWjcXH8wIs8or19rfreH
 jIraH5zNVY4haehTGHqOWzNk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: from [192.168.68.106] (80.176.231.63)
	by mta10.migadu.com with ESMTPS id afb7a9e0f1f19918;
	Tue, 25 Aug 2026 10:44:59 +0000
X-Mizu-Trace-ID: afb7a9e0f1f19918
X-Migadu-Flow: FLOW_OUT
Message-ID: <1586c3fc-eeb2-4601-b8f3-3096a1c30671@linux.dev>
Date: Tue, 25 Aug 2026 11:44:54 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: ips: Fix NULL pointer dereference in ips_release()
To: Yang Zi <2959243019@qq.com>, aacraid@microsemi.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
References: <tencent_F38F19C2D497EC19AF3331BC5030EFEF3307@qq.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <tencent_F38F19C2D497EC19AF3331BC5030EFEF3307@qq.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/25/26 10:25, Yang Zi wrote:
> When ips_insert_device() fails before calling pci_set_drvdata(), the
> PCI device's drvdata is NULL.  The .remove callback ips_remove_device()
> then calls ips_release(NULL), which immediately calls
> scsi_remove_host(NULL).  That dereferences shost->scan_mutex at a fixed
> offset of the NULL pointer, triggering a NULL pointer dereference.
> 
> KASAN report:
> 
>      BUG: KASAN: null-ptr-deref in __mutex_lock_common kernel/locking/mutex.c:625 [inline]
>      BUG: KASAN: null-ptr-deref in __mutex_lock+0x8b/0x1010 kernel/locking/mutex.c:820
>      Read of size 8 at addr 00000000000000d0 by task syz.0.671/5574
> 
>      __mutex_lock+0x8b/0x1010  kernel/locking/mutex.c:820
>      scsi_remove_host+0x24/0x300  drivers/scsi/hosts.c:169
>      ips_release  drivers/scsi/ips.c:654 [inline] [ips]
>      ips_remove_device+0x155/0x2840  drivers/scsi/ips.c:6701 [ips]

You have sent many fixes for similar crashes in other drivers today. How 
did you recreate this? You have this ips HW, right?

> 
> Make ips_release() handle a NULL Scsi_Host by returning early, so the
> remove path is safe when probe never established drvdata.

ips_release() is only called from ips_remove_device(), and this is in 
the driver removal path. This would not be called if the probe fails 
(and pci_set_drvdata() was not called). So there seems to be something 
wrong in ips_insert_device().

> 
> Signed-off-by: Yang Zi <2959243019@qq.com>
> ---
>   drivers/scsi/ips.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/ips.c b/drivers/scsi/ips.c
> index 41ed73966a48..39568a7effb3 100644
> --- a/drivers/scsi/ips.c
> +++ b/drivers/scsi/ips.c
> @@ -649,6 +649,9 @@ static void ips_release(struct Scsi_Host *sh)
>       ips_ha_t *ha;
>       int i;
>   
> +    if (!sh)
> +        return;
> +
>       METHOD_TRACE("ips_release", 1);
>   
>       scsi_remove_host(sh);

