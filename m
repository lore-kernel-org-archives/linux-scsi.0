Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4862C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Feb 2022 13:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343625AbiBKNF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Feb 2022 08:05:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:40592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229645AbiBKNF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Feb 2022 08:05:26 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCEDCF3D
        for <linux-scsi@vger.kernel.org>; Fri, 11 Feb 2022 05:05:25 -0800 (PST)
Received: from fraeml737-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JwDP63kBdz67ZCR;
        Fri, 11 Feb 2022 21:05:14 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml737-chm.china.huawei.com (10.206.15.218) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 11 Feb 2022 14:05:23 +0100
Received: from [10.47.87.89] (10.47.87.89) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 11 Feb
 2022 13:05:23 +0000
Message-ID: <c6dcf35a-4d0a-b812-36b9-20c5b681aa42@huawei.com>
Date:   Fri, 11 Feb 2022 13:05:22 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v2 21/24] scsi: pm8001: Fix pm8001_task_exec()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>,
        Luo Jiaxing <luojiaxing@huawei.com>
References: <20220211073704.963993-1-damien.lemoal@opensource.wdc.com>
 <20220211073704.963993-22-damien.lemoal@opensource.wdc.com>
 <84d4c573-661a-39d5-f639-a3eb9ba8c0ee@huawei.com>
 <c21ed2da-73e9-b388-cef6-d350b504d0f1@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <c21ed2da-73e9-b388-cef6-d350b504d0f1@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.89]
X-ClientProxiedBy: lhreml727-chm.china.huawei.com (10.201.108.78) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/02/2022 12:57, Damien Le Moal wrote:
>> I thought the current code was ok, as we init n_elem = 0 and we only
>> ever loop once. Am I missing something?
> It was not clear to me because of the loop. If the loop is done only
> once, why the loop in the first place ?
> 
> Hold on...
> 
> Oh ! It is a while(0)... OK, this too ugly to live.

I didn't see the point of the while (0) loop at all.

  We need to do
> something about this. The continue at the beginning of the loop seems
> totally crazy as it may lead to the same task being reused, so multiple
> ->task_done() calls for the same task. Is that sane ?

No.

And I think continue in while(0) has has effect as break - it falls out.

Thanks,
John


