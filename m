From: Kay Sievers <kay.sievers@vrfy.org>
Subject: Re: [PATCH 1/3] [RFC] genhd: add a new attribute in device structure
Date: Fri, 17 Jun 2011 17:39:23 +0200
Message-ID: <BANLkTinywFK3yAxN51O7RDYyqeNRHBRThA@mail.gmail.com>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
 <20110615081627.2237.9620.stgit@ltc233.sdl.hitachi.co.jp> <20110615153337.GA10160@kroah.com>
 <4DF9F11F.705@hitachi.com> <20110616154129.GA31498@kroah.com>
 <1308239454.2436.34.camel@mulgrave> <20110616161442.GA32113@kroah.com>
 <1308241506.2436.44.camel@mulgrave> <20110616181943.GB1439@kroah.com>
 <1308256290.2436.143.camel@mulgrave> <BANLkTikfCMR_=5Jp7tLhM_Wr3vxihEL+rA@mail.gmail.com>
 <1308264321.2436.161.camel@mulgrave> <BANLkTinvfmU0dszQyu4U=Pw3_BtrmOUi_g@mail.gmail.com>
 <1308320844.2586.14.camel@mulgrave> <BANLkTikMa6vO4m3tk1O2mtj76k6s66f2gQ@mail.gmail.com>
 <1308322193.2586.30.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:33765 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759439Ab1FQPjj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 17 Jun 2011 11:39:39 -0400
In-Reply-To: <1308322193.2586.30.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: Greg KH <greg@kroah.com>, Nao Nishijima <nao.nishijima.xt@hitachi.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com

On Fri, Jun 17, 2011 at 16:49, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2011-06-17 at 16:40 +0200, Kay Sievers wrote:

>> Ok, the still remaining questions:
>>
>> Why isn't logging all symlink names during device discovery solving
>> all the problems we discuss without any change to the kernel? It's
>> just a single udev rule that can be added to ages old systems today.=
 I
>> think that solves exactly the same problem and works with many names
>> at the same time.
>
> It could ... but that doesn't solve the prink problem or
> the /proc/partitions one. =C2=A0The idea is to allow naive users to i=
dentify
> their device physically when the system logs something about it. =C2=A0=
Having
> to describe a manual mapping procedure is very complex for them.

How? You see 'sda kaput' then you scroll up to the last udev message
with /dev/disk/by-all-the-many-names/. Anyone who can't do this should
not even get access to the log file. :)

>> Where is "fred", "jim", and "betty" stored on bootup?
>
> So this is subsystem specific. =C2=A0For the case of a SCSI enclosure=
, I can
> answer that it's actually burned into the enclosure firmware. =C2=A0W=
hen you
> build an enclosure with labels, the label names are stored in a
> diagnostic page. =C2=A0We can actually interrogate the enclosure dire=
ctly or
> use the ses driver to get these names mapped to current devices.

To me this sounds like a nice name on top of the current bunch of
names, not like a 'preferred' name.

I still don't like to introduce any new facility to the kernel that
can handle only one single name. Reality the last years has taught us
a very different story, and we've walked a long way to get where we
are. I really don't believe single names will ever work, it's just a
nice theory.

>> What are the keys to match the pretty names to the disks?
>>
>> The pretty name is a one-shot setting only? If not how is a change
>> handled for already used devices?
>
> obviously, one device will be root, and it will already be used
> as /dev/root, but the proposal isn't to change any name, it's merely =
to
> set "fred" as the preferred name for /dev/root, which is also /dev/sd=
c
> and /dev/disk/by-id/naa-566dce3ddf etc ...

Sure, sounds nice. I just don't see how all that can be done
automatically in a sane way. It's like telling people to name their
network interfaces "internal", "external", "dmz". Almost nobody is
doing this, there is even the netif alias support already, and nobody
wants to use it besides a few SNMP tools. In my experience, stuff
needs to work out-of-the-box, or it is not used.

>> How will this information be available in the initramfs, where
>> mutltiple disks might need to be mounted already? Initramfs images a=
re
>> generic and not created per host.
>
> That's initramfs specific. =C2=A0However, if, in deference to your ne=
w
> location, we look at dracut, it has a modules directory for plugin
> extensions. =C2=A0The scripts which do the mapping can be inserted th=
ere as
> an additional rpm.

That's not really what I meant. I want to hear how the decision is
made which one of the multiple possibilities for the name composition
is chosen. Ideally it needs to work in a generic setup, not with a
customized host-specific file included even in the initramfs image.

>> How are multipath setups handled where the exact same disk is behind
>> multiple kernel devices? What to put into these names in this case?
>
> I'm not sure I understand the question. =C2=A0a md setup of RAID-1 on=
 fred
> and betty would assemble using /dev/disk/by-preferred/fred
> and /dev/disk/by-preferred/betty. =C2=A0Whether the user want's to
> call /dev/md0 something pretty is up to them ... it's not a physicall=
y
> labelled entity, so I'd tend just to leave it with its default name a=
s
> the preferred name.

I mean multi-path not raid. Disks have all the same ids, same
locations, but we have multiple kernel devices for them.

Kay
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
