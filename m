Return-Path: <SRS0=FF5A=DH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.9 required=3.0 tests=BAYES_00,DATE_IN_PAST_96_XX,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A397C4727C
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 00:50:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4B48D20759
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Sep 2020 00:50:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729272AbgI3AuH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Sep 2020 20:50:07 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40476 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726806AbgI3AuG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 29 Sep 2020 20:50:06 -0400
Received: from DGGEMS401-HUB.china.huawei.com (unknown [172.30.72.60])
        by Forcepoint Email with ESMTP id 901CC35C07DAD9C4034E;
        Wed, 30 Sep 2020 08:50:04 +0800 (CST)
Received: from [10.174.179.1] (10.174.179.1) by smtp.huawei.com (10.3.19.201)
 with Microsoft SMTP Server (TLS) id 14.3.487.0; Wed, 30 Sep 2020 08:49:59
 +0800
Subject: Re: [PATCH] scsi: esas2r: prevent a potential NULL dereference in
 esas2r_probe()
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20200909084653.79341-1-jingxiangfeng@huawei.com>
 <yq11rj267ij.fsf@ca-mkp.ca.oracle.com>
CC:     <linuxdrivers@attotech.com>, <jejb@linux.ibm.com>,
        <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>
From:   Jing Xiangfeng <jingxiangfeng@huawei.com>
Message-ID: <5F620166.7070305@huawei.com>
Date:   Wed, 16 Sep 2020 20:13:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:38.0) Gecko/20100101
 Thunderbird/38.1.0
MIME-Version: 1.0
In-Reply-To: <yq11rj267ij.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.179.1]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 2020/9/16 5:44, Martin K. Petersen wrote:
>
> Jing,
>
>> esas2r_probe() calls scsi_host_put() in an error path. However,
>> esas2r_log_dev() may hit a potential NULL dereference. So use NUll instead.
>
> Wouldn't it be better to move the scsi_host_put() call after the error
> message?

There is already a message before the scsi_host_put() call. It is used 
to record calling function.

>
