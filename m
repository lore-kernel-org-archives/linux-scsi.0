Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E104DC4332F
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Dec 2022 11:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230507AbiLPLlc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Dec 2022 06:41:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiLPLla (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Dec 2022 06:41:30 -0500
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C054225EA8;
        Fri, 16 Dec 2022 03:41:29 -0800 (PST)
Received: from dggpemm500017.china.huawei.com (unknown [172.30.72.55])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4NYRx34f2jzRq5n;
        Fri, 16 Dec 2022 19:40:23 +0800 (CST)
Received: from [10.174.178.220] (10.174.178.220) by
 dggpemm500017.china.huawei.com (7.185.36.178) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.34; Fri, 16 Dec 2022 19:41:27 +0800
Message-ID: <5129c84b-38e5-8be4-6411-fcc003776d70@huawei.com>
Date:   Fri, 16 Dec 2022 19:41:26 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 0/2] scsi:donot skip lun if inquiry returns PQ=1 for all
 hosts
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
CC:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        <open-iscsi@googlegroups.com>, <linux-scsi@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <liuzhiqiang26@huawei.com>,
        <linfeilong@huawei.com>
References: <20221214070846.1808300-1-haowenchao@huawei.com>
 <Y5rHX95Vvl1aLhbp@infradead.org>
 <57c12317-c229-8cbe-b3d2-d799ea5f554c@huawei.com>
 <Y5waet8RoXKQHDR7@infradead.org>
From:   Wenchao Hao <haowenchao@huawei.com>
In-Reply-To: <Y5waet8RoXKQHDR7@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.178.220]
X-ClientProxiedBy: dggpeml500015.china.huawei.com (7.185.36.226) To
 dggpemm500017.china.huawei.com (7.185.36.178)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2022/12/16 15:12, Christoph Hellwig wrote:
> On Thu, Dec 15, 2022 at 05:09:31PM +0800, Wenchao Hao wrote:
>> In my opinion, if the addressed lun still response the
>> inquiry and other commands, we should not skip it,
>> maybe let the scsi drivers like sd/st/sg to determine
>> how to handle this lun accordint to the PQ value.
>>
>> As discussed in following mail, another drivers would
>> be broken too.
> 
> So why do you force a specific behavior for iSCSI?
> .

For nothing, I want the iscsi_tcp transport do not skip PQ=1 default
as what it did before commit 948e922fc4461 ("scsi: core: map PQ=1,
PDT=other values to SCSI_SCAN_TARGET_PRESENT").
