Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C3B3C433ED
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 06:10:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13E3A61424
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Apr 2021 06:10:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbhD3GLM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Apr 2021 02:11:12 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:43574 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229508AbhD3GLL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Apr 2021 02:11:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619763023;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+MeMwkE7faAYt7QfkoF+64IJYL1JYmvBd4FMvXc0p6Q=;
        b=aV+QP22a/v7w8PWI+WzAuIqqnL7fKcp81LA7FvltrqJiizvoRPJGjP9V6P8H1AGecNvR4L
        yNO4xaTHAsGYllPfeE8+06oFDZVPLwp2nRO79CEfIAts0I0li8Ujv/jZu1VYBs4ez0g/Eh
        lcuYPwByByhf8Hg48Now/u/6LPqYIzA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-mwubSvcqO52dpIoojDeaEw-1; Fri, 30 Apr 2021 02:10:21 -0400
X-MC-Unique: mwubSvcqO52dpIoojDeaEw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 27D9D8042C7;
        Fri, 30 Apr 2021 06:10:20 +0000 (UTC)
Received: from T590 (ovpn-12-77.pek2.redhat.com [10.72.12.77])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 95D971037E85;
        Fri, 30 Apr 2021 06:10:10 +0000 (UTC)
Date:   Fri, 30 Apr 2021 14:10:21 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 1/3] fnic: kill 'exclude_id' argument to fnic_cleanup_io()
Message-ID: <YIufTZGQiic01M71@T590>
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429122517.39659-2-hare@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 29, 2021 at 02:25:15PM +0200, Hannes Reinecke wrote:
> 'exclude_id' is always SCSI_NO_TAG, which will never be reached
> when traversing the list of tags.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 9 +++------
>  1 file changed, 3 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index e619a82f921b..f41d1b1c2e39 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -102,7 +102,7 @@ static const char *fnic_fcpio_status_to_str(unsigned int status)
>  	return fcpio_status_str[status];
>  }
>  
> -static void fnic_cleanup_io(struct fnic *fnic, int exclude_id);
> +static void fnic_cleanup_io(struct fnic *fnic);
>  
>  static inline spinlock_t *fnic_io_lock_hash(struct fnic *fnic,
>  					    struct scsi_cmnd *sc)
> @@ -638,7 +638,7 @@ static int fnic_fcpio_fw_reset_cmpl_handler(struct fnic *fnic,
>  	atomic64_inc(&reset_stats->fw_reset_completions);
>  
>  	/* Clean up all outstanding io requests */
> -	fnic_cleanup_io(fnic, SCSI_NO_TAG);
> +	fnic_cleanup_io(fnic);
>  
>  	atomic64_set(&fnic->fnic_stats.fw_stats.active_fw_reqs, 0);
>  	atomic64_set(&fnic->fnic_stats.io_stats.active_ios, 0);
> @@ -1361,7 +1361,7 @@ int fnic_wq_copy_cmpl_handler(struct fnic *fnic, int copy_work_to_do)
>  	return wq_work_done;
>  }
>  
> -static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
> +static void fnic_cleanup_io(struct fnic *fnic)
>  {
>  	int i;
>  	struct fnic_io_req *io_req;
> @@ -1372,9 +1372,6 @@ static void fnic_cleanup_io(struct fnic *fnic, int exclude_id)
>  	struct fnic_stats *fnic_stats = &fnic->fnic_stats;
>  
>  	for (i = 0; i < fnic->fnic_max_tag_id; i++) {
> -		if (i == exclude_id)
> -			continue;
> -
>  		io_lock = fnic_io_lock_tag(fnic, i);
>  		spin_lock_irqsave(io_lock, flags);
>  		sc = scsi_host_find_tag(fnic->lport->host, i);
> -- 
> 2.29.2
> 

Reviewed-by: Ming Lei <ming.lei@redhat.com>

-- 
Ming

