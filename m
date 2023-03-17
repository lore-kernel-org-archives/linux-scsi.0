Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A6C8C6FD1D
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Mar 2023 16:56:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229908AbjCQQ4g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Mar 2023 12:56:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjCQQ4e (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Mar 2023 12:56:34 -0400
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7636269069;
        Fri, 17 Mar 2023 09:56:33 -0700 (PDT)
Received: by mail-pj1-f45.google.com with SMTP id 6-20020a17090a190600b00237c5b6ecd7so9785997pjg.4;
        Fri, 17 Mar 2023 09:56:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679072193;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/EDMCWi2+pIYPO7/XjcMvWvrVqhfRSJwEgLRyN06IhM=;
        b=eNZ8URL7CJMXzDPLLKm28Rz2w5vZQej7Uh290IeqenDX9GBj0dIPI9eCAZypzGzlk4
         LeNxp6BcvZ+6X0wQe0QM38sEPo/qxgn70vyysK62Z8rvjTfe1cjksizNUNqd6KsnTaxS
         qk/7mso6xVsikzOQkzUTMVVLJXwDloRx2vfubBLoebfLEzRT8qPTF4XKyg9CMlVs61K3
         OOXNS6ikh5oK3Wd/p09fVETX3Zn1ZRC69X7Wp+iqvKzkWt/AU2TI+KUg8JmuU+O3Dxow
         +Lk5i7wxeevL9QugbM4n6wB7aJ07zdlji5vldiXnOBriXz/dUl02BLACymkuXXAfnpw6
         62fA==
X-Gm-Message-State: AO0yUKXW2olrazvML7pW6BijlBBUQIXsVG5LbITTTT8Bzf5Of5r98sTX
        +n1IwKJclHBs7JAC+7YWihk=
X-Google-Smtp-Source: AK7set9+vucF+M5QAaPH0ImOhBRU8mJ5PzWB43bOiUM7l98DemgZa5Ck1nVTRJiWD4OsyqVp6HnShg==
X-Received: by 2002:a05:6a20:b915:b0:d7:380b:660 with SMTP id fe21-20020a056a20b91500b000d7380b0660mr4467704pzb.3.1679072192555;
        Fri, 17 Mar 2023 09:56:32 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:ad26:bef0:6406:d659? ([2620:15c:211:201:ad26:bef0:6406:d659])
        by smtp.gmail.com with ESMTPSA id e25-20020a62aa19000000b005a817ff3903sm1819707pff.3.2023.03.17.09.56.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Mar 2023 09:56:31 -0700 (PDT)
Message-ID: <86bbac36-f727-7330-bfcc-a4cd5a544d6c@acm.org>
Date:   Fri, 17 Mar 2023 09:56:29 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v4 02/19] block: introduce ioprio hints
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20230309215516.3800571-1-niklas.cassel@wdc.com>
 <20230309215516.3800571-3-niklas.cassel@wdc.com>
 <c91be70e-14a9-7ad6-ba7c-975a640a34d3@opensource.wdc.com>
 <70b757f9-cc0c-ebd9-a597-f6ea14acbedb@acm.org> <ZBQxoRQ4/7au/1ou@x1-carbon>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <ZBQxoRQ4/7au/1ou@x1-carbon>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/17/23 02:23, Niklas Cassel wrote:
> When you have the time, we would be very grateful if you could provide
> a more thorough review, i.e. provide a R-b tag or give some feedback.
> 
> Your help is appreciated!

Although I'm overloaded, I will try to find some time to review this 
patch series.

Thanks,

Bart.

