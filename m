Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60E744C77B1;
	Tue,  8 Sep 2026 10:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788862744; cv=none; b=bNMwvO3kzYIaBS03v/ikKh9WOit/3MLGX+H3C53ULw9mQSwQmwW121MUdbYy0jvd2M3iojS5IuEsA759VfS1ea0e3Navt73L/ObH6L1qt2tvNOnBp50GMDQ6I15Zg6yYRE8b+8fLtsm+bfpr7cQgg8UGiAG/4r5VDf5ygwAtEV0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788862744; c=relaxed/simple;
	bh=iKfJ3613huDYXifDNqBYpnje/k2HU1qDpOZKOvk41Xg=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=DQgaPHxUD8aBM84b2+YcGphu3DkWOCrmnvUZAyINer8Pw0/wWVafWdXRlJV7AwqBnGmFLnjUoo7s+/SDO9AQB91TSebaJps/gBOUt6Zbb/MlVvKYCrk0osiMJ1AXllAVTHu4sbwcIUWbehBwPKatap8WByUknwRSMns4enU341Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MagZrg0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MagZrg0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17FCC1F00A3D;
	Tue,  8 Sep 2026 10:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788862743;
	bh=iKfJ3613huDYXifDNqBYpnje/k2HU1qDpOZKOvk41Xg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=MagZrg0AJ4eodhlGoBUtgERPz22t+UhZIdwElYnaxaVgGl6/4Bb7gSXn32OTVTB/r
	 /n2PMiC3+ynQ77Bvimdajug+B2mVgN5OlQglKvwmfpUJLcudmIaWYSJLHkFuJgyHQy
	 4K4iNQtvaaE+9TPjkxJLzQkCuyvDkY/3kuJB5ELnzN1Q4WyzUWJelQcFrF4FokvHZQ
	 JxOV/32rOCswbrAijcEQDwebNdpmerrtbM3sLCJ5JAkALHVuKY6gqKdLHw0qe5P3A5
	 +rJ+jEtmq2ImS+n+OOKfbpG3M5jJU6v16+jtp/sttUyy1YJd0UWWvUWCq8u0SQOzBM
	 INN/r/WUv4/8w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 32/40] scsi: hpsa: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, linux-scsi@vger.kernel.org, cassel@kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, linux-ide@vger.kernel.org
In-Reply-To: <20260908090308.1085097-33-dlemoal@kernel.org>
References: <20260908090308.1085097-1-dlemoal@kernel.org>
 <20260908090308.1085097-33-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 08 Sep 2026 10:19:01 +0000
Message-Id: <20260908101902.17FCC1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the hpsa driver to replace all hard-coded additional sense codes
> and additional sense code qualifiers with the enum values defined in
> include/scsi/scsi_sense.h. This helps with code clarity as the sense codes
> being processed are easier to test and self-documented.
>=20
> The function decode_sense_data() is also modified to take a pointer to a
> 16-bits sense_code variable in place of the two pointers to the additional
> sense code and its code qualifier. The local definitions of ASCs and ASCQs
> are deleted too.
>=20
> No functional change intended, but the function hpsa_volume_offline() was
> checking only the addditional sense code qualifier with checking the
> additional sense code. This change assumes that the intended additional
> sense code to check is ASC_LU_NOT_READY.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260908090308.1085=
097-1-dlemoal@kernel.org?part=3D32

