From: Chetan Loke <chetanloke@gmail.com>
Subject: Re: [PATCH] libfc: fix stats computation in fc_queuecommand()
Date: Tue, 26 Oct 2010 11:02:17 -0400
Message-ID: <AANLkTimVZpakuwjAk0BJFhxtfZ5+Koard6=DE7LXVr6g@mail.gmail.com>
References: <AANLkTimz_LBaPPJ_irEjiBy+f_MPCYYbLvD=oEw=JT-c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34699 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757699Ab0JZPCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Oct 2010 11:02:24 -0400
Received: by yxn35 with SMTP id 35so2921106yxn.19
        for <linux-scsi@vger.kernel.org>; Tue, 26 Oct 2010 08:02:23 -0700 (PDT)
In-Reply-To: <AANLkTimz_LBaPPJ_irEjiBy+f_MPCYYbLvD=oEw=JT-c@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hillf Danton <dhillf@gmail.com>
Cc: devel@open-fcoe.org, linux-scsi@vger.kernel.org

On Tue, Oct 26, 2010 at 9:01 AM, Hillf Danton <dhillf@gmail.com> wrote:
> There seems accumulation needed.

I'm looking at the code but why increment in queue-command. What if
the cmd-fails then
we would need to decrement the counters. If not done already then
fc_io_cmpl would be
a nice place to handle the counters.

Chetan Loke


> ---
>
> --- a/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-09-13 07:=
07:38.000000000 +0800
> +++ b/drivers/scsi/libfc/fc_fcp.c =C2=A0 =C2=A0 =C2=A0 2010-10-26 20:=
52:46.000000000 +0800
> @@ -1821,11 +1821,11 @@ int fc_queuecommand(struct scsi_cmnd *sc
> =C2=A0 =C2=A0 =C2=A0 =C2=A0if (sc_cmd->sc_data_direction =3D=3D DMA_F=
ROM_DEVICE) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flags=
 =3D FC_SRB_READ;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->InputRe=
quests++;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->InputMegaby=
tes =3D fsp->data_len;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->InputMegaby=
tes +=3D fsp->data_len;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else if (sc_cmd->sc_data_direction =3D=3D=
 DMA_TO_DEVICE) {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flags=
 =3D FC_SRB_WRITE;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->OutputR=
equests++;
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->OutputMegab=
ytes =3D fsp->data_len;
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 stats->OutputMegab=
ytes +=3D fsp->data_len;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0} else {
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0fsp->req_flags=
 =3D 0;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0stats->Control=
Requests++;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
