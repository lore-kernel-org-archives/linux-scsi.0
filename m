Return-Path: <SRS0=+Wsi=7M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C874DC433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 10:41:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AEA9B20842
	for <linux-scsi@archiver.kernel.org>; Sat, 30 May 2020 10:41:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728915AbgE3Klr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 30 May 2020 06:41:47 -0400
Received: from smtp13.smtpout.orange.fr ([80.12.242.135]:30739 "EHLO
        smtp.smtpout.orange.fr" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728869AbgE3Klr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 30 May 2020 06:41:47 -0400
Received: from [192.168.42.210] ([93.23.15.192])
        by mwinf5d70 with ME
        id kyhh2200B48dfat03yhh5A; Sat, 30 May 2020 12:41:45 +0200
X-ME-Helo: [192.168.42.210]
X-ME-Auth: Y2hyaXN0b3BoZS5qYWlsbGV0QHdhbmFkb28uZnI=
X-ME-Date: Sat, 30 May 2020 12:41:45 +0200
X-ME-IP: 93.23.15.192
Subject: Re: [PATCH] scsi: cumana_2: Fix different dev_id between
 'request_irq()' and 'free_irq()'
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-arm-kernel@lists.infradead.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
References: <20200530073555.577414-1-christophe.jaillet@wanadoo.fr>
 <20200530094338.GE1551@shell.armlinux.org.uk>
From:   Marion & Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Message-ID: <63fbba26-82f4-5c4b-90d6-d951eb914f50@wanadoo.fr>
Date:   Sat, 30 May 2020 12:41:40 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530094338.GE1551@shell.armlinux.org.uk>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Le 30/05/2020 à 11:43, Russell King - ARM Linux admin a écrit :
> On Sat, May 30, 2020 at 09:35:55AM +0200, Christophe JAILLET wrote:
>> The dev_id used in 'request_irq()' and 'free_irq()' should match.
>> So use 'host' in both cases.
>>
>> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
>> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> This is itself wrong.  cumanascsi_2_intr() requires "info" as the devid.
> Either cumanascsi_2_intr() needs changing to use shost_priv(host) along
> with this change, or free_irq() needs changing to use "info".

My bad.

I've only looked at the difference of the dev_id for the 2 functions, 
not at the usage of it with the function registered by 'request_irq'. 
This one is obviously correct, or the driver would have some problems 
somewhere.
I don't know why have chosen to change request_irq and not free_irq.

So obvious. I'm a little embarrassed and will send a v2.

Thx for the quick reply and review.


All the 3 patches being in "/drivers/scsi/arm/", do you prefer only 1 
patch for the 3, or separated as I've done so far?

CJ

> Likely the same for the other patches, I haven't looked.
>
