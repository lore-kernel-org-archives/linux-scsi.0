Return-Path: <SRS0=DEWY=5Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 21C7AC2BB55
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 17:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id ED90420678
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Apr 2020 17:07:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="W4cuyUmn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728035AbgDIRHM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Apr 2020 13:07:12 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52112 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728028AbgDIRHM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2020 13:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586452031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f8hRg5EYNwvd8gy24wDwcLfYiAk7Uf7td7X5fprQc0g=;
        b=W4cuyUmnrHIGL3v2T9+u7YjyI2N0E7dDj9UAjfXkAVupOKjOvhzjxP78BVzp35bEnwjo2X
        atER6l5c+XRCh+qriqYFdtYK3kMByKXZksy1BclT4GtTNizEE8MsGF92bTQhBj4wAEaorY
        vb4FNbRvJ3ghFis2lcBTZ1G2g6lDp8s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-226-wbcQ8QmgNVGmmCDUvSS3tA-1; Thu, 09 Apr 2020 13:07:08 -0400
X-MC-Unique: wbcQ8QmgNVGmmCDUvSS3tA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D58F18AB2CF;
        Thu,  9 Apr 2020 17:07:07 +0000 (UTC)
Received: from ovpn-113-89.phx2.redhat.com (ovpn-113-89.phx2.redhat.com [10.3.113.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 626165D9CA;
        Thu,  9 Apr 2020 17:07:06 +0000 (UTC)
Message-ID: <1b1be267b80404dc8ca5a14b3e26710c53f50fb4.camel@redhat.com>
Subject: Re: [PATCH] scsi: core: Rate limit "rejecting I/O" messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Joe Perches <joe@perches.com>, Daniel Wagner <dwagner@suse.de>,
        linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Thu, 09 Apr 2020 13:07:05 -0400
In-Reply-To: <2de69a35463317f5eca2ce665b0ee8b90b8c717b.camel@perches.com>
References: <20200408171012.76890-1-dwagner@suse.de>
         <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
         <2de69a35463317f5eca2ce665b0ee8b90b8c717b.camel@perches.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-04-08 at 12:49 -0700, Joe Perches wrote:
> 
> Could add a ratelimit_state to struct scsi_device.
> 
> Something like:
> ---
>  drivers/scsi/scsi_scan.c   | 2 ++
>  include/scsi/scsi_device.h | 2 ++
>  2 files changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> index f2437a..938c83f 100644
> --- a/drivers/scsi/scsi_scan.c
> +++ b/drivers/scsi/scsi_scan.c
> @@ -279,6 +279,8 @@ static struct scsi_device *scsi_alloc_sdev(struct
> scsi_target *starget,
>  	scsi_change_queue_depth(sdev, sdev->host->cmd_per_lun ?
>  					sdev->host->cmd_per_lun : 1);
>  
> +	ratelimit_state_init(&sdev->rs, DEFAULT_RATELIMIT_INTERVAL,
> +			     DEFAULT_RATELIMIT_BURST);
>  	scsi_sysfs_device_initialize(sdev);
>  
>  	if (shost->hostt->slave_alloc) {
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c3cba2..2600de7 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -8,6 +8,7 @@
>  #include <linux/blkdev.h>
>  #include <scsi/scsi.h>
>  #include <linux/atomic.h>
> +#include <linux/ratelimit.h>
>  
>  struct device;
>  struct request_queue;
> @@ -233,6 +234,7 @@ struct scsi_device {
>  	struct mutex		state_mutex;
>  	enum scsi_device_state sdev_state;
>  	struct task_struct	*quiesced_by;
> +	struct ratelimit_state	rs;
>  	unsigned long		sdev_data[];
>  } __attribute__((aligned(sizeof(unsigned long))));
>  

We could but in our experience this may not work well enough.  We do
wants to see the message when the device goes offline, so we can look
at logs from SAN failures to see when that happened, but logging more
than one message per device is worthless.  And there can be *LOTS*
of LUNs behind targets that go away.  Hundreds.  Thousands, even.

I keep getting crash dumps with nothing useful in the dmesg buffer.
And we see a lot of serial console lockups.

-Ewan

