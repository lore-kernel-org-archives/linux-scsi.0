Return-Path: <SRS0=v3DL=ZS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7EF16C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 10:09:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5FF3820865
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Nov 2019 10:09:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727837AbfKZKJW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 26 Nov 2019 05:09:22 -0500
Received: from smtp.infotech.no ([82.134.31.41]:43928 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727888AbfKZKJV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 26 Nov 2019 05:09:21 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 75CC720418E;
        Tue, 26 Nov 2019 11:09:19 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 9z16tZUgl1GM; Tue, 26 Nov 2019 11:09:12 +0100 (CET)
Received: from [192.168.1.80] (unknown [1.144.104.207])
        by smtp.infotech.no (Postfix) with ESMTPA id E54EA204141;
        Tue, 26 Nov 2019 11:09:06 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v6 4/4] ufs: Simplify the clock scaling mechanism
 implementation
To:     Bart Van Assche <bvanassche@acm.org>, cang@codeaurora.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        Bean Huo <beanhuo@micron.com>,
        Avri Altman <avri.altman@wdc.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-scsi@vger.kernel.org, Stanley Chu <stanley.chu@mediatek.com>,
        Tomas Winkler <tomas.winkler@intel.com>
References: <20191121220850.16195-1-bvanassche@acm.org>
 <20191121220850.16195-5-bvanassche@acm.org>
 <0101016ea17f117f-41755175-dc9e-4454-bda6-3653b9aa31ff-000000@us-west-2.amazonses.com>
 <c26ba983-b166-785f-86e8-dd60c802fa77@acm.org>
 <3cadd4df-13ee-fe65-32dc-6a3c583a4988@interlog.com>
 <4ff965f1-20c9-d561-cd67-c1426466b39f@acm.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <d13fe6a7-5449-7724-5327-f0759cfcad6a@interlog.com>
Date:   Tue, 26 Nov 2019 21:09:02 +1100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <4ff965f1-20c9-d561-cd67-c1426466b39f@acm.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-11-26 4:16 p.m., Bart Van Assche wrote:
> On 2019-11-25 21:00, Douglas Gilbert wrote:
>> On 2019-11-26 12:05 p.m., Bart Van Assche wrote:
>>> -    start = ktime_get();
>>
>> Rather than throw away the high precision clock and resort to jiffies,
>> perhaps
>> you might try the middle road. For example: ktime_get_coarse().
> 
> Hi Doug,
> 
> Since HZ >= 100, I think that 1/HZ is more than accurate enough for a
> one second timeout.

For command timeouts, yes.

I was thinking more about instrumenting a LLD to time individual SCSI commands
or get accurate averages over many similar commands (e.g. READs and WRITEs).
Those times could then be compared to similar measurements done from the
user space via the sd or sg driver. The sg driver times commands starting
from each blk_execute_rq_nowait() call to its corresponding callback. In the
current sg driver the unit of that timing is jiffies which is too coarse to
be useful, especially with flash based or faster storage. Hence the sg driver
rewrite uses ktime_get() and friends. So far I haven't seen the need to use
ktime_get_coarse() but one reviewer suggested it.

Doug Gilbert

