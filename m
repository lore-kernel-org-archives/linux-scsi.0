Return-Path: <SRS0=VSHB=C7=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45199C4346E
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:02:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 01CE623A74
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Sep 2020 02:02:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NlernS3Y"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729421AbgIVCC3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 22:02:29 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59604 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729007AbgIVCC3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Sep 2020 22:02:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1600740148;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=W1QhFiJpeL+8vBbjBr4sETQTmp+yKXR4gMOOBx8WCao=;
        b=NlernS3Y9dY3f7sHPn2yngIt23jCyozJ92tcbzm8pC9ErK1foCG6FN4hIALLkkGplrDLPg
        NbWqyvnFaqxL43LvyyJaVHHGL7mPB4NDMINGjUckbqfiHSLAPPSv1Vp5c0RpLU7Qe2ql2F
        +oDi+P+PqlyayoFLeGzbWZzupwPwmFI=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-222-SLjUKDTTPcO_OkI5t8g0kg-1; Mon, 21 Sep 2020 22:02:26 -0400
X-MC-Unique: SLjUKDTTPcO_OkI5t8g0kg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 428401005E64;
        Tue, 22 Sep 2020 02:02:25 +0000 (UTC)
Received: from [10.72.13.139] (ovpn-13-139.pek2.redhat.com [10.72.13.139])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 209CB5DA30;
        Tue, 22 Sep 2020 02:02:16 +0000 (UTC)
Subject: Re: [PATCH 2/8] vhost: add helper to check if a vq has been setup
To:     Mike Christie <michael.christie@oracle.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1600712588-9514-1-git-send-email-michael.christie@oracle.com>
 <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <e2d16333-d5ed-4c5c-58b3-7b5d0a9da47a@redhat.com>
Date:   Tue, 22 Sep 2020 10:02:15 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1600712588-9514-3-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/9/22 上午2:23, Mike Christie wrote:
> This adds a helper check if a vq has been setup. The next patches
> will use this when we move the vhost scsi cmd preallocation from per
> session to per vq. In the per vq case, we only want to allocate cmds
> for vqs that have actually been setup and not for all the possible
> vqs.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/vhost.c | 9 +++++++++
>   drivers/vhost/vhost.h | 1 +
>   2 files changed, 10 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index b45519c..5dd9eb1 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -305,6 +305,15 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>   	spin_lock_init(&call_ctx->ctx_lock);
>   }
>   
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
> +{
> +	if (vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq))
> +		return true;
> +	else
> +		return false;
> +}
> +EXPORT_SYMBOL_GPL(vhost_vq_is_setup);


This is probably ok but I wonder maybe we should have something like 
what vDPA did (VHOST_SET_VRING_ENABLE) to match virtio 1.0 device 
definition.

Thanks


> +
>   static void vhost_vq_reset(struct vhost_dev *dev,
>   			   struct vhost_virtqueue *vq)
>   {
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index 9032d3c..3d30b3d 100644
> --- a/drivers/vhost/vhost.h
> +++ b/drivers/vhost/vhost.h
> @@ -190,6 +190,7 @@ int vhost_get_vq_desc(struct vhost_virtqueue *,
>   		      struct vhost_log *log, unsigned int *log_num);
>   void vhost_discard_vq_desc(struct vhost_virtqueue *, int n);
>   
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq);
>   int vhost_vq_init_access(struct vhost_virtqueue *);
>   int vhost_add_used(struct vhost_virtqueue *, unsigned int head, int len);
>   int vhost_add_used_n(struct vhost_virtqueue *, struct vring_used_elem *heads,

