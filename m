From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Tue, 10 Apr 2018 15:47:41 +0200
Message-ID: <d31189fc94392eb733c1e310ac1ec498@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jL8oLV2xvjBVYv_SNXr74LdgpXEmU7K+cLYpD7jh2chgw@mail.gmail.com>
 <CAGXu5j+mVc6O_=GOF3YQmS4QZxeFgVPQtMxNH8sjBAhpJLjm9w@mail.gmail.com>
 <2679696.GDoj5zcZOu@natalenko.name>
 <CAGXu5jLG9ia+zBNcPt+q+BpJayoUuYwXitOgeHmh=7sPp-s87A@mail.gmail.com>
 <51a7e805058ef7f35b226cbbf0ccc4ff@natalenko.name>
 <CAGXu5jKRrdYjuyLSvc4k4mqttkM7zw-96poQ1GYqRRgPqZFOYQ@mail.gmail.com>
 <3d7b5a707e216e19eb3defe0586bfbc8@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <3d7b5a707e216e19eb3defe0586bfbc8@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.com>, Johannes Thumshirn <jthumshirn@suse.de>, linux-block@vger.kernel.org, paolo.valente@linaro.org, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

10.04.2018 08:35, Oleksandr Natalenko wrote:
>> - does it reproduce _without_ hardened usercopy? (I would assume yes,
>> but you'd just not get any warning until the hangs started.) If it
>> does reproduce without hardened usercopy, then a new bisect run could
>> narrow the search even more.
> 
> Looks like it cannot be disabled via kernel cmdline, so I have to
> re-compile the kernel, right? I can certainly do that anyway.

Okay, I've recompiled the kernel without hardened usercopy:

[root@archlinux ~]# zgrep USERCOPY /proc/config.gz
CONFIG_X86_INTEL_USERCOPY=y
CONFIG_HAVE_HARDENED_USERCOPY_ALLOCATOR=y
# CONFIG_HARDENED_USERCOPY is not set

and I cannot reproduce the issue anymore. I/O doesn't hang regardless of 
how long I hammer it.

Eeeh? Maybe, this is a matter of some cleanup code path once the 
warn/bug condition is hit with hardening enabled? I'm just guessing here 
again.

Will work towards checking Linus' master branch now…

Regards,
   Oleksandr
