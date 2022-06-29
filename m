Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEA34C43334
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jun 2022 01:22:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiF2BWM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 21:22:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbiF2BWL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 21:22:11 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id AD09530F50
        for <linux-scsi@vger.kernel.org>; Tue, 28 Jun 2022 18:22:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656465729;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=5n4VbPGYL0IVOHlHnT2VRLu5F8GGV+cKi991jjpyi/U=;
        b=G6P0bKaMhk7pgx7jJ+uK3D7r0OG7UDMX1JbsswClALHPek1Wh6/dyDpcWN8DOszlYZGOG3
        5ZaOAEwlnLVOhOPMBEGT46mbobBFl4o1ayLzc+CSB5cP2qdSw/FP0eifQXtHYIqXRi6AGb
        Bp7pUxlr6STpMVMSbGFDGkM5W7F+e60=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-P7zLZM3FP5qHu-V-hmtgvA-1; Tue, 28 Jun 2022 21:22:06 -0400
X-MC-Unique: P7zLZM3FP5qHu-V-hmtgvA-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E5D14801233;
        Wed, 29 Jun 2022 01:22:05 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id A3B81492CA4;
        Wed, 29 Jun 2022 01:22:01 +0000 (UTC)
Date:   Wed, 29 Jun 2022 09:21:55 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 2/3] scsi: core: Retry after a delay if the device is
 becoming ready
Message-ID: <YrupM8k8uG3HIRmt@T590>
References: <20220628222131.14780-1-bvanassche@acm.org>
 <20220628222131.14780-3-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628222131.14780-3-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 2.85 on 10.11.54.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jun 28, 2022 at 03:21:30PM -0700, Bart Van Assche wrote:
> If a logical unit reports that it is becoming ready, retry the command
> after a delay instead of retrying immediately.
> 
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_error.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 49ef864df581..fb7e363c4c00 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -625,10 +625,10 @@ enum scsi_disposition scsi_check_sense(struct scsi_cmnd *scmd)
>  			return NEEDS_RETRY;
>  		/*
>  		 * if the device is in the process of becoming ready, we
> -		 * should retry.
> +		 * should retry after a delay.
>  		 */
>  		if ((sshdr.asc == 0x04) && (sshdr.ascq == 0x01))
> -			return NEEDS_RETRY;
> +			return ADD_TO_MLQUEUE;

The above code & commit log just said changing to retry after a delay, but not
explains why, care to document reason why the delay is useful?

Thanks
Ming

