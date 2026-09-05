Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBAD43546CD;
	Sat,  5 Sep 2026 03:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788579463; cv=none; b=gOO95HMXgVwwzjIi9ArtcTgE1nwf2dWEsMqFyEUI1beFrE15XwiOa52LG7cnNLKOO2EAm2oU3sAAz9luPprk+L3muPFUpaUhL4DiFPgrn/+ymMizveJZkOootw8n57wI0b+y4tJdSUK3fRMdVueDxlgnissg5sp1OyuiXZpxjLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788579463; c=relaxed/simple;
	bh=fzcL7eNHhGDpG6FXY28UPCDIvr1z5s9StDqwpCxSMeA=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=MPi+p+mSt5C9RMfP3apXNpyAtoCWPyFM6p/1FpPaA4gD7Ad9PIn/6xs7tey3FGnUvDqr2AJWS+J/4f/OP1zc1yMvfcLikJl/MqRhtEyPzohvwGy6RTiXLt8jHqzIfkQMQOTvRNv8MXizzTNiJgFriuxGso6SeH1z1D/t7JAMooU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KAm7Djeh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KAm7Djeh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC761F00A3D;
	Sat,  5 Sep 2026 03:37:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788579462;
	bh=fzcL7eNHhGDpG6FXY28UPCDIvr1z5s9StDqwpCxSMeA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KAm7DjehA2C8XI8B37uvMRMwnvKFNqB6dSlDTIu+08viSzt23nJ3AaLENgx3mGZqg
	 /yMFI7+6wPH5gmUxOaS9oMi0Ic+Il9giNsIzqm1AHr0GkT8mzk3mgW/H4kBSLU51Bs
	 bljdjOfOzDSOaaSRCuS22CCHUo/txlKZMoZ599GWyEmTaTtRgnfWkte750iCXxqYoh
	 uAnap386S/e8JcYixOKqdi+Y5z8bccqVLIY+QcDnr3V8ArnwSadjkourO1M3KmMQWy
	 hldj8yzikjgaHkTsRKTfeN+JUMLtA1xh9sqp0/f0ddDAWWncjCRchANwZrCl/Pto5d
	 MtifcdxRnIHbw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 01/40] scsi: define all additional sense codes and
 their qualifiers
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, linux-scsi@vger.kernel.org, cassel@kernel.org, linux-s390@vger.kernel.org, "Christian
 Borntraeger" <borntraeger@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>, linux-ide@vger.kernel.org, dlemoal@kernel.org
In-Reply-To: <20260905032224.509860-2-dlemoal@kernel.org>
References: <20260905032224.509860-1-dlemoal@kernel.org>
 <20260905032224.509860-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 05 Sep 2026 03:37:41 +0000
Message-Id: <20260905033742.2AC761F00A3D@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260905032224.5098=
60-1-dlemoal@kernel.org?part=3D1

