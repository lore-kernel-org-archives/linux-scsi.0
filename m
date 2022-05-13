Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38D41C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 13 May 2022 12:01:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380106AbiEMMBT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 May 2022 08:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241025AbiEMMBR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 May 2022 08:01:17 -0400
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51EA5536E;
        Fri, 13 May 2022 05:01:15 -0700 (PDT)
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4L06b94Tx2z688qL;
        Fri, 13 May 2022 19:57:41 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.24; Fri, 13 May 2022 14:01:13 +0200
Received: from [10.47.25.226] (10.47.25.226) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Fri, 13 May
 2022 13:01:12 +0100
Message-ID: <2b7d091b-4caf-948f-b41a-29a7fcb9fc2a@huawei.com>
Date:   Fri, 13 May 2022 13:01:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
To:     <linux-block@vger.kernel.org>, <linux-scsi@vger.kernel.org>
CC:     "chenxiang66@hisilicon.com >> Xiang Chen" <chenxiang66@hisilicon.com>,
        "liyihang (E)" <liyihang6@hisilicon.com>
From:   John Garry <john.garry@huawei.com>
Subject: [bug report] IOMMU reports data translation fault for fio testing
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.25.226]
X-ClientProxiedBy: lhreml748-chm.china.huawei.com (10.201.108.198) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi guys,

My colleague Yihang Li noticed this issue when testing throughput for 
hisi SAS arm64 controller on v5.18-rc6:

estuary:/$ bash ./create_fio_task.sh 4k read 128 1
test2  4k
my_runtime 1500
Creat 4k_read_depth128_fiotest file successfully
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
job1: (g=0): rw=read, bs=4K-4K/4K-4K/4K-4K, ioengine=libaio, iodepth=128
fio-2.2.10
Starting 10 processes
N[  304.798377] arm-smmu-v3 arm-smmu-v3.3.auto: event 0x10 
received:iops] [eta 23m:39s]
O[  304.804431] arm-smmu-v3 arm-smmu-v3.3.auto:         0x0000741000000010
T[  304.810404] arm-smmu-v3 arm-smmu-v3.3.auto:         0x000012000000007a
I[  304.816379] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff6000
C[  304.822354] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff6000
E[  304.828330] arm-smmu-v3 arm-smmu-v3.3.auto: event 0x10 received:
:[  304.834392] arm-smmu-v3 arm-smmu-v3.3.auto:         0x0000741000000010
[  304.840368] arm-smmu-v3 arm-smmu-v3.3.auto:         0x0000120000000058
[  304.846344] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff6100
R[  304.852320] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff6000
a[  304.858297] arm-smmu-v3 arm-smmu-v3.3.auto: event 0x10 received:
s[  304.864361] arm-smmu-v3 arm-smmu-v3.3.auto:         0x0000741000000010
I[  304.870337] arm-smmu-v3 arm-smmu-v3.3.auto:         0x000012000000004a
n[  304.876313] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff62c0
t[  304.882289] arm-smmu-v3 arm-smmu-v3.3.auto:         0x00000000abff6000

Event 0x10 is a translation fault, meaning the DMA mapping is prob 
misconfigured.

I don't think it's an IOMMU issue as I tested that separately with a DMA 
mapping benchmark driver.

I'm told v5.17-rc7 does not have the issue. Any idea on the possible 
cause or if there is a fix in waiting? It could be an issue with the 
SCSI hba driver.

I'll bisect in the meantime.

thanks,
John
