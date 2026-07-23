Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9640B43744C
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784801723; cv=none; b=P2X7KDoYizUP8W3mPVaOO1chHKDG/JcXOOimX1A+L1nAgIUcdhL8ZNYiz+2FNTNnAbEtZO/+nWK1FQ6WqBoU6ufcleo9XTSIRTbTKFpnBpZkfHrAtVQeN8GeQqS7hnF6KNgCTRDUE3YAT1O8ij9LhrlOty6/LIk/9coF5qg7uvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784801723; c=relaxed/simple;
	bh=hQRRmrxORSlmrZ7M/gksd7/kv3Vr3F4DCGmlmofEeLk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BKF1R71TxsmOweESyQygrwDIjiyV11vslq5IHb0ML5igTuNw4FjJtW2ZoC8ijISNi0FwYdL5iZpF/9v1QalckEkXRBWBDIHwZ1CZOeOlElXUXJHQs8e+itKVUssJG4DepqyPdjbf4pl7/tKYlq+i6NIkxMCLBkOcBe6KpVbTR6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=O5nLpV+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="O5nLpV+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8731C1F000E9;
	Thu, 23 Jul 2026 10:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784801714;
	bh=WIAFmwhE/ygFVupkFYKeAMY20xjoo6+VLAousYCIxZM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O5nLpV+3uWeiG2DRQJKrFmy/8PJRUQg+EjiBDWYTRX2zs5l8PeuwgFEZmdhyx2VmZ
	 fuaBn3wp9GRgd2HLIPvlom1/ZqBcPTzG7om3aBWo3sy83OEB/4ud/2WXr14Ep6IKvn
	 k4rNik/Go50sN25lQBALHUOXlAqEaGv7HYmqe4Hlu6qlzLTmzs7LsCN/BuVMHGTqpT
	 oHjXITjPQsSEFIE3lzWRcoThY6kdu/wGcB+qK1ZPjWIyHFgBfdLO+vAKq6mSv1WqM4
	 IX/Lb1ehhqBtJZuxrd5qLXKSQ3nKpTQwu9ECXhGhWHQGsl4PcHEbH9WeB/aGdTQ+ah
	 NItT5hwv1FKeQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 08/28] libmultipath: Add mpath_bdev_report_zones()
Reply-To: sashiko-reviews@lists.linux.dev
To: "John Garry" <john.g.garry@oracle.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723093627.2327456-9-john.g.garry@oracle.com>
References: <20260723093627.2327456-1-john.g.garry@oracle.com>
 <20260723093627.2327456-9-john.g.garry@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:15:14 +0000
Message-Id: <20260723101514.8731C1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] The multipath head disk fails to initialize `nr_zones`, `zone_capa=
city`, and `last_zone_capacity`, leaving them as 0.
--

--- Patch [8]: [PATCH v4 08/28] libmultipath: Add mpath_bdev_report_zones()=
 ---
commit 62d62f772c0199a5085c139be78e6b1dcd14b410
Author: John Garry <john.garry@linux.dev>

libmultipath: Add mpath_bdev_report_zones()

This commit adds a multipath handler for block_device_operations.report_zon=
es
to libmultipath.

> diff --git a/lib/multipath.c b/lib/multipath.c
> index 3ff4f42a096c2..0232f51f64742 100644
> --- a/lib/multipath.c
> +++ b/lib/multipath.c
> @@ -44,6 +44,30 @@ int mpath_get_iopolicy(char *buf, int iopolicy)
>  }
>  EXPORT_SYMBOL_GPL(mpath_get_iopolicy);
> =20
> +#ifdef CONFIG_BLK_DEV_ZONED
> +static int mpath_bdev_report_zones(struct gendisk *disk, sector_t sector,
> +		unsigned int nr_zones, struct blk_report_zones_args *args)

[Severity: High]
With this function advertising report_zones capability to the block layer, =
are
the zoned attributes for the multipath head disk properly initialized?

If a zoned block device driver uses the libmultipath framework to create a
multipath head, path disks are added via mpath_add_device(). However, it
doesn't appear to propagate the zoned attributes (nr_zones, zone_capacity,
last_zone_capacity) from the underlying path to the head disk.

Since the head disk is bio-based without zone append emulation, the block
layer doesn't automatically trigger blk_revalidate_disk_zones() on it. Will
this leave these attributes at 0, potentially causing zoned filesystems or
userspace tools relying on bdev_nr_zones() and bdev_zone_capacity() to fail
or trigger division-by-zero errors when querying the multipath device?

> +{
> +	struct mpath_head *mpath_head =3D mpath_gendisk_to_head(disk);
> +	struct mpath_device *mpath_device;
> +	int srcu_idx, ret =3D -EWOULDBLOCK;
[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723093627.2327=
456-1-john.g.garry@oracle.com?part=3D8
