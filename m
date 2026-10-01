Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D1A37A831;
	Thu,  1 Oct 2026 14:05:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790863508; cv=none; b=l1WuGTUOOVXYWeiNhr73M6dw9OKrsrMVCE+nxt/grtNJi/2P4wuO/FREpdiLiP80pDv0rTE1NuhSVWi6mHndt1LP4MordD7MZb4bWYVHvN3eJhl9T6TrHE62vCWHfxh1kzBDuQanxSpUauVXRk3XGdRyorSJzo5LRbWxod2bPkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790863508; c=relaxed/simple;
	bh=yEkfXVyikNbfBpB3dU23rKZPO5u8aqRm2BcxhHbymvo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Upw04Fcw0MM+b/4jKyhMgXUhxlxoFPm0tLDR2aClzOXLdkXjsnnxXMc0GuvpmFfMlR9S+Myctwj8vzr6HK2uAjtlBOF7IYgJUqbBfrVRA94g7lvR45h8CEfqZNwKKuyzXEYRxPphh4CBTafrgDMwAPwRLOBnf1R3/nE7FBTK20M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=R1F+aqM2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="R1F+aqM2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 845D41F000FF;
	Thu,  1 Oct 2026 14:05:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790863507;
	bh=yEkfXVyikNbfBpB3dU23rKZPO5u8aqRm2BcxhHbymvo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=R1F+aqM2gB+CNQa4L3qqt1A3QFm1sOF0PpSs0/o46T9hYnp7cbSOKPecPjwI+IdVF
	 vYjQOtodAzC4upul4pKTSiNCPntQEaUrzxFJ/+lw4jMXIZce+Aa6B4w423EGQkqIvb
	 FNXcMJAXkN0K/WbN2KYLDFJRiTeU2Thi2Pbn6keJ0baAwQEVN5xa5/U7WOAnxsJKc0
	 dW1X3GI1kikXIVusjMtvvqzHT59ipQFsbP//bSS0cZm3JzDtYcr3fGPBusIpI8qSlM
	 2HNSwP1qYPWHjdhTaQ+w8dY84E6tkuewxXQ7XH/HIUQFMSx6ILjnNgA/gSu/hun5hG
	 X0ZgMUtu6Qwuw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/16 net-next v3] ipv4: introduce CONFIG_IPV4 to
 decouple the IPv4 stack
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fernando Fernandez Mancera" <fmancera@suse.de>
Cc: "Christian Borntraeger" <borntraeger@linux.ibm.com>, "Alexander Gordeev" <agordeev@linux.ibm.com>, antonio@mandelbit.com, sven@narfation.org, sw@simonwunderlich.de, linux-rdma@vger.kernel.org, marek.lindner@mailbox.org, linux-scsi@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, "Anna Schumaker" <anna@kernel.org>, mptcp@lists.linux.dev, "Jeff
 Layton" <jlayton@kernel.org>, "Chuck Lever" <cel@kernel.org>, "Vasily
 Gorbik" <gor@linux.ibm.com>, linux-s390@vger.kernel.org, linux-security-module@vger.kernel.org
In-Reply-To: <20260930135334.4739-2-fmancera@suse.de>
References: <20260930135334.4739-1-fmancera@suse.de>
 <20260930135334.4739-2-fmancera@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 01 Oct 2026 14:05:05 +0000
Message-Id: <20261001140505.845D41F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Historically, the IPv4 protocol has been linked to the core INET
> subsystem. Because shared infrastructure like the TCP/UDP engine,
> routing or INET hashtables live inside net/ipv4/, it has been impossible
> to compile a kernel with only IPv6 support.
>=20
> This patch introduces the CONFIG_IPV4 Kconfig symbol, which is set to
> 'def_bool y' for now. This does not allow to completely disable the
> IPv4 stack yet but it lays the necessary build-system work for that
> goal.
>=20
> In addition, multiple subsystems Kconfig symbols across networking
> features like tunnels, drivers and filesystems have been adjusted to
> depend on IPv4. Keep on mind that follow-up work is required to convert
> the Kconfig symbol to bool and remove the dependency on IPv4 where it
> makes sense.
>=20
> Acked-by: Chuck Lever <cel@kernel.org>
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260930135334.4739=
-1-fmancera@suse.de?part=3D1

