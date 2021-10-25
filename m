Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73EE5C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 09:08:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 58B1E60EE9
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 09:08:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232496AbhJYJLU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 05:11:20 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:60443 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232440AbhJYJLT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 25 Oct 2021 05:11:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635152937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XeGNSOcAvBmLSqJs1UuImaAZO/HaSB8DxKn5L+5tDB0=;
        b=Wenb+UaHfY3BHKOnKiwF83ErdkoY1odxDOqTCXnb7zC32aIE/guoxbRf3CrqDepdifjDfv
        phg4IeTW5CnaYLdMZSWidB3oaupd4vOMk3RXnIh1JHCBldeRc3nvWcPBPOJKwzVuUmXh6r
        /cRSim0EDiQEtJydB17UC759jZHdebA=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-217-w3e6rBtLMtWD7tA0QgcWCA-1; Mon, 25 Oct 2021 05:08:55 -0400
X-MC-Unique: w3e6rBtLMtWD7tA0QgcWCA-1
Received: by mail-ed1-f71.google.com with SMTP id u17-20020a50d511000000b003daa3828c13so9241365edi.12
        for <linux-scsi@vger.kernel.org>; Mon, 25 Oct 2021 02:08:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XeGNSOcAvBmLSqJs1UuImaAZO/HaSB8DxKn5L+5tDB0=;
        b=npsYcR1zhjrYmTlI8vZwywHjcB20QeANPNbYZpymYRj5WDhzNHL/yGCW/UJvlFwIXq
         8GE6/hY2kc6tI/H8RYwo2UaGvG2V9fxUaejM5LZ3DqrPjCGKXIWnEas34wtgX+dLawAE
         YZxCyDzJ3QMLMU5UZoDMSe9WtBpA40LtFXnN78NJIc3P19CFOgiU49eD8114Kmv3Mfy9
         tiI7HWnDopJHgK5byg0fJjcYDa/XLcdYMx4ns3tdGh9YT9q3rHE+Px2eszturqz5b7pT
         eYAiFN5gQc331MdRyS7GjfAhj8BghDqEABSl54NCnXhpLmkX8Wt0/cXE7JpvnXhx7OtJ
         WcoA==
X-Gm-Message-State: AOAM530qfyJUp4D/iGSfauc6V4HjVNGOaPf/mROw95GF9FlXItW/zjlN
        d8zbYbmOJ2UyW4uTIzHO+DX0Jv+n4GBHDF18V4AWncYjS9NQToLiQBvUWnlDh+v5Gvgj4uGwium
        5uPMQXGMKvJD+WEl0NNud/A==
X-Received: by 2002:a17:907:3f9c:: with SMTP id hr28mr21157750ejc.246.1635152934823;
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz/sV83vvSJXd/ysEd58WtGrMeInWgBZZGAKoZJQ3ewcqc/wys+wOPgIfJKAvE2jCVNIiBILg==
X-Received: by 2002:a17:907:3f9c:: with SMTP id hr28mr21157730ejc.246.1635152934633;
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
Received: from steredhat (host-79-30-88-77.retail.telecomitalia.it. [79.30.88.77])
        by smtp.gmail.com with ESMTPSA id hb9sm3019913ejc.80.2021.10.25.02.08.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 25 Oct 2021 02:08:54 -0700 (PDT)
Date:   Mon, 25 Oct 2021 11:08:52 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH V3 06/11] vhost-sock: convert to vq helpers
Message-ID: <20211025090852.4kbqf3gieednw6ie@steredhat>
References: <20211022051911.108383-1-michael.christie@oracle.com>
 <20211022051911.108383-8-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211022051911.108383-8-michael.christie@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 22, 2021 at 12:19:06AM -0500, Mike Christie wrote:
>Convert from vhost dev based helpers to vq ones.
>
>Signed-off-by: Mike Christie <michael.christie@oracle.com>
>---
> drivers/vhost/vsock.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>
>diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
>index 938aefbc75ec..c50c60d0955e 100644
>--- a/drivers/vhost/vsock.c
>+++ b/drivers/vhost/vsock.c
>@@ -300,7 +300,7 @@ vhost_transport_send_pkt(struct virtio_vsock_pkt *pkt)
> 	list_add_tail(&pkt->list, &vsock->send_pkt_list);
> 	spin_unlock_bh(&vsock->send_pkt_list_lock);
>
>-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
>+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_TX], &vsock->send_pkt_work);

I think we should use VSOCK_VQ_RX. I know, the nomenclature is weird, 
but it's from the guest's point of view, so the host when sending 
packets uses the VSOCK_VQ_RX, see vhost_transport_send_pkt_work().


>
> 	rcu_read_unlock();
> 	return len;
>@@ -612,7 +612,7 @@ static int vhost_vsock_start(struct vhost_vsock *vsock)
> 	/* Some packets may have been queued before the device was started,
> 	 * let's kick the send worker to send them.
> 	 */
>-	vhost_work_queue(&vsock->dev, &vsock->send_pkt_work);
>+	vhost_vq_work_queue(&vsock->vqs[VSOCK_VQ_TX], 
>&vsock->send_pkt_work);

Ditto.

Thanks,
Stefano

