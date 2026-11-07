Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794058046;
	b=j7NXGPaqZfPfNHJu679rvfV4fTznZzB13LX3z1XThSIs6cXBV05mtE4NyKHn2rZm/UUS
	 YMZtKTfqIoXLr/KWlWZ5JzKvZOsOXYk0QIjcATIqimsG0ZNiXHKZw0mXgnP33yIXZ2jCz
	 1itsQZIholfu4+so844eSCzzRWWnzIOqaSBxj7MckUhvdqDtREzSdkxn3eaCKbONE+S2i
	 YbO9hWfvf75lFmTcGy2rt1c0I6qFT6TqOmQbq8X7NNiWJZ9TzNWIqQ1qE76DlEzkv/C0i
	 TFe759od2GkjLtR2RAjyW3RKZd/PQr7qcdWjayVWEgxAYb1HdBfUQFaW8AAywfbOLng==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794058046;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=BYuEro8Zcjv6YME7UDOYZvPuRG2H8jml3uCqzjrXjAQ=;
	b=jtO2iMTrm16q88ITJDt8C0ZOTAxc4UP8DM+i5HI74AyqeEoOjMWQkbUaQtOGwXjgSahj
	 PFI6DgJMBy3vgBGCYL0iQwrjzwUceoKe3JBh11ST0oOz9Wc4fGCx/aqbk9of1mVvSxe0l
	 zrtQuNxaHAwM35vSuAmdZOTtXsbzaYkTfIl2eAlVUrwaHU7SwTj6RCZkkhlT1fZQu/T0X
	 8IJCjk6zvHRb3B5b60oK3e+EMSYe5HWPhHH2ds7KGueK+/MMs9+4ayy9BxKvneM/aYA4v
	 1ktihO/xBt/KJwiVSKlRr9YBMM1+mQZau30dEjrsmro4chAwyWjZDFhEAh90FOPjaTA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b="DxOP/HxQ";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C4D0606A326;
	Sat,  7 Nov 2026 13:27:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DxOP/HxQ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 330761F0089F;
	Sat,  7 Nov 2026 13:27:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794058045;
	bh=BYuEro8Zcjv6YME7UDOYZvPuRG2H8jml3uCqzjrXjAQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DxOP/HxQ17GGhExqOPnOumO/V/teeSpqm9C9gguR4xrp2sMcFN3zsxlmtz3+3JyMg
	 3Zi9YHAsAmtOi7ERD+zvDsVpnl4qRla6FXXP6SwihbgS1XGEQQByYi/hGaPhZfEQXZ
	 +iPqG3aqw0Mc/HXAZZDkObIxhrV49gB42KuiWd1F9mt563xQrYkKLjXcv6grdHw+/L
	 YROOQDkMoTSNRr6uX50MIzWJVtj0FpZp7Fc/wJsOfcVyMSv0Di4W3PFAuQlHGTPjJv
	 lbwtegD8FpR89z8SvkZSThW39mtxzdRJmnvNWJm3WlgbVA38QDWWaSXWqGq/OomZBI
	 4mw3Imp3BpWXg==
Message-ID: <sashiko-outbox-202918@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/7] scsi: sg and st: account the command buffer memory
 to memcg
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tao Cui" <cui.tao@linux.dev>, akpm@linux-foundation.org, dgilbert@interlog.com, mkp@kernel.org, loberman@redhat.com, jmeneghi@redhat.com, kraxel@redhat.com, vivek.kasireddy@intel.com, mst@redhat.com, jasowangio@gmail.com, eperezma@redhat.com, stefanha@redhat.com, sgarzare@redhat.com, rostedt@goodmis.org, vdonnefort@google.com, mhiramat@kernel.org, jgg@ziepe.ca, kevin.tian@intel.com, axboe@kernel.dk
Cc: linux-mm@kvack.org, James.Bottomley@HansenPartnership.com, sumit.semwal@linaro.org, christian.koenig@amd.com, phasta@kernel.org, joro@8bytes.org, will@kernel.org, linux-scsi@vger.kernel.org, dri-devel@lists.freedesktop.org, kvm@vger.kernel.org, virtualization@lists.linux.dev, linux-trace-kernel@vger.kernel.org, bobbyeshleman@meta.com, mathieu.desnoyers@efficios.com, robin.murphy@arm.com, mason@kernel.org, aesteve@redhat.com, tjmercier@google.com, harry@kernel.org, vbabka@suse.cz, cuitao@kylinos.cn, media-ci@linuxtv.org
In-Reply-To: <20261106131829.3228926-2-cui.tao@linux.dev>
References: <20261106131829.3228926-1-cui.tao@linux.dev>
 <20261106131829.3228926-2-cui.tao@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 07 Nov 2026 13:27:23 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 4 potential
