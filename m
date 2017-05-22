From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 1/2] libsas: Don't process sas events in static works
Date: Mon, 22 May 2017 10:28:01 +0100
Message-ID: <392354c0-a4a1-99a8-7723-25513efb835c@huawei.com>
References: <1495262360-40135-1-git-send-email-wangyijing@huawei.com>
 <1495262360-40135-2-git-send-email-wangyijing@huawei.com>
 <CAPcyv4idOqGpdFt=FKRPs0gAqYc8pOv+=gL3PGN0Wgp6maUcMw@mail.gmail.com>
 <59227D16.6000102@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([45.249.212.187]:6792 "EHLO
        szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1757923AbdEVJ2l (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 05:28:41 -0400
In-Reply-To: <59227D16.6000102@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: wangyijing <wangyijing@huawei.com>, Dan Williams <dan.j.williams@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chenqilin2@huawei.com, hare@suse.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, Wei Fang <fangwei1@huawei.com>, yanaijie@huawei.com, Christoph Hellwig <hch@lst.de>, Yousong He <heyousong@huawei.com>, Linuxarm <linuxarm@huawei.com>

On 22/05/2017 06:54, wangyijing wrote:
>> I also think for safety this should use a mempool that guarantees that
>> > events can continue to be processed under system memory pressure.
> What I am worried about is it's would still fail if the mempool is used empty during memory pressure.
>
>> > Also, have you considered the case when a broken phy starts throwing a
>> > constant stream of events? Is there a point at which libsas should
>> > stop queuing events and disable the phy?
> Not yet, I didn't find this issue in real case, but I agree, it's really a problem in some broken
> hardware, I think it's not a easy problem, we could improve it step by step.
>
> Thanks!
> Yijing.
>

I have seen this scenario on our development board when we have a bad 
physical cable connection - the PHY continually goes up and down in a loop.

So, in this regard, it is worth safeguarding against this scenario.

John
