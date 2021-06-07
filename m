Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 489C9C47094
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 15:19:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24C2861108
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 15:19:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230403AbhFGPVi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 11:21:38 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:60074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230386AbhFGPVi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 11:21:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1623079186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Ee0C+UNOPDRctMcNZqaiSmKMV76vZN+u/YStt4S+fzM=;
        b=QWTOQ31dD9HKLUuTKYDXIfMhq1yw01bdYL30npA0b8Ut8XSxfcd0jhvPsO4BOEi1RQB5kN
        n7zuCYTp9DC/l3GgQg9YQWooHT9hgiwOU69p3XmSpu5R1zks8rL2ftE2tTNVo5dzU+WpK6
        c1q0FVD2X4l+z7C1fxCeGWSVtafKQ8c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-502-fDFTTr-xOoytP0Y72mBL3g-1; Mon, 07 Jun 2021 11:19:44 -0400
X-MC-Unique: fDFTTr-xOoytP0Y72mBL3g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 3C29C107ACCA;
        Mon,  7 Jun 2021 15:19:43 +0000 (UTC)
Received: from localhost (ovpn-114-44.ams2.redhat.com [10.36.114.44])
        by smtp.corp.redhat.com (Postfix) with ESMTP id BA0D460CC6;
        Mon,  7 Jun 2021 15:19:38 +0000 (UTC)
Date:   Mon, 7 Jun 2021 16:19:37 +0100
From:   Stefan Hajnoczi <stefanha@redhat.com>
To:     michael.christie@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        pbonzini@redhat.com, jasowang@redhat.com, mst@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 7/9] vhost: allow userspace to create workers
Message-ID: <YL45CfpHyzSEcAJv@stefanha-x1.localdomain>
References: <20210525180600.6349-1-michael.christie@oracle.com>
 <20210525180600.6349-8-michael.christie@oracle.com>
 <YLjnk5GpFaCCOqCU@stefanha-x1.localdomain>
 <0c1aef53-4850-8c46-0706-9b7276716e68@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="z3oFrrR1O3xUIuMU"
Content-Disposition: inline
In-Reply-To: <0c1aef53-4850-8c46-0706-9b7276716e68@oracle.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--z3oFrrR1O3xUIuMU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sat, Jun 05, 2021 at 06:53:58PM -0500, michael.christie@oracle.com wrote:
> On 6/3/21 9:30 AM, Stefan Hajnoczi wrote:
> >> +	if (info->pid =3D=3D VHOST_VRING_NEW_WORKER) {
> >> +		worker =3D vhost_worker_create(dev);
> >=20
> > The maximum number of kthreads created is limited by
> > vhost_dev_init(nvqs)? For example VHOST_SCSI_MAX_VQ 128.
> >=20
> > IIUC kthread_create is not limited by or accounted against the current
> > task, so I'm a little worried that a process can create a lot of
> > kthreads.
> >=20
> > I haven't investigated other kthread_create() users reachable from
> > userspace applications to see how they bound the number of threads
> > effectively.
>=20
> Do we want something like io_uring's copy_process use? It's what fork use=
s,
> so we get checks like RLIMIT_NPROC and max_threads.
>=20
> I know I didn't look at everything, but it looks like for some software
> drivers we just allow the user to run wild. For example for nbd, when we
> create the device to do alloc_workqueue and use the default max_active
> value (256). We then don't have a limit on connections, so we could end
> up with 256 workqueue threads per device. And then there is no limit on
> devices a user can make.
>=20
>=20
> >=20
> > Any thoughts?
> >
>=20
> Is the concern a bad VM could create N devs each with 128 vqs/threads
> and it would slow down other VMs? How do we handle the case where
> some VM makes M * N devs and that is equal to N * 128 so we would end
> up with the same number of threads either way? Is there a limit to the
> number of vhost devices a VM can make and can I just stick in a similar
> check for workers?
>=20
> For vhost-scsi specifically, the 128 limit does not make a lot of sense.
> I think we want the max to be the number of vCPUs the VM has so we can
> add checks for that. Then we would assume someone making a VM with lots of
> CPUs is going to have the resources to support them.
>=20
> Note: It does make sense from the point of view that we don't know the
> number of vCPUs when vhost-scsi calls vhost_dev_init, so I get we had to
> select an initial limit.

My concern is that threads should probably accounted against
RLIMIT_NPROC and max_threads rather than something indirect like 128 *
RLIMIT_NOFILE (a userspace process can only have RLIMIT_NOFILE
vhost-user file descriptors open).

> >> +		if (!dev->workers) {
> >> +			vhost_worker_put(worker);
> >> +			return -ENOMEM;
> >> +		}
> >> +	}
> >> +
> >> +	vq->worker =3D worker;
> >> +
> >> +	dev->workers[dev->num_workers] =3D worker;
> >> +	dev->num_workers++;
> >=20
> > Hmm...should we really append to workers[] in the vhost_worker_find()
> > case?
>=20
>=20
> As it's coded now, yes. Every successful vhost_worker_find call does a
> get on the worker's refcount. Later when we delete the device, we loop
> over the workers array and for every entry we do a put.
>=20
> I can add in some code to first check if the worker is already in the
> dev's worker list. If so then skip the refcount and skip adding to the
> workers array. If not in the dev's worker list then do a vhost_worker_fin=
d.
>=20
> I thought it might be nicer how it is now with the single path. It's less
> code at least. Later if we add support to change a vq's worker then we al=
so
> don't have to worry about refcounts as much. We just always drop the count
> taken from when it was added.

Thanks for explaining.

Stefan

--z3oFrrR1O3xUIuMU
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmC+OQkACgkQnKSrs4Gr
c8jI/Af8DY74A2QxdTyBWRC66PcwvJSrAriaqp2KnYDCD+1vfKMLSQGqkhay/S9e
616yTR++4cVc3AcalzSHt/BRrkwTyBHtg28d2DnB1ldJganBRItTnpQeT1h57bJ9
0B5Qldud6BEJFYobEGPxdQ5vrCBPdGqyVeL6ydR9r/eihg2QtTY+Vurh1ZZ86tqn
r0VlGes79sP6m6Tg0n7kgIsvmDq3Yg5m0/8iLc/p9Sh1vFkdD23Ncydxpec/EeGd
ehiX3HFlYAn2XYxb82U5uDLD0LB2ODnx+YX2gAn99aBdR1ovh0COMH5Q7ujJhQVD
1ihEXRZuN+5vVGpC9DD/wIEtd+E44A==
=ynTO
-----END PGP SIGNATURE-----

--z3oFrrR1O3xUIuMU--

