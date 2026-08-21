Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9551B485CD1;
	Fri, 21 Aug 2026 14:32:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787322776; cv=none; b=ehnOfLLtXBIyH+otJuwh2RC+hJseLBoiBbu69motsBEgjNl+CHL5HuYWGgnjhhMKaTc31MfAvgmSx1eWgBfPMdDD3iN2c95bjpgdYPiuGyy1AoSg22ATzv/2/mPkNmU3bN7Bu8StTQhj/NPEDJhHJ0ppHLB3PqLV+kn/MnHuuR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787322776; c=relaxed/simple;
	bh=tMX0LAN+Cw/7fNsR6m6pb33Jzr2cNh9pjXdAu4X+e30=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=sLuaWPkFglBI5Mvk30VB0J2xVqjuo860cvBgcztVmZ1JiszFk8sNa3J3AyZhK3eGzf4g2x/eqV3qhMCTl8ERHOZlUlwmB1EgcUmjMfIfXAN1Xt/aej5ACtew50+W+DDnEJakQfj4Q39rPzzQdFeuoVXYp8FOIy96vesbWYxZHz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X5NBH1As; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X5NBH1As"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5663A1F000E9;
	Fri, 21 Aug 2026 14:32:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787322761;
	bh=tMX0LAN+Cw/7fNsR6m6pb33Jzr2cNh9pjXdAu4X+e30=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X5NBH1AsKCFjkhS7KvsyfRF/uTavYvLT89hMaoFOZ/YLQK/ZPa+6hKq76tBrQXKnw
	 +MxKfbdhQJx27doJoSgObYoXBOFDmU1FRp3SPN3UnBblTRrCocoivzPrux0mNkALek
	 aM5CW8F2h6b/A/oK6E4BAtSZt3T33hyDzAyW0/D1LMQkI//dXG1Ph76xuOflukdBSm
	 KA1msBJ0PdBhqGyWOVnlVAYtUM3YuJPmjybuvNfEoXou0Izd2UJsW1zuvmK3bxQtbj
	 Q6S2e0j3+MO1fx0dq0yh4i8y1lk48rSYbMS3qtd7X0rvypQiVxmk3Sg+lZ4RwcDdSU
	 bMUczoqO2DCFA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] driver core: rely on put_device to free dev->p
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260821142414.150892-2-djeffery@redhat.com>
References: <20260821142414.150892-1-djeffery@redhat.com>
 <20260821142414.150892-2-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 21 Aug 2026 14:32:40 +0000
Message-Id: <20260821143241.5663A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> From: Tarun Sahu <tarunsahu@google.com>
>=20
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260821142414.1508=
92-1-djeffery@redhat.com?part=3D1

