Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D11226659E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 12:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741868244; cv=none; b=BqJvOxNK6AhzFwnOyR7b+h1XAKxbSG6JxwE8XWxiRAJVWjkQL2tZbsu7oOotx2kgcl38B+ogqZjUPqWHiq3q0oImvqVW3dRRQP3caaM+bB39hwO4yOVxdz3+JQLITg9q21uQRTOrr5hZGYTK23x/qDBJC7gjmgEjXfMBV1CQ6oA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741868244; c=relaxed/simple;
	bh=0BOVQPkQNJ/oB3aMimokHLKS8Q4S6n+GKmzwxtrc5nM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JW6+qZcR3i2BwMq+7C5waTisiaD1Wh414ZbDSnImTuM+1+xw61zt4GrWw7TStuUwMddDKHVH6doRJkubXlLYauGujggtx5ii9KODyD3u7h8cLKXTKNKJ8H0RNOnYtdOnC5B0baeNMUVDCuUFAkPLnrlr3FwSzAdxmNfTHSkU+c0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b=POtM75mT; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=ionos.com header.i=@ionos.com header.b="POtM75mT"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-5e4d18a2c51so159794a12.0
        for <linux-scsi@vger.kernel.org>; Thu, 13 Mar 2025 05:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1741868237; x=1742473037; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T3KUfUTE42sadcrEtnViL50Ze8Ig+BwN074prKXepkA=;
        b=POtM75mTgDQu6JwvqGsp225NpGWb+xgTfPtW/hP99kygrPdU8tnBSaseJ8Z5VJiFa6
         oZKuIz1XoM42bhSojZNYKQSQ5oDDF38AbRaoDpQJ5MNB8NqV7l6GEdi1Q85Mhm33eYMy
         BFHlHbufeH1GraZ77vIGY/0TIQTVCtGZLoWLAMi8IFlAE/VAnvvmdq6NaOXnvC0iIOPw
         Xb5JktUNL0zmW0em+vvG25VL/9IcZCU2t1TWgnfYEYG8CV0gvkAWrPE6Ekle14g047v5
         rNztdarVdFb0czFAtX963thwGKSkHWisYokzGqTuFgCmzuble6tbQ4CdY3qfyxbPInN8
         ZBoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741868237; x=1742473037;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T3KUfUTE42sadcrEtnViL50Ze8Ig+BwN074prKXepkA=;
        b=c9OasrbmmYv4CiMBaWbwHquEBecLF2JKmXEhBKCTdTSjeESPgtlzX0WPY8kCSsH67N
         JKeLwJ+tobfc7b/wNw4IN48MqG5PWg0rxFfa8hV4/NjDvYzDtiWJD0WKO2EQziMWgjz3
         c36+9j6JKYQZWFNRrQsStTARGC8kk0BwSt0dQ5Iab3hKrOi2OKpcGxcPRjSpNW/My8A6
         +sLcTV1yo4YI+flG8Y6ekYHEzkkVgmOXgG8nKA7/ahk85LV/oYLJN2eYlUaPH6Q2tGYi
         tE8L1i+QQJ+VuFcSEwdX76ma4YPaLrPCw04eOWwjrtSTMlrcS5T6STxE9aGLPSXOnK1n
         4FLQ==
X-Forwarded-Encrypted: i=1; AJvYcCW+Kt+eMo1vNcShHwyYKwnIjLFI82KEPBSAYClGettf4//jhzhtixsx7GXarmLrWLahZxTbBHkMpogk@vger.kernel.org
X-Gm-Message-State: AOJu0YyUaiLT8iuB6WWiPCisFxYo8liYPVjCn+HDUCZ7EqZ9Q5GExemD
	qLPZHgbjlRhovx8QJ1ei8aQczJezmxIT96guOwRxmetvtI9zbUwtN6tIBnOy2rNcfXwya3f3p3I
	i7eAZeS3v8uY5uxVD6sVow0eRldZv436ryaRdQA==
