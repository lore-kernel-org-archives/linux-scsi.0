Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E13E8437135
	for <linux-scsi@vger.kernel.org>; Wed, 19 Aug 2026 11:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787140334; cv=none; b=j6kp850GAd43s6ROkhNgBPyIV5xIl3n9Fy+0mcqjOTKejFhbBrPxFgF1f+yz4YqeqGLgpQqYtLgkrJsFxRmdPrmUTyW3XZgNU21/8ABszo3G1qkaANqb1vypt5nMKsA5sfT/2LQEGyBuwdJOF66aLWj2Yg9jQnGePXaBYK/3lXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787140334; c=relaxed/simple;
	bh=4+VbLL+xFgpM0N8aviozCeCybkMUnov+jFDWLDKdgYs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=iSzUj16owCfqZ0HfKRS678TByh9M2/2bFzNC4r/CnE6wQLW7cRWnd8p9GajlZENW6lhnm+kVtglBj63oqhGXIzQw5bp6ldXZ3kyMDGt2Pax+JfuiPigD5J70znzEMSC+dqCU68GPCePVrYciWPUpqpTqAcWQc3/e/99DHkgOGIw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PKY4XuYA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PKY4XuYA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D46EB1F00A3A;
	Wed, 19 Aug 2026 11:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787140332;
	bh=Z5LpB/kJQ1erqRpy8EYxhAp53G2PhPsM68ms5HP87EA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PKY4XuYARkUdcHbT5rtkFUp00tXC0qxat/IGWLBHsacCWSnw/i7M2MYm0uz6rnPqM
	 dTASFQoWUw7hACL+em7aODt/szVzusgfRHaIAtIDNVfPWj3mKf53zb6xIsNF+spipf
	 vqLFr91hT3CeWJ89T4NQ7f04/RFVdPoSF/kV+Edz0g1BzBJkvKj4j0/XJwnoCdSIW0
	 owmcFHh10y8TkkWZQ+QZy6KBuK+DoL+2prOIrxYdzM0aiK2cjiKqlAutll6f7kM/YD
	 kOEAacEAuW49aasoJ7KIbYPGPF5hmOaMj1VmOrp3yduP5eVABlJp8nzuLBGTdsXs0F
	 NHWdNA9pG4xLA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] scsi: fnic: free the NVMe port template from the
 delete callback
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linmao Li" <lilinmao@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260819114242.3598034-3-lilinmao@kylinos.cn>
References: <20260819114242.3598034-1-lilinmao@kylinos.cn>
 <20260819114242.3598034-3-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 19 Aug 2026 11:52:11 +0000
Message-Id: <20260819115211.D46EB1F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

New issues:
- [Critical] Relocating `kfree(iport->nv_tmpl)` to the asynchronous `nvfnic=
_local_port_delete()` callback introduces a severe arbitrary free and memor=
y corruption vulnerability if the unregister process times out.

Pre-existing issues:
- [Critical] The driver's bounded timeout design for NVMe FC unregistration=
 leaves the `fnic` structure vulnerable to a Use-After-Free when deferred c=
allbacks execute.
--

--- Patch [2]: [PATCH 2/2] scsi: fnic: free the NVMe port template from the=
 delete callback ---
commit 99ed8cf7442e7f3171f98e582e611d65cec9862a
Author: Linmao Li <lilinmao@kylinos.cn>

scsi: fnic: free the NVMe port template from the delete callback

This commit attempts to fix a dangling pointer issue by moving the
freeing of the NVMe port template to the deferred local port delete callbac=
k,
tying its lifetime to the transport's use instead of a bounded timeout.

> diff --git a/drivers/scsi/fnic/fnic_nvme.c b/drivers/scsi/fnic/fnic_nvme.c
> index 00d9d5d439a38..a8b7b7d40b9ab 100644
> --- a/drivers/scsi/fnic/fnic_nvme.c
> +++ b/drivers/scsi/fnic/fnic_nvme.c
> @@ -1243,7 +1243,6 @@ void nvfnic_nvme_unload(struct fnic *fnic)
>  				WARN_ON(1);
>  			}
>  			iport->flags &=3D ~FNIC_LPORT_NVME_REGISTERED;
> -			kfree(iport->nv_tmpl);
>  		}
>  	}

[ ... ]

> @@ -1669,6 +1668,9 @@ void nvfnic_local_port_delete(struct nvme_fc_local_=
port *lport)
>  	FNIC_NVME_DBG(KERN_INFO, fnic, "lport delete 0x%x\n",
>  		      iport->fcid);
> =20
> +	kfree(iport->nv_tmpl);

[Severity: Critical]
Does moving this kfree() here introduce an arbitrary free if the unregister
process times out?

If the bounded timeout in nvfnic_nvme_unload() expires:

nvfnic_nvme_unload()
    time_remain =3D wait_for_completion_timeout(fnic->nvme_lport_unreg_done,
                                              msecs_to_jiffies(time_wait));

The driver can abandon the wait and eventually free the fnic structure, whi=
ch
embeds the iport. When the transport later invokes this deferred callback,
the iport pointer will point to freed memory.

Could this cause the kernel to execute an arbitrary free by passing a
corrupted iport->nv_tmpl pointer to kfree()?

> +	iport->nv_tmpl =3D NULL;
> +
>  	spin_lock_irqsave(&fnic->fnic_lock, flags);

[Severity: Critical]
This is a pre-existing issue, but does the bounded timeout design for NVMe =
FC
unregistration leave the fnic structure vulnerable to a use-after-free?

Similar to the issue above, if the wait_for_completion_timeout() in
nvfnic_nvme_unload() expires and the driver frees the fnic structure, this
callback will attempt to acquire fnic->fnic_lock on freed memory.

Since the transport can asynchronously invoke the localport_delete callback
long after the driver has given up waiting, is it safe to dereference the f=
nic
pointer here?

>  	if (fnic->nvme_lport_unreg_done)
>  		complete(fnic->nvme_lport_unreg_done);

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260819114242.3598=
034-1-lilinmao@kylinos.cn?part=3D2
