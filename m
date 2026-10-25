Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=51.159.59.229
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792906407;
	b=Eqretz7lrp/4G5IdE2kPpf1AOt+X5+E/1tQuaMpaarRe1X7XoNwnbTeNH0jOBIjP6FAX
	 5+HpiOWTYEm+jO2NxAgNjIRVtnkKef4YCrQ0ZgX4PGOo7l+h6Y4NPHQ12lJHDH/sgs3gh
	 yKdb3ixVp+DsIfCaLzupo8BSlMdNjMF/nw5HhfMOWj/wxizj7Vi9rmwiAD5VCNcbGYJG1
	 6hMhFNcwnh79yhBZ8wHCJ6zO7Y1Nn2exWBxwB2At5wUWhsFA6DKKFh861cISONbGQ93gl
	 DQjZx3A1zET1TOtZ3C5+BE68ze4EB1RWrJFl/sihZaiYH+L/I3r3zN/pwLMty5fh41Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792906407;
	h=DMARC-Filter:DKIM-Signature:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To;
	bh=oU+IxGD7sm3gCtpT4r+PI3Zmmtws95JgE05PpMuUfD0=;
	b=BPqPM5P/eTSmDIlwvTZcqCuFbE3i62cVWUTfpSh7GESTqlWgX0CscS3IhNC70LEZva9C
	 j/+j6DgsSjvU92D4y3hx41pl9mQ6UmXBgCZ5KVuRyrcbl1pI0flDa5ZEPyNRIUD7xBRDH
	 radgLOZ0FrBFstvJdxcb7OTyysTdlBs5J59vm/gNo8Hk60i6XeEoQGvar592llfh7THej
	 z56pFkbIEAKShN7v3QUp1wsZr8hobN5lkGiLHZHP8Z1IrsMlJhYrg+Gq0NT1Ck6OX0yWu
	 07Kop433vHr7ey1BkBefK1ioGj6zKewOQuCpuOjipQpB/MzPm3+/XAieEhI1LnO8D8Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=1wt.eu;
	spf=pass smtp.mailfrom=1wt.eu;
	dkim=pass header.d=1wt.eu header.i=@1wt.eu header.a=rsa-sha256 header.s=mail header.b=l2YaRF4k;
	arc=none smtp.remote-ip=51.159.59.229
Received: from mta1.formilux.org (mta1.formilux.org [51.159.59.229])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FC60606A31D
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 05:33:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8FC60606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=1wt.eu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=1wt.eu
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=1wt.eu header.i=@1wt.eu header.a=rsa-sha256 header.s=mail header.b=l2YaRF4k
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=1wt.eu; s=mail;
	t=1792906398; bh=oU+IxGD7sm3gCtpT4r+PI3Zmmtws95JgE05PpMuUfD0=;
	h=From:Message-ID:From;
	b=l2YaRF4kC0pkbYPUSUQ9C6i6shOi69yoPl6l/4ldaUhlIfO53iysC0eaWwEBgtR20
	 zT5zR1ActJYLMXwBvrhz7QqIVfbc+tc43TV3UVCYQOw/ZK/deXUYHIwtdgd1RbV43n
	 za/ajW9lxaLbeFMf2RJsJRi8YXQ8RtLLolkzsRp4=
Received: from 1wt.eu (ded1.1wt.eu [163.172.96.212])
	by mta1.formilux.org (Postfix) with ESMTP id B1659C0945;
	Sun, 25 Oct 2026 06:33:18 +0100 (CET)
Date: Sun, 25 Oct 2026 06:33:18 +0100
From: Willy Tarreau <w@1wt.eu>
To: Maholi Tumanggor <maholitumanggor@gmail.com>
Cc: linux-scsi@vger.kernel.org, ranjan.kumar@broadcom.com,
        sathya.prakash@broadcom.com, sreekanth.reddy@broadcom.com,
        suganath-prabu.subramani@broadcom.com
Subject: Re: [BUG] drivers/message/fusion/mptctl: heap buffer overflow in
 kbuf_alloc_2_sgl
Message-ID: <at2UntF92zq3ESnP@1wt.eu>
References: <CAELScTa0EePsq_Aivwb2rukQL_vNprumuH8jdwk2ST6rio=dgw@mail.gmail.com>
 <CAELScTa0EePsq_Aivwb2rukQL_vNprumuH8jdwk2ST6rio=dgw@mail.gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELScTa0EePsq_Aivwb2rukQL_vNprumuH8jdwk2ST6rio=dgw@mail.gmail.com>

Hello,

Thanks for your report. The maintainers have been added in Cc. Please
don't forget to add them next time, as per
Documentation/process/security-bugs.rst. Also there's no need to Cc
security@k.o when reporting to public lists (now moved to Bcc).
Regardless, a few comments below.

