Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5EFF4A92E6;
	Wed,  2 Sep 2026 17:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788369395; cv=none; b=VmsPUwW2/I9qEItvfMFv62AzJkqxtvrVMLM7HxXGgF/NgEjWwEgrrL461lJSe0WufBobTSwVDmoYbRxMrPPTnIY/zn/kG5vAP48HF++WaqbbEqMhMrEZ7AWLweu2TvU7BmnTJACdwZx0ne+Qin2JxTMxuegSsE1p6fRfQZJ9nkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788369395; c=relaxed/simple;
	bh=KZX2rWGCNpik8AAAhhyBBLit130QcO68IknrrqtskW8=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=BKsBTJSiTJnMmFiQiZ3QaJL3bYVUyu/nS+pP1SruGIx5rhXmVamTjOy4/wUTe7WDxNAcWqECco2pWrWmn5lVKHSeZTFl/IE/gPR9V8u/6p2dJtGIvmG28VVkA3FZ5jXtOvxDPjXmnzxBHSETPja3akyK0c4ihqSTYGgt38GWOrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e60qNdp0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e60qNdp0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E4AC1F000E9;
	Wed,  2 Sep 2026 17:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788369393;
	bh=KZX2rWGCNpik8AAAhhyBBLit130QcO68IknrrqtskW8=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=e60qNdp0wg1bT3sy+crGCvvAOVfPFSEsBtLuWcC83S+5ykQiKwuEyWGkjFWKh3/PV
	 GG5Lu5Vl+QvrLdUWj/pHQjx/v9DyE0qlW8ioTl+pGSiFxtdyBxHabTZwXVFQWebJBb
	 cOE27Dvf7RNO1ZN6uxFlZjjlfSplT1c7L6XsXU35kdfCmtM8IgYfL26v+3R5m53EuH
	 XZWv+RYM3CXODa/j+P8fRVP4ypPiMSSQLtdBm8rESvChvgvEyBkMmsd6dVKSuXZwPl
	 32R2q9YF/dtHMcujqMzcQq1QQJBmU/VTpQ+WwRCNKcKaB2Oah/0ots5wBB+O/zg9OM
	 C5rhwcGvD3AGQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/9] driver core: rely on put_device to free dev->p
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org
In-Reply-To: <20260902170734.95504-2-djeffery@redhat.com>
References: <20260902170734.95504-1-djeffery@redhat.com>
 <20260902170734.95504-2-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 02 Sep 2026 17:16:32 +0000
Message-Id: <20260902171633.3E4AC1F000E9@smtp.kernel.org>
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
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260902170734.9550=
4-1-djeffery@redhat.com?part=3D1

