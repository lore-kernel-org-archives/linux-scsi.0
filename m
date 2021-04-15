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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 293A7C433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:19:11 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DFE8861222
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Apr 2021 12:19:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232716AbhDOMTc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 08:19:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:42502 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230202AbhDOMTc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 15 Apr 2021 08:19:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1618489149;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=msL/27Cq/Mxz/erFTua/ChctcACbjdqbgpw34HcijJ4=;
        b=OBZ0AxVAgBAvjI8GYOEmR2s54CVWzFNDBl2uU8Jnsem++SYOCBdJKp3y5R2kBnT5llnI6M
        9+k60u4XOOB7s3lJ7rKj2QW7UZs43u1z3WaEBMJbrZETCvy1P2fJ9AJ2DaIK4GcJnGTVdS
        WvZmcvG6BH7E9wB+AG7Ryz4B1URLtjY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-271-JpNs0ACUN_efEKxVu5Gh2A-1; Thu, 15 Apr 2021 08:19:06 -0400
X-MC-Unique: JpNs0ACUN_efEKxVu5Gh2A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A1FE6107ACC7;
        Thu, 15 Apr 2021 12:19:05 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.193.5])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EFF576267F;
        Thu, 15 Apr 2021 12:19:04 +0000 (UTC)
Subject: Re: [PATCH v2 15/24] mpi3mr: allow certain commands during pci-remove
 hook
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     sathya.prakash@broadcom.com
References: <20210407020451.924822-1-kashyap.desai@broadcom.com>
 <20210407020451.924822-16-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <e868770d-89dc-5797-5991-1365266bd648@redhat.com>
Date:   Thu, 15 Apr 2021 14:19:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210407020451.924822-16-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/21 4:04 AM, Kashyap Desai wrote:
> This patch allows SSU and Sync Cache commands to be sent to the controller
> instead of driver returning DID_NO_CONNECT during driver unload to flush
> any cached data from the drive.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 24 +++++++++++++++++++++++-
>  1 file changed, 23 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_os.c b/drivers/scsi/mpi3mr/mpi3mr_os.c
> index a521e59efd28..558be8c75a88 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_os.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_os.c
> @@ -2862,6 +2862,27 @@ static int mpi3mr_target_alloc(struct scsi_target *starget)
>  	return retval;
>  }
>  
> +
> +/**
> + * mpi3mr_allow_scmd_to_fw - Command is allowed during shutdown
> + * @scmd: SCSI Command reference
> + *
> + * Checks whether a CDB is allowed during shutdown or not.
> + *
> + * Return: TRUE for allowed commands, FALSE otherwise.
> + */
> +
> +inline bool mpi3mr_allow_scmd_to_fw(struct scsi_cmnd *scmd)
> +{
> +	switch (scmd->cmnd[0]) {
> +	case SYNCHRONIZE_CACHE:
> +	case START_STOP:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  /**
>   * mpi3mr_qcmd - I/O request despatcher
>   * @shost: SCSI Host reference
> @@ -2897,7 +2918,8 @@ static int mpi3mr_qcmd(struct Scsi_Host *shost,
>  		goto out;
>  	}
>  
> -	if (mrioc->stop_drv_processing) {
> +	if (mrioc->stop_drv_processing &&
> +	    !(mpi3mr_allow_scmd_to_fw(scmd))) {
>  		scmd->result = DID_NO_CONNECT << 16;
>  		scmd->scsi_done(scmd);
>  		goto out;
> 
Looks good

Reviewed-by: Tomas Henzl <thenzl@redhat.com>

