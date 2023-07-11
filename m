Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62BDCEB64DD
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 20:24:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230263AbjGKUY2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Jul 2023 16:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbjGKUY1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2023 16:24:27 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFE51705
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2023 13:23:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689107020;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=eV9C9jx9h9D9C/vRLVaKfj87oGBUqvV6SKP1MNBlpZ0=;
        b=YoDqGl0Up4j4DCQr9USkOtFr1EJLZsToVDAzk/7zzbTstSOA98d1crEMe209P+JtqK00od
        N5+nsRzKGa8f8VqDM4QodxjWNAOn74SpSMw5uFtvGeRBGexrZBSwHaq/yRvX5wmx0AcYK3
        V7GUQZ3fQjvbCVFcR24eDCCRuuizIGQ=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-499-CQGI8oDENLqN45CGV-iXJg-1; Tue, 11 Jul 2023 16:23:36 -0400
X-MC-Unique: CQGI8oDENLqN45CGV-iXJg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 778FC1C09052;
        Tue, 11 Jul 2023 20:23:36 +0000 (UTC)
Received: from localhost (unknown [10.39.192.40])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D0662200AD6E;
        Tue, 11 Jul 2023 20:23:35 +0000 (UTC)
Date:   Tue, 11 Jul 2023 14:34:38 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230711183438.GA154686@fedora>
References: <20230709202859.138387-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="4bkaegDfbP/o4tRg"
Content-Disposition: inline
In-Reply-To: <20230709202859.138387-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--4bkaegDfbP/o4tRg
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
> The following patches were made over Linus's tree and fix an issue
> where windows guests will send iovecs with offset/lengths that result
> in IOs that are not aligned to 512. The LIO layer will then send them
> to Linux's FS/block layer but it requires 512 byte alignment, so
> depending on the FS/block driver being used we will get IO errors or
> hung IO.
>=20
> The following patches have vhost-scsi detect when windows sends these
> IOs and copy them to a bounce buffer. It then does some cleanup in
> the related code.

Hang on, virtio-scsi is a SCSI HBA and READs/WRITEs submitted must
follow the usual constraints on SCSI block limits. Would Windows send
mis-aligned I/O to a non-virtio-scsi SCSI HBA?

Are you sure this is not a bug in the Windows guest driver where block
limits are being misconfigured?

Stefan

--4bkaegDfbP/o4tRg
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmStoL4ACgkQnKSrs4Gr
c8jxZQgArLxrWAt/8uuBoonrckaOR/crd2onBaPgO7hRYNaZJYNJyn1BzrJMCYpO
LbkQ7P+iamfwYfA3M49anhxLpfLYfCgGAOma3qCrNll+bUgOZyFIGLn9Wy8KSsh8
EHnpWtGE9kRMXujv1J6ks7JDUIT/8v9A64KP6sX/D/YvAF4yWPEEsZP9NnaDT/61
2uC55lMrUHPQ3E85FFlwaJN4y7X+4GsO2LnA4yYwmlG/+Z1AnHKAGdD6B2ug5d9V
vvTWUWZVT4FtuT/FjdYY6F59oKOtkQEeotj0Y74jMo+uxsEuPcRZ02VRA52rpU/5
LtoQvuVKM4dLV8jw8tXlicUBpOHGtg==
=0k/W
-----END PGP SIGNATURE-----

--4bkaegDfbP/o4tRg--

