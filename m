Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BF7BC001B0
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Jul 2023 14:05:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233821AbjGMOF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Jul 2023 10:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229872AbjGMOF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 Jul 2023 10:05:26 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED2B1FD8
        for <linux-scsi@vger.kernel.org>; Thu, 13 Jul 2023 07:04:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689257079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=kejpQ7yR2S84tXVx9SoQ/put9HkEfzWndejAhecD6PM=;
        b=OBysFRX1vo7xBg9Gt5GUXOPxlWCkiVujaPLwEn6DIn+dVX8eUE0FcKsa+N6EcIfYHJGgtC
        zXERSZEQ7uCOmtVWwiTVI/16M1HMXJcFgkPOydn3SlQpNFJ3s3Kzuog2OXpGucFixczwCm
        vk3aMYhDXhqHD5RgiK/RoN/uOklST+I=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-85-Of-EHkPkNyemV-2SOmd0NA-1; Thu, 13 Jul 2023 10:04:08 -0400
X-MC-Unique: Of-EHkPkNyemV-2SOmd0NA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8A59610504BB;
        Thu, 13 Jul 2023 14:03:45 +0000 (UTC)
Received: from localhost (unknown [10.39.192.106])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAD4B1454142;
        Thu, 13 Jul 2023 14:03:44 +0000 (UTC)
Date:   Thu, 13 Jul 2023 10:03:42 -0400
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     vrozenfe@redhat.com, yvugenfi@redhat.com, mdean@redhat.com,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Message-ID: <20230713140342.GA310002@fedora>
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230711183438.GA154686@fedora>
 <6b53b833-3c71-2bd9-8fd8-757ecda75c53@oracle.com>
 <20230712142656.GB215287@fedora>
 <41d2d3aa-b537-686a-f2b4-1e0a861cebc8@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="PBejcH5agZqVo5Jy"
Content-Disposition: inline
In-Reply-To: <41d2d3aa-b537-686a-f2b4-1e0a861cebc8@oracle.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--PBejcH5agZqVo5Jy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 12, 2023 at 11:05:11AM -0500, Mike Christie wrote:
> On 7/12/23 9:26 AM, Stefan Hajnoczi wrote:
> > On Tue, Jul 11, 2023 at 04:01:22PM -0500, Mike Christie wrote:
> >> On 7/11/23 1:34 PM, Stefan Hajnoczi wrote:
> >>> On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
> >>>> The following patches were made over Linus's tree and fix an issue
> >>>> where windows guests will send iovecs with offset/lengths that result
> >>>> in IOs that are not aligned to 512. The LIO layer will then send them
> >>>> to Linux's FS/block layer but it requires 512 byte alignment, so
> >>>> depending on the FS/block driver being used we will get IO errors or
> >>>> hung IO.
> >>>>
> >>>> The following patches have vhost-scsi detect when windows sends these
> >>>> IOs and copy them to a bounce buffer. It then does some cleanup in
> >>>> the related code.
> >>>
> >>> Hang on, virtio-scsi is a SCSI HBA and READs/WRITEs submitted must
> >>> follow the usual constraints on SCSI block limits. Would Windows send
> >>> mis-aligned I/O to a non-virtio-scsi SCSI HBA?
> >>
> >> It's like linux where you can config settings like that.
> >>
> >>>> Are you sure this is not a bug in the Windows guest driver where blo=
ck
> >>> limits are being misconfigured?
> >>
> >> From what our windows dev told us the guest drivers like here:
> >>
> >> https://github.com/virtio-win
> >>
> >> don't set the windows AlignmentMask to 512. They tried that and it
> >> resulted in windows crash dump crashing because it doesn't like the
> >> hard alignment requirement.
> >>
> >> We thought other apps would have trouble as well, so we tried to add
> >> bounce buffer support to the windows driver, but I think people thought
> >> it was going to be uglier than this patch and in the normal alignment
> >> case might also affect performance. There was some windows driver/laye=
ring
> >> and buffer/cmd details that I don't fully understand and took their wo=
rd
> >> for because I don't know a lot about windows.
> >>
> >> In the end we still have to add checks to vhost-scsi to protect against
> >> bad drivers, so we thought we might as well just add bounce buffer sup=
port
> >> to vhost-scsi.
> >=20
> > CCing virtio-win developers so they can confirm how the vioscsi driver
> > is supposed to handle request alignment.
> >=20
> > My expectation is that the virtio-scsi device will fail mis-aligned I/O
> > requests.
>=20
> I don't think you can just change the driver's behavior to fail now,
> because apps send mis-aligned IO and its working as long as they have less
> than 256 bio vecs.
>=20
> We see mis-aligned IOs during boot and also from random non window's apps.
> If we just start to fail then it would be a regression when the app no
> longer works or the OS fails to start up.

I was wrong:

The virtio-scsi specification contains no alignment requirements for I/O
buffers. It is fine for the driver to submit iovecs with any memory
alignment.

The QEMU code allocates a bounce buffer if the iovecs submitted by the
driver do not match the minimum alignment requirements on the host (e.g.
O_DIRECT requirements).

It makes sense that vhost_scsi needs to use a bounce buffer in cases
where the underlying storage has stricter memory alignment requirements.

Acked-by: Stefan Hajnoczi <stefanha@redhat.com>

--PBejcH5agZqVo5Jy
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmSwBD4ACgkQnKSrs4Gr
c8jZZQgAiXLRmCgucPEGc4bLM1Ch0HqdkBRqe6ST0FN95ffDCONwWSWLTfXfsJOy
mvcn+aLKShsLgW+3Q/Iq7AyEAImiO7OWWTi1ZgltSSC5Gvxn6EPHLgXP0Lwmpwdh
2vcrAXIQ48HbLAg/eE+4K6ORsH3+/cE1pI/5H4p64LH4Feca/KwHfW8d8KE24taZ
A+bFSY8DcHGk8W6J25Fjx2gMYFXFMYZ5n5u3hVbse4syBwgRcJYM7Yq+Thmvvkoh
tivsDiHLCccKrEZGudP/vlaLUdW35SLegSWjQWJuF6jYroAZEl/L7uU7Es02U72o
tQ0MCYSZt8DMr6g4/EPmx02ZoJ/8ug==
=P4dJ
-----END PGP SIGNATURE-----

--PBejcH5agZqVo5Jy--