issues to consider:
- [High] scsi: sg: GFP_ATOMIC | __GFP_ACCOUNT in sg_build_indirect()
  bypasses memcg max
- [Medium] scsi: sg: unrelated and broken blktrace CAP_SYS_ADMIN gate in
  sg_ioctl_common()
- [Medium] scsi: st: misattributed GFP_KERNEL_ACCOUNT probe charges in
  new_tape_buffer()
- [Low] scsi: sg: commit message cites non-existent history in
  sg_build_indirect()
It also noticed 1 related pre-existing issue this patch does not
introduce:
- [High] scsi: sg: shift-out-of-bounds in sg_build_indirect() [1]
--

commit ec96b2b0cdd1df3575b4521cd9f81da9824bc2b2
Author: Tao Cui <cuitao@kylinos.cn>

scsi: sg and st: account the command buffer memory to memcg

This commit adds __GFP_ACCOUNT to buffer and descriptor allocations in the
sg and st drivers to charge them to the calling process's memory cgroup, and
adds a CAP_SYS_ADMIN check for blktrace ioctls in sg_ioctl_common().

> The sg data buffers are unaccounted: the per-fd reserved buffer, the
> scatter-gather page array, and the order-0..N pages behind it, plus the
> per-device tape buffer in st.  All of it is user controllable.  The
> reserved size is capped only by the device max_sectors, SG_MAX_QUEUE
> (16) commands can be in flight per fd, and the fd count is bounded by
> RLIMIT_NOFILE.  Nothing is charged to the memcg of the process driving
> it.  The September 2026 fixes in sg_build_indirect reshaped the element
> sizing and left the accounting alone.

[Severity: Low]
Is the commit message accurate about the history of sg_build_indirect() and
the reserved buffer cap?

In git history, sg_build_indirect() has not been modified since
aaff5ebaa269 ("scsi: remove the unchecked_isa_dma flag") in 2021, and its
element sizing has not changed since 10db10d144c0 ("sg: convert the indirect
IO path to use the block layer") in 2008.  In addition, the initial per-fd
reserved buffer in sg_add_sfp() is capped by min_t(int, def_reserved_size,
max_sectors_bytes(sdp->device->request_queue)), while only resizing via
SG_SET_RESERVED_SIZE is capped solely by max_sectors_bytes().

> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e6c01..80d919fa5cf91 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -910,6 +910,19 @@ static int put_compat_request_table(struct compat_sg=
_req_info __user *o,
>  }
>  #endif
> =20
> +/*
> + * The sg passthrough of the blktrace ioctls has the same exposure as the
> + * block device path: holding the node is the only requirement today, and
> + * a created trace outlives the fd.  Must match the gate in
> + * blk_trace_ioctl().
> + */
> +static bool sg_is_blktrace_cmd(unsigned int cmd)
> +{
> +	return cmd =3D=3D BLKTRACESETUP || cmd =3D=3D BLKTRACESETUP2 ||
> +	       cmd =3D=3D BLKTRACESTART || cmd =3D=3D BLKTRACESTOP ||
> +	       cmd =3D=3D BLKTRACETEARDOWN;
> +}
> +
>  static long
>  sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg_fd *sfp,
>  		unsigned int cmd_in, void __user *p)
> @@ -919,6 +932,9 @@ sg_ioctl_common(struct file *filp, Sg_device *sdp, Sg=
_fd *sfp,
>  	Sg_request *srp;
>  	unsigned long iflags;
> =20
> +	if (sg_is_blktrace_cmd(cmd_in) && !capable(CAP_SYS_ADMIN))
> +		return -EPERM;
> +

[Severity: Medium]
Does this capability check belong in a memcg accounting commit, and does it
cause a UAPI regression for unprivileged users with access to /dev/sg*?

Despite the comment, blk_trace_ioctl() in kernel/trace/blktrace.c does not
check capable(CAP_SYS_ADMIN); block devices gate these ioctls only on access
to the device node.  Moreover, sg_is_blktrace_cmd() matches BLKTRACESETUP2
even though sg_ioctl_common() only implements BLKTRACESETUP, BLKTRACESTART,
BLKTRACESTOP, and BLKTRACETEARDOWN, so unprivileged callers now get -EPERM
instead of -ENOTTY for BLKTRACESETUP2.

> @@ -1841,7 +1857,7 @@ static int
>  sg_build_sgat(Sg_scatter_hold * schp, const Sg_fd * sfp, int tablesize)
>  {
>  	int sg_bufflen =3D tablesize * sizeof(struct page *);
> -	gfp_t gfp_flags =3D GFP_ATOMIC | __GFP_NOWARN;
> +	gfp_t gfp_flags =3D GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT;
> =20
>  	schp->pages =3D kzalloc(sg_bufflen, gfp_flags);
>  	if (!schp->pages)
> @@ -1856,7 +1872,8 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * s=
fp, int buff_size)
>  	int ret_sz =3D 0, i, k, rem_sz, num, mx_sc_elems;
>  	int sg_tablesize =3D sfp->parentdp->sg_tablesize;
>  	int blk_size =3D buff_size, order;
> -	gfp_t gfp_mask =3D GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN | __GFP_ZERO;
> +	gfp_t gfp_mask =3D GFP_ATOMIC | __GFP_COMP | __GFP_NOWARN |
> +			 __GFP_ACCOUNT | __GFP_ZERO;
> =20
>  	if (blk_size < 0)
>  		return -EFAULT;

[Severity: High]
This problem wasn't introduced by this patch, but can the ret_sz shift in
sg_build_indirect() trigger a signed shift-out-of-bounds [1]?

drivers/scsi/sg.c:sg_build_indirect() {
	...
	num =3D scatter_elem_sz;
	...
	order =3D get_order(num);
retry:
	ret_sz =3D 1 << (PAGE_SHIFT + order);
	...
}

On 4 KB page architectures, setting the scatter_elem_sz module parameter
near INT_MAX gives order =3D=3D 19, so 1 << (PAGE_SHIFT + order) evaluates =
the
signed 32-bit shift 1 << 31, triggering UBSAN or yielding a negative ret_sz
that corrupts the allocation loop.

> @@ -2146,7 +2163,7 @@ sg_add_sfp(Sg_device * sdp)
>  	unsigned long iflags;
>  	int bufflen;
> =20
> -	sfp =3D kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN);
> +	sfp =3D kzalloc_obj(*sfp, GFP_ATOMIC | __GFP_NOWARN | __GFP_ACCOUNT);
>  	if (!sfp)
>  		return ERR_PTR(-ENOMEM);

