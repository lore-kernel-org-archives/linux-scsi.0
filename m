Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 397FAC4361B
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 18:55:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0443A23F38
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Dec 2020 18:55:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727110AbgLKRKH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Dec 2020 12:10:07 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36448 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2394888AbgLKRJ6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Dec 2020 12:09:58 -0500
Date:   Fri, 11 Dec 2020 18:09:15 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1607706556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEPcSsvC9fYuECCjhf6t+mlOYTaraVj1DDsWYpglnac=;
        b=CgZm+xezQmrEaWVNUh1EKPb1pSkUYm0XZuvU68LmW3+ZYD7ofmslf2wURxvTCwyB3P40nT
        UwIJ/gfHqkWR+8jUY37rZfjpjeZ0P3r1KIX9uNCe175UCvDjtBhRayN3sLm0hLMNii2eZ6
        /HS9oTn/vabzVW4+ZC8NYyajgtRQdzw+cwnXyrZs2aVjfCwM7w8KY/WnFCXgD1UgFz8C5g
        s+oMwXueWQaCf8f9wO6IhfeBnxbjrDvz/FEco+6uBYZE9xoi2zIGtBUxi4+4hZbx2LAQH3
        6OJrm70n49dw11Re6rO3JUnTLb6yArP+WcbaPkPJXAIA434Oy1yOEGcBeX5OjA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1607706556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XEPcSsvC9fYuECCjhf6t+mlOYTaraVj1DDsWYpglnac=;
        b=1fA13v3OmFQtgMHvHfuWAlGfbNIrYVn6jyzl/W1gc8TWOrNdsmzk7sXcRp7O2yCfjO2lTa
        GskvFAEX8fhLcCBw==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] sr: Remove in_interrupt() usage in sr_init_command().
Message-ID: <20201211170915.4bs2huyptnsmlwvf@linutronix.de>
References: <20201204164803.ovwurzs3257em2rp@linutronix.de>
 <20201204164850.2343359-1-bigeasy@linutronix.de>
 <20201204164850.2343359-3-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20201204164850.2343359-3-bigeasy@linutronix.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-12-04 17:48:50 [+0100], To linux-scsi@vger.kernel.org wrote:
> The in_interrupt() check in sr_init_command() is a leftover from the
> past, pre v2.3.16 era to be exact. Back then the ioctl() was served by
> `sr' itself and sector size changes by CDROMREADMODE2 (as noted in the
> comment) were accounted within sr's data structures which allowed a
> "lazy" reset so it could be skipped on the next request and reset back
> to the default value once the device node was closed or before a command
> from the blockqueue was issued.
> 
> This does not work like that anymore. The CDROMREADMODE2 is served by
> cdrom's mmc_ioctl() function which may change the sector size but the
> `sr' driver does not learn about it and so its ->sector_size is not
> updated.
> The ioctl() resets the changed sector size back to 2048.
> sr_read_sector() also resets the sector size back to the default once it
> is done.
> 
> Remove the conditional sector size update from sr_init_command() and
> sr_release() because it is not needed.
> 
> Link: https://lkml.kernel.org/r/20201204164803.ovwurzs3257em2rp@linutronix.de
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Any chance to get this reviewed/merged?

Sebastian
