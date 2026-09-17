Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ADC531606;
	Thu, 17 Sep 2026 17:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666065; cv=none; b=bZ7oBgF+dikniaWQooXlg3TImplGhaocnsI2dJ7hrp5rAVxwphmO53prpMs0VTVNAA6CYPFkDB0bGtTWKdt1rxEiXlJ++qLFJfTB/xxL+g4itK986dOxZEQyNnYE3rL3bifEMjUNKc0teqhcEATknpCLDxb8k+1WmPQ28o7mK10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666065; c=relaxed/simple;
	bh=jKZOZ0vCACLspHtlfXg4nPEC++KYAdALEYHNye3uvLk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=omuP6iYFlMnNfFiGyJhje2H8oqPttBY+5XrsestQA9/mGcWz5YqOHRPlEwyN5YbetQUJ9EYx9WvU8IQiFSEt5BZyhqc7lpFtiGx0iZN3aJUrbUQgTv1vErXIfeSHH7SQvex5LsAqa+VyvxBv1mzXUDxttNR85n/mwvTynfrDgj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jGrO2X/f; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jGrO2X/f"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 183BF1F00893;
	Thu, 17 Sep 2026 17:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789666063;
	bh=jKZOZ0vCACLspHtlfXg4nPEC++KYAdALEYHNye3uvLk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=jGrO2X/fGLfcGPgd+k144I7KKJWcyW5zLeF7F13DCffI84Z2PsZeTytXcB9iHnXG4
	 z8H4SAbEotKAiyVXoPgfMu8NW3CFQyYTJ/i0nDkiMwfcM+Azdtr1N6DxNXAqnG1e/3
	 73efvolGTy5l5BWgoUoq4lKxklwFjSBU5OdC1mJNK2RtI6B9gPSH1z+Ogn/W7lHB1q
	 I9BI8LiiucPopUw7Qay2BKv/40OC6Dz7V/b16Fdh4JBfb6ZW4jGXdVa6zEF7GDE+XN
	 cvv7MH41VE7zVG8GhsuoGSbAPBy1gwceeD+fwpxlcaIVHtzs+ZQR+KGNogMJrVQgMW
	 CBj4JnE4Mbn+A==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 19/40] fbdev: defio: assert FBINFO_VIRTFB, drop
 VM_IO, add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Marc Zyngier" <maz@kernel.org>, linux-rdma@vger.kernel.org, kvmarm@lists.linux.dev, "Oliver
 Upton" <oupton@kernel.org>, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-perf-users@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, bpf@vger.kernel.org, selinux@vger.kernel.org, kvm@vger.kernel.org
In-Reply-To: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-19-4583d8a23bca@kernel.org>
References: <20260917-b4-mmap-prepare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org>
 <20260917-b4-mmap-prepare-vma-flag-sanify-v3-19-4583d8a23bca@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 17 Sep 2026 17:27:42 +0000
Message-Id: <20260917172743.183BF1F00893@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Currently all drivers which use defio allocate system memory. All of them
> also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocat=
es
> system RAM, so simply failed to set this flag when it ought to.
>=20
> This patch sets FBINFO_VIRTFB on ssd1307fb probe, then drops setting VM_IO
> in fb_deferred_io_mmap() and instead requires FBINFO_VIRTFB to be set,
> erroring out with a kernel warning if not.
>=20
> The logic requires a page from the driver and since commit 1ecbc7dd2902
> ("fbdev/deferred-io: Always call get_page() for framebuffer pages") has
> always required it to be refcounted, so this was implicitly already the
> case.
>=20
> Finally this patch sets VM_MIXEDMAP, as the logic is mapping
> kernel-allocated memory so this is appropriate.
>=20
> Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260917-b4-mmap-pr=
epare-vma-flag-sanify-v3-0-4583d8a23bca@kernel.org?part=3D19

