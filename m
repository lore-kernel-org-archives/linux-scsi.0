Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4150C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C863C21928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JzvUw4Hc"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389573AbfKEPSc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:18:32 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:44325 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389339AbfKEPSc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:18:32 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967110;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iWZtHQXZBwv4u36Vs9XmIOj90srP2OhCbN5pKPYBa48=;
        b=JzvUw4HcTuJiIa+ZwE/Ry+L5DeSfINVpAwH1YmcRTezMhN5Ueq8jJJtS23tqbm6WZ8dWDY
        D0nrC09lpPWBvA8Unhw9KxgA/kDd6QUyy9+eT5HrNBOpwKuLqBt6ewqQh3jp9nlZIKGZGT
        oF1TvCFiKJVzWgwiLfAZgOEinpL/XTU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-38-6-8BbmWdOBSA9Yx-txTn_w-1; Tue, 05 Nov 2019 10:18:27 -0500
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0DCBC1800D4A;
        Tue,  5 Nov 2019 15:18:26 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 707F8608B4;
        Tue,  5 Nov 2019 15:18:25 +0000 (UTC)
Message-ID: <b527c8cf1f90b606ed83881ab62560f09bc97f9b.camel@redhat.com>
Subject: Re: [PATCH 1/8] qla2xxx: Retry PLOGI on FC-NVMe PRLI failure
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:18:24 -0500
In-Reply-To: <20191105150657.8092-2-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-2-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-MC-Unique: 6-8BbmWdOBSA9Yx-txTn_w-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-05 at 07:06 -0800, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
>=20
> Current code will send PRLI with FC-NVMe bit set for the
> targets which supports only FCP. This may result into issue
> with targets which do not understand NVMe and will go into
> strange state. This patch would restart the login process
> by going back to PLOGI state. The PLOGI state will force the
> target to respond to correct PRLI request.
>=20
> Fixes: c76ae845ea836 ("scsi: qla2xxx: Add error handling for PLOGI ELS pa=
ssthrough")
> Cc: stable@vger.kernel.org # 5.4
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 37 ++++++++---------------------------=
--
>  drivers/scsi/qla2xxx/qla_iocb.c |  6 +++++-
>  2 files changed, 13 insertions(+), 30 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 7cb7545de962..5db8ad832893 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1864,42 +1864,21 @@ qla24xx_handle_prli_done_event(struct scsi_qla_ho=
st *vha, struct event_arg *ea)
>  =09=09 * FCP/NVMe port
>  =09=09 */
>  =09=09if (NVME_FCP_TARGET(ea->fcport)) {
> -=09=09=09if (vha->hw->fc4_type_priority =3D=3D FC4_PRIORITY_NVME)
> -=09=09=09=09ea->fcport->fc4_type &=3D ~FS_FC4TYPE_NVME;
> -=09=09=09else
> -=09=09=09=09ea->fcport->fc4_type &=3D ~FS_FC4TYPE_FCP;
>  =09=09=09ql_dbg(ql_dbg_disc, vha, 0x2118,
>  =09=09=09=09"%s %d %8phC post %s prli\n",
>  =09=09=09=09__func__, __LINE__, ea->fcport->port_name,
>  =09=09=09=09(ea->fcport->fc4_type & FS_FC4TYPE_NVME) ?
>  =09=09=09=09"NVMe" : "FCP");
> -=09=09=09qla24xx_post_prli_work(vha, ea->fcport);
> -=09=09=09break;
> +=09=09=09if (vha->hw->fc4_type_priority =3D=3D FC4_PRIORITY_NVME)
> +=09=09=09=09ea->fcport->fc4_type &=3D ~FS_FC4TYPE_NVME;
> +=09=09=09else
> +=09=09=09=09ea->fcport->fc4_type &=3D ~FS_FC4TYPE_FCP;
>  =09=09}
> =20
> -=09=09/* at this point both PRLI NVME & PRLI FCP failed */
> -=09=09if (N2N_TOPO(vha->hw)) {
> -=09=09=09if (ea->fcport->n2n_link_reset_cnt < 3) {
> -=09=09=09=09ea->fcport->n2n_link_reset_cnt++;
> -=09=09=09=09/*
> -=09=09=09=09 * remote port is not sending Plogi. Reset
> -=09=09=09=09 * link to kick start his state machine
> -=09=09=09=09 */
> -=09=09=09=09set_bit(N2N_LINK_RESET, &vha->dpc_flags);
> -=09=09=09} else {
> -=09=09=09=09ql_log(ql_log_warn, vha, 0x2119,
> -=09=09=09=09    "%s %d %8phC Unable to reconnect\n",
> -=09=09=09=09    __func__, __LINE__, ea->fcport->port_name);
> -=09=09=09}
> -=09=09} else {
> -=09=09=09/*
> -=09=09=09 * switch connect. login failed. Take connection
> -=09=09=09 * down and allow relogin to retrigger
> -=09=09=09 */
> -=09=09=09ea->fcport->flags &=3D ~FCF_ASYNC_SENT;
> -=09=09=09ea->fcport->keep_nport_handle =3D 0;
> -=09=09=09qlt_schedule_sess_for_deletion(ea->fcport);
> -=09=09}
> +=09=09ea->fcport->flags &=3D ~FCF_ASYNC_SENT;
> +=09=09ea->fcport->keep_nport_handle =3D 0;
> +=09=09ea->fcport->logout_on_delete =3D 1;
> +=09=09qlt_schedule_sess_for_deletion(ea->fcport);
>  =09=09break;
>  =09}
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index eeb526411536..2b675da34bda 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2764,6 +2764,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
>  =09=09=09ea.sp =3D sp;
>  =09=09=09qla24xx_handle_plogi_done_event(vha, &ea);
>  =09=09=09break;
> +
>  =09=09case CS_IOCB_ERROR:
>  =09=09=09switch (fw_status[1]) {
>  =09=09=09case LSC_SCODE_PORTID_USED:
> @@ -2834,6 +2835,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
>  =09=09=09=09    fw_status[0], fw_status[1], fw_status[2]);
> =20
>  =09=09=09=09fcport->flags &=3D ~FCF_ASYNC_SENT;
> +=09=09=09=09fcport->disc_state =3D DSC_LOGIN_FAILED;
>  =09=09=09=09set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  =09=09=09=09break;
>  =09=09=09}
> @@ -2846,6 +2848,7 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
>  =09=09=09    fw_status[0], fw_status[1], fw_status[2]);
> =20
>  =09=09=09sp->fcport->flags &=3D ~FCF_ASYNC_SENT;
> +=09=09=09sp->fcport->disc_state =3D DSC_LOGIN_FAILED;
>  =09=09=09set_bit(RELOGIN_NEEDED, &vha->dpc_flags);
>  =09=09=09break;
>  =09=09}
> @@ -2881,11 +2884,12 @@ qla24xx_els_dcmd2_iocb(scsi_qla_host_t *vha, int =
els_opcode,
>  =09=09return -ENOMEM;
>  =09}
> =20
> +=09fcport->flags |=3D FCF_ASYNC_SENT;
> +=09fcport->disc_state =3D DSC_LOGIN_PEND;
>  =09elsio =3D &sp->u.iocb_cmd;
>  =09ql_dbg(ql_dbg_io, vha, 0x3073,
>  =09    "Enter: PLOGI portid=3D%06x\n", fcport->d_id.b24);
> =20
> -=09fcport->flags |=3D FCF_ASYNC_SENT;
>  =09sp->type =3D SRB_ELS_DCMD;
>  =09sp->name =3D "ELS_DCMD";
>  =09sp->fcport =3D fcport;

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

