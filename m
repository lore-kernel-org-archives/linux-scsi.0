Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F008C5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:21:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65B5621928
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:21:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DZ4gN8tg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389732AbfKEPVP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:21:15 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:36010 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2388842AbfKEPVO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:21:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967273;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=AcyHHJKqwd1uRPR3fupiJtyTGjIuIjk6vkCzSPuiCvs=;
        b=DZ4gN8tghlcVBpbbDAGNenQFzNEgEVnVuES6IiONBDSGDns0W9J8JfKRxB75LKai3Tkt7A
        7MwqtzhYGggX1LrEP1PyAz0qLSAtIYJMsVeGTUh3Z79AHtUEfAPMQPG2kHOKPNtozG2zFF
        fBDctATjorbc9HZZwgjRJM5L00x0EFE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-307-JWxVaA0bO3K2RpPGuG8tlA-1; Tue, 05 Nov 2019 10:21:11 -0500
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 972AE8017DD;
        Tue,  5 Nov 2019 15:21:10 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 1A5D810018FF;
        Tue,  5 Nov 2019 15:21:10 +0000 (UTC)
Message-ID: <9fae917cb46884c8eec6dfab8150f05427229424.camel@redhat.com>
Subject: Re: [PATCH 7/8] qla2xxx: Fix device connect issues in P2P
 configuration
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:21:09 -0500
In-Reply-To: <20191105150657.8092-8-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-8-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-MC-Unique: JWxVaA0bO3K2RpPGuG8tlA-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-11-05 at 07:06 -0800, Himanshu Madhani wrote:
> From: Arun Easi <aeasi@marvell.com>
>=20
> P2P need to take the alternate plogi route.
>=20
> Signed-off-by: Arun Easi <aeasi@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_gbl.h  | 1 +
>  drivers/scsi/qla2xxx/qla_init.c | 9 +++++++++
>  drivers/scsi/qla2xxx/qla_iocb.c | 5 ++---
>  3 files changed, 12 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_gbl.h b/drivers/scsi/qla2xxx/qla_gb=
l.h
> index d11416dcee4e..5b163ad85c34 100644
> --- a/drivers/scsi/qla2xxx/qla_gbl.h
> +++ b/drivers/scsi/qla2xxx/qla_gbl.h
> @@ -917,4 +917,5 @@ int qla2x00_set_data_rate(scsi_qla_host_t *vha, uint1=
6_t mode);
> =20
>  /* nvme.c */
>  void qla_nvme_unregister_remote_port(struct fc_port *fcport);
> +void qla_handle_els_plogi_done(scsi_qla_host_t *vha, struct event_arg *e=
a);
>  #endif /* _QLA_GBL_H */
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index ff4528702b4e..6bb4ddd90b6e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -1717,6 +1717,15 @@ void qla24xx_handle_relogin_event(scsi_qla_host_t =
*vha,
>  =09qla24xx_fcport_handle_login(vha, fcport);
>  }
> =20
> +void qla_handle_els_plogi_done(scsi_qla_host_t *vha,
> +=09=09=09=09      struct event_arg *ea)
> +{
> +=09ql_dbg(ql_dbg_disc, vha, 0x2118,
> +=09    "%s %d %8phC post PRLI\n",
> +=09    __func__, __LINE__, ea->fcport->port_name);
> +=09qla24xx_post_prli_work(vha, ea->fcport);
> +}
> +
>  /*
>   * RSCN(s) came in for this fcport, but the RSCN(s) was not able
>   * to be consumed by the fcport
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> index 2b675da34bda..b25f87ff8cde 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -2760,9 +2760,8 @@ static void qla2x00_els_dcmd2_sp_done(srb_t *sp, in=
t res)
>  =09=09case CS_COMPLETE:
>  =09=09=09memset(&ea, 0, sizeof(ea));
>  =09=09=09ea.fcport =3D fcport;
> -=09=09=09ea.data[0] =3D MBS_COMMAND_COMPLETE;
> -=09=09=09ea.sp =3D sp;
> -=09=09=09qla24xx_handle_plogi_done_event(vha, &ea);
> +=09=09=09ea.rc =3D res;
> +=09=09=09qla_handle_els_plogi_done(vha, &ea);
>  =09=09=09break;
> =20
>  =09=09case CS_IOCB_ERROR:

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

