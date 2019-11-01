Return-Path: <SRS0=zYer=YZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 94A41CA9ECF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:31:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B8620650
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Nov 2019 15:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727798AbfKAPb7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Nov 2019 11:31:59 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:35067 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727100AbfKAPb6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Nov 2019 11:31:58 -0400
Received: by mail-pg1-f196.google.com with SMTP id c8so6724987pgb.2
        for <linux-scsi@vger.kernel.org>; Fri, 01 Nov 2019 08:31:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=xyZv7qmYWZC61gNaDtXEE8BSxVlWhktfAqfnrTP/tvE=;
        b=SdF7V+2SiAZ7SFWrBI1eA6+ILsYSa9EJ8GAWnieuSOW2y18KmOJPxJL2178Mbuf4h5
         vtNssC4tCC4iQ+5QzkTiUeklzk4L4HIcKM/JJCGjWTLcYUj2P9uBE8WrdaJmqY+U+u64
         gzBUclFSmFxcvePLDSW3fTG8nsu+LImXRY+DJ13M9870GcX9BSX8n4vdkjmWReaz9BU9
         8tzSeUX98pqOVNSmZBOtcyQW0EHS+rDwZU5HN4OrT3orMD3vIzBGXc46yuuRQs03MxHM
         Yk5mYIET900D5OUE+kHStTVZgyB8OuqZjbasDoZStUtsmPowQu2ijrCm4bNSRIfLRxZ9
         sqsA==
X-Gm-Message-State: APjAAAVs8G9Btrq7sROhlXY6D25WwaaQShkZkm0OrNNZBt+UllxzT5Vx
        jSXdgZIUghi+hnNzQSrIBkxE/E4iuZI=
X-Google-Smtp-Source: APXvYqwtVOqLIm/avdUj9GvnJaeU/CYJdDHJlVb/FnegDpY2dIZyI2XbRZOIqk4CgyupdOPdAKjZ1w==
X-Received: by 2002:a63:f441:: with SMTP id p1mr14025825pgk.362.1572622318105;
        Fri, 01 Nov 2019 08:31:58 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id z125sm2697898pfb.134.2019.11.01.08.31.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Nov 2019 08:31:57 -0700 (PDT)
Subject: Re: [PATCH V5] scsi: core: avoid host-wide host_busy counter for
 scsi_mq
To:     Ming Lei <ming.lei@redhat.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191025065855.6309-1-ming.lei@redhat.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <a63b275b-31d5-877d-116f-623fa474cc96@acm.org>
Date:   Fri, 1 Nov 2019 08:31:55 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191025065855.6309-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/24/19 11:58 PM, Ming Lei wrote:
> Reviewed-by: Bart Van Assche <bart.vanassche@wdc.com>

Please use my current e-mail address. I had replied the following to v4 
of this patch:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

See also 
https://lore.kernel.org/linux-scsi/55c68a97-4393-fa63-e2da-d41a48237f96@acm.org/

Thanks,

Bart.
