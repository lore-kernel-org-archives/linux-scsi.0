Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D145BC433FE
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 05:36:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B88D06115B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Sep 2021 05:36:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350805AbhIIFhi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Sep 2021 01:37:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350802AbhIIFhh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 9 Sep 2021 01:37:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24E3E6113E;
        Thu,  9 Sep 2021 05:36:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631165789;
        bh=++NHiiWo2jB3aeTKob1mBUql4iblQbvqYo4A2gIlx6c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gJLnYWPa4J7nWrVp909KOZwdd6uf9VSaKr5YMg3II62inKpgBr2nfcJ8LxLPUo+kr
         Vb1x54wQS+iwV7wqk62Ob8bmpnSy7D+3E4lmRnp1rk4b0eSJMDL1twakkNNXoK62Hm
         sQ+v1oR83GIqUwGa8XAEB0Wsro6OwlZoVA0Uy+ok=
Date:   Thu, 9 Sep 2021 07:36:05 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zenghui Yu <yuzenghui@huawei.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp,
        axboe@kernel.dk, martin.petersen@oracle.com, hch@lst.de,
        wanghaibin.wang@huawei.com
Subject: Re: [PATCH] scsi: bsg: Fix device unregistration
Message-ID: <YTmdRQ6BwPTWWn/Y@kroah.com>
References: <20210909034608.1435-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210909034608.1435-1-yuzenghui@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 09, 2021 at 11:46:08AM +0800, Zenghui Yu wrote:
> We use device_initialize() to take refcount for the device but forget to
> put_device() on device teardown, which ends up leaking private data of the
> driver core, dev_name(), etc. This is reported by kmemleak at boot time if
> we compile kernel with DEBUG_TEST_DRIVER_REMOVE.
> 
> Note that adding the missing put_device() is _not_ sufficient to fix device
> unregistration. As we don't provide the .release() method for device, which
> turned out to be typically wrong and will be complained loudly by the
> driver core.
> 
> Fix both of them.
> 
> Fixes: ead09dd3aed5 ("scsi: bsg: Simplify device registration")
> Signed-off-by: Zenghui Yu <yuzenghui@huawei.com>
> ---
>  block/bsg.c | 13 +++++++++++--
>  1 file changed, 11 insertions(+), 2 deletions(-)

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
