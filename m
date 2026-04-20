Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D45B3A6B9D
	for <linux-scsi@vger.kernel.org>; Mon, 20 Apr 2026 17:30:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776706254; cv=none; b=TwMtH0f93F2jGkkggwXOGAPzC69wpoOT6a7+jI6m5oh5fdEb2jfTJDrIim14QagaERhPPmf7t1ffM82ggTK++8ZSMOpvsMwyrUscL1BtpOg8e7LluO+d8iPlCFSKVhg5LSWi4oPzT6zKkBBFkfVO39T9JddEH/AJ90Wtc4ckrDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776706254; c=relaxed/simple;
	bh=Iu9f4pFdEAjgms72y4rlL1Ez4wmrP16W0GgbFusR4XQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaHmOTAFivZ+jaWYhuNJJENrNI0gEl5XUJX8OKFfHH4LY8VwXLirtdyghZ9vQ0n5azqrtuPLepg7wA4NF0dGhO6m9miMjCYEtmlnVMTMiwMtJ7RLLuHh3wZ1DL9wkZRmLkPfYXghb9TXuZJb0Z9yl/vGin7qBN8mjjh1Ub0/92U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Xeqpy5QT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xeqpy5QT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776706252;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0VomCxP0GsSzjqG7HHomtcMmJHUChcTMYDi9bqcaXh0=;
	b=Xeqpy5QTRR6Lli6mmKv6mDgJR/H0ylprTQWxG/ysG83aLCJXjpm8usQ0ywVlHTc8GEzpDi
	AP4lc45Ua5Dq/rqxIYf7Hw8oh7m8HQe4XjycveeBJdl3SDcD9neRgXwOlyUaCfZQlq2qJv
	c/jwjz7ca+NsFuGmXTUf2h+aYPLJQsQ=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-92-TVrKP6kPPWCqo4qfqPi5OA-1; Mon,
 20 Apr 2026 13:30:48 -0400
X-MC-Unique: TVrKP6kPPWCqo4qfqPi5OA-1
X-Mimecast-MFC-AGG-ID: TVrKP6kPPWCqo4qfqPi5OA_1776706247
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 868731800370;
	Mon, 20 Apr 2026 17:30:46 +0000 (UTC)
Received: from localhost (unknown [10.44.48.35])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4949F195608E;
	Mon, 20 Apr 2026 17:30:44 +0000 (UTC)
Date: Mon, 20 Apr 2026 13:30:42 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Mike Christie <michael.christie@oracle.com>
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	james.bottomley@hansenpartnership.com,
	virtualization@lists.linux.dev, mst@redhat.com, pbonzini@redhat.com,
	eperezma@redhat.com
Subject: Re: [PATCH 4/4] virtio-scsi: Support scsi_devices without a device
 wide limit
Message-ID: <20260420173042.GA405461@fedora>
References: <20260417230751.117836-1-michael.christie@oracle.com>
 <20260417230751.117836-5-michael.christie@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="OBrD8SR4k90NN6Uo"
Content-Disposition: inline
In-Reply-To: <20260417230751.117836-5-michael.christie@oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--OBrD8SR4k90NN6Uo
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 17, 2026 at 05:57:24PM -0500, Mike Christie wrote:
> When exporting a NVMe drive or other high perf multiqueue enabled
> devices we may want to pass commands from the guest to the physical
> device without been throttled for artificial device wide limits. To
> allow the user to tell virtio-scsi that we don't have a LU wide
> command limit, this patch uses U32_MAX as a special cmd_per_lun value.
>=20
> If U32_MAX is used for cmd_per_lun, virtio-scsi will set
> SCSI_UNLIMITED_CMD_PER_LUN for the scsi_device's queue limit. In this
> case there is no scsi_device wide queue limit and we only go by the
> the virtqueue limits (virtqueue limit is translated to scsi host
> can_queue which is translated to block layer per hardware queue limit).
>=20
> There's a small chance of regression where an existing user could be
> using U32_MAX and we have been setting the cmd_per_lun to can_queue.
> However, I think in the cases the user was doing this, they will want
> the new behavior where they are only limited by can_queue because
> they have been trying to get the highest queue value possible.
>=20
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/scsi/virtio_scsi.c | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Hi Mike,
Please send a VIRTIO spec patch documenting the new meaning of U32_MAX
in the virtio-scsi's cmd_per_lun configuration field to
virtio-comment@lists.linux.dev. See
https://github.com/oasis-tcs/virtio-spec for details.

The Linux driver patches need to be be merged after the VIRTIO spec
change has been merged so that Linux stays spec-compliant and to avoid
collisions between in-progress VIRTIO changes.

Thanks,
Stefan

--OBrD8SR4k90NN6Uo
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnmYsIACgkQnKSrs4Gr
c8i31Qf/S9UtAFUHn2IdkrRCWjJLQCGz0oZjxYbgvk/1l3/wgSbUn+O/suzcRXby
II6ny+/6I0y3LE4FhBfJxEgfHcfjYfTB7pWQa2jVeqiOV0v8ButVmNqXjJRDLlRc
XQ9xUl+YkLAZ0/mVlpY+nG642c+4EbY1KcCFYDGlAUQcZb4/6MhzLzYxWj86bl55
g1qFHhH+j1aOslZ4DCa592xv0cipEtDcU++9U8Ka0OlWLK1P4ZquPJTTq0tc4c08
w+PPE1w53Hnk+pc6+h9AAFCF3O8uEMDtqNI+ghAWPDmMuHa/Lh0Ylg3T/oiq3fFG
eXz4xPC8WcSc5Dqp4GcyYiqMsZP9JA==
=DstO
-----END PGP SIGNATURE-----

--OBrD8SR4k90NN6Uo--

