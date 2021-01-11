Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E321BC433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 16:23:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9962822AAD
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Jan 2021 16:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388513AbhAKQXS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jan 2021 11:23:18 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2306 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388683AbhAKQXR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jan 2021 11:23:17 -0500
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DDzR95cl6z67Yr5;
        Tue, 12 Jan 2021 00:18:45 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 17:22:35 +0100
Received: from [10.210.171.188] (10.210.171.188) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id
 15.1.2106.2; Mon, 11 Jan 2021 16:22:34 +0000
From:   John Garry <john.garry@huawei.com>
Subject: About scsi device queue depth
To:     Ming Lei <ming.lei@redhat.com>,
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
CC:     chenxiang <chenxiang66@hisilicon.com>
Message-ID: <9ff894da-cf2c-9094-2690-1973cc57835a@huawei.com>
Date:   Mon, 11 Jan 2021 16:21:27 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.171.188]
X-ClientProxiedBy: lhreml703-chm.china.huawei.com (10.201.108.52) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

I was looking at some IOMMU issue on a LSI RAID 3008 card, and noticed 
that performance there is not what I get on other SAS HBAs - it's lower.

After some debugging and fiddling with sdev queue depth in mpt3sas 
driver, I am finding that performance changes appreciably with sdev 
queue depth:

sdev qdepth	fio number jobs* 	1	10	20
16					1590	1654	1660
32					1545	1646	1654
64					1436	1085	1070
254 (default)				1436	1070	1050

fio queue depth is 40, and I'm using 12x SAS SSDs.

I got comparable disparity in results for fio queue depth = 128 and num 
jobs = 1:

sdev qdepth	fio number jobs* 	1	
16					1640
32					1618	
64					1577	
254 (default)				1437	

IO sched = none.

That driver also sets queue depth tracking = 1, but never seems to kick in.

So it seems to me that the block layer is merging more bios per request, 
as averge sg count per request goes up from 1 - > upto 6 or more. As I 
see, when queue depth lowers the only thing that is really changing is 
that we fail more often in getting the budget in 
scsi_mq_get_budget()->scsi_dev_queue_ready().

So initial sdev queue depth comes from cmd_per_lun by default or 
manually setting in the driver via scsi_change_queue_depth(). It seems 
to me that some drivers are not setting this optimally, as above.

Thoughts on guidance for setting sdev queue depth? Could blk-mq changed 
this behavior?

Thanks,
John