X-Gm-Gg: ASbGncuKn+c1rcArMHfB+jT/eAWQe5d9l+ZJLKk8itIIBcHigBSnAGEgJokvIMNT2xb
	wxylc+ANQ0bDJDy4mgYISzWMP+XICYLB1CaEX53IToHfA79YKaFG3j82fv05D0vkFtWeKh8F3mz
	8/xlfyNeLY1bZ7Vk625W+lbHDth9++6T5xEjYd2+Qk9i2ElhjhXG8lUlLvrIuypGaBmoggBA==
X-Google-Smtp-Source: AGHT+IFzK99kHSj5d/FDwifiVSaoCoqlhKVXWIJ6/aG6k3xd47S1yV8uOe7tE9DCf5TStXwjFqv+FuI28Gyvh18i5ws=
X-Received: by 2002:a05:6402:268f:b0:5e0:36fa:ac1c with SMTP id
 4fb4d7f45d1cf-5e75f983d16mr5279244a12.9.1741868236757; Thu, 13 Mar 2025
 05:17:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CGME20250313040150epcas5p347f94dac34fd2946dea51049559ee1de@epcas5p3.samsung.com>
 <20250313035322.243239-1-anuj20.g@samsung.com>
In-Reply-To: <20250313035322.243239-1-anuj20.g@samsung.com>
From: Jinpu Wang <jinpu.wang@ionos.com>
Date: Thu, 13 Mar 2025 13:17:05 +0100
X-Gm-Features: AQ5f1JrIJ_abLv2o7eKaSVbKIXVsbvKxK9F6-3hJ2TBEx-9sNptiPJkEypoOpyY
Message-ID: <CAMGffEkm5zkBM7QPbfd7+qiMA92VBfyoRUdb+3CMzqe3ZCs7rg@mail.gmail.com>
Subject: Re: [PATCH] block: remove unused parameter
To: Anuj Gupta <anuj20.g@samsung.com>
Cc: Jens Axboe <axboe@kernel.dk>, "Md. Haris Iqbal" <haris.iqbal@ionos.com>, 
	"Michael S. Tsirkin" <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Paolo Bonzini <pbonzini@redhat.com>, Stefan Hajnoczi <stefanha@redhat.com>, 
	=?UTF-8?Q?Roger_Pau_Monn=C3=A9?= <roger.pau@citrix.com>, 
	Juergen Gross <jgross@suse.com>, Stefano Stabellini <sstabellini@kernel.org>, 
	Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>, Maxim Levitsky <maximlevitsky@gmail.com>, 
	Alex Dubov <oakad@yahoo.com>, Ulf Hansson <ulf.hansson@linaro.org>, 
	Richard Weinberger <richard@nod.at>, Zhihao Cheng <chengzhihao1@huawei.com>, 
	Miquel Raynal <miquel.raynal@bootlin.com>, Vignesh Raghavendra <vigneshr@ti.com>, 
	Sven Peter <sven@svenpeter.dev>, Janne Grunau <j@jannau.net>, 
	Alyssa Rosenzweig <alyssa@rosenzweig.io>, Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>, 
	Sagi Grimberg <sagi@grimberg.me>, James Smart <james.smart@broadcom.com>, 
	Chaitanya Kulkarni <kch@nvidia.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev, 
	xen-devel@lists.xenproject.org, linux-mmc@vger.kernel.org, 
	linux-mtd@lists.infradead.org, asahi@lists.linux.dev, 
	linux-arm-kernel@lists.infradead.org, linux-nvme@lists.infradead.org, 
	linux-scsi@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 13, 2025 at 6:14=E2=80=AFAM Anuj Gupta <anuj20.g@samsung.com> w=
