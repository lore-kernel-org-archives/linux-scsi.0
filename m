Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFFEA59
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 07:49:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773301778; cv=none; b=Zpo9T46k7oPIlcN/e3UovL9EhA3n1b9npY2oD/J3egj7FYYEUIw7hOuIekit5ABY/Hs2MlnxybqJUV2XJnPT9cTqBETFHw5y+IWHfgB3Q92q8ZOcV7r9op33hrRzD369dGBLmZE8ZBVhfPeBWDRPIqsfLqwYAVkztNt2vYtM8lc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773301778; c=relaxed/simple;
	bh=r2PdE6HYGVzZYpXyEn5kett8unUMILRQGQuMPOiuUPo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vx8j3Spcadre4AN6nTGKPsy9cBWFmUJ7uttD2jUiTFTzUa+V2eu+dFEwuu79maRCsXBCdIpllAk0BgDLSH9Ww8HjhL6rWH0wxxzCxqjGLnwaYXAPZ3ni7MPEsUftDxyJYOm+4zMoLg4U66d3/jrrpDN+iJVT9G3w0NTkTNNmFK0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-3591cc98871so351455a91.3
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 00:49:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773301776; x=1773906576;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/LhKuHInA3JH1whpdNQPR6DLSzWmpT0VhZEHTHtHiaY=;
        b=ahxA3hE0i9P7yVky2O1spxLa18ukL9jQ/sYNkGpl28CpkBXw48pbqtXAQio/3i+Tq6
         MDCTJBPpQVlYqtHVwK/edjnR0FC/IkkOIio8pPR7pMEXEG9HJq6c2MV+XreCCDsre7jl
         r+2dDbk8TtUOQO0hiuctWGyORi/+8NGuLfp/cVYky2kgSPvVba+bZpi0hR+cRD9ZcC83
         q0/tNVGm+bEUCO+tRyJmPTQFW/q8omicdiMDlsZZb1xyBK+4u+ol42JtAbazZoBvYE4E
         29IcPMcSd6QiELoVDxBWzOlGQwepwV4SzPXCBmVLMXfv2ESEl0ZeA4WvBu1Pr0kdMEWM
         mzxw==
X-Forwarded-Encrypted: i=1; AJvYcCXf2ZyXHmC0PfdJAHw5YSyt51suewfE86e6Wa/34VPqu6d/YxiiDt5ENdKzUcBBGtvHOyjTle8IJyMZ@vger.kernel.org
X-Gm-Message-State: AOJu0Yw2sjbnaQ+Fkgc6QzVcOR0lrNeNJef7VhisxUNmoeQgyl91hubt
	Z74BAMS+gIVW5u6sAbzwqqis7g/+Vqc2LpEyvhqFDn3cay/Ij61VtILFPbcJrhZ941p2Ag==
X-Gm-Gg: ATEYQzx/tDkfnaIi0Ru/wF2fgP3CWvj6qCloXYqyJzazynTM4xIbIKdgGiRPqjsUuuO
	qQvYNR6tnkCAaTHFQ5XqW1im80ASNQgasytyqHUDoed9MflaZ0i9ssg4TaD6G6x5Pta8c8fB+Wg
	JdhAWzDMBg2mjorpIMZk1a0BIwvXbxt/9TLIsoaHHuzzybOhxwQkEaC8/3E+lWKz+tLPI3soMnP
	X+lbFocvoDsMdh/ic/0WPAZNBrj4IqdvLc/KJNfnM8DoADmeC6Umt3HR87v+DIoRmOU9KGpPABw
	nxMaOcD7WSFeJhbBB9DHbaQTEHtSikbqRsXm6TtbcIj+eO9oo85gfLEI1h4EE8ugg3E5HunUl1P
	LoOgcMGTro8ddl14kSlI9e4ABDxwKwUhyg//QTUlVWM/lWRBWTgFwKqd3IVeVG5dmxKvvsGZVos
	nH1GqbvVs9+3PWu96JTxazO0FJMXhv5Dw01nJu8B4jPNimL6GZOYI1/LUg7yupK8Q=
