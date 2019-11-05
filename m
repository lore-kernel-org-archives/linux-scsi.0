Return-Path: <SRS0=fi+p=Y5=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5E193C5DF61
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:19:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 29F8021929
	for <linux-scsi@archiver.kernel.org>; Tue,  5 Nov 2019 15:19:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Qwtk8+yX"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389783AbfKEPTp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 5 Nov 2019 10:19:45 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:35647 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389339AbfKEPTp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 5 Nov 2019 10:19:45 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1572967184;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=KE2z7RMla6CDhwGl5C32SAGoqBI82S71T1uXJwv3JVc=;
        b=Qwtk8+yXHx7WmLAoA4KO+mZSPrVqcyghZXKRMbMYlLJMqmgILQAjn1lFAl6goaVbrQPwIB
        y36eTJT7UW+v3caPW3HFo9r23SP++BogtXyNsruzHyj/C4WiNq5DjGfFXO6frdftnqhXBF
        HN6JcPYFfPtKkEnBB7apR+dDr14R/DE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-QSxTa1hvO86Fnz_JfXQDyQ-1; Tue, 05 Nov 2019 10:19:41 -0500
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 498441800D4A;
        Tue,  5 Nov 2019 15:19:40 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BC9635D70D;
        Tue,  5 Nov 2019 15:19:39 +0000 (UTC)
Message-ID: <8de2aab906ed17c39c7c7eddea805bebc840f056.camel@redhat.com>
Subject: Re: [PATCH 4/8] qla2xxx: Fix driver unload hang
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
Date:   Tue, 05 Nov 2019 10:19:39 -0500
In-Reply-To: <20191105150657.8092-5-hmadhani@marvell.com>
References: <20191105150657.8092-1-hmadhani@marvell.com>
         <20191105150657.8092-5-hmadhani@marvell.com>
Mime-Version: 1.0
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
X-MC-Unique: QSxTa1hvO86Fnz_JfXQDyQ-1
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
> This patch fixes driver unload hang by removing msleep()
>=20
> Fixes: d74595278f4ab ("scsi: qla2xxx: Add multiple queue pair functionali=
ty.")
> Cc: stable@vger.kernel.org
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>  drivers/scsi/qla2xxx/qla_init.c | 2 --
>  1 file changed, 2 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index bddb26baedd2..ff4528702b4e 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -9009,8 +9009,6 @@ int qla2xxx_delete_qpair(struct scsi_qla_host *vha,=
 struct qla_qpair *qpair)
>  =09struct qla_hw_data *ha =3D qpair->hw;
> =20
>  =09qpair->delete_in_progress =3D 1;
> -=09while (atomic_read(&qpair->ref_count))
> -=09=09msleep(500);
> =20
>  =09ret =3D qla25xx_delete_req_que(vha, qpair->req);
>  =09if (ret !=3D QLA_SUCCESS)

Reviewed-by: Ewan D. Milne <emilne@redhat.com>

