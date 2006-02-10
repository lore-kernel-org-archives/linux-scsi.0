From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re:[RFC][PATCH 1/1] aic7xxx: Remove the platform_data->qfrozen logic
Date: Fri, 10 Feb 2006 10:06:25 +0100
Message-ID: <IUGRYP$4A5D04F1872FBE3D35800396C0568C0F@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:20110 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1751201AbWBJJHj convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 10 Feb 2006 04:07:39 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hch <hch@infradead.org>
Cc: hare <hare@suse.de>, linux-scsi <linux-scsi@vger.kernel.org>

> > hello,
> >=20
> > Since we no longuer do internal queuing, we push the lock
> > inside ahc_linux_run_command and completly remove the bursted
> > internal queue freezing machinery.
> > Based on Hannes Reinecke patch for aic79xxx and Christoph
> > Hellwig comments.
> >=20
> > Signed-off-by: Emmanuel Fuste <emmanuel.fuste@laposte.net>
> >=20
> > ---=20
> >=20
> >  aic7xxx_osm.c |   82
> > ++++++++++++----------------------------------------------
> >  aic7xxx_osm.h |    1
> >  2 files changed, 17 insertions(+), 66 deletions(-)
> >=20
> Ok,
>=20
> Kernel booted and works.
> cdrwtool -d /dev/sr0 -q still freeze the kernel after some time.
> Will try with "scsi_deactivate_tcq(sdev, 2);".
> It seems that there is some adherence between this and the
> recovery code.
> The recovery code success, but nothing was recovered in
> reality -> freeze.
> With a queue depth of 2, my hard disk continue to be serviced.
> It only my view of the pblm, and I could be (surely) wrong.
> It is only part of the problem since the driver receive a
> command that crash the driver/the sequencer but one thing at
> time... it could be view as a good stress test for the
> recovery code ;-).
>=20
> If you want traces/logs/etc... tell me.
Ok, more on this:

I was wrong, the freeze is not caused by
"scsi_deactivate_tcq(sdev, 1);".
In fact, I've got the freeze since the second version of your
"semaphore to completion conversion" patch. I should not do
more than one thing at time ggrrrrrrhhhh.

I will retry with your previous patch.

It will be:
2.6.15=20
+ James Bottomley "aic7xxx timer handling bug" fix=20
+ "Turn off ordered flush barriers for SCSI driver"=20
+ "semaphore to completion conversion V1" from your
+ "scsi_deactivate_tcq(sdev, 1);"
+ "Remove the platform_data->qfrozen logic"

Results monday evening.

Regards,
Emmanuel.
---

Acc=E9dez au courrier =E9lectronique de La Poste : www.laposte.net ;=20
3615 LAPOSTENET (0,34 =80/mn) ; t=E9l : 08 92 68 13 50 (0,34=80/mn)



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
