Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6B1F5C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:19:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3572821928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:19:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="dvwkPEYK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389714AbfKEPTZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:19:25 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:25750 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389339AbfKEPTY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:19:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967163;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EgZW7hLA517fhaWlhFB0OcI5a7gYcIP/ZByeIHVS/wo=;
        b=dvwkPEYKtYe7y3hw6jBDb3iaZ18ZkaESjzXTqoKeyxAkpahHXr9YT52Cjfq5ZrPWL2skkt
        wr10+7HrBNSLl+Pm9Iex902D/d0mTa2Q/dlxS8H+VY1sIUCe3h4uoKll6oV6zsVyF2ukdA
        moPldSV1qqdNRbRFrMeiJS82dpfFk80=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-303-sdX5CJ0JM2u8rrJa7_HgIA-1; Tue, 05 Nov 2019 10:19:19 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B80341005500;
        Tue,  5 Nov 2019 15:19:18 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B7C05D6A3;
        Tue,  5 Nov 2019 15:19:18 +0000 (UTC)
Message-ID: <2f83d0b87ca5e708be95e8aaf29dc49215a7550d.camel@redhat.com>
Subject: Re: [PATCH 3/8] qla2xxx: Fix SRB leak on switch command timeout
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:19:17 -0500
In-Reply-To: <20191105150657.8092-4-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-4-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: sdX5CJ0JM2u8rrJa7_HgIA-1
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
> when GPSC/GPDB switch command fails, driver just returns
> without doing a proper cleanup. This patch fixes this memory
> leak by calling sp->free() in the error path.
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_gs.c   |  2 +-
>  drivers/scsi/qla2xxx/qla_init.c | 11 +++++------
>  drivers/scsi/qla2xxx/qla_mbx.c  |  4 ----
>  drivers/scsi/qla2xxx/qla_mid.c  | 11 ++++-------
>  drivers/scsi/qla2xxx/qla_os.c   |  7 ++++++-
>  5 files changed, 16 insertions(+), 19 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gs.c b/drivers/scsi/qla2xxx/qla_gs.=
c
> index 7a00272ca380..67230688b05e 100644
> --- a/drivers/scsi/qla2xxx/qla_gs.c
> +++ b/drivers/scsi/qla2xxx/qla_gs.c
> @@ -3010,7 +3010,7 @@ static void qla24xx_async_gpsc_sp_done(srb_t *sp, i=
nt res)
>  =09fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> =20
>  =09if (res =3D=3D QLA_FUNCTION_TIMEOUT)
> -=09=09return;
> +=09=09goto done;
> =20
>  =09if (res =3D=3D (DID_ERROR << 16)) {
>  =09=09/* entry status error */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 7fdbe041cc19..bddb26baedd2 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1151,19 +1151,18 @@ static void qla24xx_async_gpdb_sp_done(srb_t *sp,=
 int res)
>  =09    "Async done-%s res %x, WWPN %8phC mb[1]=3D%x mb[2]=3D%x \n",
>  =09    sp->name, res, fcport->port_name, mb[1], mb[2]);
> =20
> -=09if (res =3D=3D QLA_FUNCTION_TIMEOUT) {
> -=09=09dma_pool_free(sp->vha->hw->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
> -=09=09=09sp->u.iocb_cmd.u.mbx.in_dma);
> -=09=09return;
> -=09}
> -
>  =09fcport->flags &=3D ~(FCF_ASYNC_SENT | FCF_ASYNC_ACTIVE);
> +
> +=09if (res =3D=3D QLA_FUNCTION_TIMEOUT)
> +=09=09goto done;
> +
>  =09memset(&ea, 0, sizeof(ea));
>  =09ea.fcport =3D fcport;
>  =09ea.sp =3D sp;
> =20
>  =09qla24xx_handle_gpdb_event(vha, &ea);
> =20
> +done:
>  =09dma_pool_free(ha->s_dma_pool, sp->u.iocb_cmd.u.mbx.in,
>  =09=09sp->u.iocb_cmd.u.mbx.in_dma);
> =20
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index 04175c91af0e..0cf94f05f008 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -6288,17 +6288,13 @@ int qla24xx_send_mb_cmd(struct scsi_qla_host *vha=
, mbx_cmd_t *mcp)
>  =09case  QLA_SUCCESS:
>  =09=09ql_dbg(ql_dbg_mbx, vha, 0x119d, "%s: %s done.\n",
>  =09=09    __func__, sp->name);
> -=09=09sp->free(sp);
>  =09=09break;
>  =09default:
>  =09=09ql_dbg(ql_dbg_mbx, vha, 0x119e, "%s: %s Failed. %x.\n",
>  =09=09    __func__, sp->name, rval);
> -=09=09sp->free(sp);
>  =09=09break;
>  =09}
> =20
> -=09return rval;
> -
>  done_free_sp:
>  =09sp->free(sp);
>  done:
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 6afad68e5ba2..bd62c4595b73 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -944,7 +944,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
> =20
>  =09sp =3D qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
>  =09if (!sp)
> -=09=09goto done;
> +=09=09return rval;
> =20
>  =09sp->type =3D SRB_CTRL_VP;
>  =09sp->name =3D "ctrl_vp";
> @@ -960,7 +960,7 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>  =09=09ql_dbg(ql_dbg_async, vha, 0xffff,
>  =09=09    "%s: %s Failed submission. %x.\n",
>  =09=09    __func__, sp->name, rval);
> -=09=09goto done_free_sp;
> +=09=09goto done;
>  =09}
> =20
>  =09ql_dbg(ql_dbg_vport, vha, 0x113f, "%s hndl %x submitted\n",
> @@ -978,16 +978,13 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cm=
d)
>  =09case QLA_SUCCESS:
>  =09=09ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s done.\n",
>  =09=09    __func__, sp->name);
> -=09=09goto done_free_sp;
> +=09=09break;
>  =09default:
>  =09=09ql_dbg(ql_dbg_vport, vha, 0xffff, "%s: %s Failed. %x.\n",
>  =09=09    __func__, sp->name, rval);
> -=09=09goto done_free_sp;
> +=09=09break;
>  =09}
>  done:
> -=09return rval;
> -
> -done_free_sp:
>  =09sp->free(sp);
>  =09return rval;
>  }
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 588e0d27f151..2e7a4a2d6c5a 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -996,7 +996,7 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, struct =
scsi_cmnd *cmd,
>  =09=09ql_dbg(ql_dbg_io + ql_dbg_verbose, vha, 0x3078,
>  =09=09    "Start scsi failed rval=3D%d for cmd=3D%p.\n", rval, cmd);
>  =09=09if (rval =3D=3D QLA_INTERFACE_ERROR)
> -=09=09=09goto qc24_fail_command;
> +=09=09=09goto qc24_free_sp_fail_command;
>  =09=09goto qc24_host_busy_free_sp;
>  =09}
> =20
> @@ -1008,6 +1008,11 @@ qla2xxx_mqueuecommand(struct Scsi_Host *host, stru=
ct scsi_cmnd *cmd,
>  qc24_target_busy:
>  =09return SCSI_MLQUEUE_TARGET_BUSY;
> =20
> +qc24_free_sp_fail_command:
> +=09sp->free(sp);
> +=09CMD_SP(cmd) =3D NULL;
> +=09qla2xxx_rel_qpair_sp(sp->qpair, sp);
> +
>  qc24_fail_command:
>  =09cmd->scsi_done(cmd);
> =20

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

