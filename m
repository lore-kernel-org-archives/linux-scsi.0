From: torvalds@transmeta.com (Linus Torvalds)
Subject: Re: [RFC] Persistent naming of scsi devices
Date: Wed, 10 Apr 2002 02:17:05 +0000 (UTC)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <a907b1$rdj$1@penguin.transmeta.com>
References: <OF8B2F3581.590066BE-ONC1256B95.0068B28C@de.ibm.com> <3CB39285.8000609@vitalstream.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by neon-gw.transmeta.com (8.9.3/8.9.3) id TAA20381
	for <linux-scsi@vger.kernel.org>; Tue, 9 Apr 2002 19:17:45 -0700
Received: from palladium.transmeta.com (palladium.transmeta.com [10.1.1.46])
	by deepthought.transmeta.com (8.11.6/8.11.6) with ESMTP id g3A2HfN03547
	for <linux-scsi@vger.kernel.org>; Tue, 9 Apr 2002 19:17:42 -0700 (PDT)
Received: (from mail@localhost)
	by palladium.transmeta.com (8.9.3/8.9.3) id TAA20627
	for linux-scsi@vger.kernel.org; Tue, 9 Apr 2002 19:17:41 -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

In article <3CB39285.8000609@vitalstream.com>,
Rick Stevens  <rstevens@vitalstream.com> wrote:
>
> [ Position-based naming ]
>
>As I said, other people smarter than I seem to think it makes sense.

No, those people were probably not smarter than you. In fact, they are
likely complete morons.

Position means nothing.  Anybody who bases naming on position is just
bending over and waiting for it when it comes to hotplugging etc.  It
solves none of the problems it is claimed to solve (ie the names are
_not_ constant), and it fundamentally locks you into a mindset that
simply isn't true. 

>Why not Linux?  It's silly to smush things together just to satisfy a
>bizzare craving to have a list of devices with no "holes" in it.

No, it's silly to think that you can enumerate the address space: you
can't. The only thing you get from trying is a horrible mess in /dev
that adds zero information anywhere.

You're much better off just enumerating your SCSI devices the trivial
way (ie 0, 1, 2 ....  completely independent on position - each device
gets one unique number that has no inherent meaning and is UNDERSTOOD to
have no inherent meaning, only an ID) and then having a way to query
their attibutes.  That way you can use the attributes (which are _NOT_
identities) to create whatever "convenient mapping" you want. 

The position of a drive is not its name, it's just one random attribute
in a sea of other random attributes.  Depending on what you do, it might
be a useful one, but it's equally likely that it is completely
meaningless.  Trying to make it inherently meaningful is just *wrong*.

		Linus
