Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75FA13195EF
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 14:01:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774533667; cv=none; b=GKGo4zHdHStY0BvXAXqKJ44uybIm38L7Gnx836WScozv9mhlw/beysQGEPBiHDLnt/Hcq4UWW2Eq5KKtIRD42dWT5cMF4BxlGjly3uFlL7edZ1LklwifS5uty2rwrFunFIBnRCU5Zy8JiChg13kWi5fp25iL2SO1fFp3zzVbwjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774533667; c=relaxed/simple;
	bh=2mozpB23xgxEgyUwDhXixVLTNPE3PHOSyUJqmiA/eTE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kAIMP1uWcbOtAVqPJmhpoFQ5m68TBOa1HPKGJPebu1k/XOSnLWfWw6fwwfrrYzBiPOWDlFLLAl0Oe8Ni9DdUly+XcRHvAAVkS6GqkZEYWxJFkyBeDilmmL33d2SH7UDCB0Hjt1dK/HJGPokYIvCH6dQvp5jdwyKEwrwxzVuovEc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=A+UXU7uq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="A+UXU7uq"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774533665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=W2N+36ApuMSHi+1WUWLxSakyItlIL+cUiW4jI9AwkuI=;
	b=A+UXU7uq0+DdTjt2sWMLtULQMgX2C53iXYGuTrdAPs543RNvP+Gl5zi6HsJKFHWmYmFrDS
	DDJ7XuRFqDQ7LN+vc3exQ1N+DXMfwIOQgmTf2hOSRJ2Cwfwt5mAfDh7ngd7WCojtyqt/fH
	EnOLzXhQ/GVQWnc+ZvSk29SXLrvQALs=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-400-mFuruvTIN2KTmyAB8GxLAQ-1; Thu,
 26 Mar 2026 10:01:00 -0400
X-MC-Unique: mFuruvTIN2KTmyAB8GxLAQ-1
X-Mimecast-MFC-AGG-ID: mFuruvTIN2KTmyAB8GxLAQ_1774533657
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id C88FA1944EBE;
	Thu, 26 Mar 2026 14:00:56 +0000 (UTC)
Received: from localhost (unknown [10.44.35.38])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id A0C74180035F;
	Thu, 26 Mar 2026 14:00:55 +0000 (UTC)
Date: Thu, 26 Mar 2026 10:00:53 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: Joshua Daley <jdaley@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	virtualization@lists.linux.dev, mst@redhat.com, jasowang@redhat.com,
	pbonzini@redhat.com, eperezma@redhat.com,
	James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	mjrosato@linux.ibm.com, farman@linux.ibm.com, frankja@linux.ibm.com
Subject: Re: [PATCH v4 2/2] scsi: virtio_scsi: kick event_list unconditionally
Message-ID: <20260326140053.GD758087@fedora>
References: <20260325180857.3675854-1-jdaley@linux.ibm.com>
 <20260325180857.3675854-3-jdaley@linux.ibm.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="ROB/BNDoRVfOr6T6"
Content-Disposition: inline
In-Reply-To: <20260325180857.3675854-3-jdaley@linux.ibm.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111


--ROB/BNDoRVfOr6T6
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Mar 25, 2026 at 07:08:57PM +0100, Joshua Daley wrote:
> The event_list processes non-hotplug events (such as LUN capacity
> changes), so remove the conditions that guard the initial kicks in
> _probe() and _restore(), as well as the work cancellation in _remove().
>=20
> Suggested-by: Stefan Hajnoczi <stefanha@redhat.com>
> Signed-off-by: Joshua Daley <jdaley@linux.ibm.com>
> ---
>  drivers/scsi/virtio_scsi.c | 15 ++++++---------
>  1 file changed, 6 insertions(+), 9 deletions(-)

Reviewed-by: Stefan Hajnoczi <stefanha@redhat.com>

--ROB/BNDoRVfOr6T6
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnFPBUACgkQnKSrs4Gr
c8g0PggAvSdvyn8Ma+AMVolR9NiFo7iRzrCdSwC8eGmbMzlqsttbbNn8/0PE1b3S
qSsvt6pdsiLyYNbmVU2b6Paip/NpVRBn7QOAJ94fn20ecszGYq6uLJarvvnd+Eo7
ppcWySqpZb+pqbi6wbZ9rv9ChjDII4MTYa5nEA4CMrLSTmI7Rv5ZMtv+u7F4ZRAG
zZtvEKHv8s1kOwhcptfMhPO/boRDuh+qD/9uLRWpXhiQUesRCHD5HTLoDxVD+8A9
qJmcH96tc94zGIIiqsiUAR+aTSTR/tzwixmDDWu0BW1SzMcwFCLQZYcfxQiSBhOi
UBzSkoFFkm8TPWNukeo+YS8lZUsRlg==
=gCH1
-----END PGP SIGNATURE-----

--ROB/BNDoRVfOr6T6--

