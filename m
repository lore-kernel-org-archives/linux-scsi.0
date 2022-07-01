Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F520C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Jul 2022 07:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbiGAHpM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Jul 2022 03:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiGAHpL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Jul 2022 03:45:11 -0400
Received: from heian.cn.fujitsu.com (mail.cn.fujitsu.com [183.91.158.132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id A0C674F1A9
        for <linux-scsi@vger.kernel.org>; Fri,  1 Jul 2022 00:45:08 -0700 (PDT)
IronPort-Data: =?us-ascii?q?A9a23=3AtBV0fa1xyy7mdsGMQPbD5XJzkn2cJEfYwER7XOP?=
 =?us-ascii?q?LsXnJ0mkkgzUEmmdMDzvQbvuIMWrxL9wiO43g9k4B7JbSy9A2QQE+nZ1PZygU8?=
 =?us-ascii?q?JKaX7x1DatR0xu6d5SFFAQ+hyknQoGowPscEzmM9n9BDpC79SMmjfvQH+KlYAL?=
 =?us-ascii?q?5EnsZqTFMGX5JZS1Ly7ZRbr5A2bBVMivV0T/Ai5S31GyNh1aYBlkpB5er83uDi?=
 =?us-ascii?q?hhdVAQw5TTSbdgT1LPXeuJ84Jg3fcldJFOgKmVY83LTegrN8F251juxExYFAdX?=
 =?us-ascii?q?jnKv5c1ERX/jZOg3mZnh+AvDk20Yd4HdplPtT2Pk0MC+7jx2NnsJxyddMvJqYR?=
 =?us-ascii?q?xorP7HXhaIWVBww/yRWZPcZoO6Wfifj2SCU5wicG5f2+N1kEkgwNJYD8eZ6KWh?=
 =?us-ascii?q?F8LofMj9lRhKEh+Twz7uhUPhEhtkqM8TqeogYvxlIzzjUAvs7QrjATr/M6Nse2?=
 =?us-ascii?q?y0/7uhOFvb2Y9EFLzZiBDzFagdTO1FREJ8ikf2zi3/XdCdRo1aY46Ew5gD7yQ1?=
 =?us-ascii?q?33/7pPdv9YNGGRcxJ2E2fowru/23jDzkBKceSjzaImlqoh+nSjWbgU5kTPKO3+?=
 =?us-ascii?q?+Qsg1CJwGEXThoMWjOGTVOR4qKlc4sHbRVKpWx19u5vnHFHh+LVB3WQyENodDZ?=
 =?us-ascii?q?FMzaIL9AH1Q=3D=3D?=
IronPort-HdrOrdr: =?us-ascii?q?A9a23=3AEBkx+6wpanImvNShR0RgKrPwEL1zdoMgy1kn?=
 =?us-ascii?q?xilNoH1uA6ilfqWV8cjzuiWbtN9vYhsdcLy7WZVoIkmskKKdg7NhXotKNTOO0A?=
 =?us-ascii?q?SVxepZnOnfKlPbexHWx6p00KdMV+xEAsTsMF4St63HyTj9P9E+4NTvysyVuds?=
 =?us-ascii?q?=3D?=
X-IronPort-AV: E=Sophos;i="5.88,333,1635177600"; 
   d="scan'208";a="127099774"
Received: from unknown (HELO cn.fujitsu.com) ([10.167.33.5])
  by heian.cn.fujitsu.com with ESMTP; 01 Jul 2022 15:45:07 +0800
Received: from G08CNEXMBPEKD05.g08.fujitsu.local (unknown [10.167.33.204])
        by cn.fujitsu.com (Postfix) with ESMTP id 6614B4D1719A;
        Fri,  1 Jul 2022 15:45:03 +0800 (CST)
Received: from G08CNEXCHPEKD08.g08.fujitsu.local (10.167.33.83) by
 G08CNEXMBPEKD05.g08.fujitsu.local (10.167.33.204) with Microsoft SMTP Server
 (TLS) id 15.0.1497.23; Fri, 1 Jul 2022 15:45:04 +0800
Received: from [192.168.122.212] (10.167.226.45) by
 G08CNEXCHPEKD08.g08.fujitsu.local (10.167.33.209) with Microsoft SMTP Server
 id 15.0.1497.23 via Frontend Transport; Fri, 1 Jul 2022 15:45:03 +0800
Subject: Re: [PATCH v2 3/3] scsi: core: Call blk_mq_free_tag_set() earlier
To:     Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>
References: <20220630213733.17689-1-bvanassche@acm.org>
 <20220630213733.17689-4-bvanassche@acm.org> <Yr5tlDkrTTldwjSq@T590>
From:   "Li, Zhijian" <lizhijian@fujitsu.com>
Message-ID: <ea467e1c-dc50-a0cd-2714-22551ec327b1@fujitsu.com>
Date:   Fri, 1 Jul 2022 15:45:02 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.1.1
MIME-Version: 1.0
In-Reply-To: <Yr5tlDkrTTldwjSq@T590>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-yoursite-MailScanner-ID: 6614B4D1719A.AC7A1
X-yoursite-MailScanner: Found to be clean
X-yoursite-MailScanner-From: lizhijian@fujitsu.com
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Send again, the format of previous one is wrong.

on 7/1/2022 11:44 AM, Ming Lei wrote:
> On Thu, Jun 30, 2022 at 02:37:33PM -0700, Bart Van Assche wrote:
>> There are two .exit_cmd_priv implementations. Both implementations use
>> resources associated with the SCSI host. Make sure that these resources are
> Please document what the exact resources associated with this SCSI host is.
>
> We need the root cause.
>
> I understand it might be related with module unloading, since ib_srp may
> be gone already, but not sure if it is the exact one in this report.
>
>> still available when .exit_cmd_priv is called by moving the .exit_cmd_priv
>> calls from scsi_host_dev_release() to scsi_forget_host(). Moving
>> blk_mq_free_tag_set() from scsi_host_dev_release() to scsi_forget_host() is
>> safe because scsi_forget_host() drains all the request queues that use the
>> host tag set. This guarantees that no requests are in flight and also that
>> no new requests will be allocated from the host tag set.
>>
>> This patch fixes the following use-after-free:
>>
>> ==================================================================
>> BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x27/0xd0 [ib_srp]
>> Read of size 8 at addr ffff888100337000 by task multipathd/16727
> What is the 8bytes buffer which triggers UAF? what does srp_exit_cmd_priv+0x27
> point to?

This bug was reported by me, let's input some debug information.
*Attention*: below debug info came from a modified source, so the offset it is a bit different from above one.


[  120.400572] ib_srp: lizhijian: srp_exit_cmd_priv:975: target_host ffff88810b8d6000, ffff88810b8d67e0
[  120.400578] ib_srp: lizhijian: srp_exit_cmd_priv:977: target_host ffff88810b8d6000, ffff88810b8d67e0
[  120.400590] ==================================================================
[  120.400592] BUG: KASAN: use-after-free in srp_exit_cmd_priv+0x6c/0x109 [ib_srp]
[  120.400616] Read of size 8 at addr ffff8881076b1800 by task multipathd/1417
[  120.400619]
[  120.400621] CPU: 0 PID: 1417 Comm: multipathd Not tainted 5.19.0-rc1-roce-flush+ #85
[  120.400626] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.14.0-27-g64f37cc530f1-prebuilt.qemu.org 04/01/2014
         


crash> struct srp_target_port.srp_host ffff88810b8d67e0
   srp_host = 0xffff8881076b1800,
crash> struct srp_target_port.srp_host
struct srp_target_port {
   [104] struct srp_host *srp_host;
}

crash> struct srp_host.srp_dev 0xffff8881076b1800
   srp_dev = 0xffff88800bcd1400,


crash> struct srp_device 0xffff88800bcd1400
struct srp_device {
   dev_list = {
     next = 0xffff888106fafd00,
     prev = 0xb680010900000749
   },
   dev = 0x0,
   pd = 0x0,
   global_rkey = 0,
   mr_page_mask = 3,
   mr_page_size = 181960704,
   mr_max_size = -30592,
   max_pages_per_mr = 117112064,
   has_fr = 129,
   use_fast_reg = 136
}


crash> dis -s srp_exit_cmd_priv+0x6c
FILE: ../drivers/infiniband/ulp/srp/ib_srp.c
LINE: 978

   973           struct srp_request *req;
   974
   975           pr_info("lizhijian: %s:%d: target_host %px, %px\n", __func__, __LINE__, shost, shost->hostdata);
   976           target = host_to_target(shost);
   977           pr_info("lizhijian: %s:%d: target_host %px, %px\n", __func__, __LINE__, shost, shost->hostdata);
* 978           dev = target->srp_host->srp_dev;
   979           ibdev = dev->dev;
   980           req = scsi_cmd_priv(cmd);
   981
   982           kfree(req->fr_list);
   983           if (req->indirect_dma_addr) {
   984                   ib_dma_unmap_single(ibdev, req->indirect_dma_addr,
   985                                       target->indirect_size,
   986                                       DMA_TO_DEVICE);
   987           }
   988           kfree(req->indirect_desc);
   989
   990           return 0;
   991   }


Thanks
Zhijian

>
>
> Thanks,
> Ming
>


