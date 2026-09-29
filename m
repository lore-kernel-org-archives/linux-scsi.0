Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9463A55294B;
	Tue, 29 Sep 2026 19:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790710366; cv=none; b=dhSIK1cOWPOCP4SHc7TNh66kcCgg7ym00Eew1qqdHpN+l/clvYOWJ7+i+oEUVGx3nsh30iZY7XN2yKQzUHtRUO5JNnrno9UbyxsjZ54zSm0FXGzLDHn00Aeov/3sAx6prem9N6dbAKIKcXddqxbfd3zflp9tuiQaQnvt0l8+L1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790710366; c=relaxed/simple;
	bh=Fn4MPbxI+JJCAvX0AAkAD9uyazR2zHDgsv3pW6Q0Lqk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=B8C6LVt0cCxjohEMaxKuCJzCplRzC1JfqpJHrhO10JJgtaXJ0d90eUTslewjb0TgoszFD5J+2hxxeupeUshQCrHyWfsQ+5MIlWaMCEH7uDt4XGZK52juEpNQBPEnVmqMlycX1/XokADWS0V/rvcgMN+PPR970sA1Fsx+61wt9NM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PBMBkbXD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PBMBkbXD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90FF01F000FF;
	Tue, 29 Sep 2026 19:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790710364;
	bh=HZtibm6wLNY3C3qTYpBig2hjrFtePeC9eV4kCyAr5kk=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PBMBkbXDwVUZDdWjT7rS5KJdKcI3WcPLdaGiv0mGoM8mOWUIez5KcDyQuJDKYconx
	 0AmBoli61qd2jVKbOaa6HRODoEUA8xU8abZZBHSndeS/0o32MDvPrD1UMw+HyjJzMa
	 5UuqfqCFSU985LqHm72wG5wJ5RhCvm2U+J3uEe8cJvdx0bzVGwBZjXo5SYCwktq6ZT
	 ymtXXHsvx+uth+8+nCVRJUonHnd06oxoX7bvvbVg5LZiZd2sgxUEjXzcF/P1TQM6Lj
	 il66dHPgFR6OexyHL/FGVqD2xxB2ThleAXInFqamp+uEaAWuEcj2pSxs+rE3AjbV1i
	 e+PXbnKfJSOjA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 01/16 net-next v2] ipv4: introduce CONFIG_IPV4 to
 decouple the IPv4 stack
Reply-To: sashiko-reviews@lists.linux.dev
To: "Fernando Fernandez Mancera" <fmancera@suse.de>
Cc: antonio@mandelbit.com, sw@simonwunderlich.de, linux-scsi@vger.kernel.org, "Jeff
 Layton" <jlayton@kernel.org>, sven@narfation.org, linux-security-module@vger.kernel.org, "Anna
 Schumaker" <anna@kernel.org>, "Chuck Lever" <cel@kernel.org>, marek.lindner@mailbox.org, mptcp@lists.linux.dev, linux-rdma@vger.kernel.org
In-Reply-To: <20260928193046.6698-2-fmancera@suse.de>
References: <20260928193046.6698-1-fmancera@suse.de>
 <20260928193046.6698-2-fmancera@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 19:32:43 +0000
Message-Id: <20260929193243.90FF01F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] kconfig: core dual-stack and IPv6 features are forcibly disabled w=
ithout IPv4
--

commit e9e0ffe00541dede8370017851b597f6f3e1cfa2
Author: Fernando Fernandez Mancera <fmancera@suse.de>

ipv4: introduce CONFIG_IPV4 to decouple the IPv4 stack

This commit introduces the CONFIG_IPV4 symbol to decouple the IPv4 stack,
currently defaulting it to yes. It adjusts multiple networking subsystems
across tunnels, drivers, and filesystems to depend on this new IPv4
configuration symbol.

> diff --git a/net/Kconfig b/net/Kconfig
> index 76ab44aa439a6..ca86f20540dd1 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
[ ... ]
> @@ -232,6 +235,7 @@ config BRIDGE_NETFILTER
>  	depends on BRIDGE
>  	depends on NETFILTER && INET
>  	depends on NETFILTER_ADVANCED
> +	depends on IPV4
>  	select NETFILTER_FAMILY_BRIDGE

[Severity: High]
Does adding this dependency force bridge netfilter to be unavailable on
kernels without IPv4?

Bridge netfilter handles both IPv4 and IPv6 bridged traffic. Tying it
exclusively to CONFIG_IPV4 under config BRIDGE_NETFILTER might prevent
filtering IPv6 traffic on an IPv6-only kernel.

[ ... ]
> diff --git a/net/ipv6/Kconfig b/net/ipv6/Kconfig
> index c3806c6ac96f9..f83efc1505cc4 100644
> --- a/net/ipv6/Kconfig
> +++ b/net/ipv6/Kconfig
[ ... ]
> @@ -256,7 +265,7 @@ config IPV6_SUBTREES
> =20
>  config IPV6_MROUTE
>  	bool "IPv6: multicast routing"
> -	depends on IPV6
> +	depends on IPV4 && IPV6
>  	select IP_MROUTE_COMMON

[Severity: High]
Does this change break IPv6 multicast routing when CONFIG_IPV4 is disabled?

IPv6 multicast routing under config IPV6_MROUTE does not inherently require
IPv4. Adding this dependency disables purely IPv6 functionality on an
IPv6-only kernel.

[ ... ]
> diff --git a/net/xfrm/Kconfig b/net/xfrm/Kconfig
> index 4a62817a88f8f..203188b05be40 100644
> --- a/net/xfrm/Kconfig
> +++ b/net/xfrm/Kconfig
> @@ -4,7 +4,7 @@
>  #
>  config XFRM
>  	bool
> -	depends on INET
> +	depends on INET && IPV4
>  	select GRO_CELLS

[Severity: High]
Will adding this dependency disable the global IPsec subsystem for IPv6-only
kernels?

Tying config XFRM entirely to CONFIG_IPV4 restricts dual-stack infrastructu=
re,
making it impossible to use IPsec with IPv6 if IPv4 is disabled.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928193046.6698=
-1-fmancera@suse.de?part=3D1
