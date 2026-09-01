Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A1E3BBFCD
	for <linux-scsi@vger.kernel.org>; Tue,  1 Sep 2026 19:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788291814; cv=none; b=KLDuKs0UFKOdB0HCm1Ow0W9aLe/g9zZRQlDkNgurqs4Mh02RMWLmFPauaRCC0ewpiLlCHx7mQZTNnje0Bh7CmHit0jrKuOW1yAZIRee6OYFt/fgyqdkw8/U7UJwxf/6xtVay5roX3YZAacm8T5PoPyBvPj+NuX/GcnOaezP7GzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788291814; c=relaxed/simple;
	bh=pDvtGZZ0VF8SBGbwMNNmVX1nklk9vC38WU8t8Fqqmt4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Fvhum/RZffxGKtHUdXHhO/XfQCI/TZCt+ippdNOlBP7NZA4uLyKp2OUlodYbeLSoUGKjL3Y8x1R3LTOmyNDu3KN5T0qUb3KpQ3su2DEvRCMKjXTlVl4EsRD+vAIgvGqRganzDQv1dogSo46FP2JhrEOI+LMikHrrZ96U58FiAys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FX1CHBH8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FX1CHBH8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1788291810;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=VSpCeH4nJnJIqhg9kGabtwBGCY223OBzJhazwl7+abk=;
	b=FX1CHBH8Vw5boPXrQRAZs0Gn8oj19ibZQAkmdQWJbh2XV4mwAyoASp/qtqQarJt4NeNpFo
	nYf5NXDpQ9fG9R117xTMOUAYEZZfcxSCXsO3SfTwqDt+/t1F3JyPJ22ZgeeRdYy3u/xJ0w
	UrHEqp7c9Vbk8b5B9JonyfCf/cEvpsE=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-44-7NJGPSj6Pt69Ni7x5jtT8A-1; Tue,
 01 Sept 2026 15:43:25 -0400
X-MC-Unique: 7NJGPSj6Pt69Ni7x5jtT8A-1
X-Mimecast-MFC-AGG-ID: 7NJGPSj6Pt69Ni7x5jtT8A_1788291801
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 54002192DD46;
	Tue,  1 Sep 2026 19:43:21 +0000 (UTC)
Received: from localhost (headnet04.pony-001.prod.iad2.dc.redhat.com [10.2.32.116])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DB74D30001A2;
	Tue,  1 Sep 2026 19:43:18 +0000 (UTC)
Date: Tue, 1 Sep 2026 15:43:17 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Linlin Zhang <linlin.zhang@oss.qualcomm.com>
Cc: ebiggers@kernel.org, axboe@kernel.dk, mst@redhat.com,
	jasowangio@gmail.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, robh@kernel.org, krzk+dt@kernel.org,
	conor+dt@kernel.org, linux-block@vger.kernel.org,
	linux-crypto@vger.kernel.org, linux-scsi@vger.kernel.org,
	virtualization@lists.linux.dev, devicetree@vger.kernel.org,
	linux-arm-msm@vger.kernel.org, neeraj.soni@oss.qualcomm.com,
	gaurav.kashyap@oss.qualcomm.com, mani@kernel.org,
	andersson@kernel.org, konradybcio@kernel.org, bvanassche@acm.org,
	alim.akhtar@samsung.com, avri.altman@sandisk.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	xuanzhuo@linux.alibaba.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 08/11] block: add /dev/blk-crypto-proxy for host-side
 virtio-blk inline encryption
Message-ID: <20260901194316.GD729142@fedora>
References: <20260827160806.1295313-1-linlin.zhang@oss.qualcomm.com>
 <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="sxRW1FDgH5jMjyvK"
Content-Disposition: inline
In-Reply-To: <20260827160806.1295313-9-linlin.zhang@oss.qualcomm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

--sxRW1FDgH5jMjyvK
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Aug 27, 2026 at 09:07:17AM -0700, Linlin Zhang wrote:
> From: linlzhan <linlin.zhang@oss.qualcomm.com>
>=20
> A userspace virtio-blk backend receives VIRTIO_BLK_T_CRYPTO_IN/OUT
> requests from guests that carry a virtual ICE keyslot index and a data
> unit number.  The backend must submit the bio to the host storage
> controller with the correct inline encryption context, but it has
> no in-kernel interface to do so.
>=20
> Add /dev/blk-crypto-proxy, a misc character device that bridges a
> userspace virtio-blk backend to the kernel blk-crypto layer.  The

Question for blk-crypto folks: should this new userspace blk-crypto
interface be at the block device level or at the VFS level? If you
envision that applications might want to manage their own keys and
perform encrypted I/O on files, then maybe this should be at the VFS
level. Block devices would of course be supported by a VFS interface
too.

> interface is three ioctls:
>=20
>   BCP_BIND_CONTEXT      =E2=80=94 bind a host block device fd and a hyper=
visor
>                           VM fd to this file descriptor; the kernel
>                           resolves the VM fd to a guest id and holds
>                           the bdev reference for the fd lifetime.

Is there anything virtualization-specific in this interface? I think
it's really a userspace interface for blk-crypto that can be used by any
userspace application.

It would be nice to name and document the interface without mentioning
virtualization so that we can think about it from a more generic point
of view that allows for new use cases in the future rather than
focussing too much on just the virtualization use case.

>   BCP_GET_CRYPTO_CAPS   =E2=80=94 query the bound device's blk_crypto_pro=
file
>                           capabilities (supported modes, key types, max
>                           DUN bytes) and the number of ICE keyslots
>                           allocated to the bound VM, so the backend can
>                           populate the virtio config space crypto fields.
>   BCP_SUBMIT_IO_BY_VSLOT =E2=80=94 submit an inline-encrypted bio using t=
he
>                           virtual slot index supplied by the guest.  The
>                           kernel resolves virt_slot to a physical ICE
>                           keyslot via bcp_slot_virt_ops, calls
>                           bio_crypt_set_ctx_by_slot(), and submits the
>                           bio synchronously.  Large requests are split
>                           at data-unit boundaries (BIO_MAX_VECS per bio)
>                           to preserve DUN/IV correctness. The
>                           implementation follows the block layer's
>                           direct-I/O path, with two differences: each
>                           bio carries an inline encryption context, and
>                           multiple bios are submitted sequentially
>                           rather than concurrently now.

