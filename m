Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 303C1C11F68
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:55:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11D03613FE
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Jul 2021 15:55:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231931AbhGBP6V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 2 Jul 2021 11:58:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:38235 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229807AbhGBP6V (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Jul 2021 11:58:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1625241348;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=508AyhKpE8jUDrBFR0nb6Agup3ldPNqzk6KlIwcdo6g=;
        b=LpvTfE/Xx+XxBOBEfTmUYI/QfsjpiHQc0Gu+BHHdR3yz83mUE4ooCVhgda5bWfcA1zOBTW
        xytcClIOyvL59dXXPT824g80VpkdOa4Jesx3/C9QvjSknNLBabkhiZnNXeUNvEjRA+6v1r
        dj9+KQW/eQiIvFkwdJ6vEK9nSAZeJMc=
Received: from mail-wm1-f69.google.com (mail-wm1-f69.google.com
 [209.85.128.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-Dhu-4a5EMbGfLWJph67VfQ-1; Fri, 02 Jul 2021 11:55:47 -0400
X-MC-Unique: Dhu-4a5EMbGfLWJph67VfQ-1
Received: by mail-wm1-f69.google.com with SMTP id t82-20020a1cc3550000b02901ee1ed24f94so6393622wmf.9
        for <linux-scsi@vger.kernel.org>; Fri, 02 Jul 2021 08:55:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=508AyhKpE8jUDrBFR0nb6Agup3ldPNqzk6KlIwcdo6g=;
        b=trPZPxKeHz2WHZnHc/d2fnkaFL4wDazogUTTBgu6H9q6xhXDq4M8shF7Ttum2hy5ov
         SdMxaZnT3crLv0CBW7hR0nZu8V1AynXpKE2B3/HrWN2hdyExZxRJmy97+2k5Vp1Ga1j8
         wbje/vytNHu2BluanRio68mFXZDBrdcSsDhDQ6rWHSUsxKVR/Cv/u3hwATFIa/VLcDRW
         57SbRmnYOLIDr9Yu9dW8f2fHJYCKxmiKPwTVVwxXdw+ElSDYWBIrz0k8oTx0aqcu8Rud
         YahLMacItkMVtA/gv3QIYo3ri41wmi7vFlETZiMfeYYVrtIt+ez0Fh27RTaENC+clnpg
         LyNw==
X-Gm-Message-State: AOAM533ITzZi9NWpEG3Ti1SWbQumwXkjPK7yB/quHILZALuMMxM90uJ2
        NOr7ziZIVcmmOBDf8OoxK5Ti/pVO9VJgWS1+PG2gRXlEDGBVfbFfH3QaUEBORNpbl8we3xuc3gU
        3BBzBtmuXZJooEv1Fbw0HKA==
X-Received: by 2002:a1c:1dd1:: with SMTP id d200mr205134wmd.82.1625241346471;
        Fri, 02 Jul 2021 08:55:46 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw5g/VM21EKC5p1b+bedRgUGipGzZg9oN5IehHhOj+/WVKmexFW92+hQHKujHlDSVZapekDzw==
X-Received: by 2002:a1c:1dd1:: with SMTP id d200mr205117wmd.82.1625241346342;
        Fri, 02 Jul 2021 08:55:46 -0700 (PDT)
Received: from redhat.com ([2.55.4.39])
        by smtp.gmail.com with ESMTPSA id n12sm4180006wmq.5.2021.07.02.08.55.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Jul 2021 08:55:45 -0700 (PDT)
Date:   Fri, 2 Jul 2021 11:55:40 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>,
        Daniel Wagner <dwagner@suse.de>,
        Wen Xiong <wenxiong@us.ibm.com>,
        John Garry <john.garry@huawei.com>,
        Hannes Reinecke <hare@suse.de>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V2 5/6] virtio: add one field into virtio_device for
 recording if device uses managed irq
Message-ID: <20210702115430-mutt-send-email-mst@kernel.org>
References: <20210702150555.2401722-1-ming.lei@redhat.com>
 <20210702150555.2401722-6-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210702150555.2401722-6-ming.lei@redhat.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 02, 2021 at 11:05:54PM +0800, Ming Lei wrote:
> blk-mq needs to know if the device uses managed irq, so add one field
> to virtio_device for recording if device uses managed irq.
> 
> If the driver use managed irq, this flag has to be set so it can be
> passed to blk-mq.
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Ming Lei <ming.lei@redhat.com>


The API seems somewhat confusing. virtio does not request
a managed irq as such, does it? I think it's a decision taken
by the irq core.

Any way to query the irq to find out if it's managed?


> ---
>  drivers/block/virtio_blk.c         | 2 ++
>  drivers/scsi/virtio_scsi.c         | 1 +
>  drivers/virtio/virtio_pci_common.c | 1 +
>  include/linux/virtio.h             | 1 +
>  4 files changed, 5 insertions(+)
> 
> diff --git a/drivers/block/virtio_blk.c b/drivers/block/virtio_blk.c
> index e4bd3b1fc3c2..33b9c80ac475 100644
> --- a/drivers/block/virtio_blk.c
> +++ b/drivers/block/virtio_blk.c
> @@ -764,6 +764,8 @@ static int virtblk_probe(struct virtio_device *vdev)
>  	vblk->tag_set.queue_depth = queue_depth;
>  	vblk->tag_set.numa_node = NUMA_NO_NODE;
>  	vblk->tag_set.flags = BLK_MQ_F_SHOULD_MERGE;
> +	if (vdev->use_managed_irq)
> +		vblk->tag_set.flags |= BLK_MQ_F_MANAGED_IRQ;
>  	vblk->tag_set.cmd_size =
>  		sizeof(struct virtblk_req) +
>  		sizeof(struct scatterlist) * sg_elems;
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index b9c86a7e3b97..f301917abc84 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -891,6 +891,7 @@ static int virtscsi_probe(struct virtio_device *vdev)
>  	shost->max_channel = 0;
>  	shost->max_cmd_len = VIRTIO_SCSI_CDB_SIZE;
>  	shost->nr_hw_queues = num_queues;
> +	shost->use_managed_irq = vdev->use_managed_irq;
>  
>  #ifdef CONFIG_BLK_DEV_INTEGRITY
>  	if (virtio_has_feature(vdev, VIRTIO_SCSI_F_T10_PI)) {
> diff --git a/drivers/virtio/virtio_pci_common.c b/drivers/virtio/virtio_pci_common.c
> index 222d630c41fc..f2ac48fb477b 100644
> --- a/drivers/virtio/virtio_pci_common.c
> +++ b/drivers/virtio/virtio_pci_common.c
> @@ -128,6 +128,7 @@ static int vp_request_msix_vectors(struct virtio_device *vdev, int nvectors,
>  	if (desc) {
>  		flags |= PCI_IRQ_AFFINITY;
>  		desc->pre_vectors++; /* virtio config vector */
> +		vdev->use_managed_irq = true;
>  	}
>  
>  	err = pci_alloc_irq_vectors_affinity(vp_dev->pci_dev, nvectors,
> diff --git a/include/linux/virtio.h b/include/linux/virtio.h
> index b1894e0323fa..85cc773b2dc7 100644
> --- a/include/linux/virtio.h
> +++ b/include/linux/virtio.h
> @@ -109,6 +109,7 @@ struct virtio_device {
>  	bool failed;
>  	bool config_enabled;
>  	bool config_change_pending;
> +	bool use_managed_irq;
>  	spinlock_t config_lock;
>  	struct device dev;
>  	struct virtio_device_id id;
> -- 
> 2.31.1

