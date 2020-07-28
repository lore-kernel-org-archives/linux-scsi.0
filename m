Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A4428C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 10:57:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 83C98204EA
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 10:57:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gsr75AZe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728962AbgG1K5J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 06:57:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728588AbgG1K5J (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 06:57:09 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDEEBC061794;
        Tue, 28 Jul 2020 03:57:07 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b79so18135795qkg.9;
        Tue, 28 Jul 2020 03:57:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=PKpPhJ/w2GiNhEhskYD8enl5OSzPCcoSE92NGXtE9Co=;
        b=Gsr75AZeO2mW9mP9ZFCQZ5QsL36RLPgDfMjW1uX1P77lexXYNMe4Z8zLnqIN2lDZhe
         ldrfK+8GVqwp/pjVGMAovAU/tFwpKqNmWZuAdYmlRc9gmfXs+sdAf80Oui+iOeNv3aV2
         w+udDAII3pXeTGEHlcrnd4BwZ6jlR87XI1ls19VDDG0MTIKPNiue58rkusY3gPJOAgA4
         ppWY5szqIXHYTP42ed/f/g+nmfijcDSntIuxyCzyNrOGum8/Brbri6XIHqDQkxlg5pRz
         4c8SCSLj+2jT/yQvbODkaj/caP4bRVHQURHokDzSO8JhOiSwEnsto9J/33bLVbyr/Z0J
         RVoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=PKpPhJ/w2GiNhEhskYD8enl5OSzPCcoSE92NGXtE9Co=;
        b=jyHeEkvHpk/nOgHYKp7sruNVhu9kJifULfPgpWboGpk75qyKoeH13d1so60vXvzdHn
         hVlhMs287+nxMwbpZWnKP7jV4089PG8AkS9Kq9KztAeKihIEK8jH+aUf6bACyWAVQ4iD
         aBW6TVdgGjmzUqv9nzqYjU+BgwMwKv0IZLfZcTN8d/FRDZLj7NkFP+pxR4mzPuLrmzpG
         vwQvQiALML1ciAVPmduVR9q6rLmJ/2v0eEAZM99AKRcC95H+S3ykTe9AcRy5ZcVGW0li
         YMPD7mGn45tLVxVYifNAH0m67vOp0J9M2HPrJC2uivxqs51D+UkWl7cDMnn6DlPoNps8
         UJuw==
X-Gm-Message-State: AOAM531IbFb2zvH/cNHsXw8nLhOyWYBsbuDS0XHLWM5GqHMtuzK6K9bE
        7sHrWuv+Fqw0eAE648T95g==
X-Google-Smtp-Source: ABdhPJzxukcAkN7Hiz1CswGMnF8kg+I/3ierdX9iaW+x9qyCpsgkMZvkdNZSFgSwbH52ZIyJVlZjdw==
X-Received: by 2002:a05:620a:65d:: with SMTP id a29mr14815054qka.167.1595933827048;
        Tue, 28 Jul 2020 03:57:07 -0700 (PDT)
Received: from PWN (c-76-119-149-155.hsd1.ma.comcast.net. [76.119.149.155])
        by smtp.gmail.com with ESMTPSA id u37sm4606954qtj.47.2020.07.28.03.57.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2020 03:57:06 -0700 (PDT)
Date:   Tue, 28 Jul 2020 06:57:04 -0400
From:   Peilin Ye <yepeilin.cs@gmail.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Linux-kernel-mentees] [PATCH] scsi/megaraid: Prevent
 kernel-infoleak in kioc_to_mimd()
Message-ID: <20200728105704.GA407553@PWN>
References: <20200727210235.327835-1-yepeilin.cs@gmail.com>
 <20200728084137.GC2571@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728084137.GC2571@kadam>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Jul 28, 2020 at 11:41:37AM +0300, Dan Carpenter wrote:
> On Mon, Jul 27, 2020 at 05:02:35PM -0400, Peilin Ye wrote:
> > hinfo_to_cinfo() does no operation on `cinfo` when `hinfo` is NULL,
> > causing kioc_to_mimd() to copy uninitialized stack memory to userspace.
> > Fix it by initializing `cinfo` with memset().
> 
> But "hinfo" can't be NULL so this patch isn't required.  It's a bit
> hard for Smatch to follow the code.
> 
> We know that "opcode" is 82 so the buffer is allocated by mimd_to_kioc()
> -> mraid_mm_attach_buf().

You are right. mraid_mm_ioctl() returns -ENOMEM and never reaches
kioc_to_mimd() if mraid_mm_attach_buf() failed to get a buffer, so
`hinfo` can never be NULL for kioc_to_mimd().

Next time I will trace the data flow more carefully. Thank you for
pointing this out!

Peilin Ye

> Generally, don't silence static checker warnings unless it makes the
> code more readable.  It's the checker writer's job to fix their own code.
> In this case, that's me, but parsing the code is quite complicated and I
> don't have a plan for how to fix it.
> 
> regards,
> dan carpenter
> 
