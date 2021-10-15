Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37C01C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 21:14:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1EFAE61151
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Oct 2021 21:14:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243087AbhJOVQr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Oct 2021 17:16:47 -0400
Received: from mail-pj1-f53.google.com ([209.85.216.53]:55032 "EHLO
        mail-pj1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243090AbhJOVQq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Oct 2021 17:16:46 -0400
Received: by mail-pj1-f53.google.com with SMTP id np13so8061682pjb.4;
        Fri, 15 Oct 2021 14:14:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=qJA65CjIq0sW9pwPjhwz1BOfzReAhhdiyB/dhUgpGh0=;
        b=XmJsJ3cEvqMpbVU5uVD1HtpgxSqmv6/3dmWAtLq0C2g2UrhRTi12yCiwyCbB+wglNg
         7vk5QLnLYtAvBY6YgwUQjzQ2ZCPbt9qKCScORtxWr3yt/47DS9+sdQn5vW/82tcXTIDC
         Dwr0TZL16gLIo0bQ1wjH466DWT0AID3rCVgVPNCmRSD0kBcDRt/gV/ewCULrjdma3uhg
         gWPLrlLGw9Lo3nSkYNI46qfB5F+CDVTdCM7BsR3quLy95LortxQ77mBstx8lvX5LvQQj
         iF6f4olVq37UxYUU+3dKqf1rt0/EUu9Ir6mBZcz59rpRd2cNOA4qB/3Dvj/f+ivKVKHH
         ljvQ==
X-Gm-Message-State: AOAM531nURH2coB+jEod8fdqT5BPGkUrEvCGZLrNsieoSBjLbpFIhGqI
        B453Rv/xQTO6GwAzXLPF6Rw=
X-Google-Smtp-Source: ABdhPJy/NnL/0K/f8CdCsfRJVIOb3LtYfQ6cBP23558YHvEBmVkiIGZyI4brw031JmBB1WCFBwaYqQ==
X-Received: by 2002:a17:90a:f2c2:: with SMTP id gt2mr2622207pjb.2.1634332478743;
        Fri, 15 Oct 2021 14:14:38 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:cbb9:9363:2c17:8891? ([2601:647:4000:d7:cbb9:9363:2c17:8891])
        by smtp.gmail.com with ESMTPSA id x30sm5785210pfj.219.2021.10.15.14.14.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 Oct 2021 14:14:38 -0700 (PDT)
Message-ID: <14930227-aca0-89a0-25ea-727d263f8bf8@acm.org>
Date:   Fri, 15 Oct 2021 14:14:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.2
Subject: Re: [PATCH] scsi: sd: fix crashes in sd_resume_runtime
Content-Language: en-US
To:     miles.chen@mediatek.com
Cc:     jejb@linux.ibm.com, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        martink@posteo.de, matthias.bgg@gmail.com,
        stanley.chu@mediatek.com, wsd_upstream@mediatek.com
References: <fe7bacf4-aa9a-6742-8382-a7c9b31236a7@acm.org>
 <20211015201155.12212-1-miles.chen@mediatek.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20211015201155.12212-1-miles.chen@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/15/21 13:11, miles.chen@mediatek.com wrote:
> I hit this in v5.15-rc1 merge, I can still reproduce this with v5.15-rc5.
> I found two ways to avoid the crash:
> 1) revert commit ed4246d37f3b ("scsi: sd: REQUEST SENSE for
> BLIST_IGN_MEDIA_CHANGE devices in runtime_resume()") works for me.
> 2) adding the NULL point check in this patch.
> 
>>From the backtrace, dev_set_drvdata() is called after sd_resume_runtime()
> is called.
> 
> sd_probe()
> {
>   scsi_autopm_get_device()
>     pm_runtime_get_sync()
>       __pm_runtime_resume()
>         rpm_resume()
>          ...
> 	 sd_resume_runtime() // crash here
> 
>    dev_set_drvdata(dev, sdkp); // sdkp is set later
> }
> 
> [    4.861395][  T151]  sd_resume_runtime+0x20/0x14c
> [    4.862025][  T151]  scsi_runtime_resume+0x84/0xe4
> [    4.862667][  T151]  __rpm_callback+0x1f4/0x8cc
> [    4.863275][  T151]  rpm_resume+0x7e8/0xaa4
> [    4.863836][  T151]  __pm_runtime_resume+0xa0/0x110
> [    4.864489][  T151]  sd_probe+0x30/0x428
> [    4.865016][  T151]  really_probe+0x14c/0x500

Thanks for the clarification. Given this clarification I'm fine with 
your patch.

Bart.


