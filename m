Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299F9C388F7
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 07:21:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1ECC207BC
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Nov 2020 07:21:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="T0OF0AKq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726213AbgKJHVA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Nov 2020 02:21:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:33258 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728538AbgKJHU7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Nov 2020 02:20:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604992857;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3QOTDZeraTDO7qssTdQxdHgHxw/ERqq7xNQOpRhF6WU=;
        b=T0OF0AKqc+Fd/wVH4HoJ5r8hM/++/XjLGurRV0gwh9T5Y64VNv6IQv3OeOfCoqkpj6q7Cx
        CLFMhJFtEbPWSRX80+4MG3MT46FIDdZrsOOETy4lNrC4p47A29n/l3epehYf/OjPvNNyqm
        wnGI8iKo6xyR4WD0H0Sns+eVu9afHDA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-53-Uf3eP6YrNEmVx5Vilrz5FQ-1; Tue, 10 Nov 2020 02:20:56 -0500
X-MC-Unique: Uf3eP6YrNEmVx5Vilrz5FQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D22771E5CA0;
        Tue, 10 Nov 2020 07:20:46 +0000 (UTC)
Received: from [10.72.13.94] (ovpn-13-94.pek2.redhat.com [10.72.13.94])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 945B376666;
        Tue, 10 Nov 2020 07:20:44 +0000 (UTC)
Subject: Re: [PATCH 1/5] vhost: add helper to check if a vq has been setup
To:     Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1604986403-4931-1-git-send-email-michael.christie@oracle.com>
 <1604986403-4931-2-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <8ca030cf-593b-3b43-1551-7de37ebe4187@redhat.com>
Date:   Tue, 10 Nov 2020 15:20:42 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604986403-4931-2-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/11/10 下午1:33, Mike Christie wrote:
> This adds a helper check if a vq has been setup. The next patches
> will use this when we move the vhost scsi cmd preallocation from per
> session to per vq. In the per vq case, we only want to allocate cmds
> for vqs that have actually been setup and not for all the possible
> vqs.
>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/vhost/vhost.c | 6 ++++++
>   drivers/vhost/vhost.h | 1 +
>   2 files changed, 7 insertions(+)
>
> diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
> index 5c835a2..a262e12 100644
> --- a/drivers/vhost/vhost.c
> +++ b/drivers/vhost/vhost.c
> @@ -304,6 +304,12 @@ static void vhost_vring_call_reset(struct vhost_vring_call *call_ctx)
>   	memset(&call_ctx->producer, 0x0, sizeof(struct irq_bypass_producer));
>   }
>   
> +bool vhost_vq_is_setup(struct vhost_virtqueue *vq)
> +{
> +	return vq->avail && vq->desc && vq->used && vhost_vq_access_ok(vq);
> +}
> +EXPORT_SYMBOL_GPL(vhost_vq_is_setup);
> +
>   static void vhost_vq_reset(struct vhost_dev *dev,
>   			   struct vhost_virtqueue *vq)
>   {
> diff --git a/drivers/vhost/vhost.h b/drivers/vhost/vhost.h
> index e016cd3..b063324 100644
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


Acked-by: Jason Wang <jasowang@redhat.com>


