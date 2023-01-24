Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E29CDC61D97
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 20:32:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233983AbjAXUci (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 15:32:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjAXUch (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 15:32:37 -0500
Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3395E4A1F5;
        Tue, 24 Jan 2023 12:32:36 -0800 (PST)
Received: by mail-pj1-f48.google.com with SMTP id u1-20020a17090a450100b0022936a63a21so19860300pjg.4;
        Tue, 24 Jan 2023 12:32:36 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MRLbM6oiJ1QftHSOm/qd3LNPBpHZQaBYTRDMNWAHmcE=;
        b=N1S8VN9oemIpQ4CVQ0Xjrbc6pQHVsPC4nRvxobmxP+qZqZW1m8rFwQCYGSS2cpqtIm
         yxfiygaZSFsogqKDc3Zd4/Q2WpPbggadPzW+RIEQHaIM2n9haUxZxVX9rW0MfCeUhTdB
         F71wz9gBwwywDL8sZ4ofCpSFZ6+w1Ym5VIzbnj4fywcEvrNnYr4iZ+keHRekUhyfqpYY
         THgeohoN9/RvNW4R2VGb/R6l91CNdwsxi0E+84gRQ8dW+SsJYfzHoJzza4Td9SKco6uy
         s0VfkHQ40DhNnrlYbE6FzbNXncmyhIYAjZuPKRB4SWWgyiwbBmYPyALBietNRmCzZvTT
         aFsw==
X-Gm-Message-State: AFqh2kpPRSZfxs83LtCTm/gdf95mcA5aaim1wc7P2WZ3/4PaW5IsdOBS
        WYZXzF11D56+0p4MpLYBQsc=
X-Google-Smtp-Source: AMrXdXt/0cv+RxYDWkSC+nI6MnkTCay37uiKfqsw65sY7I4TS/Ps5COm4BXrj978PTiKq/ROwMEFCQ==
X-Received: by 2002:a17:902:b598:b0:194:645a:fa9a with SMTP id a24-20020a170902b59800b00194645afa9amr28795976pls.8.1674592352224;
        Tue, 24 Jan 2023 12:32:32 -0800 (PST)
Received: from ?IPV6:2620:15c:211:201:c69a:cf2c:dc2d:7829? ([2620:15c:211:201:c69a:cf2c:dc2d:7829])
        by smtp.gmail.com with ESMTPSA id jc11-20020a17090325cb00b00189c62eac37sm2105659plb.32.2023.01.24.12.32.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jan 2023 12:32:31 -0800 (PST)
Message-ID: <a127b2d1-b7b0-66e4-5af1-bd292a46e752@acm.org>
Date:   Tue, 24 Jan 2023 12:32:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Keith Busch <kbusch@kernel.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
 <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
 <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <Y9A4s5tlsdx0S8s4@kbusch-mbp.dhcp.thefacebook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/24/23 11:59, Keith Busch wrote:
> On Tue, Jan 24, 2023 at 11:29:10AM -0800, Bart Van Assche wrote:
>> On 1/24/23 11:02, Niklas Cassel wrote:
>>> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
>>> report command that failed due to a command duration limit being
>>> exceeded. This new status is mapped to the ETIME error code to allow
>>> users to differentiate "soft" duration limit failures from other more
>>> serious hardware related errors.
>>
>> What makes exceeding the duration limit different from an I/O timeout
>> (BLK_STS_TIMEOUT)? Why is it important to tell the difference between an I/O
>> timeout and exceeding the command duration limit?
> 
> BLK_STS_TIMEOUT should be used if the target device doesn't provide any
> response to the command. The DURATION_LIMIT status is used when the device
> completes a command with that status.

Hi Keith,

 From SPC-6: "The MAX ACTIVE TIME field specifies an upper limit on the 
time that elapses from the time at which the device server initiates 
actions to access, transfer, or act upon the specified data until the 
time the device server returns status for the command."

My interpretation of the above text is that the SCSI command duration 
limit specifies a hard limit, the same type of limit reported by the 
status code BLK_STS_TIMEOUT. It is not clear to me from the patch 
description why a new status code is needed for reporting that the 
command duration limit has been exceeded.

Thanks,

Bart.
