Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9788C27603F
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:43:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767395; cv=none; b=p3GMAtTz5+UQjPdMP9z7A9DQJYdgsqofkHdK5nTfOD+rXrC7KacbrJRUVc+eZYiT6/+kKiNP0Thdr1Hp+vazc2PfvI9YyeBEDWLOC/AfFC79s+P4A2s6I9y3crvsDzdqF3HfdbuW076Hq3o0LE+otL34YwvgR1/f0uR8zNzWZvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767395; c=relaxed/simple;
	bh=FzuopbJb5H2CfOcpZtAXIlDNDyJ5frWjZQBhAyxxbEk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=A9lUy2ZsY3C/sQo/7H8F8xSXwrvZUCRbMJqAeMPTc1lhUP9+5LjrUV471S3MrL2rolrh+BaNBv4/EEoAg+oHV55bYdDv1iW/hNFaCHLsRBgl2yaA6IZ/d8dTNRbSjbYJgL2mBG8Ze/8ISTT/r7SFwJUkYIY3O79hmmDDmKOUnN4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ll7irVjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ll7irVjj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24AEF1F000E9;
	Thu, 23 Jul 2026 00:43:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767394;
	bh=xuUD2Ik/IRfvjmB0CnXcWNYpfQjoigh1rP+jhUyAYSM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ll7irVjj644x/xgnZBltdbyXg0HoC/lyxWQxt2DyXMC24EM6AcZI0Zb/38nSlz3/8
	 hXwAMHLXSB4A3a+LGnwRvM4Qk3GlfQK2k/2F3lK6Se6alOxF8s9DxQbflIJHxcxALV
	 D64wa3tVKf7ojAjSy3hrQKdekmomtDD2uGp649WKpKhE8zdmuR5nw1/uDLo8+SHDSq
	 1GQushLij7zxZJTq+bgo1mp7//CTZmFMPekSCw379nk17Mxzl+f0wQjOBgIxUf3qi1
	 X+ZkYgl0eKyWchKe2P2vjC+m4DfOxPlhFmTJ/avbinSvic8I/UVjHZqW6FNDg5LxP9
	 olUKkrgWSVdRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 20/33] ibmvfc: allocate targets based on protocol
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-21-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-21-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:43:13 +0000
Message-Id: <20260723004314.24AEF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] NVMe targets placed on `nvme_scrqs.targets` are completely ignored=
 by the driver's state machine and teardown paths, resulting in memory leak=
s and non-functional targets.

Pre-existing issues:
- [High] Unexpected target state causes `ibmvfc_alloc_target` to fall throu=
gh and allocate a duplicate target with the same WWPN.
--

--- Patch [20]: [PATCH v2 20/33] ibmvfc: allocate targets based on protocol=
 ---
commit c353df4f5747ab4e038043d3b4bccacccf0aa149
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: allocate targets based on protocol

This commit modifies the target allocation logic to place discovered
targets onto either the SCSI or NVMe channel-group lists based on their
protocol. It keeps protocol-specific discovery results isolated for later
traversal.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index b479537e9e78c..92c286cfc69c6 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -5014,6 +5021,7 @@ static int ibmvfc_alloc_target(struct ibmvfc_host *=
vhost,
> =20

[Severity: High]
This is a pre-existing issue, but if a target has moved and its state is not
IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT, the code prints an "Unexpected targ=
et
state" error but fails to abort:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_target() {
        if (wtgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_DELETED_RPORT) {
                ...
                goto unlock_out;
        } else {
                tgt_err(wtgt, "Unexpected target state: %d, %p\n",
                        wtgt->action, wtgt->rport);
        }
    } else if (stgt) {
        ...
    }
    spin_unlock_irqrestore(vhost->host->host_lock, flags);

Because it lacks a "goto unlock_out;" or "return;" in the else branch, does
this execution fall through to the mempool_alloc() below and erroneously
allocate a duplicate target with the same WWPN?

>  	tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
>  	memset(tgt, 0, sizeof(*tgt));
> +	tgt->protocol =3D protocol;
>  	tgt->scsi_id =3D scsi_id;
>  	tgt->wwpn =3D wwpn;

[ ... ]

> @@ -5042,7 +5050,11 @@ static int ibmvfc_alloc_targets(struct ibmvfc_host=
 *vhost)
>  	int i, rc;
> =20
>  	for (i =3D 0, rc =3D 0; !rc && i < vhost->scsi_scrqs.num_targets; i++)
> -		rc =3D ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i]);
> +		rc =3D ibmvfc_alloc_target(vhost, &vhost->scsi_scrqs.disc_buf[i],
> +					 vhost->scsi_scrqs.protocol);
> +	for (i =3D 0; !rc && i < vhost->nvme_scrqs.num_targets; i++)
> +		rc =3D ibmvfc_alloc_target(vhost, &vhost->nvme_scrqs.disc_buf[i],
> +					 vhost->nvme_scrqs.protocol);

[Severity: High]
When the hypervisor returns NVMe targets during discovery, they are allocat=
ed
and added to vhost->nvme_scrqs.targets here. Are these targets ever cleaned=
 up?

Since the rest of the driver's state machine and teardown paths (like
ibmvfc_remove) currently only iterate over vhost->scsi_scrqs.targets, it
appears these NVMe targets might be completely ignored.

Could this cause a leak of the mempool objects and leave active timers
running that might trigger use-after-free bugs after module removal?

> =20
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D20
