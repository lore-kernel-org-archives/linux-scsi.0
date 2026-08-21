Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C251C495519;
	Fri, 21 Aug 2026 14:38:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787323112; cv=none; b=Czyfr/FPb0R4pPM10vlQv9v86VBz71WuK80O/9MfI7AabTCk9VKfcRFhTSDEXl+fxWwlAOLunNFetZaYuSeus4YB9/swDCTOvq/cNHkroW8hbdg3z2hGAyuZ/eM7stJCO8F2pKA4lJD43V781vmPIleIAruAbRTpJGV5VVBcibM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787323112; c=relaxed/simple;
	bh=AqXcGSV7K5PhCTF9WKJifu6j2fCsEeEKdbuGUqknBGs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=gRzqiO08iOfuGqZiV0vvwEijglBg8ubPDh1z1fmFoV8mnhmgDipAUP1WvydAFz7/5MMSHOazEU4d4+Ow5UbNRqj2mqTvz5gOGbCrwd3fsDXje8AbOxCIlWS4/UVXuIarzfjjmXGZzW1wQx+9O9KdZ4wipSWSVTzTp04Z00bhMcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QcDeoG9j; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QcDeoG9j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB171F000E9;
	Fri, 21 Aug 2026 14:38:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787323107;
	bh=AqXcGSV7K5PhCTF9WKJifu6j2fCsEeEKdbuGUqknBGs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=QcDeoG9jO/9PH7QmRGr+qnUNLRWArDVEbVoqFqDqNlWkNA4BJEdfQQ3BgONQ1ENQS
	 qdTr62OLTLYZjP820D2UTtHmbfqjvBbt4NG3RVQgVmwuptT19R1o14gY65wp706C9K
	 cMcnU97WJZAi9uPuB4tFBu6cs6RsoMQbIdHTyZN6q/3pd05MT3iJSS3BH21b63UwIS
	 JrLXzy9343isYLPW4zMkEly2AQW4Z6SIHukeLoLqMJAp6tXM8xz7heY6Dr3lqjjMEL
	 U5XR2X1Os+ebALQacr9OB6rP4uMW3qeUaT5CYeJ+VoDIyOpRsHjqOLcKnO1dKG6rL4
	 oYLCyuEmrIhvQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6/9] driver core: async device shutdown infrastructure
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260821142414.150892-7-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-7-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:38:26 +0000
Message-Id: <20260821143826.CCB171F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Patterned after async suspend, allow devices to mark themselves as wanting
> to perform async shutdown. Devices using async shutdown wait only for the=
ir
> dependencies to shutdown before executing their shutdown routine.
>=20
> Sync shutdown devices are shut down one at a time and will only wait for =
an
> async shutdown device if the async device is a dependency.
>=20
> Enabled by default, async shutdown can be explicitly enabled or disabled
> by using the kernel parameter "core.async_shutdown=3D<bool>"
>=20
> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D6

