Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF6EA405ABE
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 12:46:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775047596; cv=none; b=IIZRYfKJCAeM0pgPV2aX4ievrHTHYi5M9RN/6JE0NJReIQEo0UtlNEHpWSumYq8DxsmcxnzvF33bMVizaZ0s/8qzPI2Mnt1+jpsyuk18p08xqx37MuuJ8ikRa13bQ1fwG+z1HwujFMqpaeVQ2iUUs+m/wKq/Cp9WdkeIBKqmIuw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775047596; c=relaxed/simple;
	bh=hfD8fH3///Shq/TJdRyVkVuDmSHrOXrT6aof5Ko/9hQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=ArJpE/b7c3zNgVONXi1Un0AsSLxkie0ry0uncBDzGnqgKCEkNl9tfnEvIFmJsQAnUOg+jw0RmbV7ZXO1PKlvbNGiQVelw5P7aVO6DC8FuxuQf39rTjAbZVyyd/mIADTVAZN/K82MkyoNcjmATumaJPuyNuIlhTnfehMHAtGCIwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GoPhI2F4; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GoPhI2F4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775047593;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=hfD8fH3///Shq/TJdRyVkVuDmSHrOXrT6aof5Ko/9hQ=;
	b=GoPhI2F4dgp/5On+LIchJSHZSVBm/Z3QMVbfj4Rg4aq8af8/IWjHEeTImAkbwnWniwkir4
	HwVTlmjSau2nDow7J+xKI+m78bjeGHHeXVk5133j35Cro7bMSMvP1sGMQZZjKFy95R20LR
	beqqTCqGE1ygbneYoYlqlMnwsmmwLpk=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-586-IG5HFOsPP_mIEbD_537igA-1; Wed,
 01 Apr 2026 08:46:30 -0400
X-MC-Unique: IG5HFOsPP_mIEbD_537igA-1
X-Mimecast-MFC-AGG-ID: IG5HFOsPP_mIEbD_537igA_1775047589
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 06619180060D;
	Wed,  1 Apr 2026 12:46:29 +0000 (UTC)
Received: from localhost (unknown [10.44.49.94])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 53CD51953947;
	Wed,  1 Apr 2026 12:46:28 +0000 (UTC)
Date: Wed, 1 Apr 2026 08:46:26 -0400
From: Stefan Hajnoczi <stefanha@redhat.com>
To: target-devel@vger.kernel.org,
	"Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: LIO PERSISTENT RESERVE OUT PREEMPT spec compliance
Message-ID: <20260401124626.GA266484@fedora>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="TwCPRSYxZP1tcyIW"
Content-Disposition: inline
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17


--TwCPRSYxZP1tcyIW
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,
I've noticed differences in behavior between LIO and HPE 3PAR storage
when handling PERSISTENT RESERVE OUT commands with the PREEMPT service
action.

I'd like to confirm what the behavior should be and will send patches if
necessary:

1. Not ignoring the TYPE field when removing reservations

LIO always checks the TYPE field for PREEMPT and fails requests that
have an invalid TYPE field value (e.g. 0). PREEMPT can be used to remove
registrations (rather than preempting reservations) and in that case
SPC-6 5.14.11.2.5 Removing registrations says "b) ignore the contents of
the SCOPE field and the TYPE field". My interpretation is that LIO
should not check the TYPE field here and it is currently not
spec-compliant.

I compared against HPE 3PAR storage and found that it completes the
command successfully.

2. Removing the I_T nexus registration sending the PREEMPT

When handling a PREEMPT that removes registrations (rather than
preempting reservations), LIO removes all registrations with the given
service action reservation key, including the I_T nexus sending the
PREEMPT.

I think this behavior is supported by SPC-6 5.14.11.2.5 Removing
registrations which says "a) remove the registrations for all I_T
nexuses specified by the SERVICE ACTION RESERVATION KEY field". In other
places the spec explicitly says "except the I_T nexus that is being used
for the PERSISTENT RESERVE OUT command", so I think LIO is correct to
really remove all registrations for the given key.

Note however that HPE 3PAR storage does not remove the registration for
the I_T nexus sending the PREEMPT, so there is a behavioral difference
between LIO and 3PAR.

Thoughts?

Stefan

--TwCPRSYxZP1tcyIW
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEhpWov9P5fNqsNXdanKSrs4Grc8gFAmnNE6IACgkQnKSrs4Gr
c8ikiAf/WoaYZJjBF+115h2gMN46ygraKh3RQfIcrU2HPIZuTfFo3gaIwrcJGOgP
b9orXoCnjaWL3aMmAkK8PjdHKcKhTuWs2ZxL24uzDIR/zRaWA3QCNc/CZBBQB8E6
wlnDAalS5Om6RlxCSwqE7rcplaQMhIUvI7pqXpzzHcYBhYTXr/75egDfQhbFvxdX
4AyJbtnRSbEZnSiZj56pCxhqSpPugDc6p8frkJ8H2OB6KeGivWjxcZzOYfHJFSxP
S1DjsY5XW4EX2uuOzeTnqrKQGc7UfqnPytgbx4Waa8W4DX6HD6hHWqf80pnBujVK
OaxXv4KxoYR2ws1rZni8VuIA6BhGcg==
=coZs
-----END PGP SIGNATURE-----

--TwCPRSYxZP1tcyIW--

