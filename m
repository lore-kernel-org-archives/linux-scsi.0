Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBFF383985;
	Mon, 14 Sep 2026 19:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789415081; cv=none; b=LbkX+vu+h3T906LMTJDrDlK0keTSYnGugyuTCPR/OFfOU5soIqhMrPHqQcK9OFUY0rC0D8C2SpVxfbg0mZ5XTH9UhBMiJDbjJqyGrRA+8I7fg6aTHmgg61GRvvlCLjtn0bSKP0khkhCBwhN3CsHUdB+iIKH6Epa07kdWuv3AUJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789415081; c=relaxed/simple;
	bh=ctiiM6vJqJ++ghuOO2EvQkAwGIF6KNL58iWGR/JZBH8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UAxLIAwTXGq51HVw+6Ytza/RjrONvkPAuIuI8tpAfIaJ37Cj2ADHdwC+U0G0wrmsCM9z0SNkaUpXkO/TgsacL95rPkpU1OFgg2RIcz1od/s6va9qJ8/mDOHv8VibJFlBY0TmZxRCuM1tLOb3xdmnwAdPxWXqxDjBNr71+7IASyw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Aa9RX4NE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Aa9RX4NE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 960DB1F000FF;
	Mon, 14 Sep 2026 19:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789415076;
	bh=dAIamB9o96xWXDBcRkq+/H0si90404IoSC8KyMPldZw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Aa9RX4NETC9n15P4OBlFDQsPzC9XjIuOtUHcYgFRMSR9QFgm0bbVVhxKu0M8wRgDj
	 U2jklQLyh4IzZ0H+3MHP8kcHulROBBL5SZwu8TEoW3jsW8g12yWV9RV1BKlMNnWggX
	 61WpUC3uZnkGyZO1jxhozUWpbMBwFodtfctbTbrphUE8/csJArkmbq2JQKLEZb/2nX
	 OkARX43MWFEQV5bfl7ZQvpJl6JuaYXuD8O9OU6yXFnODyYK4vZ67Z/GCIHsn+IqLmO
	 zF3LTrI9XHu+t2Df2uG5iq6n8dsxpNLvl/UPexqRY1SUgB4XV91cnHLp4Jaf/QLLWV
	 /BU+iQDoVNOQg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 19/40] fbdev: defio: assert FBINFO_VIRTFB, drop
 VM_IO, add VM_MIXEDMAP
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>
Cc: linux-perf-users@vger.kernel.org, "Marc Zyngier" <maz@kernel.org>, dri-devel@lists.freedesktop.org, "Oliver
 Upton" <oupton@kernel.org>, kvm@vger.kernel.org, selinux@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, kvmarm@lists.linux.dev, "Heiko Carstens" <hca@linux.ibm.com>, bpf@vger.kernel.org, linux-rdma@vger.kernel.org, linux-s390@vger.kernel.org, linux-trace-kernel@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-19-7d9781ed5361@kernel.org>
References: <20260914-b4-mmap-prepare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org>
 <20260914-b4-mmap-prepare-vma-flag-sanify-v2-19-7d9781ed5361@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 14 Sep 2026 19:44:35 +0000
Message-Id: <20260914194435.960DB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] The driver passes a virtual address to __free_pages(), causing=
 an out-of-bounds pointer dereference and kernel panic.
- [High] Ignored return value of fb_deferred_io_init() leads to NULL pointe=
r dereferences in mmap, open, and cleanup error paths.
- [High] Missing .driver_data initialization in i2c_device_id array leads t=
o NULL pointer dereference on sysfs instantiation.
--

commit d46565518c57c096a66d45b42bbe529fae5740d7
Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>

fbdev: defio: assert FBINFO_VIRTFB, drop VM_IO, add VM_MIXEDMAP

Currently all drivers which use defio allocate system memory. All of them
also set FBINFO_VIRTFB, other than ssd1307fb, however this driver allocates
system RAM, so simply failed to set this flag when it ought to.

> diff --git a/drivers/video/fbdev/ssd1307fb.c b/drivers/video/fbdev/ssd130=
7fb.c
> index c4fdecafd8560..958514a354338 100644
> --- a/drivers/video/fbdev/ssd1307fb.c
> +++ b/drivers/video/fbdev/ssd1307fb.c
> @@ -763,6 +763,8 @@ static int ssd1307fb_probe(struct i2c_client *client)
>  	info->fix.smem_start =3D __pa(vmem);
>  	info->fix.smem_len =3D vmem_size;
> =20
> +	info->flags =3D FBINFO_VIRTFB;
> +
>  	fb_deferred_io_init(info);

[Severity: High]
This isn't a bug introduced by this patch, but if memory allocation fails
in fb_deferred_io_init(), it returns -ENOMEM but ssd1307fb_probe() ignores
it, leaving info->fbdefio_state as NULL and info->deferred_work
uninitialized.

Subsequent probe failure or device removal calls fb_deferred_io_cleanup(),
which can unconditionally call flush_delayed_work() on the uninitialized
workqueue and then dereference the NULL fbdefio_state:

drivers/video/fbdev/core/fb_defio.c:fb_deferred_io_cleanup() {
	...
	mutex_lock(&fbdefio_state->lock);
	...
}

Additionally, userspace calling open() or mmap() could trigger NULL pointer
dereferences in fb_deferred_io_open() and fb_deferred_io_mmap().

Does the ignored return value of fb_deferred_io_init() lead to NULL pointer
dereferences in mmap, open, and cleanup error paths?

> =20
>  	i2c_set_clientdata(client, info);

[Severity: Critical]
This is a pre-existing issue, but the driver allocates video memory using
__get_free_pages(), which returns a virtual address (void *).

During probe failure, it passes this virtual address directly to
__free_pages():

drivers/video/fbdev/ssd1307fb.c:ssd1307fb_probe() {
	...
fb_defio_error:
	__free_pages(vmem, get_order(vmem_size));
	...
}

And during module unload, it does the same:

drivers/video/fbdev/ssd1307fb.c:ssd1307fb_remove() {
	...
	__free_pages(__va(info->fix.smem_start), get_order(info->fix.smem_len));
	...
}

Because C implicitly casts void * to struct page *, the kernel could treat
the zeroed video memory as a page struct, reading garbage PFNs, corrupting
the buddy allocator state, and crashing.

Does passing a virtual address to __free_pages() in these paths cause an
out-of-bounds pointer dereference and kernel panic? Should this be using
free_pages() instead?


[Severity: High]
This isn't a bug introduced by this patch, but if the driver is instantiated
via the legacy I2C sysfs interface, device_get_match_data() falls back to
matching against ssd1307fb_i2c_id:

drivers/video/fbdev/ssd1307fb.c:ssd1307fb_i2c_id[] =3D {
	{ .name =3D "ssd1305fb" },
	...
};

Because entries in this array omit the .driver_data field, it defaults to
NULL. The probe function then unconditionally dereferences this NULL pointe=
r:

drivers/video/fbdev/ssd1307fb.c:ssd1307fb_probe() {
	...
	par->vcomh =3D par->device_info->default_vcomh;
	...
}

Does the missing .driver_data initialization in the i2c_device_id array
lead to a NULL pointer dereference on sysfs instantiation?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260914-b4-mmap-pr=
epare-vma-flag-sanify-v2-0-7d9781ed5361@kernel.org?part=3D19
