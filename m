Return-Path: <SRS0=LwoI=W7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EB60C3A5A7
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:14:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EFE132339D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Sep 2019 09:14:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728526AbfIDJOo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Sep 2019 05:14:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58614 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727156AbfIDJOo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 4 Sep 2019 05:14:44 -0400
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com [209.85.128.71])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D1C8B2A09A4
        for <linux-scsi@vger.kernel.org>; Wed,  4 Sep 2019 09:14:43 +0000 (UTC)
Received: by mail-wm1-f71.google.com with SMTP id c11so572760wml.6
        for <linux-scsi@vger.kernel.org>; Wed, 04 Sep 2019 02:14:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=WulsqcUDqGAlte0XT35jyBuHqWE16gY7+JD//6GJ8LE=;
        b=MgW+klnUAvznE1OybYWcI3OHLCYY72L4I/GImbq/5VTmOPHdOd6ry2qu3y57vFL5zv
         Rx5DoMsszE0Qy+oOaZNITTD4dUjrrlvDlOYIQxDmSe4mr4JSXRS4Psmt2jkCT3bcZZV4
         HoVIbYblKf9bPNl/xaViH3K5fOVWSa74Rpl8vz1gtFdustoqnKGH8JQmJ+6U/UYBSfnj
         U3lRS+/uOR7ygO5H3Kly+KJzSW8NUH0noeNiJ5sqjEHsEq7kzmVfWLVov76Bgl7z1xUR
         nufEEOQ3SBfXT82Xg3l08GsJDDye8IyaEa+yJbWceJenOVpDceJ77CdhWsMK07z11OUz
         rWNA==
X-Gm-Message-State: APjAAAXs8jyhK3kT/gvztksUK2IeQhU5oraPdQrWja1Dv0/E6YNufD6b
        FtyHGNMdIVBwro0Ot//V/5kHpz/dxIozJ+/SllL5l6LYRT3A1atof+ZZANX/dBCjcDAKmJ0mLXH
        BmBRUE+NHQrqpjZuTh72OEw==
X-Received: by 2002:a1c:9e03:: with SMTP id h3mr3545580wme.112.1567588482666;
        Wed, 04 Sep 2019 02:14:42 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyWE7W0esSMrtACJMfgH6u7NS92/HwtNgSGZHmvycxF9VRjYlNRFA/kgpbIhqo36d95tm0xTQ==
X-Received: by 2002:a1c:9e03:: with SMTP id h3mr3545568wme.112.1567588482495;
        Wed, 04 Sep 2019 02:14:42 -0700 (PDT)
Received: from redhat.com (bzq-79-176-40-226.red.bezeqint.net. [79.176.40.226])
        by smtp.gmail.com with ESMTPSA id b1sm2455532wmj.4.2019.09.04.02.14.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Sep 2019 02:14:41 -0700 (PDT)
Date:   Wed, 4 Sep 2019 05:14:33 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Matt Lupfer <mlupfer@ddn.com>
Cc:     Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] scsi: virtio_scsi: unplug LUNs when events missed
Message-ID: <20190904051230-mutt-send-email-mst@kernel.org>
References: <20190903170408.32286-1-mlupfer@ddn.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190903170408.32286-1-mlupfer@ddn.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Sep 03, 2019 at 05:04:20PM +0000, Matt Lupfer wrote:
> The event handler calls scsi_scan_host() when events are missed, which
> will hotplug new LUNs.  However, this function won't remove any
> unplugged LUNs.  The result is that hotunplug doesn't work properly when
> the number of unplugged LUNs exceeds the event queue size (currently 8).
> 
> Scan existing LUNs when events are missed to check if they are still
> present.  If not, remove them.
> 
> Signed-off-by: Matt Lupfer <mlupfer@ddn.com>
> ---
>  drivers/scsi/virtio_scsi.c | 31 +++++++++++++++++++++++++++++++
>  1 file changed, 31 insertions(+)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 297e1076e571..18df77bf371b 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -324,6 +324,36 @@ static void virtscsi_handle_param_change(struct virtio_scsi *vscsi,
>  	scsi_device_put(sdev);
>  }
>  
> +static void virtscsi_rescan_hotunplug(struct virtio_scsi *vscsi)
> +{
> +	struct scsi_device *sdev;
> +	struct Scsi_Host *shost = virtio_scsi_host(vscsi->vdev);
> +	unsigned char scsi_cmd[MAX_COMMAND_SIZE];
> +	int result, inquiry_len, inq_result_len = 256;
> +	char *inq_result = kmalloc(inq_result_len, GFP_KERNEL);
> +
> +	shost_for_each_device(sdev, shost) {
> +		inquiry_len = sdev->inquiry_len ? sdev->inquiry_len : 36;
> +
> +		memset(scsi_cmd, 0, sizeof(scsi_cmd));
> +		scsi_cmd[0] = INQUIRY;
> +		scsi_cmd[4] = (unsigned char) inquiry_len;
> +
> +		memset(inq_result, 0, inq_result_len);
> +
> +		result = scsi_execute_req(sdev, scsi_cmd, DMA_FROM_DEVICE,
> +					  inq_result, inquiry_len, NULL,
> +					  2, 3, NULL);


Where do the weird 2 and 3 values come from?

Most callers seem to use SD_TIMEOUT, SD_MAX_RETRIES...

> +
> +		if (result == 0 && inq_result[0] >> 5) {
> +			/* PQ indicates the LUN is not attached */
> +			scsi_remove_device(sdev);
> +		}
> +	}
> +
> +	kfree(inq_result);
> +}
> +
>  static void virtscsi_handle_event(struct work_struct *work)
>  {
>  	struct virtio_scsi_event_node *event_node =
> @@ -335,6 +365,7 @@ static void virtscsi_handle_event(struct work_struct *work)
>  	    cpu_to_virtio32(vscsi->vdev, VIRTIO_SCSI_T_EVENTS_MISSED)) {
>  		event->event &= ~cpu_to_virtio32(vscsi->vdev,
>  						   VIRTIO_SCSI_T_EVENTS_MISSED);
> +		virtscsi_rescan_hotunplug(vscsi);
>  		scsi_scan_host(virtio_scsi_host(vscsi->vdev));
>  	}
>  
> -- 
> 2.23.0