On Sun, 25 Oct 2026 11:01:44 +0700, maholitumanggor@gmail.com wrote:
> Reported-by: *Maholi Tumanggor* [maholitumanggor@gmail.com]
>
>
> *AFFECTED FILE*=============
> drivers/message/fusion/mptctl.c
> Verified identical in mainline (84738 bytes):
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/plain/drivers/message/fusion/mptctl.c
>
> Tested on: Linux 6.12.38+kali-amd64, mptctl driver version 3.04.20
> Hardware:  LSI 53c1030 PCI-X Fusion-MPT (VirtualBox emulated)
>
>
> *DESCRIPTION*
> ===========
> Function kbuf_alloc_2_sgl() in mptctl.c allocates a buflist array of
> 74 bytes via kzalloc(MAX_SGL_BYTES / 8), then writes struct buflist
> entries (16 bytes each on 64-bit: u8 pointer + int + padding) into it
> without any bounds check on the index buflist_ent.
>
> This gives a maximum of 4 safe entries (74 / 16 = 4). Each entry
> corresponds to one 128KB DMA chunk (MAX_KMALLOC_SZ). When the
> MPTFWDOWNLOAD ioctl is called with fwlen greater than 524288 bytes
> (4 x 128KB), buflist_ent reaches 4 and subsequent iterations write
> past the end of the heap allocation.
>
> Relevant code (around line 1031):
>
>     i = MAX_SGL_BYTES / 8;           /* = 74 bytes */
>     buflist = kzalloc(i, GFP_USER);  /* max 4 entries on 64-bit */
>     ...
>     while (bytes_allocd < bytes) {
>         buflist[buflist_ent].len  = this_alloc;        /* NO BOUNDS CHECK */
>         buflist[buflist_ent].kptr = dma_alloc_coherent(...);
>         buflist_ent++;
>     }
>
>
>
> *REPRODUCER*==========
> Trigger condition:
> - Root privileges required
> - /dev/mptctl accessible (mknod /dev/mptctl c 10 220)
> - CONFIG_FUSION_CTL enabled
> - MPTFWDOWNLOAD ioctl with fwlen = 524289 (512KB + 1 byte)
>
> Minimal C reproducer (available on maintainer request per guidelines):
>
>     struct mpt_fw_xfer {
>         unsigned int iocnum;
>         unsigned int fwlen;
>         void *bufp;
>     };
>     #define MPTFWDOWNLOAD _IOWR('m', 15, struct mpt_fw_xfer)
>
>     char *buf = calloc(1, 524289);
>     struct mpt_fw_xfer req = { .iocnum=0, .fwlen=524289, .bufp=buf };
>     int fd = open("/dev/mptctl", O_RDWR);
>     ioctl(fd, MPTFWDOWNLOAD, &req);
>
>
>
> *OBSERVED BEHAVIOR (dmesg on live system)*
> =========================================
>     mptctl: ioc0: WARNING - -SG: No can do - Chain required!
>     mptctl: WARNING - (freeing 11 frags)
>
> 11 iterations confirm 7 out-of-bounds writes past the 74-byte
> buflist allocation. No kernel crash was observed, indicating silent
> heap corruption. Each OOB write places a DMA address (8 bytes) and
> buffer length (4 bytes) into adjacent kernel heap memory.
>
>
>
> *PROPOSED FIX*============
> Add a bounds check before each buflist[] access in kbuf_alloc_2_sgl():
>
> --- a/drivers/message/fusion/mptctl.c
> +++ b/drivers/message/fusion/mptctl.c
> @@ -1028,6 +1028,7 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int sge_offset,
>         int              sg_spill = MAX_FRAGS_SPILL1;
>         int              dir;
> +       int              max_buflist_ent = (MAX_SGL_BYTES / 8) /
> +                                          sizeof(struct buflist);
>
>         if (bytes < 0)
>                 return NULL;
> @@ -1063,6 +1063,10 @@ kbuf_alloc_2_sgl(int bytes, u32 sgdir, int
> sge_offset,
>         while (bytes_allocd < bytes) {
>                 this_alloc = min(alloc_sz, bytes-bytes_allocd);
> +               if (buflist_ent >= max_buflist_ent) {
> +                       printk(KERN_ERR "mptctl: buflist overflow\n");
> +                       goto free_and_fail;
> +               }
>                 buflist[buflist_ent].len = this_alloc;
>                 buflist[buflist_ent].kptr = dma_alloc_coherent(
>                         &ioc->pcidev->dev,

Could you please turn your fix into a patch that can directly be applied ?
This would save some maintainers' time and if accepted, you'd get full
credit for finding and fixing this bug. For guidance on how to write
patches, please see Documentation/process/submitting-patches.rst.

Also please note that your mailer turned tabs into spaces so you'll also
need to check Documentation/process/email-clients.rst for instructions
on how to fix it.

> *CONDITIONS*
> ==========
> - Root access to /dev/mptctl required

So this is just a regular bug, not a security issue.

> - LSI Fusion MPT hardware or compatible emulation
> - CONFIG_FUSION_CTL=y or =m
> - 64-bit kernel (32-bit has different struct buflist size,
>   threshold is higher but same bug exists)
>
>
> *IMPACT*
> ======
> Silent kernel heap corruption. The corrupted region receives DMA
> addresses and lengths from dma_alloc_coherent(). No crash observed
> on tested system, meaning corruption goes undetected and may affect
> adjacent heap objects depending on kernel heap layout.
>

Thanks,
Willy
