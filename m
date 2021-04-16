Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0046C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 01:46:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B46BB61158
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 01:46:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237904AbhDPBqp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 21:46:45 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:39968 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236309AbhDPBqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 21:46:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618537580;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=QTpEFrU/Gi+vOr9/s7xPCWwg8kaRHW6Y1Zitd7JViC0=;
        b=IpsvIv9NYiFgnQMlrtxGaRlj4+iLGH1GF7Xohuuy+bYWDXl/885M4J5viwGEcYv9AtDzmv
        4zQgprlZMvXr9MhhkPELHPQWRI02Ebwb+VyRonoW7zAeXMkC8pgCwwTfmMxVJWnpx3L+M1
        /rp8+GeuehCVbllyaOILxtNXMnisZ2s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-446-fV9uY0KuOTm-JbnVC2l_Tg-1; Thu, 15 Apr 2021 21:46:16 -0400
X-MC-Unique: fV9uY0KuOTm-JbnVC2l_Tg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6570B18397A5;
        Fri, 16 Apr 2021 01:46:15 +0000 (UTC)
Received: from T590 (ovpn-12-36.pek2.redhat.com [10.72.12.36])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2A7B76A032;
        Fri, 16 Apr 2021 01:46:11 +0000 (UTC)
Date:   Fri, 16 Apr 2021 09:46:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     John Garry <john.garry@huawei.com>
Cc:     Douglas Gilbert <dgilbert@interlog.com>,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, kashyap.desai@broadcom.com,
        axboe@kernel.dk
Subject: Re: [PATCH] scsi_debug: fix cmd_per_lun, set to max_queue
Message-ID: <YHjsXaVJJsQXwEPW@T590>
References: <20210415015031.607153-1-dgilbert@interlog.com>
 <580349dc-0152-8f39-5f3c-be9115e3bf12@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <580349dc-0152-8f39-5f3c-be9115e3bf12@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 15, 2021 at 10:15:27AM +0100, John Garry wrote:
> This looks ok.
> 
> Apart from this, I tested linux-next (without this patch) - which includes
> Ming's changes to replace sdev-->device_busy with sbitmap - and, as
> expected, it has the issue.
> 
> So I think it is also worth having this to stop this happening elsewhere:
> 
> ------>8-------
> 
> Subject: [PATCH] scsi: core: Cap initial sdev queue depth at Shost.can_queue
> 
> Function sdev_store_queue_depth() enforces that the sdev queue depth cannot
> exceed Shost.can_queue.
> 
> However, the LLDD may still set cmd_per_lun > can_queue, which would lead to
> an initial sdev queue depth greater than can_queue.
> 
> Stop this happened by capping initial sdev queue depth at can_queue.
> 
> <insert credits>
> Signed-off-by: John Garry <john.garry@huawei.com>
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index 9af50e6f94c4..fec6c17ff37c 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -218,6 +218,7 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>  	struct scsi_device *sdev;
>  	int display_failure_msg = 1, ret;
>  	struct Scsi_Host *shost = dev_to_shost(starget->dev.parent);
> +	int depth;
> 
>  	sdev = kzalloc(sizeof(*sdev) + shost->transportt->device_size,
>  		       GFP_KERNEL);
> @@ -276,8 +277,13 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>  	WARN_ON_ONCE(!blk_get_queue(sdev->request_queue));
>  	sdev->request_queue->queuedata = sdev;
> 
> -	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
> -					sdev->host->cmd_per_lun : 1);
> +	if (sdev->host->cmd_per_lun)
> +		depth = min_t(int, sdev->host->cmd_per_lun,
> +			      sdev->host->can_queue);
> +	else
> +		depth = 1;
> +
> +	scsi_change_queue_depth(sdev, depth);

'cmd_per_lun' should have been set as correct from the beginning instead
of capping it for changing queue depth:

diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
index 697c09ef259b..0d9954eabbb8 100644
--- a/drivers/scsi/hosts.c
+++ b/drivers/scsi/hosts.c
@@ -414,7 +414,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
 	shost->can_queue = sht->can_queue;
 	shost->sg_tablesize = sht->sg_tablesize;
 	shost->sg_prot_tablesize = sht->sg_prot_tablesize;
-	shost->cmd_per_lun = sht->cmd_per_lun;
+	shost->cmd_per_lun = min_t(int, sht->cmd_per_lun, shost->can_queue);
 	shost->no_write_same = sht->no_write_same;
 	shost->host_tagset = sht->host_tagset;
 

Thanks,
Ming

