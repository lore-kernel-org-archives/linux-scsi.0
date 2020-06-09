Return-Path: <SRS0=2p7s=7W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8154EC433E0
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:11:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5AFF32078D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Jun 2020 10:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SnXFbZiF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728587AbgFIKL5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Jun 2020 06:11:57 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:50664 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726765AbgFIKLz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jun 2020 06:11:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1591697513;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PJfpPoOS0YZpWw6ACeQgnrbC82mWkFgR6talvSJCrhE=;
        b=SnXFbZiF4Yt6vrM2iK2kJ/r4SUBXLCnP6P7FK0tn2iOJYOLg0qTzj4Yg0kgWM1OMsnmwKh
        4N0frYWl9Gzwz4az9PwyGEa7bXTZpHAX3ggrElFSiMDfN2ixaM/R27ajLpqzTaS1UD9Oxm
        EELDys0dsnCXfEvN6hVHcjN6N1/GnzM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-167-Hf3jT68SNiKlTEZNO_3gVQ-1; Tue, 09 Jun 2020 06:11:50 -0400
X-MC-Unique: Hf3jT68SNiKlTEZNO_3gVQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CFA4583DE2E;
        Tue,  9 Jun 2020 10:11:48 +0000 (UTC)
Received: from localhost (ovpn-115-52.ams2.redhat.com [10.36.115.52])
        by smtp.corp.redhat.com (Postfix) with ESMTP id E53015D9F1;
        Tue,  9 Jun 2020 10:11:44 +0000 (UTC)
Date:   Tue, 9 Jun 2020 11:11:43 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 02/17] target: separate acl name from port ids
Message-ID: <20200609101143.GA92564@stefanha-x1.localdomain>
References: <1591562164-9766-1-git-send-email-michael.christie@oracle.com>
 <1591562164-9766-3-git-send-email-michael.christie@oracle.com>
MIME-Version: 1.0
In-Reply-To: <1591562164-9766-3-git-send-email-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: redhat.com
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="AqsLC8rIMeq19msA"
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

--AqsLC8rIMeq19msA
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun, Jun 07, 2020 at 03:35:49PM -0500, Mike Christie wrote:
> The PGR code assumes the ACL name is going to be based on the SPC4
> transportID type of values. The problem is that for iSCSI we have an extr=
a
> session id as part of the SCSI port id and some fabric modules support or
> would like to support non transportID values for the ACL name. For exampl=
e,
> iSCSI and SRP would like to use the source address for the ACL name, but
> that is not a valud transportID value that you can get in a PGR request.
>=20
> This patch adds a new transport_id struct which maps to the SPC4
> transportID. In the future it will be used for PGR commands instead of th=
e
> ACL name. In this patchset it is used to export the initiator info in the
> session's sysfs dir, so tools can display the info and daemons that execu=
te
> commands like PGRs in userspace can build a session id to I_T nexus mappi=
ng.
>=20
> In this patch only srp is passing in different values for the transport i=
d
> and acl name. The next patches will convert loop, scsi vhost and xen
> scsiback that are more complex due to their initiator name emulation.
>=20
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Reviewed-by: Lee Duncan <lduncan@suse.com>
> ---
>  drivers/infiniband/ulp/srpt/ib_srpt.c    | 10 +++++---
>  drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  4 +--
>  drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  2 +-
>  drivers/target/loopback/tcm_loop.c       |  3 ++-
>  drivers/target/sbp/sbp_target.c          |  2 +-
>  drivers/target/target_core_fabric_lib.c  | 41 ++++++++++++++++++++++++++=
+++++
>  drivers/target/target_core_transport.c   | 42 ++++++++++++++++++++++++--=
------
>  drivers/target/tcm_fc/tfc_sess.c         |  3 ++-
>  drivers/usb/gadget/function/f_tcm.c      |  3 ++-
>  drivers/vhost/scsi.c                     |  1 +
>  drivers/xen/xen-scsiback.c               |  3 ++-
>  include/target/target_core_base.h        | 12 +++++++++
>  include/target/target_core_fabric.h      |  5 +++-
>  13 files changed, 108 insertions(+), 23 deletions(-)

For drivers/vhost/scsi.c:
Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--AqsLC8rIMeq19msA
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAl7fYF8ACgkQnKSrs4Gr
c8gEawgAkeinOFUIiE7aOXNyKyV2gK+P9Y1YWfSDoErYzKLn6Va3v6jd41O9g19o
m6hBCOfB78sAjgCuUy0w6qSlBKZykWtNH3xd3ODLWkBQOwCtdh0ABf/ujsSi0gqq
b/fV9SFHiJrX3ipr0qlckq93VILT6a60MwT7tbw5E/vpmFpOB1sFxjfaRqhyyV38
dDuY7+WIR0ltVdLxkDh9Tx1Pg9Zs/lF1Lu0FGRat1wIaT027rtCdYakEasNqSoCP
5z+UYaHX2t4TaURtep3iOjGjLzmvB1YJTW8kza+zUrkCDV7KhXDcFoxXIVlUHX6L
TNA54otTU8z9nawIqDC1F3Bhyz3u/w==
=F629
-----END PGP SIGNATURE-----

--AqsLC8rIMeq19msA--

