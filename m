Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 988EF321420;
	Fri, 17 Jul 2026 03:04:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784257474; cv=none; b=nm0otZnJYw4nko1s/pEQt3U6UePPmHp7YUlgam0EyxjBqdRN/IH1mvyWsYQbKUeFHZga1jJc68Zj7ct8m54c6/fBT3m03VdqGo48YXDtvDd7BXveW0lx/mRQuPEHO1ELX6StdGHFDOV+J8U0fR5wnW9aPZ+DlnTl6MunB0Zk1Bc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784257474; c=relaxed/simple;
	bh=bz/kaTWisRRLdZ6jhbW0txfYiVAn5z3PlokOq6ruI2k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=m4XdpMkhgqIA9Clsud8kyQ1OS5AaFk/o6KMNERGF4mPIB96y9Bv/psGJ3lBdK3dCJZP8sU4oNnwKihd86cx8wn3G0j+Wm/HO7QbMSQH6tt/j/tHe/hA7IrIFcRCymrFrCmqG+/wnosIdyKOi6jmFOSUAbFOXYQAjAoOJa0v/ufE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KuoJChWN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KuoJChWN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C65271F000E9;
	Fri, 17 Jul 2026 03:04:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784257473;
	bh=bz/kaTWisRRLdZ6jhbW0txfYiVAn5z3PlokOq6ruI2k=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KuoJChWNRs6OFajXtpMOxOUEoY9NXp0NHpxK0T1uEw4q1znp6h0OsBOosoMeFdMKX
	 y5ArAf40JZbM2E64PhC8vm3H68AeKaULAm1FTGaHfJeqDPZ/6W+eVayJTog+er3ru1
	 tEOG2a9/IyfFH0uVzzGkO28/8TEel3flLMtPr9xiWNhrlBQ1OBw1CcHhaCQhH+PogE
	 KG37NeYc4l72KQtI8FFmIq5In2gHZOV9o2h/04T6BPMCJ0TvB/ihoV+wME8h2qyR7A
	 y2FFLNNct00TaDytdS1VRDFvW9B2INz2KVLlVcGuju1FTjWE1Z35kl/3CweCMASQM7
	 1xUDyn78rUYXA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v19 1/7] device_core: rely on put_device to free dev->p
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tarun Sahu" <tarunsahu@google.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260716230411.2767394-2-tarunsahu@google.com>
References: <20260716230411.2767394-1-tarunsahu@google.com>
 <20260716230411.2767394-2-tarunsahu@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 17 Jul 2026 03:04:32 +0000
Message-Id: <20260717030432.C65271F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> device_add allocate private_data for device and assigns to
> dev->p. If device_add fails in later steps of the function,
> it cleans up this dev->p which is not necessary because In
> the next call, put_device free it anyway (if reference to
> the device is 0 which will be unless someone concurrently
> get the reference to this device).
>=20
> This avoids unnecessary races introduced in system. After device
> is added in device_kset->list by device_add and later steps in the
> device_add function failures occur, it will free dev->p manually,
> while in between there might be a user of device_kset->list will
> take reference to the device just added by device_add. and might
> try to access dev->p. So relying on put_device to free dev->p
> prevents such problem.
>=20
> Signed-off-by: Tarun Sahu <tarunsahu@google.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260716230411.2767=
394-1-tarunsahu@google.com?part=3D1

