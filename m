Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8D313D75C6
	for <linux-scsi@vger.kernel.org>; Mon,  9 Mar 2026 15:31:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773070304; cv=pass; b=Ssguaj24D8HdzXfcNw3hlyt2wFwMSxO2XgROENMaZr1UudIyoVBuN3RTqeUJJF/LmtNnHvt3J8oHA4eTpUkxBPCqbAGbNS/4GGiMrZV7pB29QnJWAdYNDB/645xjTqeDbded3W5bxXoP3vBH08JwpBymlICqerbZGckL1ly/rAI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773070304; c=relaxed/simple;
	bh=IAhun4C5RUHet00HwD7ul+JrFNPWw1T6eUv63nRkCNU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=G35e9Bi8LWjolQeElrqwDAftLhjXtoX/A5u64D/L6EtIecML//WOrPsHnfntFaGByFrYy5TN5GM2P/ek8IjMsvf6oaIDjXfG0WdsxtoX0jD7FC9guubuVKSMWeyNn+ARRKVJkv2JyQHPGZ+AirbC3FtbzNryDlfDtbMQstX/RbA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=PqFA5YcF; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="PqFA5YcF"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d74872c5b1so40654a34.2
        for <linux-scsi@vger.kernel.org>; Mon, 09 Mar 2026 08:31:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773070300; cv=none;
        d=google.com; s=arc-20240605;
        b=H4NTZ8E6Fw2PX9QHTztC3FG5yGRgNimjs89Ni53vOWnEN+02RRhuK5zaGBqZ6F5cGw
         wKqUWTE8ixE36EcqjERM/DrXzIp592o+eIXJ/IsNtg0KiKcZOSjGtUnIVO128bNRT4gq
         l+1WPcC0SYWh9/DpiJXqWlS4cXCyMLKPHjlt60N7K83GCOYN2AoiJShu6sI96lLI3j4X
         SWtQlF+z2EXO81lzzADMANipTVoEeBj0i9i5fnp8IGAzzWzI2Op/ll/xOMqzTSDSx5sf
         BxKjjZCEcywtPpE9WPd3tj76Fn9MpNkeDzz87RpDQtYE69opwlCJLiNnXZYHBY008h5u
         LGjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6+r9RgPpLrGiXVfQx056rbYEWCZcszUA9kQtErD1KEc=;
        fh=vbb6vCXrnlahpd7M6BzPsjSU3i4eoFWZuMe2U/yKrlQ=;
        b=SvNGQm0MpV7gj5bNcLbVggZ9+f+TEGrAbYDE69LphaDYeFuD+ll5Zf76+gdcex7ixy
         g6cMcUc78EFAtodyb39XIeZy4sF44QrPTh4LNMSsJRyGhdXUpukPfDhfYa1rTLfB2frB
         kAxYPi8GuMlTxtIsbYt704Zkl/XBMHrwDjyoUxzlFDttrJyy6PlF1p5YtydTXtd+kEjG
         Eet+C9YPHYVIaujG68Wm8iHJYZoYZkL08kUNvExpJXYjLcQPY0cspwvaNKwZnv4yWiC6
         mJVugz3bzVsiNG2MLBr3LXxTutEUMo0U5AXzjnPi550acb6YKNYICXK+1LIbU6r74bfs
         4VIg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1773070300; x=1773675100; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6+r9RgPpLrGiXVfQx056rbYEWCZcszUA9kQtErD1KEc=;
        b=PqFA5YcFnKVkNGYXYu/zjEoz5CoL7xNnxWEUUjsrVreoUECANOFMpdhSPDT3a/sgL6
         qy4/58lvq1tYnBuNh9ITTY2gZvwtG2GdAxBMWhLm6iPQajc/axdnYPY1PcJm+Jt3FwO4
         UPq4HCUtTEzvK7AqgW6OwPbRxh3tv+3cuMz/C7Kanzv6RuohWEsGsDNOWxlpepfQvlE5
         QXJR8AEnBG0uMYoEJ2pW1gslnIr/yEdowxKkuLPPg2dyaxvZf4z3mfMIj/jvhDGovvcE
         +Y7CGBU5jKvdrIdHlNIPReTkr6E04odkkJ3lbz+zZ1tJCE9IUQ2S3kYtIyoztQ10N3I7
         9iLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773070300; x=1773675100;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6+r9RgPpLrGiXVfQx056rbYEWCZcszUA9kQtErD1KEc=;
        b=PNbS46SaJaao3EFmF86voau/bhPLbIph0pAy+5G8T3d2e03YPcuPEoxoFsXzNyq4CO
         skiLU/boHtHczayG61/s1uneIsan80AAu0br1OMdhjMX+PMRA5gBLw8wo4mBAuldel5B
         4Eabw/OEXCtHvVVH+OMduo8YgT7G7Q/BPWSch5QEBdZac2jXhtKi4iHGykFAore4GAz3
         Pi9vmLOfPapKLeEpM4vehskFamsI+Ky9enazrdvEE1gxhpxD9UkTeLWL3HXOmukv80w9
         S/QMAN6weqDF8qvWJoIWvXPFghuRJ0At3RHPekVrVmtOFgTKtkGt5f5fo8hYwsatm9rI
         4O2g==
