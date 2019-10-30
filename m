Return-Path: <SRS0=//Xo=YX=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EA4BCCA9EC5
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:24:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C295F20679
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Oct 2019 15:24:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726949AbfJ3PYs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Oct 2019 11:24:48 -0400
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41777 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726246AbfJ3PYs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Oct 2019 11:24:48 -0400
Received: by mail-pl1-f194.google.com with SMTP id t10so1136704plr.8;
        Wed, 30 Oct 2019 08:24:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=5XiSSALIT9IX4x1ndYfnfB6J+j/tWSdimFbCRBrwIbY=;
        b=eGu/PmwhhBZFOElT7U/hWK0EnHBgzfw1a1YSNi8IGGH9jN5sMIJJeJPrsHqMMlJLPb
         cXB21F78haD5E09u5IDNS+sG5rEx5cqFl3xvtHYWqvjjMqtutge+eb6mEkVI3aYsbAXF
         /9I+l5Lu9mmV3Tn4cvv/iR0NfBhn/crtBwEYaaqcx+yKRDDkLQ0xkeuriyNlr6M9ghbp
         j7COUBvB94UaTK7z8gGfKjEuaYpyBFvp9WgwreOLu1fa6BSxYCLWI2X17YRHNxcaO6Go
         QtvMxsClAKlsqTy2WXt2icNsYpT4csRCy3xNhCN+Y7w9wyR4mz8LetZqEAah/UTaRg90
         1QRw==
X-Gm-Message-State: APjAAAVJgQogdUQYnkdeToF32bYjcUENOiopaDxCQfyHJq+zB7rEVKFT
        Iq5q/eOzG2kyXYYLP1a77g4=
X-Google-Smtp-Source: APXvYqy29Kof7dLdvZdRb0clq6VfXn8bbPtsxwxWKBNh55JyTbn3BkFoM3PBBlI4+tlOSHvN8yjvfg==
X-Received: by 2002:a17:902:467:: with SMTP id 94mr560995ple.115.1572449087207;
        Wed, 30 Oct 2019 08:24:47 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id c66sm334633pfb.25.2019.10.30.08.24.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Oct 2019 08:24:46 -0700 (PDT)
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
 <d0899d02-ecb2-7f0b-3d0a-c818a0ec6ceb@acm.org>
 <571b5f9a-f151-30fb-5720-d7d47a4ef1d7@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <cd135991-d5fb-770c-d5dc-d7658222785b@acm.org>
Date:   Wed, 30 Oct 2019 08:24:45 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <571b5f9a-f151-30fb-5720-d7d47a4ef1d7@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/30/19 8:18 AM, Hannes Reinecke wrote:
> On 10/30/19 4:12 PM, Bart Van Assche wrote:
>> I do not agree that reporting a residual overflow by calling 
>> scsi_set_resid(..., 0) is acceptable. For reads a residual overflow 
>> means that the length specified in the CDB (scsi_bufflen()) exceeds 
>> the data buffer size (length of scsi_sglist()). I think it's dangerous 
>> to report to the block layer that such requests completed successfully 
>> and with residual zero.
>>
> But that is an error on submission, and should be aborted before it even 
> got send to the drive.

If such a bug ever gets introduced in the SCSI core, I think that SCSI 
target code should detect and report it. If the SCSI core receives a 
response with a residual overflow it can then take appropriate action, 
e.g. call WARN_ON_ONCE().

Users of sg_raw can trigger the residual overflow case easily.

> However, this does not relate to the residual, which is handled after 
> the command completes (and which sparked this entire thread ...).

I'm still waiting for an answer to my question of how SCSI LLDs are 
expected to report a residual overflow to the SCSI core.

Thanks,

Bart.
