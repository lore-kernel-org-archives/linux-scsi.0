Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D775CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 14:44:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 653E7208E3
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 14:44:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20150623.gappssmtp.com header.i=@kernel-dk.20150623.gappssmtp.com header.b="ZEOnLqUq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727313AbfKAOoW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 10:44:22 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:46870 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727194AbfKAOoV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 10:44:21 -0400
Received: by mail-io1-f67.google.com with SMTP id c6so11106585ioo.13
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 07:44:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=fyVmGEPjp+fgA3qIeOSHV1kDIyaUUqkTBrMuu4zrLLE=;
        b=ZEOnLqUqapOP5Is+422A+JSIWBJwJoRkL+EkjyMEm0QMun+X2cMhREuo/EO+Kp9sjQ
         JMbr4KQ/mtATq5cBqlr7kkry5vsX1+/bIwIa2NvdNJ0joB8F0p1ZpQ+WNRnMWJH28gwx
         z1Rm3kst/Z7YwUL7lyALdvnuyfNFtMX7v5P496kdgpp744thPh8q9OG134ibUJJdbL0t
         vYPy2uk2qnf4nX52TNFizTTZp3HX2JWA74PDSFpPSBy/BxbF0FZ7atPUvLuqMgI4iP7p
         nn15EOkGE8gRATqwFk3limk/mwvlzIzSCajHF69noir1TCESft/hCrB6FGfZ/EJGCabB
         FjPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=fyVmGEPjp+fgA3qIeOSHV1kDIyaUUqkTBrMuu4zrLLE=;
        b=qiBOYwUkQFrJCpF5053spi7Wg2dKCCXM+7CZ1ArWwDReuBKdrtxIUL4ixM2clhGh5e
         bCAfknP9Bk6qWnOx7NGwBRujdUorxPrPyLKULAMhXlQ1PFjMCzYa6b64T7Z28O4NaQdl
         3GOpmmD/KQmXbWJ+itt+P87eL5vL5dGQSVYtwF74lCHk57KW5Rny1D2p5qavt2LjRJTd
         SQI7iEFxzMwAlWSImJv/oixj2OP0nGAHRn+TOmdb1e3jjLo6PHzgx46PszIp5+D6cwN0
         e/8pGHyBcaAsh5h2nmbAfIFhXMnXb2UYDOT9ntK9r8r6srJUh9i2sqGKqh3+sUKlcN8Q
         r/ig==
X-Gm-Message-State: APjAAAUiktSJuYpT9RjdYqSeysk6nG6mwIV9xceY5AbX3SEtHnXU+5Sh
        ttKl7gt+5WLTIiaWpdHSEwPUpw==
X-Google-Smtp-Source: APXvYqzmW6Y0vTK9db5s0OR58kvKovi2zogB/x9ftACnuLqJOWjKgzTDrDyoW44evB6RGd0uUhMvZQ==
X-Received: by 2002:a02:9f0f:: with SMTP id z15mr2031621jal.91.1572619460516;
        Fri, 01 Nov 2019 07:44:20 -0700 (PDT)
Received: from [192.168.1.159] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id f25sm1121364ila.71.2019.11.01.07.44.18
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 01 Nov 2019 07:44:19 -0700 (PDT)
Subject: Re: [PATCH V5] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191025065855.6309-1-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <9d1e41fa-12d5-df2a-6c8e-1f9d299a6dbf@kernel.dk>
Date:   Fri, 1 Nov 2019 08:44:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025065855.6309-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/25/19 12:58 AM, Ming Lei wrote:
> It isn't necessary to check the host depth in scsi_queue_rq() any more
> since it has been respected by blk-mq before calling scsi_queue_rq() via
> getting driver tag.
> 
> Lots of LUNs may attach to same host and per-host IOPS may reach millions,
> so we should avoid expensive atomic operations on the host-wide counter in
> the IO path.
> 
> This patch implements scsi_host_busy() via blk_mq_tagset_busy_iter()
> with one scsi command state for reading the count of busy IOs for scsi_mq.
> 
> It is observed that IOPS is increased by 15% in IO test on scsi_debug (32
> LUNs, 32 submit queues, 1024 can_queue, libaio/dio) in a dual-socket
> system.
> 
> V5:
> 	- fix document on .can_queue, no code change
> 
> V4:
>          - fix one build waring, just a line change in scsi_dev_queue_ready()
> 
> V3:
>          - use non-atomic set/clear bit operations as suggested by Bart
>          - kill single field struct for storing count of in-flight requests
>          - add patch to bypass the atomic LUN-wide counter of device_busy
>          for fast SSD device
> 
> V2:
> 	- introduce SCMD_STATE_INFLIGHT for getting accurate host busy
> 	via blk_mq_tagset_busy_iter()
> 	- verified that original Jens's report[1] is fixed
> 	- verified that SCSI timeout/abort works fine
> 
> [1] https://www.spinics.net/lists/linux-scsi/msg122867.html
> [2] V1 & its revert:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

