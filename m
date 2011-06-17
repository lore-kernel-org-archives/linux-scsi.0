From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 08:27:30 +0200
Message-ID: <4DFAF3D2.5030506@suse.de>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp> <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com> <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com> <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com> <1308241506.2436.44.camel@mulgrave> <BANLkTi=qHhzwGfp4v8B1CAmT+gtA=sOgvw@mail.gmail.com> <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:50961 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751743Ab1FQG1d (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Jun 2011 02:27:33 -0400
In-Reply-To: <BANLkTikUNqTxgD_+TTVpcFyRDu_fSesrsg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On 06/16/2011 07:20 PM, Kay Sievers wrote:
> On Thu, Jun 16, 2011 at 19:09, Kay Sievers<kay.sievers@vrfy.org>  wro=
te:
>> On Thu, Jun 16, 2011 at 18:25, James Bottomley
>> <James.Bottomley@hansenpartnership.com>  wrote:
>>> On Thu, 2011-06-16 at 09:14 -0700, Greg KH wrote:
>>>> All userspace naming will be taken care of by the usual udev rules=
, so
>>>>> for disks, something like /dev/disk/by-preferred/<fred>  which wo=
uld be
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
>
> Guess all that would work now, including mount(8) not canonicalizing.
> What would happen if we mount:
>    /dev/disk/by-pretty/foo
> and some tool later thinks the pretty name should better be 'bar', it
> writes the name to /sys, we get a uevent, the old link disappears, we
> get a new link, mount has no device node anymore for the mounted
> device ...
>
> So we basically get a one-shot additional pretty name? Guess, the
> _single_ name changed anytime later just asks for serious problems. W=
e
> need to set it very early to be really useful, but how, where is it
> coming from?
>
Well, certain storage arrays are able to print out the user-defined=20
name for the LUNs:

# sg_vpd -p 0xc8 /dev/sdc
Extended device identification (RDAC) VPD Page:
   Volume Unique Identifier: 60080e50001bf1f0000005004ddb05a4
     Creation Number: 1280, Timestamp: Tue May 24 03:11:00 2011
   Volume User Label: mas-1
   Storage Array Unique Identifier: 60080e50001bf1f0000000004d418973
   Storage Array User Label: LSI-SAS-DIF
   Logical Unit Number: 0000000000000000

where the 'Volume User Label' is the name the administrator has=20
given to the LUN on the storage array.

So for these kind of things it would be useful.

However, a single pretty name is quite a limitation.
And I also fail to see why this can't be handled in userspace.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: J. Hawn, J. Guild, F. Imend=C3=B6rffer, HRB 16746 (AG N=C3=BCrnberg=
)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
