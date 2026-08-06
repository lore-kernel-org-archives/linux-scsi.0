Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03FBA3A7D82;
	Thu,  6 Aug 2026 13:59:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786024781; cv=none; b=Mvq6zbWc30fK7jNCsNRvsay3kAZGv1jgvtQNVVnLeo2vN2RfZ6RnFFhXbplH5l8zk2UKO8u0HOmQhKMp9HB1+e07QGIkRxjJZbM0MxT+Xl+8eEQJBGEV3s4SZEKYTKtaCvlD9at7omPSydvxH5scPv9kZrHIEZMnAGsl+GPzsqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786024781; c=relaxed/simple;
	bh=klrmMI/Yvjb0Ym3p9ZQwWmHo9b9HD6hwKIvKKAVNdGc=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=imYpkrkjYJSBc2HrjgzhAPvLXiU9cwa5PT2JMOWDsrisl8kvO/T+UHxzPzxuW4G10+Cre2g6Dx2/t7IfdNYlTBR+uZ9fY6VSv/j/rMve2qB+nJRQJQH+0/X1kwwfDJ+VKjtBKhXE15Xs215N9fH7OtUplktTsmVkwzqyGuyyW2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aPk/4Mnp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aPk/4Mnp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BC441F00A3A;
	Thu,  6 Aug 2026 13:59:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786024778;
	bh=5vMWOiNYJjDPTNr+AjcyoTR48djiQ21jW2jRfAqCmwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=aPk/4MnpQGm5pyw3x7VT0DC98DkWrhJ27yksrwrdQqz5NO4+A/o3FuUR4rZvBfKAL
	 uiuDlWRQ+N4LLWDArIbfBrbWIbs5sLPJtPH4r+63XVL0HxGNg2OAL++lJv58B0y0Xd
	 I075+8Pfz7DkaauB28YVPoON2gyig4O6crsYIUQLlUgOqMHghZYq78A5odPcxhRSIq
	 JfcvdKTZX6Zo/JD/6unZPjYoD8fOLp0ndoN76GXJ8Xqmzvfc1FLn2LuMuVpvlc9bq2
	 O5W5tBQZe8A2GEQKWeM6PU4bbKZuJz1plwTJRfypJvpsRJ3svz+1cNf9SOFC/eu/TQ
	 FrE+Zpl9T9L5w==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] scsi: zfcp: Add __must_hold() attribute to
 zfcp_qdio_sbal_get()
Reply-To: sashiko-reviews@lists.linux.dev
To: "Heiko Carstens" <hca@linux.ibm.com>
Cc: "Alexander Gordeev" <agordeev@linux.ibm.com>, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, "Vasily
 Gorbik" <gor@linux.ibm.com>, "Heiko Carstens" <hca@linux.ibm.com>
In-Reply-To: <20260806134759.2122369-2-hca@linux.ibm.com>
References: <20260806134759.2122369-1-hca@linux.ibm.com>
 <20260806134759.2122369-2-hca@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 06 Aug 2026 13:59:37 +0000
Message-Id: <20260806135938.8BC441F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Add __must_hold() attribute to zfcp_qdio_sbal_get() in order to let
> clang's context analysis know that qdio->req_q_wq must be held on
> function entry. This is also documented above the function. Without this
> annotation this leads to a valid warning when context analysis is
> enabled:
>=20
> drivers/s390/scsi/zfcp_qdio.c:287:8: warning:
>   expecting spinlock '->req_q_lock' to be held at start of each loop [-Wt=
hread-safety-analysis]
>   287 |         ret =3D wait_event_interruptible_lock_irq_timeout(qdio->r=
eq_q_wq,
>       |               ^
>=20
> Signed-off-by: Heiko Carstens <hca@linux.ibm.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260806134759.2122=
369-1-hca@linux.ibm.com?part=3D1

