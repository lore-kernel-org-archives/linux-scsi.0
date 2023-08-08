Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 697B9C001B0
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Aug 2023 22:27:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230048AbjHHW1M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Aug 2023 18:27:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230035AbjHHW1L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Aug 2023 18:27:11 -0400
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CEB5DE
        for <linux-scsi@vger.kernel.org>; Tue,  8 Aug 2023 15:27:08 -0700 (PDT)
Received: by mail-pg1-x533.google.com with SMTP id 41be03b00d2f7-55b78bf0423so650846a12.0
        for <linux-scsi@vger.kernel.org>; Tue, 08 Aug 2023 15:27:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1691533627; x=1692138427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XL+BULOd9HF1aBCX6wvlZBa44EWer95pBGvLwvurMVE=;
        b=eas3rJP/bbSVsNioW89fwtP5a+7mmdBubXv0+21aYqeRM3H9ci0h/KSOwTja+iPzot
         pe8Vq4xrOVASxpBNBsL1RIyJKP2QPVB8Qpk286IaaI2p4z8DuiAEuHS7Ejl6vN0mV5Ky
         HXnZe/qCYZTQRjp0TNh0cpgjbQfJTuElCeQq7KhJDe8RpBbc33d6LVp8gCrVXD2iaaF4
         0DwTU/wQYEZgvzWbpbBldSHA7jGw5zdHD8e6/Iyx4RoE6SpM2VTOJNuxk1T84bR1Y9LZ
         0QmmDgOuV6mA3SioTOMpD43pWropQZfYifr+cIviDUtg0tWyqx6N22qm6zv7WYe0K0gw
         AuQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691533627; x=1692138427;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XL+BULOd9HF1aBCX6wvlZBa44EWer95pBGvLwvurMVE=;
        b=RD0VCj0j0VEGg+zWre0o/AiWTgbF7OrbIkG7zga01Scz3MyDwTbentpYP+9kL1zTTS
         i+/rrwuN7U50cP45W9AEIUjMBT5EUn1uRXJbKOFhI/vTNmUSL3f/ewoqcYc8WEI495I1
         oW+11AziE28ulZ1XOeAyRClIkY1md1r5zPJlhKx+UJ7xJp55XdmrDuERg8ItGqkke3Ta
         d/PgmphRoirNqtH7vUFi/LQxsBZcihgXTtmeq759w34/YWXkRXX/1GISLVZ30WfuPDXj
         adnZ4UcVPD18BZMsPCYkQrTyJOT8MqZuxD8+qCQcvAs3yYWtBywlKQanZR/9AtfG5f3+
         adeA==
X-Gm-Message-State: AOJu0YzpDgrrCg7hzlW9Kd3DnkW6k29e89IBpj6m15J4VmrYQ2Ed2GYN
        WgGorAYKzS2QBJtXHcdVh1I20g==
X-Google-Smtp-Source: AGHT+IFrrWjCITWUyeeKyC1U2g2S+h24tftyYugDC4Vw9sw4h6yesoRAYRojfe0VFUgp7sneJ+va8w==
X-Received: by 2002:a05:6a00:e8c:b0:67f:7403:1fe8 with SMTP id bo12-20020a056a000e8c00b0067f74031fe8mr913544pfb.3.1691533627622;
        Tue, 08 Aug 2023 15:27:07 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id u21-20020aa78395000000b00686fe7b7b48sm8617146pfm.121.2023.08.08.15.27.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Aug 2023 15:27:07 -0700 (PDT)
Message-ID: <067228e1-cd13-cf70-40fd-409f9b9ba557@kernel.dk>
Date:   Tue, 8 Aug 2023 16:27:05 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.1
Subject: Re: [PATCH v6 1/7] block: Introduce the flag
 QUEUE_FLAG_NO_ZONE_WRITE_LOCK
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        Ming Lei <ming.lei@redhat.com>
References: <20230804154821.3232094-1-bvanassche@acm.org>
 <20230804154821.3232094-2-bvanassche@acm.org>
 <dd230762-804c-bb8a-24e0-123afd81e26c@kernel.dk>
 <ede0c18a-f5d0-94af-5175-9be54aa85082@acm.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ede0c18a-f5d0-94af-5175-9be54aa85082@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/8/23 3:46?PM, Bart Van Assche wrote:
> On 8/8/23 14:19, Jens Axboe wrote:
>> On 8/4/23 9:47?AM, Bart Van Assche wrote:
>>> Writes in sequential write required zones must happen at the write
>>> pointer. Even if the submitter of the write commands (e.g. a filesystem)
>>> submits writes for sequential write required zones in order, the block
>>> layer or the storage controller may reorder these write commands.
>>>
>>> The zone locking mechanism in the mq-deadline I/O scheduler serializes
>>> write commands for sequential zones. Some but not all storage controllers
>>> require this serialization. Introduce a new request queue flag to allow
>>> block drivers to indicate that they preserve the order of write commands
>>> and thus do not require serialization of writes per zone.
>>
>> Looking at how this is used, why not call it QUEUE_FLAG_ZONE_WRITE_LOCK
>> instead? That'd make the code easier to immediately grok, rather than
>> deal with double negations.
> 
> Hi Jens,
> 
> Do I understand correctly that you want me to set the
> QUEUE_FLAG_ZONE_WRITE_LOCK flag for all request queues by adding it to
> QUEUE_FLAG_MQ_DEFAULT and also that the UFS driver should clear the
> QUEUE_FLAG_ZONE_WRITE_LOCK flag?

I don't think setting that flag by default makes a lot of sense, if the
device in question isn't zoned. Maybe have variants of BLK_ZONED_* which
has a locked and unlocked variant for each where it applies? Perhaps
have the lock flag be common between them so you can check them in the
same way? That'd keep the fact that it's zoned and if it needs locking
in the same spot, rather than scatter them in two spots.

-- 
Jens Axboe

