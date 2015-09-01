From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: Re: [PATCH] SCSI: mvsas: Fix NULL pointer dereference in mvs_slot_task_free
Date: Tue, 1 Sep 2015 23:08:25 +0300
Message-ID: <CAOE4rSwWQJ=-CxMic66+q-vuOwPWEYQR5S6p1FxkBccNPRaeuQ@mail.gmail.com>
References: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qg0-f53.google.com ([209.85.192.53]:36632 "EHLO
	mail-qg0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750969AbbIAUI0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Sep 2015 16:08:26 -0400
Received: by qgx61 with SMTP id 61so5137115qgx.3
        for <linux-scsi@vger.kernel.org>; Tue, 01 Sep 2015 13:08:25 -0700 (PDT)
In-Reply-To: <1440131362-18605-1-git-send-email-davispuh@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "James E.J. Bottomley" <JBottomley@odin.com>, linux-scsi@vger.kernel.org
Cc: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>

2015-08-21 7:29 GMT+03:00 D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>:
> When pci_pool_alloc fails in mvs_task_prep then task->lldd_task stays
> NULL but it's later used in mvs_abort_task as slot which is passed
> to mvs_slot_task_free causing NULL pointer dereference.
>
> Just return from mvs_slot_task_free when passed with NULL slot.
>
> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D101891
> Signed-off-by: D=C4=81vis Mos=C4=81ns <davispuh@gmail.com>
> ---
>  drivers/scsi/mvsas/mv_sas.c | 2 ++
>  1 file changed, 2 insertions(+)
>
> diff --git a/drivers/scsi/mvsas/mv_sas.c b/drivers/scsi/mvsas/mv_sas.=
c
> index 454536c..9c78074 100644
> --- a/drivers/scsi/mvsas/mv_sas.c
> +++ b/drivers/scsi/mvsas/mv_sas.c
> @@ -887,6 +887,8 @@ static void mvs_slot_free(struct mvs_info *mvi, u=
32 rx_desc)
>  static void mvs_slot_task_free(struct mvs_info *mvi, struct sas_task=
 *task,
>                           struct mvs_slot_info *slot, u32 slot_idx)
>  {
> +       if (!slot)
> +               return;
>         if (!slot->task)
>                 return;
>         if (!sas_protocol_ata(task->task_proto))
> --
> 2.5.0
>

ping? do I need to CC someone else?
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
