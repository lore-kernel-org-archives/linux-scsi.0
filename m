Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A05D35E930
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 03:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786679788; cv=none; b=hDeWtpGxQdKvVsq74Tin1nJni1Y6HnvPQSnfWWdGPeYDnmQFH5WfgPfUoeXaBJOXuDoSfvE8R5yCG2/or/4WDVSjIleD/6TmgeAZxqAPToe6aKkj5xdxJRrOo6iFYhgZAmz3v6IB8Zl9ekP6A5GERbDDNlxlpBbiRsgaHBqR3wE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786679788; c=relaxed/simple;
	bh=MVCnqtcXlCmnUISqDUWDYvF5RoO+ZeeXGBD52YMfm+U=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=VwQ/FlKH8vVnFmqb2LJZ2Y+taDRawZtedlWxgWFoSck21CcwE6r/Ky0lGNk2h2KJdZR0/f49lsf9Vzb5IgPng+bCJZ5+tK50LgGoFxD5AILGKAS859UIYa9BEj6nuEjYg5K7MudnUSpw2hqj5ChfUpAI8rSiuk1oOc30Hyq6B7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P5+qN0eC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P5+qN0eC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789571F000E9;
	Fri, 14 Aug 2026 03:56:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786679786;
	bh=L9X7QbTU0VwOpsXV93C+QAaC6pWbrcip5I1plnts6tc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=P5+qN0eC1mM1c/+9PecP+BLlMU4UVDqNjr/DruONbXxJf8MaFW0GDSY0bDqAVp46z
	 yUsHB2EXod2GDVN3xKcIJBhyROfSTM10SS6pHxC/30J3H0mY1W8R8vMTYnpWoaHAy4
	 /RuuyRzVVbB+Q3ZTe+y3yLf4TxgbltS7qndX65UjToFizAjLFTP0uqkE3U/unR6JPo
	 wOuJ12/74qekn0BuDsPjM4HUIfXAT5KMcKVQf/daFE3homk5XYr8hJQABlwb27uLqY
	 RrySZGNNKhIoN1TyboOAgz+MbSg9VuPz6FeZzd5YOdCID0QdaaVIICb3ymEBoBYsuS
	 bu89z1LZgKQzg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 1/2] scsi: leapraid: balance host references for
 firmware log VMAs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linmao Li" <lilinmao@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814033845.2971706-2-lilinmao@kylinos.cn>
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
 <20260814033845.2971706-2-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 03:56:23 +0000
Message-Id: <20260814035626.789571F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] TOCTOU race condition in `leapraid_fw_mmap` leading to Use-Aft=
er-Free of DMA buffer.
- [High] Device removal path hangs uninterruptibly waiting for userspace to=
 close VMAs.
--

--- Patch [1]: [PATCH v3 1/2] scsi: leapraid: balance host references for f=
irmware log VMAs ---
commit 727a052aa98a29cd5e6da31ed634d370a79651cc
Author: Linmao Li <lilinmao@kylinos.cn>

scsi: leapraid: balance host references for firmware log VMAs

leapraid_fw_mmap() keeps the Scsi_Host reference obtained while
looking up the adapter for the lifetime of the initial VMA.  The VMA
close callback drops that reference.

> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid=
/leapraid_app.c
> index 742f19c07fcbb..841027ce2501c 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c
> @@ -697,6 +697,7 @@ static void leapraid_fw_mmap_open(struct vm_area_stru=
ct *vma)
>  	if (!adapter)
>  		return;
> =20
> +	get_device(&adapter->shost->shost_gendev);
>  	atomic_inc(&adapter->fw_log_desc.mmap_refcnt);

[Severity: High]
This is a pre-existing issue, but does this reference counting lead to
an uninterruptible hang during device removal?

Looking at the teardown path in leapraid_remove_ctrl() ->
leapraid_fw_log_exit(), the kernel waits for this reference count
to hit zero:

    wait_event(adapter->fw_log_desc.mmap_waitq,
               !atomic_read(&adapter->fw_log_desc.mmap_refcnt));

Since there is no timeout and no alternative wake condition, couldn't any
userspace process that keeps the VMA open indefinitely cause the kernel thr=
ead
running the removal to hang, creating a denial of service?

>  }

[ ... ]

> @@ -767,7 +768,6 @@ static int leapraid_fw_mmap(struct file *filp, struct=
 vm_area_struct *vma)
>  	vma->vm_private_data =3D adapter;
>  	vma->vm_ops =3D &leapraid_fw_mmap_vm_ops;
>  	leapraid_fw_mmap_open(vma);

[Severity: Critical]
This is a pre-existing issue, but does this sequence create a race condition
leading to a use-after-free of the DMA buffer?

Just prior to this snippet, dma_mmap_coherent() is called locklessly and
before mmap_refcnt is incremented here via leapraid_fw_mmap_open().

If a concurrent device removal starts right before dma_mmap_coherent(), the
removal thread would see mmap_refcnt =3D=3D 0. It would then proceed to free
fw_log_buffer via dma_free_coherent() in leapraid_fw_log_exit().

Could the mmap thread then resume and map the now-freed DMA memory into
user space?

> -	adapter =3D NULL;
> =20
>  	rc =3D 0;
>  out_put:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814033845.2971=
706-1-lilinmao@kylinos.cn?part=3D1
