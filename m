Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F4A7C2BB3F
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Nov 2023 01:08:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230024AbjKPBIq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Nov 2023 20:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229692AbjKPBIp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Nov 2023 20:08:45 -0500
Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1534492;
        Wed, 15 Nov 2023 17:08:42 -0800 (PST)
Received: from mail.maildlp.com (unknown [172.19.163.216])
        by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4SW23Q6LP2z4f3m6s;
        Thu, 16 Nov 2023 09:08:34 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
        by mail.maildlp.com (Postfix) with ESMTP id E49B71A0181;
        Thu, 16 Nov 2023 09:08:38 +0800 (CST)
Received: from [10.174.176.73] (unknown [10.174.176.73])
        by APP1 (Coremail) with SMTP id cCh0CgDX2xGMa1VlS1opBA--.65263S3;
        Thu, 16 Nov 2023 09:08:30 +0800 (CST)
Subject: Re: [PATCH v5 2/3] scsi: core: Support disabling fair tag sharing
To:     Bart Van Assche <bvanassche@acm.org>,
        Yu Kuai <yukuai1@huaweicloud.com>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>,
        Keith Busch <kbusch@kernel.org>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Ed Tsai <ed.tsai@mediatek.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        "yukuai (C)" <yukuai3@huawei.com>
References: <20231114180426.1184601-1-bvanassche@acm.org>
 <20231114180426.1184601-3-bvanassche@acm.org>
 <80dee412-2fda-6a23-0b62-08f87bd7e607@huaweicloud.com>
 <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
From:   Yu Kuai <yukuai1@huaweicloud.com>
Message-ID: <d1e94a08-f28e-ddd9-5bda-7fee28b87f31@huaweicloud.com>
Date:   Thu, 16 Nov 2023 09:08:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <d706f265-f991-45c0-a551-34ecdee55f7c@acm.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: cCh0CgDX2xGMa1VlS1opBA--.65263S3
X-Coremail-Antispam: 1UD129KBjvdXoWruFyrZFW3tr13KF4UWFW8tFb_yoWkCFXE9w
        4DZF929F1UJwsay3ZYyr1fZrZ0ya12qr10yr10vrZIkrW7Ww1rCw1ru393Z3y5Ga18JFn8
        C3s8W34fZF4jqjkaLaAFLSUrUUUUUb8apTn2vfkv8UJUUUU8Yxn0WfASr-VFAUDa7-sFnT
        9fnUUIcSsGvfJTRUUUb3kFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k26cxKx2IYs7xG
        6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8w
        A2z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_
        Gr1UM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s
        0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xII
        jxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr
        1lF7xvr2IY64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY
        04v7Mxk0xIA0c2IEe2xFo4CEbIxvr21l42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Yz7
        v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zVAF
        1VAY17CE14v26r1q6r43MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4lIx
        AIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42xK8VAvwI8IcIk0rVWrZr1j6s0D
        MIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIda
        VFxhVjvjDU0xZFpf9x0JUdHUDUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

在 2023/11/16 2:19, Bart Van Assche 写道:
> On 11/14/23 23:24, Yu Kuai wrote:
>> 在 2023/11/15 2:04, Bart Van Assche 写道:
>>> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
>>> index d7f51b84f3c7..872f87001374 100644
>>> --- a/drivers/scsi/hosts.c
>>> +++ b/drivers/scsi/hosts.c
>>> @@ -442,6 +442,7 @@ struct Scsi_Host *scsi_host_alloc(const struct 
>>> scsi_host_template *sht, int priv
>>>       shost->no_write_same = sht->no_write_same;
>>>       shost->host_tagset = sht->host_tagset;
>>>       shost->queuecommand_may_block = sht->queuecommand_may_block;
>>> +    shost->disable_fair_tag_sharing = sht->disable_fair_tag_sharing;
>>
>> Can we also consider to disable fair tag sharing by default for the
>> driver that total driver tags is less than a threshold?
> I don't want to do this because such a change could disable fair tag
> sharing for drivers that support both SSDs and hard disks being associated
> with a single SCSI host.

Ok, then is this possible to add a sysfs entry to disable/enable fair
tag sharing manually?

Thanks,
Kuai

> 
> Thanks,
> 
> Bart.
> 
> .
> 

