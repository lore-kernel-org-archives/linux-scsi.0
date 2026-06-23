Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CA9637AA9A
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:51:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179516; cv=none; b=iDLol/XjCPLBPT1yUSxFy1U1+6vVXQDQrmn5aAROwrHciemziVlhVhx/Allhhil8dYpU8ptRHajMchnCjC3aVZ7/5TgzPT8TqwMpXkalGe8iz1NBj/ed4cg0cgKwmbwHk/T/AT1YOXRIUNAw1S3xanFocWYiX1uMKv5kNhQFOYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179516; c=relaxed/simple;
	bh=JgadrOXGuw7shtftOX8Ajv+1X19E2THDRMqu5Rztqz8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=pS2wRql2HgukYOS6C91hdoG6BKguws95RHFi6PT3qvGt2Ruv9aHtE1fTfWp2K68pWfiUhzCOQsDovN+GLV8kd0zS2EXMfpl3y7+ix7gpKAwbK2vg5+ULfm1+TeulB2m/MiLPwiy5T/XUSpnH6CFOGg8AdNpx+yBOZ/8aIEl8K8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JT2t68qd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JT2t68qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE85D1F000E9;
	Tue, 23 Jun 2026 01:51:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179515;
	bh=l5EB8vpsb6XhRXdE1deltyLV8eOMwQIqKFcDNApyqKY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JT2t68qdZWz367HdDrKAAFdSCiUoZLRJQ1LnmFvMyVniXdPTdgCX+EiJA+vG6z8pm
	 8P8W4eSx317OmoVK6mMKVw6gBTJrV9/z4+CdACa9snuOs/8pgIwrC8TRMmSdxOUZzs
	 MDZ9E/ALhDwAhW7FQO5C8NFEHpk2J0d6r84+EIG9e2ymcKe1K9Yu2+jWtnIeGj1O02
	 RdH+Up4C15gmjd5wtHJj3b2P1u8rSakF+uEZwWMhZ0/tuRzAv3hXO/G9ssXYMoifz3
	 rLp4TL9FZFQByBGgAJC/Add/Amv9j9d1r1fQqgN33iyeBcout3rf38woyJ6vY1EbeL
	 vmiQs9CGqZVJg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 17/29] ibmvfc: delete NVMe/FC targets as well as SCSI
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-18-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-18-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:51:54 +0000
Message-Id: <20260623015154.CE85D1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [High] Fabric ELS events (LOGO, PRLO, PLOGI) fail to process NVMe targets=
, violating the commit's claim regarding consistent fabric event handling.

Pre-existing issues:
- [High] An integer overflow in the calculation of `sense_len + rsp_len` by=
passes bounds checking, leading to an out-of-bounds read and write in `memc=
py()`.
--

commit 56df0a05e56764e1456bdc6176dcf26a3a1bc6b0
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: delete NVMe/FC targets as well as SCSI

This commit extends target deletion paths to process NVMe targets alongside
SCSI targets. It updates link-down and host reinitialization flows to walk
both lists to maintain consistent target state. It also renames
ibmvfc_relogin to ibmvfc_scsi_relogin.

>     Update link-down, and host reinitialization flows to walk both the SC=
SI
>     and NVMe target lists when marking targets for deletion. This ensures
>     that protocol-specific target state stays consistent across adapter
>     resets and fabric events.

[Severity: High]
Does the current patch fully handle fabric events for NVMe targets?

The commit message mentions maintaining consistent target state across fabr=
ic
events, but it appears ibmvfc_handle_async in
drivers/scsi/ibmvscsi/ibmvfc-core.c was not updated to process the
nvme_scrqs.targets list.

When an NVMe target logs out of the fabric and the adapter sends an async
IBMVFC_AE_ELS_LOGO event, the ELS event handler loop only searches
scsi_scrqs.targets. Can this cause stale NVMe targets to remain in memory
indefinitely and break the target state machine?

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 4b95e43449473..13e513bfd0a86 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c

[ ... ]

> @@ -1920,7 +1928,7 @@ static void ibmvfc_scsi_done(struct ibmvfc_event *e=
vt)
>  				memcpy(cmnd->sense_buffer, rsp->data.sense + rsp_len, sense_len);

[Severity: High]
This is a pre-existing issue, but can an integer overflow occur here when
calculating sense_len + rsp_len in ibmvfc_scsi_done?

If a buggy or compromised virtual I/O server returns a large fcp_sense_len
like 0xFFFFFFFE and a small fcp_rsp_len like 4, their sum could wrap around
to 2.

This wrapped value would bypass the greater than SCSI_SENSE_BUFFERSIZE
bounds check. Since rsp_len <=3D 8 would still be true, could the memcpy ca=
ll
attempt to copy nearly 4GB of data and cause memory corruption?

>  			if ((be16_to_cpu(vfc_cmd->status) & IBMVFC_VIOS_FAILURE) &&
>  			    (be16_to_cpu(vfc_cmd->error) =3D=3D IBMVFC_PLOGI_REQUIRED))
> -				ibmvfc_relogin(cmnd->device);
> +				ibmvfc_scsi_relogin(cmnd->device);
> =20
>  			if (!cmnd->result && (!scsi_get_resid(cmnd) || (rsp->flags & FCP_RESI=
D_OVER)))
>  				cmnd->result =3D (DID_ERROR << 16);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D17
