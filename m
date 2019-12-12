Return-Path: <SRS0=+Znx=2C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2780EC43603
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:35:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EDDDC2073B
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Dec 2019 16:35:26 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="xbcplkXM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729930AbfLLQf0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Dec 2019 11:35:26 -0500
Received: from mail-il1-f194.google.com ([209.85.166.194]:35904 "EHLO
        mail-il1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729591AbfLLQf0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Dec 2019 11:35:26 -0500
Received: by mail-il1-f194.google.com with SMTP id b15so2572200iln.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Dec 2019 08:35:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3FtLIVj+wnM2ARUnkHjLCIs+M1M/IA6PpWp8jtXGxBs=;
        b=xbcplkXMsLKBVhI2XoEAIhOCDrqD47HX6n1yvO5V22GmwrrQQBKbWggYHs4jvP1r5e
         d06kkPEOnjJE94l1i8s0OQBGyq2uCnz06HSXakJyefIeamZrYC04IsPHZG0q8AamKYX7
         hQiBFF2unkfh+vzBU4sfnsk8eFSJqiqGb27+ELN3raRO+1VzqxuUmJvQteWCoq4j74gw
         zDZjlxcYlLJc7nj02zY/1J5oio91PD6bX3m6ftojddzXMI4lyWGMcOBLF2IgQDl1+DS4
         M8/9vHNTZSCqOo/1DexoCnH9ZtJ4bViECOh2oT+MHZ1qxnhhm7JEOSFNx7VJQCROP4qJ
         4jQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3FtLIVj+wnM2ARUnkHjLCIs+M1M/IA6PpWp8jtXGxBs=;
        b=Gtoy3WZC7cyTooWTS9UdQ8DF2c5f7AG7gaTTupsYZjIqPM/cBZT43eoOXvnBRTwkKc
         nHbcGAnapVSGvWiy2C0xLup40aPeEcvLWdQKNWNHJQZlRvqp7Uu9UddD5eY6XSBDchl3
         x94LouifkJWHqNz3ShtDNE3pDJ5ez5odSSLkm3lSCmoJ3pn2J3/QF3PxLJRAiA3wcAIy
         kk/x24UXvt05J4M8NOiV8mrVcqRpMLdqsNa4sLnDpIYfY1FiiCXDYKSgjmM+rqWcd/3N
         VfPf17Gf43Bb4dn5suMxjgY0JG24/txorq+LE9zDtVQL7BdkmN5ieo7OUV6xyLMhj2ru
         mrYA==
X-Gm-Message-State: APjAAAUtBvGZhB79Cu4nms7FtyjiA5H1VtGomA47dSzVHwVDEAFm9ba6
        cFgTCqlyisK/Eb/cgp3q49u4ZQ==
X-Google-Smtp-Source: APXvYqxAPt9ybQh/T8WYBX6qxbHJzz4zpYaVA1B8qE0Zhi2chspe24qfeJl3SeUOs00SEoxpnZbeng==
X-Received: by 2002:a92:5d03:: with SMTP id r3mr8554165ilb.278.1576168525332;
        Thu, 12 Dec 2019 08:35:25 -0800 (PST)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id x62sm1843784ill.86.2019.12.12.08.35.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2019 08:35:24 -0800 (PST)
Subject: Re: [PATCH 15/24] compat_ioctl: scsi: move ioctl handling into
 drivers
To:     Christoph Hellwig <hch@infradead.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Cc:     "Michael S. Tsirkin" <mst@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>,
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
 <858768fb-5f79-8259-eb6a-a26f18fb0e04@redhat.com>
 <20191212162729.GB27991@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <6e265890-23e5-6368-4e36-d59ff47879b2@kernel.dk>
Date:   Thu, 12 Dec 2019 09:35:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20191212162729.GB27991@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/19 9:27 AM, Christoph Hellwig wrote:
> On Thu, Dec 12, 2019 at 01:28:08AM +0100, Paolo Bonzini wrote:
>> I think it's because the only ioctl for virtio-blk is SG_IO.  It makes
>> sense to lump it in with scsi, but I wouldn't mind getting rid of
>> CONFIG_VIRTIO_BLK_SCSI altogether.
> 
> CONFIG_VIRTIO_BLK_SCSI has been broken for about two years, as it
> never set the QUEUE_FLAG_SCSI_PASSTHROUGH flag after that was
> introduced.  I actually have a patch that I plan to send to remove
> this support as it was a really idea to start with (speaking as
> the person who had that idea back in the day).

We had this very discussion two years ago, and we never got it removed.
Let's please get it done.

-- 
Jens Axboe