Linux already has multiple userspace interfaces for submitting I/O, like
preadv(2), io_uring, Linux AIO, etc. I don't think a new ioctl-based
interface just for submitting I/O with blk-crypto metadata makes sense
because applications sometimes spend a lot of time optimizing for the
I/O submission interface (e.g. io_uring) and integrating a new interface
makes adoption hard.

Did you look at how to extend preadv()-related interfaces and io_uring
operations?

>=20
> The driver is hypervisor-agnostic and storage-vendor-agnostic.  Two
> pluggable op-sets registered by platform drivers fill the gaps:
>=20
>   bcp_hypervisor_ops  =E2=80=94 translate a hypervisor VM fd to an opaque
>                         guest_id; implemented by the hypervisor driver.
>   bcp_slot_virt_ops   =E2=80=94 map (profile, guest_id, virt_slot) to a
>                         physical ICE keyslot; implemented by the
>                         platform storage virtualization layer.
>=20
> Both op-sets are RCU-protected singletons; the hot path reads them
> lock-free.
>=20
> Signed-off-by: linlzhan <linlin.zhang@oss.qualcomm.com>
> ---
>  drivers/block/Kconfig                 |  15 +
>  drivers/block/Makefile                |   1 +
>  drivers/block/blk-crypto-proxy.c      | 667 ++++++++++++++++++++++++++
>  include/linux/blk-crypto-proxy.h      | 100 ++++
>  include/uapi/linux/blk-crypto-proxy.h | 122 +++++
>  5 files changed, 905 insertions(+)
>  create mode 100644 drivers/block/blk-crypto-proxy.c
>  create mode 100644 include/linux/blk-crypto-proxy.h
>  create mode 100644 include/uapi/linux/blk-crypto-proxy.h
>=20
> diff --git a/drivers/block/Kconfig b/drivers/block/Kconfig
> index 7790ee2c700c..48ad79734c09 100644
> --- a/drivers/block/Kconfig
> +++ b/drivers/block/Kconfig
> @@ -176,6 +176,21 @@ config BLK_DEV_LOOP
> =20
>  	  Most users will answer N here.
> =20
> +config BLK_CRYPTO_PROXY
> +	tristate "Inline encryption proxy for virtio-blk guests"
> +	depends on BLK_INLINE_ENCRYPTION
> +	help
> +	  Provides /dev/blk-crypto-proxy, a misc character device that allows a
> +	  userspace virtio-blk backend to submit inline-encrypted block I/O
> +	  on behalf of guest virtual machines.
> +
> +	  Guests supply a virtual keyslot index and data unit number with
> +	  each encrypted request.  The host kernel translates the virtual
> +	  slot to a physical hardware keyslot and issues the bio to the
> +	  storage controller with the correct inline encryption context.
> +
> +	  If unsure, say N.
> +
>  config BLK_DEV_LOOP_MIN_COUNT
>  	int "Number of loop devices to pre-create at init time"
>  	depends on BLK_DEV_LOOP
> diff --git a/drivers/block/Makefile b/drivers/block/Makefile
> index 079c910d5fc9..636137248d0d 100644
> --- a/drivers/block/Makefile
> +++ b/drivers/block/Makefile
> @@ -23,6 +23,7 @@ obj-$(CONFIG_BLK_DEV_LOOP)	+=3D loop.o
>  obj-$(CONFIG_SUNVDC)		+=3D sunvdc.o
> =20
>  obj-$(CONFIG_BLK_DEV_NBD)	+=3D nbd.o
> +obj-$(CONFIG_BLK_CRYPTO_PROXY)	+=3D blk-crypto-proxy.o
>  obj-$(CONFIG_VIRTIO_BLK)	+=3D virtio_blk.o
> =20
>  obj-$(CONFIG_VIRTBLK_CRYPTO_VIRTUALIZATION) +=3D virtio_blk_crypto_ext.o
> diff --git a/drivers/block/blk-crypto-proxy.c b/drivers/block/blk-crypto-=
proxy.c
> new file mode 100644
> index 000000000000..60722884dbcd
> --- /dev/null
> +++ b/drivers/block/blk-crypto-proxy.c
> @@ -0,0 +1,667 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +#define pr_fmt(fmt) "blk-crypto-proxy: " fmt
> +
> +#include <linux/module.h>
> +#include <linux/miscdevice.h>
> +#include <linux/fs.h>
> +#include <linux/uaccess.h>
> +#include <linux/slab.h>
> +#include <linux/blkdev.h>
> +#include <linux/bio.h>
> +#include <linux/mutex.h>
> +#include <linux/overflow.h>
> +#include <linux/file.h>
> +#include <linux/mm.h>
> +#include <linux/pagemap.h>
> +#include <linux/rcupdate.h>
> +#include <linux/uio.h>
> +#include <linux/blk-crypto.h>
> +#include <linux/blk-crypto-profile.h>
> +#include <linux/blk-crypto-proxy.h>
> +#include <linux/virtio_blk.h>
> +
> +static const struct bcp_hypervisor_ops __rcu *g_hypervisor_ops;
> +static DEFINE_MUTEX(g_hypervisor_ops_lock);
> +
> +static const struct bcp_slot_virt_ops __rcu *g_slot_virt_ops;
> +static DEFINE_MUTEX(g_slot_virt_ops_lock);
> +
> +int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&g_hypervisor_ops_lock);
> +	if (rcu_access_pointer(g_hypervisor_ops))
> +		ret =3D -EBUSY;
> +	else
> +		rcu_assign_pointer(g_hypervisor_ops, ops);
> +	mutex_unlock(&g_hypervisor_ops_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(bcp_register_hypervisor_ops);
> +
> +void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops)
> +{
> +	mutex_lock(&g_hypervisor_ops_lock);
> +	if (rcu_access_pointer(g_hypervisor_ops) =3D=3D ops)
> +		rcu_assign_pointer(g_hypervisor_ops, NULL);
> +	mutex_unlock(&g_hypervisor_ops_lock);
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(bcp_unregister_hypervisor_ops);
> +
> +int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
> +{
> +	int ret =3D 0;
> +
> +	mutex_lock(&g_slot_virt_ops_lock);
> +	if (rcu_access_pointer(g_slot_virt_ops))
> +		ret =3D -EBUSY;
> +	else
> +		rcu_assign_pointer(g_slot_virt_ops, ops);
> +	mutex_unlock(&g_slot_virt_ops_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(bcp_register_slot_virt_ops);
> +
> +void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops)
> +{
> +	mutex_lock(&g_slot_virt_ops_lock);
> +	if (rcu_access_pointer(g_slot_virt_ops) =3D=3D ops)
> +		rcu_assign_pointer(g_slot_virt_ops, NULL);
> +	mutex_unlock(&g_slot_virt_ops_lock);
> +	synchronize_rcu();
> +}
> +EXPORT_SYMBOL_GPL(bcp_unregister_slot_virt_ops);
> +
> +/**
> + * struct bcp_ctx - per-fd state for /dev/blk-crypto-proxy
> + * @bdev_file: file handle for the bound block device; NULL until BCP_BI=
ND_CONTEXT.
> + *             Published with smp_store_release() so hot-path ioctls can=
 read it
> + *             lock-free via smp_load_acquire() in bcp_ctx_bound().
> + * @guest_id: guest identifier resolved from vm_fd at bind time.
> + * @bdev_writable: block_dev_fd was opened with write access.
> + * @bind_lock: serializes concurrent BCP_BIND_CONTEXT calls on this fd.
> + */
> +struct bcp_ctx {
> +	struct file *bdev_file;
> +	u32 guest_id;
> +	bool bdev_writable;
> +	struct mutex bind_lock;
> +};
> +
> +/*
> + * True once BCP_BIND_CONTEXT has published ctx->bdev_file.  The acquire=
 pairs
> + * with smp_store_release() in bcp_ioctl_bind_context(), ensuring ctx->g=
uest_id
> + * and ctx->bdev_writable are visible to any caller that observes true.
> + */
> +static bool bcp_ctx_bound(struct bcp_ctx *ctx)
> +{
> +	return smp_load_acquire(&ctx->bdev_file) !=3D NULL;
> +}
> +
> +static int bcp_open(struct inode *inode, struct file *file)
> +{
> +	struct bcp_ctx *ctx;
> +
> +	ctx =3D kzalloc_obj(*ctx, GFP_KERNEL);
> +	if (!ctx)
> +		return -ENOMEM;
> +	mutex_init(&ctx->bind_lock);
> +	file->private_data =3D ctx;
> +	return 0;
> +}
> +
> +static int bcp_release(struct inode *inode, struct file *file)
> +{
> +	struct bcp_ctx *ctx =3D file->private_data;
> +
> +	if (ctx) {
> +		if (ctx->bdev_file)
> +			bdev_fput(ctx->bdev_file);
> +		mutex_destroy(&ctx->bind_lock);
> +		kfree(ctx);
> +		file->private_data =3D NULL;
> +	}
> +	return 0;
> +}
> +
> +/*
> + * Resolve a userspace block device fd to a struct file holding a refere=
nce
> + * to the block device, opened with the same access mode as @fd so that a
> + * read-only fd cannot gain write access via BCP_SUBMIT_IO_BY_VSLOT.
> + */
> +static struct file *bcp_bdev_from_fd(int fd, bool *writable)
> +{
> +	struct file *f;
> +	struct inode *inode;
> +	dev_t dev;
> +	blk_mode_t mode =3D 0;
> +
> +	f =3D fget(fd);
> +	if (!f)
> +		return ERR_PTR(-EBADF);
> +	inode =3D file_inode(f);
> +	if (!S_ISBLK(inode->i_mode)) {
> +		fput(f);
> +		return ERR_PTR(-ENOTBLK);
> +	}
> +	if (f->f_mode & FMODE_READ)
> +		mode |=3D BLK_OPEN_READ;
> +	if (f->f_mode & FMODE_WRITE)
> +		mode |=3D BLK_OPEN_WRITE;
> +	if (!mode) {
> +		fput(f);
> +		return ERR_PTR(-EACCES);
> +	}
> +	*writable =3D !!(mode & BLK_OPEN_WRITE);
> +	dev =3D inode->i_rdev;
> +	fput(f);
> +	return bdev_file_open_by_dev(dev, mode, NULL, NULL);
> +}
> +
> +static long bcp_ioctl_bind_context(struct file *file,
> +				   struct bcp_bind_context_arg __user *argp)
> +{
> +	struct bcp_ctx *ctx =3D file->private_data;
> +	struct bcp_bind_context_arg arg;
> +	const struct bcp_hypervisor_ops *hv_ops;
> +	struct file *bdev_file;
> +	u32 guest_id;
> +	bool writable =3D false;
> +	int ret;
> +
> +	if (!ctx)
> +		return -EINVAL;
> +	if (copy_from_user(&arg, argp, sizeof(arg)))
> +		return -EFAULT;
> +	if (arg.reserved)
> +		return -EINVAL;
> +
> +	/*
> +	 * get_guest_id() may sleep; call it before taking bind_lock.
> +	 */
> +	rcu_read_lock();
> +	hv_ops =3D rcu_dereference(g_hypervisor_ops);
> +	if (!hv_ops) {
> +		rcu_read_unlock();
> +		return -EOPNOTSUPP;
> +	}
> +	ret =3D hv_ops->get_guest_id(arg.vm_fd, &guest_id);
> +	rcu_read_unlock();
> +	if (ret)
> +		return ret;
> +
> +	/*
> +	 * Serialize against concurrent BCP_BIND_CONTEXT calls: two callers
> +	 * could both pass the ctx->bdev_file =3D=3D NULL check before either s=
tores.
> +	 */
> +	guard(mutex)(&ctx->bind_lock);
> +
> +	if (ctx->bdev_file)
> +		return -EBUSY;
> +
> +	bdev_file =3D bcp_bdev_from_fd(arg.block_dev_fd, &writable);
> +	if (IS_ERR(bdev_file))
> +		return PTR_ERR(bdev_file);
> +
> +	ctx->guest_id =3D guest_id;
> +	ctx->bdev_writable =3D writable;
> +	/*
> +	 * Publish ctx->bdev_file last with a release barrier; bcp_ctx_bound()
> +	 * reads it with smp_load_acquire() without taking @bind_lock.
> +	 */
> +	smp_store_release(&ctx->bdev_file, bdev_file);
> +	return 0;
> +}
> +
> +/*
> + * Maps VIRTIO_BLK_CRYPTO_MODE_* to enum blk_crypto_mode_num.  The two i=
ndex
> + * spaces do not coincide, so modes_supported[] must not be copied posit=
ionally.
> + * Keep in sync with virtio_blk_crypto_mode_map[] in drivers/block/virti=
o_blk.c.
> + */
> +static const enum blk_crypto_mode_num
> +	bcp_virtio_crypto_mode_map[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] =3D {
> +	[VIRTIO_BLK_CRYPTO_MODE_INVALID]	=3D BLK_ENCRYPTION_MODE_INVALID,
> +	[VIRTIO_BLK_CRYPTO_MODE_AES_256_XTS]	=3D BLK_ENCRYPTION_MODE_AES_256_XT=
S,
> +};
> +
> +static long bcp_ioctl_get_crypto_caps(struct file *file,
> +				      struct bcp_get_crypto_caps_arg __user *argp)
> +{
> +	struct bcp_ctx *ctx =3D file->private_data;
> +	struct bcp_get_crypto_caps_arg arg;
> +	struct block_device *bdev;
> +	u32 modes[VIRTIO_BLK_CRYPTO_MODE_MAX + 1] =3D {0};
> +	struct blk_crypto_profile *profile;
> +	unsigned int i, n;
> +	u32 cap, written;
> +
> +	if (!ctx || !bcp_ctx_bound(ctx))
> +		return -ENXIO;
> +
> +	if (copy_from_user(&arg, argp, sizeof(arg)))
> +		return -EFAULT;
> +	if (arg.num_modes && !arg.modes_ptr)
> +		return -EINVAL;
> +
> +	bdev =3D file_bdev(ctx->bdev_file);
> +	profile =3D bdev_get_queue(bdev)->crypto_profile;
> +	if (!profile)
> +		return -EOPNOTSUPP;
> +
> +	arg.key_types_supported =3D profile->key_types_supported;
> +	/*
> +	 * Clamp to 8: the @dun wire field is a single __aligned_u64 so nothing
> +	 * upstream can deliver a wider DUN regardless of what the profile clai=
ms.
> +	 */
> +	arg.max_dun_bytes =3D min_t(u32, profile->max_dun_bytes_supported, 8);
> +
> +	/*
> +	 * arg.modes_supported[] is indexed by VIRTIO_BLK_CRYPTO_MODE_* (index 0
> +	 * is always 0 per the virtio spec).  Translate via the map above; do n=
ot
> +	 * copy profile->modes_supported[] positionally.
> +	 */
> +	n =3D VIRTIO_BLK_CRYPTO_MODE_MAX + 1;
> +	cap =3D arg.num_modes;
> +	written =3D min_t(u32, cap, n);
> +
> +	for (i =3D 1; i < n; i++) {
> +		enum blk_crypto_mode_num kmode =3D bcp_virtio_crypto_mode_map[i];
> +
> +		if (!kmode)
> +			continue;
> +		modes[i] =3D profile->modes_supported[kmode];
> +	}
> +
> +	if (written &&
> +	    copy_to_user(u64_to_user_ptr(arg.modes_ptr), modes,
> +			 written * sizeof(modes[0])))
> +		return -EFAULT;
> +	arg.num_modes =3D written;
> +
> +	arg.max_slots =3D 0;
> +	rcu_read_lock();
> +	{
> +		const struct bcp_slot_virt_ops *sv_ops =3D
> +				rcu_dereference(g_slot_virt_ops);
> +		if (sv_ops) {
> +			int nslots =3D sv_ops->get_guest_slots(profile, ctx->guest_id);
> +
> +			if (nslots > 0)
> +				arg.max_slots =3D nslots;
> +		}
> +	}
> +	rcu_read_unlock();
> +
> +	if (copy_to_user(argp, &arg, sizeof(arg)))
> +		return -EFAULT;
> +	return 0;
> +}
> +
> +/*
> + * Compute the number of pages needed for up to @want_bytes of iovec data
> + * starting at cursor (@start_idx, @start_off).  The page count is cappe=
d at
> + * @cap to bound the arithmetic; *bytes_out receives the actual byte cou=
nt.
> + */
> +static unsigned int bcp_iov_pages_for_bytes(const struct iovec *iov, u32=
 iov_cnt,
> +					    u32 start_idx, u64 start_off,
> +					      u64 want_bytes, unsigned int cap,
> +					      u64 *bytes_out)
> +{
> +	u64 pages =3D 0, taken =3D 0;
> +	u32 i;
> +
> +	for (i =3D start_idx; i < iov_cnt && taken < want_bytes; i++) {
> +		u64 base, len;
> +
> +		if (i =3D=3D start_idx) {
> +			base =3D (u64)(uintptr_t)iov[i].iov_base + start_off;
> +			len  =3D iov[i].iov_len - start_off;
> +		} else {
> +			base =3D (u64)(uintptr_t)iov[i].iov_base;
> +			len  =3D iov[i].iov_len;
> +		}
> +		if (len =3D=3D 0)
> +			continue;
> +		if (len > want_bytes - taken)
> +			len =3D want_bytes - taken;
> +		pages +=3D DIV_ROUND_UP(len + offset_in_page(base), PAGE_SIZE);
> +		taken +=3D len;
> +		if (pages >=3D cap) {
> +			*bytes_out =3D taken;
> +			return cap;
> +		}
> +	}
> +	*bytes_out =3D taken;
> +	return (unsigned int)pages;
> +}
> +
> +/*
> + * Advance cursor (*idx, *off) forward by @bytes within @iov[0..iov_cnt).
> + */
> +static void bcp_iov_advance_cursor(const struct iovec *iov, u32 iov_cnt,
> +				   u32 *idx, u64 *off, u64 bytes)
> +{
> +	while (bytes > 0 && *idx < iov_cnt) {
> +		u64 seg_remaining =3D iov[*idx].iov_len - *off;
> +		u64 take =3D min_t(u64, seg_remaining, bytes);
> +
> +		*off +=3D take;
> +		bytes -=3D take;
> +		if (*off =3D=3D iov[*idx].iov_len) {
> +			(*idx)++;
> +			*off =3D 0;
> +		}
> +	}
> +}
> +
> +static long bcp_ioctl_submit_io_by_vslot(struct file *file,
> +					 struct bcp_submit_io_by_vslot_arg __user *argp)
> +{
> +	struct bcp_ctx *ctx =3D file->private_data;
> +	struct bcp_submit_io_by_vslot_arg arg;
> +	struct block_device *bdev;
> +	struct blk_crypto_profile *profile;
> +	struct iovec *iov =3D NULL;
> +	struct iov_iter iter;
> +	struct blk_crypto_slot slot;
> +	u64 dun[BLK_CRYPTO_DUN_ARRAY_SIZE];
> +	u64 bytes_done =3D 0;
> +	u64 align, stride;
> +	u64 total_bytes;
> +	u32 seg_idx =3D 0;
> +	u64 seg_off =3D 0;
> +	unsigned int phy_slot;
> +	int ret =3D -EFAULT;
> +
> +	if (!ctx || !bcp_ctx_bound(ctx))
> +		return -ENXIO;
> +
> +	if (copy_from_user(&arg, argp, sizeof(arg)))
> +		return -EFAULT;
> +	if (arg.reserved2)
> +		return -EINVAL;
> +
> +	bdev =3D file_bdev(ctx->bdev_file);
> +
> +	if (arg.direction !=3D BCP_DIR_READ && arg.direction !=3D BCP_DIR_WRITE)
> +		return -EINVAL;
> +	/*
> +	 * blk_mode_t does not stop submit_bio() from writing; enforce the
> +	 * caller's original fd permission explicitly.
> +	 */
> +	if (arg.direction =3D=3D BCP_DIR_WRITE && !ctx->bdev_writable)
> +		return -EACCES;
> +	/*
> +	 * bdev_read_only() can change after bind time; submit_bio_noacct()'s
> +	 * bio_check_ro() only warns rather than errors in this kernel.
> +	 */
> +	if (arg.direction =3D=3D BCP_DIR_WRITE && bdev_read_only(bdev))
> +		return -EROFS;
> +	if (arg.flags !=3D BCP_SUBMIT_IO_F_IOV)
> +		return -EINVAL;
> +	if (arg.iov_cnt =3D=3D 0 || arg.iov_cnt > BCP_MAX_IOV)
> +		return -EINVAL;
> +	/* A shift amount >=3D 64 would be undefined behavior. */
> +	if (arg.data_unit_size_bits >=3D 64)
> +		return -EINVAL;
> +
> +	profile =3D bdev_get_queue(bdev)->crypto_profile;
> +	if (!profile)
> +		return -EOPNOTSUPP;
> +
> +	/* Resolve virt_slot =E2=86=92 phy_slot. */
> +	rcu_read_lock();
> +	{
> +		const struct bcp_slot_virt_ops *sv_ops =3D
> +				rcu_dereference(g_slot_virt_ops);
> +		if (!sv_ops) {
> +			rcu_read_unlock();
> +			return -EOPNOTSUPP;
> +		}
> +		ret =3D sv_ops->vslot_to_pslot(profile, ctx->guest_id,
> +					     arg.virt_slot, &phy_slot);
> +	}
> +	rcu_read_unlock();
> +	if (ret)
> +		return ret;
> +
> +	memset(dun, 0, sizeof(dun));
> +	dun[0] =3D arg.dun;
> +
> +	slot.phy_slot            =3D phy_slot;
> +	slot.data_unit_size_bits =3D arg.data_unit_size_bits;
> +
> +	align =3D 1ULL << arg.data_unit_size_bits;
> +	/*
> +	 * Split bios at stride (smallest multiple of the data unit size >=3D
> +	 * PAGE_SIZE) boundaries so each bio ends on a whole data unit.
> +	 * bio_crypt_check_alignment() is skipped for slot-based bios (bc_key
> +	 * =3D=3D NULL), so a mid-unit split would silently mis-encrypt/mis-dec=
rypt.
> +	 */
> +	stride =3D DIV_ROUND_UP(PAGE_SIZE, align) * align;
> +
> +	/*
> +	 * Import the caller's iovec once.  import_iovec() validates every
> +	 * segment with access_ok(), returns the total byte count, and takes a
> +	 * private kernel copy that eliminates TOCTOU from a guest mutating its
> +	 * own iovec array mid-ioctl.
> +	 */
> +	ret =3D import_iovec(arg.direction =3D=3D BCP_DIR_READ ? ITER_DEST : IT=
ER_SOURCE,
> +			   (const struct iovec __user *)u64_to_user_ptr(arg.iov_ptr),
> +			   arg.iov_cnt, 0, &iov, &iter);
> +	if (ret < 0)
> +		return ret;
> +	total_bytes =3D ret;
> +
> +	/*
> +	 * Reject a misaligned total length up front: bio_crypt_check_alignment=
()
> +	 * is skipped for slot-based bios so nothing downstream will catch it.
> +	 */
> +	if (total_bytes =3D=3D 0 || (total_bytes & (align - 1)) ||
> +	    (total_bytes & (SECTOR_SIZE - 1))) {
> +		ret =3D -EINVAL;
> +		goto out;
> +	}
> +
> +	/*
> +	 * Fail fast if the request exceeds the device.  bio_check_eod() would
> +	 * also catch this, but only on the last bio after earlier bios have
> +	 * already done real I/O.
> +	 */
> +	{
> +		sector_t nr_sectors =3D total_bytes >> SECTOR_SHIFT;
> +		sector_t maxsector =3D bdev_nr_sectors(bdev);
> +
> +		if (nr_sectors > maxsector || arg.sector > maxsector - nr_sectors) {
> +			ret =3D -EIO;
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Reject an out-of-range DUN: slot-based bios skip
> +	 * bio_crypt_check_alignment(), so an overflow would silently truncate
> +	 * in the hardware DUN field rather than error out.
> +	 */
> +	{
> +		u64 total_units =3D total_bytes >> arg.data_unit_size_bits;
> +		u64 max_dun_used, dun_limit;
> +
> +		if (check_add_overflow(arg.dun, total_units - 1, &max_dun_used)) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +		dun_limit =3D profile->max_dun_bytes_supported >=3D 8 ? U64_MAX :
> +			(1ULL << (8 * profile->max_dun_bytes_supported)) - 1;
> +		if (max_dun_used > dun_limit) {
> +			ret =3D -EINVAL;
> +			goto out;
> +		}
> +	}
> +
> +	/*
> +	 * Submit the request as a sequence of bios (submit_bio_wait() per
> +	 * bio), each holding at most BIO_MAX_VECS pages.  Sequential
> +	 * submission avoids DUN/IV correctness concerns across concurrent
> +	 * in-flight bios.
> +	 */
> +	while (seg_idx < arg.iov_cnt) {
> +		unsigned int pages_used =3D 0;
> +		u64 bio_bytes =3D 0;
> +		u32 la_idx =3D seg_idx;
> +		u64 la_off =3D seg_off;
> +		u64 remaining_before;
> +		struct bio *bio;
> +
> +		/*
> +		 * Lookahead: count how many whole stride units fit within a
> +		 * fresh bio's BIO_MAX_VECS page budget.
> +		 */
> +		for (;;) {
> +			u64 unit_bytes;
> +			unsigned int unit_pages;
> +
> +			unit_pages =3D bcp_iov_pages_for_bytes(iov, arg.iov_cnt,
> +							     la_idx, la_off, stride,
> +							BIO_MAX_VECS + 1,
> +							&unit_bytes);
> +			if (unit_bytes =3D=3D 0)
> +				break; /* only empty segments remain */
> +
> +			if (pages_used + unit_pages > BIO_MAX_VECS) {
> +				if (pages_used =3D=3D 0) {
> +					/* data_unit_size_bits too large to fit one unit. */
> +					ret =3D -EINVAL;
> +					goto out;
> +				}
> +				break; /* finalize this bio; unit deferred to next */
> +			}
> +
> +			pages_used +=3D unit_pages;
> +			bio_bytes  +=3D unit_bytes;
> +			bcp_iov_advance_cursor(iov, arg.iov_cnt, &la_idx, &la_off,
> +					       unit_bytes);
> +		}
> +
> +		if (bio_bytes =3D=3D 0)
> +			break;
> +
> +		bio =3D bio_alloc(bdev, pages_used,
> +				arg.direction =3D=3D BCP_DIR_WRITE ?
> +					REQ_OP_WRITE : REQ_OP_READ,
> +				GFP_KERNEL);
> +		if (!bio) {
> +			ret =3D -ENOMEM;
> +			goto out;
> +		}
> +		bio->bi_iter.bi_sector =3D arg.sector + (bytes_done >> SECTOR_SHIFT);
> +
> +		/*
> +		 * Use bio_iov_iter_get_pages() to pin pages into the bio,
> +		 * the same as the O_DIRECT path.  Truncate the iter to this
> +		 * bio's byte budget, then reexpand for the next iteration.
> +		 */
> +		remaining_before =3D iov_iter_count(&iter);
> +		iov_iter_truncate(&iter, bio_bytes);
> +		ret =3D bio_iov_iter_get_pages(bio, &iter, 0, 0);
> +		if (ret < 0) {
> +			bio_put(bio);
> +			goto out;
> +		}
> +		if (iov_iter_count(&iter) !=3D 0) {
> +			/*
> +			 * The lookahead verified bio_bytes fits in BIO_MAX_VECS;
> +			 * if bio_iov_iter_get_pages() stopped early, its page
> +			 * accounting disagreed with bcp_iov_pages_for_bytes().
> +			 */
> +			bio_put(bio);
> +			ret =3D -EIO;
> +			goto out;
> +		}
> +		iov_iter_reexpand(&iter, remaining_before - bio_bytes);
> +
> +		/*
> +		 * Match __blkdev_direct_IO(): mark pages dirty on reads into
> +		 * user-backed memory.
> +		 */
> +		if (arg.direction =3D=3D BCP_DIR_READ && user_backed_iter(&iter))
> +			bio_set_pages_dirty(bio);
> +
> +		bcp_iov_advance_cursor(iov, arg.iov_cnt, &seg_idx, &seg_off,
> +				       bio_bytes);
> +
> +		bio_crypt_set_ctx_by_slot(bio, &slot, dun, GFP_KERNEL);
> +
> +		ret =3D submit_bio_wait(bio);
> +		bio_put(bio);
> +		if (ret)
> +			goto out;
> +
> +		/*
> +		 * Advance dun by this bio's contribution only, not by
> +		 * recomputing from arg.dun + bytes_done, to avoid silent
> +		 * truncation when bytes_done grows past UINT_MAX data units.
> +		 */
> +		bio_crypt_dun_increment(dun, (unsigned int)(bio_bytes >> arg.data_unit=
_size_bits));
> +		bytes_done +=3D bio_bytes;
> +	}
> +	ret =3D 0;
> +
> +out:
> +	kfree(iov);
> +	return ret;
> +}
> +
> +static long bcp_ioctl(struct file *file, unsigned int cmd, unsigned long=
 arg)
> +{
> +	void __user *argp =3D (void __user *)arg;
> +
> +	switch (cmd) {
> +	case BCP_BIND_CONTEXT:
> +		return bcp_ioctl_bind_context(file, argp);
> +	case BCP_GET_CRYPTO_CAPS:
> +		return bcp_ioctl_get_crypto_caps(file, argp);
> +	case BCP_SUBMIT_IO_BY_VSLOT:
> +		return bcp_ioctl_submit_io_by_vslot(file, argp);
> +	default:
> +		return -ENOTTY;
> +	}
> +}
> +
> +static const struct file_operations bcp_fops =3D {
> +	.owner		=3D THIS_MODULE,
> +	.open		=3D bcp_open,
> +	.release	=3D bcp_release,
> +	.unlocked_ioctl	=3D bcp_ioctl,
> +	.compat_ioctl	=3D compat_ptr_ioctl,
> +};
> +
> +static struct miscdevice bcp_misc =3D {
> +	.minor	=3D MISC_DYNAMIC_MINOR,
> +	.name	=3D "blk-crypto-proxy",
> +	.fops	=3D &bcp_fops,
> +};
> +
> +static int __init blk_crypto_proxy_init(void)
> +{
> +	int ret;
> +
> +	ret =3D misc_register(&bcp_misc);
> +	if (ret)
> +		return ret;
> +	return 0;
> +}
> +
> +static void __exit blk_crypto_proxy_exit(void)
> +{
> +	misc_deregister(&bcp_misc);
> +}
> +
> +module_init(blk_crypto_proxy_init);
> +module_exit(blk_crypto_proxy_exit);
> +
> +MODULE_LICENSE("GPL");
> +MODULE_DESCRIPTION("Host-side inline crypto proxy for virtio-blk guests"=
);
> diff --git a/include/linux/blk-crypto-proxy.h b/include/linux/blk-crypto-=
proxy.h
> new file mode 100644
> index 000000000000..6cf1ff0703e9
> --- /dev/null
> +++ b/include/linux/blk-crypto-proxy.h
> @@ -0,0 +1,100 @@
> +/* SPDX-License-Identifier: GPL-2.0-only */
> +
> +#ifndef __LINUX_BLK_CRYPTO_PROXY_H
> +#define __LINUX_BLK_CRYPTO_PROXY_H
> +
> +#include <uapi/linux/blk-crypto-proxy.h>
> +#include <linux/types.h>
> +
> +struct blk_crypto_profile;
> +
> +/**
> + * struct bcp_hypervisor_ops - hypervisor VM identity operations
> + *
> + * Translates a hypervisor-specific VM fd to the opaque u32 vm_id used
> + * throughout blk-crypto-proxy.  Register once at module init time.
> + */
> +struct bcp_hypervisor_ops {
> +	/**
> +	 * @get_guest_id: Resolve @vm_fd to an opaque guest identifier.
> +	 *
> +	 * Verify the caller is permitted to act on behalf of the VM and write
> +	 * its u32 id to @guest_id_out.  The value is passed verbatim to
> +	 * bcp_slot_virt_ops callbacks.
> +	 *
> +	 * Returns 0 on success, -errno on failure.
> +	 */
> +	int (*get_guest_id)(int vm_fd, u32 *guest_id_out);
> +};
> +
> +/**
> + * bcp_register_hypervisor_ops() - register the hypervisor op-set
> + * @ops: op-set to register; must remain valid until unregistered.
> + *
> + * Returns 0 on success, -EBUSY if an op-set is already registered.
> + */
> +int bcp_register_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
> +
> +/**
> + * bcp_unregister_hypervisor_ops() - unregister the hypervisor op-set
> + * @ops: must be the pointer that was passed to bcp_register_hypervisor_=
ops().
> + *
> + * Blocks until all in-flight callers have finished, then clears the
> + * registration.  Safe to call from module exit.
> + */
> +void bcp_unregister_hypervisor_ops(const struct bcp_hypervisor_ops *ops);
> +
> +/**
> + * struct bcp_slot_virt_ops - ICE keyslot virtualization operations
> + *
> + * Per-VM ICE keyslot accounting and virtual-to-physical slot translatio=
n.
> + * The implementation owns the slot allocation table and is registered o=
nce
> + * at platform driver probe time.
> + *
> + * @profile is passed to every callback so an implementation supporting
> + * multiple storage controllers can distinguish between them.
> + *
> + * All callbacks may be called concurrently and must not sleep (called
> + * under RCU read lock).
> + */
> +struct bcp_slot_virt_ops {
> +	/**
> +	 * @get_guest_slots: Return the number of ICE keyslots allocated to @gu=
est_id.
> +	 *
> +	 * Returns the slot count (=E2=89=A5 1) on success, -ENOKEY if @guest_i=
d is
> +	 * not in the allocation table.
> +	 */
> +	int (*get_guest_slots)(struct blk_crypto_profile *profile, u32 guest_id=
);
> +
> +	/**
> +	 * @vslot_to_pslot: Translate a VM-local virtual slot to a physical slo=
t.
> +	 * @guest_id:       hypervisor-assigned VM identifier.
> +	 * @virt_slot:   0-based slot index within @guest_id's allocation.
> +	 * @phy_slot_out: receives the physical ICE keyslot index on success.
> +	 *
> +	 * Returns 0 on success, -ENOKEY if @guest_id is unknown, -EINVAL if
> +	 * @virt_slot >=3D the VM's allocation.
> +	 */
> +	int (*vslot_to_pslot)(struct blk_crypto_profile *profile,
> +			      u32 guest_id, u32 virt_slot,
> +			      unsigned int *phy_slot_out);
> +};
> +
> +/**
> + * bcp_register_slot_virt_ops() - register the slot-virt op-set
> + * @ops: op-set to register; must remain valid until unregistered.
> + *
> + * Returns 0 on success, -EBUSY if an op-set is already registered.
> + */
> +int bcp_register_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
> +
> +/**
> + * bcp_unregister_slot_virt_ops() - unregister the slot-virt op-set
> + * @ops: must be the pointer passed to bcp_register_slot_virt_ops().
> + *
> + * Blocks until all in-flight callers have finished, then clears the
> + * registration.  Safe to call from module exit.
> + */
> +void bcp_unregister_slot_virt_ops(const struct bcp_slot_virt_ops *ops);
> +
> +#endif /* __LINUX_BLK_CRYPTO_PROXY_H */
> diff --git a/include/uapi/linux/blk-crypto-proxy.h b/include/uapi/linux/b=
lk-crypto-proxy.h
> new file mode 100644
> index 000000000000..dc8adc8ef5ed
> --- /dev/null
> +++ b/include/uapi/linux/blk-crypto-proxy.h
> @@ -0,0 +1,122 @@
> +/* SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note */
> +
> +#ifndef __UAPI_LINUX_BLK_CRYPTO_PROXY_H
> +#define __UAPI_LINUX_BLK_CRYPTO_PROXY_H
> +
> +#include <linux/types.h>
> +#include <linux/ioctl.h>
> +
> +#define BCP_DIR_READ     0
> +#define BCP_DIR_WRITE    1
> +
> +/*
> + * BCP_BIND_CONTEXT - bind a host block device and hypervisor VM fd.
> + *
> + * Must be called once after open(), before any other ioctl.
> + * Returns -EBUSY if already bound, -EOPNOTSUPP if no hypervisor op-set
> + * is registered.
> + *
> + * @block_dev_fd: fd of the host block device to bind.
> + * @vm_fd:        hypervisor VM fd identifying the guest.
> + * @reserved:     must be zero.
> + */
> +struct bcp_bind_context_arg {
> +	__s32 block_dev_fd;
> +	__s32 vm_fd;
> +	__u32 reserved;
> +};
> +
> +/*
> + * BCP_GET_CRYPTO_CAPS - query crypto capabilities of the bound block de=
vice.
> + *
> + * Requires BCP_BIND_CONTEXT; returns -ENXIO otherwise.
> + *
> + * @key_types_supported:  [out] BLK_CRYPTO_KEY_TYPE_* bitmask.
> + * @max_dun_bytes:        [out] maximum DUN bytes supported.
> + * @max_slots:            [out] maximum ICE keyslots available for the b=
ound VM;
> + *                              0 if the VM is not found in the table.
> + * @num_modes:            [in] capacity of the buffer pointed to by @mod=
es_ptr,
> + *                              in entries. [out] number of entries actu=
ally
> + *                              written to @modes_ptr (may be less than =
the
> + *                              given capacity; the caller must use this
> + *                              value, not its own capacity, to know how=
 many
> + *                              entries are valid).
> + * @modes_ptr:             [in] pointer to a caller-allocated __u32 arra=
y of
> + *                              at least @num_modes (as given) entries. =
Must
> + *                              be non-NULL if @num_modes (as given) is =
> 0.
> + *                              On return, holds a per-mode data_unit_si=
ze
> + *                              bitmask array indexed by VIRTIO_BLK_CRYP=
TO_MODE_*
> + *                              (virtio wire numbering, uapi/linux/virti=
o_blk.h)
> + *                              -- NOT by enum blk_crypto_mode_num. Inde=
x 0 is
> + *                              reserved and always 0, matching struct
> + *                              virtio_blk_crypto_modes.modes[].
> + *
> + * @modes_ptr is a pointer + count rather than a fixed-size array embedd=
ed in
> + * this struct so that sizeof(struct bcp_get_crypto_caps_arg) -- and hen=
ce the
> + * _IOWR-encoded ioctl number -- does not depend on VIRTIO_BLK_CRYPTO_MO=
DE_MAX.
> + * The caller and this kernel may be built against different virtio_blk.h
> + * versions (and thus different values of that constant); embedding a
> + * VIRTIO_BLK_CRYPTO_MODE_MAX-sized array directly in this struct would =
make
> + * the ioctl fail to even dispatch (-ENOTTY) whenever the two disagree.
> + */
> +
> +struct bcp_get_crypto_caps_arg {
> +	__u32 key_types_supported;
> +	__u32 max_dun_bytes;
> +	__u32 max_slots;
> +	__u32 num_modes;
> +	__aligned_u64 modes_ptr;
> +};
> +
> +/*
> + * BCP_SUBMIT_IO_BY_VSLOT - submit an encrypted bio using a virtual slot.
> + *
> + * The kernel resolves virt_slot to a physical ICE keyslot and submits t=
he
> + * I/O synchronously.  Large requests are split at data-unit boundaries
> + * (BIO_MAX_VECS pages per bio).  Requires BCP_BIND_CONTEXT; returns -EN=
XIO
> + * otherwise.
> + *
> + * @virt_slot:           guest-visible slot index (0-based within the VM=
's range).
> + * @direction:           BCP_DIR_READ or BCP_DIR_WRITE.
> + * @flags:               must be BCP_SUBMIT_IO_F_IOV.
> + * @data_unit_size_bits: log2 of the encryption data unit size in bytes.
> + * @sector:              start sector (512-byte units).
> + * @dun:                 data unit number (single 64-bit limb, little-en=
dian).
> + * @iov_ptr:             pointer to scatter-gather array of struct bcp_i=
ovec.
> + * @iov_cnt:             number of entries in @iov_ptr[].
> + * @reserved2:           must be zero.
> + *
> + * @sector, @dun and @iov_ptr use __aligned_u64 to guarantee identical s=
truct
> + * layout between 32-bit and 64-bit callers, as required by
> + * .compat_ioctl =3D compat_ptr_ioctl.
> + */
> +
> +/* Maximum iovec segments per BCP_SUBMIT_IO_BY_VSLOT call (matches UIO_M=
AXIOV). */
> +#define BCP_MAX_IOV            1024
> +
> +#define BCP_SUBMIT_IO_F_IOV    (1U << 0)	/* scatter-gather mode; must al=
ways be set */
> +
> +struct bcp_iovec {
> +	__u64 iov_base;
> +	__u64 iov_len;
> +};
> +
> +struct bcp_submit_io_by_vslot_arg {
> +	__u32 virt_slot;
> +	__u32 direction;
> +	__u32 flags;
> +	__u32 data_unit_size_bits;
> +	__aligned_u64 sector;
> +	__aligned_u64 dun;
> +	__aligned_u64 iov_ptr;
> +	__u32 iov_cnt;
> +	__u32 reserved2;
> +};
> +
> +#define BCP_IOC_MAGIC    0xC7
> +
> +#define BCP_BIND_CONTEXT       _IOW(BCP_IOC_MAGIC, 1, struct bcp_bind_co=
ntext_arg)
> +#define BCP_GET_CRYPTO_CAPS    _IOWR(BCP_IOC_MAGIC, 2, struct bcp_get_cr=
ypto_caps_arg)
> +#define BCP_SUBMIT_IO_BY_VSLOT  _IOW(BCP_IOC_MAGIC, 3, struct bcp_submit=
_io_by_vslot_arg)
> +
> +#endif /* __UAPI_LINUX_BLK_CRYPTO_PROXY_H */
> --=20
> 2.34.1
>=20

--sxRW1FDgH5jMjyvK
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmqXKtUACgkQnKSrs4Gr
c8hM6wf/aVQgw6iiQexve/dmavuYlWfFGIhaI9CFIlhLbXVC07XxukOBfwxt0+ql
Zsz44U3uqrEfWhdGtd2lG3Rw9EBNfO0XMYyKfecCvXRTn4qCjNApn4Gq8xWNLZhv
4Jz7tnXXhti/kcN+dONkzQBK9YpCuv0zTk++jvawNj1GSUnGqH3GDB6PkrCWuIZZ
4hj3/rPhqPUcWpBjveOB+plb8vquz4cAWwZcMXIBfeutqrM2xCeobyIrywkqp5zq
YFvfd7LUr6sA+R9ZOGJtpm6fw9V2YK6pwWNjo0MW7c3uMxRMoHP+zKuZU1Ex+Bhc
DXxVHt4QdiylTcm9io2ugjzl/+gjOw==
=Lc5Q
-----END PGP SIGNATURE-----

--sxRW1FDgH5jMjyvK--

