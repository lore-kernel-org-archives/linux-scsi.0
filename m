From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
Date: Tue, 8 Nov 2016 18:19:44 -0700
Message-ID: <7829000d-2e1c-d298-57cb-8d02c4e020d2@kernel.dk>
References: <f0fa381c-e224-b660-27c4-dede4a5b543e@kernel.dk>
 <yq1mvh9r2b9.fsf@sermon.lab.mkp.net>
 <48f84d6c60f7ac70928c2cb34cd2ed1f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:34369 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750724AbcKIBTs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Nov 2016 20:19:48 -0500
Received: by mail-pf0-f172.google.com with SMTP id n85so116853231pfi.1
        for <linux-scsi@vger.kernel.org>; Tue, 08 Nov 2016 17:19:48 -0800 (PST)
In-Reply-To: <48f84d6c60f7ac70928c2cb34cd2ed1f@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kashyap Desai <kashyap.desai@broadcom.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 11/08/2016 05:20 PM, Kashyap Desai wrote:
>> -----Original Message-----
>> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
>> Sent: Wednesday, November 09, 2016 4:45 AM
>> To: Jens Axboe
>> Cc: linux-scsi; Kashyap Desai; Martin K. Petersen
>> Subject: Re: [REGRESSION] 4.9-rc4+ doesn't boot on my test box
>>
>>>>>>> "Jens" == Jens Axboe <axboe@kernel.dk> writes:
>>
>> Jens> I wasted half a day on this, thinking it was something in my
>> Jens> 4.10 branches. But it turns out it is not, the regression is in
>> Jens> mainline.
>
> Jens -
>
> Sorry for trouble.  I did not validated this single patch. I validated
> complete patch set.
> Issue is improper MACRO usage MEGASAS_IS_LOGICAL, which gives incorrect
> check condition in qcmd Path.
>
> Below is proposed fix.
>
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> b/drivers/scsi/megaraid/megaraid_sas.h
> index 74c7b44..0d2625b 100644
> --- a/drivers/scsi/megaraid/megaraid_sas.h
> +++ b/drivers/scsi/megaraid/megaraid_sas.h
> @@ -2236,7 +2236,7 @@ struct megasas_instance_template {
>  };
>
>  #define MEGASAS_IS_LOGICAL(scp)
> \
> -	(scp->device->channel < MEGASAS_MAX_PD_CHANNELS) ? 0 : 1

Ugh... So we're completing everything immediately.

> Martin -  I validated whole series.  Apologies for this.
>
> Please help me to know how to fix this ? Do I need to send only fix on top
> of latest commit (as posted above - MACRO definition) for this issue ?

Send a fix on top of current -git asap. The current tree is completely
broken for any megaraid user. -rc4 is no time to send in untested
patches, especially not something that claims to fix a 9 year old bug
and is marked for stable as well.

-- 
Jens Axboe

