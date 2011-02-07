From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Why using configfs as the only interface is wrong for a
	storage target
Date: Mon, 07 Feb 2011 12:09:39 -0800
Message-ID: <1297109379.13752.250.camel@haakon2.linux-iscsi.org>
References: <AANLkTi=b0mcWp3ergh=GvUF2CvgXUDv3Rq1fHY=xKf9L@mail.gmail.com>
	 <20110207115347.GA7503@noexit> <1297089709.3012.19.camel@mulgrave.site>
	 <20110207160223.598210a2@harpe.intellique.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48410 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589Ab1BGUJp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Feb 2011 15:09:45 -0500
In-Reply-To: <20110207160223.598210a2@harpe.intellique.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Joel Becker <jlbec@evilplan.org>, Bart Van Assche <bvanassche@acm.org>, linux-scsi <linux-scsi@vger.kernel.org>, Boaz Harrosh <bharrosh@panasas.com>

On Mon, 2011-02-07 at 16:02 +0100, Emmanuel Florac wrote:
> Le Mon, 07 Feb 2011 08:41:49 -0600
> James Bottomley <James.Bottomley@suse.de> =C3=A9crivait:
>=20
> > I think the overall philosophical point here, and it's a good one
> > because I've heard it from several sources, is that it's not possib=
le
> > to separate configuration from status completely.=20
>=20
> This would be true only if the machines weren't ever rebooted. Out of
> this uncommon case, this is even worse than the previous state of the
> matter : instead of having a (eventually nice, human readable)
> configuration file, you need a real program to create dynamically the
> devices at boot time, which is therefore your ACTUAL configuration
> file. So all you're achieving with this philosophy is replacing data
> files by programs -- anyone but kernel programmers will find this a
> terrible idea.
>=20
> Then to avoid the hassle, someone will have the clever idea to build =
a
> way to load an INI file into configfs through a specially crafted
> program living in /etc/init.d, and we'll have been going full circle.
> Slow clap... This is the most brain-dead idea I've heard of in a long
> time.
>=20

Sorry, but I have no idea what you are talking about.

We use direct configfs mkdirs and symlinks in our configuration files.
There are special cases where we use lio-utils.git python code to load
additional backend device specific metadata (like T10 WWN, persistent
reservations APTPL, ALUA multipath secondary port state, etc)

The whole idea is that configfs re-presents the parent/child
relationships of data structures who's creation/deletion is driven by
userspace.  Having python code walk this layout and output the exact
running configuration is how we save -> reinstate the running config,
and it's really quite trivial with configfs.

But that is just the simple stuff, where configfs really shines is with
a object oriented library and high level interactive shell that allows
the configfs hierarchy to be fully utilized by application level
programmers and end-user administrators.

--nab

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
