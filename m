Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6F65C61DB3
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Jan 2023 02:52:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232579AbjA1Cwv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Jan 2023 21:52:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229681AbjA1Cwu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jan 2023 21:52:50 -0500
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39834D539;
        Fri, 27 Jan 2023 18:52:49 -0800 (PST)
Received: by mail-pj1-f44.google.com with SMTP id n20-20020a17090aab9400b00229ca6a4636so10476172pjq.0;
        Fri, 27 Jan 2023 18:52:49 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZHQOQ6R8ASWCKHlGKTyH8naBVtDUcQjGA8igjjG1pmI=;
        b=SJG7IYD1ZSOKG43IH84QfkjI9PDOHCC8DmjbG886zrpeDHMggxslX1Uwr1POjKxSEU
         o7tWvg9L65FYjyZcBRez4sLzqalwlw1paojmRniCfLgWu+Hu1T77r5pDQ+hnVyXTKAYj
         TMdxTwgRTd5UBNW26k5mLNOWZT0GcJk/7q17mI6tBGZraCAzLhLOUVvyvENKGWffym+y
         GZoMYHVFjJU7WeUbIGOFzjpB34hSGBJ1g5GDHHiwrmtDPmm0qNzhRkYXgwGhUNqpsnqV
         aLb7k9G03A5xHBZSj7epRhIsBdg2rDOnWcbksOz1USrSVo1nUPOEBNTMUby0juA2f755
         cWPg==
X-Gm-Message-State: AO0yUKU1+J8y/nbp8r1lp9Glb9wkvCmGH7ewprCXqasXYTRQhOv25SOW
        cvDX/dVuu4C4Lf88G2S/gYV8RUWcUGc=
X-Google-Smtp-Source: AK7set8uhka1/iDnT3MlG5hhBNQGAuJK3o7FYML0Pb9x14xRMs0QpyX+1wJvzOWVIsuDle1j8MwtQw==
X-Received: by 2002:a17:903:22c2:b0:196:2bdb:b600 with SMTP id y2-20020a17090322c200b001962bdbb600mr14318050plg.32.1674874368588;
        Fri, 27 Jan 2023 18:52:48 -0800 (PST)
Received: from [192.168.51.14] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id l16-20020a170903121000b0019602dd94f1sm3536422plh.13.2023.01.27.18.52.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Jan 2023 18:52:47 -0800 (PST)
Message-ID: <f9fe4e54-563a-c8fa-23ae-88780c4edc54@acm.org>
Date:   Fri, 27 Jan 2023 18:52:46 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v3 07/18] scsi: sd: detect support for command duration
 limits
Content-Language: en-US
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Hannes Reinecke <hare@suse.de>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-8-niklas.cassel@wdc.com>
 <f0793325-3022-e7b8-672d-00f2f9ee0cd9@suse.de>
 <99e6b267-6e2e-2233-19c2-1acf7c9135b2@opensource.wdc.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <99e6b267-6e2e-2233-19c2-1acf7c9135b2@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/23 16:51, Damien Le Moal wrote:
> On 1/27/23 22:00, Hannes Reinecke wrote:
>> Hmm. Calling this during revalidate() makes sense, but how can we ensure
>> that we call revalidate() when the user issues a MODE_SELECT command?
> 
> Given that CDLs can be changed with a passthrough command, I do not think we can
> do anything about that, unfortunately. But I think the same is true of many
> things like that. E.g. "let's turn onf/off the write cache without the kernel
> noticing"... But given that on a normal system only privileged applications can
> do passthrough, if that happens, then the system has been hacked or the user is
> shooting himself in the foot.
> 
> cdl-tools project (cdladm utility) uses passtrhough but triggers a revalidate
> after changing CDLs to make sure sysfs stays in sync.
> 
> As Christoph suggested, we could change all this to an ioctl(GET_CDL) for
> applications... But sysfs is so much simpler in my opinion, not to mention that
> it allows access to the information for any application written in a language
> that does not have ioctl() or an equivalent.
> 
> cdl-tools has a test suite all written in bash scripts thanks to the sysfs
> interface :)

My understanding is that combining the sd driver with SCSI pass-through 
is not supported and also that there are no plans to support this 
combination.

Martin, please correct me if I got this wrong.

Thanks,

Bart.

