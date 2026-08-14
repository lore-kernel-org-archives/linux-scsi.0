Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30D6A3D75A6
	for <linux-scsi@vger.kernel.org>; Fri, 14 Aug 2026 03:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786679576; cv=none; b=hti7RYN2qrIShWS1BDU6WhzDIV56AxE2raw8iSISIIgJgTbglFHMPg7N9ZuW8KehGD0MPksdwpst/zinrV+Xf+LleOD98PK2xQzC0H8eByTqOkXU00ZO2GKiHY6vbiHZUyRF6dym2gINSV+oWvZN72WDH7o8SvmTVkQKeFwJ3oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786679576; c=relaxed/simple;
	bh=aF3riP8CieIQwoAhFkiTY8wG6hgKhvEUZPH28Khtra8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=bvJh+rRWdHBF0RCAPI/4nm1M4B6z9xFQ4I/dm6p6/a+HUP76/gQZC4FenaqGvnD4/m17yzISymrzdBJOHtqwdS/V59XU61TY0ObIWyxdF2+0TkJqR8lVVFhHBU3P6Wt4Alx4eFlMeTNzZOitOLJLyiW+WhL+kilm6xkYmUurmkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dLBZ+RGB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dLBZ+RGB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 85FA01F000E9;
	Fri, 14 Aug 2026 03:52:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786679574;
	bh=0pGfBcVHuUlC1Mha3jMmgNNXb14IN6r+8MibR8ODFwE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dLBZ+RGBe8MiMaCfFMZLm8gxRzAwPZY4jNdzcjLbhUPTAlxs7fQQsjFKK+NkmTIJw
	 wYaXBQdCBDZbUmmzss8yeMiZgOUZxz5sXv2dcFSHsvMC1qPZuU2PCT+IS/o1wtIbN0
	 RZHQMfnQWeHMCQjWnkBgxh8QK8pm3sF9jYKbo49T9NHrtoNItaOWpmOX9mN79wkJ1g
	 Nf5fc5/XcgVQddbmjuMDnWYvvvdydVmstVRa6Fk/1A3G+KMQzPKAb/GjZGuYjPz2E6
	 6XmU38SwtoRYuJBDgVgPWsRfHjY/y0sej1/PGxTJ0bY+JM1JBYlOoD+fUCFf+7cZjv
	 fPk1PCKdX06rg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/2] scsi: leapraid: serialize firmware log mmap with
 teardown
Reply-To: sashiko-reviews@lists.linux.dev
To: "Linmao Li" <lilinmao@kylinos.cn>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260814033845.2971706-3-lilinmao@kylinos.cn>
References: <20260814033845.2971706-1-lilinmao@kylinos.cn>
 <20260814033845.2971706-3-lilinmao@kylinos.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 14 Aug 2026 03:52:54 +0000
Message-Id: <20260814035254.85FA01F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unbounded wait in `leapraid_fw_log_exit()` allows userspace to blo=
ck PCI device removal indefinitely.
--

--- Patch [2]: [PATCH v3 2/2] scsi: leapraid: serialize firmware log mmap w=
ith teardown ---
commit f76020cc63b98ce5d018410c191835d8ffc2261a
Author: Linmao Li <lilinmao@kylinos.cn>

scsi: leapraid: serialize firmware log mmap with teardown

This commit fixes a race condition during firmware log teardown by
claiming a temporary mmap reference during adapter lookup. It ensures
the driver does not free the coherent buffer while the mmap path is
still establishing a mapping.

> diff --git a/drivers/scsi/leapraid/leapraid_app.c b/drivers/scsi/leapraid=
/leapraid_app.c
> index 841027ce2501c..84eef50947aea 100644
> --- a/drivers/scsi/leapraid/leapraid_app.c
> +++ b/drivers/scsi/leapraid/leapraid_app.c

[ ... ]

> @@ -771,6 +774,9 @@ static int leapraid_fw_mmap(struct file *filp, struct=
 vm_area_struct *vma)
> =20
>  	rc =3D 0;
>  out_put:
> +	if (adapter &&
> +	    atomic_dec_and_test(&adapter->fw_log_desc.mmap_refcnt))
> +		wake_up(&adapter->fw_log_desc.mmap_waitq);

[Severity: High]
This is a pre-existing issue, but since we are modifying the mmap teardown
synchronization here, I noticed a potential problem on the wait side of this
logic.

If a userspace process keeps the VMA open indefinitely, won't the unbind
process hang forever?

Looking at the teardown side in drivers/scsi/leapraid/leapraid_func.c:

leapraid_fw_log_exit() {
    wait_event(adapter->fw_log_desc.mmap_waitq,
               !atomic_read(&adapter->fw_log_desc.mmap_refcnt));
}

Since this waits in uninterruptible sleep without a timeout, could a rogue
or stuck userspace application block PCI device removal or module unloading
permanently?=20

It seems like the kernel shouldn't rely on cooperative userspace behavior=20
during hardware unbind, perhaps this needs an unmap_mapping_range() or=20
similar asynchronous shootdown mechanism to ensure the wait completes?

>  	leapraid_ctl_put_adapter(adapter);
>  	return rc;
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260814033845.2971=
706-1-lilinmao@kylinos.cn?part=3D2
