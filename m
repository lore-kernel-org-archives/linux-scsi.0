Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E01863A6B71
	for <linux-scsi@vger.kernel.org>; Thu,  2 Jul 2026 18:17:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783016280; cv=none; b=JAvGmr+Teqc+FSoZXxD+7750XdrVd+YcaqQglBD9RZpgxpQSjCLuLvvJbuVTkopL8GLPc+oCclEVjivDn3X8v3y25dUbPxXn3EO2nu9RerKARPpoUrp7X05Sclk/bhyIdkYIVvOeBfmau9f6NSwhQP9SEElTfGQW3ar3zfusmvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783016280; c=relaxed/simple;
	bh=NmHTfqtz2GV8JkavBo2jBm25TQrSJ038RBeCxBfo3i8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=ldbmPEcU8GDrq3gcx1A91qqqDzIal13UTqaZp7pSHgKe6e+/muCmxqJPhddDHc7eB+6XAxAxWRhsu+rn9tSMEMpOiyQFlSN8jkc+G/d4Ued3aAORcjOGPL5swmVlnGEviUzX5MxKx/sfjBaoT0hrc5ynOdXea1Heh81LP2M34gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iHHRKZfc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iHHRKZfc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68DA31F000E9;
	Thu,  2 Jul 2026 18:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783016278;
	bh=NyF1xnkY4it//iIY9JXTZ9iCl1iycvzhH14nSohWRRQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iHHRKZfcE6y8o9D0JzpbpSpIFAPKU5aVtu8TkK9cXPksfzH+JB+4bv28LjEzz7zuK
	 b3MBAiVWnnJqEZw9xPkC+j2/KwfqJm/oZr1PH2/qSboNDmIqoDL097fWHm/sUTmoG3
	 viUNR57h5MW55fd35gSwtG7ZT7Da3mWJ0yTvSt4Fs4BCkdf7+Te/6SqRBNWFhd6679
	 LKSI4OsCPcvi2s53JwcWkSpZgEPBCsTP5y7KS30QUxrkuEF2Jnnh6jxFQD6OoEIaCz
	 DwlfLxaq/5GK2EbY0U2+dphmCaNu6Hw2zbYaboGuENSFBBQ6ACaFiDtAT0VBFcgz8H
	 SkAWcAkjN1fmA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/8] ibmvfc: make ibmvfc login to fabric
Reply-To: sashiko-reviews@lists.linux.dev
To: "Dave Marquardt" <davemarq@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260702-ibmvfc-fpin-support-v3-3-d95b9547cf88@linux.ibm.com>
References: <20260702-ibmvfc-fpin-support-v3-0-d95b9547cf88@linux.ibm.com>
 <20260702-ibmvfc-fpin-support-v3-3-d95b9547cf88@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 02 Jul 2026 18:17:57 +0000
Message-Id: <20260702181758.68DA31F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A recursive spinlock deadlock occurs if `ibmvfc_send_event()` fail=
s to send the newly allocated Fabric Login MAD event.
--

commit f65f56e7064cfb403146e98d083f3a2365344ff8
Author: Dave Marquardt <davemarq@linux.ibm.com>

ibmvfc: make ibmvfc login to fabric

Add support for fabric login in order to support the asynchronous
event queue with its own interrupt as required by NPIV specification
to support the asynchronous sub-queue and interrupt and full and
extended FPIN messages.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvf=
c.c
> index 110d77b9aac32..6dd1e726d9b94 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c

[ ... ]

> @@ -5261,6 +5261,88 @@ static void ibmvfc_discover_targets(struct ibmvfc_=
host *vhost)

[ ... ]

> +static void ibmvfc_fabric_login(struct ibmvfc_host *vhost)
> +{
> +	struct ibmvfc_fabric_login *mad;
> +	struct ibmvfc_event *evt;
> +	int level =3D IBMVFC_DEFAULT_LOG_LEVEL;

[ ... ]

> +	ibmvfc_init_event(evt, ibmvfc_fabric_login_done, IBMVFC_MAD_FORMAT);
> +	mad =3D &evt->iu.fabric_login;
> +	memset(mad, 0, sizeof(*mad));
> +	mad->common.opcode =3D cpu_to_be32(IBMVFC_FABRIC_LOGIN);
> +	mad->common.version =3D cpu_to_be32(1);
> +	mad->common.length =3D cpu_to_be16(sizeof(*mad));
> +
> +	ibmvfc_set_host_action(vhost, IBMVFC_HOST_ACTION_INIT_WAIT);
> +
> +	if (ibmvfc_send_event(evt, vhost, default_timeout))
[Severity: High]
This is a pre-existing issue, but does this replicate a recursive spinlock
deadlock pattern if the event transmission fails?

If ibmvfc_send_event() encounters a failure (such as a hypervisor error), i=
ts
error path synchronously calls evt->done(evt).

Because this is initialized as a MAD event, the callback is handled by
ibmvfc_locked_done(), which unconditionally attempts to acquire
vhost->host->host_lock.

When called from an event completion handler like ibmvfc_channel_setup_done=
()
which already holds the host lock, could this sequence occur:

ibmvfc_channel_setup_done() (holds host_lock)
  -> ibmvfc_fabric_login()
    -> ibmvfc_send_event()
      -> evt->done(evt) (which is ibmvfc_locked_done)
        -> spin_lock_irqsave(evt->vhost->host->host_lock, flags)

and cause the CPU to deadlock?

> +		ibmvfc_link_down(vhost, IBMVFC_LINK_DOWN);
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260702-ibmvfc-fpi=
n-support-v3-0-d95b9547cf88@linux.ibm.com?part=3D3
