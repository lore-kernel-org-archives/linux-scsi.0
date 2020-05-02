Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8ECCFC47257
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:23:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 715592495B
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 12:23:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727867AbgEBMX4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 08:23:56 -0400
Received: from mx2.suse.de ([195.135.220.15]:41278 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727113AbgEBMXz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 May 2020 08:23:55 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 8D00DAA55;
        Sat,  2 May 2020 12:23:54 +0000 (UTC)
Subject: Re: [PATCH RFC v3 00/41] scsi: enable reserved commands for LLDDs
To:     John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart van Assche <bvanassche@acm.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20200430131904.5847-1-hare@suse.de>
 <55c7aaf0-6863-a3ac-9e22-31eec1a359e4@huawei.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <9489fadc-3d80-1ea2-057c-8cef37684fe1@suse.de>
Date:   Sat, 2 May 2020 14:23:46 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <55c7aaf0-6863-a3ac-9e22-31eec1a359e4@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/1/20 2:01 PM, John Garry wrote:
> On 30/04/2020 14:18, Hannes Reinecke wrote:
> 
> Thanks for this.
> 
>> Conversion of the SAS drivers hisi_sas, pm8001, and mv_sas are
>> compile tested only; I'd be grateful if someone could give
>> these patches a spin on that hardware, too.
> 
> So after some build fixups, I get this a NULL pointer deref:
> 
> [ 5.565899]  sas_find_dev_by_rphy+0x3c/0x104
> [ 5.570182]  sas_target_alloc+0x18/0x84
> [ 5.574029]  scsi_alloc_target+0x20c/0x304
> [ 5.578136]  scsi_get_virtual_dev+0x44/0xec
> [ 5.582331]  sas_register_ha+0xd0/0x258
> [ 5.586178]  hisi_sas_probe+0x2ec/0x36c
> [ 5.590024]  hisi_sas_v2_probe+0x34/0x64
> [ 5.593958]  platform_drv_probe+0x4c/0xa0
> [ 5.597978]  really_probe+0xd8/0x334
> [ 5.601561]  driver_probe_device+0x58/0xe8
> [ 5.605669]  device_driver_attach+0x68/0x70
> [ 5.609864]  __driver_attach+0x9c/0xf8
> [ 5.613622]  bus_for_each_dev+0x50/0xa0
> [ 5.617468]  driver_attach+0x20/0x28
> [ 5.621051]  bus_add_driver+0x148/0x1fc
> [ 5.624897]  driver_register+0x6c/0x124
> [ 5.628742]  __platform_driver_register+0x48/0x50
> [ 5.633463]  hisi_sas_v2_driver_init+0x18/0x20
> [ 5.637921]  do_one_initcall+0x50/0x194
> [ 5.641767]  kernel_init_freeable+0x1e4/0x24c
> 
> And so we need this change:
> 
> commit 51f607bf91853026af102367d9e6666605cdec61 (HEAD)
> Author: John Garry <john.garry@huawei.com>
> Date:   Fri May 1 12:30:32 2020 +0100
> 
>      scsi: libsas: Don't attempt to find scsi host rphy in target alloc
> 
>      It doesn't have one.
> 
>      Signed-off-by: John Garry <john.garry@huawei.com>
> 
> diff --git a/drivers/scsi/libsas/sas_scsi_host.c 
> b/drivers/scsi/libsas/sas_scsi_host.c
> index 585e0df5fce2..f1a823d51044 100644
> --- a/drivers/scsi/libsas/sas_scsi_host.c
> +++ b/drivers/scsi/libsas/sas_scsi_host.c
> @@ -822,8 +825,15 @@ struct domain_device *sas_find_dev_by_rphy(struct 
> sas_rphy *rphy)
> 
>   int sas_target_alloc(struct scsi_target *starget)
>   {
> -       struct sas_rphy *rphy = dev_to_rphy(starget->dev.parent);
> -       struct domain_device *found_dev = sas_find_dev_by_rphy(rphy);
> +       struct device *parent = starget->dev.parent;
> +       struct sas_rphy *rphy;
> +       struct domain_device *found_dev;
> +
> +       if (scsi_is_host_device(parent))
> +               return 0;
> +
> +       rphy = dev_to_rphy(parent);
> +       found_dev = sas_find_dev_by_rphy(rphy);
> 
> 
Thank you, will be including it in the next round.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
