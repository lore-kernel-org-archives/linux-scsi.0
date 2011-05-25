From: scameron@beardog.cce.hp.com
Subject: Re: Question about aborting commands
Date: Wed, 25 May 2011 15:24:11 -0500
Message-ID: <20110525202411.GO26570@beardog.cce.hp.com>
References: <20110525135035.GK26570@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g5t0009.atlanta.hp.com ([15.192.0.46]:22255 "EHLO
	g5t0009.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753931Ab1EYUYM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 May 2011 16:24:12 -0400
Received: from g5t0029.atlanta.hp.com (g5t0029.atlanta.hp.com [16.228.8.141])
	by g5t0009.atlanta.hp.com (Postfix) with ESMTP id EBBC730574
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 20:24:11 +0000 (UTC)
Received: from beardog.cce.hp.com (beardog.cce.hp.com [16.84.84.24])
	by g5t0029.atlanta.hp.com (Postfix) with ESMTP id D6A32200EA
	for <linux-scsi@vger.kernel.org>; Wed, 25 May 2011 20:24:11 +0000 (UTC)
Content-Disposition: inline
In-Reply-To: <20110525135035.GK26570@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: scameron@beardog.cce.hp.com

> Le 25 mai 2011 06:50,  <scameron@beardog.cce.hp.com> a =E9crit :
> > Or, maybe I should be reporting the CMD_ABORTED case back as
> >
> >        cmd->result =3D DID_SOFT_ERROR << 16;
>=20
> look at scsi_error.c:scsi_decide_disposition(). DID_SOFT_ERROR
> triggers retry handling while DID_ABORT does not (at least in the tre=
e
> that i'm looking at).
>=20

Yes this is what I was looking at, and part of what is confusing me.
This makes me think that DID_ABORT is the wrong thing to do, because=20
it would seem that there is no retry, and yet, dd does not complain
that one of the reads initiated on it's behalf has been aborted.
Does that mean it copied bogus data (uninitialized memory)?  Not sure,
but if so, that would be bad. (Easy enough to test this case.)

So this makes me wonder what DID_ABORT is intended to be used for,
and that I am using in a wrong way.

DID_SOFT_ERROR seems as you say like it will cause the command to be re=
tried.
However, if a command is aborted by the error handler at the mid-layer'=
s
request, is it up to the driver to tell the mid layer to retry the
command?  Seems like it would be up to the midlayer to know if it wante=
d
to retry the command or not..

Then there seems to be some sense key that means the command is aborted
(wondering if the firmware ought to be returning those instead of some
vendor specific way of reporting aborted commands as it seems to do now=
=2E)

Maybe the mid-layer is expecting a particular sense key back from a
command which it has aborted, and maybe I'm not setting that?

-- steve

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
