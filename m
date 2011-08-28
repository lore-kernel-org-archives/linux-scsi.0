From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Sun, 28 Aug 2011 20:07:09 +0200
Message-ID: <CAPXgP12Qn2s5ZS5jHCR-Nw_E9FWkX6E3MXhQ5gy6YEq4Zm8S0g@mail.gmail.com>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp>
 <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com>
 <20110827102655.GJ2632@htj.dyndns.org> <4E58E905.4020704@hitachi.com> <20110827132044.GN2632@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51565 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751664Ab1H1SH3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 28 Aug 2011 14:07:29 -0400
In-Reply-To: <20110827132044.GN2632@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@hansenpartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com

On Sat, Aug 27, 2011 at 15:20, Tejun Heo <tj@kernel.org> wrote:
> On Sat, Aug 27, 2011 at 09:54:29PM +0900, Nao Nishijima wrote:
>> > Hmm... I don't follow. =C2=A0Why wouldn't it be able to? =C2=A0All=
 the
>> > informations are in the log. =C2=A0It is messy but it's there. =C2=
=A0If you want
>>
>> In many cases, the script is able to convert the name. However there=
 is
>> the special case that the logs do not exist in memory and disk due t=
o
>> the crash except console.
>
> Sorry but I still don't get it. =C2=A0If you can extract the log, the
> information is there and w/ remote logging (be it via serial or
> network), the information always has to be there. =C2=A0Are you talki=
ng
> about the case where somehow only the video console somehow succeeds
> to print out oops? =C2=A0I don't think that's a common case as serial=
 (also
> on IPMI) tends to be pretty robust, often more robust than vide
> output, and even when such case occurs, the only thing you want is
> mapping kernel device name to more recognizable information, which
> isn't difficult at all. =C2=A0If you wanna do it in a really simple m=
anner,
> just save udisks --dump output after boot and each hotplug event and
> write a simple script to search it.
>
>> > more structured information, u{dev|disks} already maintain device
>> > libarary - what maps to what, connected how with what attributes a=
nd
>> > so on. =C2=A0Sending them off to the log machine as device hotplug=
 events
>> > occur and consulting it when post-processing log message would wor=
k
>> > fine. =C2=A0All you need is just some python scripting. =C2=A0I do=
n't really see
>> > much point in messing with device names directly. =C2=A0The only t=
hing is
>> > that the raw log would be prettier. =C2=A0I don't think that is us=
eful
>> > enough to justify changing kernel device names.
>>
>> A kernel device names (e.g. sda) is not useful information because i=
t
>> doesn't always point the same disk at each boot-up time.
>
> Eh? =C2=A0What difference does that make? =C2=A0Just make the target =
machines
> send up-to-date disk config info to the log server.
>
>> An alias is just an option and provides the ability to give all
>> kernel devices a "preferred name".
>>
>> By default, dev_printk's will show a kernel device name. They show a=
n
>> alias only when the user assigns a "preferred name" to an alias.
>> Even if the persistend device name is used, the device names in logs=
 are
>> different from the name that the users are using. So, an alias helps=
 the
>> user identify the disk.
>
> Yes, I do understand what it's doing and can see there can be cases i=
t
> can be somewhat useful but I still think it's too adhoc an approach
> which doesn't really justify itself. =C2=A0It just does too little to=
 solve
> the actual problem and even that 'little' part isn't very trivial - i=
t
> adds whole lot of policy decisions to make and I'm pretty sure it wil=
l
> cause good amount of havoc w/ all the system tools which currently
> don't expect block device names to change to some admin determined
> free format string on the fly.

My take on this in short again:
The very same thing that needs to store the 'pretty name' in the
kernel here, can instead just log that name along with the kernel name
to /dev/kmsg. It ends up in the kernel log buffer and is the marker to
safely match all later log entries.

This can be done today, even on many years old distros, with a single
udev rule and a tiny program. It needs no kernel or tool changes and
gives almost all the benefits of the 'pretty name' infrastructure.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
