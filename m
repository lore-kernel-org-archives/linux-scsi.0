Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A2533C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Dec 2021 11:52:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231641AbhLNLwi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Dec 2021 06:52:38 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:4274 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbhLNLwh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Dec 2021 06:52:37 -0500
Received: from fraeml745-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4JCxTT3J31z67vF1;
        Tue, 14 Dec 2021 19:48:13 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml745-chm.china.huawei.com (10.206.15.226) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.20; Tue, 14 Dec 2021 12:52:35 +0100
Received: from [10.47.83.94] (10.47.83.94) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.2308.20; Tue, 14 Dec
 2021 11:52:34 +0000
From:   John Garry <john.garry@huawei.com>
Subject: Re: [PATCH 00/15] Add runtime PM support for libsas
To:     chenxiang <chenxiang66@hisilicon.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>
CC:     <linux-scsi@vger.kernel.org>, <linuxarm@huawei.com>
References: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
Message-ID: <71fd6690-8fc3-896a-ddab-9a46fb79e929@huawei.com>
Date:   Tue, 14 Dec 2021 11:52:11 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
In-Reply-To: <1637117108-230103-1-git-send-email-chenxiang66@hisilicon.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.83.94]
X-ClientProxiedBy: lhreml701-chm.china.huawei.com (10.201.108.50) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 17/11/2021 02:44, chenxiang wrote:
> From: Xiang Chen<chenxiang66@hisilicon.com>
> 

Please consider this rewrite:

Currently the HiSilicon SAS controller v3 hw driver supports runtime PM. 
However a number of corner-case bugs have been reported for this 
feature. These include:
a. If a directly-attached disk is removed when the host is suspended a 
system hang may occur during resume. libsas drains events after resuming 
the host. Draining the events causes a deadlock as we need to ensure 
that the host is resumed for some libsas events processing, however the 
resume process will not complete until all events are processed.
b. If a disk is attached to an expander when the host is suspended then 
this new disk will not be detected when active again.
c. The host controller may not resume from suspension when sending SMP IOs.
d. If a phy comes up when resuming the host controller then we may get a 
deadlock from processing of events DISCE_DISCOVER_DOMAIN and 
PORTE_BYTES_DMAED.
e. Similar to d., the work of PORTE_BROADCAST_RCVD and PORTE_BYTES_DMAED 
may deadlock.

This series addresses those issues, briefly described as follows:
a. As far as we can see, this drain is unneeded, so conditionally remove.
b. Just insert broadcast events to revalidate the topology.
c. and e. When processing any events from the LLD, make libsas keep the 
host active until finished processing all work related to that original 
event.
d. Defer phyup event processing in case described.


> Right now hisi_sas driver has already supported runtime PM, and it works
> well on base functions. But for some exception situations, there are some
> issues related to libsas layer:
> - Remove a directly attached disk when sas host is suspended, a hang will
> occur in the resume process, patch 1~2 solve the issue;
> - Insert a new disk (for expander) during suspended, and the disk is not
> revalidated when resuming sas host, patch 4~7 solve the issue;
> - SMP IOs from libsas may be sending when sas host is suspended, so resume
> sas host when sending SMP IOs in patch 9;
> - New phyup may occur during the process of resuming controller, then work
> of DISCE_DISCOVER_DOMAIN of a new phy and work PORTE_BYTES_DMAED of suspended
> phy are blocked by each other, so defer works of new phys during suspend
> in patch 10~12;
> - Work PORTE_BROADCAST_RCVD and PORTE_BYTES_DMAED are in the same
> workqueue, but it is possible that they are blocked by each other,
> so keep sas host active until finished some work in patch 14.
> 
> And patch 3 which is related to scsi/block PM is from Alan Stern
> (https://lore.kernel.org/linux-scsi/20210714161027.GC380727@rowland.harvard.edu/)

