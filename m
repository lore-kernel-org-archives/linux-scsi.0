Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3BA5C433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 01:24:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0FBC611AE
	for <linux-scsi@archiver.kernel.org>; Thu, 20 May 2021 01:24:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhETB0C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 21:26:02 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43269 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230166AbhETB0C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 May 2021 21:26:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621473881;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=IFScK2pvhtODjjn+AQe2siqswh7swK/I7mngg5hnEgo=;
        b=GGBcpZVkiWKFN5fM72KKRyiuYf8WRZkcT2uvZU5D2tk5KBxZfN7Y+TCUmOsDyGWu1Z5pWa
        XtKIoXiSGONVJsBJEkkgkRZVfZhiTSMUIP8sjS95W7+494XdlYYQINqfEZFDVHOfxsIvTL
        JHzLgL2GaplbGMmnCKaZkFwHJfvAcYk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-32-zq82DM8yM_eR4JAUW-d8GA-1; Wed, 19 May 2021 21:24:38 -0400
X-MC-Unique: zq82DM8yM_eR4JAUW-d8GA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 196AD80ED8B;
        Thu, 20 May 2021 01:24:37 +0000 (UTC)
Received: from T590 (ovpn-12-84.pek2.redhat.com [10.72.12.84])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id CEBBC687D8;
        Thu, 20 May 2021 01:24:30 +0000 (UTC)
Date:   Thu, 20 May 2021 09:24:25 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: core: Cap shost cmd_per_lun at can_queue
Message-ID: <YKW6SRdRPRbi4NAT@T590>
References: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1621434662-173079-1-git-send-email-john.garry@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, May 19, 2021 at 10:31:02PM +0800, John Garry wrote:
> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> exceed Shost.can_queue.
> 
> The sdev initial value comes from shost cmd_per_lun.
> 
> However, the LLDD may still set cmd_per_lun > can_queue, which leads to an
> initial sdev queue depth greater than can_queue.
> 
> Such an issue was reported in [0], which caused a hang. That has since
> been fixed in commit fc09acb7de31 ("scsi: scsi_debug: Fix cmd_per_lun,
> set to max_queue").
> 
> Stop this possibly happening for other drivers by capping
> shost.cmd_per_lun at shost.can_queue.
> 
> [0] https://lore.kernel.org/linux-scsi/YHaez6iN2HHYxYOh@T590/
> 
> Signed-off-by: John Garry <john.garry@huawei.com>
> ---
> Earlier patch was in https://lore.kernel.org/linux-scsi/1618848384-204144-1-git-send-email-john.garry@huawei.com/
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index ba72bd4202a2..624e2582c3df 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -220,6 +220,9 @@ int scsi_add_host_with_dma(struct Scsi_Host *shost, struct device *dev,
>  		goto fail;
>  	}
>  
> +	shost->cmd_per_lun = min_t(short, shost->cmd_per_lun,
> +				   shost->can_queue);
> +
>  	error = scsi_init_sense_cache(shost);
>  	if (error)
>  		goto fail;
> -- 
> 2.26.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

