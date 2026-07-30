Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 035E7477E52
	for <linux-scsi@vger.kernel.org>; Thu, 30 Jul 2026 23:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785454381; cv=none; b=K7imD99NIeBQaYcviimviBcgTGVH+bxBFizbJFzlF4onNgft+QLljFSd2HV72JxiLzFR3BfXhZIOMqI8WrbNxpY7guGw4kxzgbwVzNHiVkZS2OzBQElkmXTai5LRr54GrQVgEN7nF/3Bk2lFPz306JWEGdE6h9kzv9K3f2c4krY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785454381; c=relaxed/simple;
	bh=DNzEV7PoBsc7P11mHmBYucdkABUnMCkPgHBqQUsrHJo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BX+JDtToZkqpNleV5DcHb9XgBYGy7mfbh0k3J0x2IL6Xl0ktAZHmwvE0+/yJqMlTVtvs6BI9sbyEheQyc+vULn810es6Qs15V5uzg2bCAdaknwWz3kLNdZa9RaDhV2GZte4bNNmjDekkAu49vGYVIldBFh5a5uiccRtv7HMZ95k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RgJG/OkI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RgJG/OkI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 929B01F000E9;
	Thu, 30 Jul 2026 23:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785454379;
	bh=Lch3zAfEth2w7v7lR+lfS0NyIDym76Sy89AWiVqlMW4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RgJG/OkIX78QZMBnqdnZBzrffanIOK8fq8cLh0IL9nQnWiADjY7How5nTmMrAvs3w
	 WsxPuqftEOCZtvXGnbXIsPoTsvfVl2j4XOrDTEFkO4/F4w/9jYu2vWEb8gjNI/kcjf
	 g3KMDguSqF/4BnHnmCZ6j5uGi2SroCtUfNzfD2uS2hyod+jWrRgLr2QfOQau8v8ttt
	 lXl/N/g/SVB4eVHwzvc79ERw4NsKzB8GmJYNVR+/sKT0Whevw6lFsS+Azqm/DzeHuL
	 4pd0OcLD/5YEImxRCmL2Y09zxN3Pev2Ko/MIZWYyiZOmpLl5V6aOg9W1vVZD0RuZj0
	 AK+WA+U2eMerQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 57/57] scsi: core: Protect host state changes with
 the host lock
Reply-To: sashiko-reviews@lists.linux.dev
To: "Bart Van Assche" <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <36a92f43e2f8132f517248b98de4ba26a670f249.1785451174.git.bvanassche@acm.org>
References: <cover.1785451174.git.bvanassche@acm.org>
 <36a92f43e2f8132f517248b98de4ba26a670f249.1785451174.git.bvanassche@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 30 Jul 2026 23:32:59 +0000
Message-Id: <20260730233259.929B01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] The patch missed converting a direct read of `shost_state` in th=
e `mpi3mr` driver to the new `scsi_get_host_state()` API.
- [Medium] Double initialization of `host_lock` via the `spinlock_init` gua=
rd overwrites the correct lockdep class name.
- [Medium] `scsi_host_set_state()` performs a plain write to `shost_state`,=
 which races with the newly introduced `READ_ONCE()` lockless readers.
--

--- Patch [57]: [PATCH v3 57/57] scsi: core: Protect host state changes wit=
h the host lock ---
commit b02669cdb0e82751599147d300ebcdc8db8d8734
Author: Bart Van Assche <bvanassche@acm.org>

scsi: core: Protect host state changes with the host lock

Some but not all SCSI host state changes are protected with the SCSI
host lock. Annotate the SCSI host state with __guarded_by(host_lock),
protect all SCSI host state changes with the SCSI host lock and use
READ_ONCE() for all SCSI host state reads. This patch prevents that
KCSAN complains about data races when accessing the SCSI host state.

Reported-by: Jianzhou Zhao <luckd0g@163.com>
Closes: https://lore.kernel.org/all/36d59d0e.6db0.19cdbeee01b.Coremail.luck=
d0g@163.com/
Signed-off-by: Bart Van Assche <bvanassche@acm.org>

> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 08ec144f7bf77..222baa7e10680 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
[ ... ]
> @@ -413,7 +415,8 @@ struct Scsi_Host *scsi_host_alloc(const struct scsi_h=
ost_template *sht, int priv
> =20
>  	shost->host_lock =3D &shost->default_lock;
>  	spin_lock_init(shost->host_lock);
> -	shost->shost_state =3D SHOST_CREATED;
> +	scoped_guard(spinlock_init, shost->host_lock)
> +		shost->shost_state =3D SHOST_CREATED;

[Severity: Medium]
Will this double-initialize the host_lock and overwrite the lockdep class n=
ame?

The previous line explicitly calls spin_lock_init(shost->host_lock) which
assigns the correct static lockdep key. Using scoped_guard(spinlock_init, .=
..)
immediately after calls the initialization macro again internally, overwrit=
ing
the lockdep class with a generic macro variable name (_T->lock).

[ ... ]
> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
> index c5f85af4ba072..d0eefefdc0be8 100644
> --- a/include/scsi/scsi_host.h
> +++ b/include/scsi/scsi_host.h
[ ... ]
> @@ -790,11 +790,18 @@ static inline struct Scsi_Host *dev_to_shost(struct=
 device *dev)
>  	return container_of(dev, struct Scsi_Host, shost_gendev);
>  }
> =20
> +static inline enum scsi_host_state scsi_get_host_state(struct Scsi_Host =
*shost)
> +{
> +	return context_unsafe(READ_ONCE(shost->shost_state));
> +}
> +

[Severity: Medium]
Does the plain write in scsi_host_set_state() need to be updated to
WRITE_ONCE() to match this new READ_ONCE()?

Since scsi_host_set_state() performs a plain write to shost->shost_state,
concurrent lockless READ_ONCE() readers could still cause KCSAN to flag data
races due to compiler tearing on the writer side. The LKMM requires
WRITE_ONCE() on the writer side when there are concurrent lockless
READ_ONCE() readers.

[ ... ]
> @@ -945,6 +953,7 @@ static inline unsigned char scsi_host_get_guard(struc=
t Scsi_Host *shost)
>  	return shost->prot_guard_type;
>  }
> =20
> -extern int scsi_host_set_state(struct Scsi_Host *, enum scsi_host_state);
> +int scsi_host_set_state(struct Scsi_Host *shost, enum scsi_host_state st=
ate)
> +	__must_hold(shost->host_lock);
> =20
>  #endif /* _SCSI_SCSI_HOST_H */

[Severity: Medium]
Was the mpi3mr driver missed during the tree-wide conversion to the new
scsi_get_host_state() API?

It looks like mpi3mr_qcmd() in drivers/scsi/mpi3mr/mpi3mr_os.c still checks
scmd->device->host->shost_state =3D=3D SHOST_RECOVERY directly without using
scsi_get_host_state() or holding the host_lock.

Will this trigger a new Sparse warning due to the newly added
__guarded_by(host_lock) annotation on shost_state?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/cover.1785451174.gi=
t.bvanassche@acm.org?part=3D57
