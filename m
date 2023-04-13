Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E055FC77B6C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Apr 2023 01:10:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjDMBKv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Apr 2023 21:10:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjDMBKu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Apr 2023 21:10:50 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86CCB618F
        for <linux-scsi@vger.kernel.org>; Wed, 12 Apr 2023 18:10:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681348208;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UZnIo/2wtKCT4QRhyJ06wuXlq8goYTWT4FUfY/znZ5o=;
        b=KQ9FYNApgsm6CQSAZJP8iHf3TFO7irNPukRthXR7ztB08RB7rkKj5gCQfHkQuinl2dH+jM
        rqgbIsXysa23mV9vF99pB5RBr3mBo0cTMiJXTThH/U2s3MepahYhRjeVXmROnky/WjXJ3D
        vey4+jE5Hbm6FIjlymo33YNhU+ceMio=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-632-ASgBHwpLNYKHNKe4yekrfg-1; Wed, 12 Apr 2023 21:10:04 -0400
X-MC-Unique: ASgBHwpLNYKHNKe4yekrfg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D1CAD886063;
        Thu, 13 Apr 2023 01:10:03 +0000 (UTC)
Received: from ovpn-8-18.pek2.redhat.com (ovpn-8-18.pek2.redhat.com [10.72.8.18])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id C9EDF1121320;
        Thu, 13 Apr 2023 01:09:56 +0000 (UTC)
Date:   Thu, 13 Apr 2023 09:09:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>, ming.lei@redhat.com
Subject: Re: [PATCH 1/3] scsi: sd: Let sd_shutdown() fail future I/O
Message-ID: <ZDdWXeV/DQjmhlnc@ovpn-8-18.pek2.redhat.com>
References: <20230412204125.3222615-1-bvanassche@acm.org>
 <20230412204125.3222615-2-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230412204125.3222615-2-bvanassche@acm.org>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Apr 12, 2023 at 01:41:23PM -0700, Bart Van Assche wrote:
> System shutdown happens as follows (see e.g. the systemd source file
> src/shutdown/shutdown.c):
> * sync() is called.
> * reboot(RB_AUTOBOOT/RB_HALT_SYSTEM/RB_POWER_OFF) is called.
> * If the reboot() system call returns, log an error message.
> 
> The reboot() system call causes the kernel to call kernel_restart(),
> kernel_halt() or kernel_power_off(). Each of these functions calls
> device_shutdown(). device_shutdown() calls sd_shutdown().
> 
> After sd_shutdown() has been called the .shutdown() callback of the LLD
> will be called. This makes it unsafe to submit I/O after sd_shutdown()
> has finished.

unsafe often means a bug, can you explain it in details about the 'unsafe'?

> Let sd_shutdown() fail future I/O such that LLD .shutdown()
> callbacks can be simplified.
> 
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Mike Christie <michael.christie@oracle.com>
> Cc: Tomas Henzl <thenzl@redhat.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/sd.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 4bb87043e6db..629f5889caf2 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3699,12 +3699,13 @@ static int sd_start_stop_device(struct scsi_disk *sdkp, int start)
>  static void sd_shutdown(struct device *dev)
>  {
>  	struct scsi_disk *sdkp = dev_get_drvdata(dev);
> +	struct request_queue *q;
>  
>  	if (!sdkp)
>  		return;         /* this can happen */
>  
>  	if (pm_runtime_suspended(dev))
> -		return;
> +		goto fail_future_io;
>  
>  	if (sdkp->WCE && sdkp->media_present) {
>  		sd_printk(KERN_NOTICE, sdkp, "Synchronizing SCSI cache\n");
> @@ -3715,6 +3716,12 @@ static void sd_shutdown(struct device *dev)
>  		sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
>  		sd_start_stop_device(sdkp, 0);
>  	}
> +
> +fail_future_io:
> +	q = sdkp->disk->queue;
> +	blk_queue_flag_set(QUEUE_FLAG_DYING, q);
> +	blk_mq_freeze_queue(q);
> +	blk_mq_unfreeze_queue(q);

freeze queue can slow down reboot a lot especially when there are lots of
LUNs/Hosts because each device ->shutdown() is serialized.

I think it can be done by changing sdev state to SDEV_OFFLINE here.


Thanks,
Ming

