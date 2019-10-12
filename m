Return-Path: <SRS0=mfkc=YF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB150C47404
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Oct 2019 02:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A6BFF20679
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Oct 2019 02:10:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728637AbfJLCK4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Oct 2019 22:10:56 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:56346 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1728587AbfJLCK4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 11 Oct 2019 22:10:56 -0400
Received: from DGGEMS409-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 5C4939953D7986DE7905;
        Sat, 12 Oct 2019 10:10:53 +0800 (CST)
Received: from [127.0.0.1] (10.184.213.217) by DGGEMS409-HUB.china.huawei.com
 (10.3.19.209) with Microsoft SMTP Server id 14.3.439.0; Sat, 12 Oct 2019
 10:10:50 +0800
Subject: Re: [PATCH v2] scsi: core: fix uninit-value access of variable sshdr
To:     James Bottomley <jejb@linux.ibm.com>, <bvanassche@acm.org>,
        <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>
References: <1570843610-63645-1-git-send-email-zhengbin13@huawei.com>
 <1570845482.17735.27.camel@linux.ibm.com>
 <783b66dc-e7e9-3780-3041-7ab03491def5@huawei.com>
 <1570845968.17735.28.camel@linux.ibm.com>
From:   "zhengbin (A)" <zhengbin13@huawei.com>
Message-ID: <f99ef947-080a-b2ff-e43e-66a0a69fa304@huawei.com>
Date:   Sat, 12 Oct 2019 10:10:26 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.0
MIME-Version: 1.0
In-Reply-To: <1570845968.17735.28.camel@linux.ibm.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.184.213.217]
X-CFilter-Loop: Reflected
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


On 2019/10/12 10:06, James Bottomley wrote:
> On Sat, 2019-10-12 at 10:03 +0800, zhengbin (A) wrote:
>> On 2019/10/12 9:58, James Bottomley wrote:
>>> On Sat, 2019-10-12 at 09:26 +0800, zhengbin wrote:
>>>> BTW: we can't just init sshdr->response_code, sr_do_ioctl use
>>>> sshdr->sense_key
>>> That's an actual bug, isn't it?
>> If we init sshdr in __scsi_execute, this will be ok
> No I mean it's a bug because sr_do_ioctl shouldn't be acting on sense
> that isn't valid.  So all uses of sshdr should be gated on a validity
> check.

Yes you are right, the right way is use scsi_sense_valid(&sshdr), I have troubleshoot callers,

this is the only wrong use(Maybe I miss some...).

>
> James
>
>
> .
>

