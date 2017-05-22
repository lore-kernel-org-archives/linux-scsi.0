From: wangyijing <wangyijing@huawei.com>
Subject: Re: [PATCH 1/2] libsas: Don't process sas events in static works
Date: Mon, 22 May 2017 13:54:30 +0800
Message-ID: <59227D16.6000102@huawei.com>
References: <1495262360-40135-1-git-send-email-wangyijing@huawei.com>
 <1495262360-40135-2-git-send-email-wangyijing@huawei.com>
 <CAPcyv4idOqGpdFt=FKRPs0gAqYc8pOv+=gL3PGN0Wgp6maUcMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from szxga05-in.huawei.com ([45.249.212.191]:2082 "EHLO
        szxga05-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750928AbdEVFzO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 22 May 2017 01:55:14 -0400
In-Reply-To: <CAPcyv4idOqGpdFt=FKRPs0gAqYc8pOv+=gL3PGN0Wgp6maUcMw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chenqilin2@huawei.com, hare@suse.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, John Garry <john.garry@huawei.com>, Wei Fang <fangwei1@huawei.com>, yanaijie@huawei.com, Christoph Hellwig <hch@lst.de>, Yousong He <heyousong@huawei.com>

Hi Dan, thanks for your review and comments!

在 2017/5/21 11:44, Dan Williams 写道:
> On Fri, May 19, 2017 at 11:39 PM, Yijing Wang <wangyijing@huawei.com> wrote:
>> Now libsas hotplug work is static, LLDD driver queue
>> the hotplug work into shost->work_q. If LLDD driver
>> burst post lots hotplug events to libsas, the hotplug
>> events may pending in the workqueue like
>>
>> shost->work_q
>> new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
>>                                 |<-------wait worker to process-------->|
>> In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue it
>> to shost->work_q, but this work is already pending, so it would be lost.
>> Finally, libsas delete the related sas port and sas devices, but LLDD driver
>> expect libsas add the sas port and devices(last sas event).
>>
>> This patch remove the static defined hotplug work, and use dynamic work to
>> avoid missing hotplug events.
> 
> If we go this route we don't even need:
> 
> sas_port_event_fns
> sas_phy_event_fns
> sas_ha_event_fns

Yes, these three fns are not necessary, just for avoid lots kfree in phy/port/ha event fns.

> 
> ...just specify the target routine directly to INIT_WORK() and remove
> the indirection.
> 
> I also think for safety this should use a mempool that guarantees that
> events can continue to be processed under system memory pressure.

What I am worried about is it's would still fail if the mempool is used empty during memory pressure.

> Also, have you considered the case when a broken phy starts throwing a
> constant stream of events? Is there a point at which libsas should
> stop queuing events and disable the phy?

Not yet, I didn't find this issue in real case, but I agree, it's really a problem in some broken
hardware, I think it's not a easy problem, we could improve it step by step.

Thanks!
Yijing.

> 
> .
> 
