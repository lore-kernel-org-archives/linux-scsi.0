Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02D7AC761A6
	for <linux-scsi@archiver.kernel.org>; Tue,  4 Apr 2023 09:30:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234179AbjDDJaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 4 Apr 2023 05:30:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233200AbjDDJaH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2023 05:30:07 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B85AE1BF1
        for <linux-scsi@vger.kernel.org>; Tue,  4 Apr 2023 02:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680600560;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=90t9qlvXCEkn6jRJkX8e3MPo0b4uyOK8JkGmrXtq0Eg=;
        b=Qbk6UrTlucHGgs50ziEx+ImiILVftO4sW1eG7wTEoTeEFV0sigom9eyuOr/Cpf+0yUwS5o
        SwlzVFVlW3O4CjTUE4keNwQtxdkGsBO80Htdm4jW+aj5mI0aH1PbdGo1lT4PnsM70gLhPk
        QgwQp2aA0bmu5V30+JYb1cLEc8ED8nc=
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com
 [209.85.208.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-211-kq7XSDhZOG2IGMVKmpmeIQ-1; Tue, 04 Apr 2023 05:29:18 -0400
X-MC-Unique: kq7XSDhZOG2IGMVKmpmeIQ-1
Received: by mail-ed1-f72.google.com with SMTP id j21-20020a508a95000000b004fd82403c91so44867941edj.3
        for <linux-scsi@vger.kernel.org>; Tue, 04 Apr 2023 02:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680600556;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=90t9qlvXCEkn6jRJkX8e3MPo0b4uyOK8JkGmrXtq0Eg=;
        b=a97JJpnCCWj+0FRDRSQkmm8dPTpsqzxZjDZyKZ1LY9gLDDOAqbz17s1kBPraSjSU27
         A07oCIiUCmn6wM3Cubtk5cZY+LGlqkR4wPlDF+ZjikTzPtIOqurOC/MRBteAX+S6Vy/y
         IEO5uk5gz31KxtxC64yKHC7R+YEuiEQ2Rid5evCpM4pV5WcWGe6jn/G1hPRO7k+fYc3s
         2IPdydCzg+ooO73MfzACEs4FzIdbvP+Au2O9xYPY+zymaIUndQ/jHmuN6ExMmYYDw7Q1
         0jfNLDrzYUiXO38zaH375mJvC2d1ijhqpUacs2ty3agsbTtwhkuCEphm0URv9FLlrYpD
         8FWw==
X-Gm-Message-State: AAQBX9cj7gaRPmaduugpPeTv8T+Voa/5eRpADAGfMTIav72j9ePphh/H
        J8H5H+8cZnDzGUhHxn+aED575fD1DNTn6NfdVZNQ6/Q3sxz48K37Wyg9zbTbqzq/vetguc9LxvP
        o5oSS9e2GNYRYoe4YWGoRF/t5hJ59Dw==
X-Received: by 2002:a17:906:44b:b0:93b:d1ee:5f41 with SMTP id e11-20020a170906044b00b0093bd1ee5f41mr1573540eja.31.1680600556723;
        Tue, 04 Apr 2023 02:29:16 -0700 (PDT)
X-Google-Smtp-Source: AKy350ZDlpAaiC+/MWG7nwi0HYuu4GQ3JuOdbn5jdofZ8TotqsNpShc+E3HKa35p6Iw9MMmt4HGUMQ==
X-Received: by 2002:a17:906:44b:b0:93b:d1ee:5f41 with SMTP id e11-20020a170906044b00b0093bd1ee5f41mr1573523eja.31.1680600556414;
        Tue, 04 Apr 2023 02:29:16 -0700 (PDT)
Received: from [192.168.0.107] (ip4-83-240-118-160.cust.nbox.cz. [83.240.118.160])
        by smtp.gmail.com with ESMTPSA id cw16-20020a170906c79000b0093dce4e6257sm5642622ejb.201.2023.04.04.02.29.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Apr 2023 02:29:15 -0700 (PDT)
Message-ID: <4112a14d-924a-e070-6687-33a30a4475a5@redhat.com>
Date:   Tue, 4 Apr 2023 11:29:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
To:     Bart Van Assche <bvanassche@acm.org>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
References: <20230330164943.11607-1-thenzl@redhat.com>
 <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
 <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
 <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
 <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
 <33501374-2cc7-ba1c-9d42-0da2aeed4341@redhat.com>
 <0afc900c-2717-6751-de54-9f65bf127484@acm.org>
 <3b5cf6e6-9dec-880f-7807-6d0461cbf514@redhat.com>
 <eb5335bc-760d-4591-8a73-71f10dcd8155@acm.org>
Content-Language: en-US
From:   Tomas Henzl <thenzl@redhat.com>
In-Reply-To: <eb5335bc-760d-4591-8a73-71f10dcd8155@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/3/23 21:56, Bart Van Assche wrote:
> On 4/2/23 14:49, Tomas Henzl wrote:
>> On 3/31/23 20:48, Bart Van Assche wrote:
>>> I'm interested in failing future I/O from inside sd_shutdown() because
>>> it would allow me to remove the I/O quiescing code from the UFS driver
>>> shutdown callback.
>> I'm aware of this, other drivers do have similar code and so it would
>> help elsewhere as well. The patch as it is doesn't however ensure that
>> there isn't for example an I/O started before sd.shutdown which may
>> arrive in a driver after his shutdown has been called. Because of that I
>> haven't used this as an argument in the discussion here.
> 
> Has it been considered to call blk_mq_freeze_queue() and 
> blk_mq_unfreeze_queue() to wait for I/O that started earlier?
> 
> Has it been considered to set QUEUE_FLAG_DYING to make future SCSI 
> commands fail? See also blk_mq_destroy_queue().

I haven't been considering anything from above. I just had noticed on a
system timeouts when in kexec and wanted to have that fixed and for this
case it is sufficient when the blocking is only close to 100% (and the
patch is simple).
I, like you, see the benefit of moving a bit of functionality from LLD
to scsi layer but my patch wasn't accepted and I doubt that something
more complex could be.

> 
> Thanks,
> 
> Bart.
> 