X-Forwarded-Encrypted: i=1; AJvYcCWTx5PzhcdbqkPz7EotrrY1XWguFzKnVwBe5chQ2bOxSjSN6urnxXJ32N8ITecaVO9tUBzYgLfrInjM@vger.kernel.org
X-Gm-Message-State: AOJu0YzaaOm9qWCTBDq0D6g4TMdjeWdWbpnoNSW/q6f8TAWXu1oCCFSd
	JRETVC4gEIaogjJ2Qdxwwm1zdS2ZKstV7mqS/8Gbgu25WxHvRM97zTJHy8qqFrU9iF9Et6+RnsW
	tpJyhLK0uCyZtmLnYyZTywlRT7qH409ewFBeOXPtLyg==
X-Gm-Gg: ATEYQzxECH1HHTIr06u9r/Ll8Lak7tT5pPcgcBudFWXNoWj+hu95IVQNaYpV6yi5vVV
	0F6rl6/TQKuEJg9YGVr6KuOb5b2Rg4UF9Zbf7I9J4Zq6LkzNDlHsHoPsw0uvVv6Ze1pXB9afeL9
	0rcZelg1qPgZLSdUvDIrGrWSYD+u3jGbO8pxFmqj68/BgHGio7YQY42+Ju9GIaTz/71ytGkaswk
	8Y9f4GyGU08jR4lBsWw3XovTJK307aKjaUE2PDfeEqYjOKTUvRQzJZsiU1nj2FO8FFuzbDLwVWF
	smB/YxI=
X-Received: by 2002:a05:6830:3495:b0:7d7:40e7:9536 with SMTP id
 46e09a7af769-7d740e79670mr3723400a34.0.1773070299522; Mon, 09 Mar 2026
 08:31:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260309062840.2937858-2-iam@sung-woo.kim>
In-Reply-To: <20260309062840.2937858-2-iam@sung-woo.kim>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Mon, 9 Mar 2026 08:31:27 -0700
X-Gm-Features: AaiRm50lVynE24y1iGtUrsPblHqAJTvTl9abhpAYnSu85cy3kb3SYItst0KXwYA
Message-ID: <CADUfDZorSQCVtQyfjBuaziwG2Jo28yZiiqLKbp9PkFFw-9VgfQ@mail.gmail.com>
Subject: Re: [PATCH] blk-mq: nvme: Fix general protection fault in nvme_setup_descriptor_pools()
To: Sungwoo Kim <iam@sung-woo.kim>
Cc: Jens Axboe <axboe@kernel.dk>, Josef Bacik <josef@toxicpanda.com>, 
	Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, dm-devel@lists.linux.dev, 
	Ulf Hansson <ulf.hansson@linaro.org>, Richard Weinberger <richard@nod.at>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Hector Martin <marcan@marcan.st>, Sven Peter <sven@svenpeter.dev>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Chao Shi <cshi008@fiu.edu>, 
	Weidong Zhu <weizhu@fiu.edu>, Dave Tian <daveti@purdue.edu>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, nbd@other.debian.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Mar 8, 2026 at 11:30=E2=80=AFPM Sungwoo Kim <iam@sung-woo.kim> wrot=
e:
>
> The numa_node can be < 0 since NUMA_NO_NODE =3D -1. However,
> struct blk_mq_hw_ctx{} defines numa_node as unsigned int. As a result,
> numa_node is set to UINT_MAX for NUMA_NO_NODE in blk_mq_alloc_hctx().

