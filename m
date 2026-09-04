Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45A21233949;
	Fri,  4 Sep 2026 00:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788482640; cv=none; b=rV8ZTMki9pn8YClWUC/fnnIAdiyVl9fTmqwHgxJWfGs6f1d+cN7+Ns5Z65ih2SPTx0wl92MwZT8FKUIU5ew4553nSKUGUbuUQTkGhFlBMNEvbu7kBbmw2+TSEEKoO8jKIymMGtiUz04OyBbRvreMSKEcYE1Lyuwr8kQfmeQmkhs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788482640; c=relaxed/simple;
	bh=0QGwyvdFnYbp5aXTrUKOxkCDhoU59qAgmnZI1sQZcMc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=STj4rHJ0nm3BDx9VLXng/gmEDSKY8+DKCi7eir0P1sG6FB5x2nT+qMUCq26BEv1g5UeRGJm+vVuOy3Wo6rhNrXkGinDQkbQYliR/KBFirTQKtwh9E7CeFlLEYTMtjOobMOu4D6+H6BBuVYrR4efh99rR5QY4EL0eEWeGo7wqqYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JHuAKN3L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JHuAKN3L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 764F61F000E9;
	Fri,  4 Sep 2026 00:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788482639;
	bh=0QGwyvdFnYbp5aXTrUKOxkCDhoU59qAgmnZI1sQZcMc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JHuAKN3LhhNjNziNQvdieOiAUtEodsV0enVVOceGMqG9YWqLoWSaCONgpaYRP31ZT
	 A3KJHOlI/eAevoL7i0Hgk9s+9PAi0W/Sj0YsQ0fPTcxZyY/S/Q8Q8uvZxxNWFxYvqw
	 AdV6NjGjHqIEws64iHKfSi3YNT0zSO5xt4QD/dYdKRe2ZN/odt/6MzSZTmfG1RBLLS
	 aWyTz90SdGDLNN9pWaE4/yfSagEWg2wz06g+iD+vFkcreOw8GlVa/VGc7rPB0qdAQc
	 dDvYFEIbeTTAYX+XkrYUCpDAI2EkOy/DzbrEK6sO38LETynT3T8pTP06/9tsGrcpUG
	 i14FHYLNbTltA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 04/40] scsi: rename sense field of struct
 scsi_failure
Reply-To: sashiko-reviews@lists.linux.dev
To: "Damien Le Moal" <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, "Vasily Gorbik" <gor@linux.ibm.com>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>, linux-s390@vger.kernel.org, dlemoal@kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, cassel@kernel.org
In-Reply-To: <20260904002644.157668-5-dlemoal@kernel.org>
References: <20260904002644.157668-1-dlemoal@kernel.org>
 <20260904002644.157668-5-dlemoal@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 04 Sep 2026 00:43:57 +0000
Message-Id: <20260904004358.764F61F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Rename the sense field of struct scsi_failure to sense_key. This makes
> it clear that this field stores the sense key, and also unifies this
> structure field names with the names used in struct scsi_sense_hdr.
>=20
> To be consistent with this change, the macro SCMD_FAILURE_SENSE_ANY is
> renamed SCMD_FAILURE_SENSE_KEY_ANY.
>=20
> Of note is that the definition of the array any_sense_failure_defs in
> scsi_lib_test_any_sense() is modified to change the initialization of the
> result field to use SCMD_FAILURE_RESULT_ANY and add the .sense_key field
> initialization to SCMD_FAILURE_SENSE_KEY_ANY to match the test target
> case.
>=20
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260904002644.1576=
68-1-dlemoal@kernel.org?part=3D4

