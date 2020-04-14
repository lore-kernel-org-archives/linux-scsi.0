Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB7D3C2BBFD
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:04:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9AD912072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 06:04:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405744AbgDNGEu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 02:04:50 -0400
Received: from mx2.suse.de ([195.135.220.15]:43722 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405711AbgDNGEu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 02:04:50 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 4CFBAAD75;
        Tue, 14 Apr 2020 06:04:46 +0000 (UTC)
Subject: Re: [PATCH 01/10] sbitmap: maintain allocation round_robin in sbitmap
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     Omar Sandoval <osandov@fb.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20200211121135.30064-1-ming.lei@redhat.com>
 <20200211121135.30064-2-ming.lei@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <f50dee21-3901-e5af-a19d-84e2f21ee381@suse.de>
Date:   Tue, 14 Apr 2020 08:04:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200211121135.30064-2-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/11/20 1:11 PM, Ming Lei wrote:
> Now allocation round_robin info is maintained by sbitmap_queue.
> 
> Actually, bit allocation belongs to sbitmap. Also the following
> patch will move alloc_hint to sbitmap for users with high depth.
> 
> So move round_robin to sbitmap.
> 
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: Sumit Saxena <sumit.saxena@broadcom.com>
> Cc: Shivasharan S <shivasharan.srikanteshwara@broadcom.com>
> Cc: Ewan D. Milne <emilne@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Bart Van Assche <bart.vanassche@wdc.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
>   block/blk-mq.c            |  2 +-
>   block/kyber-iosched.c     |  3 ++-
>   drivers/dma/idxd/device.c |  2 +-
>   drivers/dma/idxd/submit.c |  2 +-
>   include/linux/sbitmap.h   | 20 ++++++++++----------
>   lib/sbitmap.c             | 28 ++++++++++++++--------------
>   6 files changed, 29 insertions(+), 28 deletions(-)
> Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
