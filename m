From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 04 Apr 2018 23:34:56 +0200
Message-ID: <6a6ba6c98cad6adf5dbd1cc4eaba47fa@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name>
 <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

04.04.2018 23:25, Kees Cook wrote:
>> Actually, I can trigger a BUG too:
>> 
>> [  129.259213] usercopy: Kernel memory exposure attempt detected from 
>> SLUB
>> object 'scsi_sense_cache' (offset 119, size 22)!
> 
> Wow, yeah, that's totally outside the slub object_size. How did you
> trigger this? Just luck or something specific?

Just luck, I suppose. It usually comes after the first warning if you 
wait long enough (maybe, a couple of extra minutes).

To give you an idea regarding variety of offsets, I've summarised kernel 
log from the server:

$ sudo journalctl -kb | grep "Kernel memory exposure attempt detected" | 
grep -oE 'offset [0-9]+, size [0-9]+' | sort | uniq -c
       9 offset 107, size 22
       6 offset 108, size 22
       8 offset 109, size 22
       7 offset 110, size 22
       5 offset 111, size 22
       5 offset 112, size 22
       2 offset 113, size 22
       2 offset 114, size 22
       1 offset 115, size 22
       1 offset 116, size 22
       1 offset 119, size 22
       1 offset 85, size 22

> I'd really like to understand how the buffer position can be
> changing... I'd expect that to break all kinds of things (i.e.
> free()ing the slab later would break too...)

I haven't checked the code yet, but the first thing that comes to my 
mind is some uninitialised variable. Just guessing here, though.

> Thanks for the report! I hope someone more familiar with sg_io() can
> help explain the changing buffer offset... :P

Hopefully, SCSI people are Cc'ed here properly…

Thanks!

Regards,
   Oleksandr
