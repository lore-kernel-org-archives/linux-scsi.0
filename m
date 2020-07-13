Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31129C433E2
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:23:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1016C2072D
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:23:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="I3YD8cpE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729318AbgGMLXa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:23:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:42723 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728950AbgGMLX2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jul 2020 07:23:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594639405;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Cp13jJuIIl8muXNVHzNvpxZz6DmTE1jSSxstK7LrSuw=;
        b=I3YD8cpEE4+NDUiKJZs0nC847r4KvTlXO5w+cYdNCz+RB7DA8nBMVFq5U5oA0C2vP7ilN4
        1k00JdZlNvegDiGid8fBmAQMLoZK41kC7W6zXQUD9re9jvSDfRqRqyWc7uPdFwTuy+YGPS
        v5nOrzgpFjA04oerRdCrjUnVpQjj1rA=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-119-tF8m5n3uMlWNZxCbR__v7g-1; Mon, 13 Jul 2020 07:23:23 -0400
X-MC-Unique: tF8m5n3uMlWNZxCbR__v7g-1
Received: by mail-wm1-f70.google.com with SMTP id z74so12987760wmc.4
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 04:23:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Cp13jJuIIl8muXNVHzNvpxZz6DmTE1jSSxstK7LrSuw=;
        b=uZYQvzSjFlSrv4wUzTUGAXqpSbhFqETbZfgvdlfuc0TL0e3zKTqP7+R2rkwk/xF+ZB
         s8L6/KObPCSvrWXnd0wFGaVQwIMGsRzvLrBTQw+PuuCSzAu/+8IK6E7ztye/DKySCBf/
         oRUkL5RHFff6exfKRZOIHA/TjRdMIp4RU45qJ71e7SbYVpP3jRwqaPd4sZB+P/UQ7XLW
         e5swS2M/E4q0QHWIOgtPeAT1STOcc7iy9D89x/YDC1F3bMn9KFieeA+rTti77ca8Yz7p
         5j800dn2Xqc21S1zXLWi8/V03gXlMgoEoCf6YP5oulVOfcRX8YF4k9eUE3nvXdbuiakc
         1Acg==
X-Gm-Message-State: AOAM531PkDzC7H5XEHPq97DcMQ3GyhY1pHy01dL7givEYA+vIgQ24qQY
        E5grrYPywymxaHKNF+3Ds5M9eeFcD7xhW5/ZpBldHxpNJeKzzqc9q9UnmQk4AHM7YA4i0fgbV3P
        9Q8bMiE4FmG/yr7vUqbgECg==
X-Received: by 2002:adf:84e2:: with SMTP id 89mr82610820wrg.139.1594639402329;
        Mon, 13 Jul 2020 04:23:22 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxzoCrHCmvHA+9tYCCZvkKCKZhV/F4YlMxW4KU+tbDXUAXf+8nTnhjTJ8IHP6HmlwcPSxo1PQ==
X-Received: by 2002:adf:84e2:: with SMTP id 89mr82610801wrg.139.1594639402164;
        Mon, 13 Jul 2020 04:23:22 -0700 (PDT)
Received: from redhat.com (bzq-79-180-10-140.red.bezeqint.net. [79.180.10.140])
        by smtp.gmail.com with ESMTPSA id m16sm25473869wro.0.2020.07.13.04.23.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 04:23:21 -0700 (PDT)
Date:   Mon, 13 Jul 2020 07:23:13 -0400
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 12/24] scsi: virtio_scsi: Demote seemingly
 unintentional kerneldoc header
Message-ID: <20200713071453-mutt-send-email-mst@kernel.org>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <20200713080001.128044-13-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200713080001.128044-13-lee.jones@linaro.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 13, 2020 at 08:59:49AM +0100, Lee Jones wrote:
> This is the only use of kerneldoc in the sourcefile and no
> descriptions are provided.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>  drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'vscsi' not described in 'virtscsi_complete_cmd'
>  drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'buf' not described in 'virtscsi_complete_cmd'
> 
> Cc: "Michael S. Tsirkin" <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: virtualization@lists.linux-foundation.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> Acked-by: Paolo Bonzini <pbonzini@redhat.com>

Acked-by: Michael S. Tsirkin <mst@redhat.com>

Pls merge with the rest of the patches (which tree is this for?)

> ---
>  drivers/scsi/virtio_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
> index 0e0910c5b9424..56875467e4984 100644
> --- a/drivers/scsi/virtio_scsi.c
> +++ b/drivers/scsi/virtio_scsi.c
> @@ -100,7 +100,7 @@ static void virtscsi_compute_resid(struct scsi_cmnd *sc, u32 resid)
>  		scsi_set_resid(sc, resid);
>  }
>  
> -/**
> +/*
>   * virtscsi_complete_cmd - finish a scsi_cmd and invoke scsi_done
>   *
>   * Called with vq_lock held.
> -- 
> 2.25.1

