Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97A82C433FE
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 14:57:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 49CE82360D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 14:57:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbgLGO47 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 09:56:59 -0500
Received: from mx2.suse.de ([195.135.220.15]:50144 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725867AbgLGO46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Dec 2020 09:56:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 7663EAB63;
        Mon,  7 Dec 2020 14:56:17 +0000 (UTC)
Subject: Re: [RFC PATCH v2 0/2] add simple copy support
To:     Christoph Hellwig <hch@lst.de>,
        SelvaKumar S <selvakuma.s1@samsung.com>
Cc:     linux-nvme@lists.infradead.org, kbusch@kernel.org, axboe@kernel.dk,
        damien.lemoal@wdc.com, sagi@grimberg.me,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, snitzer@redhat.com, selvajove@gmail.com,
        nj.shetty@samsung.com, joshi.k@samsung.com,
        javier.gonz@samsung.com,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        linux-scsi@vger.kernel.org
References: <CGME20201204094719epcas5p23b3c41223897de3840f92ae3c229cda5@epcas5p2.samsung.com>
 <20201204094659.12732-1-selvakuma.s1@samsung.com>
 <20201207141123.GC31159@lst.de>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <01fe46ac-16a5-d4db-f23d-07a03d3935f3@suse.de>
Date:   Mon, 7 Dec 2020 15:56:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201207141123.GC31159@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/7/20 3:11 PM, Christoph Hellwig wrote:
> So, I'm really worried about:
> 
>   a) a good use case.  GC in f2fs or btrfs seem like good use cases, as
>      does accelating dm-kcopyd.  I agree with Damien that lifting dm-kcopyd
>      to common code would also be really nice.  I'm not 100% sure it should
>      be a requirement, but it sure would be nice to have
>      I don't think just adding an ioctl is enough of a use case for complex
>      kernel infrastructure.
>   b) We had a bunch of different attempts at SCSI XCOPY support form IIRC
>      Martin, Bart and Mikulas.  I think we need to pull them into this
>      discussion, and make sure whatever we do covers the SCSI needs.
> 
And we shouldn't forget that the main issue which killed all previous 
implementations was a missing QoS guarantee.
It's nice to have simply copy, but if the implementation is _slower_ 
than doing it by hand from the OS there is very little point in even 
attempting to do so.
I can't see any provisions for that in the TPAR, leading me to the 
assumption that NVMe simple copy will suffer from the same issue.

So if we can't address this I guess this attempt will fail, too.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
