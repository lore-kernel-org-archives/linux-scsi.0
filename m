From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: persistent reservation behaviour with dm-multipath
Date: Wed, 23 Jul 2008 23:09:44 +0200
Message-ID: <1216847384.9122.15.camel@plop>
References: <1216457992.7364.15.camel@plop>  <48879489.6060401@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from postfix1-g20.free.fr ([212.27.60.42]:43797 "EHLO
	postfix1-g20.free.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754586AbYGWVKq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 17:10:46 -0400
Received: from smtp7-g19.free.fr (smtp7-g19.free.fr [212.27.42.64])
	by postfix1-g20.free.fr (Postfix) with ESMTP id 5C7AD2890589
	for <linux-scsi@vger.kernel.org>; Wed, 23 Jul 2008 23:10:45 +0200 (CEST)
In-Reply-To: <48879489.6060401@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org

Le mercredi 23 juillet 2008 =C3=A0 16:28 -0400, Douglas Gilbert a =C3=A9=
crit :
> Christophe Varoqui wrote:
> > The current dm-multipath behaviour is currently a potent data corru=
pter
> > on Persistant Reservation-based clusters sharing multipaths with th=
e
> > queue_if_no_path feature on (Clariion, Storageworks, ...).
> >=20
> > Consider the following scenario :
> >=20
> > - Node A take a write-exclusive persistent reservation on LU
> > - Node B submits a write io to LU, which is a sda-sdb multipath
> > =EF=BB=BF- B dm_multipath routes the wio to sda, the wio is failed,=
 the path is
> > marked failed
> > =EF=BB=BF- B dm_multipath routes the wio to sdb, the wio is failed,=
 the last
> > path is marked failed
> > - B queues the wio because of the queue_if_no_path feature. Process
> > submitting the wio is stuck in D-state.
> > - A releases the reservation. Queued wios are unqueued, corrupting =
the
> > data on LU.
> >=20
> > I suspect wio returning a "reservation conflict" status should neve=
r be
> > queued.
> >=20
> > DM suspend/resume on the multipath devmap effectively flushes the q=
ueue,
> > but this solution leaves a window open for data corruption, between=
 io
> > enqueue and user-space driven queue flush.
> >=20
> > Is there work in progress to address this issue yet ? What's would =
be an
> > acceptable solution design (for example Mike Christie suggested in =
Aug
> > 2005 a scsi-to-blk error translation patch, which got nowhere) ?
> y of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>=20
> If memory serves, a SCSI command status of RESERVATION
> CONFLICT did not find its way back to the sg driver API
> (and/or the command was retried). Is that still the case?
>=20
As far as I can tell, the scsi subsystem alone behaves as expected : a
wio on a reserved-by-other scsi device gets errored nicely : no retry, =
a
clean message indicating the wio error cause in the dmesg.

The device-mapper multipath target, on the other hand, can be configure=
d
to queue ios errored by the scsi layer. Which is a desirable behaviour
when we know we face a transcient all-paths-down situation (like a LU
tresspass on a Clariion controller pair), but which is not so smart we
the io was errored due to a reservation conflict.

The problem here is how the scsi layer can instruct the multipath dm
driver not to queue an errored io. This is what Mike's patch tied to
address.

Regards,
cvaroqui

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
