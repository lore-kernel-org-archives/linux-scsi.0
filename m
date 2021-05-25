Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74616C2B9F8
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:37:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57490613BC
	for <linux-scsi@archiver.kernel.org>; Tue, 25 May 2021 08:37:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231785AbhEYIib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 May 2021 04:38:31 -0400
Received: from mx2.suse.de ([195.135.220.15]:51548 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231590AbhEYIia (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 May 2021 04:38:30 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1621931820; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+q8b2wJkzRfZVRMU8e2Eqh7aoa9TLeEc7HFvdD7V9g=;
        b=IYQftUnajQhjlz9MpZHzFC6fpCDYhuDykvuk3aW377A2oDYPa6iM0Yig1FkrXanl8vyLur
        c6Qpe+NvYM5vyn8ScxOlAXZsQfka0/3GUTuEv2+MXJTIKU5UYLnfvELdJGDWUAYTNUFRQQ
        xGuh+WfQEb4Sk03hc4+FFiSr3iXkPcc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1621931820;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z+q8b2wJkzRfZVRMU8e2Eqh7aoa9TLeEc7HFvdD7V9g=;
        b=xrpllPzdXKZEfzTv74E1aSpfVJUdGH50v6JxGSqqAvTfpYiWeBVsUNt/L6l55+6FB1LqBq
        5fbokxhq0w5TucAA==
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0E5B0AE92;
        Tue, 25 May 2021 08:37:00 +0000 (UTC)
Subject: Re: [PATCH v19 45/45] sg: bump version to 4.0.12
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com
References: <20210524010147.94845-1-dgilbert@interlog.com>
 <20210524010147.94845-46-dgilbert@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <01a1bc9a-132a-9b65-2cc4-28370af2e559@suse.de>
Date:   Tue, 25 May 2021 10:36:59 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210524010147.94845-46-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/24/21 3:01 AM, Douglas Gilbert wrote:
> Now that the sg version 4 interface is supported:
>    - with ioctl(SG_IO) for synchronous/blocking use
>    - with ioctl(SG_IOSUBMIT) and ioctl(SG_IORECEIVE) for
>      async/non-blocking use
> Plus new ioctl(SG_IOSUBMIT_V3) and ioctl(SG_IORECEIVE_V3)
> potentially replace write() and read() for the sg
> version 3 interface. Bump major driver version number
> from 3 to 4.
> 
> The main new feature is the removal of the fixed 16 element
> array of requests per file descriptor. It is replaced by
> a xarray (eXtensible array) in their parent which is a
> sg_fd object (i.e. a file descriptor). The sg_request
> objects are not freed until the owning file descriptor is
> closed; instead these objects are re-used when multiple
> commands are sent to the same file descriptor.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>   drivers/scsi/sg.c      | 11 ++++++-----
>   include/uapi/scsi/sg.h |  4 ++--
>   2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index d47efed3a3ca..1f89d3d4cfbe 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -7,13 +7,14 @@
>    *
>    * Original driver (sg.c):
>    *        Copyright (C) 1992 Lawrence Foard
> - * Version 2 and 3 extensions to driver:
> - *        Copyright (C) 1998 - 2019 Douglas Gilbert
> + * Version 2, 3 and 4 extensions to driver:
> + *        Copyright (C) 1998 - 2021 Douglas Gilbert
> + *
>    */
>   
> -static int sg_version_num = 30901;  /* [x]xyyzz where [x] empty when x=0 */
> -#define SG_VERSION_STR "3.9.01"		/* [x]x.[y]y.zz */
> -static char *sg_version_date = "20190606";
> +static int sg_version_num = 40012;  /* [x]xyyzz where [x] empty when x=0 */
> +#define SG_VERSION_STR "4.0.12"		/* [x]x.[y]y.zz */
> +static char *sg_version_date = "20210522";
>   
>   #include <linux/module.h>
>   
> diff --git a/include/uapi/scsi/sg.h b/include/uapi/scsi/sg.h
> index 6fce44607613..079ef6c57aea 100644
> --- a/include/uapi/scsi/sg.h
> +++ b/include/uapi/scsi/sg.h
> @@ -12,9 +12,9 @@
>    *   Copyright (C) 1992 Lawrence Foard
>    *
>    * Later extensions (versions 2, 3 and 4) to driver:
> - *   Copyright (C) 1998 - 2018 Douglas Gilbert
> + *   Copyright (C) 1998 - 2021 Douglas Gilbert
>    *
> - * Version 4.0.11 (20190502)
> + * Version 4.0.12 (20210111)
>    *  This version is for Linux 4 and 5 series kernels.
>    *
>    * Documentation
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
