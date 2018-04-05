From: Oleksandr Natalenko <oleksandr@natalenko.name>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 05 Apr 2018 16:32:45 +0200
Message-ID: <dee9721a530576e667881d86bbec351b@natalenko.name>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name>
 <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
 <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name>
 <CAGXu5jKhiE512yQXp90M+Wie=8RkpMZT-Yi_9BgjfKwibP433g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jKhiE512yQXp90M+Wie=8RkpMZT-Yi_9BgjfKwibP433g@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, keescook@google.com
List-Id: linux-scsi@vger.kernel.org

Hi.

05.04.2018 16:21, Kees Cook wrote:
> I had a VM running over night with:
> 
> [1]   Running                 while :; do
>     smartctl -a /dev/sda > /dev/null;
> done &
> [2]-  Running                 while :; do
>     ls --color=auto -lR / > /dev/null 2> /dev/null;
> done &
> [3]+  Running                 while :; do
>     sleep $(( $RANDOM % 100 )); sync; echo 3 > 
> /proc/sys/vm/drop_caches;
> done &
> 
> and I haven't seen the issue. :(
> 
> FWIW, I'm using the ahci qemu driver:
> 
> -drive file=disk-image.raw,if=none,id=drive0,format=raw \
> -device ahci,id=bus0 \
> -device ide-drive,bus=bus0.0,drive=drive0
> 
> Does this match your qemu instance?

Well, not really. I just pass 2 raw disks as "-hda sda.img -hdb sda.img" 
(it is a playground VM for me with RAID10, LVM and LUKS inside, but I 
hope this doesn't matter). Does passing "-hda" differ from your 
approach?

Regards,
   Oleksandr
