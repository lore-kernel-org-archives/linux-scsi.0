Return-Path: <SRS0=qxeY=C2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45A1AC2BBD1
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 08:20:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1CC00206DB
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Sep 2020 08:20:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726315AbgIQIUn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Sep 2020 04:20:43 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2877 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726198AbgIQIUm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Sep 2020 04:20:42 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 88F572824A66CB081D46;
        Thu, 17 Sep 2020 09:20:40 +0100 (IST)
Received: from [127.0.0.1] (10.210.165.75) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 17 Sep
 2020 09:20:39 +0100
From:   John Garry <john.garry@huawei.com>
Subject: mpt3sas hostwide tagset?
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>
CC:     <MPT-FusionLinux.pdl@broadcom.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "axboe@kernel.dk" <axboe@kernel.dk>, Ming Lei <ming.lei@redhat.com>
Message-ID: <44b35254-faed-bcc9-6fb3-b843fff1ac1f@huawei.com>
Date:   Thu, 17 Sep 2020 09:17:53 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.165.75]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

You may have noticed patchset "blk-mq/scsi: Provide hostwide shared tags 
for SCSI HBAs", where we allow SCSI HBAs which have restriction of 
hostwide tagset to expose hw queues to blk-mq. Main motivation is to 
take advantage of blk-mq CPU hotplug handling support [0], and also 
possibly [1].

 From looking at this driver again, I now notice that mpt3sas seems to 
have all the characteristics of a driver which could make this change: 
uses managed interrupts for some completion queues, manages internally 
CPU<->queue mapping, does not set Scsi_Host.nr_hw_queues, and also uses 
request->tag.

Have you considered making this transition? Not sure if there are 
technical reasons not to.

Thanks,
John

[0] https://lore.kernel.org/linux-block/20200529135315.199230-1-hch@lst.de/

[1] 
https://lore.kernel.org/linux-scsi/CAHsXFKFy+ZVvaCr=H224VGA755k45fAJhz5TaMz+tOP6hNpj1g@mail.gmail.com/


