Return-Path: <SRS0=fKRq=4M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EEE4C11D30
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 16:23:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E9EBA20CC7
	for <linux-scsi@archiver.kernel.org>; Mon, 24 Feb 2020 16:23:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="MlFeKYpd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727486AbgBXQXQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 Feb 2020 11:23:16 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:39241 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727299AbgBXQXQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Feb 2020 11:23:16 -0500
Received: by mail-io1-f68.google.com with SMTP id c16so10840286ioh.6
        for <linux-scsi@vger.kernel.org>; Mon, 24 Feb 2020 08:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cdH1MvvC7rUuS4KMjyzC13eGx35pprvSgBak/SE0yDY=;
        b=MlFeKYpdGaZT6w34tn6UFiEg5Qu4hA9w7O6A9cIiaoRQtKmhSi2DoL/6YteNJlg9YE
         NgHRstjBoCMp2W8rfpiMDU4KbItudyyg4ytb79MSCjGDGDRRvZzvDYecDvaczbeslPJG
         ApTtFYFtGhY70jJFfyAFPuvg4WmY24LXDJ5YXmiZArOovzz84VmKp4OppNCjMNF/vwcd
         FcvV1jIapAwYuxO21y88pG/KN98bbsuiO4xF/gq7+XoIymUrffXa/0s5rijokVIBefHd
         vvil+w87/K6Imf7715nhMQhuh0DHonMpPezoW7cLQZBe0d0bEAgl/YgPpozox1sV3n+l
         Tjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cdH1MvvC7rUuS4KMjyzC13eGx35pprvSgBak/SE0yDY=;
        b=BIISZnswO2gJuRbgLrdfvGeiuN2btDgLbuh9sQtYZcJ41jRapmFIWGrgQEiksnF3uF
         i4pBp1PxhKzTf47XZtYR1iEW+hiO+m/dOkhWl8jV4Lydeq7MGb0O2gVb8eSwmiEFwi0S
         hN+X7yOkRdTUldvMxX+K8YiBuZ2XdWxV6rh+LexAswpZTGt74pbhkjZIbzGLI+0zg9Ox
         zhEFrhg8pyo7kgx0qsu4bQetZrslm8a3RPGhbmbpauBrkPrboXYrPJtpahOTMRrNrW1R
         tOm20hi0L1kZGlAb36NH/ar7O5tDEVYw2RU3BYQ8oW3DLYL4lmiVxK6oaFRR74ETk79U
         x+yQ==
X-Gm-Message-State: APjAAAV71GYd6f30RbS8CSrjn80zgDqap7hZQVs+M0NX+3RGMO53frKn
        RJPep1Akf+qYr6JxrpvHfhbaCO9gycw=
X-Google-Smtp-Source: APXvYqwlY2sK74rRUwE66MTs9Vld2g2g6L09aji8FUtw894gQCIG22oW4xtpGFOq9D4DS8+9Glemdw==
X-Received: by 2002:a6b:6108:: with SMTP id v8mr50420904iob.210.1582561394387;
        Mon, 24 Feb 2020 08:23:14 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id w15sm3115476iow.61.2020.02.24.08.23.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 24 Feb 2020 08:23:13 -0800 (PST)
Subject: Re: [PATCH] sr_vendor: remove references to BLK_DEV_SR_VENDOR, leave
 it enabled.
To:     =?UTF-8?Q?Diego_Elio_Petten=c3=b2?= <flameeyes@flameeyes.com>
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200223191144.726-1-flameeyes@flameeyes.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <28e56c52-1f36-eaf5-0a92-2ffd494472ac@kernel.dk>
Date:   Mon, 24 Feb 2020 09:23:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200223191144.726-1-flameeyes@flameeyes.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/20 12:11 PM, Diego Elio Pettenò wrote:
> This kernel configuration is basically enabling/disabling sr driver quirks
> detection. While these quirks are for fairly rare devices (very old CD
> burners, and a glucometer), the additional detection of these models is a
> very minimal amount of code.
> 
> The logic behind the quirks is always built into the sr driver.
> 
> This also removes the config from all the defconfig files that are enabling
> this already.

Looks fine to me, kind of silly to have that option.

Reviewed-by: Jens Axboe <axboe@kernel.dk>

Assuming the SCSI tree will pick this up.

-- 
Jens Axboe

