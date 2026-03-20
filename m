Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C768236EAB1
	for <linux-scsi@vger.kernel.org>; Fri, 20 Mar 2026 11:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774005247; cv=none; b=Uaq9/YEhIIkAZmO0qJoO3jw4NnHs18QM969IFROdYfgD9XbkFJItS5Nrvi8J2crxyDS9W03OxUkKw0fh8aZp27NbSwqnFz23Se6r4wp3K9bu8ivfMVxqJUphPHVsJd3PaOf1GZ6kRAPt03pigUI6tbpy7ZE0t+NonuK/I8rrUZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774005247; c=relaxed/simple;
	bh=1hj72cRPqwqfvLjJnaBh/cOjWaZYnOWHm71Pw/s74CY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eo1Aej2FbEuy1lpD6YjhES+5AqWzAWR7VBiPegf3Q5f/HtfXJEyZflYTBU48D3vMcwZa6ca71CDqgAZslsGGKo/8xIeCcYGfVOz4beLF5SfXAI3GjdOunpHKwYNb2L1TtRLs8F9lMTjTwSVzQJ/hLY2bL2K51rA4HfPV9cq1T1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GPwdNdDi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GPwdNdDi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774005244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=3NQZznosVl48MCXOoUyc53RSVU44S4P9FpUYqwm8D6Y=;
	b=GPwdNdDi0hIxB+Q3+lyJoRIn58pDs3eazpa6TUpKEV16eLO0swCjUjU16qQHhg2vmJz5+w
	+CpMeUPLR9Pk+xnzoPcoXZBuTE530v+ToCpUSTnEKlUtJIn/x96LHMUN9NOZHuhx8FoVBI
	yJoBU1YuJQG+URHbFk3BW/TfDlEPsfg=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-74-wjq3BzQaN8eowOVq2MuslA-1; Fri,
 20 Mar 2026 07:14:01 -0400
X-MC-Unique: wjq3BzQaN8eowOVq2MuslA-1
X-Mimecast-MFC-AGG-ID: wjq3BzQaN8eowOVq2MuslA_1774005240
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 905BF180049D;
	Fri, 20 Mar 2026 11:13:59 +0000 (UTC)
Received: from localhost (unknown [10.44.33.200])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3719A1955F21;
	Fri, 20 Mar 2026 11:13:57 +0000 (UTC)
Date: Fri, 20 Mar 2026 07:13:54 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Joshua Daley <jdaley@linux.ibm.com>, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, virtualization@lists.linux.dev,
	mst@redhat.com, jasowang@redhat.com, pbonzini@redhat.com,
	eperezma@redhat.com, James.Bottomley@hansenpartnership.com,
	mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v3 0/3] scsi: virtio_scsi: move INIT_WORK calls to
 virtscsi_init
Message-ID: <20260320111354.GA227028@fedora>
References: <20260316153341.2062278-1-jdaley@linux.ibm.com>
 <yq14imbkzxr.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="uagbqTySvoIPF7sU"
Content-Disposition: inline
In-Reply-To: <yq14imbkzxr.fsf@ca-mkp.ca.oracle.com>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12


--uagbqTySvoIPF7sU
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 19, 2026 at 10:19:00PM -0400, Martin K. Petersen wrote:
> > This patch avoids a kernel warning that may occur if a virtio_scsi
> > controller is detached immediately following a disk detach. See the
> > commit message for details. The following are instructions to
> > produce the warning (without the proposed patch).
>=20
> A few issues were flagged. Please review:
>=20
>   https://sashiko.dev/#/patchset/20260316153341.2062278-1-jdaley%40linux.=
ibm.com

Hi Joshua,
I am responding to the following sashiko review comment (haven't figured
out a way to reply in the web UI or via direct email to sashiko). I feel
responsible for this one since I suggested the change that sashiko is
questioning. I haven't looked at the other review comments, please
triage them yourself.

=46rom Sashiko:
> Does this code violate the virtio-scsi specification?
>
> The specification mandates that a driver must not place buffers into the
> event virtqueue if neither VIRTIO_SCSI_F_HOTPLUG nor VIRTIO_SCSI_F_CHANGE
> has been negotiated.
>
> By completely removing the VIRTIO_SCSI_F_HOTPLUG check without expanding =
it
> to check for VIRTIO_SCSI_F_CHANGE, could this unconditionally populate the
> event queue and cause strict implementations to reject the buffers or
> transition the device into a broken state?

No, this is a hallucination. The spec does not mandate that a driver
must not place buffers into the event virtqueue when neither
VIRTIO_SCSI_F_HOTPLUG nor VIRTIO_SCSI_F_CHANGE has been negotiated:
https://docs.oasis-open.org/virtio/virtio/v1.4/virtio-v1.4.html#x1-4510006

The event virtqueue still serves a purpose when both
VIRTIO_SCSI_F_HOTPLUG and VIRTIO_SCSI_F_CHANGE are not negotiated. For
example, see "Asynchronous notification subscription" and the
VIRTIO_SCSI_T_ASYNC_NOTIFY event type.

Stefan

--uagbqTySvoIPF7sU
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmm9K/IACgkQnKSrs4Gr
c8i3aAf+NF/UZTnAHGOBAx2EqnAXxT3SWR5a9K3rGuKzj4HOYpkhHfyad0jaWDM9
NVcAk3kH8Lywbca/je3kbfJDUfoNPTs840drpeBh89s2GRhKLDKxL8GLam8XYCg6
l35OzwEWtCowWpBGyoZ73sLUXniRFdQHhtWyMYyMv4jjwgyWTJdOXCU8pXtL6lPV
XjvV6KaUB8d9yfuELeT78uXAXUDTgkTMH9t45NHsxtX+fbcECyGUhtz+6cRlOohl
Xosbeg5ZP6loPqUU3HpfMqb5BlgVyNRrybYQ7dZAkJ90tCzN61DsXRMInpUaHuaz
ZWGl5ilkQxcE41/JX0t/qMhJrLCkQg==
=JMnL
-----END PGP SIGNATURE-----

--uagbqTySvoIPF7sU--

