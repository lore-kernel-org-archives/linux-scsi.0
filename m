From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: Kernel panic - Ththththaats all folks
Date: Fri, 5 Sep 2003 22:47:16 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF731BEB2B.7C214673-ONC1256D98.006F5ECF-C1256D98.00728EE1@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from d12lmsgate-4.de.ibm.com ([194.196.100.237]:55780 "EHLO
	d12lmsgate.de.ibm.com") by vger.kernel.org with ESMTP
	id S263088AbTIEUrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Sep 2003 16:47:15 -0400
List-Id: linux-scsi@vger.kernel.org
To: Sulamita Garcia <sulagarcia@yahoo.com.br>
Cc: linux-scsi@vger.kernel.org


We have also seen that panic sporadically with the zfcp lldd
on zSeries. We tracked it down as a situation when a data buffer
is only partially transferred and the request is being requeued
to retrieve the remaining data. Then segment counting needs to
be done before adding a request to the block layer queue again.
The following patch moves segment recounting.
Could you give it a try?

regards,
Martin


--- scsi_lib.c  26 Oct 2001 18:00:38 -0000      1.13
+++ scsi_lib.c  17 Apr 2002 15:58:05 -0000      1.14
@@ -262,6 +262,15 @@
                 * the bad sector.
                 */
                SCpnt->request.special =3D (void *) SCpnt;
+                /*
+                 * We need to recount the number of
+                 * scatter-gather segments here - the
+                 * normal case code assumes this to be
+                 * correct, as it would be a performance
+                 * loss to always recount.  Handling
+                 * errors is always unusual, of course.
+                 */
+                recount_segments(SCpnt);
                list_add(&SCpnt->request.queue, &q->queue_head);
        }

@@ -968,15 +977,6 @@
                         */
                        if( req->special !=3D NULL ) {
                                SCpnt =3D (Scsi_Cmnd *) req->special;
-                               /*
-                                * We need to recount the number of
-                                * scatter-gather segments here - the
-                                * normal case code assumes this to be
-                                * correct, as it would be a performanc=
e
-                                * lose to always recount.  Handling
-                                * errors is always unusual, of course.
-                                */
-                               recount_segments(SCpnt);
                        } else {
                                SCpnt =3D scsi_allocate_device(SDpnt, F=
ALSE,
=46ALSE);
                        }



Sulamita Garcia <sulagarcia@yahoo.com.br>@vger.kernel.org on 05/09/2003
11:01:00

Sent by:    linux-scsi-owner@vger.kernel.org


To:    linux-scsi@vger.kernel.org
cc:
Subject:    Kernel panic - Ththththaats all folks


Hi

I have a RocketRAID 404 (HPT374) controller adapter on
a RedHat 9.0 box. I compiled a new fresh kernel
2.4.22, because errors I get with 2.4.20 from
instalation default, and rebuild module from source
because kernel module didn't work. Now I have a Raid 0
by hardware, which is a 800Gb partition. I formated
this as ext3, and for while, was good.
But I doing this for a high availabity cluster, with
drbd (mirroring). And I can't sync machines, I get
this kernel panic:

Incorrect number of segments after building list
nr_segments is 10
counted segments is 1
=46lags 0 0
Kernel Panic: Ththththaats all folks. To dangerous to
continue
In interrupt handler - not syncing.

I found this message in scsi_merge, and I don't know
that did it mean. It's kernel problem, scsi problem,
chipset problem, or what?

Thanks

Sulamita Garcia


_______________________________________________________________________
Desafio AntiZona: participe do jogo de perguntas e respostas que vai
dar um Renault Clio, computadores, c=E2meras digitais, videogames e mui=
to
mais! www.cade.com.br/antizona
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html




-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
