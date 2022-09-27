Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC8D9C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 09:47:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231390AbiI0Jrn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 05:47:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiI0Jrm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 05:47:42 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40571B4E96;
        Tue, 27 Sep 2022 02:47:40 -0700 (PDT)
Received: from fraeml709-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4McFBT0fqKz687Dc;
        Tue, 27 Sep 2022 17:46:25 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml709-chm.china.huawei.com (10.206.15.37) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 11:47:37 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 10:47:36 +0100
Message-ID: <d2c4a043-e998-db98-1fe1-47b53516d7cc@huawei.com>
Date:   Tue, 27 Sep 2022 10:47:39 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2 2/2] ata: libata-sata: Fix device queue depth control
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-ide@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20220925230817.91542-1-damien.lemoal@opensource.wdc.com>
 <20220925230817.91542-3-damien.lemoal@opensource.wdc.com>
 <5bab7eb9-7b91-8c06-e8c3-f2076bac78dc@huawei.com>
 <92d87d6c-9bd0-0cf9-1ced-bac104ea2d66@opensource.wdc.com>
 <f3e90970-5153-f6bc-5be8-c2c379be0d7f@huawei.com>
 <60721293-14e2-98be-37af-ce7c1b227f44@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <60721293-14e2-98be-37af-ce7c1b227f44@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml500003.china.huawei.com (7.191.162.67) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/2022 10:28, Damien Le Moal wrote:
>> Sure, we can use sas_to_ata_dev() to get the ata_device.
>>
>> I am just suggesting my way such that we can have a consistent method to
>> get the ata_device between all libata users and we don't need to change
>> the ata_change_queue_depth() interface. It would be something like:
>>
>> struct ata_device *ata_scsi_find_dev(struct ata_port *ap, const struct
>> scsi_device *scsidev)
>> {
>> 	struct ata_link *link;
>> 	struct ata_device *dev;
>>
>> 	ata_for_each_link(link, ap, EDGE) {
>> 		ata_for_each_dev(dev, link, ENABLED) {
>> 			if (scsidev == dev->sdev)
>> 				return dev;
>> 		}
>> 	}
>> 	// todo: check pmp
>> 	return NULL;
>> }
> I see. Need to think about this one... This may also unify the pmp case.
> Are you OK with the patch as is though ? 

I'm ok with your patchset, but let me test it and get back to you later 
today.

We can improve with something
> like the above on top later. Really need to fix that qd setting as it is
> causing problems for testing devices with/without ncq commands.

Out of curiosity, are you considering your patchset for 6.0?

> 

Thanks,
John
