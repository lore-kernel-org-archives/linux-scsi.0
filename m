Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04220C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Mar 2022 14:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349201AbiCOOjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Mar 2022 10:39:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349192AbiCOOjh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Mar 2022 10:39:37 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A957A3BBCB
        for <linux-scsi@vger.kernel.org>; Tue, 15 Mar 2022 07:38:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1647355104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=oIP9eWTq1MZaXmiOhkKg9VYEpBhdJtYGb5hpV7ZOjz8=;
        b=P3WOXzP8vB0GtHkX0nbp7R2+f16hdTDBfwl9YeqZ2/PwQafFRU60b9bp7fxqdDHkwfx19H
        rR84GVzmX6vV0ndCMNxNusyMDFGki5RaF+D0T+kY4/nX6e/Ab3eC3NOvFG32dF1EvMUuWt
        jqiNI92nE9DyW3PbX6ea0/dRK58QsNs=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-608-mOGPsvbkMpqlRSkpcsHQfQ-1; Tue, 15 Mar 2022 10:38:19 -0400
X-MC-Unique: mOGPsvbkMpqlRSkpcsHQfQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E249438008A2;
        Tue, 15 Mar 2022 14:38:18 +0000 (UTC)
Received: from T590 (ovpn-8-28.pek2.redhat.com [10.72.8.28])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 80DADC28100;
        Tue, 15 Mar 2022 14:38:11 +0000 (UTC)
Date:   Tue, 15 Mar 2022 22:38:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     damien.lemoal@opensource.wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, bvanassche@acm.org, hch@lst.de,
        hare@suse.de, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.wilck@suse.com
Subject: Re: [PATCH 1/2] scsi: core: Fix sbitmap depth in
 scsi_realloc_sdev_budget_map()
Message-ID: <YjCkzSDc6HQ6hhKR@T590>
References: <1647340746-17600-1-git-send-email-john.garry@huawei.com>
 <1647340746-17600-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1647340746-17600-2-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 15, 2022 at 06:39:05PM +0800, John Garry wrote:
> In commit edb854a3680b ("scsi: core: Reallocate device's budget map on
> queue depth change"), the sbitmap for the device budget map may be
> reallocated after the slave device depth is configured.
> 
> When the sbitmap is reallocated we use the result from
> scsi_device_max_queue_depth() for the sbitmap size, but don't resize to
> match the actual device queue depth.
> 
> Fix by resizing the sbitmap after reallocating the budget sbitmap.
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
>  drivers/scsi/scsi_scan.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f4e6c68ac99e..2ef78083f1ef 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -223,6 +223,8 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  	int ret;
>  	struct sbitmap sb_backup;
>  
> +	depth = min_t(unsigned int, depth, scsi_device_max_queue_depth(sdev));
> +
>  	/*
>  	 * realloc if new shift is calculated, which is caused by setting
>  	 * up one new default queue depth after calling ->slave_configure
> @@ -245,6 +247,9 @@ static int scsi_realloc_sdev_budget_map(struct scsi_device *sdev,
>  				scsi_device_max_queue_depth(sdev),
>  				new_shift, GFP_KERNEL,
>  				sdev->request_queue->node, false, true);
> +	if (!ret)
> +		sbitmap_resize(&sdev->budget_map, depth);
> +

Looks fine, 

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

