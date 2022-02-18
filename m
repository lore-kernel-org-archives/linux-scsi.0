Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 421D7C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 11:21:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233480AbiBRLVu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Feb 2022 06:21:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231375AbiBRLVt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Feb 2022 06:21:49 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DEEE45797
        for <linux-scsi@vger.kernel.org>; Fri, 18 Feb 2022 03:21:29 -0800 (PST)
Received: from fraeml702-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K0TlX2H5zz686th;
        Fri, 18 Feb 2022 19:20:56 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml702-chm.china.huawei.com (10.206.15.51) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id
 15.1.2308.21; Fri, 18 Feb 2022 12:21:27 +0100
Received: from [10.47.86.67] (10.47.86.67) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 18 Feb
 2022 11:21:26 +0000
Message-ID: <6b5065d5-ab4e-9e0f-7fed-844e3dddf98c@huawei.com>
Date:   Fri, 18 Feb 2022 11:21:26 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH v3 27/31] scsi: pm8001: Cleanup pm8001_queue_command()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Xiang Chen <chenxiang66@hisilicon.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220214021747.4976-1-damien.lemoal@opensource.wdc.com>
 <20220214021747.4976-28-damien.lemoal@opensource.wdc.com>
 <51d7c127-f975-14e9-a036-c37416ed8679@huawei.com>
 <32efd519-3485-ee34-84e2-34a0d8c27e17@opensource.wdc.com>
 <38090771-ad24-1b20-9b79-f7f89d42ea66@huawei.com>
 <37df3c92-c28e-72d4-76d8-33356829af5a@opensource.wdc.com>
 <5a5481af-e975-c6fb-2d48-961769eae551@huawei.com>
 <9c22abeb-1b22-4613-66bc-276aaa4a639c@opensource.wdc.com>
 <e7b5c48b-4217-7247-8bc9-e5f8ae9411ce@huawei.com>
 <e9b40eaf-7aa5-798b-1bde-1a2ce8d83433@opensource.wdc.com>
 <712a4702-8534-fad2-2679-cc5cf62e4a9e@huawei.com>
 <ba58ea9e-430a-ec22-e67a-ceb632e99f33@opensource.wdc.com>
 <28cfcd43-e006-ab26-2d58-47384ae49146@huawei.com>
 <04a7d878-f5dc-6058-fc29-c72139d13aa3@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <04a7d878-f5dc-6058-fc29-c72139d13aa3@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.67]
X-ClientProxiedBy: lhreml714-chm.china.huawei.com (10.201.108.65) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 18/02/2022 03:12, Damien Le Moal wrote:
>> I don't know why the driver even does this, but the implementation of
>> pm80xx_send_read_log() is questionable. It would be nice to not see ATA
>> code in the driver like this.
> I have been thinking about this one. We should be able to avoid this
> read log and rely on libata-eh to do it. All we should need to do is an
> internal abort all without completing the commands. libata will do the
> read log and resend the retry for the failed command (if appropriate)
> and all the other aborted NCQ commands.
> 
> Need to look at how other libsas drivers are handling this. But the
> above should work, I think.

I just assumed that this was something specific to that HW as no other 
libsas driver does this manually.

> 
> Not adding this to the current series though:)  That will be for another
> patch series.
Please note that the Hisi SAS driver also issues an ATA softreset as 
part of the disk reset procedure - it would be nice to have that sort of 
code in libata also; I see softreset code in libahci which maybe could 
be refactored. I can check further when I get a chance.

Thanks,
John


