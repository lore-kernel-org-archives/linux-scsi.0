Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D264EC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 12:34:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiKGMev (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:34:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232239AbiKGMeu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 07:34:50 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644B010FEC
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 04:34:48 -0800 (PST)
Received: from canpemm500004.china.huawei.com (unknown [172.30.72.54])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4N5Vzh1bhMzRp59;
        Mon,  7 Nov 2022 20:34:40 +0800 (CST)
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Mon, 7 Nov 2022 20:34:46 +0800
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_phy_add()
To:     Yang Yingliang <yangyingliang@huawei.com>,
        <linux-scsi@vger.kernel.org>
CC:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <john.g.garry@oracle.com>
References: <20221107115401.3399891-1-yangyingliang@huawei.com>
From:   Jason Yan <yanaijie@huawei.com>
Message-ID: <cd67ea3f-4d50-2416-c6c7-3f1e82877117@huawei.com>
Date:   Mon, 7 Nov 2022 20:34:45 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20221107115401.3399891-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.14]
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/11/7 19:54, Yang Yingliang wrote:
> If transport_add_device() fails in sas_phy_add(), but it's not handled,
> it will lead kernel crash because of trying to delete not added device
> in transport_remove_device() called from sas_remove_host().
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
> CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc1+ #173
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : device_del+0x54/0x3d0
> lr : device_del+0x37c/0x3d0
> Call trace:
>   device_del+0x54/0x3d0
>   attribute_container_class_device_del+0x28/0x38
>   transport_remove_classdev+0x6c/0x80
>   attribute_container_device_trigger+0x108/0x110
>   transport_remove_device+0x28/0x38
>   sas_phy_delete+0x30/0x60 [scsi_transport_sas]
>   do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
>   device_for_each_child+0x68/0xb0
>   sas_remove_children+0x40/0x50 [scsi_transport_sas]
>   sas_remove_host+0x20/0x38 [scsi_transport_sas]
>   hisi_sas_remove+0x40/0x68 [hisi_sas_main]
>   hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
>   platform_remove+0x2c/0x60
> 
> Fix this by checking and handling return value of transport_add_device()
> in sas_phy_add().
> 
> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v1 -> v2:
>    Update title and refactor the error handling suggested by John.
> ---
>   drivers/scsi/scsi_transport_sas.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)

Looks good,
Reviewed-by: Jason Yan <yanaijie@huawei.com>
