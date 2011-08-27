From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Sat, 27 Aug 2011 21:54:29 +0900
Message-ID: <4E58E905.4020704@hitachi.com>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org> <4E58C3BD.3000609@hitachi.com> <20110827102655.GJ2632@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:43976 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751593Ab1H0Mye (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2011 08:54:34 -0400
In-Reply-To: <20110827102655.GJ2632@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, kay.sievers@gmail.com

Hello,

(2011/08/27 19:26), Tejun Heo wrote:
> (cc'ing Kay)
> Hello,
>=20
> On Sat, Aug 27, 2011 at 07:15:25PM +0900, Nao Nishijima wrote:
>> Our concern is the failure analysis. For example, when the disk fail=
ure
>> happened, we need to identify the disk from kernel log.
>>
>> Kernel messages are output to serial console when kernel crashes.
>> It's so hard to convert a device name to the alias. Thus the script
>> can't always convert the name.
>=20
> Hmm... I don't follow.  Why wouldn't it be able to?  All the
> informations are in the log.  It is messy but it's there.  If you wan=
t

In many cases, the script is able to convert the name. However there is
the special case that the logs do not exist in memory and disk due to
the crash except console.


> more structured information, u{dev|disks} already maintain device
> libarary - what maps to what, connected how with what attributes and
> so on.  Sending them off to the log machine as device hotplug events
> occur and consulting it when post-processing log message would work
> fine.  All you need is just some python scripting.  I don't really se=
e
> much point in messing with device names directly.  The only thing is
> that the raw log would be prettier.  I don't think that is useful
> enough to justify changing kernel device names.

A kernel device names (e.g. sda) is not useful information because it
doesn't always point the same disk at each boot-up time.

An alias is just an option and provides the ability to give all
kernel devices a "preferred name".

By default, dev_printk's will show a kernel device name. They show an
alias only when the user assigns a "preferred name" to an alias.
Even if the persistend device name is used, the device names in logs ar=
e
different from the name that the users are using. So, an alias helps th=
e
user identify the disk.


Best regards,

--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
