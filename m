Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 366FEC3DA6F
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Aug 2023 01:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229928AbjHYBAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Aug 2023 21:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230018AbjHYBAX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Aug 2023 21:00:23 -0400
Received: from mail-pf1-f177.google.com (mail-pf1-f177.google.com [209.85.210.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 885E519B5;
        Thu, 24 Aug 2023 18:00:21 -0700 (PDT)
Received: by mail-pf1-f177.google.com with SMTP id d2e1a72fcca58-68a3b66f350so398204b3a.3;
        Thu, 24 Aug 2023 18:00:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692925221; x=1693530021;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jB2xRswWJa0klj7TJw27ybThB4/tZn3Dja5CUdH0AEA=;
        b=T3qwrro5Z++rCEXnXHtBSaiK3Lz6hj2MDiYJDFBq+EELF/ijXoxhAGcdUOqUwXcj3U
         0If80ChUpRs9p1YNjlvBDHtgsobr6OQ26cS5m4o37mX2i/F3u2LS/ac1+F8oQvuOQPmb
         0jlpTjVyuoQKmGMAJRHvvIw2j4nbxOFn9YElodTNAgVpaQONihN5nkWI0yDyGbuC/pK3
         p00MujHUhvbcO1UiNx1Vh3w2J+BeJUo5RFbrQR0VsBi2gLgr4y961JNFymvD/YGi3VK/
         f4GfJKD9Y5iCx/c/9PdEWy3EJgaF39//Zq4NBXxxySHf7HS8mwkOVPlYMLDGdOsLqKz+
         msWw==
X-Gm-Message-State: AOJu0YyIuOrpOKkZ2rp+ic0YfMDh3Il14DjDzN/H6qgy+2/hZslAziso
        z1Chm0h478UcohuSyOIJnR0=
X-Google-Smtp-Source: AGHT+IHLI2s1q9v/JFg0bDQlKf45MGO1AWW/E3PjJecMe0+ksEhsT/rTY9FImsrICm4gBeNGRszsxg==
X-Received: by 2002:a05:6a20:3215:b0:14c:512c:60d9 with SMTP id hl21-20020a056a20321500b0014c512c60d9mr1145750pzc.27.1692925220830;
        Thu, 24 Aug 2023 18:00:20 -0700 (PDT)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id 5-20020aa79245000000b0068bbd43a6e2sm358016pfp.10.2023.08.24.18.00.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Aug 2023 18:00:20 -0700 (PDT)
Message-ID: <d9938e36-0a8c-49c6-89bf-73f9677253c3@acm.org>
Date:   Thu, 24 Aug 2023 18:00:19 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 04/16] scsi: core: Introduce a mechanism for
 reordering requests in the error handler
To:     Damien Le Moal <dlemoal@kernel.org>,
        Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
References: <20230822191822.337080-1-bvanassche@acm.org>
 <20230822191822.337080-5-bvanassche@acm.org>
 <3562fc36-4bc2-b4fb-a2ad-1e310baf1b47@suse.de>
 <078d2954-f4af-6678-29ce-d8f65ff1397a@acm.org>
 <741e19ae-d4fd-11f5-7faa-18b888ff769c@kernel.org>
 <6355b575-3f59-93dc-5acf-4726c6e80a15@acm.org>
 <5c36ae01-a806-a36b-0196-41c217f78307@suse.de>
 <1e54cf7a-4e8f-4539-6677-d6bf0ec88ea5@acm.org>
 <5b94bd2d-78a0-b94b-621c-1732e2cce58c@kernel.org>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <5b94bd2d-78a0-b94b-621c-1732e2cce58c@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/23 16:53, Damien Le Moal wrote:
> I think that Hannes point was that if you ensure that the rejected regular write
> commands used to emulate zone append when requeued go through the sd driver
> again when resubmitted, they will be changed again to emulate the original zone
> append using the latest wp location, which is assumed correct. And that does not
> depend on the ordering. So requeuing these regular writes does not need sorting.
> It can be in any order. The constraint is of course that they must be re-preped
> from the original REQ_OP_ZONE_APPEND every time they are requeued.

Hi Damien,

Although this is a possible approach, I do not agree that this is a better
approach. Compared to the patch series that I posted, the disadvantages of
this approach are as follows:
* It relies on the zone append emulation. Although that emulation is not too
   complicated, it adds more code in the hot path. The spin lock in the zone
   append emulation is expected to cause performance issues at the performance
   levels supported by UFS devices. Current UFS devices already support more
   than 300 K IOPS and future UFS devices are expected to support even higher
   performance.
* It would be challenging to derive the write pointer in the error handler
   without submitting a REPORT ZONES command to the storage device. This
   means that the error handler becomes more complicated.

In summary: the feedback is appreciated but I do not agree that the zone
append approach is a better approach for UFS devices than the approach of
this patch series.

Thanks,

Bart.

