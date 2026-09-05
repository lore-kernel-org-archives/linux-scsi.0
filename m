Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A62E8240611;
	Sat,  5 Sep 2026 03:34:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579284; cv=none; b=JMsCzOtHFZly5D15UrJA1YkvhT9L6PefBnU4yMP4yTdCd/RGVdX+c60SamCfw5NxZ99Di8DKuWYUNQ4ByIKAGZ7aiwuYOzWYEYsXaCJhmcV8Fe4002mzdJJI1CuXg6Sdbexr/Uyp2gHeciJDbFP0uSxRGEl4hBdizlTxlpMiz38=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579284; c=relaxed/simple;
	bh=N8JHXU6wRa7q+m4w1Q8gTVw7y0R17+2yhUgiKtuWJUY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sEWiL08kP/XX2s9Kz07buWYBQWZWWQRaIYXfuawMrCJQVEmq9K4uHMIqhC8HaitxL8q8Us3ib1uyfQVjiaAPbFj8vrIXWRB2knQlruqnb5qXwqGg0IvA4z0ki2nmmWi+yQJ1jOmgtmyF2LL9H+inV/L18daKVSjNsWkqkbKWLIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iKmhffYo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iKmhffYo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD4C1F00A3D;
	Sat,  5 Sep 2026 03:34:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579283;
	bh=N8JHXU6wRa7q+m4w1Q8gTVw7y0R17+2yhUgiKtuWJUY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=iKmhffYoe+LK4+RjEgHTH3tlMwn4zVh1hDY7ApLB+5I3ENVjXhV9i3VMBR/VX1j1s
	 5C0BnAwi/5+wTatjlWCPI4MuljEK33EEZzRCvVcFfQIcR+AHq8ij5YS04Bi6gbqlum
	 tGub85WAhxnkDFMyTO7u8nTsbDFxjVSLU8XygA0paMpFNZtjoU57aWhuu6s9TucKAd
	 ZTr/s+TsMN7tfqu6n9B7MprEzipDv85Ow7/b9EwSHpOmlfZaFiUNGYaU/AiqnPWAp1
	 EHJ+mUq7+YnKv8LhFwoE2OHEuyoZZYIJjTQW93kDCmPkIgUQO6eFHX96C+KCSWDlni
	 v2eduG/aH/WRQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 07/40] scsi: core: use 16-bits defined sense codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, cassel@kernel.org, linux-ide@vger.kernel.org, dlemoal@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260905032224.509860-8-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-8-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:34:42 +0000
Message-Id: <20260905033443.0AD4C1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Refactor the SCSI core code to use the 16-bits sense_code field of
> struct scsi_sense_hdr and struct scsi_failure and replace all hard-coded
> additional sense codes and additional sense code qualifiers with the enum
> values defined in include/scsi/scsi_sense.h. This helps with code clarity
> as the sense codes being processed are easier to test and self-documented.
>=20
> No functional change intended, with the exception of a correction of the
> array any_sense_failure_defs in scsi_lib_test_any_sense() which
> erroenously sets result to SCMD_FAILURE_RESULT_ANY instead of
> SAM_STAT_CHECK_CONDITION and does not sets sense_key to
> SCMD_FAILURE_SENSE_KEY_ANY.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D7

