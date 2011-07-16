From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [RFC PATCH 0/4] Persistent device name using alias name
Date: Sat, 16 Jul 2011 20:40:27 +0900
Message-ID: <4E2178AB.1080007@hitachi.com>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp> <20110708194501.GU6418@nb.net.home> <4E1FE446.4040208@hitachi.com> <20110715124806.GH3486@nb.net.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:58978 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753413Ab1GPLkk (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 16 Jul 2011 07:40:40 -0400
In-Reply-To: <20110715124806.GH3486@nb.net.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Karel Zak <kzak@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de

Hi, Karel

Thank you for your comments.

(2011/07/15 21:48), Karel Zak wrote:
> On Fri, Jul 15, 2011 at 03:55:02PM +0900, Nao Nishijima wrote:
>>>  If there is not /dev/foo and /sys/block/foo then the patch introdu=
ces
>>>  a REGRESSION.=20
>>> =20
>>>  The names from /proc/partitions are used in many applications
>>>  (libblkid, fdisk, ...) for many many years. The applications will =
not
>>>  work as expected.
>>>
>>
>> I think that it is not a regression when users do not set an alias n=
ame.
>> Of course, I am going to modify all these utils so that users can us=
e
>> alias names.
>>
>> The purpose of alias names is to unify the name of device which user=
s
>> operate and see. Therefore, I think that users would like to get an
>> alias name from it, because currently they get a device name form it=
=2E
>>
>> However, for who wants to use alias name only for dmesg, I have an
>> enhancement idea that users can choose alias names or device names i=
n
>> procfs by sysctl (default is device names).
>=20
>>From my point of view
>=20
>     dmesg | grep <alias>
>=20
> seems a little bit problematic, because for example initial messages
> for the device will be invisible. In the log will be messages with
> original canonical names and another (later) messages with aliases, y=
ou
> can also change the alias, etc. Seems like a mess. The log should be
> consistent...
>=20
> I think it would be better to use always only canonical names in the
> kernel log and translate to something more user-friendly in userspace=
=2E
> For example if you add some meta-information to the kernel log then w=
e
> can improve dmesg(1) to translate the canonical names to aliases.
>=20
>  printk(KERN_INFO "this is info about %{device}s", device);
>=20
>  <5>[105221.774534]{device=3Dsda} this is info about sda
>=20
> or whatever... (this is a nice topic with many colors for the bike
> shed:-)
>=20
>> I would like to hear your opinion about this.
>=20
> If you want to modify all the userspace utils then you don't have to
> modify /proc/partitions :-)
>=20
> You can keep the standard names in /proc/partitions (so the file will
> be compatible with /sys and /dev) and you can modify all the utils to
> translate the canonical device names to aliases. The result will be
> the same, except "cat /proc/partitions" -- but I think that instead o=
f
> "cat" you can use "lsblk".
>=20

"lsblk" is great. (Sorry, I didn't know this command until now)

I think it would be good that users can get alias name from BOTH of
"lsblk" and "/proc/partitions", because users expect to see same name i=
n
kernel output and command output=E3=80=80as they can see now.

In kernel message, I think that "alias name" is necessary. Because thos=
e
logs are output when kernel crashes, it outputs kernel message to seria=
l
console. In that case, it's hard to convert canonical device name to
alias name.

> If you add only the attribute (alias name) to the /sys then you don't
> have to care if all the utils are already modified.
>=20
> Anyway, I still agree with Kay and Greg -- the proper solution
> is to improve printk() and dmesg(1). The aliases could be implemented=
=20
> in userspace by udev /dev/disk/by-alias/<cool_name> symlinks.
>=20

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
