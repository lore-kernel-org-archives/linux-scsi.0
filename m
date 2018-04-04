From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 04 Apr 2018 22:49:30 +0200
Message-ID: <3265889.eu5sbW8aRz@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi.

On středa 4. dubna 2018 22:21:53 CEST Kees Cook wrote:
> ...
> That means scsi_sense_cache should be 96 bytes in size? But a 22 byte
> read starting at offset 94 happened? That seems like a 20 byte read
> beyond the end of the SLUB object? Though if it were reading past the
> actual end of the object, I'd expect the hardened usercopy BUG (rather
> than the WARN) to kick in. Ah, it looks like
> /sys/kernel/slab/scsi_sense_cache/slab_size shows this to be 128 bytes
> of actual allocation, so the 20 bytes doesn't strictly overlap another
> object (hence no BUG):
> ...

Actually, I can trigger a BUG too:

[  129.259213] usercopy: Kernel memory exposure attempt detected from 
SLUB
object 'scsi_sense_cache' (offset 119, size 22)!
[  129.265167] ------------[ cut here ]------------
[  129.267579] kernel BUG at mm/usercopy.c:100!

And also offset can be different, as you may see:

[   55.993224] Bad or missing usercopy whitelist? Kernel memory exposure
attempt detected from SLUB object 'scsi_sense_cache' (offset 76, size 
22)!
[   55.998678] WARNING: CPU: 0 PID: 1305 at mm/usercopy.c:81 
usercopy_warn
+0x7e/0xa0

It looks like only the size stays the same.

> Can you send me your .config? What SCSI drivers are you using in the
> VM and on the real server?

This is an Arch kernel with a config available here [1].

For both server and VM "lspci -vv" shows "ahci" in use. Is this what you 
are
asking for?

> Are you able to see what ioctl()s smartctl is issuing? I'll try to
> reproduce this on my end...

As per [2], strace shows "SG_IO" requests. Is this detailed enough?

Thanks for looking into it.

Regards,
   Oleksandr

[1] https://git.archlinux.org/svntogit/packages.git/plain/trunk/config?
h=packages/linux&id=d7625be23f83416491d202d5cea96e5a871fb216
[2] https://gist.github.com/6f58f8891468aeba1ab2cc9f45668735
