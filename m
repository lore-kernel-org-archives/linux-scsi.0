Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11DACC433B4
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Apr 2021 15:39:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CD99261242
	for <linux-scsi@archiver.kernel.org>; Sun,  4 Apr 2021 15:39:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbhDDPjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 4 Apr 2021 11:39:46 -0400
Received: from mxout04.lancloud.ru ([45.84.86.114]:60720 "EHLO
        mxout04.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbhDDPjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 4 Apr 2021 11:39:46 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout04.lancloud.ru 9147C20C4F75
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] scsi: hisi_sas: fix IRQ checks
To:     Andy Shevchenko <andy.shevchenko@gmail.com>
CC:     Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        John Garry <john.garry@huawei.com>
References: <810f26d3-908b-1d6b-dc5c-40019726baca@omprussia.ru>
 <CAHp75VfZ+B-MNZ57BzMxgTvGXQ7Ek-DU2T4UVQ2tQpPoOmfcTg@mail.gmail.com>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <38771b7a-fbb5-19ca-37c1-175f912cb7d6@omprussia.ru>
Date:   Sun, 4 Apr 2021 18:39:36 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <CAHp75VfZ+B-MNZ57BzMxgTvGXQ7Ek-DU2T4UVQ2tQpPoOmfcTg@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT02.lancloud.ru (fd00:f066::142) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/4/21 2:48 PM, Andy Shevchenko wrote:

[...]
>     Commit df2d8213d9e3 ("hisi_sas: use platform_get_irq()") failed to take
>     into account that irq_of_parse_and_map() and platform_get_irq() have a
>     different way of indicating an error: the former returns 0 and the latter
>     returns a negative error code. Fix up the IRQ checks!
> 
> 
> Shouldn’t you unshadow error codes at the same time?
> 
> return -ENOENT; ==> return IRQ;

   I'm going to send that as a follow-up (cleanup) patch -- we also have devm_request_irq() with
the result overridden for no good reason...

>     Fixes: df2d8213d9e3 ("hisi_sas: use platform_get_irq()")
>     Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru <mailto:s.shtylyov@omprussia.ru>>
[...]

MBR, Sergei
