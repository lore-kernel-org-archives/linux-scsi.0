Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ECAB9C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 00:33:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229909AbiGLAdu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230255AbiGLAds (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 20:33:48 -0400
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3AA618390
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:33:47 -0700 (PDT)
Received: by mail-pl1-f174.google.com with SMTP id l12so5832949plk.13
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:33:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=I8g9MXjRls0eJR4xYf/Z1DQAuCGRU1jmqT1vhxpcI50=;
        b=h8UYWYCjLIyUSQrX3COeTnSqj6Wd4jDWNQFzSgh8RtZzhHhq0GY3AyR6d1Skb8H7k8
         ss1+bMvnOY0j/76/bbwQNBOFDRQAJmmJWUBWDpqrlxXbeetx9ctDc6f60Ps6kCq4zeKc
         rGbMS5NVLTzeCkY3N/SqWqIFplPjckedKbExwOzKIjt9yH661n+eY7O/nsu5TimK4ZVW
         ZdpIt7UupVb/8qZPzI5zxTVDC3FqGE/enLFUpCmq8Z6/Yhn2IbzLnljzF7dycYRLoeIZ
         tlU0w55lLuc3A/egMo8X4IpOqhyvs73sdS6Cimb6YLLmfHohk0gCs+zKXUM/bor40EhM
         iWnQ==
X-Gm-Message-State: AJIora+lg9LwiCZplyl2x6SYFuMn0bNr7vJHL+LCpQGgrkeBcrPfp786
        8Q7eU6z5szInLpbnB1bK7o4=
X-Google-Smtp-Source: AGRyM1snstLGyJxGFzkVHbYi8QtH+ohWUm2ynsB2rdKHo0XE2NPAsqAWvEM+/Km6MttEo/QrsmOA7g==
X-Received: by 2002:a17:902:6503:b0:16a:4db1:8d5a with SMTP id b3-20020a170902650300b0016a4db18d5amr21854953plk.133.1657586026924;
        Mon, 11 Jul 2022 17:33:46 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id c5-20020a170902d48500b001638a171558sm5346952plg.202.2022.07.11.17.33.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Jul 2022 17:33:46 -0700 (PDT)
Message-ID: <35c22b90-13d5-10b9-4677-fd3214298105@acm.org>
Date:   Mon, 11 Jul 2022 17:33:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] scsi_debug: Make the READ CAPACITY response compliant
 with ZBC
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-3-bvanassche@acm.org>
 <625056aa-0604-d1a9-e1a1-0efef70a5de1@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <625056aa-0604-d1a9-e1a1-0efef70a5de1@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/11/22 16:19, Damien Le Moal wrote:
> Note that I think this entire patch could be reduced to just doing this:
> 
> 	if (devip->zmodel == BLK_ZONED_HM) {
> 		/* Set RC BASIS = 1 */
> 		arr[12] |= 0x01 << 4;
> 	}
> 
> No ?

Hi Damien,

The above looks valid to me from the point-of-view of the ZBC-spec. 
However, reducing patch 2/3 to the above would reduce the number of code 
paths in the sd_zbc.c code that can be triggered with the scsi_debug driver.

Thanks,

Bart.
