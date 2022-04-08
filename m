Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6213AC433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Apr 2022 14:37:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234844AbiDHOjm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Apr 2022 10:39:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233108AbiDHOjl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Apr 2022 10:39:41 -0400
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 010274EDF9
        for <linux-scsi@vger.kernel.org>; Fri,  8 Apr 2022 07:37:37 -0700 (PDT)
Received: by mail-pl1-f180.google.com with SMTP id be5so2047965plb.13
        for <linux-scsi@vger.kernel.org>; Fri, 08 Apr 2022 07:37:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=SwEJkNl43IT3YuJCwaCBIHOwKkvbcOqMlfEnM+hp7vY=;
        b=cPwajJ00tY4d5TOtnPxinyVCesrGfpN4sbXVUQG33knt4V+nP05t/e1YMtJ4psCxn+
         BuMqZymBZAwJ+tM0YbUv5XiagDwBlAx0w+QL4sNtlP8PGIx9olG9QQRcruN2bghScoUI
         +CnyBtwXOJXhwT3VMwl+Frlu2UKjak+kmmGQTlPJ2lP8d/tNIL7o5kjYA2+PYr11Yiba
         WS3rOuGHIhB21paOmswCyFFuR+ViJtFDzcZYcC7RIlcJRG4QxEheSnO40/jagtYZ26/X
         xOrJvlNAIU7SYJpzyO9KNtgP0zLXJf1RPN3hby7RRV5jGQr+wx/Ll9ZtQleXbHPEUxrY
         AiFg==
X-Gm-Message-State: AOAM531YsRpJP8JRm4nIUP2+bm62bYtcQwjYKQR5rt8Q+Pl+AwwueXYY
        MB91stADrMexeVjDcQCdgHE=
X-Google-Smtp-Source: ABdhPJxIvtpHH5YYAXi6O442vnByGCUj3gxxvWUgvzfYgX33Tn6UAE5MPUYsn1kGfUoyjoftVZhC5A==
X-Received: by 2002:a17:90a:9416:b0:1ca:c87b:9439 with SMTP id r22-20020a17090a941600b001cac87b9439mr22293984pjo.71.1649428657346;
        Fri, 08 Apr 2022 07:37:37 -0700 (PDT)
Received: from ?IPV6:2601:647:4000:d7:feaa:14ff:fe9d:6dbd? ([2601:647:4000:d7:feaa:14ff:fe9d:6dbd])
        by smtp.gmail.com with ESMTPSA id bg13-20020a17090b0d8d00b001caa8f51098sm12096881pjb.9.2022.04.08.07.37.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 08 Apr 2022 07:37:36 -0700 (PDT)
Message-ID: <d5cd2ee3-2520-6fc6-0292-0efbc7f34a65@acm.org>
Date:   Fri, 8 Apr 2022 07:37:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v3 3/8] mpi3mr: move MPI headers to uapi/scsi/mpi3mr
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>,
        Sumit Saxena <sumit.saxena@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        chandrakanth.patil@broadcom.com, sreekanth.reddy@broadcom.com,
        prayas.patel@broadcom.com
References: <20220407192913.345411-1-sumit.saxena@broadcom.com>
 <20220407192913.345411-4-sumit.saxena@broadcom.com>
 <20220408051351.GA31826@lst.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20220408051351.GA31826@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/7/22 22:13, Christoph Hellwig wrote:
> On Thu, Apr 07, 2022 at 03:29:08PM -0400, Sumit Saxena wrote:
>> MPI headers are used by user space applications so
>> it makes sense to move them to uapi/scsi/mpi3mr.
> 
> I think this is a horrible idea.  These headers are a huge and a bit of
> a mess, and no we need to provide uapi guarantees for them.

Hi Christoph,

Although I agree with the above: my understanding is that this patch 
series adds a new NVMe pass-through mechanism but without adding the 
necessary declarations under include/uapi. That is why I asked recently 
to move the necessary declarations into the include/uapi directory.

Bart.
