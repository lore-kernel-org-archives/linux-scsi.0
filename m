From: Ishikawa <ishikawa@yk.rim.or.jp>
Subject: Re: aic7xxx woes in 2.5
Date: Sun, 15 Dec 2002 15:06:10 +0900
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFC1BD2.F2F347C9@yk.rim.or.jp>
References: <3DFC059A.9AA3F75F@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from yk.rim.or.jp (really [127.0.0.1]) by yk.rim.or.jp
	via smail with esmtp
	id <m18NRul-000Gy1C@standard.erephon> (Debian Smail3.2.0.114)
	for <linux-scsi@vger.kernel.org>; Sun, 15 Dec 2002 15:06:11 +0900 (JST)
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: linux-scsi@vger.kernel.org

Hi,

> The parity error is intermittent.  But when it happens, the lockup
> always happens.
> 
> This never happens in 2.4 kernels.
> 
> It seems to happen a little more frequently on uniprocessor builds.
> 
> So relevant questions would be:
> 
> 1) Why does only 2.5 get the parity error?


Since you say "uniprocessor builds", maybe you are using 
high-quality dual processor board. But just in case, does your
motherboard support proper PCI parity bus check?
(I remember that when I switched motherboards about two years ago,
I noticed that the SCSI driver warns of me of a
parity error and won't start. I had to add a boot line
command option to ignore the parity error. The
board didn't seem to handle PCI bus parity bit properly. 
A surprise. I switched to another board 
a couple of weeks later, which supports 
parity without problem.)

So assuiming that the PCI parity is handled
correctly on your motherboard, I wonder if it is 
possibly a real intermittent parity error.
Maybe 2.5 is now more efficient in
data I/O rate and the excercised bus may encounter
occasional parity error.  A pure guess.
Frankly only a hardware engineer with good diagnostic
tool can tell the real cause if it is a real parity error.

Of course, there is a chance that the parity error
is reported by a slightly buggy driver (downloaded
firmware may not handle the timing correctly, etc. under
new kernel timing condition. )

> 2) Why does the recovery lock up?

A good question. There still may be missed
lock-up path(s) during recovery even in 2.5.

> scsi0 : Adaptec AIC7XXX EISA/VLB/PCI SCSI HBA DRIVER, Rev 6.2.5
>         <Adaptec 29160 Ultra160 SCSI adapter>
>         aic7892: Ultra160 Wide Channel A, SCSI Id=7, 32/253 SCBs
> 

I noticed that you have many disks.
Are they in external enclosure?
If not, is the power-supply in your
PC box spec'ed to supply enough power?
[I just had to reassemble non-linux PC to
upgrade the power-supply after I changed the video card.
(Newer video card seems to suck in power like a large
gas guzller.) Initially I replaced a power supply
to a newer one, which I thought was enough
to give the required power. But later on, I realized that
the new one didn't offer the enough power: the system
would still crash/get hung under heavy usage, and
upgraded to a larger one. That PC runs fine now.]

It is possible that the PC is running fine but the
power condition may be close to the safety limit and
a real parity may occur under heavy I/O conditions.

BTW, strange things do happen when we switch 
kernels and drivers, don't they?
If only I have a spare PC,
I would have tried  linux 2.5.xx to see how the
newer SCSI susbsystem fares in real-world conditions after
seeing so many problems in the older kernels with
my set of flakey and esoteric hardware drives: very long
silent/time out period of my CD changer drives, and
a Segate disk that had a few bad blocks which go bad
after it is heated up enough, etc..
[I still keep the Seagate drive as a test sample for
recovery testing. ]

 
-- 
int main(void){int j=2002;/*(c)2002 cishikawa. */
char t[] ="<CI> @abcdefghijklmnopqrstuvwxyz.,\n\"";
char *i ="h>qtCIuqivb,gCwe\np@.ietCIuqi\"tqkvv is>dnamz";
while(*i)((j+=strchr(t,*i++)-(int)t),(j%=sizeof t-1),
(putchar(t[j])));return 0;}/* under GPL */
