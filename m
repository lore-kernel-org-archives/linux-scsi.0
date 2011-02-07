From: Emmanuel Florac <eflorac@intellique.com>
Subject: Re: Why using configfs as the only interface is wrong for a storage
 target
Date: Mon, 7 Feb 2011 22:38:45 +0100
Message-ID: <20110207223845.71d2ab18@galadriel2.home>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	<20110207115347.GA7503@noexit>
	<1297089709.3012.19.camel@mulgrave.site>
	<20110207160223.598210a2@harpe.intellique.com>
	<1297109379.13752.250.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp3-g21.free.fr ([212.27.42.3]:33315 "EHLO smtp3-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754790Ab1BGVkH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 16:40:07 -0500
In-Reply-To: <1297109379.13752.250.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: James Bottomley <James.Bottomley@suse.de>, Joel Becker <jlbec@evilplan.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

Le Mon, 07 Feb 2011 12:09:39 -0800 vous =C3=A9criviez:

> Sorry, but I have no idea what you are talking about.

Sorry too, I'm just a typical target user, and I'm pretty confused.

> We use direct configfs mkdirs and symlinks in our configuration files=
=2E

> There are special cases where we use lio-utils.git python code to loa=
d
> additional backend device specific metadata (like T10 WWN, persistent
> reservations APTPL, ALUA multipath secondary port state, etc)

The configuration files are actually programs, because even a simple
bash script is a program. I'm getting uneasy. These are not your
regular, non executable config files.

> The whole idea is that configfs re-presents the parent/child
> relationships of data structures whose creation/deletion is driven by
> userspace.=20

Yes, this is the really good part, and I'll be eternally grateful for
this. Thank you.=20

> Having python code walk this layout and output the exact
> running configuration is how we save -> reinstate the running config,
> and it's really quite trivial with configfs.

Please understand that at this point, anybody lacking a deep
understanding of kernel innards like me or 99.9% of linux system
admins or users, really don't give a fsck. I actually understand the
problem with using sysfs for that, but the fact is that from a
usability point of view this doesn't make a frigging difference, except
that we have another unfathomable virtual filesystem. We could do just
the same with /proc or /sys, and a startup script for either ietd or
scst or stgt, from the user POV.

So as long as the config is not really, completely automagically made
persistent by some in-kernel mechanism, this isn't any better than a
daemon loading a config file. In fact, it's worse, because it's more
unusual.=20

> But that is just the simple stuff, where configfs really shines is
> with a object oriented library and high level interactive shell that
> allows the configfs hierarchy to be fully utilized by application
> level programmers and end-user administrators.

You know, my first reaction was :

Aaaaargh. Are you trying to convince me that you've done the windows
registry right this time? I don't want no stinking object oriented
library to manage my scsi targets.

But finally, OK, I see the point for infrastructure. Now tell me, could
we avoid more virtual fs creep in the future ?=20

What bothers me is that I'm not sure you can make a Ferrari by bolting
new parts onto a Ford, or in this particular case importing Plan9
architectural features into the Linux kernel.

--=20
-----------------------------------------------------------------------=
-
Emmanuel Florac     |   Direction technique
                    |   Intellique
                    |	<eflorac@intellique.com>
                    |   +33 1 78 94 84 02
-----------------------------------------------------------------------=
-
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
