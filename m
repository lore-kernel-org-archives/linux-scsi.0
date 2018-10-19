From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: -Wswitch Clang warnings in drivers/scsi
Date: Fri, 19 Oct 2018 06:55:29 -0700
Message-ID: <da70bb3c-3474-7fa5-032c-2abad01deb9d@acm.org>
References: <20181004183047.GA1885@flashbox>
 <1538678069.230807.6.camel@acm.org> <20181004184540.GA17513@flashbox>
 <CAKwvOd=FrGZ-oh5Q9RGQD2GNORZrqwAZUzNYN+hTKkp5wrfrqw@mail.gmail.com>
 <20181005065754.GA18637@flashbox> <1539024429.64374.40.camel@acm.org>
 <20181019065104.GA27170@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181019065104.GA27170@flashbox>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 10/18/18 11:51 PM, Nathan Chancellor wrote:
> On Mon, Oct 08, 2018 at 11:47:09AM -0700, Bart Van Assche wrote:
>>  From the user space header <sys/ioctl.h>:
>>
>> extern int ioctl (int __fd, unsigned long int __request, ...) __THROW;
>>
>>  From the kernel header <linux/fs.h>:
>>
>> 	long (*unlocked_ioctl) (struct file *, unsigned int, unsigned long);
>> 	long (*compat_ioctl) (struct file *, unsigned int, unsigned long);
>>
>> Why has the second argument been declared as "unsigned long" in the glibc
>> headers and as "unsigned int" in the kernel headers? That's not clear to me.
>>
>> Bart.
>>
> 
> Hi Bart,
> 
> Sorry it took me so long to reply, somehow this email got lost in my
> inbox...
> 
> Unfortuntely, I am unsure why there is that discrepency between the
> headers. I tried to do some research but I didn't come up with much.
> 
> However, I did test changing the type of ioctl/compat_ioctl's cmd
> parameter to 'unsigned int' and came up with the following diff (rather
> large so sharing via a gist instead of pasting here):
> 
> https://gist.github.com/nathanchance/8febc92735f4228574cb0464520f0f6f
> 
> I'll obviously draft up a proper commit message before formally sending
> but I can address any major concerns before that happens. I checked
> every single ioctl for a negative value and there aren't any so I think
> this change makes sense to fix this warning.

Hi Nathan,

Since that change makes the SCSI code more consistent with the rest of 
the Linux kernel, I'm in favor of making that change.

Bart.
