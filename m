Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 104BA1D130E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2026 18:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786559512; cv=none; b=E3y5XmwoI3wMQTIOwDqa+F/UFhFVaGol3rscFBc0rdAfbkKvEDRl21fRfFV4wIY+dgYqRlBFP7L/T05Ya8QDfQZET1iQcc1NFp9zR3H7lYT7DXeoSGGC/la1uSHdHZpzQRIleAZUAhDP08A8embyYw+xWD5puUZXv7/Ac/Vp694=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786559512; c=relaxed/simple;
	bh=ochJIIAJiMAZnPcC5ht7JHHFVwN14AmiEGNnrVWmG9k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=cXy02PGsCGkVwpZRDS+oKIakY7hAIbAkoShQzfmWLz6UQNyHVRyc4390Es5Q1he4Gct3UbG2JAK8EXobByurS5y8qO9haDxCqP8Xvz5CGZLQpSKMzVRUF3+LifF4bkJrscSpIe/lN392FDfYXXPOHkHGlKI/fsS3OUPtMKNXbSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JKbfeeCq; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JKbfeeCq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6D21F000E9;
	Wed, 12 Aug 2026 18:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786559510;
	bh=XuyPE/oSqLstAHoUJQcVZIgRGZ9DR0cTLFtYGg216g0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JKbfeeCq6vyT08X8cTFea3JlNXQJleTd3YR1OrnyB2i18jRPP5s184Bcm1vTZEa0h
	 X0N5s/pES6ZI2Y4vnTPYdkwGnQ235Jqtvj6Bjs7ZKP2ZTK7bRwtyVUZMtDrhOFBXOO
	 kK9Ir9qlPePHcYdqyT+4KLNnNcjxvYsE4ffLhnRVu2gfUQFcghKxfBzSGNRJUuSbq4
	 p6Ilfzk63TT3G0j0oPoiJClNr0HTCo58t8EVc+dGiIUq1/KZ8kEyI4AHvmQ2rlDmh7
	 zRPyETv2JJrikAHomVgtIQBHP7l+STU2mqw24jOo4AH4SwpKCBun0MKcPQtLU4ZDC3
	 A+o8N+D43AOBg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 12/13] nvme: fcloop: Add set_rport_marginal to sysfs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Jesse Taube" <jtaubepe@redhat.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260812181300.3712426-13-jtaubepe@redhat.com>
References: <20260812181300.3712426-1-jtaubepe@redhat.com>
 <20260812181300.3712426-13-jtaubepe@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 12 Aug 2026 18:31:50 +0000
Message-Id: <20260812183150.8D6D21F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] The `opts` structure is allocated on the stack and passed uninitia=
lized to `fcloop_parse_options`, leading to undefined behavior and use of s=
tack garbage.
- [High] A reference count leak occurs on the error path in `fcloop_set_mar=
ginal_rport` when the target port or remote port is missing.
- [High] Lockless access to `nport->tport` and `nport->tport->remoteport` c=
reates a TOCTOU bug that can lead to a Use-After-Free.
--

--- Patch [12]: [PATCH 12/13] nvme: fcloop: Add set_rport_marginal to sysfs=
 ---
commit 0c2a40a45b26fd619c8713ddb24578a051043b92
Author: Jesse Taube <jtaubepe@redhat.com>

nvme: fcloop: Add set_rport_marginal to sysfs

This commit adds a sysfs attribute to allow setting a remote port as margin=
al.
This helps facilitate testing of multipath failover by simulating a marginal
link in the fcloop LLDD.

> diff --git a/drivers/nvme/target/fcloop.c b/drivers/nvme/target/fcloop.c
> index b63af3b643a64..51a50743128db 100644
> --- a/drivers/nvme/target/fcloop.c
> +++ b/drivers/nvme/target/fcloop.c

[ ... ]

> @@ -1663,6 +1677,31 @@ fcloop_set_cmd_drop(struct device *dev, struct dev=
ice_attribute *attr,
>  	return count;
>  }
> =20
> +static ssize_t
> +fcloop_set_marginal_rport(struct device *dev, struct device_attribute *a=
ttr,
> +		const char *buf, size_t count)
> +{
> +	struct fcloop_nport *nport;
> +	struct fcloop_ctrl_options opts;

[Severity: High]
Does this leave the opts structure uninitialized?

Looking at fcloop_parse_options(), it uses opts->mask |=3D token during par=
sing,
which performs a read-modify-write operation. Since opts is allocated on the
stack here without initialization, could this use stack garbage and result =
in
false validation bypass or incorrect functional behavior?

> +	int ret;
> +
> +	ret =3D fcloop_parse_options(&opts, buf);
> +	if (ret)
> +		return ret;
> +
> +	/* everything there ? */
> +	if ((opts.mask & MARGINAL_OPTS) !=3D MARGINAL_OPTS)
> +		return -EINVAL;
> +
> +	nport =3D fcloop_nport_lookup(opts.wwnn, opts.wwpn);
> +	if (!nport || !nport->tport || !nport->tport->remoteport)
> +		return -ENOENT;

[Severity: High]
If nport is successfully found but !nport->tport or !nport->tport->remotepo=
rt
is true, does this leak the reference count on nport?

The fcloop_nport_lookup() function increments the reference count of the
returned nport. Returning -ENOENT early here skips the fcloop_nport_put()
call, which would permanently prevent the nport from being freed.

[Severity: High]
Is it safe to access nport->tport and nport->tport->remoteport locklessly
here?

Could a concurrent write to del_target_port take fcloop_lock, clear these
pointers, and free the targetport memory while this function is actively
dereferencing them, resulting in a use-after-free?

> +
> +	nvme_fc_set_remoteport_fpin(nport->tport->remoteport, opts.marginal);
> +	fcloop_nport_put(nport);
> +
> +	return count;
> +}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260812181300.3712=
426-1-jtaubepe@redhat.com?part=3D12
