Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43992C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 12:26:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 05A8F619BC
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 12:26:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231823AbhC3M0Q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 08:26:16 -0400
Received: from mxout02.lancloud.ru ([45.84.86.82]:45496 "EHLO
        mxout02.lancloud.ru" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231749AbhC3MZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 30 Mar 2021 08:25:55 -0400
Received: from LanCloud
DKIM-Filter: OpenDKIM Filter v2.11.0 mxout02.lancloud.ru C45062313EF1
Received: from LanCloud
Received: from LanCloud
Received: from LanCloud
Subject: Re: [PATCH] scsi: ufshcd-pltfrm: fix deferred probing
To:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
References: <420364ca-614a-45e3-4e35-0e0653c7bc53@omprussia.ru>
 <52c081b2-2f66-ee7b-4dcd-d106106dfd3d@acm.org>
From:   Sergey Shtylyov <s.shtylyov@omprussia.ru>
Organization: Open Mobile Platform, LLC
Message-ID: <481ba2ec-8480-7f87-1d75-15b11e87e2ad@omprussia.ru>
Date:   Tue, 30 Mar 2021 15:25:47 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <52c081b2-2f66-ee7b-4dcd-d106106dfd3d@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [192.168.11.198]
X-ClientProxiedBy: LFEXT01.lancloud.ru (fd00:f066::141) To
 LFEX1908.lancloud.ru (fd00:f066::208)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/30/21 12:06 AM, Bart Van Assche wrote:

>> The driver overrides the error codes returned by platform_get_irq() to
>> -ENODEV, so if it returns -EPROBE_DEFER, the driver would fail the probe
>> permanently instead of the deferred probing.  Propagate the error code
>> upstream, as it should have been done from the start...
>>
>> Fixes: 2953f850c3b8 ("[SCSI] ufs: use devres functions for ufshcd")
>> Signed-off-by: Sergey Shtylyov <s.shtylyov@omprussia.ru>
> 
> Hi Sergey,
> 
> How has this patch been tested?

   Only build-tested.
   Misusing platfrom_get_irq() appears a common issue. :-(

> Thanks,
> 
> Bart.

MBR, Sergei
