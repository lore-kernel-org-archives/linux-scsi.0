Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E4A0265623;
	Wed,  1 Jul 2026 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782914548; cv=none; b=k2Vj7aGaimF7QjhZT8Ep7XjE5TnmwkaFT6Kz2bjKDyOtrH1LQ0hFoaDrFEw99yOX6iF5Twp8aPakiU9cr0eScHgrIAQrFjUJhWYdi97y+NGpr+0qkiq93+epRUILM7bG5TwwfhAO8dD9IOWIbXRZ6xRQfvMjoKN5/2u5xRM+wJU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782914548; c=relaxed/simple;
	bh=hw3WIU8r3/MPRJqog1RGlkc+Yu6ZICwmiTyPOo+EXgo=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=UEerHgtja1Oylk/rfPeo8PcaSiSv6YveTXKq/LII/vidbGHqa8hcKKh3xwCdU5G9R+BgVCNtq3fMJ+DNrK2k7NySSAGs0qQkbvnzjx+BJdEpkoPwouv05AmBEvIYocm97VtrAMoRdxjx+bgw+j7vVjP6m4DoJ6J2sfU06g2oPWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RcUSmEim; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RcUSmEim"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B24F51F000E9;
	Wed,  1 Jul 2026 14:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782914547;
	bh=hw3WIU8r3/MPRJqog1RGlkc+Yu6ZICwmiTyPOo+EXgo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=RcUSmEimC9KQJnSP2PRbsm3vMS27obZINWWANMQA/WDX30SlTP2w7mgt1tF+wsH6u
	 rGL3IQjLFMyCss8sOpYqdp8s6XfbfV/zyOQZDEwuefns8Sv8xP+xqJbdbc/YacuMXK
	 563MP0dCPCu1wUwqS8hTV91k2NPaxUHReDCTEZJqe7vg59dsznQCqq7aQzVsXnaC/1
	 zcK7wHZoT4KZ6fMgeA/JhfXGulUsJWJVNdt+d5dXVBQ1sxvUYhF4p3zCAPLDFDTQLr
	 jJMjl6fN5EkKHB0CdZ+it1rb1lHY3j15nKSQYwwcgVk6u5Xv7PnOz8+oS/N2e7F8Ri
	 rq9eknZ9W/sPA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/5] driver core: do not always lock parent in shutdown
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Jeffery" <djeffery@redhat.com>
Cc: linux-pci@vger.kernel.org, linux-scsi@vger.kernel.org
In-Reply-To: <20260701135015.81937-3-djeffery@redhat.com>
References: <20260701135015.81937-1-djeffery@redhat.com>
 <20260701135015.81937-3-djeffery@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 01 Jul 2026 14:02:26 +0000
Message-Id: <20260701140226.B24F51F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

> Don't lock a parent device unless it is needed in device_shutdown. This
> is in preparation for making device shutdown asynchronous, when it will
> be needed to allow children of a common parent to shut down
> simultaneously.
>=20
> And only acquire a reference to the parent device if the parent is to be
> locked.
>=20
> Signed-off-by: Stuart Hayes <stuart.w.hayes@gmail.com>
> Signed-off-by: David Jeffery <djeffery@redhat.com>

Sashiko has reviewed this patch and found no issues. It looks great!

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260701135015.8193=
7-1-djeffery@redhat.com?part=3D2

