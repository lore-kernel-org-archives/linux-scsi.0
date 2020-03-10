Return-Path: <SRS0=Pfrg=43=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C6A8C18E5A
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 21:09:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0A11224649
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Mar 2020 21:09:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726411AbgCJVJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Mar 2020 17:09:01 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2547 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726268AbgCJVJB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Mar 2020 17:09:01 -0400
Received: from lhreml705-cah.china.huawei.com (unknown [172.18.7.106])
        by Forcepoint Email with ESMTP id B0422B53C758ABD6007B;
        Tue, 10 Mar 2020 21:08:59 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml705-cah.china.huawei.com (10.201.108.46) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Tue, 10 Mar 2020 21:08:59 +0000
Received: from [127.0.0.1] (10.210.167.10) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Tue, 10 Mar
 2020 21:08:57 +0000
Subject: Re: [PATCH RFC v2 02/24] scsi: allocate separate queue for reserved
 commands
To:     Christoph Hellwig <hch@infradead.org>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <hare@suse.de>,
        <ming.lei@redhat.com>, <bvanassche@acm.org>,
        <linux-block@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-scsi@vger.kernel.org>,
        <virtualization@lists.linux-foundation.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        Hannes Reinecke <hare@suse.com>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-3-git-send-email-john.garry@huawei.com>
 <20200310183243.GA14549@infradead.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <79cf4341-f2a2-dcc9-be0d-2efc6e83028a@huawei.com>
Date:   Tue, 10 Mar 2020 21:08:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200310183243.GA14549@infradead.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.167.10]
X-ClientProxiedBy: lhreml726-chm.china.huawei.com (10.201.108.77) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/03/2020 18:32, Christoph Hellwig wrote:
> On Wed, Mar 11, 2020 at 12:25:28AM +0800, John Garry wrote:
>> From: Hannes Reinecke <hare@suse.com>
>>
>> Allocate a separate 'reserved_cmd_q' for sending reserved commands.
> 
> Why?  Reserved command specifically are not in any way tied to queues.
> .
> 

So the v1 series used a combination of the sdev queue and the per-host 
reserved_cmd_q. Back then you questioned using the sdev queue for virtio 
scsi, and the unconfirmed conclusion was to use a common per-host q. 
This is the best link I can find now:

https://www.mail-archive.com/linux-scsi@vger.kernel.org/msg83177.html

"

 >> My implementation actually allows for per-device reserved tags (eg for
 >> virtio). But some drivers require to use internal commands prior to any
 >> device setup, so they have to use a separate reserved command queue 
just to
 >> be able to allocate tags.
 >
 > Why would virtio-scsi need per-device reserved commands?  It 
currently uses
 > a global mempool to allocate the reset commands.
 >
Oh, I'm perfectly fine with dropping the per-device reserved commands,
and use the host-wide queue in general.
It turns out most of the drivers use it that way already.
Will be doing so for the next iteration.

"

Cheers
