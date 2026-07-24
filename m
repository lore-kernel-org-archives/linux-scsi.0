Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE2C62E7F2C
	for <linux-scsi@vger.kernel.org>; Fri, 24 Jul 2026 18:07:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784916423; cv=none; b=cqDEydKYWrwQlOGo+uEIXZM4HsfzUBc/JHWf1jvWkeWxGMK7cmQalvfEM3+IICGwnAX8aj3YlHNbIVyvFZJFgPfoO0xxypDeT9Akb/TWnRCQzcqfTJVMSj88rIYJC0mDWzCDik6pzI4ukjINQ8QO27hDnzGirKAYa4pb4LYVaBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784916423; c=relaxed/simple;
	bh=Hmm2XEA2iMwa2UqCy/HW1Ygoz6/I0Fsa9HOX2SuXUC4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ZK0MAd+nXy59ddqIg+IMzfYerYpVwHKzwNba50si8Sawig2g1xJ8PkRP99QAddQ+xUNeZsSZWA25FRPcQQJfLt4udwqhtN1TwBEzYVCXixXjTCb9c1nSXbmSukfktL3Jcor8XMXb3GJ5tcEsG3m7+bzJenqQV/n4zLPoZKFof/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dYkKqdfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dYkKqdfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 22B711F000E9;
	Fri, 24 Jul 2026 18:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784916422;
	bh=3i58I2pANZNNZGv28TPiTV8ozjlfqvRLlel6U1SWM2A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dYkKqdfciqyvvsNaqwlX950E5smymqaIdXJ+Ua+CSgCKJ5ClDNcqbVvK3n/bhuWvI
	 lLguXGBIqmTl4/xvjo2sakvQ1J9tbj9tPtJG37wnTQvV9P59HO+hYshnvNzhDkoHMM
	 4Z3VtJMObV23db6jOGQlNEGUbw+apVrlXl7Uv3fd+iIpCkuw6EXPzGacinf+SauulI
	 FV1rKhNUzX3chopTk/c7tSYMmL68uD2GKBERxxRGcmlAYq36hsrNwv9UF/TEZEy1QH
	 g59J4/3HmC4q4xIKnvBBBGB26FD3Z1WqDLzFl+QqtX5svH5fxF8+gpItLPFJ1OCr/1
	 Qb5m1dUYjQnZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/13] scsi: fnic: Decode firmware role configuration
Reply-To: sashiko-reviews@lists.linux.dev
To: "Karan Tilak Kumar" <kartilak@cisco.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260724174811.5118-4-kartilak@cisco.com>
References: <20260724174811.5118-1-kartilak@cisco.com>
 <20260724174811.5118-4-kartilak@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 24 Jul 2026 18:07:01 +0000
Message-Id: <20260724180702.22B711F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Probing a device configured as an NVMe initiator causes guaranteed=
 NULL/invalid pointer dereferences because `fnic->host` is never allocated.
--

--- Patch [3]: [PATCH v6 03/13] scsi: fnic: Decode firmware role configurat=
ion ---
commit 59ee4f0111b49617d84eeb07cca8bec4e3b8d757
Author: Karan Tilak Kumar <kartilak@cisco.com>

scsi: fnic: Decode firmware role configuration

This commit adds FNIC_ROLE_CONFIG_MASK to decode firmware role bits when
reading vNIC configuration. It accepts FCP and NVMe initiator roles,
reports target roles as unsupported, and logs the configured role flags.

> diff --git a/drivers/scsi/fnic/fnic_main.c b/drivers/scsi/fnic/fnic_main.c
> index 7c7f9ea5267b9..3a365ea455b1a 100644
> --- a/drivers/scsi/fnic/fnic_main.c
> +++ b/drivers/scsi/fnic/fnic_main.c
[ ... ]
> @@ -863,8 +863,27 @@ static int fnic_probe(struct pci_dev *pdev, const st=
ruct pci_device_id *ent)
>  					fnic->fnic_num);
>  		}
>  		break;
> +	case VFCF_FC_TARGET:
> +		dev_info(&fnic->pdev->dev,
> +			 "fnic: %d is scsi target\n",
> +			 fnic->fnic_num);
> +		err =3D -EOPNOTSUPP;
> +		goto err_out_fnic_role;
> +	case VFCF_FC_NVME_INITIATOR:
> +		fnic->role =3D FNIC_ROLE_NVME_INITIATOR;
> +		dev_info(&fnic->pdev->dev, "fnic: %d is NVME initiator\n",
> +			fnic->fnic_num);
> +		break;

[Severity: High]
If a device is configured as an NVMe initiator, this case breaks out of the
switch block without allocating fnic->host (unlike the VFCF_FC_INITIATOR
case). Could this cause a NULL pointer dereference later on?

For example, if an error occurs shortly after this in fnic_probe(), the
teardown path unconditionally calls:

err_out_fnic_set_intr_mode:
        scsi_host_put(fnic->host);

Since scsi_host_put() resolves the host pointer internally, passing NULL
results in an invalid offset pointer passed to put_device(), crashing the
kernel.

Additionally, does the success path unconditionally dereference the
unallocated host in fnic_scsi_drv_init()?

fnic_probe() -> fnic_scsi_drv_init() {
        ...
        if (fnic->config.io_throttle_count !=3D FNIC_UCSM_DFLT_THROTTLE_CNT=
_BLD)
                host->can_queue =3D min_t(u32, FNIC_MAX_IO_REQ, ...);
        ...
}

> +	case VFCF_FC_NVME_TARGET:
> +		dev_info(&fnic->pdev->dev,
> +			 "fnic: %d is NVME target\n",
> +			 fnic->fnic_num);
> +		err =3D -EOPNOTSUPP;
> +		goto err_out_fnic_role;
>  	default:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260724174811.5118=
-1-kartilak@cisco.com?part=3D3
