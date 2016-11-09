From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Ordering problems with 3ware controller
Date: Wed, 9 Nov 2016 10:08:37 +0100
Message-ID: <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
 <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------54C6B319688ACF06085FF273"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:45383 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751654AbcKIJIk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 9 Nov 2016 04:08:40 -0500
In-Reply-To: <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Adam Radford <linuxraid@lsi.com>, dvteam@molgen.mpg.de

This is a multi-part message in MIME format.
--------------54C6B319688ACF06085FF273
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit

Dear Martin,


On 11/09/16 00:45, Martin K. Petersen wrote:
>>>>>> "Paul" == Paul Menzel <pmenzel@molgen.mpg.de> writes:

> Paul> Updating from Linux 4.4.X to Linux 4.8.4, we noticed that the
> Paul> 3ware devices under `/dev` – `/dev/twa0`, `/dev/twa1`, … – map to
> Paul> the controllers differently.
>
> Paul> This unfortunately breaks quite a lot of our scripts, as we depend
> Paul> on the fact that the first controller is also in the front.
>
> It's not the 3ware drivers since they have not been updated in a long
> time (since way before 4.4).

Yes, that’s what made me wonder too.

> Linux does not provide device discovery ordering guarantees. You need to
> fix your scripts to use UUIDs, filesystem labels, or DM devices to get
> stable naming.

Indeed. But it worked for several years, so that *something* must have 
changed that the ordering of the result of `getdents64` is different now.

Fixing the scripts is unfortunately not that easy, as `tw_cli` is a 
proprietary tool [1], and we do not have the sources. It does a `readdir()`.

> open("/proc/scsi/3w-9xxx", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = -1 ENOENT (No such file or directory)
> open("/sys/class/scsi_host", O_RDONLY|O_NONBLOCK|O_DIRECTORY) = 3
> fstat(3, {st_mode=S_IFDIR|0755, st_size=0, ...}) = 0
> fcntl(3, F_SETFD, FD_CLOEXEC)           = 0
> getdents64(3, /* 12 entries */, 4096)   = 368
> stat("/sys/class/scsi_host/host0/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host9/stats", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> open("/sys/class/scsi_host/host9/stats", O_RDONLY) = 4
> read(4, "3w-9xxx Driver v", 16)         = 16
> close(4)                                = 0
> open("/dev/twa0", O_RDWR)               = 4
> close(4)                                = 0
> stat("/sys/class/scsi_host/host7/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host5/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host3/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host1/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host8/stats", {st_mode=S_IFREG|0444, st_size=4096, ...}) = 0
> open("/sys/class/scsi_host/host8/stats", O_RDONLY) = 4
> read(4, "3w-9xxx Driver v", 16)         = 16
> close(4)                                = 0
> open("/dev/twa1", O_RDWR)               = 4
> close(4)                                = 0
> stat("/sys/class/scsi_host/host6/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host4/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> stat("/sys/class/scsi_host/host2/stats", 0x7fffafd05290) = -1 ENOENT (No such file or directory)
> getdents64(3, /* 0 entries */, 4096)    = 0
> close(3)                                = 0
> open("/proc/devices", O_RDONLY) = 3

Please find attached a wrapper from my colleague, using name spaces to 
ensure the ordering, that `tw_cli` expects.


Kind regards,

Paul


[1] https://wiki.hetzner.de/index.php/3Ware_RAID_Controller/en

--------------54C6B319688ACF06085FF273
Content-Type: text/plain; charset=UTF-8;
 name="tw_wrapcli"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
 filename="tw_wrapcli"

IyEgL3Vzci9iaW4vcGVybAp1c2Ugc3RyaWN0Owp1c2Ugd2FybmluZ3M7CgpzdWIgc29ydF9o
b3N0IHsKCW15ICgkbjEsJG4yKTsKCSgkbjEpPSRhPX4vXmhvc3QoXGQrKSQvIGFuZCAoJG4y
KT0kYj1+L15ob3N0KFxkKykkLyBhbmQgcmV0dXJuICRuMSA8PT4gJG4yOwoJcmV0dXJuICRh
IGNtcCAkYjsKfQoKCm91ciAkU1lTX3Vuc2hhcmU9MjcyOyAgICAgICMgL3Vzci9pbmNsdWRl
L2FzbS91bmlzdGRfNjQuaApvdXIgJENMT05FX05FV05TPTB4MjAwMDA7ICAjIC91c3IvaW5j
bHVkZS9saW51eC9zY2hlZC5oCgpteSAkcGlkPWZvcms7CmRlZmluZWQgJHBpZCBvciBkaWUg
IiQhXG4iOwp1bmxlc3MgKCRwaWQpIHsKCW9wZW5kaXIgbXkgJGQsIi9zeXMvY2xhc3Mvc2Nz
aV9ob3N0IjsKCW15IEBuYW1lcz1zb3J0IHNvcnRfaG9zdCBncmVwICEvXlwuXC4/JC8scmVh
ZGRpciAkZDsKCglzeXNjYWxsKCRTWVNfdW5zaGFyZSwkQ0xPTkVfTkVXTlMpIGFuZCBkaWUg
IiQhXG4iOwoJLWQgJy90bXAvc3lzZnMnIG9yIG1rZGlyKCIvdG1wL3N5c2ZzIikgb3IgZGll
ICIvdG1wL3N5c2ZzOiAkIVxuIjsKCXN5c3RlbSAnbW91bnQnLCctdHN5c2ZzJywnQkxBJywn
L3RtcC9zeXNmcycgYW5kIGV4aXQgMTsKCXN5c3RlbSAnbW91bnQnLCctdHRtcGZzJywnQkxB
JywnL3N5cy9jbGFzcy9zY3NpX2hvc3QnIGFuZCBleGl0IDE7CgoJZm9yIG15ICRuYW1lIChy
ZXZlcnNlIEBuYW1lcykgewoJCXN5bWxpbmsoIi90bXAvc3lzZnMvY2xhc3Mvc2NzaV9ob3N0
LyRuYW1lIiwiL3N5cy9jbGFzcy9zY3NpX2hvc3QvJG5hbWUiKSBvciBkaWUgIi9zeXMvY2xh
c3Mvc2NzaV9ob3N0LyRuYW1lOiAkIVxuIjsKCX0KCWV4ZWMgJy9yb290L2Jpbi90d19jbGku
ZXhlJyxAQVJHVjsKCWRpZSAiJCFcbiI7Cn0Kd2FpdDsKJD8gYW5kIGV4aXQgMTsK
--------------54C6B319688ACF06085FF273--
