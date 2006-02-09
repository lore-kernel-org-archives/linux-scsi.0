From: =?iso-8859-1?b?RW1tYW51ZWwgRnVzdMOp?= <emmanuel.fuste@laposte.net>
Subject: Re:[RFC][PATCH 1/1] aic7xxx: Remove the platform_data->qfrozen logic
Date: Thu,  9 Feb 2006 11:09:04 +0100
Message-ID: <IUF074$61354B6993A3C8337BCD6420985787FB@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx.laposte.net ([81.255.54.11]:26182 "EHLO mx.laposte.net")
	by vger.kernel.org with ESMTP id S1422747AbWBIKKL convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Feb 2006 05:10:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare <hare@suse.de>, hch <hch@infradead.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

> hello,
>=20
> Since we no longuer do internal queuing, we push the lock
> inside ahc_linux_run_command and completly remove the bursted
> internal queue freezing machinery.
> Based on Hannes Reinecke patch for aic79xxx and Christoph
> Hellwig comments.
>=20
> Signed-off-by: Emmanuel Fuste <emmanuel.fuste@laposte.net>
>=20
> ---=20
>=20
>  aic7xxx_osm.c |   82
> ++++++++++++----------------------------------------------
>  aic7xxx_osm.h |    1
>  2 files changed, 17 insertions(+), 66 deletions(-)
>=20
Ok,

Kernel booted and works.
cdrwtool -d /dev/sr0 -q still freeze the kernel after some time.
Will try with "scsi_deactivate_tcq(sdev, 2);".
It seems that there is some adherence between this and the
recovery code.
The recovery code success, but nothing was recovered in
reality -> freeze.
With a queue depth of 2, my hard disk continue to be serviced.
It only my view of the pblm, and I could be (surely) wrong.
It is only part of the problem since the driver receive a
command that crash the driver/the sequencer but one thing at
time... it coild be view as a good stress test for the
recovery code ;-).

If you want traces/logs/etc... tell me.

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
