Return-Path: <SRS0=1qKe=7Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 367C2C433DF
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 09:36:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 13C292078D
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Jun 2020 09:36:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbgFKJgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Jun 2020 05:36:25 -0400
Received: from lhrrgout.huawei.com ([185.176.76.210]:2299 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726907AbgFKJgZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Jun 2020 05:36:25 -0400
Received: from lhreml724-chm.china.huawei.com (unknown [172.18.7.107])
        by Forcepoint Email with ESMTP id 6033969D0A898C07E451;
        Thu, 11 Jun 2020 10:36:24 +0100 (IST)
Received: from [127.0.0.1] (10.210.169.30) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1913.5; Thu, 11 Jun
 2020 10:36:22 +0100
Subject: Re: [PATCH RFC v7 00/12] blk-mq/scsi: Provide hostwide shared tags
 for SCSI HBAs
To:     Ming Lei <ming.lei@redhat.com>
CC:     <axboe@kernel.dk>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <don.brace@microsemi.com>,
        <kashyap.desai@broadcom.com>, <sumit.saxena@broadcom.com>,
        <bvanassche@acm.org>, <hare@suse.com>, <hch@lst.de>,
        <shivasharan.srikanteshwara@broadcom.com>,
        <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <esc.storagedev@microsemi.com>, <chenxiang66@hisilicon.com>,
        <megaraidlinux.pdl@broadcom.com>
References: <1591810159-240929-1-git-send-email-john.garry@huawei.com>
 <20200611030708.GB453671@T590>
From:   John Garry <john.garry@huawei.com>
Message-ID: <c033f445-97fd-6dc9-c270-9890681b39d9@huawei.com>
Date:   Thu, 11 Jun 2020 10:35:05 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20200611030708.GB453671@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.210.169.30]
X-ClientProxiedBy: lhreml713-chm.china.huawei.com (10.201.108.64) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/06/2020 04:07, Ming Lei wrote:
>> Using 12x SAS SSDs on hisi_sas v3 hw. mq-deadline results are included,
>> but it is not always an appropriate scheduler to use.
>>
>> Tag depth 		4000 (default)			260**
>>
>> Baseline:
>> none sched:		2290K IOPS			894K
>> mq-deadline sched:	2341K IOPS			2313K
>>
>> Final, host_tagset=0 in LLDD*
>> none sched:		2289K IOPS			703K
>> mq-deadline sched:	2337K IOPS			2291K
>>
>> Final:
>> none sched:		2281K IOPS			1101K
>> mq-deadline sched:	2322K IOPS			1278K
>>
>> * this is relevant as this is the performance in supporting but not
>>    enabling the feature
>> ** depth=260 is relevant as some point where we are regularly waiting for
>>     tags to be available. Figures were are a bit unstable here for testing.
>>
>> A copy of the patches can be found here:
>> https://github.com/hisilicon/kernel-dev/commits/private-topic-blk-mq-shared-tags-rfc-v7
>>
>> And to progress this series, we the the following to go in first, when ready:
>> https://lore.kernel.org/linux-scsi/20200430131904.5847-1-hare@suse.de/
> I'd suggest to add options to enable shared tags for null_blk & scsi_debug in V8, so
> that it is easier to verify the changes without real hardware.
> 

ok, fine, I can look at including that. To stop the series getting too 
large, I might spin off the early patches, which are not strictly related.

Thanks,
John
