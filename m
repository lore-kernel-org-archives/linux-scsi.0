Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A61B6C47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 13:54:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8FEA5613E7
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 13:54:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230525AbhFCNz6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 09:55:58 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36723 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230264AbhFCNz6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 09:55:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622728453;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=1kB/QJX5BIlb1z1hPD/TANoHe7uf5sJAff0xCkv6VsY=;
        b=KMZqHAJxVkrThbQ5+BoUuVi0e4iMepkAoy2ZCkTznIBjpyzsfp/au+3QNS4R/LXhCCsUqu
        3SDxd494ZiaFn6Qj8Ag3CqyGm9+7+aU+zEnjJLOf6EwKWIanTXk0oOfJGYZ+8fN7HZRFxg
        88GxLDNXpcgg8LloPIZjzWq34anHWJk=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-547-3GFkZtYmMkii5c7HxqWoVQ-1; Thu, 03 Jun 2021 09:54:11 -0400
X-MC-Unique: 3GFkZtYmMkii5c7HxqWoVQ-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 57FE8180FD75;
        Thu,  3 Jun 2021 13:54:10 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C4E465C232;
        Thu,  3 Jun 2021 13:54:05 +0000 (UTC)
Date:   Thu, 3 Jun 2021 14:54:04 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 5/9] vhost-scsi: flush IO vqs then send TMF rsp
Message-ID: <YLje/Ja40HpxxRlh@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-6-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="oQptM8rAC7OUhFVQ"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-6-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--oQptM8rAC7OUhFVQ
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:56PM -0500, Mike Christie wrote:
> With one worker we will always send the scsi cmd responses then send the
> TMF rsp, because LIO will always complete the scsi cmds first which
> calls vhost_scsi_release_cmd to add them to the work queue.
>=20
> When the next patches adds multiple worker support, the worker threads
> could still be sending their responses when the tmf's work is run.
> So this patch has vhost-scsi flush the IO vqs on other worker threads
> before we send the tmf response.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c  | 17 ++++++++++++++---
>  drivers/vhost/vhost.c |  6 ++++++
>  drivers/vhost/vhost.h |  1 +
>  3 files changed, 21 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/vhost/scsi.c b/drivers/vhost/scsi.c
> index 46f897e41217..e585f2180457 100644
> --- a/drivers/vhost/scsi.c
> +++ b/drivers/vhost/scsi.c
> @@ -1168,12 +1168,23 @@ static void vhost_scsi_tmf_resp_work(struct vhost=
_work *work)
>  {
>  	struct vhost_scsi_tmf *tmf =3D container_of(work, struct vhost_scsi_tmf,
>  						  vwork);
> -	int resp_code;
> +	int resp_code, i;
> +
> +	if (tmf->scsi_resp =3D=3D TMR_FUNCTION_COMPLETE) {
> +		/*
> +		 * When processing a TMF lio completes the cmds then the TMF,
> +		 * so with one worker the TMF always completes after cmds. For
> +		 * multiple worker support we must flush the IO vqs to make
> +		 * sure if they have differrent workers then the cmds have

s/differrent/different/

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--oQptM8rAC7OUhFVQ
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC43vwACgkQnKSrs4Gr
c8hjZwf+KeUTDVtyQ9sFewX8iRHhfPwDLkXjwwOArYnb7aItO7iqWHMMOzOWB0EJ
aEEPQJh4wkPM2JEFaSfG0nKKEiOCAp7eKBWaGEROSJAb2iEWDdqwFv0aRo8q/oNb
JAraumYNlrKuBFm5WFQWLxnqh5AmYGYwbZ91LPsoz1inRXo8C5gqCgQuILBCK+2u
7NuZhNpJHVjnCyOoVA2OskULdIPUHNpnCF0DVg2VpOVuPIcAAXPo8VIRb09ZxlXB
zQ/VZPxMBZ44vF/3oWSvjgWxtBM16YbDQF3LzkVoMdsqnKXX4KP2ooXNfIDU5n0C
vQXaagDOfVUHdhoAz2+n6LQ83zR9bw==
=G+4s
-----END PGP SIGNATURE-----

--oQptM8rAC7OUhFVQ--

