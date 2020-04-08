Return-Path: <SRS0=Y1+o=5Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23E7DC2D0F4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 19:16:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EB4A42072F
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Apr 2020 19:16:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="X0x7cqk5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729897AbgDHTQk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Apr 2020 15:16:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:49087 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728209AbgDHTQj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2020 15:16:39 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586373399;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7CvAUIVz+j5eQxkWwgrZLmBoQHc38XJ7xtY6pC6wqtQ=;
        b=X0x7cqk51FX385/9+3AvXiWFOE7ERN3S01lxytvUnoR3+Ygc1Tm1ZeCrXLWLjMk4ZGvG/e
        RMJfOywtVmk5Qol6cnVElIbJlgYx+YoRW4ljpINN212/IXDiVqDKUuFcylYGWzvPAA42iw
        +wOUnEzZKIxWv2OsJ8x/SwV3JlT/Z44=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-125-1wkKQxUHMoaod1zr0jnyWg-1; Wed, 08 Apr 2020 15:16:30 -0400
X-MC-Unique: 1wkKQxUHMoaod1zr0jnyWg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 726931005509;
        Wed,  8 Apr 2020 19:16:29 +0000 (UTC)
Received: from ovpn-113-89.phx2.redhat.com (ovpn-113-89.phx2.redhat.com [10.3.113.89])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CDFF75D9C9;
        Wed,  8 Apr 2020 19:16:28 +0000 (UTC)
Message-ID: <120ce7f4cd1fd070e1f7c353223c21b8e4f29337.camel@redhat.com>
Subject: Re: [PATCH] scsi: core: Rate limit "rejecting I/O" messages
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Daniel Wagner <dwagner@suse.de>, linux-scsi@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Date:   Wed, 08 Apr 2020 15:16:27 -0400
In-Reply-To: <20200408171012.76890-1-dwagner@suse.de>
References: <20200408171012.76890-1-dwagner@suse.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-04-08 at 19:10 +0200, Daniel Wagner wrote:
> Prevent excessive logging by rate limiting the "rejecting I/O"
> messages. For example in setups where remote syslog is used the link
> is saturated by those messages when a storage controller/disk
> misbehaves.
> 
> Cc: "James E.J. Bottomley" <jejb@linux.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Signed-off-by: Daniel Wagner <dwagner@suse.de>
> ---
>  drivers/scsi/scsi_lib.c    |  4 ++--
>  include/scsi/scsi_device.h | 10 ++++++++++
>  2 files changed, 12 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 47835c4b4ee0..01c35c58c6f3 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1217,7 +1217,7 @@ scsi_prep_state_check(struct scsi_device *sdev,
> struct request *req)
>  		 */
>  		if (!sdev->offline_already) {
>  			sdev->offline_already = true;
> -			sdev_printk(KERN_ERR, sdev,
> +			sdev_printk_ratelimited(KERN_ERR, sdev,
>  				    "rejecting I/O to offline
> device\n");

I would really prefer we not do it this way if at all possible.
It loses information we may need to debug SAN outage problems.

The reason I didn't use ratelimit is that the ratelimit structure is
per-instance of the ratelimit call here, not per-device.  So this
doesn't work right -- it will drop messages for other devices.

>  		}
>  		return BLK_STS_IOERR;
> @@ -1226,7 +1226,7 @@ scsi_prep_state_check(struct scsi_device *sdev,
> struct request *req)
>  		 * If the device is fully deleted, we refuse to
>  		 * process any commands as well.
>  		 */
> -		sdev_printk(KERN_ERR, sdev,
> +		sdev_printk_ratelimited(KERN_ERR, sdev,
>  			    "rejecting I/O to dead device\n");

I practice I hardly see this message, do you actually have a case
where this happens?  If so perhaps add another flag similar to
offline_already?

The offline message happens a *lot*, we get a ton of them for each
active device when the queues are unblocked when a target goes away.

-Ewan

>  		return BLK_STS_IOERR;
>  	case SDEV_BLOCK:
> diff --git a/include/scsi/scsi_device.h b/include/scsi/scsi_device.h
> index c3cba2aaf934..8be40b0e1b8f 100644
> --- a/include/scsi/scsi_device.h
> +++ b/include/scsi/scsi_device.h
> @@ -257,6 +257,16 @@ sdev_prefix_printk(const char *, const struct
> scsi_device *, const char *,
>  #define sdev_printk(l, sdev, fmt, a...)				
> \
>  	sdev_prefix_printk(l, sdev, NULL, fmt, ##a)
>  
> +#define sdev_printk_ratelimited(l, sdev, fmt, a...)			
> \
> +({									
> \
> +	static DEFINE_RATELIMIT_STATE(_rs,				
> \
> +				      DEFAULT_RATELIMIT_INTERVAL,	\
> +				      DEFAULT_RATELIMIT_BURST);		
> \
> +									
> \
> +	if (__ratelimit(&_rs))						
> \
> +		sdev_prefix_printk(l, sdev, NULL, fmt, ##a);		
> \
> +})
> +
>  __printf(3, 4) void
>  scmd_printk(const char *, const struct scsi_cmnd *, const char *,
> ...);
>  

