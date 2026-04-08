Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 153603D4131;
	Wed,  8 Apr 2026 16:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775667303; cv=none; b=tWZTxt1MEoX2oiT/SxDt/Ls5uRiv7EMOBC51YRPyq2GFW2yx0DbjeqmlcPUp8CJkCx4brWuBrvxEZb9jLVbywBgtYdvrdsJgSZl2HH2sugON0BIWjO4c9PwthK5E4Gie5GkDGWn/mngbsFaNPKBJQTGMxoZMBbRZJvDF7Og3LQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775667303; c=relaxed/simple;
	bh=l9DP0GH9MCurTbEQAjdMKc4uZTFoMdfijB0YEpGLnNY=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=qbgfCl769l3lP3lkS9nPh/oPud23HDdAQ4miU4ohrR72KRbSXMEN3lGGiM/rxPHVVwFaZV8GqIxuRAsPjpbZ3nA/hvBmt5CgEKFLL9QYURFCJO2n3W1E4Dcq1Wbfz3/qAKK69XPN4RFNtFgQwSjiu5E+OoSRG7GgUyexH0M7ujg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Pb3rU9Qw; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Pb3rU9Qw"
Received: from [10.17.145.186] (unknown [4.194.122.170])
	by linux.microsoft.com (Postfix) with ESMTPSA id 234D120B710C;
	Wed,  8 Apr 2026 09:54:54 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 234D120B710C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1775667301;
	bh=mD29zgGmHKg3hWcuJVIIaqH6LjpveyUTNfBgAyLvtHE=;
	h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
	b=Pb3rU9QwvNHEwiYOVAh5gJPGtC33xq6v0fUTu3ZF84PMTL+oHXI7Di3V/rI70cZeq
	 499g33dTbLEdxy70aRYL2GJXyBJoYlmRt98XSg0m4WEFQqsV+M2LtoXhfuRDeGIdM3
	 MWqOTmVnp3BJ+DIZvXdkDj6A1P+jeFWoW/QYkHj8=
Message-ID: <2a80b7a6-2cfe-4bd0-a799-ff855df7bd41@linux.microsoft.com>
Date: Wed, 8 Apr 2026 09:54:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: kys@microsoft.com, haiyangz@microsoft.com, wei.liu@kernel.org,
 decui@microsoft.com, longli@microsoft.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 apais@microsoft.com, easwar.hariharan@linux.microsoft.com,
 Tianyu Lan <tiala@microsoft.com>, linux-hyperv@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, vdso@hexbites.dev,
 mhklinux@outlook.com
Subject: Re: [PATCH] x86/VMBus: Confidential VMBus for dynamic DMA transfers
To: Tianyu Lan <ltykernel@gmail.com>
References: <20260408073105.272255-1-tiala@microsoft.com>
From: Easwar Hariharan <easwar.hariharan@linux.microsoft.com>
Content-Language: en-US
In-Reply-To: <20260408073105.272255-1-tiala@microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/8/2026 12:31 AM, Tianyu Lan wrote:
> Hyper-V provides Confidential VMBus to communicate between
> device model and device guest driver via encrypted/private
> memory in Confidential VM. The device model is in OpenHCL
> (https://openvmm.dev/guide/user_guide/openhcl.html) that
> plays the paravisor role.
> 
> For a VMBus device, there are two communication methods to
> talk with Host/Hypervisor. 1) VMBUS Ring buffer 2) Dynamic
> DMA transfer.
> 
> The Confidential VMBus Ring buffer has been upstreamed by
> Roman Kisel(commit 6802d8af47d1).
> 
> The dynamic DMA transition of VMBus device normally goes
> through DMA core and it uses SWIOTLB as bounce buffer in
> a CoCo VM.
> 
> The Confidential VMBus device can do DMA directly to
> private/encrypted memory. Because the swiotlb is decrypted
> memory, the DMA transfer must not be bounced through the
> swiotlb, so as to preserve confidentiality. This is different
> from the default for Linux CoCo VMs, so not use DMA(SWIOTLB)
> API in VMBus driver when confidential dynamic DMA transfers
> capability is present.
> 
> Signed-off-by: Tianyu Lan <tiala@microsoft.com>
> ---
>  drivers/scsi/storvsc_drv.c | 28 +++++++++++++++++++++-------
>  include/linux/hyperv.h     |  1 +
>  2 files changed, 22 insertions(+), 7 deletions(-)
> 

Does netvsc not need this same sort of patch?

Thanks,
Easwar (he/him)


