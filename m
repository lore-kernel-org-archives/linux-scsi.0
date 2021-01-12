Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85596C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:24:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3588322CB2
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 07:24:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbhALHYT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 02:24:19 -0500
Received: from mx2.suse.de ([195.135.220.15]:59180 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727304AbhALHYT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Jan 2021 02:24:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9F667AE6E;
        Tue, 12 Jan 2021 07:23:37 +0000 (UTC)
Subject: Re: About scsi device queue depth
To:     John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Hannes Reinecke <hare@suse.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
Cc:     chenxiang <chenxiang66@hisilicon.com>
References: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2b9a90c4-17e6-4935-bf3f-4bef54de27cc@suse.de>
Date:   Tue, 12 Jan 2021 08:23:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/11/21 5:21 PM, John Garry wrote:
> Hi,
> 
> I was looking at some IOMMU issue on a LSI RAID 3008 card, and noticed 
> that performance there is not what I get on other SAS HBAs - it's lower.
> 
> After some debugging and fiddling with sdev queue depth in mpt3sas 
> driver, I am finding that performance changes appreciably with sdev 
> queue depth:
> 
> sdev qdepth    fio number jobs*     1    10    20
> 16                    1590    1654    1660
> 32                    1545    1646    1654
> 64                    1436    1085    1070
> 254 (default)                1436    1070    1050
> 
> fio queue depth is 40, and I'm using 12x SAS SSDs.
> 
> I got comparable disparity in results for fio queue depth = 128 and num 
> jobs = 1:
> 
> sdev qdepth    fio number jobs*     1
> 16                    1640
> 32                    1618
> 64                    1577
> 254 (default)                1437
> 
> IO sched = none.
> 
> That driver also sets queue depth tracking = 1, but never seems to kick in.
> 
> So it seems to me that the block layer is merging more bios per request, 
> as averge sg count per request goes up from 1 - > upto 6 or more. As I 
> see, when queue depth lowers the only thing that is really changing is 
> that we fail more often in getting the budget in 
> scsi_mq_get_budget()->scsi_dev_queue_ready().
> 
> So initial sdev queue depth comes from cmd_per_lun by default or 
> manually setting in the driver via scsi_change_queue_depth(). It seems 
> to me that some drivers are not setting this optimally, as above.
> 
> Thoughts on guidance for setting sdev queue depth? Could blk-mq changed 
> this behavior?
> 
First of all: are these 'real' SAS SSDs?
The peak at 32 seems very ATA-ish, and I wouldn't put it past the LSI 
folks to optimize for that case :-)
Can you get a more detailed picture by changing the queue depth more 
finegrained?
(Will get you nicer graphs to boot :-)

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
