From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 20:36:38 +0900
Message-ID: <4DFB3C46.4030909@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com> <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com
List-Id: linux-scsi@vger.kernel.org

Hi Kay,

Thank you for looking at it.

(2011/06/17 2:20), Kay Sievers wrote:
> On Thu, Jun 16, 2011 at 19:09, Kay Sievers <kay.sievers@vrfy.org> wro=
te:
>> On Thu, Jun 16, 2011 at 18:25, James Bottomley
>> <James.Bottomley@hansenpartnership.com> wrote:
>>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>>> All userspace naming will be taken care of by the usual udev rules=
, so
>>>>> for disks, something like /dev/disk/by-preferred/<fred> which wou=
ld be
>>>>> the usual symbolic link.
>>>>
>>>> No, udev can not create such a link after the preferred name is se=
t, as
>>>> it has no way of knowing that the name was set.
>>>
>>> It can if we trigger a uevent.  Note: I'm not advocating this ... I=
'd be
>>> equally happy having whatever sets the kernel name create the link =
(or
>>> tickle udev to create it).  We definitely require device links, tho=
ugh,
>>> to get this to work.
>=20
> Guess all that would work now, including mount(8) not canonicalizing.
> What would happen if we mount:
>   /dev/disk/by-pretty/foo
> and some tool later thinks the pretty name should better be 'bar', it
> writes the name to /sys, we get a uevent, the old link disappears, we
> get a new link, mount has no device node anymore for the mounted
> device ...
>=20
> So we basically get a one-shot additional pretty name? Guess, the
> _single_ name changed anytime later just asks for serious problems. W=
e
> need to set it very early to be really useful, but how, where is it
> coming from?
>=20

If we can avoid serious problems, I will implement preferred name as
write once.

I have two idea for work preferred name from the very first steps durin=
g
early boot in initramfs.

1. I think we can provide udev rules for preferred name in initramfs.
2. (option) I consider using user-defined name for the LUNs(*) because
   it is possible to get the name in initramfs. The user store preferre=
d
   name in LUNs by sg command if available.

(*) Hannes say:
> Well, certain storage arrays are able to print out the user-defined n=
ame for the LUNs:
>
> # sg_vpd -p 0xc8 /dev/sdc
> Extended device identification (RDAC) VPD Page:
>   Volume Unique Identifier: 60080e50001bf1f0000005004ddb05a4
>     Creation Number: 1280, Timestamp: Tue May 24 03:11:00 2011
>   Volume User Label: mas-1
>   Storage Array Unique Identifier: 60080e50001bf1f0000000004d418973
>   Storage Array User Label: LSI-SAS-DIF
>   Logical Unit Number: 0000000000000000
>
> where the 'Volume User Label' is the name the administrator has given=
 to the LUN on the storage array.=20


Thanks,

--=20
Nao NISHIJIMA
Software Platform Research Dept. Linux Technology Center
Hitachi, Ltd., YOKOHAMA Research  Laboratory
Email=EF=BC=9A nao.nishijima.xt@hitachi.com
