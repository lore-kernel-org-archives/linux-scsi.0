Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31919C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:51:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1908361875
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Sep 2021 07:51:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348899AbhI3Hwu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Sep 2021 03:52:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:32330 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1348945AbhI3Hwn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 30 Sep 2021 03:52:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1632988261;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/0kMV5NHViQC1s+jSR/2KlMo8Q4JFLx8qT0rabuW1S0=;
        b=ee7wjggITwTkNcali4DtIdO6w00KH23skQrY5G8U6w8gsHSS+17mXSGdjSK7fAkEkMPWNI
        XTe+bO6woAWh0bJwjvSl6oiBtEj0lrm6XRapMR+jJtKo6X4kblGL79T3zv3DlEYaP/SuRd
        /+Tjc4zflLb6S61mi/nFykMX780G72s=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-587-KEqCKbmxMUaQlpF0FuNmVg-1; Thu, 30 Sep 2021 03:50:59 -0400
X-MC-Unique: KEqCKbmxMUaQlpF0FuNmVg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id BB9ACDF8A3;
        Thu, 30 Sep 2021 07:50:58 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65FDB60854;
        Thu, 30 Sep 2021 07:50:54 +0000 (UTC)
Date:   Thu, 30 Sep 2021 15:50:49 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Cc:     Changhui Zhong <czhong@redhat.com>, Yi Zhang <yi.zhang@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH V2] scsi: core: put LLD module refcnt after SCSI device
 is released
Message-ID: <YVVsWbX3Fqfq0wAS@T590>
References: <20210930074026.1011114-1-ming.lei@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210930074026.1011114-1-ming.lei@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 30, 2021 at 03:40:26PM +0800, Ming Lei wrote:
> SCSI host release is triggered when SCSI device is freed, and we have to
> make sure that LLD module won't be unloaded before SCSI host instance is
> released because shost->hostt is required in host release handler.
> 
> So put LLD module refcnt after SCSI device is released.
> 
> The real release handler can be run from wq context in case of
> in_interrupt(), so add one atomic counter for serializing putting
> module via current and wq context. This way is fine since we don't
> call scsi_device_put() in fast IO path.
> 
> Reported-by: Changhui Zhong <czhong@redhat.com>
> Reported-by: Yi Zhang <yi.zhang@redhat.com>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>  drivers/scsi/scsi.c        |  8 +++++++-
>  drivers/scsi/scsi_sysfs.c  | 10 ++++++++++
>  include/scsi/scsi_device.h |  2 ++
>  3 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
> index b241f9e3885c..b6612161587f 100644
> --- a/drivers/scsi/scsi.c
> +++ b/drivers/scsi/scsi.c
> @@ -553,8 +553,14 @@ EXPORT_SYMBOL(scsi_device_get);
>   */
>  void scsi_device_put(struct scsi_device *sdev)
>  {
> -	module_put(sdev->host->hostt->module);
> +	struct module *mod = sdev->host->hostt->module;
> +
> +	atomic_inc(&sdev->put_dev_cnt);
> +
>  	put_device(&sdev->sdev_gendev);
> +
> +	if (atomic_dec_if_positive(&sdev->put_dev_cnt) >= 0)
> +		module_put(mod);

oops, sdev can be freed now, so this approach isn't good too, :-(

Will think further about the solution.

thanks,
Ming

