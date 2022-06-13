Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8524CCA47B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 09:13:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240709AbiFMJNS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 05:13:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240642AbiFMJNQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 05:13:16 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C29A10FFF
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:13:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655111586; x=1686647586;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5VI+2FKzrNWL5Wg6P8XUaZKUwKjPPZ20dAG7gLdj7D4=;
  b=gVX5J8+qhp1B8efd/y6g6PF6aC9yFFaQfjmHQzqscikFPvjzx8fmEhF6
   GSttnAR2cQBtRbtBGpgty6+tv31SEAHqc1GalwjLnSrTUjAGeQdJPSEQS
   CTp6oZEAKZz+CG3otV5xT/wFdZlmA/dZATjjI/FYdV8nJmSvRA7Dz/Jrq
   4OuU4c5YdeYndFPXwWC/0aX5IqI8VtDy0d3TXkiM+9KFdE4bhTRryj8m5
   0i3vMrmh7zDLj5S2BBIwt+L0kxo6N1TE7GX0TYtiKNdAfMjTWwb6NNSpt
   kzgEEyrqcV87P4t8HpBP4KRrjgXTO0fXYPNCK2ZB11v2Drr/iO0VoLIeS
   g==;
X-IronPort-AV: E=Sophos;i="5.91,297,1647273600"; 
   d="scan'208";a="207835117"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 17:13:04 +0800
IronPort-SDR: 4r+NKD+Wv74ETw32z+9vHmKrpGgZPy0s4ECFu65FbLwtCbUh879bUvYkI66zcOw3q8tkL+XuI3
 UgY3TFN0cTZIn7C1RJQCFDWmuQRnKqrWCJM50MVjgVgPdf+xoHkItUFcPloSFwpGNRRi2Z5JRf
 cb5Qn0QorEKJgjm7eW7Dl2i/nA4aKHk7zNkg0dMwzM9+sbk8VKPICQ8DSMq6oN1y42w9N7+GgO
 GbOv9ppQbWq2cwaHveavhnMV+TMyjfoZ5DnQF7z+Jvumo+y9iGImEC0FVyfNDO4J8ZvhaWNMrH
 Hm/lrd1t40J7alKTMlwaDY4n
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 01:31:44 -0700
IronPort-SDR: tB9FYRwkIOE6KTfU/qx9qAXBxjlg6QfQO0ZZEIsu2WXY1KWzKRYTYjpF+TPvnAKMSvujmusOH7
 ImF1dWoCAbJgHepiCQkGJUx38mQHAza2fLXYjclfY2+j+yEeeW2TFJk7+b+ezArsS45NpSGdMw
 x4ZaUecmiC9xg16OwRRaiOYhlBKIXwaf0vgMXNTuPyuWXbdz0RmyoJ4GsLdsPH0G3U3jzkrtNQ
 ZVQvbG22nCzehtOVIUA1YvAgmrI0sTjAqltUlLh7ofXuubUJUD7srd5bq5tx8O+cYpRBCgsTjZ
 1dk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 02:07:05 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LM5L03sHSz1Rvlx
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 02:07:04 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655111223; x=1657703224; bh=5VI+2FKzrNWL5Wg6P8XUaZKUwKjPPZ20dAG
        7gLdj7D4=; b=N6F42YueqYj6jCq8Tph13jH4lRuGGdq0520WRmvHubluyuoK1pI
        ohF9B1kdFp64bbxgYAF0ebL9TTO7QIeRQ6DJK/bF1HShfEtL+bSWv1/6f6htSwP5
        CZI3XFWHjI06Pzd7e8dDcqSPV+0e9pE3SQ23n5Ax0Yzje0kt15BFdMT1500SizUh
        FalGLu0aA96GQI3sTlNzAg8xHbjXyjqZ6LjUs/rg/Fp2tRK6wNjPbpjNXSaYJjVz
        xg/+SLU+GIeMiz1KclzppU2C2nf3SHi5M4Kr5l9oTINOc3u5l1PfKzvcUT9KURXc
        o5HGxiekWBoQt0AXyDk16j6b/0Y3HnWkkEA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KAwFADXNGgQe for <linux-scsi@vger.kernel.org>;
        Mon, 13 Jun 2022 02:07:03 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LM5Kw6qYVz1Rvlc;
        Mon, 13 Jun 2022 02:07:00 -0700 (PDT)
