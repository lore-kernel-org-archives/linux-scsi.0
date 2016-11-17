From: Donald Buczek <buczek@molgen.mpg.de>
Subject: Re: Ordering problems with 3ware controller
Date: Thu, 17 Nov 2016 20:55:58 +0100
Message-ID: <e9feadfa-fa8e-e630-faaf-a3721ad0318a@molgen.mpg.de>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
 <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
 <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de>
 <yq11syjo2py.fsf@sermon.lab.mkp.net>
 <feacce75-237e-c514-eb5a-9d4a83ee5ed7@molgen.mpg.de>
 <5618e4d9-8add-37eb-a141-c31f98e298ef@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <5618e4d9-8add-37eb-a141-c31f98e298ef@molgen.mpg.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Paul Menzel <pmenzel@molgen.mpg.de>, dvteam@molgen.mpg.de, George Spelvin <linux@sciencehorizons.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On 17.11.2016 15:55, Paul Menzel wrote:

> Dear Linux folks,
>
>
> On 11/16/16 22:24, Donald Buczek wrote:
>>
>> The relevant commit is 703b5fa  which includes
>
> The commit message summary is *fs/dcache.c: Save one 32-bit multiply 
> in dcache lookup*.
>
>>  static inline unsigned long end_name_hash(unsigned long hash)
>>  {
>> -       return (unsigned int)hash;
>> +       return __hash_32((unsigned int)hash);
>>  }
>>
>> __hash_32 is a multiplication by 0x61C88647 ( hash.h )
>>
>> And this exactly is the difference between the hash value of "host0" on
>> the 4.4 and the 4.8 system:
>>
>>   DB<2> x sprintf '%x',0x11bf1ddd*0x61C88647
>> 0  '6c750ef074af64b'
>>
>> The bug, of course, is in the userspace tool tw_cli which wrongly
>> assumes that the names would be returned in the "right" order by 
>> getdents.
>
> Nice analysis.
>
> Unfortunately, I don’t find the discussion of the patch on the Linux 
> kernel mailing list.

703b5fa sits on top of 8387ff2 from Linus Torvalds. Maybe he didn't send 
his own suggestion to the lists but to the three people named in that 
commit only. Maybe George Spelvin replied with his patch as an 
improvement and Linus just accepted it on his own branch and merged 
(554828e).

Donald

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
