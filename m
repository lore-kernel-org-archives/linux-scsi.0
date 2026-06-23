Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 885F436729C
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179600; cv=none; b=CLoCVRhwvOtn2eslipgGQ8QgO86Eb+G7jnTllvyYYCIhpUGiN5nNavjtzk8T6C61NMXtHFqfP759VRDj2U7FF9hjYSKsyFRvJSJP3MwlcpwW12hFrOL0E/9AwUaq8QU20HAwf0O/mRPOuJtLfNqZEtQESsd89rLuaFh6U1gynUo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179600; c=relaxed/simple;
	bh=5tbQLF/cug6KEl8ua0iCFu1UvhzGP1XIMrPHaHiOd4g=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=LgdwqK97xERkvwsNCUNni5xCmnEn/yIHajtc81plNq/hsZ3czkw8jaC4F+UZEZ6baKclnBXx/VwfU6uCMKMlviZSCX/EDgSqHzpVBLqe2NvYfcL0aab32EgA0c4L+hNb2DCwl9yVeqwERzlVBi9s3URW/7KCdmHLDvkWP6U6130=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fNNj/Ixq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fNNj/Ixq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151C91F000E9;
	Tue, 23 Jun 2026 01:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179599;
	bh=f2H7wFNwkEsGFKJWXisrvhg6FHSAkpaG6IqWcY4SYo8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=fNNj/IxqavMQSdYpOlYhjTQlm5dQtOXdALCnsdRX682AHJ+N0mS2MBD2xmIrslkUn
	 T9+U0PwwGuYGSvswgx9s0OvLv2/jveot4e/ReBG1Z2+KUKWS71HMwcrO1kz23Bvcq0
	 YLWR6QgFz63xn8ZGhSrMnC6KzE8cN+FM6D26FUo9t+cLbwkRKdmql0HL3iYjBWGcnb
	 ESHuYEIfC0w35AjweAzPS7IskL5MREYX4CbAOQR9v4ujlipUF8ItYfHwq99l/POOgT
	 puvQd3CVINr/I15p+vvWavXm20k2gCCGxr08o3NdxG4R4WHqul2LiPLOIO8OGPyKik
	 fVMGsXN/0pZKg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 13/29] ibmvfc: add NVMe/FC Port Login support
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-14-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-14-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:53:18 +0000
Message-Id: <20260623015319.151C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Targets allocated from a mempool are incorrectly freed using `kfre=
e()` directly, permanently depleting the mempool's reserved elements.
--

commit 6a208595368e371e1b9ab8d0fccb04902f87daf8
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC Port Login support
   =20
Expand the target login path to issue the NVMe/FC-specific port login
MAD for NVMe targets. Select the correct PLOGI MAD opcode based on the
target protocol and include the protocol name in success and failure
logging.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 3e3d77e0d5172..2c54d0b9add49 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -4286,7 +4286,10 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_ta=
rget *tgt)
>  	} else {
>  		plogi->common.version =3D cpu_to_be32(1);
>  	}
> -	plogi->common.opcode =3D cpu_to_be32(IBMVFC_PORT_LOGIN);
> +	if (tgt->protocol =3D=3D IBMVFC_PROTO_SCSI)
> +		plogi->common.opcode =3D cpu_to_be32(IBMVFC_PORT_LOGIN);
> +	else
> +		plogi->common.opcode =3D cpu_to_be32(IBMVFC_NVMF_PORT_LOGIN);
>  	plogi->common.length =3D cpu_to_be16(sizeof(*plogi));
>  	plogi->scsi_id =3D cpu_to_be64(tgt->scsi_id);
> =20
> @@ -4295,7 +4298,7 @@ static void ibmvfc_tgt_send_plogi(struct ibmvfc_tar=
get *tgt)
>  		ibmvfc_set_tgt_action(tgt, IBMVFC_TGT_ACTION_NONE);
>  		kref_put(&tgt->kref, ibmvfc_release_tgt);

[Severity: High]
This isn't a bug introduced by this patch, but does the target release
function deplete the mempool's reserved elements during memory pressure?

The target structure is allocated from the driver's mempool:

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_alloc_target() {
    ...
    tgt =3D mempool_alloc(vhost->tgt_pool, GFP_NOIO);
    ...
}

However, it appears ibmvfc_release_tgt() uses kfree() instead of
mempool_free():

drivers/scsi/ibmvscsi/ibmvfc-core.c:ibmvfc_release_tgt() {
    struct ibmvfc_target *tgt =3D container_of(kref, struct ibmvfc_target, =
kref);
    kfree(tgt);
}

When the system is under memory pressure, mempool_alloc() falls back to
using its pre-allocated reserve elements.

If these elements are returned to the general slab allocator via kfree()
instead of mempool_free(), wouldn't this permanently deplete the mempool's
reserve and cause subsequent allocations under memory pressure to hang
indefinitely?

>  	} else
> -		tgt_dbg(tgt, "Sent port login\n");
> +		tgt_dbg(tgt, "Sent %s port login\n", proto_type[tgt->protocol]);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D13