X-Received: by 2002:a17:90b:3d82:b0:359:2204:a29 with SMTP id 98e67ed59e1d1-35a0133cf11mr5298709a91.27.1773301775620;
        Thu, 12 Mar 2026 00:49:35 -0700 (PDT)
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com. [74.125.82.178])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359f06ff204sm8349987a91.7.2026.03.12.00.49.35
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 00:49:35 -0700 (PDT)
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-2be4781d2baso1849479eec.0
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 00:49:35 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXoEU1e2JXvjXZpjl0fwKMBf2ZR5HeSd0Yxz+hl/JTqDTvSRN41yiG9YmngzadkRjyHZdixwsEPNLa6@vger.kernel.org
X-Received: by 2002:a05:6122:1b0f:b0:56a:9f03:1719 with SMTP id
 71dfb90a1353d-56b47483c0fmr2043365e0c.7.1773301414536; Thu, 12 Mar 2026
 00:43:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310153506.5181-1-fmancera@suse.de> <20260310153506.5181-2-fmancera@suse.de>
In-Reply-To: <20260310153506.5181-2-fmancera@suse.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 12 Mar 2026 08:43:23 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWj-7J5bMq=wpv12CGaV7xtq7=O3nLHLvOT_odxOE4ueA@mail.gmail.com>
X-Gm-Features: AaiRm50vZ50YS2w5-6lod2s5W_kA6Ap8FK_nMN9HyVzDzz2AFRy7FAD50ZqnaYU
Message-ID: <CAMuHMdWj-7J5bMq=wpv12CGaV7xtq7=O3nLHLvOT_odxOE4ueA@mail.gmail.com>
Subject: Re: [PATCH 01/10 net-next v2] ipv6: convert CONFIG_IPV6 to built-in
 only and clean up Kconfigs
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: netdev@vger.kernel.org, rbm@suse.com, Jason Gunthorpe <jgg@ziepe.ca>, 
	Leon Romanovsky <leon@kernel.org>, Selvin Xavier <selvin.xavier@broadcom.com>, 
	Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, Simon Horman <horms@kernel.org>, 
	Saurav Kashyap <skashyap@marvell.com>, Javed Hasan <jhasan@marvell.com>, 
	"maintainer:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" <GR-QLogic-Storage-Upstream@marvell.com>, 
	"James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	"Martin K. Petersen" <martin.petersen@oracle.com>, Nilesh Javali <njavali@marvell.com>, 
	Manish Rangankar <mrangankar@marvell.com>, Varun Prakash <varun@chelsio.com>, 
	Alexander Aring <aahringo@redhat.com>, David Teigland <teigland@redhat.com>, 
	Andreas Gruenbacher <agruenba@redhat.com>, Nikolay Aleksandrov <razor@blackwall.org>, 
	David Ahern <dsahern@kernel.org>, Pablo Neira Ayuso <pablo@netfilter.org>, 
	Florian Westphal <fw@strlen.de>, Phil Sutter <phil@nwl.cc>, David Howells <dhowells@redhat.com>, 
	Marc Dionne <marc.dionne@auristor.com>, 
	Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>, Xin Long <lucien.xin@gmail.com>, 
	Jon Maloy <jmaloy@redhat.com>, 
	Krzysztof Kozlowski <krzysztof.kozlowski@oss.qualcomm.com>, 
	Bjorn Andersson <bjorn.andersson@oss.qualcomm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Eric Biggers <ebiggers@kernel.org>, Michal Simek <michal.simek@amd.com>, 
	Luca Weiss <luca.weiss@fairphone.com>, Sven Peter <sven@kernel.org>, 
	Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>, 
	Kuninori Morimoto <kuninori.morimoto.gx@renesas.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Gow <david@davidgow.net>, 
	Kuan-Wei Chiu <visitorckw@gmail.com>, Ryota Sakamoto <sakamo.ryota@gmail.com>, 
	Kir Chou <note351@hotmail.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Vikas Gupta <vikas.gupta@broadcom.com>, 
	Bhargava Marreddy <bhargava.marreddy@broadcom.com>, 
	Rajashekar Hudumula <rajashekar.hudumula@broadcom.com>, =?UTF-8?Q?Markus_Bl=C3=B6chl?= <markus@blochl.de>, 
	Heiner Kallweit <hkallweit1@gmail.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:M68K ARCHITECTURE" <linux-m68k@lists.linux-m68k.org>, 
	"open list:INFINIBAND SUBSYSTEM" <linux-rdma@vger.kernel.org>, 
	"open list:NETRONOME ETHERNET DRIVERS" <oss-drivers@corigine.com>, 
	"open list:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" <linux-scsi@vger.kernel.org>, 
	"open list:DISTRIBUTED LOCK MANAGER (DLM)" <gfs2@lists.linux.dev>, "open list:ETHERNET BRIDGE" <bridge@lists.linux.dev>, 
	"open list:NETFILTER" <netfilter-devel@vger.kernel.org>, 
	"open list:NETFILTER" <coreteam@netfilter.org>, 
	"open list:RXRPC SOCKETS (AF_RXRPC)" <linux-afs@lists.infradead.org>, 
	"open list:SCTP PROTOCOL" <linux-sctp@vger.kernel.org>, 
	"open list:TIPC NETWORK LAYER" <tipc-discussion@lists.sourceforge.net>
