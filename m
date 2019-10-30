Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD0C4CA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:15:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 92E4120874
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727216AbfJ3PPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:15:20 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:33826 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727169AbfJ3PPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 11:15:20 -0400
Received: by mail-pf1-f193.google.com with SMTP id b128so1814657pfa.1;
        Wed, 30 Oct 2019 08:15:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=X+f7Q5A5Y2bGz0zmlOAyoSSUqrUDISfufa4bR7XqeLE=;
        b=ojlt62X+jWIW66C9bu0bgfGwaqYoqUaHxdffFYnnEiUbrfWvvZOg+sXLzdoIXqe7gw
         pPc/IX2uZVvthnMw86ND7+anzXcwCkUV3uk/W9nbXYJNKQawmlPCu63WpWQkZY2AE7X8
         VnwM8AHzbL3ly0Ywlgg/Sgdq5y7qvW53/G9GFLiPrKFqYhEZe+gqKxPC4pYBmqcJ2Fmm
         CCwjN1af8SynaN/VS9Bqt3NU9X30gv2nrwMQUSPNpqDY3F8jGbDyJR8dNRyjmvrj9fiL
         8Cm7JVjwAct4Dj9C61xlxXyJVaYPJcE4FmZ+caWBCCUjOndgnBp5CC8K4ChBVdSGDb+L
         L61Q==
X-Gm-Message-State: APjAAAWPxaHovYfMCo0rNFz7qbS4RXULNPf10wMfpwCoeQC/lT8wnP2d
        ZdpIiKMkrPa2FUIPIqM7h253lu2o
X-Google-Smtp-Source: APXvYqxkPzaKddNYfydLzrWbqFzgt2+BTT/TOZxPLVrNXB0eES/raS+jymMgecy2adK83ENxkOE4Cg==
X-Received: by 2002:a17:90a:a406:: with SMTP id y6mr15137830pjp.106.1572448517964;
        Wed, 30 Oct 2019 08:15:17 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id f13sm139711pgs.83.2019.10.30.08.15.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 08:15:16 -0700 (PDT)
Subject: Re: [PATCH v2] scsi: Fix scsi_get/set_resid() interface
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191030090847.25650-1-damien.lemoal@wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <af516590-58dc-0377-5c54-ac63cffbafc8@acm.org>
Date:   Wed, 30 Oct 2019 08:15:15 -0700
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
  Please answer my question about how a SCSI LLD should report residual 
overflows. I think this patch is incompatible with the approach used by 
the SRP initiator driver:

if (unlikely(rsp->flags & SRP_RSP_FLAG_DIUNDER))
	scsi_set_resid(scmnd, be32_to_cpu(rsp->data_in_res_cnt));
else if (unlikely(rsp->flags & SRP_RSP_FLAG_DIOVER))
	scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_in_res_cnt));
else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOUNDER))
	scsi_set_resid(scmnd, be32_to_cpu(rsp->data_out_res_cnt));
else if (unlikely(rsp->flags & SRP_RSP_FLAG_DOOVER))
	scsi_set_resid(scmnd, -be32_to_cpu(rsp->data_out_res_cnt));

Thanks,

Bart.
