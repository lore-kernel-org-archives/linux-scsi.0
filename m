Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78009C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 16:38:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230028AbiBXQjU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 11:39:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230173AbiBXQjO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 11:39:14 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5A5186420;
        Thu, 24 Feb 2022 08:38:41 -0800 (PST)
Received: from fraeml738-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4JPm3SZnz67xMd;
        Fri, 25 Feb 2022 00:33:48 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml738-chm.china.huawei.com (10.206.15.219) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Thu, 24 Feb 2022 17:38:38 +0100
Received: from [10.47.86.126] (10.47.86.126) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Thu, 24 Feb
 2022 16:38:38 +0000
Message-ID: <3aece7d2-9e9d-8ce5-1873-80f1434f87cc@huawei.com>
Date:   Thu, 24 Feb 2022 16:38:36 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
To:     Christoph Hellwig <hch@lst.de>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
References: <20220222140443.589882-1-hch@lst.de>
 <20220222140443.589882-4-hch@lst.de>
 <d94e5e8a-9793-ab48-88f8-6f6bb878cecd@huawei.com>
 <20220224162713.GA31469@lst.de>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220224162713.GA31469@lst.de>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.86.126]
X-ClientProxiedBy: lhreml752-chm.china.huawei.com (10.201.108.202) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 24/02/2022 16:27, Christoph Hellwig wrote:
> On Thu, Feb 24, 2022 at 08:28:48AM +0000, John Garry wrote:
>>> +	if (!blk_rq_is_passthrough(rq) && !(cmd->flags & SCMD_INITIALIZED)) {
>>> +		cmd->flags |= SCMD_INITIALIZED;
>> Maybe I'm being dozy, but isn't this being cleared below *
> with below you mean the
> 
> 	cmd->flags &= SCMD_PRESERVED_FLAGS;
> 
> ?  No, that doen't clear the flag, but all the others.

Yeah, I was wrong as SCMD_INITIALIZED is included in (actually same as) 
SCMD_PRESERVED_FLAGS mask.

Sorry for the noise.

Cheers,
John
