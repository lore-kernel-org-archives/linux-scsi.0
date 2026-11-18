Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794998243;
	b=Hkm2biJpHEwLddFIDtO+u7do6zF9js8f5EJq8sd4d7w8ilNQxszz5EYi/FY3f+M90WaO
	 MRKauWUZ0Qd8k4oszfw2mz5VnwGAvvc4dbyVHtEtBVbnV5Rc2QdlDmhmLgkcRd5CGYsSu
	 G9HgwB/6E/mTlALXoDRpdx7DRHrUgajWYhaPgJlTA677lkZSS7dW+j75aKvBLQTnX2F06
	 jcLgvtYyndkeP2ngdnyKahrd4NJUcwK8Ubs4mimUmTlzbNF2pfgX7tsvNSEdexQCh5xjh
	 iMlvHgNlNtuVHxIwMxjDdSt8i/b5yHAxEzRJ7byV/RTF+XQDcCvrUO+Dzhjq+wQge8g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794998243;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=shD5tBjn1ezoyX4r1RLG+Q1MIb28OGy3ICx5qnEF8XE=;
	b=2MpioycjEtypYQe68z0mY2hxrarFpLMVq06ao4GYLFgdzWJgErfzS6O9UdjszqbItgJX
	 xK+PIos0aNS5KRGATpr3+NpnzhTY2KNduuAX+IQrDY/Yazy3NY4c4vv8lz7JVTRA5ndgL
	 BXKLihRz3gT7BPtPqdML9TCzdP8MX3hVnvHc2rS8iwUM8CeQQir1U168lwUZdPRbbvlsv
	 X2yINs5GqPgM4vO6pRbsSEqr29Jne9gjAwzhv6xi99jjOnv7Ps8wQLGFYKi5NsOx9kIRf
	 X16uEZYOQMDJLM5JXvSYWKFix/0aKgJF/HDfcEzj43v3U2yAcOza/dZ2cUls/lKAHHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8kyfYLv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C844606A32A
	for <linux-scsi@vger.kernel.org>; Wed, 18 Nov 2026 10:37:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=M8kyfYLv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8DE01F000C5;
	Wed, 18 Nov 2026 10:37:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794998242;
	bh=shD5tBjn1ezoyX4r1RLG+Q1MIb28OGy3ICx5qnEF8XE=;
	h=From:Subject:Reply-To:To:In-Reply-To:References:Date;
	b=M8kyfYLvv6QvBO4WXre/bOcZ2Kn/m6YCu0MOGlv304K/RDLBaCNe/ktK/s5ma/Hr+
	 2QQLD9EAmCy9b5H0ug/4BgX+cYU7I+EpjGyF5rpcEBrik4Y2UrwUwa+3EbEwJzM6d3
	 Q8RReO7fqnVtfStUOC9ASnpm7bXZrWvVbY2fdHZbUCaJlbL3r6OcnnxETvSAMDrgI4
	 mB9IIrOcBhtkrvLNN8GSu3scBPXobZnnBR/eY66D3M1GDV+BQxeuu8VfVhC0y5R+MC
	 iHkQ5fK3tOW3NEpL89ISnl80N5uARyJ09jhCApH45myJ4FLDRkVUsZzhATSMUdU7t3
	 ey2YEExSlfm6Q==
Message-ID: <sashiko-outbox-220719@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 04/37] scsi: mpt3sas: Fix locking and bounds checks
 on host_trace_buffer sysfs files
Reply-To: sashiko-reviews@lists.linux.dev
To: "Shivasharan S" <shivasharan.srikanteshwara@broadcom.com>, linux-scsi@vger.kernel.org
In-Reply-To: <1794995806-5835-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
References: <1794995806-5835-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1794995806-5835-5-git-send-email-shivasharan.srikanteshwara@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 10:37:22 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] scsi: mpt3sas: missing Fixes trailer for host_trace_buffer sysfs
  fix
- [Low] scsi: mpt3sas: redundant ring_buffer reset in
  _ctl_diag_register_2()
--

commit 3535763c07f27fef4db2f60a5c7aeaf47d1bbea7
Author: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>

> scsi: mpt3sas: Fix locking and bounds checks on host_trace_buffer sysfs f=
iles
>
> Serialize the host_trace_buffer* sysfs handlers on ctl_cmds.mutex and
> clamp the reported/used buffer size to the actual allocation size.
>
> Signed-off-by: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Signed-off-by: Ranjan Kumar <ranjan.kumar@broadcom.com>

[Severity: Low]
Since this fixes locking and bounds checks in the host_trace_buffer sysfs
handlers, should it include a Fixes tag?

  Fixes: f92363d12359 ("[SCSI] mpt3sas: add new driver supporting 12GB SAS")

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_ctl.c b/drivers/scsi/mpt3sas/mp=
t3sas_ctl.c
> index f4eeef572f6ec..ef28da96dc262 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_ctl.c
> @@ -1772,6 +1772,11 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
>  	/* Reset ioc variables used for additional query commands */
>  	ioc->reset_from_user =3D 0;
>  	memset(&ioc->htb_rel, 0, sizeof(struct htb_rel_query));
> +	/* a (re)posted trace buffer starts a fresh capture */
> +	if (buffer_type =3D=3D MPI2_DIAG_BUF_TYPE_TRACE) {
> +		ioc->ring_buffer_sz =3D 0;
> +		ioc->ring_buffer_offset =3D 0;
> +	}
>  	ioc->diag_buffer_status[buffer_type] &=3D
>  	    MPT3_DIAG_BUFFER_IS_DRIVER_ALLOCATED;
>  	memcpy(ioc->product_specific[buffer_type],
> @@ -1791,6 +1796,10 @@ _ctl_diag_register_2(struct MPT3SAS_ADAPTER *ioc,
>  	if (request_data =3D=3D NULL) {
>  		ioc->diag_buffer_sz[buffer_type] =3D 0;
>  		ioc->diag_buffer_dma[buffer_type] =3D 0;
> +		if (buffer_type =3D=3D MPI2_DIAG_BUF_TYPE_TRACE) {
> +			ioc->ring_buffer_sz =3D 0;
> +			ioc->ring_buffer_offset =3D 0;
> +		}

[Severity: Low]
This isn't a bug, but the second reset of ioc->ring_buffer_sz and
ioc->ring_buffer_offset inside the request_data =3D=3D NULL block is redund=
ant
since both fields are already zeroed unconditionally just above.

Also, when a released trace buffer is re-posted via the MPT3DIAGREADBUFFER
ioctl with MPT3_FLAGS_REREGISTER in _ctl_diag_read_buffer(),
ioc->ring_buffer_sz and ioc->ring_buffer_offset are not reset, leaving
stale sysfs ring buffer state across ioctl-initiated re-registration.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/1794995806-5835-1-g=
it-send-email-shivasharan.srikanteshwara@broadcom.com?part=3D4
