Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D43521D555
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 00:53:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784767985; cv=none; b=I1+b3e7aTN4kdtmE9qKzLRdg+NjOoCPV1a9oVkfJOoJ05WlTKo+YlWOTVxPOtaCE6D31w9hE7w+/BRurch0DYP0IRDZUP/rln1V5BJC11D9Ice/nhKmWA2lBRtO7S82x6FhpIqzJBIop+xz+gjQ0z3abORYH5cx9FzAaI8gpAec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784767985; c=relaxed/simple;
	bh=o2qmonYdPS3qFREQwF9ugKZCpjNE2C1PC3h4L8WLYy4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BzxEj0h1s926xY4JkTqYBmzMXa0XvUdCofDQrDpF9mQ4MgN1oOBH1uDwpjvoiWiCPGPCVoxCONdne7A1BHjN/XDdbhWrRKTRKAN4fg+myfKWyqIGbzSygu9COkwLa70HtjmRVgkN285/XLFBkycoTDIUMt460p+0JXBQJbRFdr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rj2gielj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rj2gielj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4C91F000E9;
	Thu, 23 Jul 2026 00:53:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784767984;
	bh=P1KaWMqvLZbtsCz5XgxYDi+4QYb3ypJERYDXjLEDiks=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Rj2gieljFYDGlUlA+IwZ53htSOz+ynOS4qUXn4eQcC6wa9e8UAwZxa44q6f3Hd7NP
	 6SF9YQ+IGMah8JYGv8d+WJgFuRLyU29SguPtqOqbE9VyvMclsJ0mC0miUOmQIvYGBW
	 eBebe2+M6qZbNlOkDK7UQpx3JJUogpX3gyg9fBGn4O0b4iP6YDsx6Nl1uGjId+SaGQ
	 XtgV3aiGoAo53DndEmzJHpklrSeuoka2POXTTNnMzuxay/QdKkTltcMRVFb9URd6bi
	 5dV7+heJBhxOcdYHfDuzyEq6BzJMfyiLcsIVfsG4M+ASYXZ1klAzTEbVnx3N9fTdlE
	 675CQW4lQ4haA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 22/33] ibmvfc: update state machine to process
 NVMe/FC targets
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723000149.969416-23-tyreld@linux.ibm.com>
References: <20260723000149.969416-1-tyreld@linux.ibm.com>
 <20260723000149.969416-23-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 00:53:03 +0000
Message-Id: <20260723005304.5D4C91F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The state machine loops were only partially updated for NVMe targe=
ts, missing the terminal deletion loop in `ibmvfc_do_work` and the rport ad=
dition loop in `ibmvfc_rport_add_thread`.
--

--- Patch [22]: [PATCH v2 22/33] ibmvfc: update state machine to process NV=
Me/FC targets ---
commit caac2c6b6503f6fc5585805d7ed766e74dd3cfa7
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: update state machine to process NVMe/FC targets

Update the host work loop and target state-machine helpers to process
NVMe targets in addition to SCSI targets.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc-core.c b/drivers/scsi/ibmvscsi/=
ibmvfc-core.c
> index 1185d72a8a734..ff84ca0f9f45a 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc-core.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc-core.c
[ ... ]
> @@ -5988,6 +6018,12 @@ static void ibmvfc_do_work(struct ibmvfc_host *vho=
st)
>  				break;
>  			}
>  		}
> +		list_for_each_entry(tgt, &vhost->nvme_scrqs.targets, queue) {
> +			if (tgt->action =3D=3D IBMVFC_TGT_ACTION_LOGOUT_RPORT) {
> +				tgt->job_step(tgt);
> +				break;
> +			}
> +		}
> =20
>  		if (ibmvfc_dev_logo_to_do(vhost)) {
>  			spin_unlock_irqrestore(vhost->host->host_lock, flags);

[Severity: High]
Does this code introduce a regression by missing the equivalent terminal
deletion loop for NVMe targets?

While this block handles IBMVFC_TGT_ACTION_LOGOUT_RPORT for nvme_scrqs.targ=
ets,
shortly after this in ibmvfc_do_work() there is a loop for SCSI terminal
deletion (handling IBMVFC_TGT_ACTION_DEL_RPORT and
IBMVFC_TGT_ACTION_DEL_AND_LOGOUT_RPORT) that doesn't appear to be updated to
include vhost->nvme_scrqs.targets.

If that loop is omitted, won't NVMe targets marked for deletion remain in t=
he
list indefinitely, failing to cancel their timers and leaking the target me=
mory?

Additionally, looking at ibmvfc_rport_add_thread(), it only iterates over
vhost->scsi_scrqs.targets. Should NVMe targets that have tgt->add_rport =3D=
 1
also be processed there? If they are ignored by the worker thread, it appea=
rs
they will never be passed to ibmvfc_nvme_register_remoteport(), preventing =
the
NVMe targets from registering with the transport.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723000149.9694=
16-1-tyreld@linux.ibm.com?part=3D22
