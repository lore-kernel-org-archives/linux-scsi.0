Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A90563CBE7E
	for <linux-scsi@vger.kernel.org>; Fri,  3 Jul 2026 12:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783080220; cv=none; b=awVt/xignyRnSTeVv3y0GMpnwNHNBR1PPHZsqcSjMe6jH3JUeofx3E+JdigTZNFXEkJ9b1AJoEf83+XitVg+wZzkcQQR6fMKghkp7C9G4ztbLOE+cX2fmcLBhUxZx+7FNWRaTJ4NyKgU+eIHr70U2iPa1fZyzSaF7KK8QIWEWPs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783080220; c=relaxed/simple;
	bh=PW7ksLokOHhYKfuXgMLFwXWNkC0PloF/hAQW7EhCDzI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=R0Y1z9KPD1YYk4wqH616QULo76AEE6RK491HMXaWKcosgyP8CGju68ZXmqzOajVzV78yQ+BMF3GqGXyRdCmClDhxSvh3HL9Yu4N8y/yFjt2CfOt9Cbc5GHBkJsQbdq/3JHvzXBI1Y7q9XiFfieRsjO0H5x7YTwI+7TcNq9fPkfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e8ngsJQ/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e8ngsJQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F35081F000E9;
	Fri,  3 Jul 2026 12:03:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783080219;
	bh=RvOqyft5LBYm6nW48TTBsDDyaLyTV/DydHksnbnhXBw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e8ngsJQ/R+56aiUXH4xFZ9emQvizqBRyw/ZTueoi+0toaJaRyfFGe0ehku54izAjm
	 2Em+4sbbNyDFvrcV/MGk4F8GHUwwXwUcWTQH8J3SDXznLol3cKLEOyn+78b0BmVEmF
	 P0Sp2UcdH1ardBWZvf6FDyUoFqIdFamr2+WwTeK54NO4K2+rjcHfOjefs3c1x3+cg2
	 iC0VBSDkhNBtXajbjMMQvqgcLGb9VlqU/yOLFVlolee6Gs5tS7zndfG5nifXWYFA4j
	 eDcnCIIfQ6I2aOQ4uZHL+sCuqdabtb1Y5SdSdnlbjG4+mQ6nJmPel4vdFed6omBdWk
	 yw86dR9kn/O6w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 10/17] scsi-multipath: block PR commands
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260703103402.3725011-11-john.g.garry@oracle.com>
References: <20260703103402.3725011-1-john.g.garry@oracle.com>
 <20260703103402.3725011-11-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 03 Jul 2026 12:03:38 +0000
Message-Id: <20260703120338.F35081F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Double-free and use-after-free of `scsi_mpath_head` and its resour=
ces on the `dev_set_name` failure path.
- [High] Calling `list_del_init` on an uninitialized list_head and `device_=
unregister` on a failed device addition.
--

commit 3be4a33456416864c9e49c5cfb76773fb5375009
Author: John Garry <john.g.garry@oracle.com>

scsi-multipath: block PR commands

For initial scsi-multipath support, do not support Persistent Reservations
(PRs). This change intercepts PR SCSI commands for passthrough and rejects
them since PR support for SCSI is quite complicated.

> diff --git a/drivers/scsi/scsi_multipath.c b/drivers/scsi/scsi_multipath.c
> index 61fa2e4cdfdab..b4d9d6518b4fe 100644
> --- a/drivers/scsi/scsi_multipath.c
> +++ b/drivers/scsi/scsi_multipath.c

[ ... ]

While reviewing this file, I noticed a couple of pre-existing issues:

drivers/scsi/scsi_multipath.c:scsi_mpath_alloc_head() {
    ...
	ret =3D dev_set_name(&scsi_mpath_head->dev, "scsi_mpath_device%d",
				scsi_mpath_head->index);
	if (ret) {
		put_device(&scsi_mpath_head->dev);
		goto out_free_ida;
	}
    ...
}

[Severity: High]
This is a pre-existing issue, but can this lead to a double-free?

If dev_set_name() fails, the error path calls put_device(). Since
device_initialize() sets the kref count to 1, this drops the count to 0 and
immediately invokes the release function scsi_mpath_head_release().

The scsi_mpath_head_release() function will free the scsi_mpath_head memory
via kfree() as well as associated resources like the IDA and bioset.

The code then incorrectly falls through to out_free_ida, executing ida_free=
(),
mpath_put_head(), bioset_exit(), and a second kfree() on the already freed
scsi_mpath_head pointer. Will this result in a double-free and memory
corruption?

A similar issue appears in a different error path:

drivers/scsi/scsi_multipath.c:scsi_mpath_dev_alloc() {
    ...
	ret =3D device_add(&scsi_mpath_head->dev);
	if (ret) {
		mutex_unlock(&scsi_mpath_heads_lock);
		goto out_put_head;
	}
    ...
}

Which eventually calls the release function:

drivers/scsi/scsi_multipath.c:scsi_mpath_free_head() {
    ...
	list_del_init(&scsi_mpath_head->entry);
	mutex_unlock(&scsi_mpath_heads_lock);

	device_unregister(&scsi_mpath_head->dev);
    ...
}

[Severity: High]
This is a pre-existing issue, but does this release function operate on an
unlinked list head and a partially initialized device?

In scsi_mpath_dev_alloc(), if device_add() fails, it jumps to out_put_head =
and
calls scsi_mpath_put_head(). This drops the reference to 0 and invokes
scsi_mpath_free_head().

When scsi_mpath_free_head() calls list_del_init(&scsi_mpath_head->entry), t=
he
entry is uninitialized (zeroed by kzalloc) because device_add() failed befo=
re
list_add_tail() was ever called. Can this result in a NULL pointer derefere=
nce
when __list_del_entry() attempts to link the pointers?

Furthermore, it then unconditionally calls device_unregister(). Does this
incorrectly attempt to device_del() a device that was never successfully ad=
ded,
leading to driver core warnings or crashes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260703103402.3725=
011-1-john.g.garry@oracle.com?part=3D10
