Return-Path: <SRS0=RyiH=BH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A90DC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 15:45:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6670220825
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jul 2020 15:45:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="go3OUaBv"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731003AbgG1PpO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jul 2020 11:45:14 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26970 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1730949AbgG1PpO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jul 2020 11:45:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595951113;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0umpA98IwRGx6/MPdjALwMgb7oXwSSsk+mQbCZoe0MU=;
        b=go3OUaBvbCu1xa6uDnHvREtzkmpwv5fUJ9OJboVSeBIq2pNhAR2d0JJlckZeuDBsGEP+8i
        N55g20350BhlJb8diTHZe39F1Q4yr7lzNVdQ6tIBtgG9aopblFU+QXCx/rb07Qp8lgOMnx
        uZo2KW52wxkjnQdzca5QLO93AQwbtes=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-460-nZeArAQfM2eHGtGOwT-JDA-1; Tue, 28 Jul 2020 11:45:10 -0400
X-MC-Unique: nZeArAQfM2eHGtGOwT-JDA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C96A2106B246;
        Tue, 28 Jul 2020 15:44:42 +0000 (UTC)
Received: from localhost (ovpn-115-19.ams2.redhat.com [10.36.115.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2BFD6712E8;
        Tue, 28 Jul 2020 15:44:41 +0000 (UTC)
Date:   Tue, 28 Jul 2020 16:44:40 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Maxim Levitsky <mlevitsk@redhat.com>
Cc:     linux-kernel@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
        Josef Bacik <josef@toxicpanda.com>,
        "open list:BLOCK LAYER" <linux-block@vger.kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@kernel.dk>,
        "open list:NVM EXPRESS DRIVER" <linux-nvme@lists.infradead.org>,
        "open list:SCSI CDROM DRIVER" <linux-scsi@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <damien.lemoal@wdc.com>,
        Jason Wang <jasowang@redhat.com>,
        Maxim Levitsky <maximlevitsky@gmail.com>,
        Colin Ian King <colin.king@canonical.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Ajay Joshi <ajay.joshi@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "open list:SONY MEMORYSTICK SUBSYSTEM" <linux-mmc@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Satya Tangirala <satyat@google.com>,
        "open list:NETWORK BLOCK DEVICE (NBD)" <nbd@other.debian.org>,
        Hou Tao <houtao1@huawei.com>, Jens Axboe <axboe@fb.com>,
        "open list:VIRTIO CORE AND NET DRIVERS" 
        <virtualization@lists.linux-foundation.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Alex Dubov <oakad@yahoo.com>
Subject: Re: [PATCH 02/10] block: virtio-blk: check logical block size
Message-ID: <20200728154440.GD21660@stefanha-x1.localdomain>
References: <20200721105239.8270-1-mlevitsk@redhat.com>
 <20200721105239.8270-3-mlevitsk@redhat.com>
MIME-Version: 1.0
In-Reply-To: <20200721105239.8270-3-mlevitsk@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="IMjqdzrDRly81ofr"
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--IMjqdzrDRly81ofr
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, Jul 21, 2020 at 01:52:31PM +0300, Maxim Levitsky wrote:
> Linux kernel only supports logical block sizes which are power of two,
> at least 512 bytes and no more that PAGE_SIZE.
>=20
> Check this instead of crashing later on.
>=20
> Note that there is no need to check physical block size since it is
> only a hint, and virtio-blk already only supports power of two values.
>=20
> Bugzilla link: https://bugzilla.redhat.com/show_bug.cgi?id=3D1664619
>=20
> Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
> ---
>  drivers/block/virtio_blk.c | 15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--IMjqdzrDRly81ofr
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl8gR+gACgkQnKSrs4Gr
c8jH9gf9EntnBlm/IA+XQjmYVE6AzhflC6xpD5M+QOMtx8Gej8rEDnfv7e+8O5qL
wr7XyrYfjofwgT61Li9+QV7z8mw4hKwMUGpqUDULEHY/X6u0yegtZJiBgwAViSHw
shlmEyXroq4nlwvLOveuIj85c/56JUHpAIAUh0zhj9ZYvhyoaf6mWs5C6jz6Pp1z
wVqPpFhPNq1slTBQM9usXil/ToMZvt5FlHhFeF2KaKruugDnF5NeYg4bvOYZohNp
1zFxVPsHL2QKJQ5mhGBNoyvu4Z3XxgT093CydyLsxOoS+fgPV9l0p5hsl53VELL0
wORoNRxEjSgis0Ixkvc7AK42GUfpow==
=aToL
-----END PGP SIGNATURE-----

--IMjqdzrDRly81ofr--

