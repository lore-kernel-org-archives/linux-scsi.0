From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in mvs_slot_task_free
Date: Wed, 21 Oct 2015 17:26:01 +0300
Message-ID: <CAOE4rSznxS7h4vqY2THG7Mfv0QU9gRoiyMjd5B51sakYBvyT0g@mail.gmail.com>
References: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
	<CAOE4rSz=U+7WqiLz1fwyeBDkijkkfRPD=uY_twSVy9PWfDudww@mail.gmail.com>
	<1445412826.16404.12.camel@suse.de>
	<CAOE4rSx_UW-tDa+1PNBigbmnWJLDqF2B2bJ=_9hYH8ApXtXH4w@mail.gmail.com>
	<1445435228.16404.15.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445435228.16404.15.camel@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

2015-10-21 16:47 GMT+03:00 Johannes Thumshirn <jthumshirn@suse.de>:
> On Wed, 2015-10-21 at 16:18 +0300, D=C4=81vis Mos=C4=81ns wrote:
>> 2015-10-21 10:33 GMT+03:00 Johannes Thumshirn <jthumshirn@suse.de>:
>> > On Tue, 2015-10-20 at 20:41 +0300, D=C4=81vis Mos=C4=81ns wrote:
>> > > 2015-08-21 7:29 GMT+03:00 D=C4=81vis Mos=C4=81ns <davispuh@gmail=
=2Ecom>:
>> > > > When pci_pool_alloc fails in mvs_task_prep then task->lldd_tas=
k
>> > > > stays
>> > > > NULL but it's later used in mvs_abort_task as slot which is
>> > > > passed
>> > > > to mvs_slot_task_free causing NULL pointer dereference.
>> > > >
>> > > > Just return from mvs_slot_task_free when passed with NULL slot=
=2E
>> > > >
>> > > > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
>> > > > Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>
>> > > > ---
>> > > >  drivers/scsi/mvsas/mv_sas.c | 2 ++
>> > > >  1 file changed, 2 insertions(+)
>> > > >
>> > > > diff --git a/drivers/scsi/mvsas/mv_sas.c
>> > > > b/drivers/scsi/mvsas/mv_sas.c
>> > > > index 454536c..9c78074 100644
>> > > > --- a/drivers/scsi/mvsas/mv_sas.c
>> > > > +++ b/drivers/scsi/mvsas/mv_sas.c
>> > > > @@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info
>> > > > *mvi,
>> > > > u32 rx_desc)
>> > > >  static void mvs_slot_task_free(struct mvs_info *mvi, struct
>> > > > sas_task *task,
>> > > >                           struct mvs_slot_info *slot, u32
>> > > > slot_idx)
>> > > >  {
>> > > > +       if (!slot)
>> > > > +               return;
>> > > >         if (!slot->task)
>> > > >                 return;
>> > > >         if (!sas_protocol_ata(task->task_proto))
>> > > > --
>> > > > 2.5.0
>> > > >
>> > >
>> > > Can this get merged?
>> > > So far since august it have saved me from several kernel crashes=
=2E
>> >
>> > If it saved you from several crashes, it probably should be tagged
>> > for
>> > stable, shouldn't it?
>> >
>> > Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>> >
>> >
>>
>> I don't really know how that works... this is my first patch so I'm
>> not really concerned about in which version it gets in as long as it
>> does.
>> I've been compiling kernel with this patch for these months so for m=
e
>> it
>> doesn't really make any difference.
>
> You can add
> Cc: stable@vger.kernel.org
> somewhere around your Signed-off-by
>
> Documentation/stable_kernel_rules.txt has all the process
> documentation.

Should I add it together with review tags too and resend patch or reply=
 to this
thread with it edited or just leave it like it is now and whoever will =
see it
will add it himself?


also for stable requirements this line is a bit confusing
"It or an equivalent fix must already exist in Linus' tree (upstream)."

but then later seems it's not requirement for Option 1
