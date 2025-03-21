Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F8A112E7F;
	Fri, 21 Mar 2025 04:44:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742532299; cv=none; b=Ecw9HjSttLYDNSQMSe7lncIUvY80ShJmPEBdXhbNfMolZ6u3l2SEDu47wDV5k0oKIJsi0nV0UARDo71ry+vaF43mDyLb4NJRt4soBDrBgk+HTWuQ+yY+RxnWEDtbVXZQJNfNCHVP6OFFZ4QrLj1r63HN9uVSL9U1R499xS+4PlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742532299; c=relaxed/simple;
	bh=IbP65EIbouZpavoogqTJ0zC+puOuTqdxDlOMKbO3Pw4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=pjivV0mcRqE3AJjn4o6jv9Z121ObsOwYR0SWwv+xvWfqjUXn5Q24ojbLJdcumjXh/TP6qTjb5s8IzL748fU2cRqlofZmDLgYipQUuMoWIUXHU/7v5/obDEFlXXFOXZe7LUrK0GSXu7f1whFuVhTO7mIkwJkZLHNjiNk5Ixg1j/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Q1AbhOLD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Q1AbhOLD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38930C4CEE8;
	Fri, 21 Mar 2025 04:44:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1742532297;
	bh=IbP65EIbouZpavoogqTJ0zC+puOuTqdxDlOMKbO3Pw4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Q1AbhOLDNWE/81pqMX92HPwHIuaro+I+0aXaVBGEyhQ0GlbRWW6vKFZSFmMasuIIl
	 eseD5alkgbe5oW3KKftAeJvBIkelhpLlkFA1OUIN+OLGKHeQTSBjb/q9tBOuPPGooy
	 YyPqTNpJW6szjRq/yuUZpQpaDxYFdsmNf4Rj+Kquu8r8g5RQAYTMQTa+IlXeKDTZah
	 JVhejt7U0MYDWfTufxeDSqcEzJzY2RpGSEi6lmCTmpql/XgAa9r0VOng1Gxo+JAAb1
	 tE4UMofGJMF71SLnBL7wBVGbcWhLfArN2cShbBRt3eymn0iZYDak1RDQHghrK1HrM3
	 2T1lfjV7ZKqag==
Date: Thu, 20 Mar 2025 21:44:55 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: ZhangHui <zhanghui31@xiaomi.com>
Cc: bvanassche@acm.org, alim.akhtar@samsung.com, avri.altman@wdc.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	peter.griffin@linaro.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ufs: crypto: add host_sem lock in ufshcd_program_key
Message-ID: <20250321044455.GB98513@sol.localdomain>
References: <20250317110101.347636-1-zhanghui31@xiaomi.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250317110101.347636-1-zhanghui31@xiaomi.com>

Hi ZhangHui,

On Mon, Mar 17, 2025 at 07:01:01PM +0800, ZhangHui wrote:
> From: zhanghui <zhanghui31@xiaomi.com>
> 
> On Android devices, we found that there is a probability that
> the ufs has been shut down but the thread is still deleting the
> key, which will cause the bus error.
> 
> We checked the Android reboot process and found that it is indeed
> possible that some threads have not been killed before the device
> shutdown, because the Android reboot process will not wait until
> all threads are killed before continuing to execute.
> 
> The call stack is as follows:
> 
> __blk_crypto_evict_key+0x148/0x1c4
> blk_crypto_evict_key+0x38/0x9c
> dm_keyslot_evict_callback+0x18/0x2c
> default_key_iterate_devices+0x40/0x50
> dm_keyslot_evict+0xac/0xfc
> __blk_crypto_evict_key+0xf4/0x1c4
> blk_crypto_evict_key+0x38/0x9c
> fscrypt_destroy_inline_crypt_key+0xb8/0x10c
> fscrypt_destroy_prepared_key+0x30/0x48
> fscrypt_put_master_key_activeref+0xc4/0x308
> fscrypt_destroy_keyring+0xb0/0xfc
> generic_shutdown_super+0x60/0x12c
> kill_block_super+0x1c/0x48
> kill_f2fs_super+0xc4/0x1a8
> deactivate_locked_super+0x98/0x144
> deactivate_super+0x78/0x8c
> cleanup_mnt+0x110/0x148
> __cleanup_mnt+0x14/0x20
> task_work_run+0xc4/0xec
> get_signal+0x6c/0x8d8
> do_notify_resume+0x128/0x828
> el0_svc+0x6c/0x70
> el0t_64_sync_handler+0x68/0xbc
> el0t_64_sync+0x1a8/0x1ac
>
> Let's fixed this issue by adding a lock in program_key flow.
> 
> Signed-off-by: zhanghui <zhanghui31@xiaomi.com>
> ---
>  drivers/ufs/core/ufshcd-crypto.c | 20 +++++++++++++++-----
>  1 file changed, 15 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/ufs/core/ufshcd-crypto.c b/drivers/ufs/core/ufshcd-crypto.c
> index 694ff7578fc1..f3260a072c0c 100644
> --- a/drivers/ufs/core/ufshcd-crypto.c
> +++ b/drivers/ufs/core/ufshcd-crypto.c
> @@ -5,6 +5,7 @@
>  
>  #include <ufs/ufshcd.h>
>  #include "ufshcd-crypto.h"
> +#include "ufshcd-priv.h"
>  
>  /* Blk-crypto modes supported by UFS crypto */
>  static const struct ufs_crypto_alg_entry {
> @@ -17,12 +18,18 @@ static const struct ufs_crypto_alg_entry {
>  	},
>  };
>  
> -static void ufshcd_program_key(struct ufs_hba *hba,
> +static int ufshcd_program_key(struct ufs_hba *hba,
>  			       const union ufs_crypto_cfg_entry *cfg, int slot)
>  {
>  	int i;
>  	u32 slot_offset = hba->crypto_cfg_register + slot * sizeof(*cfg);
>  
> +	down(&hba->host_sem);
> +	if (!ufshcd_is_user_access_allowed(hba)) {
> +		up(&hba->host_sem);
> +		return -EBUSY;
> +	}
> +

It seems broken that the filesystem doesn't get unmounted until after the UFS is
shut down.  It would be helpful to get a clearer picture of exactly why things
are happening in that order.

But disregarding that, it's indeed logical for blk_crypto_evict_key() to return
an error if it cannot fulfill the request.

But I'm wondering if this needs to be solved in the UFS driver itself or whether
the blk-crypto framework should handle this (so that it also gets fixed for
other drivers that may have the same problem).  In block/blk-crypto-profile.c,
pm_runtime_get_sync() is already called before ->keyslot_evict.  So
->keyslot_evict is supposed to be called only when the device is resumed.

The blk-crypto code (in blk_crypto_hw_enter()) doesn't check the return value of
pm_runtime_get_sync(), though.  That seems like a bug.  Is it possible this
issue would be fixed if it checked the return value?

Or does the UFS driver still need to check ufshcd_is_user_access_allowed() too?
If that's the case, I'm also wondering whether it's okay to nest host_sem inside
pm_runtime_get_sync().  Elsewhere in the UFS driver they are called in the
opposite order.

- Eric
