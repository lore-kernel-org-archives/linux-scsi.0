Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD04AC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:32:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8AC7B64DDC
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Feb 2021 08:32:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbhBAIcl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Feb 2021 03:32:41 -0500
Received: from mail29.static.mailgun.info ([104.130.122.29]:15706 "EHLO
        mail29.static.mailgun.info" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229736AbhBAIcj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Feb 2021 03:32:39 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1612168339; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=6EzIkNA3acQs1j+OyBpJRN8xkjdhbxTtElMpjG4WLrs=;
 b=TtBHEASvUvKiqPYmWsMmKO7oNGUpfaBu329Hds2hAd2hNPfDD3UBa/CS5MPXuD2ERWjS707a
 Kaw1kk9R6FZvC2r6OtvV/w4JUqU927k6BZUvTaBtljSBbz3/lVlFrj0sXCM8MMhofLegdZJZ
 PqIoevhAazcnwsTkrr2XOYLHvMc=
X-Mailgun-Sending-Ip: 104.130.122.29
X-Mailgun-Sid: WyJlNmU5NiIsICJsaW51eC1zY3NpQHZnZXIua2VybmVsLm9yZyIsICJiZTllNGEiXQ==
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n04.prod.us-west-2.postgun.com with SMTP id
 6017bc72f71e8b99346c0ff2 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 01 Feb 2021 08:31:46
 GMT
Sender: nitirawa=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 9CDEFC43463; Mon,  1 Feb 2021 08:31:46 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: nitirawa)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 84644C433ED;
        Mon,  1 Feb 2021 08:31:45 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 01 Feb 2021 14:01:45 +0530
From:   nitirawa@codeaurora.org
To:     Avri Altman <Avri.Altman@wdc.com>
Cc:     asutoshd@codeaurora.org, cang@codeaurora.org,
        stummala@codeaurora.org, vbadigan@codeaurora.org,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, nitirawa@codeaurora.org
Subject: Re: [PATCH V1 0/3] scsi: ufs: Add a vops to configure VCC voltage
 level
In-Reply-To: <DM6PR04MB6575D0348161330D21A9B6C5FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
References: <1611852899-2171-1-git-send-email-nitirawa@codeaurora.org>
 <DM6PR04MB6575D0348161330D21A9B6C5FCB79@DM6PR04MB6575.namprd04.prod.outlook.com>
Message-ID: <48fbd86b319697fced61317bd15c4779@codeaurora.org>
X-Sender: nitirawa@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-01-31 19:32, Avri Altman wrote:
>> 
>> UFS specification allows different VCC configurations for UFS devices,
>> for example,
>>         (1)2.70V - 3.60V (For UFS 2.x devices)
>>         (2)2.40V - 2.70V (For UFS 3.x devices)
>> For platforms supporting both ufs 2.x (2.7v-3.6v) and
>> ufs 3.x (2.4v-2.7v), the voltage requirements (VCC) is 2.4v-3.6v.
>> So to support this, we need to start the ufs device initialization 
>> with
>> the common VCC voltage(2.7v) and after reading the device descriptor 
>> we
>> need to switch to the correct range(vcc min and vcc max) of VCC 
>> voltage
>> as per UFS device type since 2.7v is the marginal voltage as per specs
>> for both type of devices.
>> 
>> Once VCC regulator supply has been intialised to 2.7v and UFS device
>> type is read from device descriptor, we follows below steps to
>> change the VCC voltage values.
>> 
>> 1. Set the device to SLEEP state.
>> 2. Disable the Vcc Regulator.
>> 3. Set the vcc voltage according to the device type and reenable
>>    the regulator.
>> 4. Set the device mode back to ACTIVE.
>> 
>> The above changes are done in vendor specific file by
>> adding a vops which will be needed for platform
>> supporting both ufs 2.x and ufs 3.x devices.
> The flow should be generic - isn't it?
> Why do you need the entire flow to be vendor-specific?
> Why not just the parameters vendor-specific?
> 
> Thanks,
> Avri

Hi Avri,
This vops change was done as per the below mail thread
discussion where it was decided to go with vops and
let vendors handle it, until specs provides more clarity.

https://www.spinics.net/lists/kernel/msg3754995.html

Regards,
Nitin