Content-Type: text/plain; charset="UTF-8"

Hi Fernando,

On Tue, 10 Mar 2026 at 16:37, Fernando Fernandez Mancera
<fmancera@suse.de> wrote:
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
>
> [1] http://www.linux-m68k.org/faq/ram.html
>
> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>

Thanks for your patch!

>  arch/m68k/configs/amiga_defconfig           | 45 +-------------------
>  arch/m68k/configs/apollo_defconfig          | 46 +-------------------
>  arch/m68k/configs/atari_defconfig           | 45 +-------------------
>  arch/m68k/configs/bvme6000_defconfig        | 45 +-------------------
>  arch/m68k/configs/hp300_defconfig           | 47 +--------------------
>  arch/m68k/configs/mac_defconfig             | 45 +-------------------
>  arch/m68k/configs/multi_defconfig           | 45 +-------------------
>  arch/m68k/configs/mvme147_defconfig         | 45 +-------------------
>  arch/m68k/configs/mvme16x_defconfig         | 45 +-------------------
>  arch/m68k/configs/q40_defconfig             | 45 +-------------------
>  arch/m68k/configs/sun3_defconfig            | 45 +-------------------
>  arch/m68k/configs/sun3x_defconfig           | 45 +-------------------

Why are the stats not the same for each file?

> --- a/arch/m68k/configs/apollo_defconfig
> +++ b/arch/m68k/configs/apollo_defconfig

> @@ -384,7 +343,6 @@ CONFIG_FB=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION=y
>  CONFIG_LOGO=y
> -# CONFIG_LOGO_LINUX_VGA16 is not set

Unrelated change.

>  # CONFIG_LOGO_LINUX_CLUT224 is not set
>  CONFIG_HID=m
>  CONFIG_HIDRAW=y

> --- a/arch/m68k/configs/hp300_defconfig
> +++ b/arch/m68k/configs/hp300_defconfig

> @@ -386,8 +345,6 @@ CONFIG_FB=y
>  CONFIG_FRAMEBUFFER_CONSOLE=y
>  CONFIG_FRAMEBUFFER_CONSOLE_LEGACY_ACCELERATION=y
>  CONFIG_LOGO=y
> -# CONFIG_LOGO_LINUX_MONO is not set
> -# CONFIG_LOGO_LINUX_VGA16 is not set

Two more.

>  CONFIG_HID=m
>  CONFIG_HIDRAW=y
>  CONFIG_UHID=m

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
