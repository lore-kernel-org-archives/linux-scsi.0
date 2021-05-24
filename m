Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A8296C04FF3
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 13:24:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 854FB61076
	for <linux-scsi@archiver.kernel.org>; Mon, 24 May 2021 13:24:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbhEXN0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 24 May 2021 09:26:19 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39174 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232409AbhEXN0S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 24 May 2021 09:26:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1621862690;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4XLlEUkhiAcP2K4ZB+J18mgQ/icUCahgsIUqJqs8aT8=;
        b=LvQD3UIEQraMlUaipeFIXB0KErsoODNUWeSb2zKfpRipQBoK46GayHY3pMryDPezQOvFfq
        1tp9Khp3tXYvZ9KfuUD1zCZKEpxWELNrU5GZwx4qWMQW//cTQeu8gx2nxh7K98WgK4xkEc
        2HITjwvTSriwVpziKwqFRN9d4Wd/yN8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-525-jomfIlbHN1CH-3P2nYiTDA-1; Mon, 24 May 2021 09:24:46 -0400
X-MC-Unique: jomfIlbHN1CH-3P2nYiTDA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B747B100A241;
        Mon, 24 May 2021 13:24:44 +0000 (UTC)
Received: from localhost (ovpn-113-244.ams2.redhat.com [10.36.113.244])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D599E50233;
        Mon, 24 May 2021 13:24:38 +0000 (UTC)
Date:   Mon, 24 May 2021 14:24:37 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Dongli Zhang <dongli.zhang@oracle.com>,
        virtualization@lists.linux-foundation.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, mst@redhat.com, jasowang@redhat.com,
        pbonzini@redhat.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, joe.jin@oracle.com,
        junxiao.bi@oracle.com, srinivas.eeda@oracle.com
Subject: Re: [RFC] virtio_scsi: to poll and kick the virtqueue in timeout
 handler
Message-ID: <YKupFeOtc6Pr5KS2@stefanha-x1.localdomain>
References: <20210523063843.1177-1-dongli.zhang@oracle.com>
 <ac161748-15d2-2962-402e-23abca469623@suse.de>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="S/KzmU9AGl0WrRAq"
Content-Disposition: inline
In-Reply-To: <ac161748-15d2-2962-402e-23abca469623@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--S/KzmU9AGl0WrRAq
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, May 23, 2021 at 09:39:51AM +0200, Hannes Reinecke wrote:
> On 5/23/21 8:38 AM, Dongli Zhang wrote:
> > This RFC is to trigger the discussion about to poll and kick the
> > virtqueue on purpose in virtio-scsi timeout handler.
> >=20
> > The virtio-scsi relies on the virtio vring shared between VM and host.
> > The VM side produces requests to vring and kicks the virtqueue, while t=
he
> > host side produces responses to vring and interrupts the VM side.
> >=20
> > By default the virtio-scsi handler depends on the host timeout handler
> > by BLK_EH_RESET_TIMER to give host a chance to perform EH.
> >=20
> > However, this is not helpful for the case that the responses are availa=
ble
> > on vring but the notification from host to VM is lost.
> >=20
> How can this happen?
> If responses are lost the communication between VM and host is broken, and
> we should rather reset the virtio rings themselves.

I agree. In principle it's fine to poll the virtqueue at any time, but I
don't understand the failure scenario here. It's not clear to me why the
device-to-driver vq notification could be lost.

Stefan

--S/KzmU9AGl0WrRAq
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmCrqRUACgkQnKSrs4Gr
c8ja+gf9GSHdRkmM60mxLZ82ONQ0mRq3/yKUUtqLg3POUVan4p1AT+T6YazetRxA
1ux2OmVeDXzAfe9mawQXQLZ5ArlNGYGR+hfi30ECCfXGMkmdhJN42JO57bzYhyfM
ezn5v4l8Dk6d6sdTwQbqaj0KJ8MGS3OqZ4Sd/zanTVlOEi3fuiY0NRYRRQG8xWkr
TFB8ZqPqQvFfdtrjZQHufl9GaZr/pn3xP3bKNXwKWTGCO4zUsgNzddvjGjcAsDh8
a9dX8ujl+N2xQYcp/EpWbeg3H8S/kyMv2834ZHaBH9FEG2K/Z25HfXTzInOSZiRs
vyysHy57N24AFAeVx11lAKTqkkvxcQ==
=8nHX
-----END PGP SIGNATURE-----

--S/KzmU9AGl0WrRAq--

