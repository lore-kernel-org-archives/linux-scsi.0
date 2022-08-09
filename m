Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C489C3F6B0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 19:33:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245171AbiHITck (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 15:32:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346291AbiHITbX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 15:31:23 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59F232250A;
        Tue,  9 Aug 2022 12:31:22 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id b4so12645152pji.4;
        Tue, 09 Aug 2022 12:31:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=tEEBECMt2JMCyk8XPkBX4uFGE3X1j9GMANI0TyJE5wc=;
        b=LRubxvAy2ALehugLqD1nIHa1pRk+gQtTIas0+nQlfnDX/mbX6xM8e8GhzHY5AhRtXc
         rdSTz/WFWtysolS2IHFPvd9o15dT6XP4GjLPQbvgmRYviJLibkOj/nmXu7yw+9MHRSzr
         1OI6gB52SA7qQ8Yy1DZ9BNb1wUTB5poIwn0u0ccCOF7AwP9a1rK3kYGGS65SvK+CHy7w
         4JvegyMg6mw7l/aD+veLKI0br0mB9g/AglX+qk42v/tI8igu+XkMEyxuxfVvWu4goc22
         ZeunYW9e3JgVafG7+w3DweBeFqpo6fPHEo48NOYW/vFLUI0j1zX45KtyugmsyQEBbCme
         MuHA==
X-Gm-Message-State: ACgBeo1uFP+eJ08dAqmkwKU3Eeu++KaMi6uIg0uM4FvhB1gjtRNT/B8s
        jdRV2YebFAuUj4HINRG98iU=
X-Google-Smtp-Source: AA6agR5ZL0koW3EeIcBB5kMJj6MK9Gs4GzdlJ/nY6Ucb+iCE6MSghHnDdd0Y6rdswP+L8s03kMtJug==
X-Received: by 2002:a17:902:e5cc:b0:16f:1153:c519 with SMTP id u12-20020a170902e5cc00b0016f1153c519mr24584729plf.151.1660073481696;
        Tue, 09 Aug 2022 12:31:21 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:61e9:2f41:c2d4:73d? ([2620:15c:211:201:61e9:2f41:c2d4:73d])
        by smtp.gmail.com with ESMTPSA id np15-20020a17090b4c4f00b001f31d6fe0f3sm13133214pjb.57.2022.08.09.12.31.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Aug 2022 12:31:20 -0700 (PDT)
Message-ID: <c6e96f39-69e0-b1f3-93c5-b9912e2af270@acm.org>
Date:   Tue, 9 Aug 2022 12:31:18 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA is returned.
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>,
        Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Martin Wilck <mwilck@suse.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-15-michael.christie@oracle.com>
 <20220809071632.GA11161@lst.de>
 <bf55356d-24fe-7a8e-c766-cdf33e7304c2@oracle.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <bf55356d-24fe-7a8e-c766-cdf33e7304c2@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 09:24, Mike Christie wrote:
> On 8/9/22 2:16 AM, Christoph Hellwig wrote:
>> On Mon, Aug 08, 2022 at 07:04:13PM -0500, Mike Christie wrote:
>>> It's common to get a UA when doing PR commands. It could be due to a
>>> target restarting, transport level relogin or other PR commands like a
>>> release causing it. The upper layers don't get the sense and in some cases
>>> have no idea if it's a SCSI device, so this has the sd layer retry.
>>
>> This seems like another case for the generic in-kernel passthrugh
>> command retry discussed in the other thread.
> 
> It is.

Has it been considered to introduce a flag that makes scsi_noretry_cmd() 
retry passthrough commands?

Thanks,

Bart.
