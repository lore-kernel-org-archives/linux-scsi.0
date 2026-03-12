Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8638DD3;
	Thu, 12 Mar 2026 03:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773284543; cv=none; b=S0JFj6zc4zCnFLvfoaayVNtCTvJ+HkbE3TYY+9tYKdChL5kmzc4ca5GcOMjQFcRQMdCBI5RhGPAriaumDHf8ECWoUbPCmJnjw/nFRozQn26FhJIw6QY+XzbNPdwjD3rjTTXJldv1hqa+4p4BgbtFyHzUkCTwgnWP4LSjzebGKVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773284543; c=relaxed/simple;
	bh=KEYQl8+VvPcfn6uzVu6YIy+HYhzQOXqkZpAojxKhODA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FKAOaizCHgHx3LVQRTYq21oCj4Vap6RVTeh/TAXoQdI4CxonNvlW6FU8GAJPciGBP2stdkyjuA7qLo/yRU2LMpGHB02WQt+McNWcsQT0XCUvMYXcSLt0e6hh7/uvjWZqciazv6/CGg3i9rlPuwfCzr5zhqsqCbowbiqqKB9x8aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F8NXL71/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F8NXL71/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A04AC4CEF7;
	Thu, 12 Mar 2026 03:02:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773284543;
	bh=KEYQl8+VvPcfn6uzVu6YIy+HYhzQOXqkZpAojxKhODA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=F8NXL71/vLl3Dq1WAm4Auc0XA4QvHGBmkfPAKKMT6NZVVgMTlNICYyjzHbGeJNcRz
	 F/Wyghg4yMGVLqcfE4spE2II5KVJdUmo2MxvcpQg3RiL0kv50pky3Us/SgWGfNm4C8
	 OBewmMfEcqIpb9At+m7LjiAqOwNVG4C2TNES2w0nh0uyTac7Ly/93mEtPAEk62p2+b
	 RhVSYeBhuL4hLRLBGq/r/1rBww6KvG71fHi3nYyB1s5dHCLtjRQkQCLldoR1mkjmFr
	 aShv34CDa+y+Ih95SrOoeCJ6uds494cxNGUfz/pgC7e4lbkLCq/zI770KaUawqGkb+
	 srwBq+9pcpfUw==
Date: Wed, 11 Mar 2026 20:02:19 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netdev@vger.kernel.org, rbm@suse.com, Geert Uytterhoeven
 <geert@linux-m68k.org>, Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky
 <leon@kernel.org>, Selvin Xavier <selvin.xavier@broadcom.com>, Andrew Lunn
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Paolo Abeni <pabeni@redhat.com>, Ido
 Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, Simon Horman
 <horms@kernel.org>, Saurav Kashyap <skashyap@marvell.com>, Javed Hasan
 <jhasan@marvell.com>, GR-QLogic-Storage-Upstream@marvell.com
 (maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER), "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, Manish
 Rangankar <mrangankar@marvell.com>, Varun Prakash <varun@chelsio.com>,
 Alexander Aring <aahringo@redhat.com>, David Teigland
 <teigland@redhat.com>, Andreas Gruenbacher <agruenba@redhat.com>, Nikolay
 Aleksandrov <razor@blackwall.org>, David Ahern <dsahern@kernel.org>, Pablo
 Neira Ayuso <pablo@netfilter.org>, Florian Westphal <fw@strlen.de>, Phil
 Sutter <phil@nwl.cc>, David Howells <dhowells@redhat.com>, Marc Dionne
 <marc.dionne@auristor.com>, Marcelo Ricardo Leitner
 <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, Jon Maloy
 <jmaloy@redhat.com>, Krzysztof Kozlowski
 <krzysztof.kozlowski@oss.qualcomm.com>, Bjorn Andersson
 <bjorn.andersson@oss.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>, Eric
 Biggers <ebiggers@kernel.org>, Michal Simek <michal.simek@amd.com>, Luca
 Weiss <luca.weiss@fairphone.com>, Sven Peter <sven@kernel.org>, Lad
 Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>, Kuninori Morimoto
 <kuninori.morimoto.gx@renesas.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Gow <david@davidgow.net>, Kuan-Wei Chiu
 <visitorckw@gmail.com>, Ryota Sakamoto <sakamo.ryota@gmail.com>, Kir Chou
 <note351@hotmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, Herbert Xu
 <herbert@gondor.apana.org.au>, Vikas Gupta <vikas.gupta@broadcom.com>,
 Bhargava Marreddy <bhargava.marreddy@broadcom.com>, Rajashekar Hudumula
 <rajashekar.hudumula@broadcom.com>, Markus =?UTF-8?B?QmzDtmNobA==?=
 <markus@blochl.de>, Heiner Kallweit <hkallweit1@gmail.com>,
 linux-kernel@vger.kernel.org (open list), linux-m68k@lists.linux-m68k.org
 (open list:M68K ARCHITECTURE), linux-rdma@vger.kernel.org (open
 list:INFINIBAND SUBSYSTEM), oss-drivers@corigine.com (open list:NETRONOME
 ETHERNET DRIVERS), linux-scsi@vger.kernel.org (open list:BROADCOM BNX2FC 10
 GIGABIT FCOE DRIVER), gfs2@lists.linux.dev (open list:DISTRIBUTED LOCK
 MANAGER (DLM)), bridge@lists.linux.dev (open list:ETHERNET BRIDGE),
 netfilter-devel@vger.kernel.org (open list:NETFILTER),
 coreteam@netfilter.org (open list:NETFILTER), linux-afs@lists.infradead.org
 (open list:RXRPC SOCKETS (AF_RXRPC)), linux-sctp@vger.kernel.org (open
 list:SCTP PROTOCOL), tipc-discussion@lists.sourceforge.net (open list:TIPC
 NETWORK LAYER)
