Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7FB2C07E99
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 07:24:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9344E611F1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Jul 2021 07:24:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231126AbhGIH1H (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Jul 2021 03:27:07 -0400
Received: from mx3.molgen.mpg.de ([141.14.17.11]:59353 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S230121AbhGIH1G (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 9 Jul 2021 03:27:06 -0400
Received: from [192.168.0.3] (ip5f5aeb5a.dynamic.kabel-deutschland.de [95.90.235.90])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: pmenzel)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 9015E61E5FE33;
        Fri,  9 Jul 2021 09:24:21 +0200 (CEST)
Subject: Re: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller
 features msgs
To:     Don.Brace@microchip.com, Kevin.Barnett@microchip.com
Cc:     Scott.Teel@microchip.com, Justin.Lindley@microchip.com,
        Scott.Benesh@microchip.com, Gerry.Morong@microchip.com,
        Mahesh.Rajashekhara@microchip.com, Mike.McGowen@microchip.com,
        Murthy.Bhat@microchip.com, Balsundar.P@microchip.com,
        joseph.szczypek@hpe.com, jeff@canonical.com, POSWALD@suse.com,
        john.p.donnelly@oracle.com, mwilck@suse.com,
        linux-kernel@vger.kernel.org, hch@infradead.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com,
        linux-scsi@vger.kernel.org
References: <20210706181618.27960-1-don.brace@microchip.com>
 <20210706181618.27960-3-don.brace@microchip.com>
 <17eeaf22-4625-d733-dcfb-ec2322dd0ca6@molgen.mpg.de>
 <SN6PR11MB284877FDAB929F223AEC14B5E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
From:   Paul Menzel <pmenzel@molgen.mpg.de>
Message-ID: <4b68177b-4c61-74fd-eee7-83b938200278@molgen.mpg.de>
Date:   Fri, 9 Jul 2021 09:24:21 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <SN6PR11MB284877FDAB929F223AEC14B5E1199@SN6PR11MB2848.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

[I corrected Martin’s email from peterson to peters*e*n. Don, you should 
have also receive a bounce message from the MTA. I guess Martin has 
these as a list subscriber nevertheless, but I suggest to resend the 
series as soon as possible.]

Dear Don,


Thank you for your reply.


Am 08.07.21 um 21:04 schrieb Don.Brace@microchip.com:
> -----Original Message-----
> From: Paul Menzel [mailto:pmenzel@molgen.mpg.de]
> Sent: Wednesday, July 7, 2021 2:29 AM
> Subject: Re: [smartpqi updates PATCH 2/9] smartpqi: rm unsupported controller features msgs

> Am 06.07.21 um 20:16 schrieb Don Brace:
>> From: Kevin Barnett <kevin.barnett@microchip.com>
>>
>> Remove "Feature XYZ not supported by controller" messages.
>>
>> During driver initialization, the driver examines the PQI Table Feature bits.
>> These bits are used by the controller to advertise features supported
>> by the controller. For any features not supported by the controller,
>> the driver would display a message in the form:
>>           "Feature XYZ not supported by controller"
>> Some of these "negative" messages were causing customer confusion.
> 
> As it’s info log level and not warning or notice, these message are
> useful in my opinion. You could downgrade them to debug, but I do not
> see why. If customers do not want to see these info messages, they
> should filter them out.
> 
> For completeness, is there an alternative to list the unsupported
> features from the firmware for example from sysfs?

> Don> Thanks for your Review. At this time we would prefer to not
> provide messages about unsupported features.

Only because a customer complained? That is not a good enough reason in 
my opinion. Log messages, often grepped for, are an interface which 
should only be changed with caution.

If these absent feature message were present for a long time, and you 
suddenly remove them, people looking a newer Linux kernel messages, 
users conclude the feature is supported now. That is quite a downside in 
my opinion.

> We may add them back at some point but we have taken them out of our
> out-of-box driver also so we hope to keep the driver code in sync.
That’s why you should develop for Linux master branch and upstream 
*first* to get external reviews. That argument should not count for 
Linux upstream reviews in my opinion.


Kind regards,

Paul


>> Reviewed-by: Mike McGowen <mike.mcgowen@microchip.com>
>> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
>> Reviewed-by: Scott Teel <scott.teel@microchip.com>
>> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
>> Signed-off-by: Don Brace <don.brace@microchip.com>
>> ---
>>    drivers/scsi/smartpqi/smartpqi_init.c | 5 +----
>>    1 file changed, 1 insertion(+), 4 deletions(-)
>>
>> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
>> b/drivers/scsi/smartpqi/smartpqi_init.c
>> index d977c7b30d5c..7958316841a4 100644
>> --- a/drivers/scsi/smartpqi/smartpqi_init.c
>> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
>> @@ -7255,11 +7255,8 @@ struct pqi_firmware_feature {
>>    static void pqi_firmware_feature_status(struct pqi_ctrl_info *ctrl_info,
>>        struct pqi_firmware_feature *firmware_feature)
>>    {
>> -     if (!firmware_feature->supported) {
>> -             dev_info(&ctrl_info->pci_dev->dev, "%s not supported by controller\n",
>> -                     firmware_feature->feature_name);
>> +     if (!firmware_feature->supported)
>>                return;
>> -     }
>>
>>        if (firmware_feature->enabled) {
>>                dev_info(&ctrl_info->pci_dev->dev,
>>
