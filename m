From: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Subject: Re: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Wed, 6 Dec 2017 10:20:44 +0300
Message-ID: <99fe7aac-e3f6-62cf-7677-7596d742fb8b@virtuozzo.com>
References: <1512490788.2660.16.camel@wdc.com>
 <sr4inbsihn7krboba8euqqp1.1512508675214@email.android.com>
 <1512510365.2660.35.camel@wdc.com> <5A27228D.1090705@virtuozzo.com>
 <1512514780.2660.46.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-db5eur01on0094.outbound.protection.outlook.com ([104.47.2.94]:64320
        "EHLO EUR01-DB5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752692AbdLFHUv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 6 Dec 2017 02:20:51 -0500
In-Reply-To: <1512514780.2660.46.camel@wdc.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stuart.w.hayes@gmail.com" <stuart.w.hayes@gmail.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>

>>> In case (a) scsi_eh_inc_host_failed() will wake up the error handler. And in
>>> case (b) scsi_dec_host_busy() will wake up the error handler. So it's not
>>> clear to me why you think that there is a scenario in which the EH won't be
>>> woken up?
>>
>> So in case (b), in my understanding, scsi_dec_host_busy can skip wakeups
>> as it does not see host_failed change yet.
> 
> That's not correct. If scsi_dec_host_busy() obtains the SCSI host lock before
> scsi_eh_inc_host_failed() obtains it then the latter function will trigger a
> SCSI EH wakeup.

You are right! Thanks a lot for pointing that out! Now when I understand 
it, your patch looks good for me:

Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>

By the way, I very much like your idea of using rcu for these case.

Thanks, Pavel.

> 
> Bart.
>
