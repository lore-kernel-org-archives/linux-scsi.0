Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C4A4C54EE9
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 07:05:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230219AbiI0HFL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 03:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230256AbiI0HFF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 03:05:05 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4FDC8A7F1;
        Tue, 27 Sep 2022 00:05:01 -0700 (PDT)
Received: from fraeml711-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4Mc9Zp47z1z685K1;
        Tue, 27 Sep 2022 15:03:46 +0800 (CST)
Received: from lhrpeml500003.china.huawei.com (7.191.162.67) by
 fraeml711-chm.china.huawei.com (10.206.15.60) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 09:04:58 +0200
Received: from [10.48.156.245] (10.48.156.245) by
 lhrpeml500003.china.huawei.com (7.191.162.67) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Tue, 27 Sep 2022 08:04:58 +0100
Message-ID: <f3e90970-5153-f6bc-5be8-c2c379be0d7f@huawei.com>
Date:   Tue, 27 Sep 2022 08:05:00 +0100
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
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <92d87d6c-9bd0-0cf9-1ced-bac104ea2d66@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.48.156.245]
X-ClientProxiedBy: lhrpeml100005.china.huawei.com (7.191.160.25) To
 lhrpeml500003.china.huawei.com (7.191.162.67)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 27/09/2022 00:05, Damien Le Moal wrote:
>>> ata_scsi_find_dev() returns NULL, turning
>>> __ata_change_queue_depth() into a nop, which prevents the user from
>>> setting the maximum queue depth of ATA devices used with libsas based
>>> HBAs.
>>>
>>> Fix this by renaming __ata_change_queue_depth() to
>>> ata_change_queue_depth() and adding a pointer to the ata_device
>>> structure of the target device as argument. This pointer is provided by
>>> ata_scsi_change_queue_depth() using ata_scsi_find_dev() in the case of
>>> a libata managed device and by sas_change_queue_depth() using
>>> sas_to_ata_dev() in the case of a libsas managed ata device.
>> This seems ok. But could you alternatively use ata_for_each_dev() and
>> match by ata_device.sdev pointer? That pointer is set quite late in the
>> probe, though, so maybe it would not work.
> Not sure I understand why we should search for the ata device again using
> ata_for_each_dev() when sas_to_ata_dev() gives us directly what we need
> for the libsas controlled device... Can you clarify ?
> 

Sure, we can use sas_to_ata_dev() to get the ata_device.

I am just suggesting my way such that we can have a consistent method to 
get the ata_device between all libata users and we don't need to change 
the ata_change_queue_depth() interface. It would be something like:

struct ata_device *ata_scsi_find_dev(struct ata_port *ap, const struct 
scsi_device *scsidev)
{
	struct ata_link *link;
	struct ata_device *dev;

	ata_for_each_link(link, ap, EDGE) {
		ata_for_each_dev(dev, link, ENABLED) {
			if (scsidev == dev->sdev)
				return dev;
		}
	}
	// todo: check pmp
	return NULL;
}

Thanks,
John
