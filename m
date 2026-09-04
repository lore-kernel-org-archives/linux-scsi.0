Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37B3D361DBE;
	Fri,  4 Sep 2026 00:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482746; cv=none; b=NxeoptOUPMRfPgy95AvIam9TjCl02B/9Cu+9XCOdVdDZyk2C9hqAu5uPsyrTnxQm//8nvHAlkSkMlapvbHA75JAeSCFnZ+gxGMQWUyxQc/3vaThgcy2VXZ88WoTlGBh2vIyBrV1yi3/5isIcefM8EeCiQ7Z5zISIPw8vB54xnXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482746; c=relaxed/simple;
	bh=aw5H44feyUtO+ZcCCo1Geybi9d1elD2mFD2olDa6luM=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=tBQpM3bNBxseSI3a0u1RG6JFNd/+tJ10Obe9Alhqr5FD+hLkyQE7WcXzlxzBXVrFQGFJgQdTDclesfrQiiCd2hq/JJoZTJvoP6GbXBMwwyuhdayv0Kd75JlaNH2oHUf1EqJxB2mq2p7i95YGqYEW81hv4Lu7oFzJbjondGQJQco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=dxvERQdJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="dxvERQdJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 78DB11F00A3D;
	Fri,  4 Sep 2026 00:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482744;
	bh=Q9yTR+VqhNh9dYsqMffzc6wh6Sp3/emSOVqEdCyB+8A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=dxvERQdJm55IEuMfUlO2YnP7c2zALGJgyBvs0aLV50b02HYHGNtNr92Ixwbg6qGPX
	 Z6An5PFTenTJk+huAuo24ZiuU8YqpByyDNfis1go1zPJxKj9p/Lhpm9uuNAdJ1ZLMx
	 okqMZKE1yh+emfiE2UNdShmY8zO1cU3dRPmpudwyTQIRjAikEHQULnO0xUNkw1RqjH
	 pZa3h3xLziXSFseGYEF9vg4znrBeRAmvlOI7kauifLgX+FITsqjACZ7sh6EpVLsnV2
	 2ChIUSY2N34pKv9ucfpIzRNISnB3sZefxasXY1KLca+Thym+p41rD6uxiiTxc5Y9ZN
	 AH58t6TkJedZw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 05/40] scsi: prepare for using 16-bits defined sense
 codes
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-s390@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, dlemoal@kernel.org, cassel@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>
In-Reply-To: <20260904002644.157668-6-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:45:44 +0000
Message-Id: <20260904004544.78DB11F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D5