rote:
>
> request_queue param is not used by blk_rq_map_sg and __blk_rq_map_sg.
> remove it.
>
> Signed-off-by: Anuj Gupta <anuj20.g@samsung.com>
> ---
>  block/blk-merge.c                   | 4 ++--
>  block/bsg-lib.c                     | 2 +-
>  drivers/block/mtip32xx/mtip32xx.c   | 2 +-
>  drivers/block/rnbd/rnbd-clt.c       | 2 +-
lgtm.
Acked-by: Jack Wang <jinpu.wang@ionos.com> #rnbd
>  drivers/block/sunvdc.c              | 2 +-
>  drivers/block/virtio_blk.c          | 2 +-
>  drivers/block/xen-blkfront.c        | 2 +-
>  drivers/memstick/core/ms_block.c    | 2 +-
>  drivers/memstick/core/mspro_block.c | 4 +---
>  drivers/mmc/core/queue.c            | 2 +-
>  drivers/mtd/ubi/block.c             | 2 +-
>  drivers/nvme/host/apple.c           | 2 +-
>  drivers/nvme/host/fc.c              | 2 +-
>  drivers/nvme/host/pci.c             | 2 +-
>  drivers/nvme/host/rdma.c            | 3 +--
>  drivers/nvme/target/loop.c          | 2 +-
>  drivers/scsi/scsi_lib.c             | 2 +-
>  include/linux/blk-mq.h              | 9 ++++-----
>  18 files changed, 22 insertions(+), 26 deletions(-)
>
> diff --git a/block/blk-merge.c b/block/blk-merge.c
> index 1d1589c35297..fdd4efb54c6c 100644
> --- a/block/blk-merge.c
> +++ b/block/blk-merge.c
> @@ -551,8 +551,8 @@ static inline struct scatterlist *blk_next_sg(struct =
scatterlist **sg,
>   * Map a request to scatterlist, return number of sg entries setup. Call=
er
>   * must make sure sg can hold rq->nr_phys_segments entries.
>   */
> -int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
> -               struct scatterlist *sglist, struct scatterlist **last_sg)
> +int __blk_rq_map_sg(struct request *rq, struct scatterlist *sglist,
> +                   struct scatterlist **last_sg)
>  {
>         struct req_iterator iter =3D {
>                 .bio    =3D rq->bio,
> diff --git a/block/bsg-lib.c b/block/bsg-lib.c
> index 93523d8f8195..9ceb5d0832f5 100644
> --- a/block/bsg-lib.c
> +++ b/block/bsg-lib.c
> @@ -219,7 +219,7 @@ static int bsg_map_buffer(struct bsg_buffer *buf, str=
uct request *req)
>         if (!buf->sg_list)
>                 return -ENOMEM;
>         sg_init_table(buf->sg_list, req->nr_phys_segments);
> -       buf->sg_cnt =3D blk_rq_map_sg(req->q, req, buf->sg_list);
> +       buf->sg_cnt =3D blk_rq_map_sg(req, buf->sg_list);
>         buf->payload_len =3D blk_rq_bytes(req);
>         return 0;
>  }
> diff --git a/drivers/block/mtip32xx/mtip32xx.c b/drivers/block/mtip32xx/m=
tip32xx.c
> index 95361099a2dc..0d619df03fa9 100644
> --- a/drivers/block/mtip32xx/mtip32xx.c
> +++ b/drivers/block/mtip32xx/mtip32xx.c
> @@ -2056,7 +2056,7 @@ static void mtip_hw_submit_io(struct driver_data *d=
d, struct request *rq,
>         unsigned int nents;
>
>         /* Map the scatter list for DMA access */
> -       nents =3D blk_rq_map_sg(hctx->queue, rq, command->sg);
> +       nents =3D blk_rq_map_sg(rq, command->sg);
>         nents =3D dma_map_sg(&dd->pdev->dev, command->sg, nents, dma_dir)=
;
>
>         prefetch(&port->flags);
> diff --git a/drivers/block/rnbd/rnbd-clt.c b/drivers/block/rnbd/rnbd-clt.=
c
> index 82467ecde7ec..15627417f12e 100644
> --- a/drivers/block/rnbd/rnbd-clt.c
> +++ b/drivers/block/rnbd/rnbd-clt.c
> @@ -1010,7 +1010,7 @@ static int rnbd_client_xfer_request(struct rnbd_clt=
_dev *dev,
>          * See queue limits.
>          */
>         if ((req_op(rq) !=3D REQ_OP_DISCARD) && (req_op(rq) !=3D REQ_OP_W=
RITE_ZEROES))
> -               sg_cnt =3D blk_rq_map_sg(dev->queue, rq, iu->sgt.sgl);
> +               sg_cnt =3D blk_rq_map_sg(rq, iu->sgt.sgl);
>
>         if (sg_cnt =3D=3D 0)
>                 sg_mark_end(&iu->sgt.sgl[0]);
> diff --git a/drivers/block/sunvdc.c b/drivers/block/sunvdc.c
> index 282f81616a78..2b33fb5b949b 100644
> --- a/drivers/block/sunvdc.c
> +++ b/drivers/block/sunvdc.c
> @@ -485,7 +485,7 @@ static int __send_request(struct request *req)
>         }
>
>         sg_init_table(sg, port->ring_cookies);
> -       nsg =3D blk_rq_map_sg(req->q, req, sg);
> +       nsg =3D blk_rq_map_sg(req, sg);
>
>         len =3D 0;
>         for (i =3D 0; i < nsg; i++)
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index 6a61ec35f426..a3df4d49bd46 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -226,7 +226,7 @@ static int virtblk_map_data(struct blk_mq_hw_ctx *hct=
x, struct request *req,
>         if (unlikely(err))
>                 return -ENOMEM;
>
> -       return blk_rq_map_sg(hctx->queue, req, vbr->sg_table.sgl);
> +       return blk_rq_map_sg(req, vbr->sg_table.sgl);
>  }
>
>  static void virtblk_cleanup_cmd(struct request *req)
> diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
> index edcd08a9dcef..5babe575c288 100644
> --- a/drivers/block/xen-blkfront.c
> +++ b/drivers/block/xen-blkfront.c
> @@ -751,7 +751,7 @@ static int blkif_queue_rw_req(struct request *req, st=
ruct blkfront_ring_info *ri
>         id =3D blkif_ring_get_request(rinfo, req, &final_ring_req);
>         ring_req =3D &rinfo->shadow[id].req;
>
> -       num_sg =3D blk_rq_map_sg(req->q, req, rinfo->shadow[id].sg);
> +       num_sg =3D blk_rq_map_sg(req, rinfo->shadow[id].sg);
>         num_grant =3D 0;
>         /* Calculate the number of grant used */
>         for_each_sg(rinfo->shadow[id].sg, sg, num_sg, i)
> diff --git a/drivers/memstick/core/ms_block.c b/drivers/memstick/core/ms_=
block.c
> index 5b617c1f6789..f4398383ae06 100644
> --- a/drivers/memstick/core/ms_block.c
> +++ b/drivers/memstick/core/ms_block.c
> @@ -1904,7 +1904,7 @@ static void msb_io_work(struct work_struct *work)
>
>                 /* process the request */
>                 dbg_verbose("IO: processing new request");
> -               blk_rq_map_sg(msb->queue, req, sg);
> +               blk_rq_map_sg(req, sg);
>
>                 lba =3D blk_rq_pos(req);
>
> diff --git a/drivers/memstick/core/mspro_block.c b/drivers/memstick/core/=
mspro_block.c
> index 634d343b6bdb..c9853d887d28 100644
> --- a/drivers/memstick/core/mspro_block.c
> +++ b/drivers/memstick/core/mspro_block.c
> @@ -627,9 +627,7 @@ static int mspro_block_issue_req(struct memstick_dev =
*card)
>         while (true) {
>                 msb->current_page =3D 0;
>                 msb->current_seg =3D 0;
> -               msb->seg_count =3D blk_rq_map_sg(msb->block_req->q,
> -                                              msb->block_req,
> -                                              msb->req_sg);
> +               msb->seg_count =3D blk_rq_map_sg(msb->block_req, msb->req=
_sg);
>
>                 if (!msb->seg_count) {
>                         unsigned int bytes =3D blk_rq_cur_bytes(msb->bloc=
k_req);
> diff --git a/drivers/mmc/core/queue.c b/drivers/mmc/core/queue.c
> index ab662f502fe7..3ba62f825b84 100644
> --- a/drivers/mmc/core/queue.c
> +++ b/drivers/mmc/core/queue.c
> @@ -523,5 +523,5 @@ unsigned int mmc_queue_map_sg(struct mmc_queue *mq, s=
truct mmc_queue_req *mqrq)
>  {
>         struct request *req =3D mmc_queue_req_to_req(mqrq);
>
> -       return blk_rq_map_sg(mq->queue, req, mqrq->sg);
> +       return blk_rq_map_sg(req, mqrq->sg);
>  }
> diff --git a/drivers/mtd/ubi/block.c b/drivers/mtd/ubi/block.c
> index 2836905f0152..39cc0a6a4d37 100644
> --- a/drivers/mtd/ubi/block.c
> +++ b/drivers/mtd/ubi/block.c
> @@ -199,7 +199,7 @@ static blk_status_t ubiblock_read(struct request *req=
)
>          * and ubi_read_sg() will check that limit.
>          */
>         ubi_sgl_init(&pdu->usgl);
> -       blk_rq_map_sg(req->q, req, pdu->usgl.sg);
> +       blk_rq_map_sg(req, pdu->usgl.sg);
>
>         while (bytes_left) {
>                 /*
> diff --git a/drivers/nvme/host/apple.c b/drivers/nvme/host/apple.c
> index a060f69558e7..a437eee741e1 100644
> --- a/drivers/nvme/host/apple.c
> +++ b/drivers/nvme/host/apple.c
> @@ -525,7 +525,7 @@ static blk_status_t apple_nvme_map_data(struct apple_=
nvme *anv,
>         if (!iod->sg)
>                 return BLK_STS_RESOURCE;
>         sg_init_table(iod->sg, blk_rq_nr_phys_segments(req));
> -       iod->nents =3D blk_rq_map_sg(req->q, req, iod->sg);
> +       iod->nents =3D blk_rq_map_sg(req, iod->sg);
>         if (!iod->nents)
>                 goto out_free_sg;
>
> diff --git a/drivers/nvme/host/fc.c b/drivers/nvme/host/fc.c
> index b9929a5a7f4e..1b5ad1173bc7 100644
> --- a/drivers/nvme/host/fc.c
> +++ b/drivers/nvme/host/fc.c
> @@ -2571,7 +2571,7 @@ nvme_fc_map_data(struct nvme_fc_ctrl *ctrl, struct =
request *rq,
>         if (ret)
>                 return -ENOMEM;
>
> -       op->nents =3D blk_rq_map_sg(rq->q, rq, freq->sg_table.sgl);
> +       op->nents =3D blk_rq_map_sg(rq, freq->sg_table.sgl);
>         WARN_ON(op->nents > blk_rq_nr_phys_segments(rq));
>         freq->sg_cnt =3D fc_dma_map_sg(ctrl->lport->dev, freq->sg_table.s=
gl,
>                                 op->nents, rq_dma_dir(rq));
> diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
> index 950289405ef2..a0b1c57067aa 100644
> --- a/drivers/nvme/host/pci.c
> +++ b/drivers/nvme/host/pci.c
> @@ -812,7 +812,7 @@ static blk_status_t nvme_map_data(struct nvme_dev *de=
v, struct request *req,
>         if (!iod->sgt.sgl)
>                 return BLK_STS_RESOURCE;
>         sg_init_table(iod->sgt.sgl, blk_rq_nr_phys_segments(req));
> -       iod->sgt.orig_nents =3D blk_rq_map_sg(req->q, req, iod->sgt.sgl);
> +       iod->sgt.orig_nents =3D blk_rq_map_sg(req, iod->sgt.sgl);
>         if (!iod->sgt.orig_nents)
>                 goto out_free_sg;
>
> diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
> index 86a2891d9bcc..b5a0295b5bf4 100644
> --- a/drivers/nvme/host/rdma.c
> +++ b/drivers/nvme/host/rdma.c
> @@ -1476,8 +1476,7 @@ static int nvme_rdma_dma_map_req(struct ib_device *=
ibdev, struct request *rq,
>         if (ret)
>                 return -ENOMEM;
>
> -       req->data_sgl.nents =3D blk_rq_map_sg(rq->q, rq,
> -                                           req->data_sgl.sg_table.sgl);
> +       req->data_sgl.nents =3D blk_rq_map_sg(rq, req->data_sgl.sg_table.=
sgl);
>
>         *count =3D ib_dma_map_sg(ibdev, req->data_sgl.sg_table.sgl,
>                                req->data_sgl.nents, rq_dma_dir(rq));
> diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
> index a9d112d34d4f..a5c41144667c 100644
> --- a/drivers/nvme/target/loop.c
> +++ b/drivers/nvme/target/loop.c
> @@ -162,7 +162,7 @@ static blk_status_t nvme_loop_queue_rq(struct blk_mq_=
hw_ctx *hctx,
>                 }
>
>                 iod->req.sg =3D iod->sg_table.sgl;
> -               iod->req.sg_cnt =3D blk_rq_map_sg(req->q, req, iod->sg_ta=
ble.sgl);
> +               iod->req.sg_cnt =3D blk_rq_map_sg(req, iod->sg_table.sgl)=
;
>                 iod->req.transfer_len =3D blk_rq_payload_bytes(req);
>         }
>
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index f1cfe0bb89b2..0d29470e86b0 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1149,7 +1149,7 @@ blk_status_t scsi_alloc_sgtables(struct scsi_cmnd *=
cmd)
>          * Next, walk the list, and fill in the addresses and sizes of
>          * each segment.
>          */
> -       count =3D __blk_rq_map_sg(rq->q, rq, cmd->sdb.table.sgl, &last_sg=
);
> +       count =3D __blk_rq_map_sg(rq, cmd->sdb.table.sgl, &last_sg);
>
>         if (blk_rq_bytes(rq) & rq->q->limits.dma_pad_mask) {
>                 unsigned int pad_len =3D
> diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
> index fa2a76cc2f73..f2eff998913d 100644
> --- a/include/linux/blk-mq.h
> +++ b/include/linux/blk-mq.h
> @@ -1165,14 +1165,13 @@ static inline unsigned short blk_rq_nr_discard_se=
gments(struct request *rq)
>         return max_t(unsigned short, rq->nr_phys_segments, 1);
>  }
>
> -int __blk_rq_map_sg(struct request_queue *q, struct request *rq,
> -               struct scatterlist *sglist, struct scatterlist **last_sg)=
;
> -static inline int blk_rq_map_sg(struct request_queue *q, struct request =
*rq,
> -               struct scatterlist *sglist)
> +int __blk_rq_map_sg(struct request *rq, struct scatterlist *sglist,
> +               struct scatterlist **last_sg);
> +static inline int blk_rq_map_sg(struct request *rq, struct scatterlist *=
sglist)
>  {
>         struct scatterlist *last_sg =3D NULL;
>
> -       return __blk_rq_map_sg(q, rq, sglist, &last_sg);
> +       return __blk_rq_map_sg(rq, sglist, &last_sg);
>  }
>  void blk_dump_rq_flags(struct request *, char *);
>
> --
> 2.25.1
>