The node argument to blk_mq_alloc_hctx() comes from
blk_mq_alloc_and_init_hctx(), which is called by
blk_mq_alloc_and_init_hctx() with int node =3D blk_mq_get_hctx_node(set,
i). node =3D NUMA_NO_NODE would suggest that blk_mq_hw_queue_to_node()
doesn't find any CPU affinitized to the queue. Is that even possible?

>
> Later, nvme_setup_descriptor_pools() accesses
> descriptor_pools[numa_node]. Due to the above, it tries to access
> descriptor_pools[UINT_MAX]. The address is garbage but accessible
> because it is canonical and still within the slab memory range.
> Therefore, no page fault occurs, and KASAN cannot detect this since it
> is beyond the redzones.
>
> Subsequently, normal I/O calls dma_pool_alloc() with the garbage pool
> address. pool->next_block contains a wild pointer, causing a general
> protection fault (GPF).
>
> To fix this, this patch changes the type of numa_node to int and adds
> a check for NUMA_NO_NODE.
>
> Log:
>
> Oops: general protection fault, probably for non-canonical address 0xe980=
3b040854d02c: 0000 [#1] SMP KASAN PTI
> KASAN: maybe wild-memory-access in range [0x4c01f82042a68160-0x4c01f82042=
a68167][FEMU] Err: I/O cmd failed: opcode=3D0x2 status=3D0x4002
> CPU: 0 UID: 0 PID: 112363 Comm: systemd-udevd Not tainted 6.19.0-dirty #1=
0 PREEMPT(voluntary)
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-=
ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
> RIP: 0010:pool_block_pop mm/dmapool.c:187 [inline]
> RIP: 0010:dma_pool_alloc+0x110/0x990 mm/dmapool.c:417
> Code: 00 0f 85 a4 07 00 00 4c 8b 63 58 4d 85 e4 0f 84 12 01 00 00 e8 41 1=
d 93 ff 4c 89 e2 48 b8 00 00 00 00 00 fc ff df 48 c1 ea 03 <80> 3c 02 00 0f=
 85 a7 07 00 00 49 8b 04 24 48 8d 7b 68 48 89 fa 48
> RSP: 0018:ffffc90002b9efd0 EFLAGS: 00010003
> RAX: dffffc0000000000 RBX: ffff888005466800 RCX: ffffffff94faab7f
> RDX: 09803f040854d02c RSI: 6c9b26c9b26c9b27 RDI: ffff88800c725ea0
> RBP: ffffc90002b9f060 R08: 0000000000000001 R09: 0000000000000001
> R10: 0000000000000003 R11: 0000000000000000 R12: 4c01f82042a68164
> R13: ffff888005466800 R14: 0000000000000820 R15: ffff888007b29000
> FS:  00007f2abc4ff8c0(0000) GS:ffff8880d1ff7000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056360eb89000 CR3: 000000000a480000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nvme_pci_setup_data_prp drivers/nvme/host/pci.c:906 [inline]
>  nvme_map_data drivers/nvme/host/pci.c:1114 [inline]
>  nvme_prep_rq.part.0+0x17d3/0x3c90 drivers/nvme/host/pci.c:1243
>  nvme_prep_rq drivers/nvme/host/pci.c:1239 [inline]
>  nvme_prep_rq_batch drivers/nvme/host/pci.c:1321 [inline]
>  nvme_queue_rqs+0x37b/0x8a0 drivers/nvme/host/pci.c:1336
>  __blk_mq_flush_list block/blk-mq.c:2848 [inline]
>  __blk_mq_flush_list+0xaa/0xe0 block/blk-mq.c:2844
>  blk_mq_dispatch_queue_requests+0x4f5/0x990 block/blk-mq.c:2893
>  blk_mq_flush_plug_list+0x232/0x650 block/blk-mq.c:2981
>  __blk_flush_plug+0x2c3/0x510 block/blk-core.c:1225
>  blk_finish_plug block/blk-core.c:1252 [inline]
>  blk_finish_plug+0x64/0xc0 block/blk-core.c:1249
>  read_pages+0x6bd/0x9d0 mm/readahead.c:176
>  page_cache_ra_unbounded+0x659/0x950 mm/readahead.c:269
>  do_page_cache_ra mm/readahead.c:332 [inline]
>  force_page_cache_ra+0x282/0x3a0 mm/readahead.c:361
>  page_cache_sync_ra+0x201/0xbf0 mm/readahead.c:579
>  filemap_get_pages+0x3be/0x1990 mm/filemap.c:2690
>  filemap_read+0x3ea/0xdf0 mm/filemap.c:2800
>  blkdev_read_iter+0x1b8/0x520 block/fops.c:856
>  new_sync_read fs/read_write.c:491 [inline]
>  vfs_read+0x90f/0xd80 fs/read_write.c:572
>  ksys_read+0x14e/0x280 fs/read_write.c:715
>  __do_sys_read fs/read_write.c:724 [inline]
>  __se_sys_read fs/read_write.c:722 [inline]
>  __x64_sys_read+0x7b/0xc0 fs/read_write.c:722
>  x64_sys_call+0x17ec/0x21b0 arch/x86/include/generated/asm/syscalls_64.h:=
1
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x8b/0x1200 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x76/0x7e
> RIP: 0033:0x7f2abc7b204e
> Code: 0f 1f 40 00 48 8b 15 79 af 00 00 f7 d8 64 89 02 48 c7 c0 ff ff ff f=
f eb ba 0f 1f 00 64 8b 04 25 18 00 00 00 85 c0 75 14 0f 05 <48> 3d 00 f0 ff=
 ff 77 5a c3 66 0f 1f 84 00 00 00 00 00 48 83 ec 28
> RSP: 002b:00007fff07113cb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 000056360eb6a528 RCX: 00007f2abc7b204e
> RDX: 0000000000040000 RSI: 000056360eb6a538 RDI: 000000000000000f
> RBP: 000056360e8d23d0 R08: 000056360eb6a510 R09: 00007f2abc79abe0
> R10: 0000000000040050 R11: 0000000000000246 R12: 000000003ff80000
> R13: 0000000000040000 R14: 000056360eb6a510 R15: 000056360e8d2420
>  </TASK>
> Modules linked in:
>
> Fixes: 320ae51feed5 ("blk-mq: new multi-queue block IO queueing mechanism=
")
> Fixes: d977506f8863 ("nvme-pci: make PRP list DMA pools per-NUMA-node")
> Acked-by: Chao Shi <cshi008@fiu.edu>
> Acked-by: Weidong Zhu <weizhu@fiu.edu>
> Acked-by: Dave Tian <daveti@purdue.edu>
> Signed-off-by: Sungwoo Kim <iam@sung-woo.kim>
> ---
>  block/bsg-lib.c                   |  2 +-
>  drivers/block/mtip32xx/mtip32xx.c |  2 +-
>  drivers/block/nbd.c               |  2 +-
>  drivers/md/dm-rq.c                |  2 +-
>  drivers/mmc/core/queue.c          |  2 +-
>  drivers/mtd/ubi/block.c           |  2 +-
>  drivers/nvme/host/apple.c         |  2 +-
>  drivers/nvme/host/fc.c            |  2 +-
>  drivers/nvme/host/pci.c           | 11 ++++++++---
>  drivers/nvme/host/rdma.c          |  2 +-
>  drivers/nvme/host/tcp.c           |  2 +-
>  drivers/nvme/target/loop.c        |  2 +-
>  drivers/scsi/scsi_lib.c           |  2 +-
>  include/linux/blk-mq.h            |  4 ++--
>  14 files changed, 22 insertions(+), 17 deletions(-)
>
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 9ceb5d0832f5..e93b1018a346 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -299,7 +299,7 @@ static blk_status_t bsg_queue_rq(struct blk_mq_hw_ctx=
 *hctx,
>
>  /* called right after the request is allocated for the request_queue */
>  static int bsg_init_rq(struct blk_mq_tag_set *set, struct request *req,
> -                      unsigned int hctx_idx, unsigned int numa_node)
> +                      unsigned int hctx_idx, int numa_node)
>  {
>         struct bsg_job *job =3D blk_mq_rq_to_pdu(req);
>
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/m=
tip32xx.c
> index 567192e371a8..8aedba9b5690 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -3340,7 +3340,7 @@ static void mtip_free_cmd(struct blk_mq_tag_set *se=
t, struct request *rq,
>  }
>
>  static int mtip_init_cmd(struct blk_mq_tag_set *set, struct request *rq,
> -                        unsigned int hctx_idx, unsigned int numa_node)
> +                        unsigned int hctx_idx, int numa_node)
>  {
>         struct driver_data *dd =3D set->driver_data;
>         struct mtip_cmd *cmd =3D blk_mq_rq_to_pdu(rq);
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index f6c33b21f69e..e1fac1c0c4cd 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -1888,7 +1888,7 @@ static void nbd_dbg_close(void)
>  #endif
>
>  static int nbd_init_request(struct blk_mq_tag_set *set, struct request *=
rq,
> -                           unsigned int hctx_idx, unsigned int numa_node=
)
> +                           unsigned int hctx_idx, int numa_node)
>  {
>         struct nbd_cmd *cmd =3D blk_mq_rq_to_pdu(rq);
>         cmd->nbd =3D set->driver_data;
> diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
> index a6ca92049c10..b687a209256b 100644
> --- a/drivers/md/dm-rq.c
> +++ b/drivers/md/dm-rq.c
> @@ -455,7 +455,7 @@ static void dm_start_request(struct mapped_device *md=
, struct request *orig)
>  }
>
>  static int dm_mq_init_request(struct blk_mq_tag_set *set, struct request=
 *rq,
> -                             unsigned int hctx_idx, unsigned int numa_no=
de)
> +                             unsigned int hctx_idx, int numa_node)
>  {
>         struct mapped_device *md =3D set->driver_data;
>         struct dm_rq_target_io *tio =3D blk_mq_rq_to_pdu(rq);
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index 284856c8f655..06cb29190a88 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -203,7 +203,7 @@ static unsigned short mmc_get_max_segments(struct mmc=
_host *host)
>  }
>
>  static int mmc_mq_init_request(struct blk_mq_tag_set *set, struct reques=
t *req,
> -                              unsigned int hctx_idx, unsigned int numa_n=
ode)
> +                              unsigned int hctx_idx, int numa_node)
>  {
>         struct mmc_queue_req *mq_rq =3D req_to_mmc_queue_req(req);
>         struct mmc_queue *mq =3D set->driver_data;
> diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
> index b53fd147fa65..1c0bd2b36637 100644
> --- a/drivers/mtd/ubi/block.c
> +++ b/drivers/mtd/ubi/block.c
> @@ -312,7 +312,7 @@ static blk_status_t ubiblock_queue_rq(struct blk_mq_h=
w_ctx *hctx,
>
>  static int ubiblock_init_request(struct blk_mq_tag_set *set,
>                 struct request *req, unsigned int hctx_idx,
> -               unsigned int numa_node)
> +               int numa_node)
>  {
>         struct ubiblock_pdu *pdu =3D blk_mq_rq_to_pdu(req);
>
> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> index ed61b97fde59..50ff5e9a168d 100644
> --- a/drivers/nvme/host/apple.c
> +++ b/drivers/nvme/host/apple.c
> @@ -819,7 +819,7 @@ static int apple_nvme_init_hctx(struct blk_mq_hw_ctx =
*hctx, void *data,
>
>  static int apple_nvme_init_request(struct blk_mq_tag_set *set,
>                                    struct request *req, unsigned int hctx=
_idx,
> -                                  unsigned int numa_node)
> +                                  int numa_node)
>  {
>         struct apple_nvme_queue *q =3D set->driver_data;
>         struct apple_nvme *anv =3D queue_to_apple_nvme(q);
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index 6948de3f438a..64d0c5d7613a 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -2109,7 +2109,7 @@ __nvme_fc_init_request(struct nvme_fc_ctrl *ctrl,
>
>  static int
>  nvme_fc_init_request(struct blk_mq_tag_set *set, struct request *rq,
> -               unsigned int hctx_idx, unsigned int numa_node)
> +               unsigned int hctx_idx, int numa_node)
>  {
>         struct nvme_fc_ctrl *ctrl =3D to_fc_ctrl(set->driver_data);
>         struct nvme_fcp_op_w_sgl *op =3D blk_mq_rq_to_pdu(rq);
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 3c83076a57e5..a5f12fc7655d 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -443,11 +443,16 @@ static bool nvme_dbbuf_update_and_check_event(u16 v=
alue, __le32 *dbbuf_db,
>  }
>
>  static struct nvme_descriptor_pools *
> -nvme_setup_descriptor_pools(struct nvme_dev *dev, unsigned numa_node)
> +nvme_setup_descriptor_pools(struct nvme_dev *dev, int numa_node)
>  {
> -       struct nvme_descriptor_pools *pools =3D &dev->descriptor_pools[nu=
ma_node];
> +       struct nvme_descriptor_pools *pools;
>         size_t small_align =3D NVME_SMALL_POOL_SIZE;
>
> +       if (numa_node =3D=3D NUMA_NO_NODE)
> +               pools =3D &dev->descriptor_pools[numa_node_id()];
> +       else
> +               pools =3D &dev->descriptor_pools[numa_node];

Simpler: if (numa_node =3D=3D NUMA_NO_NODE) numa_node =3D numa_node_id();

> +
>         if (pools->small)
>                 return pools; /* already initialized */
>
> @@ -516,7 +521,7 @@ static int nvme_init_hctx(struct blk_mq_hw_ctx *hctx,=
 void *data,
>
>  static int nvme_pci_init_request(struct blk_mq_tag_set *set,
>                 struct request *req, unsigned int hctx_idx,
> -               unsigned int numa_node)
> +               int numa_node)
>  {
>         struct nvme_iod *iod =3D blk_mq_rq_to_pdu(req);
>
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 35c0822edb2d..c2514ef94028 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -292,7 +292,7 @@ static void nvme_rdma_exit_request(struct blk_mq_tag_=
set *set,
>
>  static int nvme_rdma_init_request(struct blk_mq_tag_set *set,
>                 struct request *rq, unsigned int hctx_idx,
> -               unsigned int numa_node)
> +               int numa_node)
>  {
>         struct nvme_rdma_ctrl *ctrl =3D to_rdma_ctrl(set->driver_data);
>         struct nvme_rdma_request *req =3D blk_mq_rq_to_pdu(rq);
> diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
> index 69cb04406b47..385eef98081b 100644
> --- a/drivers/nvme/host/tcp.c
> +++ b/drivers/nvme/host/tcp.c
> @@ -547,7 +547,7 @@ static void nvme_tcp_exit_request(struct blk_mq_tag_s=
et *set,
>
>  static int nvme_tcp_init_request(struct blk_mq_tag_set *set,
>                 struct request *rq, unsigned int hctx_idx,
> -               unsigned int numa_node)
> +               int numa_node)
>  {
>         struct nvme_tcp_ctrl *ctrl =3D to_tcp_ctrl(set->driver_data);
>         struct nvme_tcp_request *req =3D blk_mq_rq_to_pdu(rq);
> diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
> index fc8e7c9ad858..72a8ea70eae7 100644
> --- a/drivers/nvme/target/loop.c
> +++ b/drivers/nvme/target/loop.c
> @@ -202,7 +202,7 @@ static int nvme_loop_init_iod(struct nvme_loop_ctrl *=
ctrl,
>
>  static int nvme_loop_init_request(struct blk_mq_tag_set *set,
>                 struct request *req, unsigned int hctx_idx,
> -               unsigned int numa_node)
> +               int numa_node)
>  {
>         struct nvme_loop_ctrl *ctrl =3D to_loop_ctrl(set->driver_data);
>         struct nvme_loop_iod *iod =3D blk_mq_rq_to_pdu(req);
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 4a902c9dfd8b..8958ad31ed2a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1948,7 +1948,7 @@ static blk_status_t scsi_queue_rq(struct blk_mq_hw_=
ctx *hctx,
>  }
>
>  static int scsi_mq_init_request(struct blk_mq_tag_set *set, struct reque=
st *rq,
> -                               unsigned int hctx_idx, unsigned int numa_=
node)
> +                               unsigned int hctx_idx, int numa_node)
>  {
>         struct Scsi_Host *shost =3D set->driver_data;
>         struct scsi_cmnd *cmd =3D blk_mq_rq_to_pdu(rq);
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index cae9e857aea4..1a5a3786522c 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -426,7 +426,7 @@ struct blk_mq_hw_ctx {
>         struct blk_mq_tags      *sched_tags;
>
>         /** @numa_node: NUMA node the storage adapter has been connected =
to. */
> -       unsigned int            numa_node;
> +       int             numa_node;
>         /** @queue_num: Index of this hardware queue. */
>         unsigned int            queue_num;
>
> @@ -651,7 +651,7 @@ struct blk_mq_ops {
>          * flush request.
>          */
>         int (*init_request)(struct blk_mq_tag_set *set, struct request *,
> -                           unsigned int, unsigned int);
> +                           unsigned int, int);

Pre-existing, but naming these integer arguments would be helpful for
documentation.

Best,
Caleb

>         /**
>          * @exit_request: Ditto for exit/teardown.
>          */
> --
> 2.47.3
>
>
