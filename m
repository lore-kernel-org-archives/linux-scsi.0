Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4F52EC76196
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Mar 2023 14:25:36 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232861AbjC1OZf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Mar 2023 10:25:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230331AbjC1OZf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Mar 2023 10:25:35 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CA38A4C
        for <linux-scsi@vger.kernel.org>; Tue, 28 Mar 2023 07:25:33 -0700 (PDT)
Received: from canpemm100004.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4PmBhN4QQCzSpr5;
        Tue, 28 Mar 2023 22:21:56 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm100004.china.huawei.com (7.192.105.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.21; Tue, 28 Mar 2023 22:25:30 +0800
Subject: Re: [PATCH] scsi: libsas: abort all inflight requests when device is
 gone
To:     John Garry <john.g.garry@oracle.com>, <martin.petersen@oracle.com>,
        <jejb@linux.ibm.com>
CC:     <linux-scsi@vger.kernel.org>, <hare@suse.com>, <hch@lst.de>,
        <bvanassche@acm.org>, <jinpu.wang@cloud.ionos.com>,
        <damien.lemoal@opensource.wdc.com>,
        Xingui Yang <yangxingui@huawei.com>
References: <20230328111524.1657878-1-yanaijie@huawei.com>
 <982d5c0d-1548-0739-d7d6-96a7834709ef@oracle.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <eb2f325c-c45b-756c-77a5-3c62fe577aca@huawei.com>
Date:   Tue, 28 Mar 2023 22:25:30 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <982d5c0d-1548-0739-d7d6-96a7834709ef@oracle.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 canpemm100004.china.huawei.com (7.192.105.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/3/28 20:35, John Garry wrote:
> On 28/03/2023 12:15, Jason Yan wrote:
>> When a disk is removed with inflight IO, the userspace application need
>> to wait for 30 senconds(depends on the timeout configuration) to getback
>> from the kernel. Xingui tried to fix this issue by aborting the ata link
>> for SATA devices[1]. However this approach left the SAS devices 
>> unresolved.
>>
>> This patch try to fix this issue by aborting all inflight requests while
>> the device is gone. This is implemented by itering the tagset.
>>
>> [1] 
>> https://lore.kernel.org/lkml/234e04db-7539-07e4-a6b8-c6b05f78193d@opensource.wdc.com/T/ 
>>
>>
>> Cc: Xingui Yang <yangxingui@huawei.com>
>> Cc: John Garry <john.g.garry@oracle.com>
>> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> Cc: Hannes Reinecke <hare@suse.com>
>> Signed-off-by: Jason Yan <yanaijie@huawei.com>
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 20 ++++++++++++++++++++
>>   1 file changed, 20 insertions(+)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index 72fdb2e5d047..d2be67f348e0 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -360,8 +360,28 @@ static void sas_destruct_ports(struct 
>> asd_sas_port *port)
>>       }
>>   }
>> +static bool sas_abort_cmd(struct request *req, void *data)
>> +{
>> +    struct scsi_cmnd *cmd = blk_mq_rq_to_pdu(req);
>> +    struct domain_device *dev = data;
>> +
>> +    if (dev == cmd_to_domain_dev(cmd))
>> +        blk_abort_request(req);
> 
> I suppose that this is ok, but we're not dealing with libsas "internal" 
> commands or libata internal commands, though. What about them?

Hi John,

Most of the time user space applications are not sensitive to libsas(or 
libata) "internal" commands. The applications only need the kernel 
response quickly on their "read" or "write" syscalls. This patch aborts 
all the application's IO and they will return immediately. We have 
tested this patch for more than 300 times. The "internal" commands may 
affects the EH process but in out test it does not affect the 
application's IO return.

> 
> I suppose my series here would help:
> 
> https://lore.kernel.org/linux-scsi/1666693096-180008-1-git-send-email-john.garry@huawei.com/ 

This is great. After your series we can manage "internal" commands more 
effectively, I think. And we can easily control all the commands 
including the "internal" commands.

> 
> 
> Along with Part II
> 
>> +    return true;
>> +}
>> +
>> +static void sas_abort_domain_cmds(struct domain_device *dev)
>> +{
>> +    struct sas_ha_struct *sas_ha = dev->port->ha;
>> +    struct Scsi_Host *shost = sas_ha->core.shost;
>> +    blk_mq_tagset_busy_iter(&shost->tag_set, sas_abort_cmd, dev);
> 
> blk_mq_queue_tag_busy_iter() would be nicer to use here, but it's not 
> exported - I am not advocating exporting it either. And we don't have 
> direct access to the scsi device pointer (from which we can look up the 
> request queue pointer), either.
> 
>> +}
>> +
>>   void sas_unregister_dev(struct asd_sas_port *port, struct 
>> domain_device *dev)
>>   {
>> +    if (test_bit(SAS_DEV_GONE, &dev->state))
>> +        sas_abort_domain_cmds(dev);
> 
> This code is common to expanders. Should we really be calling this for 
> an expander, even if it is harmless (as it does nothing currently)?

Yes, It does nothing now for expanders. I can filter out the expander 
devices in advance to avoid the wasting tag itering.

> 
> And we also seem to be calling this for rphy "which never saw 
> sas_rphy_add" (see code comment, not shown below), which is 
> questionable. Should we really do that?

This device has not been initialized completely if "never saw 
sas_rphy_add", and there will be no IO from the block layer. I think 
there is no real bug but we need to avoid to iter the tag set too.

Thanks,
Jason

> 
>> +
>>       if (!test_bit(SAS_DEV_DESTROY, &dev->state) &&
>>           !list_empty(&dev->disco_list_node)) {
>>           /* this rphy never saw sas_rphy_add */
> 
> 
> .
