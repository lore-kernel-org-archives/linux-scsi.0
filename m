Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_NONE,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B23F6C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:29:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C13B613BF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232516AbhFNGbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 02:31:11 -0400
Received: from mail-ej1-f49.google.com ([209.85.218.49]:44674 "EHLO
        mail-ej1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232471AbhFNGbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 02:31:10 -0400
Received: by mail-ej1-f49.google.com with SMTP id c10so14645721eja.11
        for <linux-scsi@vger.kernel.org>; Sun, 13 Jun 2021 23:29:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=v8BOXtUmJkf154Ju1gnY/31TOaH+QZPbAvt/fQumKY0=;
        b=JpvU4q/TzbhM0O6qtqWXJixkZ/TLLRLwQ+IrYlPOf9uaiivlM7iQ+5be3uTmCO1rRh
         3wRActPKRy/avk5yNbcR4vJLSvM5h0c+UTMd3XLsMyTDRG6xuqcBWTuVAck8UcOSyux/
         htFzrp4AWhDm5Ox6aMSMbto6e1ClznhElwnNbasWmsbjhPnGgOMuVb1Mt+b2fZAhXdS0
         PVLwFBOWhEYMmzt1rRxs9yEEW53HgoOg+q38+xVB6AY7sriX/1w/UmwbQbYzfjCv17rr
         qoTO76nzyZhBS74C+PcyhVkE8LG/o1l1TZmrYvpPy3lgqtwc50ynt2Ll13nKcUPwm1Wn
         xs4Q==
X-Gm-Message-State: AOAM530ga2wx1s4r5Gg0ssDKG41AxKI9Bx3URwYeDSyDPQtPhXfgs1XV
        GYjRrO9tkZvNTgZqAs/+6U13jw2B1AQ=
X-Google-Smtp-Source: ABdhPJzxB4TdfiHD/WXTiSl+PasWTzpdZHCR7Slu0i+kzTWKOqIh0WoX6j3Ug+vKhpwlglKCDL3fKw==
X-Received: by 2002:a17:906:3e8d:: with SMTP id a13mr13770006ejj.463.1623652147154;
        Sun, 13 Jun 2021 23:29:07 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id z63sm7993047ede.36.2021.06.13.23.29.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 13 Jun 2021 23:29:06 -0700 (PDT)
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
 <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
 <6d5c893d-61c1-fad9-78f5-17b41f19706d@kernel.org>
 <723d9d8b-5dde-839f-efe6-164177f5c1ce@suse.de>
 <b91a17a7-3bfd-b882-ce15-fa9991315293@kernel.org>
 <80a6d6fe-c1ab-e27f-7c01-2946c53ebac8@suse.de>
From:   Jiri Slaby <jirislaby@kernel.org>
Message-ID: <1395eb01-3db3-c657-ba42-5a4e76eb3293@kernel.org>
Date:   Mon, 14 Jun 2021 08:29:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.2
MIME-Version: 1.0
In-Reply-To: <80a6d6fe-c1ab-e27f-7c01-2946c53ebac8@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11. 06. 21, 9:38, Hannes Reinecke wrote:
> Alternatively: which configuration do you use?
> Maybe I can reproduce it here locally ...

It's quite easy:
qemu-img create /tmp/dr.img 1G

qemu-kvm -smp 4 -m 2G -drive file=/tmp/dr.img,if=none,id=hd,format=raw 
-device virtio-scsi-pci,id=scsi -device scsi-hd,drive=hd -serial stdio 
-kernel /path/to/bzImage -append 'console=ttyS0' -nographic -monitor none

Either sda appears or not... Assuming virtio_scsi and sd are built in.

thanks,
-- 
js
suse labs
