Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 787DEC433FE
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:11:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1455B225A9
	for <linux-scsi@archiver.kernel.org>; Fri,  4 Dec 2020 08:11:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbgLDILO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 4 Dec 2020 03:11:14 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:52660 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726122AbgLDILO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 4 Dec 2020 03:11:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1607069388;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7PzD8ci+JJSUGwk83KFpOt0nd1ee50ac53SGYVA8XcE=;
        b=FEAwryQnLilpSZ8I+G3S4656zRuq+XO40X5gumLQYhDcSHciwfoPCSIoFKVDZtKvzQUHib
        Exy9DqJ9E09Gt7V3fqpwcygS3J9s2okzO5iLZxMUfD8DF9OT1fSCXDIspYYdgMsJqqPvCM
        IzSPNyamVwW4M0pUzxyKKBlzWx7mhIc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-345-KFTildZxNF2BQ1FQWqstdA-1; Fri, 04 Dec 2020 03:09:44 -0500
X-MC-Unique: KFTildZxNF2BQ1FQWqstdA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 56E85802B40;
        Fri,  4 Dec 2020 08:09:43 +0000 (UTC)
Received: from [10.72.12.116] (ovpn-12-116.pek2.redhat.com [10.72.12.116])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 847A61A8A4;
        Fri,  4 Dec 2020 08:09:34 +0000 (UTC)
Subject: Re: [RFC PATCH 5/8] vhost: allow userspace to bind vqs to CPUs
To:     Mike Christie <michael.christie@oracle.com>, sgarzare@redhat.com,
        stefanha@redhat.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, mst@redhat.com, pbonzini@redhat.com,
        virtualization@lists.linux-foundation.org
References: <1607068593-16932-1-git-send-email-michael.christie@oracle.com>
 <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
From:   Jason Wang <jasowang@redhat.com>
Message-ID: <4546ef72-da7c-df9e-53be-c937a5437436@redhat.com>
Date:   Fri, 4 Dec 2020 16:09:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1607068593-16932-6-git-send-email-michael.christie@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2020/12/4 下午3:56, Mike Christie wrote:
> +static long vhost_vring_set_cpu(struct vhost_dev *d, struct vhost_virtqueue *vq,
> +				void __user *argp)
> +{
> +	struct vhost_vring_state s;
> +	int ret = 0;
> +
> +	if (vq->private_data)
> +		return -EBUSY;
> +
> +	if (copy_from_user(&s, argp, sizeof s))
> +		return -EFAULT;
> +
> +	if (s.num == -1) {
> +		vq->cpu = s.num;
> +		return 0;
> +	}
> +
> +	if (s.num >= nr_cpu_ids)
> +		return -EINVAL;
> +
> +	if (!d->ops || !d->ops->get_workqueue)
> +		return -EINVAL;
> +
> +	if (!d->wq)
> +		d->wq = d->ops->get_workqueue();
> +	if (!d->wq)
> +		return -EINVAL;
> +
> +	vq->cpu = s.num;
> +	return ret;
> +}


So one question here. Who is in charge of doing this set_cpu? Note 
that sched_setaffinity(2) requires CAP_SYS_NICE to work, so I wonder 
whether or not it's legal for unprivileged Qemu to do this.

Thanks


