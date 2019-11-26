Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A6A4C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:02:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D259220684
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 20:02:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="xDShlhvS"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbfKZUCo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 15:02:44 -0500
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35712 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726036AbfKZUCo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Nov 2019 15:02:44 -0500
Received: by mail-pg1-f193.google.com with SMTP id l24so1056692pgk.2
        for <linux-scsi@vger.kernel.org>; Tue, 26 Nov 2019 12:02:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=u14rKrT7Gow4r3xJ5+yGHcKuDYb4mqLZkkuJ6ycM4oc=;
        b=xDShlhvSye5Zjqy2OEBbxnyTI45hBoOOC636NoFBL3dM3CKjYDgcN+K9emJHE6bzPC
         A1PYOfGxjdXnr5qQk5/EhAnGG+SWzcdoDJPIuPe8x/VnqW2gZyvVmX0b8rht8KI3cEwk
         owv6RgZcmOCyjTSvqJxmthQFXCd1iZzB3uK8nMxzaX4EaTnUuFzDKDTGU8pJ9He2n6It
         /BGtlVzkw9roHeq1hpZ+oX8v+qBdR0sYO0jEJT34lzhhgVlnYwzrTU5QKzFamvZvy6jl
         PAM+ORzbKpOji2gBCRQxO7/yZB6NSoD3BYtd90qkst24B/LJFlJNUaAdHcNvHyzNOxhM
         6huQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=u14rKrT7Gow4r3xJ5+yGHcKuDYb4mqLZkkuJ6ycM4oc=;
        b=aHQACPtJCDI5rM43nR0QihWKKXHnwDVLmj53dQY2LqTKqQGpRXjDrd8frCfds1Xrtf
         fjfJ6vizLcap6C+A7WtPSTaI2QkEmmwTP5VMub4kpEuaFI7TnQiKjAtaYvwTtDvdIkIM
         YO6MCig7fiCrKWLZGiFeccOcup9JGmuHvCIPI8nk1LGE4sPrC19ZbrGWxmM48f9WWJ43
         ognTRzJ8EhXeKrvcYxVh9mrHn4zdFeyxpWFh+WegQWAIzxUUNVGX/swquDerAueC6xRl
         wysfz8OySdd0aQc1g8ykdD23qc0TZw68gZqjk+4gzAVx21yMDT5NHvnJzEHR9cKIMGOY
         W0cg==
X-Gm-Message-State: APjAAAVCKr0873h06O6VXjd3ALjVm8F55oLHs2qICHw9OdyiwRhYJ4Le
        7FC8+6z3sF5C6EeQUvJawqbF1QjvxtmYqQ==
X-Google-Smtp-Source: APXvYqy5sX/6Bv3pIcN1ZNgFGddQH9UStznfWcfBQntq1x7+WA9EqR1VQvQOMLUmrsjectVQip60Aw==
X-Received: by 2002:a63:c103:: with SMTP id w3mr226644pgf.275.1574798563184;
        Tue, 26 Nov 2019 12:02:43 -0800 (PST)
Received: from [192.168.1.188] ([66.219.217.79])
        by smtp.gmail.com with ESMTPSA id y4sm13749935pgy.27.2019.11.26.12.02.41
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Nov 2019 12:02:42 -0800 (PST)
Subject: Re: [PATCH 1/2] cdrom: respect device capabilities during opening
 action
To:     =?UTF-8?Q?Diego_Elio_Petten=c3=b2?= <flameeyes@flameeyes.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20191119213709.10900-1-flameeyes@flameeyes.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7df6dd1b-7c3c-9178-e391-aac71a10e1b8@kernel.dk>
Date:   Tue, 26 Nov 2019 13:02:40 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191119213709.10900-1-flameeyes@flameeyes.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/19/19 2:37 PM, Diego Elio Pettenò wrote:
> Reading the TOC only works if the device can play audio, otherwise
> these commands fail (and possibly bring the device to an unhealthy
> state.)
> 
> Similarly, cdrom_mmc3_profile() should only be called if the device
> supports generic packet commands.

Applied 1-2, thanks.

-- 
Jens Axboe

