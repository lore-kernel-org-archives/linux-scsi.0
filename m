Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FC3BC001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 21:46:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbjHHVqr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 17:46:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjHHVqp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 17:46:45 -0400
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EADDBE72;
        Tue,  8 Aug 2023 14:46:44 -0700 (PDT)
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-1bc5acc627dso22266865ad.1;
        Tue, 08 Aug 2023 14:46:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691531204; x=1692136004;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UWO+B3VMMC5kdv5gm3JrDZlf3aI34FAscPuuTecwAGs=;
        b=EOiM4RWalYGQf1Ufd4WMFNZBNx00+5It+CjGj01dBrAf2BBL1ZzN8DZrbiqBZ2fAJt
         hl0IxgB+Ap5IVYIV6GGY2zqF0XBV8dgLh/au0RSun2lYpyYdJ8RPuzYUkOb37xYhQELh
         cfFsKNGdqJkqhoE7e8aSnGXNjish7pqprxdKLTvoNQljtj0WF0IuPbvjr0npB3EXxWRW
         Avtqken03NsG/gMfMDvzT+jOomvr1NXsR/hejWsUmqdsrgCdqWa3+DL2HESifW6MVAPs
         L/aLnrslHfLNv1inub90cAepX7sYeo/5b2ajxZngYgrpwGAc06zaMdN0/5PBx3IO/X7F
         vZVw==
X-Gm-Message-State: AOJu0YyJ2smef0EsoRY80TWr3cbiRER1LrISMBgCzKUoCQ9qZO/cgIDn
        EZ6ootXbSS83KlCnShWRMuS/F5Kd394=
X-Google-Smtp-Source: AGHT+IFiOmmS9FJznub0QD3vU+zFO5gge1d1uMLaORGxQYRsJz+2Jl68cbW00zwfwtZ7jedsYLh22g==
X-Received: by 2002:a17:903:12d4:b0:1b7:e86f:7631 with SMTP id io20-20020a17090312d400b001b7e86f7631mr939779plb.19.1691531204273;
        Tue, 08 Aug 2023 14:46:44 -0700 (PDT)
Received: from ?IPV6:2600:1010:b047:2ab0:fd93:3f7d:e947:afd4? ([2600:1010:b047:2ab0:fd93:3f7d:e947:afd4])
        by smtp.gmail.com with ESMTPSA id be5-20020a170902aa0500b001b5247cac3dsm9478808plb.110.2023.08.08.14.46.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 14:46:43 -0700 (PDT)
Message-ID: <ede0c18a-f5d0-94af-5175-9be54aa85082@acm.org>
Date:   Tue, 8 Aug 2023 14:46:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v6 1/7] block: Introduce the flag
 QUEUE_FLAG_NO_ZONE_WRITE_LOCK
Content-Language: en-US
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20230804154821.3232094-1-bvanassche@acm.org>
 <20230804154821.3232094-2-bvanassche@acm.org>
 <dd230762-804c-bb8a-24e0-123afd81e26c@kernel.dk>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <dd230762-804c-bb8a-24e0-123afd81e26c@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/23 14:19, Jens Axboe wrote:
> On 8/4/23 9:47?AM, Bart Van Assche wrote:
>> Writes in sequential write required zones must happen at the write
>> pointer. Even if the submitter of the write commands (e.g. a filesystem)
>> submits writes for sequential write required zones in order, the block
>> layer or the storage controller may reorder these write commands.
>>
>> The zone locking mechanism in the mq-deadline I/O scheduler serializes
>> write commands for sequential zones. Some but not all storage controllers
>> require this serialization. Introduce a new request queue flag to allow
>> block drivers to indicate that they preserve the order of write commands
>> and thus do not require serialization of writes per zone.
> 
> Looking at how this is used, why not call it QUEUE_FLAG_ZONE_WRITE_LOCK
> instead? That'd make the code easier to immediately grok, rather than
> deal with double negations.

Hi Jens,

Do I understand correctly that you want me to set the
QUEUE_FLAG_ZONE_WRITE_LOCK flag for all request queues by adding it to
QUEUE_FLAG_MQ_DEFAULT and also that the UFS driver should clear the
QUEUE_FLAG_ZONE_WRITE_LOCK flag?

Thanks,

Bart.
