Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D43E3C11F66
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:26:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0C3613C8
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Jul 2021 18:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240041AbhGNS3U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 14 Jul 2021 14:29:20 -0400
Received: from mail-oi1-f169.google.com ([209.85.167.169]:40915 "EHLO
        mail-oi1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240069AbhGNS3S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 14 Jul 2021 14:29:18 -0400
Received: by mail-oi1-f169.google.com with SMTP id l26so3314214oic.7;
        Wed, 14 Jul 2021 11:26:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=L5C7sNY8TB8NPeFGL9sYtQQ8gOiI4hebauC48DXYqLw=;
        b=qNzqeJCaD6KrKxNweCdDhWl3hVReBqg8TLQKLlDZ6Frypg4GnaicU9dj+dXpepQNfj
         CYWw4reeK2USblBevTB2fcSLkeMf0SET7cOa0QsGaz11jC1Xv5xvbAukn7QnWqAVVxWc
         zoADW4XfS0Cze1VIAGUO20YoFfp91dLPKh4uGgf4wwGIaNP0uweCfOMEmlKknX+1/6Ic
         feIAV8hoY2gVzJDDpIe4JP6a2C2geL+/0CDIYTYrYFb4mMtYgyYzH3kCAHYyL2GPy3Sr
         CiZ4FFVUcNzibZuwfNPWTlEOsy/c6gmeZk6UktiTee4/6V6aZpa0fLQBBhMEHfYWwiM/
         I5qA==
X-Gm-Message-State: AOAM5327q5nWk2JXnZ4dgjU9KZ41G0FkAIpRAqq2pdT229EnUQ60ZVaI
        cG1gf1ryEWQEf+/CMuUFlzTxBtYZqyAVfJGe2cc=
X-Google-Smtp-Source: ABdhPJytKbKxR4JGMpQiSKO3EgwP/rucDajdJBRhLTyT4fycctOoVGx8u5M8vo8so275hBs1Y9CdCgTUAOM34EMbgJQ=
X-Received: by 2002:aca:3502:: with SMTP id c2mr1867706oia.157.1626287185145;
 Wed, 14 Jul 2021 11:26:25 -0700 (PDT)
MIME-Version: 1.0
References: <20210710103819.12532-1-adrian.hunter@intel.com> <20210710103819.12532-3-adrian.hunter@intel.com>
In-Reply-To: <20210710103819.12532-3-adrian.hunter@intel.com>
From:   "Rafael J. Wysocki" <rafael@kernel.org>
Date:   Wed, 14 Jul 2021 20:26:14 +0200
Message-ID: <CAJZ5v0gCiHucpwejmHEJFgzUCPvWMXfth1JEUiAvLR=U-c9DrA@mail.gmail.com>
Subject: Re: [PATCH V3 2/3] driver core: Add ability to delete device links of
 unregistered devices
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     "Rafael J . Wysocki" <rafael@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Saravana Kannan <saravanak@google.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "open list:TARGET SUBSYSTEM" <linux-scsi@vger.kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <huobean@gmail.com>, Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Bart Van Assche <bvanassche@acm.org>,
        Linux PM <linux-pm@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Jul 10, 2021 at 12:38 PM Adrian Hunter <adrian.hunter@intel.com> wrote:
>
> Managed device links are deleted by device_del(). However it is possible to
> add a device link to a consumer before device_add(), and then discover an

I would say "discovering an error"

> error prevents the device from being used. In that case normally references
> to the device would be dropped and the device would be deleted. However the
> device link holds a reference to the device, so the device link and device
> remain indefinitely (unless the supplier is deleted).
>
> Amend device link removal to accept removal of a link with an
> unregistered consumer device.
>
> Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Fixes: b294ff3e34490 ("scsi: ufs: core: Enable power management for wlun")

This patch by itself doesn't fix the above one, so the tag doesn't
seem to be suitable here.

Frankly, I would consider folding it into the third patch in the
series in which case please feel free to add

Reviewed-by: Rafael J. Wysocki <rafael@kernel.org>

to the resulting combo patch.

> Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
> ---
>  drivers/base/core.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 2de8f7d8cf54..983e895d4ced 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -887,6 +887,8 @@ static void device_link_put_kref(struct device_link *link)
>  {
>         if (link->flags & DL_FLAG_STATELESS)
>                 kref_put(&link->kref, __device_link_del);
> +       else if (!device_is_registered(link->consumer))
> +               __device_link_del(&link->kref);
>         else
>                 WARN(1, "Unable to drop a managed device link reference\n");
>  }
> --
> 2.17.1
>
