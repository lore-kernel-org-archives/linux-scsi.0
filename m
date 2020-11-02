Return-Path: <SRS0=0UYT=EI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 08AFCC00A89
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 12:53:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE08622273
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Nov 2020 12:53:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728741AbgKBMxW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Nov 2020 07:53:22 -0500
Received: from szxga06-in.huawei.com ([45.249.212.32]:7443 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728253AbgKBMxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Nov 2020 07:53:22 -0500
Received: from DGGEMS407-HUB.china.huawei.com (unknown [172.30.72.60])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4CPtBR6X17zhfpq;
        Mon,  2 Nov 2020 20:53:19 +0800 (CST)
Received: from [10.174.179.35] (10.174.179.35) by
 DGGEMS407-HUB.china.huawei.com (10.3.19.207) with Microsoft SMTP Server id
 14.3.487.0; Mon, 2 Nov 2020 20:53:11 +0800
Subject: Re: [PATCH] scsi: libiscsi: Fix cmds hung when sd_shutdown
To:     <linux-scsi@vger.kernel.org>, <open-iscsi@googlegroups.com>
CC:     <lduncan@suse.com>, <cleech@redhat.com>, <jejb@linux.ibm.com>,
        <lutianxiong@huawei.com>, <linfeilong@huawei.com>,
        <liuzhiqiang26@huawei.com>
References: <1604132622-497115-1-git-send-email-wubo40@huawei.com>
From:   Wu Bo <wubo40@huawei.com>
Message-ID: <1c38befc-3faa-8420-9156-3804f5129475@huawei.com>
Date:   Mon, 2 Nov 2020 20:53:11 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.2.2
MIME-Version: 1.0
In-Reply-To: <1604132622-497115-1-git-send-email-wubo40@huawei.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.35]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020/10/31 16:23, Wu Bo wrote:
> For some reason, during reboot the system, iscsi.service failed to
> logout all sessions. kernel will hang forever on its
> sd_sync_cache() logic, after issuing the SYNCHRONIZE_CACHE cmd to all
> still existent paths.
> 
> [ 1044.098991] reboot: Mddev shutdown finished.
> [ 1044.099311] reboot: Usermodehelper disable finished.
> [ 1050.611244]  connection2:0: ping timeout of 5 secs expired, recv timeout 5, last rx 4295152378, last ping 4295153633, now 4295154944
> [ 1348.599676] Call trace:
> [ 1348.599887]  __switch_to+0xe8/0x150
> [ 1348.600113]  __schedule+0x33c/0xa08
> [ 1348.600372]  schedule+0x2c/0x88
> [ 1348.600567]  schedule_timeout+0x184/0x3a8
> [ 1348.600820]  io_schedule_timeout+0x28/0x48
> [ 1348.601089]  wait_for_common_io.constprop.2+0x168/0x258
> [ 1348.601425]  wait_for_completion_io_timeout+0x28/0x38
> [ 1348.601762]  blk_execute_rq+0x98/0xd8
> [ 1348.602006]  __scsi_execute+0xe0/0x1e8
> [ 1348.602262]  sd_sync_cache+0xd0/0x220 [sd_mod]
> [ 1348.602551]  sd_shutdown+0x6c/0xf8 [sd_mod]
> [ 1348.602826]  device_shutdown+0x13c/0x250
> [ 1348.603078]  kernel_restart_prepare+0x5c/0x68
> [ 1348.603400]  kernel_restart+0x20/0x98
> [ 1348.603683]  __se_sys_reboot+0x214/0x260
> [ 1348.603987]  __arm64_sys_reboot+0x24/0x30
> [ 1348.604300]  el0_svc_common+0x80/0x1b8
> [ 1348.604590]  el0_svc_handler+0x78/0xe0
> [ 1348.604877]  el0_svc+0x10/0x260
> 

Hi,

Sorry, I did not add this commit:

commit 0ab710458da113a71c461c4df27e7f1353d9f864
Author: Bharath Ravi <rbharath@google.com>
Date:   Sat Jan 25 01:19:25 2020 -0500

     scsi: iscsi: Perform connection failure entirely in kernel space

It makes the session recovery in the kernel do not need iscsid.

This commit was not added in my system, So the problem still exists. 
After adding the patch, Tested and verified that the problem I 
encountered has been resolved.

Please ignore this patch.

Thanks.
