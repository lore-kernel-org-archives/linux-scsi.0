Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F340C4724C
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 16:16:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 69601206E6
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 16:16:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="JtB9E0VA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729588AbgEDQQo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 12:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726551AbgEDQQn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 12:16:43 -0400
Received: from mail-il1-x144.google.com (mail-il1-x144.google.com [IPv6:2607:f8b0:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 740BAC061A41
        for <linux-scsi@vger.kernel.org>; Mon,  4 May 2020 09:16:42 -0700 (PDT)
Received: by mail-il1-x144.google.com with SMTP id q10so11811841ile.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 May 2020 09:16:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=O2NAB+HJ6UzNB91gndqrDrOBWBRRYdtXc0RXwgVqjIU=;
        b=JtB9E0VAIJLFoltqJ/EHP5uJ1L/CC5gPEHBmZzWmKIrxbjl26Ne5XpvBSLm41xSBIg
         t1xVdmJvdqBHaspjtVCP0vgnGV8j2MBTNBjG6GfJcM4fXOhB5+xGf03i727pyog2NP6D
         GccF27GbRs4QZX7lndDIpxFVeOCoMgIl3dOrXZVf+VRPY7WwOdamJ/8xOXsiov24FI4J
         cg7O0CG65PADdLp8q2dvOrT5ZwuaButnO4gv0VIES92fKah6Zco3/qNsmkTYiehcGMU9
         Q2MWvAeM0Qng2AHkE9aLevizkhC1L0KUTdxlOLZZymREU3y6Lz7t6E+UeIP0pi9e0AJ9
         6new==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O2NAB+HJ6UzNB91gndqrDrOBWBRRYdtXc0RXwgVqjIU=;
        b=JSOu3OIT4iRHrCAyk0LajRgS3Wr3PcO/uN3iSacUFKusvp4iL0uHipH91oLSNhMu/z
         RTZYDWQNkR9a6055uOo+pIyNPXW6QXdcJiGjTckrNAF6pWP5v8AJ91MvZsnwKKGug3xX
         VF0P5RyWOChSHLFi6pDkbT/WAZpwFI0pleMZDjwGtXn1Um4AU9xyZ7xzWp6X5dILor6j
         /1T3R8iXQZo0twmTXZh8fAnchHBCW6SRj2pfgZ+EKDm3LAp5YqZtFlJJ7ra0qHejC7bh
         E5eOmNXZvMNjxJuNchUwGYnv8uhqswfSvPPhfs+3+hu2cXjs0yG4ckYDOC26MbCFLzgQ
         qzxw==
X-Gm-Message-State: AGi0PuZvFKLliOXdLXHwXbYFyDp37aApU5KYxvh0IUIT0zrujfqXhMV7
        7MsR8vW+tRsP/4i1+HCCVOi5Pg==
X-Google-Smtp-Source: APiQypLOM7ihGkQHTNt/pKRC46v+xHKsvR0zC0Gq/TKe4vXwyBmsBEqqQDWLYSJ6GF4HlBlFg2BYoQ==
X-Received: by 2002:a92:d6c6:: with SMTP id z6mr16340696ilp.32.1588609001697;
        Mon, 04 May 2020 09:16:41 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id m22sm4250384iow.35.2020.05.04.09.16.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 May 2020 09:16:41 -0700 (PDT)
Subject: Re: [PATCH 5/7] hfsplus: stop using ioctl_by_bdev
To:     Christoph Hellwig <hch@lst.de>
Cc:     Tim Waugh <tim@cyberelk.net>, Borislav Petkov <bp@alien8.de>,
        Jan Kara <jack@suse.com>, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Damien Le Moal <damien.lemoal@wdc.com>
References: <20200425075706.721917-1-hch@lst.de>
 <20200425075706.721917-6-hch@lst.de>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6c47f731-7bff-f186-da55-7ce6cffacdc3@kernel.dk>
Date:   Mon, 4 May 2020 10:16:40 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200425075706.721917-6-hch@lst.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/25/20 1:57 AM, Christoph Hellwig wrote:
>  	if (HFSPLUS_SB(sb)->session >= 0) {
> +		struct cdrom_tocentry te;
> +
> +		if (!cdi)
> +			return -EINVAL;
> +
>  		te.cdte_track = HFSPLUS_SB(sb)->session;
>  		te.cdte_format = CDROM_LBA;
> -		res = ioctl_by_bdev(sb->s_bdev,
> -			CDROMREADTOCENTRY, (unsigned long)&te);
> -		if (!res && (te.cdte_ctrl & CDROM_DATA_TRACK) == 4) {
> -			*start = (sector_t)te.cdte_addr.lba << 2;
> -			return 0;
> +		if (cdrom_read_tocentry(cdi, &te) ||
> +		    (te.cdte_ctrl & CDROM_DATA_TRACK) != 4) {
> +			pr_err("invalid session number or type of track\n");
> +			return -EINVAL;
>  		}

I must be missing something obvious from just looking over the patches,
but how does this work if cdrom is modular and hfsplus is builtin?

-- 
Jens Axboe

