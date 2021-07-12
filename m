Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B40C07E9B
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CB863600EF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jul 2021 09:34:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236736AbhGLJhN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jul 2021 05:37:13 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:25670 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236621AbhGLJhA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 12 Jul 2021 05:37:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1626082450;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gdA+S+3YSWLYResZwMQhyDJvMFxlp9J0PZNAibvseEU=;
        b=JfvjU43sHnBIjOa1AuqoLRvy//hmxa2k6QxBLumg8bent0n2dKvz2cosFK4GwVZGK0kFub
        wvJ4PWyVE14LXSYBVB5nw3yg0iyOGE1gZQKu10C2Vv/HryrImOPQV2a/gA0c5qxuhapvGC
        v0EJHu9WQxn585D23RFDyZCx5oFBLvc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-588-DsTtSTTPN3Oc37bTxBzuIg-1; Mon, 12 Jul 2021 05:34:08 -0400
X-MC-Unique: DsTtSTTPN3Oc37bTxBzuIg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A7F0E800D62;
        Mon, 12 Jul 2021 09:34:06 +0000 (UTC)
Received: from localhost (ovpn-112-230.ams2.redhat.com [10.36.112.230])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 98C5B604CF;
        Mon, 12 Jul 2021 09:34:02 +0000 (UTC)
Date:   Mon, 12 Jul 2021 10:34:01 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Wenchao Hao <haowenchao@huawei.com>
Cc:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org,
        Zhiqiang Liu <liuzhiqiang26@huawei.com>,
        Wu Bo <wubo40@huawei.com>, linfeilong@huawei.com,
        yuzhanzhan@huawei.com
Subject: Re: [bug report]scsi: drive letter drift problem
Message-ID: <YOwMiYRmGYskOn7A@stefanha-x1.localdomain>
References: <7ae2293e-71a9-f68e-0bfb-b4a70ecf493e@huawei.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="fuPUrc/TQtUWERHW"
Content-Disposition: inline
In-Reply-To: <7ae2293e-71a9-f68e-0bfb-b4a70ecf493e@huawei.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--fuPUrc/TQtUWERHW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Jul 12, 2021 at 12:47:05PM +0800, Wenchao Hao wrote:
> We deploy two SCSI disk in one SCSI host(virtio-scsi bus) for one machine,
> whose ids are [0:0:0:0] and [0:0:1:0].
>=20
> Mostly, the device letter are assigned as following after reboot:
> [0:0:0:0] --> sda
> [0:0:1:0] --> sdb
>=20
> While in rare cases, the device letter shown as following:
> [0:0:0:0] --> sdb
> [0:0:1:0] --> sda
>=20
> Could we guarantee "sda" is assigned to [0:0:0:0] and "sdb" is assigned to
> [0:0:1:0] or not?
> If we can, then how?

Is there a stable ID that you can use in /dev/disk/by-*?

Stefan

--fuPUrc/TQtUWERHW
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmDsDIkACgkQnKSrs4Gr
c8hdnQf/Rs2fRaJYaSbQa32JKf0l4C/g6F+qFtbfnjBx97dzW6wb0+PPyavNMGmp
tWbISz6bIz3StkRv8oOstrJA1px9caorIZJTvXXBf036EJFtnOuZq9HF1enjybNw
RLFknEaavVlj6ay2ZkdxkIwCjGJtUcU/U6lXFGrWkwqScP6TOmhnV+l7nkcH74Kq
lffTF6TC6rqGMQNVpPzK4PueRMSuBzWL4TAol61w9o6pwGYnxCObOnQIF4QGj6cE
LKY89s8dbJG8SEN1LkUrqsd9NkV9Kd4lT67QEJd/qoWCBXFmL4mbF+ceJ5B0kL13
RM9O4ybPKVXqiWhprpNon4qvBfwo3w==
=0+Ee
-----END PGP SIGNATURE-----

--fuPUrc/TQtUWERHW--

