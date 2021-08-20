Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DEA0C4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 17:37:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 527F561101
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 17:37:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234656AbhHTRh4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 13:37:56 -0400
Received: from frasgout.his.huawei.com ([185.176.79.56]:3677 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbhHTRhz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Aug 2021 13:37:55 -0400
Received: from fraeml741-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4GrphV5lX2z67RS4;
        Sat, 21 Aug 2021 01:36:10 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml741-chm.china.huawei.com (10.206.15.222) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.8; Fri, 20 Aug 2021 19:37:15 +0200
Received: from [10.47.93.229] (10.47.93.229) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.8; Fri, 20 Aug
 2021 18:37:14 +0100
From:   John Garry <john.garry@huawei.com>
Subject: arm scsi drivers
To:     <linux@armlinux.org.uk>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Hannes Reinecke <hare@suse.com>,
        "Christoph Hellwig" <hch@lst.de>,
        Bart Van Assche <bvanassche@acm.org>,
        Arnd Bergmann <arnd@arndb.de>
Message-ID: <5a72842f-99db-8787-120b-6d85e7884e2d@huawei.com>
Date:   Fri, 20 Aug 2021 18:37:13 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.1
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.93.229]
X-ClientProxiedBy: lhreml729-chm.china.huawei.com (10.201.108.80) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Russell,

Recently we tried to remove scsi_cmnd.tags struct member [0].

However it now shows that some of the arm SCSI drivers continue to use 
this [1]. I think any other driver usage of this member had been found 
and removed.

The impression is that the usage of scsi_cmnd.tag in those drivers is 
quite dubious.

Now checking [2], it appears that you may have had some patches for 
these drivers locally.

So is that the case? Is this HW still used with bleeding edge kernels? 
If so, can we fix up this tag management?

[0] 
https://lore.kernel.org/linux-scsi/6c83bd7f-9fd2-1b43-627f-615467fa55d4@huawei.com/T/#mb47909f38f35837686734369600051b278d124af

[1] 
https://lore.kernel.org/linux-scsi/6c83bd7f-9fd2-1b43-627f-615467fa55d4@huawei.com/T/#md5d786e5753083b2f3e8e761b1c69809f82c7485

[2] 
https://lore.kernel.org/lkml/20210109174357.GB1551@shell.armlinux.org.uk/

Thanks,
John
