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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65322C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:39:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2AB3664E74
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Feb 2021 15:39:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbhBVPj1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Feb 2021 10:39:27 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:45286 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231421AbhBVPir (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Feb 2021 10:38:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1614008237;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rKDRMIQHwWO9NaBFJtVvd9Xjn5c8Xhvq62CFQpOYfFU=;
        b=VSsHU9z7zZOuyKCuBJ6WGoOG62YpnFkLfDrO4bKiIXyCyqNntUrnjOt2P9OA5VAETIrrQ/
        HlkhJUQXFY/A0PuPjacOI+oPJuYFDnvm8Z/TH4DtlZYKHvE0uowwCqO7m07UnwQnUnXJ7M
        MesUpZNspAT6tHLHGtG+jGV+3wMGac8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-pSu-bZmePqumvNCp-r11ng-1; Mon, 22 Feb 2021 10:37:13 -0500
X-MC-Unique: pSu-bZmePqumvNCp-r11ng-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 490DF192AB7F;
        Mon, 22 Feb 2021 15:37:11 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A20BD5D9D3;
        Mon, 22 Feb 2021 15:37:09 +0000 (UTC)
Subject: Re: [PATCH 23/24] mpi3mr: add eedp dif dix support
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-24-kashyap.desai@broadcom.com>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <68cd8c00-982a-fca6-c815-816d07938655@redhat.com>
Date:   Mon, 22 Feb 2021 16:37:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-24-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  18 +-
>  drivers/scsi/mpi3mr/mpi3mr_fw.c |   7 +
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 303 +++++++++++++++++++++++++++++++-
>  3 files changed, 321 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr.h b/drivers/scsi/mpi3mr/mpi3mr.h
> index f0ead83dc16c..acc5649bed5f 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr.h
> +++ b/drivers/scsi/mpi3mr/mpi3mr.h
> @@ -118,6 +118,7 @@ extern struct list_head mrioc_list;
>  #define MPI3MR_SENSEBUF_SZ	256
>  #define MPI3MR_SENSEBUF_FACTOR	3
>  #define MPI3MR_CHAINBUF_FACTOR	3
> +#define MPI3MR_CHAINBUFDIX_FACTOR	2
>  
>  /* Invalid target device handle */
>  #define MPI3MR_INVALID_DEV_HANDLE	0xFFFF
> @@ -145,6 +146,15 @@ extern struct list_head mrioc_list;
>  /* Default target device queue depth */
>  #define MPI3MR_DEFAULT_SDEV_QD	32
>  
> +/* Definitions for the sector size for EEDP */
> +#define MPI3_SECTOR_SIZE_512_BYTE	(512)
> +#define MPI3_SECTOR_SIZE_520_BYTE	(520)
> +#define MPI3_SECTOR_SIZE_4080_BYTE	(4080)
> +#define MPI3_SECTOR_SIZE_4088_BYTE	(4088)
> +#define MPI3_SECTOR_SIZE_4096_BYTE	(4096)
> +#define MPI3_SECTOR_SIZE_4104_BYTE	(4104)
> +#define MPI3_SECTOR_SIZE_4160_BYTE	(4160)
> +

This looks weird, please use the values directly instead of creating
macros.

tomash

