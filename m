Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63C5FC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 00:28:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3475F214AF
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 00:28:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ewgbKEQ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727267AbfLLA2O (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Dec 2019 19:28:14 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25415 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727126AbfLLA2O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Dec 2019 19:28:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576110493;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hb5JBtjwXvbmme4Dxt6Sh1XFoFaw8S8TIapNfxubP9w=;
        b=ewgbKEQ5fLMgONL7JmY2NfQ9C9Nx+MlUiseSvD6hFTc/Iuxjsa/Y+Ucc9DkxZctvV+QJhA
        3+SHBfc4n9A0SvS30XOMEfX808wtywBqxI19k3BEDJ/HIiRoEFBfWbGFcopjCEp0EMJW+P
        Jdqp7RDrpyhen68B/Hl7nO7GBQ7iTaA=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-397-SQCKNExxPay9blocQsjlPg-1; Wed, 11 Dec 2019 19:28:12 -0500
X-MC-Unique: SQCKNExxPay9blocQsjlPg-1
Received: by mail-wm1-f71.google.com with SMTP id b131so230639wmd.9
        for <linux-scsi@vger.kernel.org>; Wed, 11 Dec 2019 16:28:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hb5JBtjwXvbmme4Dxt6Sh1XFoFaw8S8TIapNfxubP9w=;
        b=rUk9gG5fphtmDxlqmYM8Jb32pCRP6MyTI/lGcMLR6HgJ4RV610rGt7DxV6c2rxXdID
         FSGPkdIY3h1l09sROLbaDGPf809Z11uM2jaGPOEkThgzlY9D2Vy3pJtHCgxX//Z0RsEq
         EMcW9NWay4bgg/TU9wnB2zPy7e3pMk+NMghfRjG2Eu7DD7NEyo/oOvamf8VJQsy7hrFw
         jjRXRslOuKYgYLAxtkc5GY6CjUZe2V15Ff+P2PA7XuVyTy053C6tp7CABgLxliqokkN+
         v7FUpzseTbdv1nsQscWCMK/f9TsBRBfTzklgOQ8cUS92NiE2AAvdC1PxKKFnUfkZTJGv
         h7/g==
X-Gm-Message-State: APjAAAWsKvQsCHcseVdoz+aM8kyVQ/KJPQKEN0Z4n1WsTJuaU7x7JF6H
        FNyFvX6ZbeeqDAsi4aFrX99s9hNRLPPQX8bfuKXN5J6WyspYubh1cAVRCRZcjZ2mp8s5q77ATk4
        IQt54pXgadeGZIwo6TYldxg==
X-Received: by 2002:adf:8bde:: with SMTP id w30mr2790566wra.124.1576110490978;
        Wed, 11 Dec 2019 16:28:10 -0800 (PST)
X-Google-Smtp-Source: APXvYqwPP/UQtQvR7H0tI553soFfAslbKh86aszplkbovgcOGgnxj1GpFCjYyjEJLCUeQDAEqXIk1A==
X-Received: by 2002:adf:8bde:: with SMTP id w30mr2790552wra.124.1576110490746;
        Wed, 11 Dec 2019 16:28:10 -0800 (PST)
Received: from ?IPv6:2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9? ([2001:b07:6468:f312:e9bb:92e9:fcc3:7ba9])
        by smtp.gmail.com with ESMTPSA id g9sm4134194wro.67.2019.12.11.16.28.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 11 Dec 2019 16:28:10 -0800 (PST)
Subject: Re: [PATCH 15/24] compat_ioctl: scsi: move ioctl handling into
 drivers
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Jason Wang <jasowang@redhat.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        =?UTF-8?Q?Kai_M=c3=a4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-kernel@vger.kernel.org, y2038@lists.linaro.org,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        John Garry <john.garry@huawei.com>,
        virtualization@lists.linux-foundation.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20191211204306.1207817-1-arnd@arndb.de>
 <20191211204306.1207817-16-arnd@arndb.de>
 <20191211180155-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <858768fb-5f79-8259-eb6a-a26f18fb0e04@redhat.com>
Date:   Thu, 12 Dec 2019 01:28:08 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191211180155-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/19 00:05, Michael S. Tsirkin wrote:
>> @@ -405,6 +405,9 @@ static int virtblk_getgeo(struct block_device *bd, struct hd_geometry *geo)
>>  
>>  static const struct block_device_operations virtblk_fops = {
>>  	.ioctl  = virtblk_ioctl,
>> +#ifdef CONFIG_COMPAT
>> +	.compat_ioctl = blkdev_compat_ptr_ioctl,
>> +#endif
>>  	.owner  = THIS_MODULE,
>>  	.getgeo = virtblk_getgeo,
>>  };
> Hmm - is virtio blk lumped in with scsi things intentionally?

I think it's because the only ioctl for virtio-blk is SG_IO.  It makes
sense to lump it in with scsi, but I wouldn't mind getting rid of
CONFIG_VIRTIO_BLK_SCSI altogether.

Paolo