Message-ID: <e4b108ba-cbc9-5237-f873-2fcea94f2b85@opensource.wdc.com>
Date:   Mon, 13 Jun 2022 18:06:59 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH RFC v2 03/18] scsi: core: Implement reserved command
 handling
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, brking@us.ibm.com,
        hare@suse.de, hch@lst.de
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        chenxiang66@hisilicon.com
References: <1654770559-101375-1-git-send-email-john.garry@huawei.com>
 <1654770559-101375-4-git-send-email-john.garry@huawei.com>
 <b4a0ede5-95a3-4388-e808-7627b5484d01@opensource.wdc.com>
 <7f80f3b6-84f6-de48-4e69-4562c96e62c5@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <7f80f3b6-84f6-de48-4e69-4562c96e62c5@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/13/22 17:25, John Garry wrote:
> On 13/06/2022 08:01, Damien Le Moal wrote:
>> On 6/9/22 19:29, John Garry wrote:
>>> From: Hannes Reinecke <hare@suse.de>
>>>
>>> Quite some drivers are using management commands internally, which
>>> typically use the same hardware tag pool (ie they are being allocated
>>> from the same hardware resources) as the 'normal' I/O commands.
>>> These commands are set aside before allocating the block-mq tag bitmap,
>>> so they'll never show up as busy in the tag map.
>>> The block-layer, OTOH, already has 'reserved_tags' to handle precisely
>>> this situation.
>>> So this patch adds a new field 'nr_reserved_cmds' to the SCSI host
>>> template to instruct the block layer to set aside a tag space for these
>>> management commands by using reserved tags.
>>>
>>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>>> Signed-off-by: John Garry <john.garry@huawei.com>
>>> ---
>>>   drivers/scsi/hosts.c     |  3 +++
>>>   drivers/scsi/scsi_lib.c  |  6 +++++-
>>>   include/scsi/scsi_host.h | 22 +++++++++++++++++++++-
>>>   3 files changed, 29 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index 8352f90d997d..27296addaf63 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -474,6 +474,9 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_host_template *sht, int privsize)
>>>   	if (sht->virt_boundary_mask)
>>>   		shost->virt_boundary_mask = sht->virt_boundary_mask;
>>>   
>>> +	if (sht->nr_reserved_cmds)
>>> +		shost->nr_reserved_cmds = sht->nr_reserved_cmds;
>>> +
>>>   	device_initialize(&shost->shost_gendev);
>>>   	dev_set_name(&shost->shost_gendev, "host%d", shost->host_no);
>>>   	shost->shost_gendev.bus = &scsi_bus_type;
>>> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
>>> index 6ffc9e4258a8..f6e53c6d913c 100644
>>> --- a/drivers/scsi/scsi_lib.c
>>> +++ b/drivers/scsi/scsi_lib.c
>>> @@ -1974,8 +1974,12 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
>>>   	else
>>>   		tag_set->ops = &scsi_mq_ops_no_commit;
>>>   	tag_set->nr_hw_queues = shost->nr_hw_queues ? : 1;
>>> +
>>>   	tag_set->nr_maps = shost->nr_maps ? : 1;
>>> -	tag_set->queue_depth = shost->can_queue;
>>> +	tag_set->queue_depth =
>>> +		shost->can_queue + shost->nr_reserved_cmds;
>>> +	tag_set->reserved_tags = shost->nr_reserved_cmds;
>>> +
>>>   	tag_set->cmd_size = cmd_size;
>>>   	tag_set->numa_node = dev_to_node(shost->dma_dev);
>>>   	tag_set->flags = BLK_MQ_F_SHOULD_MERGE;
>>> diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
>>> index 59aef1f178f5..149dcbd4125e 100644
>>> --- a/include/scsi/scsi_host.h
>>> +++ b/include/scsi/scsi_host.h
>>> @@ -366,10 +366,19 @@ struct scsi_host_template {
>>>   	/*
>>>   	 * This determines if we will use a non-interrupt driven
>>>   	 * or an interrupt driven scheme.  It is set to the maximum number
>>> -	 * of simultaneous commands a single hw queue in HBA will accept.
>>> +	 * of simultaneous commands a single hw queue in HBA will accept
>>> +	 * excluding internal commands.
>>>   	 */
>>>   	int can_queue;
>>>   
>>> +	/*
>>> +	 * This determines how many commands the HBA will set aside
>>> +	 * for internal commands. This number will be added to
>>> +	 * @can_queue to calcumate the maximum number of simultaneous
>>
> 
> Hi Damien,
> 
>> s/calcumate/calculate
>>
>> But this is weird. For SATA, can_queue is 32. Having reserved commands,
>> that number needs to stay the same. 
> 
> It does.
> 
>> We cannot have more than 32 tags.
> 
> We may have 32 regular tags and 1 reserved tag for SATA.

Right. But that is the messy part though. That extra 1 tag is actually not
a tag since all internal commands are non-NCQ commands that do not need a
tag...

I am working on command duration limits support currently. This feature
set has a new horrendous "improvement": a command can be aborted by the
device if it fails its duration limit, but the abort is done with a good
status + sense data available bit set so that the device queue is not
aborted entirely like with a regular NCQ command error.

For such aborted commands, the command sense data is set to
"COMPLETED/DATA UNAVAILABLE". In this case, the host needs to go read the
new "successful NCQ sense data log" to check that the command sense is
indeed "COMPLETED/DATA UNAVAILABLE". And to go read that log page without
stalling the device queue, we would need an internal NCQ (queuable) command.

Currently, that is not possible to do cleanly as there are no guarantees
we can get a free tag (there is a race between block layer tag allocation
and libata internal tag counting). So a reserved tag for that would be
nice. We would end up with 31 IO tags at most + 1 reserved tag for NCQ
commands + ATA_TAG_INTERNAL for non-NCQ. That last one would be rendered
rather useless. But that also means that we kind-of go back to the days
when Linux showed ATA drives max QD of 31...

I am still struggling with this particular use case and trying to make it
fit with your series. Trying out different things right now.


> 
>> I think keeping can_queue as the max queue depth with at most
>> nr_reserved_cmds tags reserved is better.
> 
> Maybe the wording in the comment can be improved as it originally 
> focused on SAS HBAs where there are no special rules for tagset depth or 
> how the tagset should be carved up to handle regular and reserved commands.

Indeed. And that would be for HBAs that do *not* use libsas/libata.
Otherwise, the NCQ vs non-NCQ reserved tag mess is there.

> 
> Thanks,
> John
> 
>>
>>> +	 * commands sent to the host.
>>> +	 */
>>> +	int nr_reserved_cmds;
>>> +
>>>   	/*
>>>   	 * In many instances, especially where disconnect / reconnect are
>>>   	 * supported, our host also has an ID on the SCSI bus.  If this is
>>> @@ -602,6 +611,11 @@ struct Scsi_Host {
>>>   	unsigned short max_cmd_len;
>>>   
>>>   	int this_id;
>>> +
>>> +	/*
>>> +	 * Number of commands this host can handle at the same time.
>>> +	 * This excludes reserved commands as specified by nr_reserved_cmds.
>>> +	 */
>>>   	int can_queue;
>>>   	short cmd_per_lun;
>>>   	short unsigned int sg_tablesize;
>>> @@ -620,6 +634,12 @@ struct Scsi_Host {
>>>   	 */
>>>   	unsigned nr_hw_queues;
>>>   	unsigned nr_maps;
>>> +
>>> +	/*
>>> +	 * Number of reserved commands to allocate, if any.
>>> +	 */
>>> +	unsigned nr_reserved_cmds;
>>> +
>>>   	unsigned active_mode:2;
>>>   
>>>   	/*
>>
>>
> 


-- 
Damien Le Moal
Western Digital Research
