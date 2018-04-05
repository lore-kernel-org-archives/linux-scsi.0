From: Kees Cook <keescook@chromium.org>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Thu, 5 Apr 2018 07:21:31 -0700
Message-ID: <CAGXu5jKhiE512yQXp90M+Wie=8RkpMZT-Yi_9BgjfKwibP433g@mail.gmail.com>
References: <10360653.ov98egbaqx@natalenko.name> <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
 <3265889.eu5sbW8aRz@natalenko.name> <CAGXu5jL++CEmLzFtGMVMhGWBzHpsRNJPTsEoc7Pw1dP--=azCA@mail.gmail.com>
 <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <7fc01f67a561ce1fad676fc34c2249e7@natalenko.name>
Sender: linux-kernel-owner@vger.kernel.org
To: Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 5, 2018 at 2:56 AM, Oleksandr Natalenko
<oleksandr@natalenko.name> wrote:
> Hi.
>
> 04.04.2018 23:25, Kees Cook wrote:
>>
>> Thanks for the report! I hope someone more familiar with sg_io() can
>> help explain the changing buffer offset... :P
>
>
> Also, FYI, I kept the server running with smartctl periodically invoked, =
and
> it was still triggering BUGs, however, I consider them to be more or less
> harmless until the server got stuck with high I/O wait this morning after
> next smartctl invocation. So, it isn't harmless, it seems=E2=80=A6
>
> It could be unrelated, of course, since the journal didn't give me any hi=
nt
> (or a stack trace) on what happened, thus I'll monitor how things behave
> without smartctl too.

I had a VM running over night with:

[1]   Running                 while :; do
    smartctl -a /dev/sda > /dev/null;
done &
[2]-  Running                 while :; do
    ls --color=3Dauto -lR / > /dev/null 2> /dev/null;
done &
[3]+  Running                 while :; do
    sleep $(( $RANDOM % 100 )); sync; echo 3 > /proc/sys/vm/drop_caches;
done &

and I haven't seen the issue. :(

FWIW, I'm using the ahci qemu driver:

-drive file=3Ddisk-image.raw,if=3Dnone,id=3Ddrive0,format=3Draw \
-device ahci,id=3Dbus0 \
-device ide-drive,bus=3Dbus0.0,drive=3Ddrive0

Does this match your qemu instance?

-Kees

--=20
Kees Cook
Pixel Security
