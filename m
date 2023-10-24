Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7803C00A8F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 17:18:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343807AbjJXRSL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 13:18:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35212 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234423AbjJXRSK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 13:18:10 -0400
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CEC92122;
        Tue, 24 Oct 2023 10:18:03 -0700 (PDT)
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-5859a7d6556so3712974a12.0;
        Tue, 24 Oct 2023 10:18:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698167883; x=1698772683;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nFQ4hAaH4GHrD05T+wsusm8j3/kPx+eSR+g/+Vlb8Z8=;
        b=ieX4EFte9OIaV6pgFhciVL7DTGkS6uDCIDcy/OhWA4RJfoXF4tTZFCX7d40jdlYBUl
         +2CwWGeNQQFGhajIK9Js0hRr14wJSOCTwfH653Dugnq83WMf3+LKdM7Sck6InDgXjwE3
         99LhFmcDYRUISVuFn4EzsjvGH/e8r8X9GltepVLXP1HPiAXwHsnhIQUm7X0lxwCTi+q6
         9nTKezHdJO5Rzm+Whr/hYETfqqbtVu4u4Vh24qKs6wUroj3aEzlBZ1YZI2VnLoiQk70I
         LWQmivAjxPhI/BzKg8zbDBgu9H1MqvAnmN5NDGcVsjr+4LlAcNnVvrqTDvOyBj/CCpq4
         yZ6Q==
X-Gm-Message-State: AOJu0YznRS4zsdVEd8Nc1rmnHxCS6RLCqEGceCfN+qz+jvIYuy91slVY
        84W1I9cReHaUhad3YHH7eOI=
X-Google-Smtp-Source: AGHT+IGPlSNIkrhqV7jLbFyREFNNQY/SubkQm3MBkjek4omvgpyXiFLwlgl0Na5Y3TZskPt6VmOuIA==
X-Received: by 2002:a17:90b:2890:b0:27d:63ae:f376 with SMTP id qc16-20020a17090b289000b0027d63aef376mr13553789pjb.38.1698167883145;
        Tue, 24 Oct 2023 10:18:03 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:30e1:c9d3:6b41:493d? ([2620:15c:211:201:30e1:c9d3:6b41:493d])
        by smtp.gmail.com with ESMTPSA id h13-20020a17090ac38d00b0027cbc50b826sm9165245pjt.17.2023.10.24.10.18.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Oct 2023 10:18:02 -0700 (PDT)
Message-ID: <26ddfc1b-5290-4558-ae95-85fe01575c91@acm.org>
Date:   Tue, 24 Oct 2023 10:17:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v14 05/19] scsi: Add an argument to scsi_eh_flush_done_q()
Content-Language: en-US
To:     John Garry <john.g.garry@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-6-bvanassche@acm.org>
 <dcd4019f-93ae-5843-b10d-af912013b3fd@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dcd4019f-93ae-5843-b10d-af912013b3fd@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/23 02:26, John Garry wrote:
> On 23/10/2023 22:53, Bart Van Assche wrote:
> "Add an argument to scsi_eh_flush_done_q()" - that's too vague. I'd have 
> "Pass shost pointer to scsi_eh_flush_done_q()".

Thanks for having taken a look. I will change the subject.

> And I have to admit that it is painful to help review when only cc'ed 
> explicitly on a single patch.

The linux-scsi mailing list has been Cc-ed. I assume that you are
subscribed to that mailing list.

BTW, I'm using "scripts/get_maintainer.pl" to build a Cc-list. 
Unfortunately git send-email does not make it easy to combine the
cc-lists of individual patches into one cc-list for all patches :-(

Thanks,

Bart.
