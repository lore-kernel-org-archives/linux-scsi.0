Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DC99CA9EC7
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:12:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 39E5120874
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:12:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727090AbfJ3PMJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:12:09 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44708 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726949AbfJ3PMI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 11:12:08 -0400
Received: by mail-pg1-f193.google.com with SMTP id e10so1659503pgd.11;
        Wed, 30 Oct 2019 08:12:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=nrnPTyEFl+6aZzJXJflCpowsX8ZrOUs+tX0p0YHuCEE=;
        b=c3kETC9VO6Jb4m+3nc4C6M5VtTqp/mjVe07vm76svkzvYlF0wPRBYQX6QS41JpLwp0
         FaZ98DWjdGT5/w3Jsc7eMG02OhZN4OkrR2DhYG5vWAxgaFbb/FL7bhmJZANshwq7GJyR
         9Q3j/9H5I3PujjJVIf8uO+swOFxFEK9qPYSHpAi+YXA1J/6PZ5EUifZNl5LCLeZ6gEq3
         F7LuW/jq+brxUNELVMjZtC2Kbo80aPaiKp+BjkvZblqAYY/Rnuxo0n8lN0rJWbLLp4Ln
         mfwZC2HZXXdVUl2kVbYSAXIJENex0MsO9Gf6w/I8x2o0ob279cD3inno9QC0Qo5+/UcH
         YhZA==
X-Gm-Message-State: APjAAAWs+GJzFBG+Tdl/GxviPkMQT/YciVtg4viwSGptE9CvkZKeiVwu
        sC1FH7UqeCDvhXGavQWQgn4=
X-Google-Smtp-Source: APXvYqyIheuynv7JrRYiPQ/gSZ0JJ1J8L2s6PYAcq9UqcuxWCofZljR4zxoAk++LMW2H+VPuMY0ieg==
X-Received: by 2002:a63:5801:: with SMTP id m1mr25588238pgb.139.1572448327681;
        Wed, 30 Oct 2019 08:12:07 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z7sm290350pfr.165.2019.10.30.08.12.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 08:12:06 -0700 (PDT)
Subject: Re: [PATCH] scsi: Fix scsi_get/set_resid() interface
To:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Justin Piszcz <jpiszcz@lucidpixels.com>
References: <20191028105732.29913-1-damien.lemoal@wdc.com>
 <eb8f6e3e-0350-9688-58c8-9d777ba93298@acm.org>
 <4ee551d0-27a6-b516-ade0-d477fd93bad8@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <d0899d02-ecb2-7f0b-3d0a-c818a0ec6ceb@acm.org>
Date:   Wed, 30 Oct 2019 08:12:04 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ee551d0-27a6-b516-ade0-d477fd93bad8@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 1:30 AM, Hannes Reinecke wrote:
> On 10/28/19 9:38 PM, Bart Van Assche wrote:
>> If the residual is changed from signed into unsigned, how is a SCSI 
>> LLD expected to report the difference between residual overflow and 
>> residual underflow to the SCSI core?
>
> You don't have to. To quote RFC 3720 page 122:
> 
>       bit 5 - (O) set for Residual Overflow.  In this case, the Residual
>         Count indicates the number of bytes that were not transferred
>         because the initiator's Expected Data Transfer Length was not
>         sufficient.  For a bidirectional operation, the Residual Count
>         contains the residual for the write operation.
> 
> IE the 'overflow' setting in the iSCSI command response is an indicator 
> that there _would_ be more data if the command request _would_ have 
> specified a larger buffer.
> But as it didn't, the entire buffer was filled, and the overflow counter 
> is set.
> Which, of course, is then ignored by the linux SCSI stack as the request 
> got all data, and the residual is set to zero.
> Then it's left to the caller to re-send with a larger buffer if 
> required. But it's nothing the SCSI stack can nor should be attempting 
> on its own.

Hi Hannes,

I do not agree that reporting a residual overflow by calling 
scsi_set_resid(..., 0) is acceptable. For reads a residual overflow 
means that the length specified in the CDB (scsi_bufflen()) exceeds the 
data buffer size (length of scsi_sglist()). I think it's dangerous to 
report to the block layer that such requests completed successfully and 
with residual zero.

Bart.
