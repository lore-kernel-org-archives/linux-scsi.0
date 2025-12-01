Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBCFC31CA68
	for <linux-scsi@vger.kernel.org>; Mon,  1 Dec 2025 16:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764606197; cv=none; b=DCdp2ktwWkRL9o5DehSQw8zjDkObtdUlo8ZZQ4IGhNUxIb2Oo48nEvi0KPPwDlfe5XHNFGR+2GQOB8MQ4UDqCTgLJ/UD2Tne/0axjFJxUr4q97Rxv1h1rNhEXghVzWWvmfDOB9ECfYj16bXhVUp7AclDHBuS4B2/OUEZcVaInMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764606197; c=relaxed/simple;
	bh=qpQ8JUDKVag2flq6GT4xQY+M2quse0eIopRNEPLoZ2M=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S8pvMcQC166hJbGhHkCwh5kOr68Tpo1GT+OlayJdv/mmSQL7CNstSANeGay+9sx5DYODQNp22rpIgfv9ut5eKRR9nRTdljebd7dcleulIz47hhtmgd+yRBa8A/Vr9eN0Jdq6lMtGTseknVXlZ9XqSS4YPwCUme3181poP2KmDgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=OxJl8kFh; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="OxJl8kFh"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764606193;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pS2mQ5xbofpQvFILM7dJqGHd9p4HpT8s5pC6EbcT+hk=;
	b=OxJl8kFhNqkcQWVqHu2Olc2I1qQobLnzRQb3Y/NQyubzvdODdedhIDUMP1a7KEfKhY22Av
	SP25XbZWdGXlURWC8ZTN3me2vBuPojpEU8FH0JfyhFEoMRo//48r7DeScb7R0CbmekiBR2
	bb2c/iekZRf6uWKV/AjjVcrvO3j0DT8=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-57-31z9c91cOCa-rtg8RH6E0g-1; Mon,
 01 Dec 2025 11:23:05 -0500
X-MC-Unique: 31z9c91cOCa-rtg8RH6E0g-1
X-Mimecast-MFC-AGG-ID: 31z9c91cOCa-rtg8RH6E0g_1764606183
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE42A180057A;
	Mon,  1 Dec 2025 16:23:02 +0000 (UTC)
Received: from localhost (unknown [10.2.16.172])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D83941800877;
	Mon,  1 Dec 2025 16:23:01 +0000 (UTC)
Date: Mon, 1 Dec 2025 11:22:55 -0500
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 2/4] nvme: reject invalid pr_read_keys() num_keys
 values
Message-ID: <20251201162255.GD866564@fedora>
References: <20251127155424.617569-1-stefanha@redhat.com>
 <20251127155424.617569-3-stefanha@redhat.com>
 <20251201063649.GB19461@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="YKftHGuwZht4hbb7"
Content-Disposition: inline
In-Reply-To: <20251201063649.GB19461@lst.de>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93


--YKftHGuwZht4hbb7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Mon, Dec 01, 2025 at 07:36:49AM +0100, Christoph Hellwig wrote:
> On Thu, Nov 27, 2025 at 10:54:22AM -0500, Stefan Hajnoczi wrote:
> > The pr_read_keys() interface has a u32 num_keys parameter. The NVMe
> > Reservation Report command has a u32 maximum length. Reject num_keys
> > values that are too large to fit.
> >=20
> > This will become important when pr_read_keys() is exposed to untrusted
> > userspace via an <linux/pr.h> ioctl.
> >=20
> > Signed-off-by: Stefan Hajnoczi <stefanha@redhat.com>
> > ---
> >  drivers/nvme/host/pr.c | 4 ++++
> >  1 file changed, 4 insertions(+)
> >=20
> > diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
> > index ca6a74607b139..156a2ae1fac2e 100644
> > --- a/drivers/nvme/host/pr.c
> > +++ b/drivers/nvme/host/pr.c
> > @@ -233,6 +233,10 @@ static int nvme_pr_read_keys(struct block_device *=
bdev,
> >  	int ret, i;
> >  	bool eds;
> > =20
> > +	/* Check that keys fit into u32 rse_len */
> > +	if (num_keys > (U32_MAX - sizeof(*rse)) / sizeof(rse->regctl_eds[0]))
> > +		return -EINVAL;
> > +
>=20
> We use struct_size to calculate the size below, which saturates on
> overflow.  So just checking the rse_len variable returned by the that
> would be nicer.  Bonus points for using sizeof_field() instead of
> hardcoding U32_MAX.

Will fix. I don't see how to use sizeof_field() here, but taking
advantage of struct_size() already improves things a lot:

diff --git a/drivers/nvme/host/pr.c b/drivers/nvme/host/pr.c
index ca6a74607b139..ad2ecc2f49a97 100644
--- a/drivers/nvme/host/pr.c
+++ b/drivers/nvme/host/pr.c
@@ -228,7 +228,8 @@ static int nvme_pr_resv_report(struct block_device *bde=
v, void *data,
 static int nvme_pr_read_keys(struct block_device *bdev,
                struct pr_keys *keys_info)
 {
-       u32 rse_len, num_keys =3D keys_info->num_keys;
+       size_t rse_len;
+       u32 num_keys =3D keys_info->num_keys;
        struct nvme_reservation_status_ext *rse;
        int ret, i;
        bool eds;
@@ -238,6 +239,9 @@ static int nvme_pr_read_keys(struct block_device *bdev,
         * enough to get enough keys to fill the return keys buffer.
         */
        rse_len =3D struct_size(rse, regctl_eds, num_keys);
+       if (rse_len > U32_MAX)
+               return -EINVAL;
+
        rse =3D kzalloc(rse_len, GFP_KERNEL);
        if (!rse)
                return -ENOMEM;

Stefan

--YKftHGuwZht4hbb7
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmktwN8ACgkQnKSrs4Gr
c8gLeAf/dAZo5nwpdpojnIzrv8GAq8x+o/SWFa1b7FBbj7Lc0vzxQD23XMORjCvm
sS28Gf6duxGp88k2clDV3MELwZppYSXAPVyAM+/nVJzjrtA9F0FAcfyhLSrL4RzY
mXLIrOrmnr6FxHTbDj6USxHsRk4h1tQzOKDwaej5Xhb1bqZdmEHkViGwVMcCfJJM
tjKO1veWKq7p7hBjMzTsD3fABOMXKZqEZmac9fWI3X0KrwKcN9WcgHFnvV4l46M1
7HQbxqPS8nbPf3eD98p5ZNUVHf0cbJ/pac8ztqLvdr7GD19lnmZcHBjUKmNTh8sM
ibzD4lqyv4wHEIj/EmYShAzH+zIWZA==
=S0Z0
-----END PGP SIGNATURE-----

--YKftHGuwZht4hbb7--

