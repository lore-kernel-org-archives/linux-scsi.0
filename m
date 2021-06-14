Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95DB2C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:20:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 61813613C0
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 07:20:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbhFNHWx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 03:22:53 -0400
Received: from mail-ej1-f47.google.com ([209.85.218.47]:44893 "EHLO
        mail-ej1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232424AbhFNHWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 03:22:52 -0400
Received: by mail-ej1-f47.google.com with SMTP id c10so14881865eja.11
        for <linux-scsi@vger.kernel.org>; Mon, 14 Jun 2021 00:20:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=EVydmKJPPYNtiVY9iSZ+7MSirUBdJUDLhipNH5/mdp0=;
        b=ELaHOPZ8dQbSDkq5jh9V7uiATIPvW+NrTukyYHK8vAXpz11JAsHbAFYwmkY7PjPUrc
         ngB97rsFAKDMgVq1nIXwfZOUranmXehDn604Chms7EEkkHm8EFAf4kw23YW3M7krkHZu
         qjtsONoptNQ96Y8Sa/HzPYAVT3qt2cU/RDNBRtc6AB2/NQgMwIPQBppjmq6Tuwl7le1p
         tHybN0rMumqG/+x52HAjtrjlE7qk5n6k5OZr751y2Cf0BLnHRnq3cfZ2GhKYK44M9iaF
         gWvYM3frd6mSdZEg214rSXYJMnKjljiSRMi9PB1yI1uaTvAr95hjFgyJ+s1p+b0BudRV
         EPiQ==
X-Gm-Message-State: AOAM532nnKyuHsj7M/kNW93e64NoTRUpJa1aIHi/7iYBxQGpFQgrZ9th
        PsfBJBhDHhFMp9Z83KrVkV0gtFHDAMM=
X-Google-Smtp-Source: ABdhPJylVj4do7wmnM1XrYNuV+0GgotGzYhaY/WAsdQoFk540VulY/Ovu7KFa2s42jnS2CAAPplkmQ==
X-Received: by 2002:a17:907:62a5:: with SMTP id nd37mr4031394ejc.148.1623655249122;
        Mon, 14 Jun 2021 00:20:49 -0700 (PDT)
Received: from ?IPv6:2a0b:e7c0:0:107::70f? ([2a0b:e7c0:0:107::70f])
        by smtp.gmail.com with ESMTPSA id n4sm6493435eja.121.2021.06.14.00.20.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Jun 2021 00:20:48 -0700 (PDT)
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
Message-ID: <4ae28eed-ec63-958e-832f-f15d60dd5512@kernel.org>
Date:   Mon, 14 Jun 2021 09:20:47 +0200
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
> Next try:
> Can you take the patch from the mailing list (virtio_scsi: do not 
> overwrite SCSI status),

That (20210610135833.46663-1-hare@suse.de for reference) works fine for me:
[    3.173255] scsi host0: Virtio SCSI HBA
[    3.183529] scsi 0:0:0:0: Direct-Access     QEMU     QEMU HARDDISK 
  2.5+ PQ: 0 ANSI: 5
[    3.220967] sd 0:0:0:0: Power-on or device reset occurred
[    3.226150] sd 0:0:0:0: [sda] 20971520 512-byte logical blocks: (10.7 
GB/10.0 GiB)
[    3.230889] sd 0:0:0:0: [sda] Write Protect is off
[    3.232772] sd 0:0:0:0: [sda] Mode Sense: 63 00 00 08
[    3.233633] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[    3.239478]  sda: sda1 sda2
[    3.243752] sd 0:0:0:0: [sda] Attached SCSI disk

thanks,
-- 
js
suse labs
