Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B46D7C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 16:12:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 933E46058D
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Oct 2021 16:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233885AbhJYQOj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Oct 2021 12:14:39 -0400
Received: from mail-pl1-f180.google.com ([209.85.214.180]:35553 "EHLO
        mail-pl1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230177AbhJYQOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Oct 2021 12:14:38 -0400
Received: by mail-pl1-f180.google.com with SMTP id n12so3596566plc.2;
        Mon, 25 Oct 2021 09:12:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=+qW5evmThMV91an/ENDTvnEGIo+rhzLqS9sPVu9KTo0=;
        b=Z0s5Fl2Iz0+mpHIhnsolAllWc9OqtAtaAqFV2/oWUxjnvtDo0Obx6jlfGGoLIWurrE
         3jnK2BuW0y7G4LspCj6gwQbiNUVIpooMQegvQYgAiCk07N8VPORTylozB/qgeFw0bheT
         Z+T5U3/3hLi1QIkZfqrGsL+s9Fi/61FQnGe/dMTF0dEQ2tvle+zCBxJVgUNyMyVn/8vM
         wldFSHEMXltnbaClCAnyIL6jpdZOfCVm33r3iZENenZ9A2g1sI0lUgEiGPF97ZWCN68e
         bLNhBEc/Sb7oTgHeT09giXMDvnnm2/SI3f2XbcBkovA1za47kxXbxth+lsb35yDm4hcR
         kYdg==
X-Gm-Message-State: AOAM532KqIRaeMmN4rLgVgWocRvCe+Ok6p2kFZVOKpIbHJXXlEX+afn+
        H2RzVhBFHUHFQ4t2waVub48=
X-Google-Smtp-Source: ABdhPJw8kxOk107Tm99wsQRBcZYYFyQvHZD3wFAvArs6FbOm1vw/qzhSzJB55/WSkW+gvppMcSCbgg==
X-Received: by 2002:a17:90a:764e:: with SMTP id s14mr6742822pjl.221.1635178336018;
        Mon, 25 Oct 2021 09:12:16 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:f863:1daa:afe1:156])
        by smtp.gmail.com with ESMTPSA id z8sm16847102pgc.53.2021.10.25.09.12.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 25 Oct 2021 09:12:15 -0700 (PDT)
Subject: Re: [PATCH] scsi: ufs: revert HPB support
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com,
        axboe@kernel.dk
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
References: <20211022062011.1262184-1-hch@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <4199e780-32e5-a1ce-65ba-85e0b7a3eda5@acm.org>
Date:   Mon, 25 Oct 2021 09:12:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211022062011.1262184-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/21/21 11:20 PM, Christoph Hellwig wrote:
> The HPB support added this merge window is fundanetally flawed as it
> uses blk_insert_cloned_request to insert a cloned request onto the same
> queue as the one that the original request came from, leading to all
> kinds of issues in blk-mq accounting (in addition to this API being
> a special case for dm-mpath that should not see other users).

I do not agree with removing the UFS HPB code from the upstream kernel 
at this time.

One of the HPB users promised to look into removing the 
blk_insert_cloned_request() call from the UFS HPB code. Shouldn't that 
person be given the chance to come up with a patch before removal of the 
UFS HPB code is considered?

Additionally, removing the UFS HPB code from the upstream kernel won't 
affect UFS users much. As far as I know all HPB users use Android. UFS 
HPB is supported by Android 12 and will also be supported by Android 13. 
Whether or not this patch is goes upstream won't affect the Android 
kernel. I am not aware of any plans to make any changes in the Android 
kernel UFS HPB code if this patch would be integrated in the upstream 
kernel.

Bart.
