Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A07F5C433F5
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 19:51:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 88D7F61251
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Nov 2021 19:51:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236362AbhKGTyb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Nov 2021 14:54:31 -0500
Received: from mail-pl1-f176.google.com ([209.85.214.176]:43777 "EHLO
        mail-pl1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236361AbhKGTyb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Nov 2021 14:54:31 -0500
Received: by mail-pl1-f176.google.com with SMTP id y1so14394434plk.10;
        Sun, 07 Nov 2021 11:51:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=H5xHYKMniSx/Mg6dS/jtSkwbJD5EXGUsd4tmD0Rxz7s=;
        b=6xuTt647//pNdnD4ewYE3KhheYBWiVQTgZxPemR3cNC/SJrmy5VCzXOs1OisRIbZ2N
         jPU7XR1+1TA/js4begp0MbkrygQFi3jkTzLU5AYRptvbGq4zM5waT4kUOsIfBfPEKz1p
         percux+81YUrGFzlAOndr4KqS8pu7+49ZHoq52e+X+mQFPocfCo2Q+PSGaLUpPMGqBlc
         KW/ev70LsYxnZTF7Y5uSXMzrmaz0tGY5qer7DKge2FX5cGXmgiPGFOl6Nl+68CVh4r47
         Y73LvdCG+oVUt4FhwHXmNHOiesgLzsJYjQW9lSGuNFKHA+TQYM+wja7LiQyGNk1Xdbx2
         SXFg==
X-Gm-Message-State: AOAM530Z9u3WYUs2Qqx70lHr/5QYmi7Rxhju7ToRrg/+tF446IPqfJxN
        Envp/idftgiqWHnYPd3Djew=
X-Google-Smtp-Source: ABdhPJwqUFo5Ny4lkKrHJCjfEQcrraKF9krA1mvWYYoYM/O7i1A1ys/Or4WVRgYR3WgIy/C9kBSiLQ==
X-Received: by 2002:a17:90a:fe87:: with SMTP id co7mr46071388pjb.21.1636314707819;
        Sun, 07 Nov 2021 11:51:47 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:d1e7:8937:1ee:f842? ([2601:647:4000:d7:d1e7:8937:1ee:f842])
        by smtp.gmail.com with ESMTPSA id a2sm10697730pgn.20.2021.11.07.11.51.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 07 Nov 2021 11:51:46 -0800 (PST)
Message-ID: <ce4f925f-cbf9-9bbb-4bde-dd57059e3c84@acm.org>
Date:   Sun, 7 Nov 2021 11:51:45 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: Unreliable disk detection order in 5.x
Content-Language: en-US
To:     Simon Kirby <sim@hostway.ca>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20211105064623.GD32560@hostway.ca>
 <9c14628f-4d23-dedf-3cdc-4b4266d5a694@opensource.wdc.com>
 <20211107022410.GA6530@hostway.ca>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211107022410.GA6530@hostway.ca>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/6/21 19:24, Simon Kirby wrote:
> This occurs regardless of the CONFIG_SCSI_SCAN_ASYNC setting, and
> also with scsi_mod.scan=sync on vendor kernels. All of these disks
> are coming from the same driver and card.
> 
> I understand that using UUIDs, by-id, etc., is an option to work
> around this, but then we would have to push IDs for disks in every
> server to our configuration management. It does not seem that this
> change is really intentional.

SCSI disk detection is asynchronous on purpose since a long time. The 
most recent commit I know of that changed SCSI disk scanning
behavior is commit f049cf1a7b67 ("scsi: sd: Rely on the driver core for
asynchronous probing").

Please use one of the /dev/disk/by-*/* identifiers as Damien requested.

Thanks,

Bart.
