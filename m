Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BDAAC47096
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 13:57:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E406613AA
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 13:57:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231287AbhFCN72 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 09:59:28 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:51452 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230342AbhFCN72 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 09:59:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622728663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=qmLTHJrSQDbMU7UTLA4d0t4PiOLJgLmVKJZe+PUyZok=;
        b=WCb1fkqu0J4G41sot2f0oXgDvHSDgNL2PXp1YQ9n6DVWMylSsE2QffoUd4/ZvCr8IC1TPW
        67v9SKjyaPV5gJAcoKBqPk7H/FOaI8QvwkNqlWgOIznZfFjqS9cibi4LEBwNuBRtWFdqtt
        UwxxOmDcgNaOwpgNDu/zCalurHsdaRE=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-564-NqkgsowEMUKltENCWcyOoQ-1; Thu, 03 Jun 2021 09:57:36 -0400
X-MC-Unique: NqkgsowEMUKltENCWcyOoQ-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D00E0803624;
        Thu,  3 Jun 2021 13:57:35 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C790A60657;
        Thu,  3 Jun 2021 13:57:31 +0000 (UTC)
Date:   Thu, 3 Jun 2021 14:57:30 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 6/9] vhost-scsi: make SCSI cmd completion per vq
Message-ID: <YLjfyqC1VD7kNFpH@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="mvXsWp4PhT0LQr2M"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-7-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--mvXsWp4PhT0LQr2M
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:57PM -0500, Mike Christie wrote:
> This patch separates the scsi cmd completion code paths so we can complete
> cmds based on their vq instead of having all cmds complete on the same
> worker/CPU. This will be useful with the next patch that allows us to
> create mulitple worker threads and bind them to different vqs, so we can
> have completions running on different threads/CPUs.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/vhost/scsi.c | 48 +++++++++++++++++++++++---------------------
>  1 file changed, 25 insertions(+), 23 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--mvXsWp4PhT0LQr2M
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC438oACgkQnKSrs4Gr
c8hBHwgAqiLjVqav8oRJZbb+h+FZfPrI5JEeMouqXSxGC/R3GNDnJXHoIosgbjUd
isXzBnt1GHlhRBspQXx1i+z2TZ09csnLPdF25g1qwULMQmZ7pCAjdOIAzMaTauxn
6GBGOB1P+YD4/QQAgdFWyUqI0t0VxfrHxHY5AgAoZ5b4DEt105OrUDMFlwXLbsXm
rMZV8biElfES8egfDNuHg9Ityn/DtQZVB16FQZnB0bYU6elHpXXn+mcaqfKQWWoX
+VDFyFB0I8jmZRfgXf/VBgX9uZUy4ByW+sTE8M+/L0e6eymw75c7ZXSvgImcQazl
rrCvDqyPsNL/jVotE0y8R1cvPFjJ/A==
=6gup
-----END PGP SIGNATURE-----

--mvXsWp4PhT0LQr2M--

