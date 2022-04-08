Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0474C433F5
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 16:56:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233516AbiDHQ6c (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 12:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232609AbiDHQ6b (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 12:58:31 -0400
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC745249895
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 09:56:27 -0700 (PDT)
Received: by mail-pg1-f180.google.com with SMTP id q19so8253597pgm.6
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 09:56:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Z3zuuQyjDIR40TIxvxF82iwP7VTwFcgLYRNgSdpQtaY=;
        b=01gi8h7M167x8YwoNrpQfcIiKYdOXZArDA3pOlaQYsAnHuRrvFyQF1fw6fr5vNLQuL
         9cLTdvau3QpmBvKFfwzVP2iH+V5Li1T6++2tPa/2fRxNNAs4nCUmoVU9MtSDvqZY5mii
         A43D9r7EzcsbPz/zmBnWmIdQFSIrGk+pGcQB7dqaNEVb+eKR/FsxckzeVs9TtxeV9GK1
         7cvkVRmpzl5zQkEdKAse2bCiB4QIwIUkofKss3T9yG3HfJXTHo6/uHybtR8lHVSxlNfq
         N62ogBSNPQmY04W0/wJQDca8yaELh0zveGx9Vgke4tZY1vBUwiW3xNqbQv1vm2cjkji1
         kqrQ==
X-Gm-Message-State: AOAM533NyVo+3C7jxCY9DbNCyUhyjLcuILUpgiIXcuOuWXxK+ULNgbjE
        OWL8pbsNcocVjveELSjoRsg=
X-Google-Smtp-Source: ABdhPJxJEI2ozUfg84s9TszruFudyJJ5+LX1+DgWE1XDKT74e2Rdd4rWqWa2yO3RlY9ux80xBZVPrg==
X-Received: by 2002:a63:4e62:0:b0:398:cb40:19b0 with SMTP id o34-20020a634e62000000b00398cb4019b0mr16342875pgl.445.1649436987092;
        Fri, 08 Apr 2022 09:56:27 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id q22-20020a056a00085600b004fb308e393csm28478008pfk.178.2022.04.08.09.56.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 09:56:26 -0700 (PDT)
Message-ID: <7556e509-3933-f65a-3850-4925e19eaae7@acm.org>
Date:   Fri, 8 Apr 2022 09:56:24 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
Content-Language: en-US
To:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Prayas Patel <prayas.patel@broadcom.com>
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-4-sumit.saxena@broadcom.com>
 <20220408051351.GA31826@lst.de>
 <d5cd2ee3-2520-6fc6-0292-0efbc7f34a65@acm.org>
 <CAFdVvOwj43jDSj78JFMPPHdc_9QvJt3e-dDZ9yuHAF+Ut3At+g@mail.gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAFdVvOwj43jDSj78JFMPPHdc_9QvJt3e-dDZ9yuHAF+Ut3At+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/8/22 07:45, Sathya Prakash Veerichetty wrote:
> We can submit another patchset where we will move only structures
> which are used both by applications and drivers into the include/uapi
> and keep the remaining ones which are not used in the app into the
> older mpi3mr/mpi  folder.  However, I have a generic question on why
> we need to move the headers into uapi because the driver provides the
> transfer mechanism already in the uapi through app.h and the
> information transferred in through that is blob from the driver
> perspective and that goes to the controller directly and processed by
> the controller, only for specific cases like NVMe encapsulated
> command, to set up the DMA address the driver parse through the
> command.  Wouldn't it make sense to keep all of the
> controller/firmware related structures along with the driver and
> expose only the transport mechanism in the uapi?

Hi Sathya,

Please reply below the original email instead of above. From 
https://en.wikipedia.org/wiki/Posting_style:

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Regarding the question in your email: the convention in the Linux kernel 
is to define data structures that are needed by user space applications 
(and only those data structures) under the include/uapi directory. These 
data structures are not only exported to user space apps but also used 
by the kernel code that implements the user space API. This guarantees 
the correctness of these header files.

I can't find the app.h header file anywhere in the kernel tree. Hence my 
request to move the user space data structures and constant definitions 
into a header file under the include/uapi/ directory.

Thanks,

Bart.
