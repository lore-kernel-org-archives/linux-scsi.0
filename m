Return-Path: <SRS0=MVi0=Y4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DBACCA9EB5
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:45:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 455EC214E0
	for <linux-scsi@archiver.kernel.org>; Mon,  4 Nov 2019 17:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729411AbfKDRpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 Nov 2019 12:45:12 -0500
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46900 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728957AbfKDRpM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Nov 2019 12:45:12 -0500
Received: by mail-pf1-f193.google.com with SMTP id 193so11453674pfc.13
        for <linux-scsi@vger.kernel.org>; Mon, 04 Nov 2019 09:45:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=zKKFSmZUNA0t3ubYSb3/zWsKt/jr+gnz5pSEuBYG6yE=;
        b=J7cYTyBWEqS9mcrQ7U7H5vms3pxTjs+ZQW/6v1H9QYwNNiOoQ1kGicQF7vuJvNmaFJ
         mzJnjyl7BFB3zbgRfYRe9hpvdPWJbGTk4QGHNRX0kOJYHCIku6Fs84w8zlgYSlEUD82l
         kHYN4p4he5YJ1aJFgZqOeylBQOfzP8xUY7Mw2Q9bPETIa9TizSD11YRe5nxMfH721W02
         CLYgRqXOYa3qMlnDG5S1YK06jjIp33fdK50j2rT+MXVlBQg4Z3Tms2cJgPND3kdwEgBM
         oz2Ow9Q/ICQyCE7aBc8ALh2OgXhP6Dyj9WQg/8lLV2pJTkL2HzWcaqnxcLbcxMK/eFst
         mxYw==
X-Gm-Message-State: APjAAAVjsYidw1yqCT5zNrHugY8m+WQzMQyC+zaSwyeUg5NGGun4t/qn
        49SK5GnVlYThd18OHHZLuRQQgBXS
X-Google-Smtp-Source: APXvYqzsF0W8PCijqA6u6Tl9wCvrse5lkufwraH+4COmwVc7+c5e6C38pzvBvS3sak4/TVbBQa3tAg==
X-Received: by 2002:a17:90a:858a:: with SMTP id m10mr444085pjn.128.1572889511193;
        Mon, 04 Nov 2019 09:45:11 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id a66sm6049644pfb.166.2019.11.04.09.45.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Nov 2019 09:45:10 -0800 (PST)
Subject: Re: [PATCH 18/52] scsi: change status_byte() to return the standard
 SCSI status
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
References: <20191104090151.129140-1-hare@suse.de>
 <20191104090151.129140-19-hare@suse.de>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <e768768e-d31d-9715-8e0b-3532c5318639@acm.org>
Date:   Mon, 4 Nov 2019 09:45:07 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191104090151.129140-19-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/4/19 1:01 AM, Hannes Reinecke wrote:
> Instead of returning the linux-special status (which is shifted
> by 1 to the right) change the status_byte() macro to return the
> correct SCSI standard status.
> And audit all callers to handle this change.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

