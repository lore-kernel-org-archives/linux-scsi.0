From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [-v3 PATCH 0/3] Persistent device name using alias
Date: Sat, 27 Aug 2011 19:15:25 +0900
Message-ID: <4E58C3BD.3000609@hitachi.com>
References: <20110825090359.2288.91057.stgit@ltc197.sdl.hitachi.co.jp> <20110825101602.GI3286@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail9.hitachi.co.jp ([133.145.228.44]:52213 "EHLO
	mail9.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab1H0KPa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 27 Aug 2011 06:15:30 -0400
In-Reply-To: <20110825101602.GI3286@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, James.Bottomley@HansenPartnership.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com

Hi Tejun,

Thank you for your comments.

(2011/08/25 19:16), Tejun Heo wrote:
> Hello,
>=20
> On Thu, Aug 25, 2011 at 06:03:59PM +0900, Nao Nishijima wrote:
>> This patch series provide an "alias" of the disk into kernel message=
s.
>>
>> A raw device name of a disk does not always point a same disk at eac=
h boot-up
>> time. Therefore, users have to use persistent device names, which ud=
ev creates
>> to always access the same disk. However, kernel messages still displ=
ay the raw
>> device names.
>>
>> My proposal is that users can use and see persistent device names wh=
ich were
>> assigned by themselves because users expect same name to point same =
disk
>> anytime.
>>
>> Why need to modify kernel messages?
>> - We can see mapping of device names and persistent device names in =
udev log.
>>   If those logs output to syslog, we can search persistent device na=
me from
>>   device name, but it can cause a large amount of syslog output.
>>
>> - If we can use the persistent device names and can always see the s=
ame name on
>>   the kernel log, we don't need to pay additional cost for searching=
 and picking
>>   a correct pair of device name and persistent device name from udev=
 log.
>>
>> - Kernel messages are output to serial console when kenel crashes, i=
t's so hard
>>   to convert a device name to the alias.
>=20
> Just some general comments.  This may already be a horse which is
> beaten to death but anyways...
>=20
> I'm not really convinced this is something we need.  What we're
> missing is structured error reporting which can be understood,
> processed, presented and reacted by programs implementing system
> management policies.  Such facility would be useful in general but fo=
r
> block devices I think it's a must that we're sorely missing.

Yes. I agree that we need structured error reporting.
This facility will be discussed by Kay Sievers at Kernel Summit.

However I think that even if it is applied in kernel, "alias" is still
necessary because users want to use and see friendly name which can be
simple, short and preference, instead of persistent device names (e.g.
/dev/disk/by-uuid/35d4def7-9098-448c-8cc3-b0cb74c8670b).


> Free format kernel message is a very undiscoverable way of
> communicating these information.  For developing and debugging, it's
> fine.  It's easy, flexible and you don't really have to think too muc=
h
> about what should be presented how.  For anything else, it's basicall=
y
> horrible.
>=20
> I don't really see what the point of this feature is.  For developing
> and debugging, pretty names might be nice but almost completely
> unnecessary.  For anything else, this falls way too short and can be
> easily replaced by some smart scripting from userland.  After all,
> matching different device names is the least of the worries when
> trying to use kernel log for general management and post-processing w=
/
> good amount of heuristics is necessary to be useful anyway.

Our concern is the failure analysis. For example, when the disk failure
happened, we need to identify the disk from kernel log.

Kernel messages are output to serial console when kernel crashes.
It's so hard to convert a device name to the alias. Thus the script
can't always convert the name.

Also, the alias is useful for users because they can use and see the
same name everywhere(e.g. commands, kernel log).


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
