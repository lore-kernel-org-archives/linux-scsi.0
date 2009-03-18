From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] scsi_dh: Add modalias support for SCSI targets
Date: Wed, 18 Mar 2009 21:24:41 +0100
Message-ID: <ac3eb2510903181324s6bc442e0ka3448b53567e1dce@mail.gmail.com>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu>
	 <20090318013621.26548.10529.sendpatchset@chandra-ubuntu>
	 <1237402051.3350.29.camel@localhost.localdomain>
	 <1237403542.14147.23.camel@chandra-ubuntu>
	 <1237406940.3350.39.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f165.google.com ([209.85.219.165]:52220 "EHLO
	mail-ew0-f165.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbZCRUYp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 16:24:45 -0400
Received: by ewy9 with SMTP id 9so182676ewy.37
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2009 13:24:42 -0700 (PDT)
In-Reply-To: <1237406940.3350.39.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: sekharan@linux.vnet.ibm.com, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu

On Wed, Mar 18, 2009 at 21:09, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Wed, 2009-03-18 at 12:12 -0700, Chandra Seetharaman wrote:
>> On Wed, 2009-03-18 at 18:47 +0000, James Bottomley wrote:
>> > On Tue, 2009-03-17 at 18:36 -0700, Chandra Seetharaman wrote:
>> > > From: Peter Jones <pjones@redhat.com>
>> > >
>> > > This patch allows the use of modaliases on scsi targets to corre=
ctly
>> > > load scsi device handler modules when the devices are found.
>> > >
>> > > Signed-off-by: Peter Jones <pjones@redhat.com>
>> > > Signed-off-by: Chandra Seetharaman <sekharan@us.ibm.com>
>> >
>> > I have to say this is a bit icky.
>> >
>> > overloading the modalias type like this produces several nasty eff=
ects:
>> >
>> > =C2=A0 =C2=A0 =C2=A01. You don't actually care about type for any =
of the scsi_dh
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 handlers, so they all have it as a use=
less extra field
>> > =C2=A0 =C2=A0 =C2=A02. TYPE_ANY is a bogus (non SAM) definition ..=
=2E I suppose it's
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 unlikely ever to clash, but you never =
know
>>
>> >From (1) and (2) are you suggesting _not_ to use the TYPE field for
>> scsi_dh handlers ?
>
> Well, you don't ever set it to anything other than TYPE_ANY, do you? =
so
> it's completely superfluous as far as you're concerned. =C2=A0That's =
why
> overloading the SCSI ULD modalias looks rather contrived.
>
>> > =C2=A0 =C2=A0 =C2=A03. scsi_dh handlers would now get loaded on *a=
ny* system ...
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 regardless of whether it's using multi=
pathing or not ... that's
>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 going to cause problems with other mul=
ti path solutions, I bet.
>>
>> Actually that is the intent. We _do_ want scsi_dh handlers to be loa=
ded
>> before multipath comes into picture.
>>
>> Basically we want the handlers to be available ASAP after the device=
 is
>> configured. The reason is:
>> =C2=A0- These devices are active/passive, SCSI doesn't know about it=
 and
>> =C2=A0 =C2=A0any I/O sent to SCSI will be sent down to the device, i=
rrespective
>> =C2=A0 =C2=A0of the active/passive nature of the device in that path=
=2E When the
>> =C2=A0 =C2=A0device (path) is passive, I/O leads to time delay and e=
xtraneous
>> =C2=A0 =C2=A0error message (these are the two main reasons we moved =
the
>> =C2=A0 =C2=A0device handler code from dm-multipath layer to SCSI(scs=
i_dh)).
>>
>> With scsi_dh, I/O to the passive path will be short circuited in
>> prep_fn() and errors are REQ_QUIET'd.
>>
>> Currently I suggest users to add these modules to their initrd to ma=
ke
>> them available ASAP (as described at
>> http://sources.redhat.com/lvm2/wiki/MultipathUsageGuide#head-fb3efbb=
82fa69ca86b7db26423c235ae6c280caa)
>>
>> If we have the support thru modalias, then appropriate modules will =
be
>> included in initrd by the installer, thereby making it easier for th=
e
>> user.
>
> Um, is that correct? =C2=A0the MODALIAS env is lost as soon as it goe=
s
> through udev. =C2=A0For initrd to base module selection on the MODALI=
AS, it
> will have to reconstruct it after the fact (and so need modifying to =
use
> the new modalias).

A device's modalias is usually also available as an attribute called
"modalias". The entire device uevent environment is in almost all
cases also available by reading the "uevent" file of the device at any
time later.

Does that help? I might misread your "MODALIAS env is lost" sentence.

Thanks,
Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
