Return-Path: <SRS0=LZqT=EC=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.4 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C278C838CA
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 15:47:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 310C322283
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Oct 2020 15:47:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1764484AbgJ0PrW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Oct 2020 11:47:22 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:3000 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1799227AbgJ0Pa0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 27 Oct 2020 11:30:26 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id 9B788CFFF0BBBC69937E;
        Tue, 27 Oct 2020 15:30:24 +0000 (GMT)
Received: from [10.47.8.138] (10.47.8.138) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Tue, 27 Oct
 2020 15:30:23 +0000
Subject: Re: [PATCHv6 00/21] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Bart van Assche <bvanassche@acm.org>,
        Don Brace <don.brace@microchip.com>,
        <linux-scsi@vger.kernel.org>,
        chenxiang <chenxiang66@hisilicon.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>
References: <20200703130122.111448-1-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ac78e944-25e1-15d7-7c9e-b7f439079222@huawei.com>
Date:   Tue, 27 Oct 2020 15:27:03 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200703130122.111448-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.8.138]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 03/07/2020 14:01, Hannes Reinecke wrote:
> Hi all,
> 
> quite some drivers use internal commands for various purposes, most
> commonly sending TMFs or querying the HBA status.
> While these commands use the same submission mechanism than normal
> I/O commands, they will not be counted as outstanding commands,
> requiring those drivers to implement their own mechanism to figure
> out outstanding commands.
> The block layer already has the concept of 'reserved' tags for
> precisely this purpose, namely non-I/O tags which live off a separate
> tag pool. That guarantees that these commands can always be sent,
> and won't be influenced by tag starvation from the I/O tag pool.
> This patchset enables the use of reserved tags for the SCSI midlayer
> by allocating a virtual LUN for the HBA itself which just serves
> as a resource to allocate valid tags from.
> This removes quite some hacks which were required for some
> drivers (eg. fnic or snic), and allows the use of tagset
> iterators within the drivers.
> 
> The entire patchset can be found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git reserved-tags.v6
> 

Hi Hannes,

Any chance you can repost this series? I'm being a bit of a nag :)

It now looks like some drivers may also need this for supporting 
io_uring in SCSI mid-layer:
https://lore.kernel.org/linux-scsi/20201015133541.60400-1-kashyap.desai@broadcom.com/

And it's also useful for the runtime PM which we were supporting for 
hisi_sas, to track IOs.

I know that you were hoping for a few more reviews, but I don't think 
that they are coming for v6 now. And at least I gave a few comments 
here, like:

https://lore.kernel.org/linux-scsi/b03c1256-8255-5e7f-dda3-df036aaef812@huawei.com/

And there were other comments.

Please let me know.

Cheers,
John
