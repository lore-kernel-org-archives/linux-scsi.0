Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1540C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 10:19:27 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 93B6A64E57
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Feb 2021 10:19:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230458AbhBWKT1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Feb 2021 05:19:27 -0500
Received: from frasgout.his.huawei.com ([185.176.79.56]:2596 "EHLO
        frasgout.his.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230142AbhBWKT0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2021 05:19:26 -0500
Received: from fraeml710-chm.china.huawei.com (unknown [172.18.147.206])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4DlFFX5d8Nz67rvq;
        Tue, 23 Feb 2021 18:11:28 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml710-chm.china.huawei.com (10.206.15.59) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2106.2; Tue, 23 Feb 2021 11:18:44 +0100
Received: from [10.47.0.222] (10.47.0.222) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2106.2; Tue, 23 Feb
 2021 10:18:43 +0000
Subject: Re: [PATCHv7 00/31] scsi: enable reserved commands for LLDDs
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
CC:     James Bottomley <james.bottomley@hansenpartnership.com>,
        Christoph Hellwig <hch@lst.de>, <linux-scsi@vger.kernel.org>,
        "Viswas.G@microchip.com" <Viswas.G@microchip.com>
References: <20210222132405.91369-1-hare@suse.de>
From:   John Garry <john.garry@huawei.com>
Message-ID: <a6234ede-74bd-81f0-9d39-db398b79f50a@huawei.com>
Date:   Tue, 23 Feb 2021 10:16:56 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <20210222132405.91369-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.0.222]
X-ClientProxiedBy: lhreml742-chm.china.huawei.com (10.201.108.192) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 22/02/2021 13:23, Hannes Reinecke wrote:
> Hi all,

+

> 
> quite some drivers use internal commands for various purposes, most
> commonly sending TMFs or querying the HBA status.
> While these commands use the same submission mechanism than normal
> I/O commands, they will not be counted as outstanding commands,
> requiring those drivers to implement their own mechanism to figure
> out outstanding commands.
> The block layer already has the concept of 'reserved' tags for
> precisely this purpose, namely non-I/O tags which live off a separate
> tag pool. That guarantees that these commands can always be sent,
> and won't be influenced by tag starvation from the I/O tag pool.
> This patchset enables the use of reserved tags for the SCSI midlayer
> by allocating a virtual LUN for the HBA itself which just serves
> as a resource to allocate valid tags from.
> This removes quite some hacks which were required for some
> drivers (eg. fnic or snic), and allows the use of tagset
> iterators within the drivers.
> 
> The entire patchset can be found at
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/hare/scsi-devel.git
> reserved-tags.v7


Thanks for doing this, I'll have a look.
