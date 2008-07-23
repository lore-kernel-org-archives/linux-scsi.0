From: Douglas Gilbert <dougg@torque.net>
Subject: Re: persistent reservation behaviour with dm-multipath
Date: Wed, 23 Jul 2008 16:28:57 -0400
Message-ID: <48879489.6060401@torque.net>
References: <1216457992.7364.15.camel@plop>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:54383 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755461AbYGWU3H (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jul 2008 16:29:07 -0400
In-Reply-To: <1216457992.7364.15.camel@plop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christophe Varoqui <christophe.varoqui@free.fr>
Cc: linux-scsi@vger.kernel.org

Christophe Varoqui wrote:
> The current dm-multipath behaviour is currently a potent data corrupt=
er
> on Persistant Reservation-based clusters sharing multipaths with the
> queue_if_no_path feature on (Clariion, Storageworks, ...).
>=20
> Consider the following scenario :
>=20
> - Node A take a write-exclusive persistent reservation on LU
> - Node B submits a write io to LU, which is a sda-sdb multipath
> =EF=BB=BF- B dm_multipath routes the wio to sda, the wio is failed, t=
he path is
> marked failed
> =EF=BB=BF- B dm_multipath routes the wio to sdb, the wio is failed, t=
he last
> path is marked failed
> - B queues the wio because of the queue_if_no_path feature. Process
> submitting the wio is stuck in D-state.
> - A releases the reservation. Queued wios are unqueued, corrupting th=
e
> data on LU.
>=20
> I suspect wio returning a "reservation conflict" status should never =
be
> queued.
>=20
> DM suspend/resume on the multipath devmap effectively flushes the que=
ue,
> but this solution leaves a window open for data corruption, between i=
o
> enqueue and user-space driven queue flush.
>=20
> Is there work in progress to address this issue yet ? What's would be=
 an
> acceptable solution design (for example Mike Christie suggested in Au=
g
> 2005 a scsi-to-blk error translation patch, which got nowhere) ?
y of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

If memory serves, a SCSI command status of RESERVATION
CONFLICT did not find its way back to the sg driver API
(and/or the command was retried). Is that still the case?

Doug Gilbert

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
