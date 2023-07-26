Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8714FC0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 26 Jul 2023 11:35:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjGZLfE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Jul 2023 07:35:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjGZLfC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Jul 2023 07:35:02 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68967AA
        for <linux-scsi@vger.kernel.org>; Wed, 26 Jul 2023 04:34:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690371255;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=3Jw46pEqoG1JcwCkUZQGSGX6+2Sim05zqEJGgawvmzU=;
        b=F5YqsmU+JoM1vYO9CtNGmf0Gj3hF2Rdc5d1sP/HVYwPz5mlUDj3SzC3LyoRJOmfFzNpkhL
        cxd8zdl4Qad4bsoHh+MgitU/R+89RbqF7z+9phxm3OT0mLinSVb4UlFeyDLR9qn/Yq2i1Y
        DfQ88MIOBV7gSNErqZQ0Z8BLJK0j+CY=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-49-QX68alr1OeC0yznYYve55A-1; Wed, 26 Jul 2023 07:34:11 -0400
X-MC-Unique: QX68alr1OeC0yznYYve55A-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8ED78800888;
        Wed, 26 Jul 2023 11:34:11 +0000 (UTC)
Received: from butterfly.localnet (unknown [10.45.224.168])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DD216F782E;
        Wed, 26 Jul 2023 11:34:10 +0000 (UTC)
From:   Oleksandr Natalenko <oleksandr@redhat.com>
To:     Saurav Kashyap <skashyap@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH] qedf: Changed string copy method for "stop_io_on_error" from
 sprintf to put_user
Date:   Wed, 26 Jul 2023 13:34:04 +0200
Message-ID: <12251400.O9o76ZdvQC@redhat.com>
Organization: Red Hat
In-Reply-To: <182fcf92-913f-81dc-6017-01435821bf80@wdc.com>
References: <20230726101236.11922-1-skashyap@marvell.com>
 <182fcf92-913f-81dc-6017-01435821bf80@wdc.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart5693819.DvuYhMxLoT";
 micalg="pgp-sha256"; protocol="application/pgp-signature"
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--nextPart5693819.DvuYhMxLoT
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset="UTF-8"; protected-headers="v1"
From: Oleksandr Natalenko <oleksandr@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Date: Wed, 26 Jul 2023 13:34:04 +0200
Message-ID: <12251400.O9o76ZdvQC@redhat.com>
Organization: Red Hat
In-Reply-To: <182fcf92-913f-81dc-6017-01435821bf80@wdc.com>
MIME-Version: 1.0

Hello.

On st=C5=99eda 26. =C4=8Dervence 2023 12:55:52 CEST Johannes Thumshirn wrot=
e:
> On 26.07.23 12:12, Saurav Kashyap wrote:
>=20
> That one seems to be a duplicate of:
>=20
> https://lore.kernel.org/linux-scsi/20230724120241.40495-2-oleksandr@redha=
t.com/
>=20
> Which looks IMHO way nicer than the put_user() calls.

Thanks for checking that submission. Yes, I'd appreciate some reaction on i=
t as a) open-coding what can be done with a simple simple_read_from_buffer(=
) is a questionable decision; and b) there are two more places where the sa=
me issue occurs, and the RFC I posted should fix those too.

> Regards,
>=20
>      Johannes
>=20
>=20


=2D-=20
Oleksandr Natalenko (post-factum)
Principal Software Maintenance Engineer
--nextPart5693819.DvuYhMxLoT
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCAAdFiEENQb0bxzeq+SMr0+vn464/xkP+AUFAmTBBKwACgkQn464/xkP
+AV4VA//aLZ2GNJqdriBggpRk+IcZpn61juRyDzQBsqIv8HodJ3VyqPkqPswICac
srRoYCvgapOBS2ZWDjBqfzDqFpY912YCm3JbXnwnQCjMvFW8aAzMMhH5nDRWczo5
iRz6oiXsXe4KhDUkuVEOj+dJMzj/LEjyTjBQlDXZnl+AE9mXg7dcvD6K8q8hVnt/
vOpfSIerJDDZMw4qG+wSOryC3ZR27tKFyB5wNdUb3Elr16yKz89/NV4HsAGh51oo
7bpwIpKESVNNCvaGBt3YRYB6KcTAvDPBFG88bY/DrNrRZ61DUaq4obYdKeyawko9
E6PHAh8yeO9FJI1x9jdBfLZMcjuii49mIyPLTunsj4X/YOQWIopGTsTSdwXa4Bwa
45t8opZ4J/7Ylz1yYJyFSjtklerRhAzygke/+wQt1J/IMVsKQskVFV01gp9Nrx2Y
pseK5DTDt85AV9bXZRmFtNCnHisO3At21T7jBiMX+gBqhCHw1OrhPlDJZj3rZmzN
mpptVcwOh+RWZVUhQzNdW8Cq3JV1RIRe53FGX6U8BNsZlp3SXaRB0X27xOA7RdVC
1NTPjKGF1/dVmnpbjx1Gu9llDt9mvx7B6g+3OuBx7CaHmsefU/jvwixlOhPtAM8F
tsFzEJExtbLAiUv5k7mSzbmNypJ28jgxeC2K3oDvGr8LjN1OwyQ=
=I2lJ
-----END PGP SIGNATURE-----

--nextPart5693819.DvuYhMxLoT--



