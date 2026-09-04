Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337D5481A97;
	Fri,  4 Sep 2026 13:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788527707; cv=none; b=LeNAdJAdH834mEd5FJcl2eTfWs07lCxGUHwfYsS5FIv34cFkd+/jSdQRcsbluR64IPZheAe2XcQHOyVFVUpWo3CxkrysNjlqzLg0TZwQu4MP93mBmUl85tdFA6C/6iGLK1JiI/R+EwTkg9Ipq5mwfhVgIDJPkZEZ5npqjFYuWwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788527707; c=relaxed/simple;
	bh=lzxhKLC6ov9kd9mG94WYpO8RUYZs6WSRd+qZc5IuoSs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=C9PFaUrRTHDXUQSuelDA52qHYG1kr09IzqPPj5TS1GEtZtE3LWvs8wraBASOrOM/rBuGiEfZySBvFqmRmQyftAA2kYxgC1pDHOag/xSD3BLr8Q/8OrGPTsGa5i8MeQdXPtv8G4/C7vTBR5zRRoNUQtT8wpsWvJ9eYxuYMHBXLjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ol2Izn6B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ol2Izn6B"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 355C41F00A3E;
	Fri,  4 Sep 2026 13:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788527703;
	bh=HnJSorNu3nYDhGdZpXoVI1JnfTa98po6oGxyFlA3wJc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ol2Izn6BXgkXrMGAGVU4P6XIE5BP4QiSrqqYz9fFxrxC9v/cR0JdH9wzAYOeXq7DW
	 M+t2aZDJ0qJR/bS8Bo2L0fMH8N39et3Ru31Qeizu/5kQw7rZNOQq5iJJz+M/O/f8iL
	 P07Wsd63Pc1v4+xOY26VPJy0D2rwNTxSSCF7tQCglz5mz6lv9bmXORR0iRDCH62N+p
	 bOQ9HFm14SFU9qf1fpUoSjuF4A0o/v8rJRTjX40a3ydKKLvasx4cp6hw7lVEUhS2Pc
	 mnLANSTH+wMY4mliQaYBWDKC/PW1cYnKv6JgerGBImVZFdRetzuyqZRY5y6KHHdGIf
	 f+Sq3B8ghyHVg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v3 1/1] leds: asus-aura-scsi: Add ASUS Aura RGB LED
 driver for ROG NVMe enclosures
Reply-To: sashiko-reviews@lists.linux.dev
To: "Liang Haowen" <nbg2974@gmail.com>
Cc: lee@kernel.org, linux-leds@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <202609042030.RFCv3-1.lhw@gmail.com>
References: <202609012200.RFC0.lhw@gmail.com>
 <202609012200.RFC1.lhw@gmail.com> <202609032000.RFCv2-0.lhw@gmail.com>
 <202609032000.RFCv2-1.lhw@gmail.com> <20260903161357.GX2133376@google.com>
 <202609042000.RFCv3-0.lhw@gmail.com> <202609042030.RFCv3-1.lhw@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 13:15:02 +0000
Message-Id: <20260904131503.355C41F00A3E@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] LED class device name violates UAPI naming standards and breaks =
userspace parsing.
- [Low] Compilation failure due to undefined macro `kzalloc_obj`.
- [Low] Compilation failure due to missing argument in `blk_rq_map_kern()` =
call.
--

commit c4b336ab5a8222a99fc342c60592e26cbc2f680e
Author: Liang Haowen <nbg2974@gmail.com>

leds: asus-aura-scsi: Add ASUS Aura RGB LED driver for ROG NVMe enclosures

This commit introduces a driver for ASUS ROG external NVMe enclosures. It
exposes the Aura LEDs connected to an ENE controller via vendor SCSI
commands, implementing multicolor LED class devices for each LED.

> diff --git a/drivers/leds/leds-asus-aura-scsi.c b/drivers/leds/leds-asus-=
aura-scsi.c
> new file mode 100644
> index 0000000000000..3ff33615a7934
> --- /dev/null
> +++ b/drivers/leds/leds-asus-aura-scsi.c
[ ... ]
> +static int ene_write(struct scsi_device *sdev, u16 reg,
> +		     const void *data, u8 arg_count)
> +{
> +	struct request *rq;
> +	struct scsi_cmnd *scmd;
> +	u8 cdb[ENE_CDB_LEN];
> +	int ret;
> +
> +	ene_build_cdb(cdb, reg, arg_count);
> +
> +	rq =3D scsi_alloc_request(sdev->request_queue, REQ_OP_DRV_OUT, 0);
> +	if (IS_ERR(rq))
> +		return PTR_ERR(rq);
> +
> +	if (arg_count) {
> +		ret =3D blk_rq_map_kern(rq, (void *)data, arg_count, GFP_NOIO);

[Severity: Low]
Will this compile successfully? Looking at blk_rq_map_kern() in
block/blk-map.c, the function expects 5 arguments with the request queue as
the first parameter, but this call only provides 4. Should this pass
sdev->request_queue as the first argument?

[ ... ]
> +static int asus_aura_register_led(struct asus_aura_zone *zone, int index)
> +{
[ ... ]
> +	/*
> +	 * Include the sdev's H:C:T:L: every enclosure gets its own SCSI
> +	 * host, so the names stay unique when more than one is connected.
> +	 * With a static name the LED core would register the second
> +	 * enclosure's LEDs under renamed nodes (asus-arion:led0_1), which
> +	 * is the wrong device identity. The names are per-attachment, like
> +	 * sd X letters, and userspace is expected to enumerate.
> +	 */
> +	cdev->name =3D kasprintf(GFP_KERNEL, "asus-arion-%s:led%d",
> +			       dev_name(&zone->sdev->sdev_gendev), index);

[Severity: Medium]
Does this format string comply with the standard LED class device naming
conventions? Since the SCSI dev_name() format typically introduces multiple
colons (like 0:0:0:0), and standard LED userspace tools expect the naming
scheme devicename:color:function, will the extra colons break userspace
parsing or udev rules?

[ ... ]
> +static int asus_aura_attach(struct scsi_device *sdev)
> +{
> +	struct asus_aura_zone *zone;
> +	int i, ret;
> +
> +	if (strncmp(sdev->vendor, ARION_INQ_VENDOR, strlen(ARION_INQ_VENDOR)) ||
> +	    strncmp(sdev->model, ARION_INQ_MODEL, strlen(ARION_INQ_MODEL)))
> +		return SCSI_DH_DEV_UNSUPP;
> +
> +	zone =3D kzalloc_obj(*zone, GFP_KERNEL);

[Severity: Low]
Will this cause a build failure? It appears kzalloc_obj is not a defined
kernel allocation macro. Should this be using kzalloc() with sizeof(*zone)
instead?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/202609042030.RFCv3-=
1.lhw@gmail.com?part=3D1
