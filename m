Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2BC9C4332F
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 01:37:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D08A06108D
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Sep 2021 01:37:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237866AbhIGBim (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Sep 2021 21:38:42 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:52231 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232492AbhIGBih (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Sep 2021 21:38:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1630978651;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LD4HmvA+6ng2SFaOBQkrpmMcYGijXFYTWjOibY469rU=;
        b=ISTAn5P9n39d7GuCDuOY4asIMwFWPgLAz4ZrINnaCg1IlPBAPlUueKOLgTi+LRwwlrNAhh
        yapk5fak0VtdRpE4mM70FVHc0i2XI668Q4UpkiPXICbvbDiIO0nKucKdW7o3SKHGQfhgCX
        GHkhcKRBkUvMv+BrBAuKEr/kZ9ilnDs=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-420-jemrBUYpPzmuqg88LXk5sw-1; Mon, 06 Sep 2021 21:37:30 -0400
X-MC-Unique: jemrBUYpPzmuqg88LXk5sw-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFBFF10054F6;
        Tue,  7 Sep 2021 01:37:27 +0000 (UTC)
Received: from T590 (ovpn-8-23.pek2.redhat.com [10.72.8.23])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8619927097;
        Tue,  7 Sep 2021 01:37:04 +0000 (UTC)
Date:   Tue, 7 Sep 2021 09:37:05 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.ibm.com,
        kbusch@kernel.org, sagi@grimberg.me, adrian.hunter@intel.com,
        beanhuo@micron.com, ulf.hansson@linaro.org, avri.altman@wdc.com,
        swboyd@chromium.org, agk@redhat.com, snitzer@redhat.com,
        josef@toxicpanda.com, hch@infradead.org, hare@suse.de,
        bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-mmc@vger.kernel.org,
        dm-devel@redhat.com, nbd@other.debian.org,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v3 2/8] scsi/sr: add error handling support for add_disk()
Message-ID: <YTbCQdieHG07Bz8W@T590>
References: <20210830212538.148729-1-mcgrof@kernel.org>
 <20210830212538.148729-3-mcgrof@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210830212538.148729-3-mcgrof@kernel.org>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 30, 2021 at 02:25:32PM -0700, Luis Chamberlain wrote:
> We never checked for errors on add_disk() as this function
> returned void. Now that this is fixed, use the shiny new
> error handling.
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  drivers/scsi/sr.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
> index 2942a4ec9bdd..72fd21844367 100644
> --- a/drivers/scsi/sr.c
> +++ b/drivers/scsi/sr.c
> @@ -779,7 +779,10 @@ static int sr_probe(struct device *dev)
>  	dev_set_drvdata(dev, cd);
>  	disk->flags |= GENHD_FL_REMOVABLE;
>  	sr_revalidate_disk(cd);
> -	device_add_disk(&sdev->sdev_gendev, disk, NULL);
> +
> +	error = device_add_disk(&sdev->sdev_gendev, disk, NULL);
> +	if (error)
> +		goto fail_minor;

You don't undo register_cdrom(), maybe you can use kref_put(&cd->kref, sr_kref_release);
to simplify the error handling.


Thanks,
Ming

