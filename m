Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-19.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE4BC433EF
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:16:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A016E60EFD
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Sep 2021 06:16:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239346AbhIFGRl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 02:17:41 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:52046 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231271AbhIFGRk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 02:17:40 -0400
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B8DD32007F;
        Mon,  6 Sep 2021 06:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1630908994; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kg4Wg8l9Kk8kQXbHb+Zd/FuQr2WxF39YElxb+dyQ+VE=;
        b=jUKgUkat+IWhWae9SRap4L0fOrkeAZYxNNu3dInXbGvI0NwGondgJOGBQ3nqMwT87HBvDx
        IiCWFhf0JbwgMc/IBcVoQrOD2wWgHtscQ49PVA/dZUyLxfE6EgXuAoeQbNEp7Mk/SzVzIn
        aB7KnTqlbofAItfphmfIvnFPK76BTF4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1630908994;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kg4Wg8l9Kk8kQXbHb+Zd/FuQr2WxF39YElxb+dyQ+VE=;
        b=KrMO6ehR/K/zkDmPLkRvTxvqE5GVaXbGNecWPadjaqC3QuTyW1pJ2aFh5QHeu/H57K2JPF
        RApH1raAUiWxbPDw==
Received: from imap1.suse-dmz.suse.de (imap1.suse-dmz.suse.de [192.168.254.73])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap1.suse-dmz.suse.de (Postfix) with ESMTPS id B8ACF13299;
        Mon,  6 Sep 2021 06:16:33 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap1.suse-dmz.suse.de with ESMTPSA
        id lP1cKkGyNWFKTwAAGKfGzw
        (envelope-from <hare@suse.de>); Mon, 06 Sep 2021 06:16:33 +0000
Subject: Re: [PATCH v3 3/8] nvme: add error handling support for add_disk()
To:     Luis Chamberlain <mcgrof@kernel.org>, axboe@kernel.dk,
        martin.petersen@oracle.com, jejb@linux.ibm.com, kbusch@kernel.org,
        sagi@grimberg.me, adrian.hunter@intel.com, beanhuo@micron.com,
        ulf.hansson@linaro.org, avri.altman@wdc.com, swboyd@chromium.org,
        agk@redhat.com, snitzer@redhat.com, josef@toxicpanda.com
Cc:     hch@infradead.org, bvanassche@acm.org, ming.lei@redhat.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-mmc@vger.kernel.org, dm-devel@redhat.com,
        nbd@other.debian.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-4-mcgrof@kernel.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <677ca876-b003-d3b5-9e2e-d50ebef82cce@suse.de>
Date:   Mon, 6 Sep 2021 08:16:35 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210830212538.148729-4-mcgrof@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/30/21 11:25 PM, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>   drivers/nvme/host/core.c | 9 ++++++++-
>   1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index 8679a108f571..687d3be563a3 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -3763,7 +3763,9 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
>   
>   	nvme_get_ctrl(ctrl);
>   
> -	device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups);
> +	if (device_add_disk(ctrl->device, ns->disk, nvme_ns_id_attr_groups))
> +		goto out_cleanup_ns_from_list;
> +
>   	if (!nvme_ns_head_multipath(ns->head))
>   		nvme_add_ns_cdev(ns);
>   
> @@ -3773,6 +3775,11 @@ static void nvme_alloc_ns(struct nvme_ctrl *ctrl, unsigned nsid,
>   
>   	return;
>   
> + out_cleanup_ns_from_list:
> +	nvme_put_ctrl(ctrl);
> +	down_write(&ctrl->namespaces_rwsem);
> +	list_del_init(&ns->list);
> +	up_write(&ctrl->namespaces_rwsem);
>    out_unlink_ns:
>   	mutex_lock(&ctrl->subsys->lock);
>   	list_del_rcu(&ns->siblings);
> 
I would rather turn this around, and call 'nvme_put_ctrl()' after 
removing the namespace from the list. But it's probably more a style 
issue, come to think of it.

Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