Subject: Re: [PATCH 01/10 net-next v2] ipv6: convert CONFIG_IPV6 to built-in
 only and clean up Kconfigs
Message-ID: <20260311200219.45796ec4@kernel.org>
In-Reply-To: <20260310153506.5181-2-fmancera@suse.de>
References: <20260310153506.5181-1-fmancera@suse.de>
	<20260310153506.5181-2-fmancera@suse.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 10 Mar 2026 16:34:24 +0100 Fernando Fernandez Mancera wrote:
> Maintaining a modular IPv6 stack offers image size and memory savings
> for specific setups, this benefit is outweighed by the architectural
> burden it imposes on the subsystems on implementation and maintenance.
> Therefore, drop it.
> 
> Change CONFIG_IPV6 from tristate to bool. Remove all Kconfig
> dependencies across the tree that explicitly checked for IPV6=m. In
> addition, remove MODULE_DESCRIPTION(), MODULE_ALIAS(), MODULE_AUTHOR()
> and MODULE_LICENSE().
> 
> This is also replacing module_init() by device_initcall(). It is not
> possible to use fs_initcall() as IPv4 does because that creates a race
> condition on IPv6 addrconf.
> 
> Finally, modify the default configs from CONFIG_IPV6=m to CONFIG_IPV6=y
> except for m68k as according to the bloat-o-meter the image is
> increasing by 330KB~ and that isn't acceptable. Instead, disable IPv6 on
> this architecture by default. This is aligned with m68k RAM requirements
> and recommendations [1].

AI has spotted:

> diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
> index 31d16cba9879..de088071dde4 100644
> --- a/arch/m68k/configs/amiga_defconfig
> +++ b/arch/m68k/configs/amiga_defconfig
> @@ -64,7 +64,6 @@ CONFIG_NET_IPIP=m
>  CONFIG_NET_IPGRE_DEMUX=m
>  CONFIG_NET_IPGRE=m
>  CONFIG_NET_IPVTI=m
> -CONFIG_NET_FOU_IP_TUNNELS=y
>  CONFIG_INET_AH=m

Is CONFIG_NET_FOU_IP_TUNNELS=y removed intentionally? This option
provides FOU/GUE encapsulation for IP tunnels and has 'depends on
NET_IPIP || NET_IPGRE || IPV6_SIT' as its Kconfig dependency. With IPv6
disabled, IPV6_SIT becomes unavailable, but CONFIG_NET_IPIP=m and
CONFIG_NET_IPGRE=m are both still present in the defconfig, so the
dependency remains satisfiable.

Since CONFIG_NET_FOU_IP_TUNNELS has no 'default y', removing it from the
defconfig means FOU/GUE encapsulation for IP tunnels will be silently
disabled by default on m68k. The commit message describes only disabling
IPv6 on m68k, not removing IPv4 FOU tunnel support.

This affects four m68k defconfigs:
- amiga_defconfig
- apollo_defconfig
- atari_defconfig
- bvme6000_defconfig
