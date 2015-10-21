From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in mvs_slot_task_free
Date: Wed, 21 Oct 2015 16:18:35 +0300
Message-ID: <CAOE4rSx_UW-tDa+1PNBigbmnWJLDqF2B2bJ=_9hYH8ApXtXH4w@mail.gmail.com>
References: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
	<CAOE4rSz=U+7WqiLz1fwyeBDkijkkfRPD=uY_twSVy9PWfDudww@mail.gmail.com>
	<1445412826.16404.12.camel@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f182.google.com ([209.85.220.182]:36484 "EHLO
	mail-qk0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750698AbbJUNSg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2015 09:18:36 -0400
In-Reply-To: <1445412826.16404.12.camel@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

2015-10-21 10:33 GMT+03:00 Johannes Thumshirn <jthumshirn@suse.de>:
> On Tue, 2015-10-20 at 20:41 +0300, D=C4=81vis Mos=C4=81ns wrote:
>> 2015-08-21 7:29 GMT+03:00 D=C4=81vis Mos=C4=81ns <davispuh@gmail.com=
>:
>> > When pci_pool_alloc fails in mvs_task_prep then task->lldd_task
>> > stays
>> > NULL but it's later used in mvs_abort_task as slot which is passed
>> > to mvs_slot_task_free causing NULL pointer dereference.
>> >
>> > Just return from mvs_slot_task_free when passed with NULL slot.
>> >
>> > Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
>> > Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>
>> > ---
>> >  drivers/scsi/mvsas/mv_sas.c | 2 ++
>> >  1 file changed, 2 insertions(+)
>> >
>> > diff --git a/drivers/scsi/mvsas/mv_sas.c
>> > b/drivers/scsi/mvsas/mv_sas.c
>> > index 454536c..9c78074 100644
>> > --- a/drivers/scsi/mvsas/mv_sas.c
>> > +++ b/drivers/scsi/mvsas/mv_sas.c
>> > @@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info *mvi=
,
>> > u32 rx_desc)
>> >  static void mvs_slot_task_free(struct mvs_info *mvi, struct
>> > sas_task *task,
>> >                           struct mvs_slot_info *slot, u32 slot_idx=
)
>> >  {
>> > +       if (!slot)
>> > +               return;
>> >         if (!slot->task)
>> >                 return;
>> >         if (!sas_protocol_ata(task->task_proto))
>> > --
>> > 2.5.0
>> >
>>
>> Can this get merged?
>> So far since august it have saved me from several kernel crashes.
>
> If it saved you from several crashes, it probably should be tagged fo=
r
> stable, shouldn't it?
>
> Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
>
>

I don't really know how that works... this is my first patch so I'm
not really concerned about in which version it gets in as long as it do=
es.
I've been compiling kernel with this patch for these months so for me i=
t
doesn't really make any difference.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
