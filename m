Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E870FA372C
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:25:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E387821882
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 16:25:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726576AbfKHQZE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 11:25:04 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:40358 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726200AbfKHQZE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 11:25:04 -0500
Received: by mail-pg1-f196.google.com with SMTP id 15so4257369pgt.7;
        Fri, 08 Nov 2019 08:25:02 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9+uoj8lNodCH/yF6mbg/IXWpHQI/7No+l7A/rtoNzfQ=;
        b=WaT4N+XU7tj8mnvinwvqaIiA25W7zl1cbltShPh9GFu8NOobmPS7wBtYokiPwCbA08
         UyaC/IopHhD5vjF7mPwwusohB0XqJQ16cL9w7n3D5mffTL+fk47Afd30yUrFRj5l620H
         z3OvO3xPEcM5gt0wmkZjXJ3u5ItjokKk6UVm4BKXkaZY0Ew+n67rs/I0rKYWAJ+zgjpc
         64pRmTNjxDalU96txhTcUfQHpWRNj0JaGFS+CoddiSZcMgvHjShUAVX2m6g4bCc0p/yI
         ZFkKMkmhiILBywUBtzz+Jpf8fx9Ua3gx02kvIclsCEGCtite0lw1Y93tUbocQPoACNot
         Pwgw==
X-Gm-Message-State: APjAAAV3QyHEk0miEXquaihu8+vA2f7ldIJVFsc1kQVC2LPj0aLG02sW
        6N9KdYdEvUsChjz2afcO9yw=
X-Google-Smtp-Source: APXvYqyR62JXFIcQsnv/9aTkvr/5Zf4QUY+imxly2ODGG0V1kn41lARaY8vNAqGp9+R2uzse4hc3Pw==
X-Received: by 2002:a17:90a:6283:: with SMTP id d3mr15111619pjj.27.1573230301739;
        Fri, 08 Nov 2019 08:25:01 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id s66sm8704017pfb.38.2019.11.08.08.25.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Nov 2019 08:25:00 -0800 (PST)
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <11fa0f63-9a0f-faae-1d11-35f21cc64717@acm.org>
Date:   Fri, 8 Nov 2019 08:24:59 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191030090847.25650-1-damien.lemoal@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 2:08 AM, Damien Le Moal wrote:
> struct scsi_cmnd cmd->req.resid_len which is returned and set
> respectively by the helper functions scsi_get_resid() and
> scsi_set_resid() is an unsigned int. Reflect this fact in the interface
> of these helper functions.
> 
> Also fix compilation errors due to min() and max() type mismatch
> introduced by this change in scsi debug code, usb transport code and in
> the USB ENE card reader driver.

Since there is agreement that residual overflow should use another field 
than scsi_request.resid_len:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
