From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Burning multiple DVDs at one time
Date: Sat, 17 Mar 2012 13:47:56 +0100
Message-ID: <20120317134756.7a9ea99c@stein>
References: <20120315225310.GB3152@animx.eu.org>
	<20120317095644.145d0588@stein>
	<20120317115324.10b39bb7@galadriel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:56552 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752061Ab2CQMsb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Mar 2012 08:48:31 -0400
In-Reply-To: <20120317115324.10b39bb7@galadriel.home>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Emmanuel Florac <eflorac@intellique.com>
Cc: Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Mar 17 Emmanuel Florac wrote:
> Le Sat, 17 Mar 2012 09:56:44 +0100 vous =C3=A9criviez:
>=20
> > This is likely due to serialization by a global mutex in the sr
> > driver. Have a look at thread "[PATCH] [SCSI] sr: fix multi-drive
> > performance, remove BKL replacement" from February.
> > https://lkml.org/lkml/2012/2/28/230=20
>=20
> When was this regression introduced? I have a dedicated cd burning
> machine running 2.6.35.x, and it works great with 4 drives at a time.

BKL was replaced by sr_mutex in 2.6.37-rc1.

Wakko, you could try the patch from the mentioned thread and see whethe=
r
it fixes your problem.  But be aware that the patch opens possible race
conditions between processes that access the same optical drive, e.g.
applications vs. udisks-daemon.  (I haven't noticed anything bad during=
 the
period of using the patch though.)
--=20
Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D=3D-- --=3D=3D =3D---=3D
http://arcgraph.de/sr/
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
