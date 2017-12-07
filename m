From: Stuart Hayes <stuart.w.hayes@gmail.com>
Subject: Re: [PATCH v3 1/2] Ensure that the SCSI error handler gets woken up
Date: Wed, 6 Dec 2017 23:12:51 -0600
Message-ID: <cf6ab64c-a6da-ba85-adb1-3ee9412b8884@gmail.com>
References: <1512490788.2660.16.camel@wdc.com>
 <sr4inbsihn7krboba8euqqp1.1512508675214@email.android.com>
 <1512510365.2660.35.camel@wdc.com> <5A27228D.1090705@virtuozzo.com>
 <1512514780.2660.46.camel@wdc.com>
 <99fe7aac-e3f6-62cf-7677-7596d742fb8b@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <99fe7aac-e3f6-62cf-7677-7596d742fb8b@virtuozzo.com>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "jthumshirn@suse.de" <jthumshirn@suse.de>, "hch@lst.de" <hch@lst.de>, "stable@vger.kernel.org" <stable@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hare@suse.com" <hare@suse.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "khorenko@virtuozzo.com" <khorenko@virtuozzo.com>
List-Id: linux-scsi@vger.kernel.org

>>>> In case (a) scsi_eh_inc_host_failed() will wake up the error handler. And in
>>>> case (b) scsi_dec_host_busy() will wake up the error handler. So it's not
>>>> clear to me why you think that there is a scenario in which the EH won't be
>>>> woken up?
>>>
>>> So in case (b), in my understanding, scsi_dec_host_busy can skip wakeups
>>> as it does not see host_failed change yet.
>>
>> That's not correct. If scsi_dec_host_busy() obtains the SCSI host lock before
>> scsi_eh_inc_host_failed() obtains it then the latter function will trigger a
>> SCSI EH wakeup.
> 
> You are right! Thanks a lot for pointing that out! Now when I understand it, your patch looks good for me:
> 
> Reviewed-by: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
> 
> By the way, I very much like your idea of using rcu for these case.
> 
> Thanks, Pavel.
> 

This patch tests ok on my system, too... it's run for over 24 hours, on a system that typically fails within ten minutes without the patch...

Tested-by: Stuart Hayes <stuart.w.hayes@gmail.com>

Thanks,
Stuart


---
This email has been checked for viruses by Avast antivirus software.
https://www.avast.com/antivirus
