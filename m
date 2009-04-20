From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] RFC scsi_error: handle REPORT_LUNS_DATA_CHANGED, CAPACITY_DATA_CHANGED,
Date: Mon, 20 Apr 2009 11:55:52 +0200
Message-ID: <49EC46A8.1070704@suse.de>
References: <12385252751209-git-send-email-michaelc@cs.wisc.edu> <49E90243.7080806@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:53751 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754240AbZDTJzy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 20 Apr 2009 05:55:54 -0400
In-Reply-To: <49E90243.7080806@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

Hi Mike,

Mike Christie wrote:
> Hey Hannes
>=20
> While we are talking about LSF stuff and you are not busy with distro
> stuff....
>=20
Ah, irony detector kicked in.
(Current bugilla count is at 114. Ask me about being busy.)

> I implemented this based on what we talked about at the last LSF.
>=20
Yes, I've seen it. You again beat me to it; I've done an initial implem=
entation
already but failed to send it mainline. Sigh.

But yes, we _do_ need something like this.

> I was thinking that maybe using kobject_uevent_env would be better. T=
he
> info that gets passed to userspace would be the decoded sense and
> asc/ascq based on values from the drivers/scsi/constants.c.
>=20
No. This patch has the possibility of generating _huge_ amounts of
messages, most of which are information only and of no influence
to the actual operation.
udev would be flooded with it and won't be able to react to 'important'
messages while processing them.

Hence a separate mechanism like the proposed SCSI generic netlink
facility is the better approach.

> I was also thinking that a udev rule could then just handle something
> like rescanning for REPORT_LUNS_DATA_CHANGED and handle
> CAPACITY_DATA_CHANGED by doing all the crap that has to be done.
>=20
Yes, that was my initial thought, too. But Kay objected because
of the possible message flooding in udev so we have to use a
separate facility here.

Actually, I already have a daemon implemented. I can drop you
a pointer to the location if required.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
