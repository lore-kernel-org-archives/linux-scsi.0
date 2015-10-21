From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in
 mvs_slot_task_free
Date: Wed, 21 Oct 2015 15:47:08 +0200
Message-ID: <1445435228.16404.15.camel@suse.de>
References: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
	 <CAOE4rSz=U+7WqiLz1fwyeBDkijkkfRPD=uY_twSVy9PWfDudww@mail.gmail.com>
	 <1445412826.16404.12.camel@suse.de>
	 <CAOE4rSx_UW-tDa+1PNBigbmnWJLDqF2B2bJ=_9hYH8ApXtXH4w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:58593 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753639AbbJUNrL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 Oct 2015 09:47:11 -0400
In-Reply-To: <CAOE4rSx_UW-tDa+1PNBigbmnWJLDqF2B2bJ=_9hYH8ApXtXH4w@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?Q?D=C4=81vis_Mos=C4=81ns?= <davispuh@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Wed, 2015-10-21 at 16:18 +0300, D=C4=81vis Mos=C4=81ns wrote:
> 2015-10-21 10:33 GMT+03:00 Johannes Thumshirn <jthumshirn@suse.de>:
> > On Tue, 2015-10-20 at 20:41 +0300, D=C4=81vis Mos=C4=81ns wrote:
> > > 2015-08-21 7:29 GMT+03:00 D=C4=81vis Mos=C4=81ns <davispuh@gmail.=
com>:
> > > > When pci_pool_alloc fails in mvs_task_prep then task->lldd_task
> > > > stays
> > > > NULL but it's later used in mvs_abort_task as slot which is
> > > > passed
> > > > to mvs_slot_task_free causing NULL pointer dereference.
> > > >=20
> > > > Just return from mvs_slot_task_free when passed with NULL slot.
> > > >=20
> > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
> > > > Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>
> > > > ---
> > > > =C2=A0drivers/scsi/mvsas/mv_sas.c | 2 ++
> > > > =C2=A01 file changed, 2 insertions(+)
> > > >=20
> > > > diff --git a/drivers/scsi/mvsas/mv_sas.c
> > > > b/drivers/scsi/mvsas/mv_sas.c
> > > > index 454536c..9c78074 100644
> > > > --- a/drivers/scsi/mvsas/mv_sas.c
> > > > +++ b/drivers/scsi/mvsas/mv_sas.c
> > > > @@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info
> > > > *mvi,
> > > > u32 rx_desc)
> > > > =C2=A0static void mvs_slot_task_free(struct mvs_info *mvi, stru=
ct
> > > > sas_task *task,
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0struct mvs_slot_info *slot, u32
> > > > slot_idx)
> > > > =C2=A0{
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!slot)
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!slot->task=
)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0return;
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (!sas_protoc=
ol_ata(task->task_proto))
> > > > --
> > > > 2.5.0
> > > >=20
> > >=20
> > > Can this get merged?
> > > So far since august it have saved me from several kernel crashes.
> >=20
> > If it saved you from several crashes, it probably should be tagged
> > for
> > stable, shouldn't it?
> >=20
> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
> >=20
> >=20
>=20
> I don't really know how that works... this is my first patch so I'm
> not really concerned about in which version it gets in as long as it
> does.
> I've been compiling kernel with this patch for these months so for me
> it
> doesn't really make any difference.

You can add
Cc: stable@vger.kernel.org
somewhere around your Signed-off-by=C2=A0

Documentation/stable_kernel_rules.txt has all the process
documentation.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
