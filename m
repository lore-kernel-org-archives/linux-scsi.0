Return-Path: <SRS0=4aQo=EM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F598C2D0A3
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 04:06:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F73C20658
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Nov 2020 04:06:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgKFEGl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Nov 2020 23:06:41 -0500
Received: from mail-pf1-f174.google.com ([209.85.210.174]:34592 "EHLO
        mail-pf1-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725616AbgKFEGl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Nov 2020 23:06:41 -0500
Received: by mail-pf1-f174.google.com with SMTP id o129so131664pfb.1
        for <linux-scsi@vger.kernel.org>; Thu, 05 Nov 2020 20:06:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5hb9P8bqoPN0yoDSlq0YQywGLDoqU9LvpiWq2qmNJy0=;
        b=oZjuoLpYLoMrJi5z5e6tKXr/XLdfp6Ye+rVZY7+SeuRQZX5TEkTc1T2OKaH5eEMiEu
         JyIQaAId2jeR7JSZoybZ5VdAkgpw+3Y4IPvdoZwaQrjb68+Ah4fWwcQBHUDvcBjnXfx4
         KyV2AfC1aDMmqFEJQxbHONTPR8mUp1S1hGdKrmIISy8A1ZyPb1mo1A07yJzdwJyB1WbK
         XcC2utxZzem5UBNolf3973Q0ddah7IowLKBoJFmd8cmIYcPPQwB6657skprRsNc6mz65
         na0UNoiT4hdPMVA6krTnhKsHWDpqHypxctRl6R5R4Il5KHktoKZV9KLKYBYTtQFASIuT
         oMHg==
X-Gm-Message-State: AOAM532VPDsTL3qH8O6ZnxBTyzmed0T3tSVtiISwyTbvODZqPJS+ea4n
        6jn2ROcLvhg2lEEd8I8tuSY=
X-Google-Smtp-Source: ABdhPJzW3S9do29nlslTdczBtMdvFD90K0dL+wtJhzdkU8yfRmKq1pcQu8cuIHlPxNkkeisloFF4dQ==
X-Received: by 2002:a63:2d02:: with SMTP id t2mr86200pgt.306.1604635599083;
        Thu, 05 Nov 2020 20:06:39 -0800 (PST)
Received: from [192.168.3.218] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id z10sm185577pjz.49.2020.11.05.20.06.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Nov 2020 20:06:37 -0800 (PST)
Subject: Re: [PATCH] scsi_debug: change store from vmalloc to sgl
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        bostroesser@gmail.com, ddiss@suse.de, hare@suse.de
References: <20201106003852.24113-1-dgilbert@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <be8196e5-0eab-f40b-1985-c04c3c3a1682@acm.org>
Date:   Thu, 5 Nov 2020 20:06:35 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201106003852.24113-1-dgilbert@interlog.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/5/20 4:38 PM, Douglas Gilbert wrote:
> A long time ago this driver's store was allocated by kmalloc() or
> alloc_pages(). When this was switched to vmalloc() the author
> noticed slower ramdisk access times and more variability in repeated
> tests. So try going back with sgl_alloc_order() to get uniformly
> sized allocations in a sometimes large scatter gather _array_. That
> array is the basis of keeping O(1) access to the store.
> 
> Using sgl_alloc_order() and friends requires CONFIG_SGL_ALLOC
> so add a 'select' to the Kconfig file.
> 
> Remove kcalloc() in resp_verify() as sgl_s can now be compared
> directly without forming an intermediate buffer. This is a
> performance win for the SCSI VERIFY command implementation.
> 
> Make the SCSI COMPARE AND WRITE command yield the offset of the
> first miscompared byte when the compare fails (as required by
> T10).
> 
> This patch depends on: "[PATCH v4 0/4] scatterlist: add new
> capabilities".

Hi Doug,

Although I'm fine with this patch: has it been considered to use huge
pages instead of allocating a scatterlist? Would that have the same or
even better performance advantages?

Thanks,

Bart.
