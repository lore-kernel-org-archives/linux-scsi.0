Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D126CC47082
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 10:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B834A61359
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Jun 2021 10:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbhFCKPu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Jun 2021 06:15:50 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:49664 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229707AbhFCKPt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jun 2021 06:15:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622715244;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G3Y1k1YEFr6f8xxwIHr0zBttTt1tgA8IjgdQ73/jc5A=;
        b=O+3be96FRNTJoiOBfkRiqCn/Z4ia3rCJhJCwYgYHKDMvPELXCXNXxPYGSUAJKSGdGSM4dO
        hast9cCCNSLzXkDu8yQbYMFM3c/g5clFCqXTFwZGjUO5D+E/zrTn64sd2Om7E5JZS8gdVa
        /zVj32EHZxYz1vC241uD+GM6l8yiupM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-146-v9adZuvnPfCJ-9QeciswZA-1; Thu, 03 Jun 2021 06:14:03 -0400
X-MC-Unique: v9adZuvnPfCJ-9QeciswZA-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3D2BD106BAE4;
        Thu,  3 Jun 2021 10:14:02 +0000 (UTC)
Received: from localhost (ovpn-114-228.ams2.redhat.com [10.36.114.228])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CCEAA6A03A;
        Thu,  3 Jun 2021 10:13:58 +0000 (UTC)
Date:   Thu, 3 Jun 2021 11:13:57 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: vhost: multiple worker support
Message-ID: <YLirZVVeL95jm2/O@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="JCoIRIf5J1RspPIG"
Content-Disposition: inline
In-Reply-To: <20210525180600.6349-1-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--JCoIRIf5J1RspPIG
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue, May 25, 2021 at 01:05:51PM -0500, Mike Christie wrote:
> Results:
> --------
> When running with the null_blk driver and vhost-scsi I can get 1.2
> million IOPs by just running a simple
>=20
> fio --filename=3D/dev/sda --direct=3D1 --rw=3Drandrw --bs=3D4k --ioengine=
=3Dlibaio
> --iodepth=3D128  --numjobs=3D8 --time_based --group_reporting --name=3Dio=
ps
> --runtime=3D60 --eta-newline=3D1
>=20
> The VM has 8 vCPUs and sda has 8 virtqueues and we can do a total of
> 1024 cmds per devices. To get 1.2 million IOPs I did have to tune and
> ran the virsh emulatorpin command so the vhost threads were running
> on different CPUs than the VM. If the vhost threads share CPUs then I
> get around 800K.
>=20
> For a more real device that are also CPU hogs like iscsi, I can still
> get 1 million IOPs using 1 dm-multipath device over 8 iscsi paths
> (natively it gets 1.1 million IOPs).

There is no comparison against a baseline, but I guess it would be the
same 8 vCPU guest with single queue vhost-scsi?

>=20
> Results/TODO Note:
>=20
> - I ported the vdpa sim code to support multiple workers and as-is now
> it made perf much worse. If I increase vdpa_sim_blk's num queues to 4-8
> I get 700K IOPs with the fio command above. However with the multiple
> worker support it drops to 400K. The problem is the vdpa_sim lock
> and the iommu_lock. If I hack (like comment out locks or not worry about
> data corruption or crashes) then I can get around 1.2M - 1.6M IOPs with
> 8 queues and fio command above.
>=20
> So these patches could help other drivers, but it will just take more
> work to remove those types of locks. I was hoping the 2 items could be
> done indepentently since it helps vhost-scsi immediately.

Cool, thank you for taking a look. That's useful info for Stefano. vDPA
and vhost can be handled independently though in the long term hopefully
they can share code.

--JCoIRIf5J1RspPIG
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC4q2UACgkQnKSrs4Gr
c8jrOgf/SN8FF1DfEW+Dtwvpt20HUU0gXAOx1apbOvkhL8fB1MJtqCCzjQAQojd7
0vVgzQJ12W9Wu30cRQ2cgEQvihNP+iN5GDy1g1mUCSEDGnaWFO/7lwijBeaBQTas
OKi+YXofh0k6s848LaXkuvCzrheVbdG1RMW/PprCl79QW7JOPgyg98ohiX/HvNau
+jRflSMidp0KoHBtQZea2kWxoylSNDnS8B7Y4sGP2yvB5p0dOMBrRKCz/inu+lOE
NwyfFALUyapGDOK++GfmXaFpAeUGo0MjDvJV72LZXlBUM4k+rq5nzkdQEFJLJ9kZ
WtQc9sYlkJIFF00oktpL6OSGh6d0ng==
=Z74f
-----END PGP SIGNATURE-----

--JCoIRIf5J1RspPIG--

