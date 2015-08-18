From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 101891] mvsas prep failed, NULL pointer dereference in
 mvs_slot_task_free+0x5/0x1f0 [mvsas]
Date: Tue, 18 Aug 2015 14:54:28 +0000
Message-ID: <bug-101891-11613-HmXHzyE99A@https.bugzilla.kernel.org/>
References: <bug-101891-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:34632 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750893AbbHROyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Aug 2015 10:54:33 -0400
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CE0692054C
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 14:54:31 +0000 (UTC)
Received: from bugzilla1.web.kernel.org (bugzilla1.web.kernel.org [172.20.200.51])
	by mail.kernel.org (Postfix) with ESMTP id A2CF1205DF
	for <linux-scsi@vger.kernel.org>; Tue, 18 Aug 2015 14:54:28 +0000 (UTC)
In-Reply-To: <bug-101891-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=3D101891

--- Comment #4 from D=C4=81vis <davispuh@gmail.com> ---
(In reply to D=C4=81vis from comment #3)
> I narrowed it down to this section of mvs_abort_task function
> (drivers/scsi/mvsas/mv_sas.c)
>=20
> 	} else if (task->task_proto & SAS_PROTOCOL_SATA ||
> 		task->task_proto & SAS_PROTOCOL_STP) {
> 		if (SAS_SATA_DEV =3D=3D dev->dev_type) {
> 			struct mvs_slot_info *slot =3D task->lldd_task;
> 			u32 slot_idx =3D (u32)(slot - mvi->slot_info);
> 			mv_dprintk("mvs_abort_task() mvi=3D%p task=3D%p "
> 				   "slot=3D%p slot_idx=3Dx%x\n",
> 				   mvi, task, slot, slot_idx);
> 			task->task_state_flags |=3D SAS_TASK_STATE_ABORTED;
> 			mvs_slot_task_free(mvi, task, slot, slot_idx);
> 			rc =3D TMF_RESP_FUNC_COMPLETE;
> 			goto out;
> 		}
>=20
> 	}
>=20
>=20
> Basically this line "u32 slot_idx =3D (u32)(slot - mvi->slot_info)".
> I think (slot - mvi->slot_info) returns 0x10 and that's why
> (there's no "mvs_abort_task()" in journal so it crashes before that.
>=20

Sorry for being idiot, that line doesn't cause any pointer
dereference and neither does previous line. It's just so obvious,
compiler reordered instructions so that mvs_slot_task_free is executed
before mv_dprintk is called and that's why it's not in journal.
Even as title I wrote NULL pointer dereference in mvs_slot_task_free
and that's exactly where had to look.

So anyway when in mvs_task_prep and if pci_pool_alloc fails then
task->lldd_task is NULL as can see

    task->lldd_task =3D NULL;
    slot->n_elem =3D n_elem;
    slot->slot_tag =3D tag;

    slot->buf =3D pci_pool_alloc(mvi->dma_pool, GFP_ATOMIC, &slot->buf_=
dma);
    if (!slot->buf)
        goto err_out_tag;

then later it's aborted with mvs_abort_task and there mvs_slot_task_fre=
e
is called with (slot =3D task->lldd_task) which is NULL and in
mvs_slot_task_free
{
    if (!slot->task)
        return;

happens this NULL pointer dereference because slot is NULL.

There's 2 ways to fix this, either check if slot is NULL before calling=
=20
mvs_slot_task_free or just inside it check it.

I went for second option as it seems easier and won't have to always
check before calling.

Here's a patch, haven't tested it yet but I think it will fix this
and it's compiling right now so I'll let know once I'll have tested it.

diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.c
index 454536c..9c78074 100644
--- a/drivers/scsi/mvsas/mv_sas.c
+++ b/drivers/scsi/mvsas/mv_sas.c
@@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info *mvi, u32
rx_desc)
 static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task *=
task,
                          struct mvs_slot_info *slot, u32 slot_idx)
 {
+       if (!slot)
+               return;
        if (!slot->task)
                return;
        if (!sas_protocol_ata(task->task_proto))

--=20
You are receiving this mail because:
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
