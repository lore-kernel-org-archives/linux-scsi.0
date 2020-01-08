Return-Path: <SRS0=fkLW=25=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EB7CC33C9E
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 11:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 586F7206DA
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jan 2020 11:53:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727380AbgAHLxt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jan 2020 06:53:49 -0500
Received: from lhrrgout.huawei.com ([185.176.76.210]:2235 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726290AbgAHLxs (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 8 Jan 2020 06:53:48 -0500
Received: from lhreml708-cah.china.huawei.com (unknown [172.18.7.108])
        by Forcepoint Email with ESMTP id 3E7AA4C5978AABF20FD3;
        Wed,  8 Jan 2020 11:53:47 +0000 (GMT)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 lhreml708-cah.china.huawei.com (10.201.108.49) with Microsoft SMTP Server
 (TLS) id 14.3.408.0; Wed, 8 Jan 2020 11:53:46 +0000
Received: from [127.0.0.1] (10.202.226.43) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.1713.5; Wed, 8 Jan 2020
 11:53:46 +0000
Subject: Re: [PATCH v1] driver core: Use list_del_init to replace list_del at
 device_links_purge()
To:     Luo Jiaxing <luojiaxing@huawei.com>, <gregkh@linuxfoundation.org>,
        <saravanak@google.com>, <jejb@linux.ibm.com>,
        <James.Bottomley@suse.de>, <James.Bottomley@HansenPartnership.com>
CC:     <linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
From:   John Garry <john.garry@huawei.com>
Message-ID: <875eb2dc-a0d3-72e5-a27b-48fa38687c8c@huawei.com>
Date:   Wed, 8 Jan 2020 11:53:45 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <1578483244-50723-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.202.226.43]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 08/01/2020 11:34, Luo Jiaxing wrote:

+ linux-scsi, Martin

> We found that enabling kernel compilation options CONFIG_SCSI_ENCLOSURE and
> CONFIG_ENCLOSURE_SERVICES, repeated initialization and deletion of the same
> SCSI device will cause system panic, as follows:
> [72.425705] Unable to handle kernel paging request at virtual address
> dead000000000108
> ...
> [72.595093] Call trace:
> [72.597532] device_del + 0x194 / 0x3a0
> [72.601012] enclosure_remove_device + 0xbc / 0xf8
> [72.605445] ses_intf_remove + 0x9c / 0xd8
> [72.609185] device_del + 0xf8 / 0x3a0
> [72.612576] device_unregister + 0x14 / 0x30
> [72.616489] __scsi_remove_device + 0xf4 / 0x140
> [72.620747] scsi_remove_device + 0x28 / 0x40
> [72.624745] scsi_remove_target + 0x1c8 / 0x220

please share the full crash stack frame and the commands used to trigger 
it. Some people prefer the timestamp removed also.

> 
> After analysis, we see that in the error scenario, the ses module has the
> following calling sequence:
> device_register() -> device_del() -> device_add() -> device_del().
> The first call to device_del() is fine, but the second call to device_del()
> will cause a system panic.
> 
> Through disassembly, we locate that panic happen when device_links_purge()
> call list_del() to remove device_links.needs_suppliers from list, and
> list_del() will set this list entry's prev and next pointers to poison.
> So if INIT_LIST_HEAD() is not re-executed before the next list_del(), It
> will cause the system to access a memory address which is posioned.
> 
> Therefore, replace list_del() with list_del_init() can avoid such issue.
> 
> Fixes: e2ae9bcc4aaa ("driver core: Add support for linking devices during device addition")
> Signed-off-by: Luo Jiaxing <luojiaxing@huawei.com>
> Reviewed-by: John Garry <john.garry@huawei.com>

This tag was only implicitly granted, but I thought that the fix looked 
ok, so:

Reviewed-by: John Garry <john.garry@huawei.com>

> ---
>   drivers/base/core.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/base/core.c b/drivers/base/core.c
> index 42a6724..7b9b0d6 100644
> --- a/drivers/base/core.c
> +++ b/drivers/base/core.c
> @@ -1103,7 +1103,7 @@ static void device_links_purge(struct device *dev)
>   	struct device_link *link, *ln;
>   
>   	mutex_lock(&wfs_lock);
> -	list_del(&dev->links.needs_suppliers);
> +	list_del_init(&dev->links.needs_suppliers);
>   	mutex_unlock(&wfs_lock);
>   
>   	/*
> 

