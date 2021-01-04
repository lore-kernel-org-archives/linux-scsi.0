Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA03DC43331
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 82905206B2
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Jan 2021 17:49:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727634AbhADRtp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Jan 2021 12:49:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727566AbhADRto (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Jan 2021 12:49:44 -0500
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9AEAC061343
        for <linux-scsi@vger.kernel.org>; Mon,  4 Jan 2021 09:48:30 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id i7so19509847pgc.8
        for <linux-scsi@vger.kernel.org>; Mon, 04 Jan 2021 09:48:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxace-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=65owITg5bptvn1j++cmPjkA/zjpHPF/EDZomkuXKGqY=;
        b=uY/UlD7z90jZJguSr4Qov6hTFwNsacX2P0geVNecyR5ZH7ZJamw0DXTNljsbMPh9PS
         MFtO+9k1uqqfJPP4oxrzK1VHY59gJeN3JZOQsggZWLYox/RAcbwzjbXHZTbFVt/p2hXc
         5PsPpT843IKgWkVa89xYlfbHBCRM9SdJW1eLo4vZRudTVCbP03yEes6Of/ssVlo1bwwD
         lPisb7pbEW5ixCwrXhMykOxku5XX94zl1lW46mkndO08IyIeRjTZFa0pUxIpRkCFgRPq
         ug5zNvBVQsrv3jFZjiOXLHjS9S5H7+LP8pFgaUWXRdyTsJ7CT9WbL3iRXfIFRSKMSDCy
         Sh6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=65owITg5bptvn1j++cmPjkA/zjpHPF/EDZomkuXKGqY=;
        b=Fh2QSzBcXNckZlMgkUuglexE35qDALO2w8rTSvFbHFqC93PdFHxcFjfxUJx/uXW5OG
         4w70v2Des2t9LtxePafqZJBPItWR6HVsMWzlCkP7jJIVScSdtiZRGBpUZ1zf6RiEb3+X
         ZyvypkTVCsBiz+KkpuJIjGc+Zr0GETRoE4ic4Z1qyqlzHVx74t/q65euXxXaAbertRfX
         TZ95DMbJ76oTsToEy775h2OTIZlDTVBY1aIKOUPDAbPFYJ5uhxKxZYDpbjXD4JCNUygJ
         DrGcyf4BXH8FQKsX6k3OUJTMJEOe6XYddDJXVTi1200I6RQ6xyUnOnicKWhNSDFwaZSR
         qZWg==
X-Gm-Message-State: AOAM532trxzhDFbSi+clcPFwII+ZO0cBxMJ+zYFhV13E31HjhHjpfn4u
        Ws1BQxOvEcv40E0vn0Cyf2dUmA==
X-Google-Smtp-Source: ABdhPJzyl3JwJlJhdPc5Jfiknw7ZF3oAzN30Yms3O1ELx9wLiAGjFS0agKxHvleXTZGJgkZVtJCRqw==
X-Received: by 2002:a63:520e:: with SMTP id g14mr24089127pgb.378.1609782510541;
        Mon, 04 Jan 2021 09:48:30 -0800 (PST)
Received: from home.linuxace.com (cpe-23-243-7-246.socal.res.rr.com. [23.243.7.246])
        by smtp.gmail.com with ESMTPSA id p9sm34954pjb.3.2021.01.04.09.48.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Jan 2021 09:48:29 -0800 (PST)
Date:   Mon, 4 Jan 2021 09:48:26 -0800
From:   Phil Oester <kernel@linuxace.com>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     Arnd Bergmann <arnd@arndb.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@infradead.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, megaraidlinux.pdl@broadcom.com,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
Message-ID: <20210104174826.GA76610@home.linuxace.com>
References: <20200908213715.3553098-1-arnd@arndb.de>
 <20200908213715.3553098-2-arnd@arndb.de>
 <20201231001553.GB16945@home.linuxace.com>
 <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0_WORgd4Wvd3n+59oR=-rrESwg_MgpDJN4xPo_e6ir5Q@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jan 03, 2021 at 05:26:29PM +0100, Arnd Bergmann wrote:
> Thank you for the report and bisecting the issue, and sorry this broke
> your system!
> 
> Fortunately, the patch is fairly small, so there are only a limited number
> of things that could go wrong. I haven't tried to analyze that message,
> but I have two ideas:
> 
> a) The added ioc->sense_off check gets triggered and the code relies
>   on the data being written outside of the structure
> 
> b) the address actually needs to always be written as a 64-bit value
>     regardless of the instance->consistent_mask_64bit flag, as the
>    driver did before. This looked like it was done in error.
> 
> Can you try the patch below instead of the revert and see if that
> resolves the regression, and if it triggers the warning message I
> add?

Thanks Arnd, I tried your patch and it resolves the regression.  It does not
trigger the warning message you added.

Phil
