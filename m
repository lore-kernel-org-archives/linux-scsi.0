Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BE64C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 22 Nov 2021 18:08:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239938AbhKVSLX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 22 Nov 2021 13:11:23 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4147 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239944AbhKVSLW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Nov 2021 13:11:22 -0500
Received: from fraeml715-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4HyZxd07pLz67NW9;
        Tue, 23 Nov 2021 02:07:49 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml715-chm.china.huawei.com (10.206.15.34) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Mon, 22 Nov 2021 19:08:13 +0100
Received: from [10.47.91.234] (10.47.91.234) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Mon, 22 Nov
 2021 18:08:13 +0000
Subject: Re: [PATCH v2 05/20] scsi: core: Add support for internal commands
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
CC:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20211119195743.2817-1-bvanassche@acm.org>
 <20211119195743.2817-6-bvanassche@acm.org>
 <d396a5ed-763e-de79-1714-b4e58e812c7f@huawei.com>
 <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
From:   John Garry <john.garry@huawei.com>
Message-ID: <5244b111-66ea-af2b-4e98-343a96c7367e@huawei.com>
Date:   Mon, 22 Nov 2021 18:08:07 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <24ce9815-c01d-9ad4-2221-5a5b041ee231@acm.org>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.91.234]
X-ClientProxiedBy: lhreml705-chm.china.huawei.com (10.201.108.54) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/11/2021 17:46, Bart Van Assche wrote:
>>
>> struct scsi_cmnd *scsi_get_internal_cmd(struct scsi_device *sdev, ..)
>> struct scsi_cmnd *scsi_host_get_internal_cmd(struct Scsi_Host *shost, ..)
> 
> Passing a request queue pointer as first argument instead of a struct 
> scsi_device is a deliberate choice. In the UFS driver (and probably also 
> in other SCSI LLDs) we want to allocate internal requests without these 
> requests being visible in any existing SCSI device statistics. 


> Creating 
> a new SCSI device for the allocation of internal requests is not a good 
> choice because that new SCSI device would have to be assigned a LUN 
> number and would be visible in sysfs.

But I was not suggesting that.

Hannes series which he points us at recently added an "admin" 
request_queue for a scsi_host, for when we don't want or need a reserved 
commands associated with an sdev. I assumed that you would do something 
similar to this, which would replace ufs_hba.cmd_queue.

Thanks,
John
