Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80553C43460
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:49:37 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 550746135A
	for <linux-scsi@archiver.kernel.org>; Wed, 19 May 2021 14:49:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354790AbhESOu4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 May 2021 10:50:56 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:3605 "EHLO
        szxga06-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348629AbhESOuz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 May 2021 10:50:55 -0400
Received: from dggems703-chm.china.huawei.com (unknown [172.30.72.58])
        by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4FlbLY2G8tzmXVs;
        Wed, 19 May 2021 22:47:17 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 dggems703-chm.china.huawei.com (10.3.19.180) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2176.2; Wed, 19 May 2021 22:49:33 +0800
Received: from [10.47.87.246] (10.47.87.246) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2176.2; Wed, 19 May
 2021 15:49:30 +0100
Subject: Re: [PATCH] scsi: libsas: use _safe() loop in sas_resume_port()
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
CC:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Jacek Danecki <jacek.danecki@intel.com>,
        "James Bottomley" <JBottomley@parallels.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <kernel-janitors@vger.kernel.org>
References: <YKUeq6gwfGcvvhty@mwanda>
From:   John Garry <john.garry@huawei.com>
Message-ID: <53700bc0-b2a0-3d65-5471-ff20f3127790@huawei.com>
Date:   Wed, 19 May 2021 15:48:26 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.2
MIME-Version: 1.0
In-Reply-To: <YKUeq6gwfGcvvhty@mwanda>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.87.246]
X-ClientProxiedBy: lhreml745-chm.china.huawei.com (10.201.108.195) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/05/2021 15:20, Dan Carpenter wrote:
> If sas_notify_lldd_dev_found() fails then this code calls:
> 
> 	sas_unregister_dev(port, dev);
> 
> which removes "dev", our list iterator, from the list.  This could
> lead to an endless loop.  We need to use list_for_each_entry_safe().
> 
> Fixes: 303694eeee5e ("[SCSI] libsas: suspend / resume support")
> Signed-off-by: Dan Carpenter<dan.carpenter@oracle.com>

Reviewed-by: John Garry <john.garry@huawei.com>
