From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/2] libsas: Don't process sas events in static works
Date: Sat, 20 May 2017 20:44:16 -0700
Message-ID: <CAPcyv4idOqGpdFt=FKRPs0gAqYc8pOv+=gL3PGN0Wgp6maUcMw@mail.gmail.com>
References: <1495262360-40135-1-git-send-email-wangyijing@huawei.com> <1495262360-40135-2-git-send-email-wangyijing@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:35912 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1756713AbdEUDoR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 20 May 2017 23:44:17 -0400
Received: by mail-oi0-f49.google.com with SMTP id h4so129431251oib.3
        for <linux-scsi@vger.kernel.org>; Sat, 20 May 2017 20:44:17 -0700 (PDT)
In-Reply-To: <1495262360-40135-2-git-send-email-wangyijing@huawei.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Yijing Wang <wangyijing@huawei.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, chenqilin2@huawei.com, hare@suse.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, chenxiang66@hisilicon.com, huangdaode@hisilicon.com, wangkefeng.wang@huawei.com, zhaohongjiang@huawei.com, dingtianhong@huawei.com, guohanjun@huawei.com, John Garry <john.garry@huawei.com>, Wei Fang <fangwei1@huawei.com>, yanaijie@huawei.com, Christoph Hellwig <hch@lst.de>, Yousong He <heyousong@huawei.com>

On Fri, May 19, 2017 at 11:39 PM, Yijing Wang <wangyijing@huawei.com> wrote:
> Now libsas hotplug work is static, LLDD driver queue
> the hotplug work into shost->work_q. If LLDD driver
> burst post lots hotplug events to libsas, the hotplug
> events may pending in the workqueue like
>
> shost->work_q
> new work[PORTE_BYTES_DMAED] --> |[PHYE_LOSS_OF_SIGNAL][PORTE_BYTES_DMAED] -> processing
>                                 |<-------wait worker to process-------->|
> In this case, a new PORTE_BYTES_DMAED event coming, libsas try to queue it
> to shost->work_q, but this work is already pending, so it would be lost.
> Finally, libsas delete the related sas port and sas devices, but LLDD driver
> expect libsas add the sas port and devices(last sas event).
>
> This patch remove the static defined hotplug work, and use dynamic work to
> avoid missing hotplug events.

If we go this route we don't even need:

sas_port_event_fns
sas_phy_event_fns
sas_ha_event_fns

...just specify the target routine directly to INIT_WORK() and remove
the indirection.

I also think for safety this should use a mempool that guarantees that
events can continue to be processed under system memory pressure.
Also, have you considered the case when a broken phy starts throwing a
constant stream of events? Is there a point at which libsas should
stop queuing events and disable the phy?
