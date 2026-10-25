Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792908824;
	b=KyTWZ+dpOkFRh2pWMTenEjdgEjSgF1dzZfCQD6DnZP9vAE5EgZihjvo9sjPTs+/jxJ2H
	 c9Uh6J0qeEdyUCRqAutHBK7fprwqiV56W2daVfg3Ix7aw8qEx3DAfdzAKAmM3pSEkPeg/
	 DuS9RRHJkz4JEzVFW8GSg81JoFCaMArgb3vAHh+NoiuMxwzxy0DNqj7oa0LQL3eQ/R+DN
	 BsmWuJDwbENp0o2r0gb7ILcR7JVtWOgAH8xTSsyRddzE/UvteniykSWWmNbjF/3wAtSUL
	 azASBXaEd8vwhvydEVXIFdBWUQ4+9/ueMdjdcKfFv27yJmwpL9pZMc3Tj9yzVqnhs3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792908824;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=kKnAeP1qA0SMv3Ti/BSO+LDrD072v8nA7MJcrE3DHvs=;
	b=kCoimXECzIwNONRoMIwJx9iIinW3TN96zDUufmd8kJY/5G70R9rZXZ1Yq+P1N51DVF50
	 VFlJPUUePk6eL6nHDD/yrTSb7K4lo8jSJA8cEm2mr1lRoSGYZAjyuJJAYZvpbudM+/p1O
	 wvegMKSIVg/FR2adZuzJWRBA+CVSan5hmnkjgBx1kTMgBT+Bn/LPggt3bB/ILljL9KtEJ
	 ftE5+pjU+B1wZv3waG/fRCQB/kgSdGcGn/6bEyJE8eTpWo0w8eSVlPxGA1OAyOtQ45WiX
	 ZH/hmvW9UAOCWsvW6Uc+dcZYPjBlZsCks94ufFF/pvRVhcGHO8GIRJ+bdALm37sxqUw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgNCxD8i;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 762AD606A31B
	for <linux-scsi@vger.kernel.org>; Sun, 25 Oct 2026 06:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RgNCxD8i
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D7BF1F01825;
	Sun, 25 Oct 2026 06:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792908824;
	bh=kKnAeP1qA0SMv3Ti/BSO+LDrD072v8nA7MJcrE3DHvs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RgNCxD8iOcBPKBQMApXOaj0o9SS9izFGg4AQizceoaPb3CAlDDtjyhkPA5VTQ48Rm
	 Mtxtc2hcPKRHFmTgJpe9C71jIbnCmmzTlmWsLwvyVqHWL3d0terZWyZl6wXit+7wKe
	 PGwT1qzDYsv7MOOzImVj+d1vEPRQA9TNdSubbNwM=
Date: Sun, 25 Oct 2026 07:13:39 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Maholi Tumanggor <maholitumanggor@gmail.com>
Cc: linux-scsi@vger.kernel.org, security@kernel.org
Subject: Re: [BUG] drivers/message/fusion/mptctl: heap buffer overflow in
 kbuf_alloc_2_sgl
Message-ID: <2026102512-buffoon-unvisited-6d49@gregkh>
References: <CAELScTbAp2ERF9d_dc9GsPmjH_Y4VqN6VJzb3jTwskH7nzv_XA@mail.gmail.com>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAELScTbAp2ERF9d_dc9GsPmjH_Y4VqN6VJzb3jTwskH7nzv_XA@mail.gmail.com>

On Sun, Oct 25, 2026 at 11:05:38AM +0700, Maholi Tumanggor wrote:
> PROPOSED FIX
> ============
> Add a bounds check before each buflist[] access in kbuf_alloc_2_sgl():

Please just turn this into a real patch that can be applied if you wish
to see this resolved.

thanks,

greg k-h
