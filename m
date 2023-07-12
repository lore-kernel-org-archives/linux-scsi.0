Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05CADEB64D9
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Jul 2023 14:28:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231522AbjGLO2g (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Jul 2023 10:28:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232035AbjGLO2Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Jul 2023 10:28:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8ED2273D
        for <linux-scsi@vger.kernel.org>; Wed, 12 Jul 2023 07:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689172022;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YuLYRtG9rlYrlnldQSFLl0oU1VkecWxThhvBzU3738M=;
        b=R3jkEYe9oKd9kZz0VXmV+Ojc/GhMz8aut91v37fplmSdrueTbtq0FPhhelDLjk4ZSuF1Zh
        CpcKKdyuVcasLMTAOcCbfPlLcJvnWiobObyXBp2DK2R0GGfZegd0La/GseZZwtd83EbaTX
        6njvXltPSvtDafXVEvanGH4BlDmKkg4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-518-zBZ4RJz0Pty4nzvIoj45OQ-1; Wed, 12 Jul 2023 10:26:58 -0400
X-MC-Unique: zBZ4RJz0Pty4nzvIoj45OQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 388648EBBA1;
        Wed, 12 Jul 2023 14:26:58 +0000 (UTC)
Received: from localhost (unknown [10.39.192.162])
        by smtp.corp.redhat.com (Postfix) with ESMTP id B588FC1ED96;
        Wed, 12 Jul 2023 14:26:57 +0000 (UTC)
Date:   Wed, 12 Jul 2023 10:26:56 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     vrozenfe@redhat.com, yvugenfi@redhat.com, mdean@redhat.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230712142656.GB215287@fedora>
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230711183438.GA154686@fedora>
 <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="NRdAloLYDxU+lGu1"
Content-Disposition: inline
In-Reply-To: <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--NRdAloLYDxU+lGu1
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 11, 2023 at 04:01:22PM -0500, Mike Christie wrote:
> On 7/11/23 1:34 PM, Stefan Hajnoczi wrote:
> > On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
> >> The following patches were made over Linus's tree and fix an issue
> >> where windows guests will send iovecs with offset/lengths that result
> >> in IOs that are not aligned to 512. The LIO layer will then send them
> >> to Linux's FS/block layer but it requires 512 byte alignment, so
> >> depending on the FS/block driver being used we will get IO errors or
> >> hung IO.
> >>
> >> The following patches have vhost-scsi detect when windows sends these
> >> IOs and copy them to a bounce buffer. It then does some cleanup in
> >> the related code.
> >=20
> > Hang on, virtio-scsi is a SCSI HBA and READs/WRITEs submitted must
> > follow the usual constraints on SCSI block limits. Would Windows send
> > mis-aligned I/O to a non-virtio-scsi SCSI HBA?
>=20
> It's like linux where you can config settings like that.
>=20
> > > Are you sure this is not a bug in the Windows guest driver where block
> > limits are being misconfigured?
>=20
> From what our windows dev told us the guest drivers like here:
>=20
> https://github.com/virtio-win
>=20
> don't set the windows AlignmentMask to 512. They tried that and it
> resulted in windows crash dump crashing because it doesn't like the
> hard alignment requirement.
>=20
> We thought other apps would have trouble as well, so we tried to add
> bounce buffer support to the windows driver, but I think people thought
> it was going to be uglier than this patch and in the normal alignment
> case might also affect performance. There was some windows driver/layering
> and buffer/cmd details that I don't fully understand and took their word
> for because I don't know a lot about windows.
>=20
> In the end we still have to add checks to vhost-scsi to protect against
> bad drivers, so we thought we might as well just add bounce buffer support
> to vhost-scsi.

CCing virtio-win developers so they can confirm how the vioscsi driver
is supposed to handle request alignment.

My expectation is that the virtio-scsi device will fail mis-aligned I/O
requests.

Stefan

--NRdAloLYDxU+lGu1
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSuuDAACgkQnKSrs4Gr
c8hvFAf+JDI1Oz+7UVYpSQJpLXVE72G+4FSrqroo20DnuvXiTgty7VncVfOy5nd1
/iSBI7rffMwc1LdIzR7hOWb/Iz0po/eVfUyUBo3noy+ShjV1jWIJNGnYYt3P8j0u
tE/ywD63hJp/s82fWBS+nOI2b3QJqkg+4bfTmihd+PngLZbikJqRv4TdR1x+1ka9
o6XJ8Iu75YiKqVKCehxUsEWkPc8304dXoMANZR4YO6+68zZhKS7RVSFi2hR0squi
T9Aq89ap8LRNvjTtcHic2u+fwLoL4TEvutjYsAEcSNl0p1BNSu8nuriciocg0ZyG
Qsbwf0+HjCtR9RUF14BlKLt9zkU6dA==
=O6MD
-----END PGP SIGNATURE-----

--NRdAloLYDxU+lGu1--

