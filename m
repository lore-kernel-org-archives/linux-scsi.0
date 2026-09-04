Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9667F2066DE;
	Fri,  4 Sep 2026 00:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482313; cv=none; b=sHOYmvzXs7QfDIOY4+ypeX97Jxvn6gugFAcfdyinR852Wh8Qzk7XeyV3ML3cgy0vOy/X1Uoee7eWSXCvuuh7qcm2yeiz90UT07NlePyIZdNtCIaV9w1Lf2TXDvh4XoG8ZjTvpkb7rM4jAe1jzMVPIZV04+1A6BmgeLfA4mq5fpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482313; c=relaxed/simple;
	bh=0WkGZPUtqbSNBju/TLCm3DcbC5/uauDOLNTCVtjPvoE=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SGcOU0i5hSJacffAv0qIt/x1cjZULVE0beUXuHtyC8uMFtq8XJP01ZV5zwbOOl67WERMfFZEqD+cRE7cZ5F3wbvDTMTNN3qEFKeFqBCjGr6cDxw17sOnT0/k0fY6nVPMJmrwrhyO83oqQEqJNrD36r1OF0IjJIn8q5vTKJrH1h0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GTXMqKUH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GTXMqKUH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7AF71F00A3D;
	Fri,  4 Sep 2026 00:38:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482312;
	bh=0WkGZPUtqbSNBju/TLCm3DcbC5/uauDOLNTCVtjPvoE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GTXMqKUHLfh4UNXqpPVyJgkAv31CoaYfrEfjmzbnBL2ZRBZGYvc27Am36ytWu6Io8
	 rOC1rdBxX1Xj1lW8Kpcgkb1H/ly37ghcFvVa1pp+saxeu2Xwh8mjPbAJVqzElQNg3Q
	 Qt91Ln7l8jZFbpS1dE31ImkPq3Cc4aokusmyup8z9BiRLRD0ktJ2TMZuQE0xbW/vbq
	 mlTst4LHyF7YbWaVPOH/IUkRb6sHCurQUU71laf8GWvPplKdLu+LwG+DOgKkitPjRF
	 T0LYkMkPSI5Ddgn5VwbYIE7UlRPHehFpY/4AkKve57V15byd3SuPsjfsp128xScw1J
	 nw0QD6oz/X2iA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 01/40] scsi: define all additional sense codes and
 their qualifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, dlemoal@kernel.org, cassel@kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260904002644.157668-2-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:38:31 +0000
Message-Id: <20260904003831.B7AF71F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Introduce the file include/scsi/scsi_sense.h to define all existing
> additional sense codes and their combinations with additional sense code
> qualifiers, according to the most current T10 list available at
> https://www.t10.org/lists/asc-num.txt.
>=20
> Additional sense codes (ASCs) are individually defined as an 8-bit value
> with the ASC_ name prefix. The combination of all ASCs with T10 defined
> possible non-zero code qualifiers are defined as 16-bits values. The
> 16-bits value for ASCs with a zero ASCQ are defined together with the ASC
> 8-code using the ASC() macro.
>=20
> The sense key macro definitions in include/scsi/scsi_proto.h are also
> moved into this new file and scsi_sense.h is included in scsi_proto.h. The
> helper function scsi_sense_code() is defined to facilitate generating a
> 16-bits sense code from 8-bits ASC and ASCQ. The accessors
> scsi_sense_code_asc() and scsi_sense_code_ascq() are defined for the
> reverse operation, that is, to respectively extract an ASC and an ASCQ
> from a 16-bits sense code.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D1

