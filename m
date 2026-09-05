Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47152334C05;
	Sat,  5 Sep 2026 03:33:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579216; cv=none; b=BAM164bdB+M1bShEp+37DpexjhJ64WLw8W2GdevCE2lslospRnL7OpT6oe+exJ4ma2oVAXMK6FFSL1KerE59I/9P5KpLOzJb9PqhQeBld2bPSvWWRRCMvKeQDQLB9qhGoKPYGEBMhwnBiYQBGcBen0L0YqTjbmlIrTlrZDJNnxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579216; c=relaxed/simple;
	bh=/hczANAE4dKh0EFTm57TdebwMSr95NN40Q76d04G14k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=F136sw10sbGOyZ5Hge5jH1JwnveRvBmJ24r/Npqtvx82kAP5Qbjy7OfhNMwjQKxijWc14i19YCQhEo/g0gpNPp/M4QLhI4k5i4U1+hrRLNKGwBG1aswt9aLa2QKidToRV8HXLNEga97A2fYRTZZA3Q/RR2VvWe/baRcV3GLCmlM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Qr8ljZ1L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Qr8ljZ1L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 600BA1F00A3D;
	Sat,  5 Sep 2026 03:33:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579214;
	bh=J/gALbFjLIBM5FjmnaJDRt3/XliQDpM+TlMisK+7uKo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Qr8ljZ1LoeC1x6jkZAB9okNJCRrpfqBQijQs8/pMRFptvZApMPs54+HIRjI5L603b
	 dMng2aAoqr1yB8uBZLlUYSLj22Xq1BEOoXMhkXGgOl10wi/YFVqmamiwLynvzT9po1
	 01j6em79fVZYEnrRYtGFW4ugM34IS4tPZ8nPSkhFApFnwHptOg49u8EoYndJgSosoq
	 oFsTFRXe2aj8WooQevAq0becdQIy2Jx/VpWAZ0EVAsnENR1IFVLaNDQspsx5lAP2bb
	 DA37bBsyj2ju1kTadPwS94uY7ouNk4E4PY2Hq1Y297dosZf7thnPrvjNjTzVTs1fbn
	 C/l04hpRGjtPw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 05/40] scsi: prepare for using 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Vasily Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, cassel@kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>
In-Reply-To: <20260905032224.509860-6-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:33:33 +0000
Message-Id: <20260905033334.600BA1F00A3D@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> In preparation for handling sense codes and their qualifiers as a single
> 16-bits sense code field, with the values  defined as macros in
> include/scsi/scsi_sense.h, modify the definition of the structures
> scsi_failure and scsi_sense_hdr to introduce a 16-bits sense_code field
> as a union with the existing 8-bits asc and ascq fields.
>=20
> This temporary modification allows accessing either the asc and ascq
> fields individually, or their combination as the 16-bits sense_code field.
>=20
> The helper functions scsi_sense_asc(), scsi_sense_ascq() are defined to
> allow accessing the 8-bits ASC and ASCQ values from the sense_code filed
> of struct scsi_sense_hdr. The helper functions scsi_failure_asc() and
> scsi_failure_ascq() provide the same for the sense code field of struct
> scsi_failure.
>=20
> The helper functions scsi_set_sense_buffer() and scsi_set_sense() are also
> added to wrap calls to scsi_build_sense_buffer() and scsi_build_sense()
> using a 16-bits sense code aregument instead of the 8-bits ASC and ASCQ
> arguments.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D5