[Severity: High]
Does combining GFP_ATOMIC with __GFP_ACCOUNT in sg_build_sgat(),
sg_build_indirect(), and sg_add_sfp() allow processes to bypass their memcg
memory.max limit?

GFP_ATOMIC sets __GFP_HIGH and lacks __GFP_DIRECT_RECLAIM.  When a memcg is
at memory.max, try_charge_memcg() skips reclaim because the allocation
cannot block and then force-charges past memory.max because __GFP_HIGH is
set:

mm/memcontrol.c:try_charge_memcg() {
	...
nomem:
	if (!(gfp_mask & (__GFP_NOFAIL | __GFP_HIGH)))
		return -ENOMEM;
force:
	page_counter_charge(&memcg->memory, nr_pages);
	...
}

All callers of sg_add_sfp(), sg_build_sgat(), and sg_build_indirect()
(sg_open(), SG_SET_RESERVED_SIZE in sg_ioctl_common(), and sg_start_req())
run in sleepable process context holding only mutexes, so using GFP_KERNEL
would allow memcg reclaim and enforce memory.max.

> diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
> index f1c3c49466379..7083d37622c08 100644
> --- a/drivers/scsi/st.c
> +++ b/drivers/scsi/st.c
> @@ -3973,7 +3973,7 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>  {
>  	struct st_buffer *tb;
> =20
> -	tb =3D kzalloc_obj(struct st_buffer);
> +	tb =3D kzalloc_obj(struct st_buffer, GFP_KERNEL_ACCOUNT);
>  	if (!tb) {
>  		printk(KERN_NOTICE "st: Can't allocate new tape buffer.\n");
>  		return NULL;
> @@ -3982,7 +3982,8 @@ static struct st_buffer *new_tape_buffer(int max_sg)
>  	tb->use_sg =3D max_sg;
>  	tb->buffer_size =3D 0;
> =20
> -	tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg);
> +	tb->reserved_pages =3D kzalloc_objs(struct page *, max_sg,
> +					  GFP_KERNEL_ACCOUNT);
>  	if (!tb->reserved_pages) {
>  		kfree(tb);
>  		return NULL;

[Severity: Medium]
Does using GFP_KERNEL_ACCOUNT in new_tape_buffer() charge the device probe
context instead of the process driving tape I/O?

new_tape_buffer() is only called from st_probe() when a tape device is
attached, and both tb and tb->reserved_pages live until scsi_tape_release(),
so they are never charged to the process performing I/O.  Meanwhile, the
per-I/O page array allocated in the driving process's context during direct
I/O in sgl_map_user_pages() (pages =3D kmalloc_objs(*pages, max_pages))
remains unaccounted.

[1] https://sashiko.dev/#/bug/linux-ccac9556-cc9e-4b08-b44f-5f7ffb342827

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261106131829.3228=
926-1-cui.tao@linux.dev?part=3D1
