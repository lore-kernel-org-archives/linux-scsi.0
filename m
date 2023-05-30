Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95A49C7EE2C
	for <linux-scsi@archiver.kernel.org>; Tue, 30 May 2023 11:30:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231977AbjE3LaR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 May 2023 07:30:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231756AbjE3LaL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 May 2023 07:30:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C54FE5
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:29:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1685446166;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NpOBAS8Bi4kBG+sylQuaVNwQB72hawQBUTtbh7SjPqA=;
        b=B/sTW0SE7F6H36fs6qw9rv1x+lZq9zkDir32hC1uRG2yBv/N0OFHnQSbmprDZ8VPwMnmWc
        ThWsajj81IH3FMBovJIZk3e8G1BWFoqXGd4lEVpEtBIC8e/Xw+miirHc8cQwXz0lwpfc5Z
        dlUB3EWDh58aPD0oQBZpc638Rjtx+FI=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-336-hZH9sN3sPbuZhp7YvEaGaw-1; Tue, 30 May 2023 07:29:25 -0400
X-MC-Unique: hZH9sN3sPbuZhp7YvEaGaw-1
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-43fa9a00625so824219e0c.2
        for <linux-scsi@vger.kernel.org>; Tue, 30 May 2023 04:29:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685446164; x=1688038164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NpOBAS8Bi4kBG+sylQuaVNwQB72hawQBUTtbh7SjPqA=;
        b=PsyVpIUp9L+tGNzSKIlb/gHQkaWjS/dQtN+0afFg9Q75BFW5QbuymtPFDzPqckkzUx
         O2Z1WrvVOWWgm0EhUE1+1AaW5Z6kp+Y83TjcZhB+Wwcy7T08VnD4jtb/LAhX9ah4wXDR
         f2Cm+4rV1vNeMan50IifLbFPb842AJoEr/SSo97WGWWZL/YukNOXxyiYH3+9shuHkfXq
         FFHv9kP/oEODfM3GX/JADzivIWaeqW68t2rWIoszPXHHyrd/baL8pA8VeNQvFvXTAzHL
         7XD5olTd5ovlx4nV4m4bvSTPCoNyIamy/KyK6BHAEHFRwEbbdOeia4sSmJn4LrHkbUFp
         ZCyg==
X-Gm-Message-State: AC+VfDy+etKDxKYAbXTVMWrxdsXo0ie+Wbg/i2d5dwQ6xyX5oQQByPyx
        jEJwGPS0jvodxLNSP7qMfQjjGYH41afTqMepqKYBv8MJF3EgEF2CX1OV3YkmO0mKv656p5LcHv4
        vQCB2ZYZYDnKNUW4NtAJIiarGxCgBxor//dy3vQ==
X-Received: by 2002:a1f:4b45:0:b0:44f:cc32:1585 with SMTP id y66-20020a1f4b45000000b0044fcc321585mr396082vka.16.1685446164681;
        Tue, 30 May 2023 04:29:24 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ60g8d6uIJQJ6uxHej74jlrBVrcHx9EcH35VqVEe7Tezem4ctVekj51qYF9EFj7YKA4koNTixi+3DAOC1La86o=
X-Received: by 2002:a1f:4b45:0:b0:44f:cc32:1585 with SMTP id
 y66-20020a1f4b45000000b0044fcc321585mr396070vka.16.1685446164430; Tue, 30 May
 2023 04:29:24 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20230522104536epcas5p23dd8108dd267ec588e5c36e8f9eb9fe8@epcas5p2.samsung.com>
 <20230522104146.2856-1-nj.shetty@samsung.com> <20230522104146.2856-3-nj.shetty@samsung.com>
In-Reply-To: <20230522104146.2856-3-nj.shetty@samsung.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Tue, 30 May 2023 13:29:12 +0200
Message-ID: <CAFL455nMtKbDt1HeN6D2WPB2JjOYq2z1=RagmmuhmQ33eL2Bfw@mail.gmail.com>
Subject: Re: [PATCH v11 2/9] block: Add copy offload support infrastructure
To:     Nitesh Shetty <nj.shetty@samsung.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>, dm-devel@redhat.com,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        James Smart <james.smart@broadcom.com>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        James.Bottomley@hansenpartnership.com, bvanassche@acm.org,
        hare@suse.de, ming.lei@redhat.com, dlemoal@kernel.org,
        anuj20.g@samsung.com, joshi.k@samsung.com, nitheshshetty@gmail.com,
        gost.dev@samsung.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

po 22. 5. 2023 v 13:17 odes=C3=ADlatel Nitesh Shetty <nj.shetty@samsung.com=
> napsal:
>
> +static int __blkdev_copy_offload(struct block_device *bdev_in, loff_t po=
s_in,
> +               struct block_device *bdev_out, loff_t pos_out, size_t len=
,
> +               cio_iodone_t endio, void *private, gfp_t gfp_mask)
> +{
> +       struct cio *cio;
> +       struct copy_ctx *ctx;
> +       struct bio *read_bio, *write_bio;
> +       struct page *token;
> +       sector_t copy_len;
> +       sector_t rem, max_copy_len;
> +
> +       cio =3D kzalloc(sizeof(struct cio), GFP_KERNEL);
> +       if (!cio)
> +               return -ENOMEM;
> +       atomic_set(&cio->refcount, 0);
> +       cio->waiter =3D current;
> +       cio->endio =3D endio;
> +       cio->private =3D private;
> +
> +       max_copy_len =3D min(bdev_max_copy_sectors(bdev_in),
> +                       bdev_max_copy_sectors(bdev_out)) << SECTOR_SHIFT;
> +
> +       cio->pos_in =3D pos_in;
> +       cio->pos_out =3D pos_out;
> +       /* If there is a error, comp_len will be set to least successfull=
y
> +        * completed copied length
> +        */
> +       cio->comp_len =3D len;
> +       for (rem =3D len; rem > 0; rem -=3D copy_len) {
> +               copy_len =3D min(rem, max_copy_len);
> +
> +               token =3D alloc_page(gfp_mask);
> +               if (unlikely(!token))
> +                       goto err_token;

[...]

> +err_token:
> +       cio->comp_len =3D min_t(sector_t, cio->comp_len, (len - rem));
> +       if (!atomic_read(&cio->refcount))
> +               return -ENOMEM;
> +       /* Wait for submitted IOs to complete */
> +       return blkdev_copy_wait_completion(cio);
> +}

Suppose the first call to "token =3D alloc_page()" fails (and
cio->refcount =3D=3D 0), isn't "cio" going to be leaked here?

Maurizio

