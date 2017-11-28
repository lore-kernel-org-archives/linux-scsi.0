From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: News UBSAN warnings in aacraid
Date: Tue, 28 Nov 2017 14:27:18 +0100
Message-ID: <CAK8P3a04ZmNU6zAyaJHnvm2m_9itHxhtVUd67kMEW-JXNdC8Rg@mail.gmail.com>
References: <alpine.LRH.2.21.1711272112050.5402@math.ut.ee>
 <CAK8P3a00CC20bD2cfuJhRwrmmSte7y83a0Z2hx+CRoqQotJktA@mail.gmail.com> <alpine.LRH.2.21.1711281504580.27929@math.ut.ee>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <alpine.LRH.2.21.1711281504580.27929@math.ut.ee>
Sender: linux-kernel-owner@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>
Cc: Dave Carroll <david.carroll@microsemi.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 28, 2017 at 2:05 PM, Meelis Roos <mroos@linux.ee> wrote:
>> I think this chunk would solve the problem and result in the
>> same behavior as before:
>>
>> --- a/drivers/scsi/aacraid/commsup.c
>> +++ b/drivers/scsi/aacraid/commsup.c
>> @@ -2511,8 +2511,8 @@ int aac_command_thread(void *data)
>>                         /* Synchronize our watches */
>>                         if (((NSEC_PER_SEC - (NSEC_PER_SEC / HZ)) > now.tv_nsec)
>>                          && (now.tv_nsec > (NSEC_PER_SEC / HZ)))
>> -                               difference = (((NSEC_PER_SEC -
>> now.tv_nsec) * HZ)
>> -                                 + NSEC_PER_SEC / 2) / NSEC_PER_SEC;
>> +                               difference = HZ + HZ / 2 -
>> +                                            now.tv_nsec / (NSEC_PER_SEC / HZ);
>>                         else {
>>                                 if (now.tv_nsec > NSEC_PER_SEC / 2)
>>                                         ++now.tv_sec;
>>
>> but I don't see why we add in half a second here. Any ideas?
>
> I did not try to understand the details but I can confirm that this
> patch makes the warnings go away.

Thanks for testing! I've wrote it up as a proper patch now, and tried
to capture what I understand about this code and how I got to
the new change.

       Arnd
