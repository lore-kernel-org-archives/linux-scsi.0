Return-Path: <SRS0=OHhN=ZA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54672C5DF60
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 15:19:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 279C7222C4
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Nov 2019 15:19:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="QtDCCezd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbfKHPTS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 Nov 2019 10:19:18 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:31867 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726036AbfKHPTS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Nov 2019 10:19:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573226357;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=gDcepNlFdX9wdEB6yJ5lc+Qh94tnvNgUu56sJpD0ViI=;
        b=QtDCCezd50fiISV/oRQpsdPPKvA26HwTpbptnnns7e21Kzaes2kQ7z8rv3ASlM9Y++zPXG
        m7FeF5uWTGlAbXW12zS7QTjxT1YlXAufoHHDhmHaEqX89cnlLwVEPQUjeN1vLuFp5q9a6h
        q9/tmJjC6gEXSsErpgtUijebMl5MRfQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-33-cSLfRZXhNIW_HAwetSqILg-1; Fri, 08 Nov 2019 10:19:13 -0500
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id F05CF1804971;
        Fri,  8 Nov 2019 15:19:12 +0000 (UTC)
Received: from [10.10.125.42] (ovpn-125-42.rdu2.redhat.com [10.10.125.42])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6F1D260BE2;
        Fri,  8 Nov 2019 15:19:12 +0000 (UTC)
Subject: Re: [PATCH v2] target: core: Prevent memory reclaim recursion
To:     Damien Le Moal <damien.lemoal@wdc.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
References: <20191108082901.417950-1-damien.lemoal@wdc.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5DC5876F.2000301@redhat.com>
Date:   Fri, 8 Nov 2019 09:19:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20191108082901.417950-1-damien.lemoal@wdc.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
X-MC-Unique: cSLfRZXhNIW_HAwetSqILg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/08/2019 02:29 AM, Damien Le Moal wrote:
> Prevent recursion into the IO path under low memory conditions by using
> GFP_NOIO in place of GFP_KERNEL when allocating a new command with
> tcmu_alloc_cmd() and user ring space with tcmu_get_empty_block().
>=20
> Reported-by: Masato Suzuki <masato.suzuki@wdc.com>
> Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
> ---
>=20
> Changes from v1:
> * Added reported-by tag
>=20
>  drivers/target/target_core_user.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_co=
re_user.c
> index 35be1be87d2a..0b9dfa6b17bc 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -499,7 +499,7 @@ static inline bool tcmu_get_empty_block(struct tcmu_d=
ev *udev,
>  =09=09=09schedule_delayed_work(&tcmu_unmap_work, 0);
> =20
>  =09=09/* try to get new page from the mm */
> -=09=09page =3D alloc_page(GFP_KERNEL);
> +=09=09page =3D alloc_page(GFP_NOIO);
>  =09=09if (!page)
>  =09=09=09goto err_alloc;
> =20
> @@ -573,7 +573,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd =
*se_cmd)
>  =09struct tcmu_dev *udev =3D TCMU_DEV(se_dev);
>  =09struct tcmu_cmd *tcmu_cmd;
> =20
> -=09tcmu_cmd =3D kmem_cache_zalloc(tcmu_cmd_cache, GFP_KERNEL);
> +=09tcmu_cmd =3D kmem_cache_zalloc(tcmu_cmd_cache, GFP_NOIO);
>  =09if (!tcmu_cmd)
>  =09=09return NULL;
> =20
> @@ -584,7 +584,7 @@ static struct tcmu_cmd *tcmu_alloc_cmd(struct se_cmd =
*se_cmd)
>  =09tcmu_cmd_reset_dbi_cur(tcmu_cmd);
>  =09tcmu_cmd->dbi_cnt =3D tcmu_cmd_get_block_cnt(tcmu_cmd);
>  =09tcmu_cmd->dbi =3D kcalloc(tcmu_cmd->dbi_cnt, sizeof(uint32_t),
> -=09=09=09=09GFP_KERNEL);
> +=09=09=09=09GFP_NOIO);
>  =09if (!tcmu_cmd->dbi) {
>  =09=09kmem_cache_free(tcmu_cmd_cache, tcmu_cmd);
>  =09=09return NULL;
>=20

Acked-by: Mike Christie <mchristi@redhat.com>

We should also change tcmu_setup_cmd_timer so the gfp use in that code
path is consistent. I think we can do that in a separate patch later as
this one just fixes a specific bug.

