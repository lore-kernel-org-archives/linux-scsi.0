Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A66AEC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 31 Mar 2022 09:13:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233696AbiCaJPg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 31 Mar 2022 05:15:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233672AbiCaJPX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Mar 2022 05:15:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04FEB4A;
        Thu, 31 Mar 2022 02:13:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=WV4zzGwlX5tfhXTvGhAbB3PhzrHBBTp7BcxlK6NdwK8=; b=P/bxrCTI4drj48NjuxThG29VxH
        ebHq/Gm9DUghweh+goB7YczQXWSsi1Gz6QnHhDS97L5Q+7HYS0yHR4EqQ+nYgReUmcnPOowqeZQmO
        iqM+qrBpYMI7pSXI1iGiGYJ05m5h7AlHaU9thnZ3QykVYYQrri+ON9biDdtmdsnvieN0+n3SXbauk
        zsnNQFx7DqNw+VCwny2yYxz6IhQihDCKXvTvCg3nrJ9BjrdNf0BKkJfrZHwrsqnTjVmiVOqVkZTxh
        0PNhWQYqVtg3UYqSjzK/Lge+PRWnq+2fj9CKvesuu28DFvt3ni3Iu9+eRGbFxmsjY9E0/EUR8+3XD
        OU6cOWUA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nZqrv-001R3U-17; Thu, 31 Mar 2022 09:13:27 +0000
Date:   Thu, 31 Mar 2022 02:13:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     "Fabio M. De Francesco" <fmdefrancesco@gmail.com>
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        Wenchao Hao <haowenchao@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com,
        syzbot+f08c77040fa163a75a46@syzkaller.appspotmail.com,
        syzkaller-bugs@googlegroups.com, linfeilong@huawei.com
Subject: Re: [PATCH] scsi: sd: call device_del() if device_add_disk() fails
Message-ID: <YkVwt4s+K0haRpbr@infradead.org>
References: <20220329154948.10350-1-fmdefrancesco@gmail.com>
 <20220331054156.GI3293@kadam>
 <YkU/6KB+0fPU5Hie@infradead.org>
 <10056508.nUPlyArG6x@leap>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10056508.nUPlyArG6x@leap>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 31, 2022 at 11:07:45AM +0200, Fabio M. De Francesco wrote:
> If I don't misunderstand what you wrote, I think you mean something like
> the following changes:
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index a390679cf458..7a000a9a9dbe 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3431,7 +3431,7 @@ static int sd_probe(struct device *dev)
>         sdkp->disk_dev.class = &sd_disk_class;
>         dev_set_name(&sdkp->disk_dev, "%s", dev_name(dev));
>  
> -       error = device_add(&sdkp->disk_dev);
> +       error = device_register(&sdkp->disk_dev);

The device_initialize call about also need to go.

>         if (error) {
>                 put_device(&sdkp->disk_dev);

.. and this put_device

>                 goto out;
> @@ -3474,7 +3474,7 @@ static int sd_probe(struct device *dev)
>  
>         error = device_add_disk(dev, gd, NULL);
>         if (error) {
> -               put_device(&sdkp->disk_dev);
> +               device_unregister(&sdkp->disk_dev);
>                 goto out;
>         }

.. and then the cleanup patch would need the same logic.  But thinking
about it I don't think we actually can do that due to the split
unregistration.  So I take my suggestion back.
