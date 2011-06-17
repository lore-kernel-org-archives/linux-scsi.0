From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 21:28:31 +0900
Message-ID: <4DFB486F.9080100@hitachi.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com> <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com> <4DFAF3D2.5030506@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail7.hitachi.co.jp ([133.145.228.42]:55503 "EHLO
	mail7.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755627Ab1FQM2g (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2011 08:28:36 -0400
In-Reply-To: <4DFAF3D2.5030506@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Kay Sievers <kay.sievers@vrfy.org>, James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

Hi Hannes,

Thank you for looking at it.

(2011/06/17 15:27), Hannes Reinecke wrote:
> On 06/16/2011 07:20 PM, Kay Sievers wrote:
>> On Thu, Jun 16, 2011 at 19:09, Kay Sievers<kay.sievers@vrfy.org>  wr=
ote:
>>> On Thu, Jun 16, 2011 at 18:25, James Bottomley
>>> <James.Bottomley@hansenpartnership.com>  wrote:
>>>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>>>> All userspace naming will be taken care of by the usual udev rule=
s, so
>>>>>> for disks, something like /dev/disk/by-preferred/<fred>  which
>>>>>> would be
>>>>>> the usual symbolic link.
>>>>>
>>>>> No, udev can not create such a link after the preferred name is
>>>>> set, as
>>>>> it has no way of knowing that the name was set.
>>>>
>>>> It can if we trigger a uevent.  Note: I'm not advocating this ...
>>>> I'd be
>>>> equally happy having whatever sets the kernel name create the link=
 (or
>>>> tickle udev to create it).  We definitely require device links, th=
ough,
>>>> to get this to work.
>>
>> Guess all that would work now, including mount(8) not canonicalizing=
=2E
>> What would happen if we mount:
>>    /dev/disk/by-pretty/foo
>> and some tool later thinks the pretty name should better be 'bar', i=
t
>> writes the name to /sys, we get a uevent, the old link disappears, w=
e
>> get a new link, mount has no device node anymore for the mounted
>> device ...
>>
>> So we basically get a one-shot additional pretty name? Guess, the
>> _single_ name changed anytime later just asks for serious problems. =
We
>> need to set it very early to be really useful, but how, where is it
>> coming from?
>>
> Well, certain storage arrays are able to print out the user-defined n=
ame
> for the LUNs:
>=20
> # sg_vpd -p 0xc8 /dev/sdc
> Extended device identification (RDAC) VPD Page:
>   Volume Unique Identifier: 60080e50001bf1f0000005004ddb05a4
>     Creation Number: 1280, Timestamp: Tue May 24 03:11:00 2011
>   Volume User Label: mas-1
>   Storage Array Unique Identifier: 60080e50001bf1f0000000004d418973
>   Storage Array User Label: LSI-SAS-DIF
>   Logical Unit Number: 0000000000000000
>=20
> where the 'Volume User Label' is the name the administrator has given=
 to
> the LUN on the storage array.
>=20
> So for these kind of things it would be useful.
>=20
> However, a single pretty name is quite a limitation.
> And I also fail to see why this can't be handled in userspace.
>=20

I know that there are several names for one device.
Preferred name does not eliminate those names, but just add another
pretty name. Usually those machine-generated names are too long and
not familiar with users. preferred name will provide a human-readable
name and reduce the operation cost.

Thanks,

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
