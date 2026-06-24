Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B7DC40D57C
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jun 2026 05:17:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782278254; cv=none; b=GhZ3lJc8guRQl2aKgvXFcK+Pw+kaDNuwaTr+ov13z2gYBZw/9/nVeyo3CRK16F2cC/62gC3N/yqsKrOmDRJubSHkZJy5h8pXEj/UXeIgV7e6WILflr4pMch4O4I8Xdhn6ZdAFX038qKTuHK7ueawftw5wgEl8exeKua9+F8eVd0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782278254; c=relaxed/simple;
	bh=wVcaM3uK8bwL8u0Roxr72ygKc0iW4qI/XchsiyUooiQ=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mmMqLv0wIU8udqYmdW3vS6skpfEw+wiB63mKHqLhHN2YsNX/Cz+Wqy/r0b3IFr6YKcOOgH6DmvADfOYacNehRZv3NtKqR1X9bqzlnWU+ujdc6eMqbGblyL5iYJO5ld1sTD3p5MXl+Jr7anKI2TRHS7RZy0VBPD+b6b9tjTXyIls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DXug/A/V; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DXug/A/V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4A361F000E9;
	Wed, 24 Jun 2026 05:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782278253;
	bh=793kcWiS/svuvcy2SyL+5Hxv4il/4QFXHCFbQKWA9Ls=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DXug/A/VfWsS+4/gEG9ZIXeirCDUeu5TA6av2ljl32rauXlEPOu0tWRMbNi/axYFv
	 lJ5wn9IPvZ8t2Co0AqDxyFeiWYH0/XVcMEI3E7Je20av8PubnpoRSFW91O6redM5KL
	 e+D3E5ztgsfagtiyn9nPgoikIBfC6rGWg+eHU7K1dDpCIhJkbWWIfNm9TKQfWzqPcv
	 yKho70yarKRywWAK4Fn9Fpv40UC9Ol/cR/ROpiuEXVbgijP/Vm0w4r1rzeVyKKGqbU
	 JOY4FdDqAozL5gHZyOtMFKIbbdMLktAWqwNhOX7n4X4dCZgMaMoAHctWnW+UpEvszM
	 rWCaJh+pJyreg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v5 12/13] scsi: fnic: Expose NVMe transport state in
 debugfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260624044334.3079-13-kartilak@cisco.com>
References: <20260624044334.3079-1-kartilak@cisco.com>
 <20260624044334.3079-13-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 24 Jun 2026 05:17:32 +0000
Message-Id: <20260624051732.C4A361F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The NVMe debugfs file is created and exposed to user space before =
the data structures and locks it depends on are initialized, creating a rac=
e condition that can trigger a NULL pointer dereference and uninitialized s=
pinlock access.
--

commit 82342d5cda06cd97fbd3a125f13faf76b39082ad
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Expose NVMe transport state in debugfs

Create an NVMe debugfs directory with a per-host nvmef_info file,
reporting local-port and target-port identifiers for NVMe initiator
instances.

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index df8c8ebbc32b9..245db1b992b51 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
[ ... ]
> @@ -933,6 +933,7 @@ static int fnic_probe(struct pci_dev *pdev, const str=
uct pci_device_id *ent)
>  		err =3D -EOPNOTSUPP;
>  		goto err_out_fnic_role;
>  	case VFCF_FC_NVME_INITIATOR:
> +		fnic_nvmef_debugfs_init(fnic);

[Severity: High]
Is it safe to create and expose the debugfs file nvmef_info this early in
the probe sequence?

At this point in fnic_probe(), the fnic structure has been allocated with
kzalloc(), but critical structures like fnic_lock and iport->tport_list
haven't been initialized yet. They appear to be initialized later in the
function or in fnic_fdls_init().

If a process concurrently opens and reads this debugfs file right after
fnic_nvmef_debugfs_init() returns, could it trigger a crash?

>  		fnic->role =3D FNIC_ROLE_NVME_INITIATOR;
>  		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
>  			fnic->fnic_num);
[ ... ]
> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index e322dd4dcb787..a19dd9cf76cf9 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
[ ... ]
> @@ -188,6 +188,36 @@ void nvfnic_release_nvme_ioreq_buf(struct fnic_iport=
_s *iport,
>  			     fnic->io_sgl_pool[io_req->sgl_type]);
>  }
> =20
> +int nvfnic_get_nvmef_info(struct fnic *fnic, struct fnic_nvmef_info *inf=
o)
> +{
> +	int len =3D 0;
> +	struct fnic_iport_s *iport =3D &fnic->iport;
> +	int buf_size =3D info->buf_size;
> +	struct fnic_tport_s *tport;
> +	struct fnic_tport_s *next;
> +	unsigned long flags;
> +
> +	if (buf_size <=3D 0)
> +		return 0;
> +
> +	len +=3D scnprintf(info->info_buffer + len, buf_size - len,
> +			 "lport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
> +			 iport->wwpn, iport->wwnn, iport->fcid);
> +
> +	spin_lock_irqsave(&fnic->fnic_lock, flags);
> +	list_for_each_entry_safe(tport, next, &iport->tport_list, links) {

[Severity: High]
If nvfnic_get_nvmef_info() is executed concurrently before the fnic
struct is fully initialized, will this attempt to acquire an
uninitialized fnic_lock?

Furthermore, if iport->tport_list is still zeroed from the kzalloc(),
the list_for_each_entry_safe() macro expects a properly initialized
list head. Could passing a zeroed list head cause a NULL pointer
dereference when computing the next pointer for the first entry?

> +		if (len >=3D buf_size - 1)
> +			break;
> +
> +		len +=3D scnprintf(info->info_buffer + len, buf_size - len,
> +				 "tport wwpn 0x%llx wwnn 0x%llx fcid 0x%06x\n",
> +				 tport->wwpn, tport->wwnn, tport->fcid);
> +	}
> +	spin_unlock_irqrestore(&fnic->fnic_lock, flags);
> +
> +	return len;
> +}
> +

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624044334.3079=
-1-kartilak@cisco.com?part=3D12
