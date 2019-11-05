Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48206C5DF60
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:18:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1A70121929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:18:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cwYyQ1gF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389781AbfKEPS4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:18:56 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:21480 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389339AbfKEPS4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:18:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967135;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NY+8vtl1sS3QRy0+4LSJUZ9+OnUW1am7C+BXlmp+Cc8=;
        b=cwYyQ1gF/XgqsNybneFhm2p24pvNKzBBM86Aqdp7S97UgfcUd8MG0u5vq/z/nw/OKTSyz/
        wx/jKprKzEf4Lag9lfEaj419zY0ZPWFwrsWKx5U3UhnGtdtx5pYzpNAexAnebtuomBrUco
        Jx5z/XS8bamoNfOAKSnomlYJqnBz+0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-CCnMWoOGO6iOhACiYoPE3w-1; Tue, 05 Nov 2019 10:18:54 -0500
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D5FBD477;
        Tue,  5 Nov 2019 15:18:52 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4E19E5D9CD;
        Tue,  5 Nov 2019 15:18:52 +0000 (UTC)
Message-ID: <3d6f18af923fe3f1d513851c7d4c67c10d6bb369.camel@redhat.com>
Subject: Re: [PATCH 2/8] qla2xxx: Do command completion on abort timeout
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:18:51 -0500
In-Reply-To: <20191105150657.8092-3-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-3-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: CCnMWoOGO6iOhACiYoPE3w-1
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
> On switch, fabric and mgt command timeout, driver
> send Abort to tell FW to return the original command.
> If abort is timeout, then return both Abort and
> original command for cleanup.
>=20
> Fixes: 219d27d7147e0 ("scsi: qla2xxx: Fix race conditions in the code for=
 aborting SCSI commands")
> Cc: stable@vger.kernel.org # 5.2
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_def.h  |  1 +
>  drivers/scsi/qla2xxx/qla_init.c | 18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 721ee7f09b39..ef9bb3c7ad6f 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -604,6 +604,7 @@ typedef struct srb {
>  =09const char *name;
>  =09int iocbs;
>  =09struct qla_qpair *qpair;
> +=09struct srb *cmd_sp;
>  =09struct list_head elem;
>  =09u32 gen1;=09/* scratch */
>  =09u32 gen2;=09/* scratch */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index 5db8ad832893..7fdbe041cc19 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -101,8 +101,22 @@ static void qla24xx_abort_iocb_timeout(void *data)
>  =09u32 handle;
>  =09unsigned long flags;
> =20
> +=09if (sp->cmd_sp)
> +=09=09ql_dbg(ql_dbg_async, sp->vha, 0x507c,
> +=09=09    "Abort timeout - cmd hdl=3D%x, cmd type=3D%x hdl=3D%x, type=3D=
%x\n",
> +=09=09    sp->cmd_sp->handle, sp->cmd_sp->type,
> +=09=09    sp->handle, sp->type);
> +=09else
> +=09=09ql_dbg(ql_dbg_async, sp->vha, 0x507c,
> +=09=09    "Abort timeout 2 - hdl=3D%x, type=3D%x\n",
> +=09=09    sp->handle, sp->type);
> +
>  =09spin_lock_irqsave(qpair->qp_lock_ptr, flags);
>  =09for (handle =3D 1; handle < qpair->req->num_outstanding_cmds; handle+=
+) {
> +=09=09if (sp->cmd_sp && (qpair->req->outstanding_cmds[handle] =3D=3D
> +=09=09    sp->cmd_sp))
> +=09=09=09qpair->req->outstanding_cmds[handle] =3D NULL;
> +
>  =09=09/* removing the abort */
>  =09=09if (qpair->req->outstanding_cmds[handle] =3D=3D sp) {
>  =09=09=09qpair->req->outstanding_cmds[handle] =3D NULL;
> @@ -111,6 +125,9 @@ static void qla24xx_abort_iocb_timeout(void *data)
>  =09}
>  =09spin_unlock_irqrestore(qpair->qp_lock_ptr, flags);
> =20
> +=09if (sp->cmd_sp)
> +=09=09sp->cmd_sp->done(sp->cmd_sp, QLA_OS_TIMER_EXPIRED);
> +
>  =09abt->u.abt.comp_status =3D CS_TIMEOUT;
>  =09sp->done(sp, QLA_OS_TIMER_EXPIRED);
>  }
> @@ -142,6 +159,7 @@ static int qla24xx_async_abort_cmd(srb_t *cmd_sp, boo=
l wait)
>  =09sp->type =3D SRB_ABT_CMD;
>  =09sp->name =3D "abort";
>  =09sp->qpair =3D cmd_sp->qpair;
> +=09sp->cmd_sp =3D cmd_sp;
>  =09if (wait)
>  =09=09sp->flags =3D SRB_WAKEUP_ON_COMP;
> =20

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

