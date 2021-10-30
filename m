Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31319C433F5
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 02:56:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0A2E26101B
	for <linux-scsi@archiver.kernel.org>; Sat, 30 Oct 2021 02:56:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbhJ3C7M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 29 Oct 2021 22:59:12 -0400
Received: from szxga03-in.huawei.com ([45.249.212.189]:26209 "EHLO
        szxga03-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229700AbhJ3C7M (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Oct 2021 22:59:12 -0400
Received: from dggemv704-chm.china.huawei.com (unknown [172.30.72.56])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4Hh3nJ1KlVz8tyl;
        Sat, 30 Oct 2021 10:55:16 +0800 (CST)
Received: from kwepemm600003.china.huawei.com (7.193.23.202) by
 dggemv704-chm.china.huawei.com (10.3.19.47) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 10:56:40 +0800
Received: from [10.67.102.185] (10.67.102.185) by
 kwepemm600003.china.huawei.com (7.193.23.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.15; Sat, 30 Oct 2021 10:56:39 +0800
To:     <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
CC:     John Garry <john.garry@huawei.com>, <linux-kernel@vger.kernel.org>
From:   "liuqi (BA)" <liuqi115@huawei.com>
Subject: [ISSUE] WARNING in base/core.c when executing link reset of remote
 PHY and rmmod SAS driver simultaneously
Message-ID: <80100e01-0d8e-627d-e1cb-ecf1083359bb@huawei.com>
Date:   Sat, 30 Oct 2021 10:56:39 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.102.185]
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600003.china.huawei.com (7.193.23.202)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

I met a issue on v5.15-rc6, WARNING is triggered when executing link 
reset of remote PHY and rmmod SAS driver simultaneously. Here is the 
WARNING log:

WARNING: CPU: 61 PID: 21818 at drivers/base/core.c:1349 
__device_links_no_driver+0xb4/0xc0
  CPU: 61 PID: 21818 Comm: kworker/u256:4 Kdump: loaded Tainted: G 
  W         5.15.0-rc5+ #25
  Hardware name: Huawei TaiShan 2280 V2/BC82AMDC, BIOS 2280-V2 CS 
V5.B170.01 06/30/2021
  Workqueue: 0000:74:02.0_disco_q sas_revalidate_domain [libsas]
  pstate: 20400009 (nzCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
  pc : __device_links_no_driver+0xb4/0xc0
  lr : device_links_driver_cleanup+0xb0/0xfc
  sp : ffff800049e73b10
  x29: ffff800049e73b10 x28: 0000000000000000 x27: 0000000000000000
  x26: ffff00209ecd7428 x25: 0000000000000000 x24: ffff204002bc8000
  x23: ffff00209ff53190 x22: ffff00209ff53190 x21: 0000000000000001
  x20: ffff00209ff53230 x19: ffff00209ff53210 x18: 0000000000000030
  x17: 74796274736f6820 x16: 3a746c7573655220 x15: 3a64656c69616620
  x14: 2930312865686361 x13: 4b4f5f5245564952 x12: 443d657479627265
  x11: 7669726420343078 x10: ffff0020913b0640 x9 : ffffccc6d592b514
  x8 : ffff204002bc8a00 x7 : ffffffff80000000 x6 : 0000000000000000
  x5 : 0000000000000000 x4 : 0000000000000000 x3 : ffff00209ff53250
  x2 : 0000000000000003 x1 : 000000000000004c x0 : ffff00209ee60c00
  Call trace:
   __device_links_no_driver+0xb4/0xc0
   device_links_driver_cleanup+0xb0/0xfc
   __device_release_driver+0x198/0x23c
   device_release_driver+0x38/0x50
   bus_remove_device+0x130/0x140
   device_del+0x184/0x434
   __scsi_remove_device+0x118/0x150
   scsi_remove_target+0x1bc/0x240
   sas_rphy_remove+0x90/0x94
   sas_rphy_delete+0x24/0x3c
   sas_destruct_devices+0x64/0xa0 [libsas]
   sas_revalidate_domain+0xe4/0x150 [libsas]
   process_one_work+0x1e0/0x46c
   worker_thread+0x15c/0x464
   kthread+0x160/0x170
   ret_from_fork+0x10/0x20
  ---[ end trace 71e059eb58f85d4a ]---

Normally in __device_links_no_driver(), link->status is 
DL_STATE_SUPPLIER_UNBIND, but in the WARNING scenario, link->status is 
DL_STATE_ACTIVE.

I'm not sure this warning is caused by libsas, lldd or sas scsi 
transport code. Does anyone have any ideas?

Thanks,
Qi
