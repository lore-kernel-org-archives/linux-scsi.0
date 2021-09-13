Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9917C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 09:21:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9892860FBF
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Sep 2021 09:21:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238506AbhIMJXF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Sep 2021 05:23:05 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3769 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238493AbhIMJXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Sep 2021 05:23:04 -0400
Received: from fraeml714-chm.china.huawei.com (unknown [172.18.147.200])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4H7LXK2lQtz6FCpR;
        Mon, 13 Sep 2021 17:19:29 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml714-chm.china.huawei.com (10.206.15.33) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Mon, 13 Sep 2021 11:21:47 +0200
Received: from [10.47.80.114] (10.47.80.114) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Mon, 13 Sep
 2021 10:21:46 +0100
Subject: Re: [PATCH 0/4] scsi: remove last references to scsi_cmnd.tag
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        <linux-scsi@vger.kernel.org>,
        "Russell King (Oracle)" <linux@armlinux.org.uk>
References: <20210819084007.79233-1-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <ef629eef-fe55-2c8b-2825-67c43e4f4cd8@huawei.com>
Date:   Mon, 13 Sep 2021 10:25:27 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <20210819084007.79233-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.80.114]
X-ClientProxiedBy: lhreml754-chm.china.huawei.com (10.201.108.204) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

+ Russell

On 19/08/2021 09:40, Hannes Reinecke wrote:

The arm rpc_defconfig build is now broken on mainline.

I suggest resending this series, please.

Thanks

> Hi all,
> 
> with commit 4c7b6ea336c1 ("scsi: core: Remove scsi_cmnd.tag") drivers
> cannot reference the SCSI command tag anymore.
> Arguably these drivers would have stopped working since 2010 with
> the switch to block layer tags in SCSI anyway, so chances are no-one
> had been using tagging in these drivers.
> 
> This patchset fixes up these usage; for fas216 we're just switching
> to use the appropriate wrapper.
> For acornscsi the tagged queue handling is removed altogether as it
> was broken in the first place, and no-one since the switch to git
> could be bothered to fix it.
> And the patchset has the nice side-effect that we can remove the
> scsi_device.current_tag field.
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (4):
>    scsi: Introduct scsi_cmd_to_tag()
>    fas216: kill scmd->tag
>    acornscsi: remove tagged queuing vestiges
>    scsi: remove 'current_tag'
> 
>   drivers/scsi/arm/Kconfig     |  11 ----
>   drivers/scsi/arm/acornscsi.c | 103 ++++++++---------------------------
>   drivers/scsi/arm/fas216.c    |  31 +++--------
>   drivers/scsi/arm/queue.c     |   2 +-
>   include/scsi/scsi_cmnd.h     |   7 +++
>   include/scsi/scsi_device.h   |   1 -
>   6 files changed, 38 insertions(+), 117 deletions(-)
> 

