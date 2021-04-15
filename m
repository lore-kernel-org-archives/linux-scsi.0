Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA1E8C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:57:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8CF2D61153
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 11:57:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231531AbhDOL5i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 07:57:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:45168 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhDOL5i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 07:57:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618487835;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QJoQ7CfakCpNbcH/5U0SIlwSqYUUX7Ewj27+InQBbW4=;
        b=APsFn8Z+DszR6/q1rEnQ+F9lQsiG/lCjH1xb91/msbNYmNe8CF301P1l6vAP3wM9hpgjsG
        pfZx5ms/1z277L7Ianet6bSQ6Ndcf406zBC9oEiIT8ZJID5r4SpVdsAskJRMJujQmz3ZtJ
        kCQGknWfTHqlCqo1mvZReWeBAt1ut8E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-449-_9lG8x1GMR-PsFopPVD6Fw-1; Thu, 15 Apr 2021 07:57:11 -0400
X-MC-Unique: _9lG8x1GMR-PsFopPVD6Fw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57084C7409;
        Thu, 15 Apr 2021 11:56:58 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A116C19D9F;
        Thu, 15 Apr 2021 11:56:57 +0000 (UTC)
Subject: Re: [PATCH v2 12/24] mpi3mr: add bios_param shost template hook
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-13-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <5b6e21ae-8fad-ba96-2ff8-5d5430eaff3b@redhat.com>
Date:   Thu, 15 Apr 2021 13:56:56 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-13-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 40 +++++++++++++++++++++++++++++++++
>  1 file changed, 40 insertions(+)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index dd9452de76f8..25539380968d 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2075,6 +2075,45 @@ static int mpi3mr_build_sg_scmd(struct mpi3mr_ioc *mrioc,
>  	return ret;
>  }
>  
> +/**
> + * mpi3mr_bios_param - BIOS param callback
> + * @sdev: SCSI device reference
> + * @bdev: Block device reference
> + * @capacity: Capacity in logical sectors
> + * @params: Parameter array
> + *
> + * Just the parameters with heads/secots/cylinders.
> + *
> + * Return: 0 always
> + */
> +static int mpi3mr_bios_param(struct scsi_device *sdev,
> +	struct block_device *bdev, sector_t capacity, int params[])
> +{
> +	int heads;
> +	int sectors;
> +	sector_t cylinders;
> +	ulong dummy;
> +
> +	heads = 64;
> +	sectors = 32;
> +
> +	dummy = heads * sectors;
> +	cylinders = capacity;
> +	sector_div(cylinders, dummy);
> +
> +	if ((ulong)capacity >= 0x200000) {
> +		heads = 255;
> +		sectors = 63;
> +		dummy = heads * sectors;
> +		cylinders = capacity;
> +		sector_div(cylinders, dummy);
> +	}
> +
> +	params[0] = heads;
> +	params[1] = sectors;
> +	params[2] = cylinders;
> +	return 0;
> +}
>  
>  /**
>   * mpi3mr_map_queues - Map queues callback handler
> @@ -2508,6 +2547,7 @@ static struct scsi_host_template mpi3mr_driver_template = {
>  	.slave_destroy			= mpi3mr_slave_destroy,
>  	.scan_finished			= mpi3mr_scan_finished,
>  	.scan_start			= mpi3mr_scan_start,
> +	.bios_param			= mpi3mr_bios_param,
>  	.map_queues			= mpi3mr_map_queues,
>  	.no_write_same			= 1,
>  	.can_queue			= 1,
> 

Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

