Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11440C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Jun 2022 17:14:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231950AbiFXROl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Jun 2022 13:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiFXROk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Jun 2022 13:14:40 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57ABD63611
        for <linux-scsi@vger.kernel.org>; Fri, 24 Jun 2022 10:14:38 -0700 (PDT)
Received: from fraeml736-chm.china.huawei.com (unknown [172.18.147.226])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4LV3cq6cy6z67m9N;
        Sat, 25 Jun 2022 01:14:03 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml736-chm.china.huawei.com (10.206.15.217) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 19:14:35 +0200
Received: from [10.126.175.21] (10.126.175.21) by
 lhreml724-chm.china.huawei.com (10.201.108.75) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 24 Jun 2022 18:14:35 +0100
Message-ID: <8fb3b093-55f0-1fab-81f4-e8519810a978@huawei.com>
Date:   Fri, 24 Jun 2022 18:14:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
From:   John Garry <john.garry@huawei.com>
Subject: About pm8001 NCQ error handling
To:     Hannes Reinecke <hare@suse.de>,
        Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
CC:     <linux-scsi@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.126.175.21]
X-ClientProxiedBy: lhreml715-chm.china.huawei.com (10.201.108.66) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Damien, Hannes,

I want to remove usage of sas_alloc_slow_task() outside libsas as prep 
work for SCSI reserved command handling. The pm8001 driver uses 
sas_alloc_slow_task() for dealing with NCQ error handling, which was 
added in commit c6b9ef5779c3 ("[SCSI] pm80xx: NCQ error handling 
changes"). So it seems a good opportunity to fix that code so that it 
does not send read log ext from the LLDD and we can drop those 
sas_alloc_slow_task() calls.

That NCQ error handling in that driver consists of 2x main steps:

1. send read log ext page 10 to analyze/clear the error
- I do note the crazy code to alloc a domain device there cf. 
pm8001_send_read_log()
2. send special pm8001 SATA_ABORT command to abort any pending IO in the 
drive/host

I actually have to solve a very similar NCQ disk error problem for 
hisi_sas driver.

As for improving this, an idea is to set link->eh_info>err_mask |= 
AC_ERR_DEV and call ata_std_sched_eh() when 
IO_XFER_ERROR_ABORTED_NCQ_MODE occurs and take advantage of the libata 
fastdrain feature to abort all the outstanding IO. This calls the SCSI 
error handler, in which we could send the SATA_ABORT in the libsas abort 
task or LU reset handler LLDD callback.

The problem here is where to call the read log ext page 10 happens in 
this handling - when we finally get around to it in ata_eh_autopsy() -> 
ata_eh_link_autopsy() -> ata_eh_link_autopsy(), the port is frozen and 
all qc are already mark failed. So we need it earlier. Do you have any 
ideas on this or whether this approach is sensible?

Thanks,
John
