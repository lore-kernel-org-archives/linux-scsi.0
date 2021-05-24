Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26B10C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 09:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0329B6108E
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 09:23:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232397AbhEXJYv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 05:24:51 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:59074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232313AbhEXJYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 05:24:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621848199;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ne4HeOCGj7q8c4BgvagMZxPePSQO88cIXvFas9Gk97w=;
        b=PIL4UnPm/viX3l74DwLu77oqriPr6yxBdknbIx4Emp5QJmDQRQly/1fFhzhdRSiCLZ1Qx7
        1BWTeQ0mWla4QLz0fGitkApz52yJf68pV8FMds+oXWzvAssvK49rewMTxj1NIpD3PYZvmb
        sQLMAvA8RTAuX+KftWZ7wxp9yFJjYFU=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-580-E3hz_bw7PEqGIhPUFiEPJA-1; Mon, 24 May 2021 05:23:18 -0400
X-MC-Unique: E3hz_bw7PEqGIhPUFiEPJA-1
Received: by mail-wr1-f70.google.com with SMTP id c13-20020a5d6ccd0000b029010ec741b84bso12784693wrc.23
        for <linux-scsi@vger.kernel.org>; Mon, 24 May 2021 02:23:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ne4HeOCGj7q8c4BgvagMZxPePSQO88cIXvFas9Gk97w=;
        b=UMt2yL9M0OyHuz21t0gnH8waHIUwQx+t/Mqae96YrLoFuIRCBEomSEFdCNX+YP2naV
         jGP3KGlp2QXnA1gJ1wzvzHHpp1vpVv+er9GKvWzeQxhqnI7B9l8UZbsdw+zctVBsHiIv
         1ab98/49lEwxEV/rncymLrLsw4MBQHsQKy2h5nYVwx51rYsZT7ZRcy4vfIF+M7iymJKG
         Z7BLs0/el5B5psUYQmb9SX7vJbTv4KrfiSIRzadRFwqk5VB+3WhzdrW5u1UaaIvjsSsR
         Ho72pPoxx90lV3++vC0wznSbKZIACiTIKOD6TP7VR1dBIhwgRkRJDnlbuLN0C+ZPMM8v
         KNAw==
X-Gm-Message-State: AOAM532xh1V/wI9iycp/1acSyrhq2kGoiP9d5/naADazuJWn7bFcTYOb
        gA5e+ceMmCG8T9MfTVcofLcN6bgnHNQwH1pncRsPBBiKFrMlPvdfbTuUcOnmupbqxTDB4qsdWhY
        XV5he9Im7zZAIBgqufvLJhA==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr21744501wri.41.1621848197160;
        Mon, 24 May 2021 02:23:17 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzXkzC5UeXauCxR+Lq2KM020A5wyfMd5vwbgFN3j9I9zuro0RWyF0jWCQ5UFODd9juP+fN5pg==
X-Received: by 2002:a05:6000:186a:: with SMTP id d10mr21744492wri.41.1621848197042;
        Mon, 24 May 2021 02:23:17 -0700 (PDT)
Received: from redhat.com ([2a10:8006:fcda:0:90d:c7e7:9e26:b297])
        by smtp.gmail.com with ESMTPSA id q3sm11331101wrr.43.2021.05.24.02.23.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 May 2021 02:23:16 -0700 (PDT)
Date:   Mon, 24 May 2021 05:23:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v3 47/51] virtio_scsi: Use scsi_cmd_to_rq() instead of
 scsi_cmnd.request
Message-ID: <20210524052301-mutt-send-email-mst@kernel.org>
References: <20210524030856.2824-1-bvanassche@acm.org>
 <20210524030856.2824-48-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524030856.2824-48-bvanassche@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 23, 2021 at 08:08:52PM -0700, Bart Van Assche wrote:
> Prepare for removal of the request pointer by using scsi_cmd_to_rq()
> instead. This patch does not change any functionality.
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

If everyone else does it, I don't mind
Acked-by: Michael S. Tsirkin <mst@redhat.com>

> ---
>  drivers/scsi/virtio_scsi.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b9c86a7e3b97..8ae4b8441519 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -521,7 +521,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
>  				    struct virtio_scsi_cmd_req_pi *cmd_pi,
>  				    struct scsi_cmnd *sc)
>  {
> -	struct request *rq = sc->request;
> +	struct request *rq = scsi_cmd_to_rq(sc);
>  	struct blk_integrity *bi;
>  
>  	virtio_scsi_init_hdr(vdev, (struct virtio_scsi_cmd_req *)cmd_pi, sc);
> @@ -545,7 +545,7 @@ static void virtio_scsi_init_hdr_pi(struct virtio_device *vdev,
>  static struct virtio_scsi_vq *virtscsi_pick_vq_mq(struct virtio_scsi *vscsi,
>  						  struct scsi_cmnd *sc)
>  {
> -	u32 tag = blk_mq_unique_tag(sc->request);
> +	u32 tag = blk_mq_unique_tag(scsi_cmd_to_rq(sc));
>  	u16 hwq = blk_mq_unique_tag_to_hwq(tag);
>  
>  	return &vscsi->req_vqs[hwq];

