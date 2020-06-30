Return-Path: <SRS0=aUil=AL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45B3DC433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 06:33:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 23633207FB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Jun 2020 06:33:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730154AbgF3GdG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Jun 2020 02:33:06 -0400
Received: from mx2.suse.de ([195.135.220.15]:56652 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbgF3GdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Jun 2020 02:33:06 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 74AF3AAC3;
        Tue, 30 Jun 2020 06:33:04 +0000 (UTC)
Subject: Re: About sbitmap_bitmap_show() and cleared bits (was Re: [PATCH RFC
 v7 07/12] blk-mq: Add support in hctx_tags_bitmap_show() for a shared
 sbitmap)
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        linux-block@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        don.brace@microsemi.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, ming.lei@redhat.com, bvanassche@acm.org,
        hare@suse.com, hch@lst.de, shivasharan.srikanteshwara@broadcom.com,
        linux-scsi@vger.kernel.org, esc.storagedev@microsemi.com,
        chenxiang66@hisilicon.com, megaraidlinux.pdl@broadcom.com
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <1591810159-240929-8-git-send-email-john.garry@huawei.com>
 <9f4741c5-d117-d764-cf3a-a57192a788c3@suse.de>
 <aad6efa3-2d7f-ca68-d239-44ea187c8017@huawei.com>
 <7ed6ccf1-6ad9-1df7-f55d-4ed6cac1e08d@suse.de>
 <8ffd5c22-f644-3436-0a9f-2e08c220525e@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <84f9623e-961e-3c9b-eed6-795b64f1ab76@suse.de>
Date:   Tue, 30 Jun 2020 08:33:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <8ffd5c22-f644-3436-0a9f-2e08c220525e@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/29/20 5:32 PM, John Garry wrote:
> Hi all,
> 
> I noticed that sbitmap_bitmap_show() only shows set bits and does not 
> consider cleared bits. Is that the proper thing to do?
> 
> I ask, as from trying to support sbitmap_bitmap_show() for hostwide 
> shared tags feature, we currently use blk_mq_queue_tag_busy_iter() to 
> find active requests (and associated tags/bits) for a particular hctx. 
> So, AFAICT, would give a change in behavior for sbitmap_bitmap_show(), 
> in that it would effectively show set and not cleared bits.
> 
Why would you need to do this?
Where would be the point traversing cleared bits?

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
