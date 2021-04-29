Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8383AC433B4
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 14:34:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 39A9361445
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Apr 2021 14:34:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237315AbhD2OfY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 29 Apr 2021 10:35:24 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60585 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234862AbhD2OfX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Apr 2021 10:35:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619706875;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=heDsRu5oD1OaUAfnSUi3+LrKS0XIxJbkgCIieGYoAbg=;
        b=MVbjf9guktWykaAJOAzJdD0AuxzhgolIDFY2/TMr7nzD9lR06op22j39yC51wXPW/WTR4x
        XlWlqucR6AE5T24DK2USLJVFXzdsKuPfaOM7YnZYXo1+E5HwHAkwvBzy5u1TYmLKDJ9EV5
        qSfSZS5C28CQi7h5/Vnk1uwHyRFvs/M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-372-yiZCL_17PW6blJdg-itMRA-1; Thu, 29 Apr 2021 10:34:32 -0400
X-MC-Unique: yiZCL_17PW6blJdg-itMRA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8AEC310060D6;
        Thu, 29 Apr 2021 14:34:30 +0000 (UTC)
Received: from T590 (ovpn-12-74.pek2.redhat.com [10.72.12.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 784225D768;
        Thu, 29 Apr 2021 14:34:17 +0000 (UTC)
Date:   Thu, 29 Apr 2021 22:34:27 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/3] fnic: check for started requests in
 fnic_wq_copy_cleanup_handler()
Message-ID: <YIrD87Ekh3xBqE6u@T590>
References: <20210429122517.39659-1-hare@suse.de>
 <20210429122517.39659-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210429122517.39659-4-hare@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 29, 2021 at 02:25:17PM +0200, Hannes Reinecke wrote:
> fnic_wq_copy_cleanup_handler() is using scsi_host_find_tag() to
> map id to a scsi command. However, as per discussion on the mailinglist
> scsi_host_find_tag() might return a non-started request, so we need
> to check the returned command with blk_mq_request_started() to avoid
> the function tripping over a non-initialized command.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/fnic/fnic_scsi.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/fnic/fnic_scsi.c b/drivers/scsi/fnic/fnic_scsi.c
> index 762cc8bd2653..b9fd3d87416b 100644
> --- a/drivers/scsi/fnic/fnic_scsi.c
> +++ b/drivers/scsi/fnic/fnic_scsi.c
> @@ -1466,7 +1466,7 @@ void fnic_wq_copy_cleanup_handler(struct vnic_wq_copy *wq,
>  		return;
>  
>  	sc = scsi_host_find_tag(fnic->lport->host, id);
> -	if (!sc)
> +	if (!sc || !blk_mq_request_started(sc->request))
>  		return;

scsi_host_find_tag() has covered blk_mq_request_started check already, so
this patch isn't necessary.


Thanks,
Ming

