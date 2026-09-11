Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFE3A374A17;
	Fri, 11 Sep 2026 15:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789139741; cv=none; b=Q6Vi5khbURLpjF4i58BHZQMAvnEIQ71f4K0uMTdVJ8ioJr0kQKjBF6cKyVpEoQCUnaLSDo0j4cfbMZ6gVSYGMVQl4HOPCgz4Anz4Vt6j5V40apA3JNu81iHaqrrM6tnOkkBI4M5j0d9xmZoZe3aP2L+3zxaTE+KX3G22i7Tw+zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789139741; c=relaxed/simple;
	bh=+JMr+qGMs3sFTxbkwI95qYwIaFt6UtAXLV76Pl4C2Xs=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=Rka04Upn2tgRKNeshl0QsMWeXf3UtJfcXvH/ixs8LE4NsaDhr+pXqHLDC94u+lwGKRpaMzEJiOvwsYELa8kXE25njioV404UOXdbzpxK6dP0ax6Ql47fDgy2Q3WvfaGiysiLosiq1DIEm3YkcwPeijnPXY+4WcCtUPtoS5bJJHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=awHF7upi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="awHF7upi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FBC61F00898;
	Fri, 11 Sep 2026 15:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789139739;
	bh=spXyrTowUXWc/69WlA9MNUyghCeh7E7kfBS+3vu+KRc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=awHF7upiS9J2W4k1vFwqMV+vv0xK2E/MZVYL0TNSj931LhDb++1c+P07HRXDHo5cE
	 I6WNIDrC30zjaNT2jislU0t3tsPDOG0E3s94GKpqdvYKab5klA/m3OhVLtFVfw8zoG
	 icIAXzo7+JJsL4wbfUPKmIZCnRR9jic9KuLDR+MqqQIAr3Z+xMaQIgPgiLG+7ZIG4l
	 +YReFDCcSQ695Gof1ffTn2eChOCUgl57DNXVi1kj7vWBxUJv9efzzgWOPgGHMcyITX
	 KOr0r9DHA5OVZmtWsNzL39JEDk6kxXcP4OlwrP5tOpMPNJNVPZXaXoFdJmB3wKJgz9
	 g0K4atLQzEIxw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/13 net-next] net: ipv4: introduce CONFIG_IPV4 to
 decouple the IPv4 stack
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fernando Fernandez Mancera" <fmancera@suse.de>
Cc: sven@narfation.org, "Christian Borntraeger" <borntraeger@linux.ibm.com>, marek.lindner@mailbox.org, sw@simonwunderlich.de, "Jeff
 Layton" <jlayton@kernel.org>, antonio@mandelbit.com, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org, "Heiko
 Carstens" <hca@linux.ibm.com>, linux-scsi@vger.kernel.org, "Anna Schumaker" <anna@kernel.org>, linux-s390@vger.kernel.org, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Chuck
 Lever" <cel@kernel.org>
In-Reply-To: <20260910144914.8025-2-fmancera@suse.de>
References: <20260910144914.8025-1-fmancera@suse.de>
 <20260910144914.8025-2-fmancera@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 11 Sep 2026 15:15:38 +0000
Message-Id: <20260911151538.6FBC61F00898@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Layer-2 networking features and core drivers incorrectly depend on=
 IPV4, breaking INET=3Dn builds.
--

commit a6e6a467093e978fadc9f73c8f0d22f0bf0ee577
Author: Fernando Fernandez Mancera <fmancera@suse.de>
Subject: net: ipv4: introduce CONFIG_IPV4 to decouple the IPv4 stack

Historically, the IPv4 protocol has been linked to the core INET subsystem.
This patch introduces the CONFIG_IPV4 Kconfig symbol and adds it as a
dependency to multiple networking Kconfig symbols.

> diff --git a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig b/drivers/ne=
t/ethernet/mellanox/mlx5/core/Kconfig
> index 925ee25d05b47..86b0884968b67 100644
> --- a/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> +++ b/drivers/net/ethernet/mellanox/mlx5/core/Kconfig
> @@ -12,6 +12,7 @@ config MLX5_CORE
>  	depends on PTP_1588_CLOCK_OPTIONAL
>  	depends on PCI_HYPERV_INTERFACE || !PCI_HYPERV_INTERFACE
>  	depends on HWMON || !HWMON
> +	depends on IPV4

[Severity: High]
Does adding this dependency on IPV4 mean the Mellanox core driver can no
longer be used for L2/DPDK in IP-less kernels?

The IPV4 symbol is sourced inside the if INET block in net/Kconfig, so it
evaluates to n when INET=3Dn. This seems to prevent selecting MLX5_CORE wit=
hout
TCP/IP, which causes a regression for valid Layer-2-only kernel configurati=
ons.

[ ... ]

> diff --git a/net/bridge/Kconfig b/net/bridge/Kconfig
> index 318715c8fc9bc..421892a031299 100644
> --- a/net/bridge/Kconfig
> +++ b/net/bridge/Kconfig
> @@ -7,6 +7,7 @@ config BRIDGE
>  	tristate "802.1d Ethernet Bridging"
>  	select LLC
>  	select STP
> +	depends on IPV4

[Severity: High]
Is it intentional that Ethernet bridging requires IPV4 here?

Bridging is a Layer-2 feature that does not require INET, but since IPV4 is
evaluated as n in INET=3Dn builds, this completely disables bridging in ker=
nels
configured without TCP/IP, resulting in a configuration regression.

[ ... ]

> diff --git a/net/mac80211/Kconfig b/net/mac80211/Kconfig
> index d6bc295e23a1a..ec485da283730 100644
> --- a/net/mac80211/Kconfig
> +++ b/net/mac80211/Kconfig
> @@ -1,7 +1,7 @@
>  # SPDX-License-Identifier: GPL-2.0-only
>  config MAC80211
>  	tristate "Generic IEEE 802.11 Networking Stack (mac80211)"
> -	depends on CFG80211
> +	depends on CFG80211 && IPV4

[Severity: High]
Does the generic 802.11 stack need to be rendered unavailable if INET=3Dn?

Since it does not require IP, adding the IPV4 dependency seems to cause a
regression for valid Layer-2-only configurations.

[ ... ]

> diff --git a/net/packet/Kconfig b/net/packet/Kconfig
> index 2997382d597c2..00fda9e08cb0b 100644
> --- a/net/packet/Kconfig
> +++ b/net/packet/Kconfig
> @@ -5,6 +5,7 @@
> =20
>  config PACKET
>  	tristate "Packet socket"
> +	depends on IPV4

[Severity: High]
Can packet sockets (AF_PACKET) still be used when INET=3Dn?

They provide direct Layer-2 access and are independent of INET, but this
dependency causes a regression by making them unavailable in INET=3Dn build=
s.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260910144914.8025=
-1-fmancera@suse.de?part=3D1
