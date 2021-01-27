Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81C66C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:20:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 44D7E207FC
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 15:20:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343796AbhA0PUs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 10:20:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:60320 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343804AbhA0PUT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 27 Jan 2021 10:20:19 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 15E77207DE;
        Wed, 27 Jan 2021 15:19:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611760777;
        bh=RA9rQ2xvdGOXteA6WC38jMW+W5EiTIher3eJGUoXFGo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eww1VXmficGkOu+NTZPjeWxDouV9+uM9TJD/LHYCXyDE6v2YkA9cle4ruggIWAI7A
         Gr2i0PfLPm3ISme1vpjnkoCLqKMq8O0ri5dHz2mHwrorHiMufGMU0V2fw6wgteYfX9
         +R9O+mo8wNUSBWhuq0UPx8SDQeAmrhnaPnxc9+/o=
Date:   Wed, 27 Jan 2021 16:19:35 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Avri Altman <avri.altman@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bart Van Assche <bvanassche@acm.org>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>,
        alim.akhtar@samsung.com, asutoshd@codeaurora.org,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <avi.shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>, cang@codeaurora.org,
        stanley.chu@mediatek.com
Subject: Re: [PATCH 1/8] scsi: ufshpb: Cache HPB Control mode on init
Message-ID: <YBGEh4cfPldXoQxI@kroah.com>
References: <20210127151217.24760-1-avri.altman@wdc.com>
 <20210127151217.24760-2-avri.altman@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210127151217.24760-2-avri.altman@wdc.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jan 27, 2021 at 05:12:10PM +0200, Avri Altman wrote:
> We will use it later, when we'll need to differentiate between device
> and host control modes.
> 
> Signed-off-by: Avri Altman <avri.altman@wdc.com>
> ---
>  drivers/scsi/ufs/ufshpb.c | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/ufs/ufshpb.c b/drivers/scsi/ufs/ufshpb.c
> index d3e6c5b32328..183bdf35f2d0 100644
> --- a/drivers/scsi/ufs/ufshpb.c
> +++ b/drivers/scsi/ufs/ufshpb.c
> @@ -26,6 +26,8 @@ static int tot_active_srgn_pages;
>  
>  static struct workqueue_struct *ufshpb_wq;
>  
> +static enum UFSHPB_MODE ufshpb_mode;

How are you allowed to have a single variable for a device-specific
thing?  What happens when you have two controllers or disks or whatever
you are binding to here?  How does this work at all?

This should be per-device, right?

thanks,

greg k-h
