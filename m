Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEBD7C6FA83
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Sep 2022 22:19:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiILWT2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Sep 2022 18:19:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiILWTF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Sep 2022 18:19:05 -0400
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D75D1EECB
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 15:17:57 -0700 (PDT)
Received: by mail-pj1-f48.google.com with SMTP id m10-20020a17090a730a00b001fa986fd8eeso13761645pjk.0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Sep 2022 15:17:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=huXRUucL2UuMwUKszMPjjatMAjW2/Nq4jWwUvq+Tbjg=;
        b=lKOtDurQQkwAMTdE3CXkiSlag/VF2O2STfDeP/SLSCajrVBmgNFpELJG0k9dAaImht
         b4VTiD8ybqeHXObqMrbhhoCHew6JAStYIocQdhGbJcKtkY3xDZH2skARV5hcRX61fU8h
         bfRVaAC5UrOp7X+6tqQOqLri31GsPH2OssAncTqUYXeqTschYFer1mokM5I9t7LZhDDf
         D2kfXoDb7JqZvsokdrWopoKA2V98GgO9/rZ9nFGl/bOHBEeFoMNnOVeaKcZx1Bn6fmdN
         2qL1uF3VaWaPrjf5H10Q5QTUyvOfvscVGduCswH5CcX+u2OfAEaU4pYirVNznXe5uXHZ
         VzFw==
X-Gm-Message-State: ACgBeo0th9zVSKJhCyKXfnK+W0L2gJe/OhaOic1ZI8RRcHjpAmv3c7nq
        COoucb8sN8xGoqtDdB31WR4=
X-Google-Smtp-Source: AA6agR6AjkWPlKa3lpjYENpGpLSKGJf5OkNLlmOM1zDrAFoZEW910NqO5Nl/u6zupSZ0GuuWHsBRDg==
X-Received: by 2002:a17:90b:3811:b0:202:9e26:bc00 with SMTP id mq17-20020a17090b381100b002029e26bc00mr540575pjb.223.1663021076635;
        Mon, 12 Sep 2022 15:17:56 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:b206:445a:9717:79df? ([2620:15c:211:201:b206:445a:9717:79df])
        by smtp.gmail.com with ESMTPSA id u17-20020a170903125100b001780e4e6b65sm6440651plh.114.2022.09.12.15.17.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Sep 2022 15:17:54 -0700 (PDT)
Message-ID: <e1d7dcf5-975e-ef90-fea4-2ca089e97493@acm.org>
Date:   Mon, 12 Sep 2022 15:17:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: Another DP for Revert "scsi: core: Call blk_mq_free_tag_set()
 earlier"
Content-Language: en-US
To:     "Kenneth R. Crudup" <kenny@panix.com>
Cc:     linux-scsi@vger.kernel.org
References: <9dc65f12-7692-7f2f-b3a7-41befb47d9a6@panix.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <9dc65f12-7692-7f2f-b3a7-41befb47d9a6@panix.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/30/22 13:19, Kenneth R. Crudup wrote:
> I have a power-hungry NVMe-to-USB-C enclosure that sometimes falls offline
> under heavy load and disconnects from the USB. Normally I curse and re-plug
> it into a powered hub and go on with things. But I'm running Linus' master
> (6.0-rc3 of Sunday August 28th, which also has the asynchronous resume support
> rework reverted) and I was seeing a lot of the below (along with a hanging up
> of the USB).
> 
> Reverting f323896f (and setting it up to reproduce the disk error/disconnect)
> seems to have fixed the "usb_hub_wq hub_event" hangup, at least at first glance.

Hi Kenneth,

Thanks for having reported this. The revert mentioned above has been 
included in Linus' master branch as commit 2b36209ca818 ("scsi: core: 
Revert "Call blk_mq_free_tag_set() earlier""). Further feedback is welcome.

Thanks,

Bart.


