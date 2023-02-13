Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26872C636CC
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Feb 2023 12:11:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230508AbjBMML3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Feb 2023 07:11:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231431AbjBMMK7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Feb 2023 07:10:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74C643AA6
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 04:09:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1676290198;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3mEYzxx/bkDFLt7byV5MhD22WdETXrhwLYc+g6bKb6Q=;
        b=SnHUAqxflJK0A/HeBpu6r6ySXS0/LwY7qq1R954xafKSAmfgutJO3RH3hCN1NBtipN7evo
        3wB0wudt2eSsHIjOw+aImgNHiip8pIT5/NFZN0EtuqgvQxvRUioDWU92T25cwmUyTyJWbs
        RxQUhJTUVe3b3sBcU0vinMiVBnd0A+0=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-354-3o5S4mN1ORyxCfu5_h2SJg-1; Mon, 13 Feb 2023 07:09:57 -0500
X-MC-Unique: 3o5S4mN1ORyxCfu5_h2SJg-1
Received: by mail-ed1-f72.google.com with SMTP id s20-20020a05640217d400b004ab46449f12so5409103edy.23
        for <linux-scsi@vger.kernel.org>; Mon, 13 Feb 2023 04:09:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3mEYzxx/bkDFLt7byV5MhD22WdETXrhwLYc+g6bKb6Q=;
        b=AY8rZFyrp1cHlDPcZKe4kApS8VL/IkG768yxMSPKGFYSvJ2r67+rXDZi59CuUQRTcZ
         IC64/5cscTMFbKttLbpWyhyXCmG1McoQnPX9IdockjMQqe4M3ECYHB0Atokl/iZvse7F
         KiqQF6dW9h5aYWo9Ig52ifnAPBQkVe1so6gOz4Ip8Q4cbi2c35aQP2Zxv/s3mMaEk6mo
         LW7rUHDUGfOKwc/xjYq4W7jy31qNvvdrzQMkC9p5ZlR84cQnDyBZ5S1UdkhzBK0ROFg3
         IMaIV8b14KsO1mj5dbZsR08B4ZcsqMWdGr1jwL195Y87j9kuIErnbzWHRQMhu/E/tv8b
         2hOQ==
X-Gm-Message-State: AO0yUKUSHuMxZoL6PZsc++0ZXxaB/s703VV+a7o8FfcafUe8Sm51OdGK
        /VkP5+obrsB76UeyIBpAzr5+M2MsC8dt5l4O+hRwCogrdcIF2Yih75cPWR6qf2kyZNENbUrwoqE
        cX3OgSUH+PIjHRm12DQyTuw==
X-Received: by 2002:a17:906:1286:b0:886:50d:be8d with SMTP id k6-20020a170906128600b00886050dbe8dmr26816169ejb.13.1676290196340;
        Mon, 13 Feb 2023 04:09:56 -0800 (PST)
X-Google-Smtp-Source: AK7set/LVnxEG3I8rnVK7885EnaICcxb+lvhiOf/rZbS+wU3TNmlvfBa8qzgmQnMIPHWTVKERIaRaw==
X-Received: by 2002:a17:906:1286:b0:886:50d:be8d with SMTP id k6-20020a170906128600b00886050dbe8dmr26816157ejb.13.1676290196155;
        Mon, 13 Feb 2023 04:09:56 -0800 (PST)
Received: from redhat.com ([2.52.132.212])
        by smtp.gmail.com with ESMTPSA id l26-20020a170906079a00b008966488a5f1sm6757478ejc.144.2023.02.13.04.09.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Feb 2023 04:09:55 -0800 (PST)
Date:   Mon, 13 Feb 2023 07:09:50 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Zheng Wang <zyytlz.wz@163.com>
Cc:     hackerzheng666@gmail.com, jasowang@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        security@kernel.org, alex000young@gmail.com
Subject: Re: [PATCH v2] scsi: virtio_scsi: Fix poential NULL pointer
 dereference in  virtscsi_rescan_hotunplug
Message-ID: <20230213070906-mutt-send-email-mst@kernel.org>
References: <20230202064124.22277-1-zyytlz.wz@163.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230202064124.22277-1-zyytlz.wz@163.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 02, 2023 at 02:41:24PM +0800, Zheng Wang wrote:
> There is no check about the return value of kmalloc in
> virtscsi_rescan_hotunplug. Add the check to avoid use
> of null pointer 'inq_result' in case of the failure
> of kmalloc.
> 
> Signed-off-by: Zheng Wang <zyytlz.wz@163.com>
> ---

I fixed a typo in subject and tweaked the patch a bit

> v2:
> - add kfree to avoid memory leak
> ---
>  drivers/scsi/virtio_scsi.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index d07d24c06b54..a66d8815d738 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -330,7 +330,7 @@ static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
>  	scsi_device_put(sdev);
>  }
>  
> -static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
> +static int virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
>  {
>  	struct scsi_device *sdev;
>  	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> @@ -338,6 +338,11 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
>  	int result, inquiry_len, inq_result_len = 256;
>  	char *inq_result = kmalloc(inq_result_len, GFP_KERNEL);
>  
> +	if (!inq_result) {
> +		kfree(inq_result);
> +		return -ENOMEM;
> +	}
> +
>  	shost_for_each_device(sdev, shost) {
>  		inquiry_len = sdev->inquiry_len ? sdev->inquiry_len : 36;
>  
> @@ -366,6 +371,7 @@ static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
>  	}
>  
>  	kfree(inq_result);
> +	return 0;
>  }
>  
>  static void virtscsi_handle_event(struct work_struct *work)
> @@ -374,12 +380,15 @@ static void virtscsi_handle_event(struct work_struct *work)
>  		container_of(work, struct virtio_scsi_event_node, work);
>  	struct virtio_scsi *vscsi = event_node->vscsi;
>  	struct virtio_scsi_event *event = &event_node->event;
> +	int ret = 0;
>

dropped = 0 here
  
>  	if (event->event &
>  	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {

and moved declaration here.

>  		event->event &= ~cpu_to_virtio32(vscsi->vdev,
>  						   VIRTIO_SCSI_T_EVENTS_MISSED);
> -		virtscsi_rescan_hotunplug(vscsi);
> +		ret = virtscsi_rescan_hotunplug(vscsi);
> +		if (ret)
> +			return;
>  		scsi_scan_host(virtio_scsi_host(vscsi->vdev));
>  	}
>  
> -- 
> 2.25.1
> 
> 

