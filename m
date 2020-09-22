Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 053D3C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:01:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7AFB23A60
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:01:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dMJ+3jBe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729315AbgIVCB1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 22:01:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:40994 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729307AbgIVCB1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 22:01:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600740085;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tzo+iSLdl/HV45jduxk4SIxbpvPEBNGD2dSVt98peB0=;
        b=dMJ+3jBeerqRU7TOo1ycVwONGDB9FNTLRuT6nouDHM6ZuDBZ51mifeu1dEwNVQGrfuwq3v
        gX7EtLuKxHOGUK9zwMhzC3e542wlIRA2YdwAT5YvpFU73UkcyylFyBGAxUwqB/WrrInm4a
        EkAw/5RGdMbXO1kDKho28EO2YBX807I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-147-UvOzHbDKNpaWiXKnNTsUJw-1; Mon, 21 Sep 2020 22:01:21 -0400
X-MC-Unique: UvOzHbDKNpaWiXKnNTsUJw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 33292107464B;
        Tue, 22 Sep 2020 02:01:20 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4A08573670;
        Tue, 22 Sep 2020 02:01:10 +0000 (UTC)
Subject: Re: [PATCH 7/8] vhost: remove work arg from vhost_work_flush
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-8-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <ce8af213-1eff-7c4e-b5e8-660267b8ff31@redhat.com>
Date:   Tue, 22 Sep 2020 10:01:09 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600712588-9514-8-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/9/22 上午2:23, Mike Christie wrote:
> vhost_work_flush doesn't do anything with the work arg. This patch drops
> it and then renames vhost_work_flush to vhost_work_dev_flush to reflect
> that the function flushes all the works in the dev and not just a
> specific queue or work item.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>


Acked-by: Jason Wang <jasowang@redhat.com>


> ---
>   drivers/vhost/scsi.c  | 4 ++--
>   drivers/vhost/vhost.c | 8 ++++----
>   drivers/vhost/vhost.h | 2 +-
>   drivers/vhost/vsock.c | 2 +-
>   4 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 8791db8..5833059 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1469,8 +1469,8 @@ static void vhost_scsi_flush(struct vhost_scsi *vs)
>   	/* Flush both the vhost poll and vhost work */
>   	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
>   		vhost_scsi_flush_vq(vs, i);
> -	vhost_work_flush(&vs->dev, &vs->vs_completion_work);
> -	vhost_work_flush(&vs->dev, &vs->vs_event_work);
> +	vhost_work_dev_flush(&vs->dev);
> +	vhost_work_dev_flush(&vs->dev);
>   
>   	/* Wait for all reqs issued before the flush to be finished */
>   	for (i = 0; i < VHOST_SCSI_MAX_VQ; i++)
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5dd9eb1..f83674e 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -231,7 +231,7 @@ void vhost_poll_stop(struct vhost_poll *poll)
>   }
>   EXPORT_SYMBOL_GPL(vhost_poll_stop);
>   
> -void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
> +void vhost_work_dev_flush(struct vhost_dev *dev)
>   {
>   	struct vhost_flush_struct flush;
>   
> @@ -243,13 +243,13 @@ void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work)
>   		wait_for_completion(&flush.wait_event);
>   	}
>   }
> -EXPORT_SYMBOL_GPL(vhost_work_flush);
> +EXPORT_SYMBOL_GPL(vhost_work_dev_flush);
>   
>   /* Flush any work that has been scheduled. When calling this, don't hold any
>    * locks that are also used by the callback. */
>   void vhost_poll_flush(struct vhost_poll *poll)
>   {
> -	vhost_work_flush(poll->dev, &poll->work);
> +	vhost_work_dev_flush(poll->dev);
>   }
>   EXPORT_SYMBOL_GPL(vhost_poll_flush);
>   
> @@ -542,7 +542,7 @@ static int vhost_attach_cgroups(struct vhost_dev *dev)
>   	attach.owner = current;
>   	vhost_work_init(&attach.work, vhost_attach_cgroups_work);
>   	vhost_work_queue(dev, &attach.work);
> -	vhost_work_flush(dev, &attach.work);
> +	vhost_work_dev_flush(dev);
>   	return attach.ret;
>   }
>   
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 3d30b3d..b91efb5 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -46,7 +46,7 @@ void vhost_poll_init(struct vhost_poll *poll, vhost_work_fn_t fn,
>   void vhost_poll_stop(struct vhost_poll *poll);
>   void vhost_poll_flush(struct vhost_poll *poll);
>   void vhost_poll_queue(struct vhost_poll *poll);
> -void vhost_work_flush(struct vhost_dev *dev, struct vhost_work *work);
> +void vhost_work_dev_flush(struct vhost_dev *dev);
>   long vhost_vring_ioctl(struct vhost_dev *d, unsigned int ioctl, void __user *argp);
>   
>   struct vhost_log {
> diff --git a/drivers/vhost/vsock.c b/drivers/vhost/vsock.c
> index a483cec..f40205f 100644
> --- a/drivers/vhost/vsock.c
> +++ b/drivers/vhost/vsock.c
> @@ -652,7 +652,7 @@ static void vhost_vsock_flush(struct vhost_vsock *vsock)
>   	for (i = 0; i < ARRAY_SIZE(vsock->vqs); i++)
>   		if (vsock->vqs[i].handle_kick)
>   			vhost_poll_flush(&vsock->vqs[i].poll);
> -	vhost_work_flush(&vsock->dev, &vsock->send_pkt_work);
> +	vhost_work_dev_flush(&vsock->dev);
>   }
>   
>   static void vhost_vsock_reset_orphans(struct sock *sk)

