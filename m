Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3E89C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 20:16:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240829AbiBWUQz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 15:16:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232750AbiBWUQz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 15:16:55 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 017D74CD58;
        Wed, 23 Feb 2022 12:16:27 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id bx9-20020a17090af48900b001bc64ee7d3cso16817pjb.4;
        Wed, 23 Feb 2022 12:16:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=RBcufn5WQ8cmoyVtub/MxNarzBgjiahv7fP0eJoTRQ0=;
        b=T7ju1uSIo51L4FIXV06RCx8puz7iOMZGwZcdCACn0oUIAC9FAAOoab2UWG0Fy7wbo1
         XbBNNNeHs8Vzg7+H/KU3NQ3h+43sPlZepJbp6yfaIUF7sWDyDeK35KxuKXt7JtbM2b4t
         FX7+YZ+ztn78Yil0TEgB9sDwG6sNJ98b520eFBGmsxRMb1RgZNJuFmmH4FbIbZ42zz27
         3tWlvd2bjfRBC9rz3y95K8U3zQwe1j6MLoGdp7ggPHuu9r4us3v/VeuL3KcrCkpCiAwE
         gWhMLCzj6DMcFngrJ7AOI1gIMe3tsFA/QR2sjIeWmoqorMDn50cIqxXuVkOjqJFAgvvN
         oe6w==
X-Gm-Message-State: AOAM532e5O8lu5iKDgYnucu8GErmjR6VF7yC11K2ipmem7kFQ6pBdJCr
        1eYUCDWM1bo8/0O1I+8JlF8=
X-Google-Smtp-Source: ABdhPJzAAgD7m9Zjo/s2zyKNWtlaJrNg0BIXqf1SsBO4kP4Dx4Fa8VFFrzPsfTvD0SmT9jvoO+Y0sQ==
X-Received: by 2002:a17:902:9b96:b0:14d:b42c:d4d3 with SMTP id y22-20020a1709029b9600b0014db42cd4d3mr1406298plp.33.1645647386252;
        Wed, 23 Feb 2022 12:16:26 -0800 (PST)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id m17-20020a17090a7f9100b001b9e4d62ed0sm3784472pjl.13.2022.02.23.12.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Feb 2022 12:16:25 -0800 (PST)
Message-ID: <c22fa8f1-790d-faf8-a014-f00e0e357075@acm.org>
Date:   Wed, 23 Feb 2022 12:16:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
 <f5c2f7e0-6b14-222f-ba16-696b29517296@huawei.com>
 <20220223123940.GA4205@lst.de>
 <75ccb490-3c77-b7d9-815a-8bf1698f0848@huawei.com>
 <20220223125855.GA4489@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220223125855.GA4489@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/22 04:58, Christoph Hellwig wrote:
> In general most of the zeroing here should go away entirely.  Right
> now that code is a bit convolute due to the fake EH scsi command that
> also uses scsi_init_command.  Once that is sorted out (I've just pinged
> Hannes for his series) scsi_init_command can be folded into
> scsi_prepare_cmd and a lot more of this can be cleaned up.

Several SCSI LLDs rely on the SCSI core zeroing the driver-private data.
I'd be more than happy if the code for zeroing of driver-private data 
would be pushed into the LLD drivers. This may require the introduction 
of a new per-command flag since that zeroing should only happen if 
scsi_queue_rq() decided to call scsi_prepare_cmd().

Bart.
