From: Christophe Varoqui <christophe.varoqui@free.fr>
Subject: Re: [dm-devel] Read-Only devices, multipath and more
Date: Tue, 20 May 2008 23:09:49 +0200
Message-ID: <1211317789.31536.9.camel@plop>
References: <1210966544.12901.51.camel@plop>
	 <20080520144807.GC10723@agk.fab.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp7-g19.free.fr ([212.27.42.64]:39072 "EHLO smtp7-g19.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758895AbYETVJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 May 2008 17:09:36 -0400
In-Reply-To: <20080520144807.GC10723@agk.fab.redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alasdair G Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org

Le mardi 20 mai 2008 =C3=A0 15:48 +0100, Alasdair G Kergon a =C3=A9crit=
 :
> On Fri, May 16, 2008 at 09:35:44PM +0200, christophe varoqui wrote:
> > fact: device-mapper refuse to load a RW multipath table on these pa=
ths
> > (ie without libdevmapper:set_task_set_ro())
> > question: should change this behaviour to allow to load a RW multip=
ath
> > table on these paths and let the IO be failed by the storage hardwa=
re ?
>=20
> Yes.  But relax this *only* for multipath targets, where the whole id=
ea
> is to "hide" path problems from the layer above.
=EF=BB=BF
=46air enough.

> It would not make sense=20
> in my view to do this for other DM targets.
> =20

During my testing I remember seeing a RW linear map loaded over a RO
multipath map (through a genuine vgchange -ay, the PV being the
multipath).

> > Alasdair proposed to add more explicit table loading ioctl return c=
ode
> > when the failure is due to this ready-only paths issue (E_ROFS for
> > example).
>=20
> I think this should be done too (for non-multipath and other errors).
>=20
Right, I'm about the publish a changeset for supporting the whole RO
notion in the multipath-tools :
1/ printing the RO/RW information
2/ fallbacking to RO when RW loading fails
3/ new flag to force map reloading, which takes care of the RO->RW
promotion and RW->RO demotion scenarii

I'll adapt 2/ to your new return codes when available.


Thanks for caring,
cvaroqui

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
