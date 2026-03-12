Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F4A13F54C1
	for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 16:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773331955; cv=none; b=G15lyFQ8gTwjGtdtbeKOZjq4s0uXQCYc9aIycNLxlVrsLZiUtcMgd9nuXwwVGNEqc0rCefMLdXYhLlMh/jKbjYXo+Zl1PJn8Te3bkbUTXtUuQlcRU0a+ByFkXIZeZ2kleGUz2DM7dosyspqtIMCxtztabiMmvw1PLNVloRQwCzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773331955; c=relaxed/simple;
	bh=J0G6eyWjCZe2EavnpoZMaa3QDnbvlnCWthcPft0y1xg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T0yNC8+IoRGYmWFP6trmRF02yIElBW99A3E6/SqQJWo74lMlZPHyQ5e13L9wLR8J8qXy1X3bkI/QXQlqnuL3dHKLfStQbLzhypobNf/FnoBy5cqbXtnnV2bCJIX23FFU51MpzQ8JefglVKy4JjTHGHKF4BA11qDde7EPtvKT+m8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org; spf=pass smtp.mailfrom=gmail.com; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d73d6976adso1084073a34.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 09:12:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773331950; x=1773936750;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r8DuBIlRqwUybKw9BKko7+xZruw6jP0mIyTYZl7vHWM=;
        b=OUwbKNETFhjlobxdl6xxJjX//H+Bv/7oLQnTUHKfdSIi7SMKIW42vSKo0rsf8COI37
         FZTkAs3DmMWv4rnTYY64TreeOTiN0zKk9QtXm4CZkGk3g69tWBCZso51LO0lcr74czWS
         VCnBkO5wC1mt3+GfNR8c+USC8PB2z46wj31Y5Pl7p4svRQa7JWFcsawe8ULsx1nsN7LS
         94vAHn8gX4cJ1fDNFbNQsqvXnNmKDfvwDUP9tNuF9pU7Q24glgkf7g3ZBbIPNg6IP+Y4
         hUFsosTXg81wR5Sl3Gab1ykm7kT3oJ0NkzBQe347aI+yX5/CvF7hITyhDVZ2DNsHRg1M
         8zJg==
X-Forwarded-Encrypted: i=1; AJvYcCV7kM+xZ9TBQ0obxdYTJGZCCrnrK67kLjpHtmkinKLvsC4WpC4kjQ9ImWE5kCrTqV+mk/9WzWpRN4Sa@vger.kernel.org
X-Gm-Message-State: AOJu0Yw/gLafwQQCspoeyWeuFM+ULO4fF3yJHEdrP4ATLorHANn1TYlW
	CIDvlbFa/xSkWGqE5sEIptCagNPsMYOc2vLF+q9rCG48YSVlO8SXRHtE4eb+CBpFacg=
X-Gm-Gg: ATEYQzyM/wPAjH1TazaIF+a3Z/+9narWVLnCNFk2QzxtQC0YH5X8jD2/lY1NWnhhnkR
	cxEKDE9sXhwjsVwuvZ0JLKZuaEqrO5HWmgyanbbS1eDrsWdSIMd62U9gtM1JqFaI3ndZ5H+8Fsp
	asuQZJw05xeXvcylG7RsgmTZNaIxN1THiZ44dOfOsFzuiiHwJLm2+6oPpSMDmwPcNr46IlfEv7k
	FxhfbJQVnZOfF4JkdT17p3mlZmo7k6L6y3OyPKTR0XQax7ldy7R1CP9eXAtQPRmBKdfCJffUM8o
	+ykBFkbQ3/phWm1RitgLUzsgLXIjK85Mzh+Xx7IplwS4jM2Omhvg8LnjKQz97FYOH/BEHrCELVG
	3IjMN0CrQ4JE/AJy0ruiPlSzWCkntUelX8EZMvbAqvFw4ZwRWWGeYZ7J8wG2kf1W5emm2evwZmi
	fClVADZ4dhWsOcnK2xu4pjvQOMuRNTI4Nn+rK3ree69PqCM7YlLqnjDrgEXxkzaOWj
X-Received: by 2002:a05:6830:913:b0:7cf:d1eb:f37a with SMTP id 46e09a7af769-7d76a7472acmr4915180a34.18.1773331949893;
        Thu, 12 Mar 2026 09:12:29 -0700 (PDT)
Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com. [209.85.167.175])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7d76aebc9d3sm4394140a34.24.2026.03.12.09.12.29
        for <linux-scsi@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Mar 2026 09:12:29 -0700 (PDT)
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-463a0e14abfso786838b6e.2
        for <linux-scsi@vger.kernel.org>; Thu, 12 Mar 2026 09:12:29 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWVtwq0pG9eGMIjfIfmjacJNCn6fgbw4Mnm9vTOL+HHpTj82j5dgB7eED0tm5tH4a+7cOeIKDUuQO6e@vger.kernel.org
X-Received: by 2002:a05:6102:512b:b0:5ff:22f5:e37e with SMTP id
 ada2fe7eead31-601deb4d089mr2630417137.10.1773331557630; Thu, 12 Mar 2026
 09:05:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260310153506.5181-1-fmancera@suse.de> <20260310153506.5181-2-fmancera@suse.de>
 <20260311200219.45796ec4@kernel.org> <aebac89f-f3b9-4983-8139-353a3ff19c98@suse.de>
In-Reply-To: <aebac89f-f3b9-4983-8139-353a3ff19c98@suse.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Thu, 12 Mar 2026 17:05:46 +0100
X-Gmail-Original-Message-ID: <CAMuHMdWK0P+EEQXOQ8FMb7DYt-95dAmmbOjMhxCKHnvHRntojA@mail.gmail.com>
X-Gm-Features: AaiRm51vTFby3MbWyu4EKyWe_lBoIWwNWM0L5hUj3OB8Sdn3mba4moA7Rj12Mh4
Message-ID: <CAMuHMdWK0P+EEQXOQ8FMb7DYt-95dAmmbOjMhxCKHnvHRntojA@mail.gmail.com>
Subject: Re: [PATCH 01/10 net-next v2] ipv6: convert CONFIG_IPV6 to built-in
 only and clean up Kconfigs
To: Fernando Fernandez Mancera <fmancera@suse.de>
Cc: Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org, rbm@suse.com, 
	Jason Gunthorpe <jgg@ziepe.ca>, Leon Romanovsky <leon@kernel.org>, 
	Selvin Xavier <selvin.xavier@broadcom.com>, Andrew Lunn <andrew+netdev@lunn.ch>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Paolo Abeni <pabeni@redhat.com>, Ido Schimmel <idosch@nvidia.com>, Petr Machata <petrm@nvidia.com>, 
	Simon Horman <horms@kernel.org>, Saurav Kashyap <skashyap@marvell.com>, 
	Javed Hasan <jhasan@marvell.com>, 
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

On Thu, 12 Mar 2026 at 16:12, Fernando Fernandez Mancera
<fmancera@suse.de> wrote:
> On 3/12/26 4:02 AM, Jakub Kicinski wrote:
> > On Tue, 10 Mar 2026 16:34:24 +0100 Fernando Fernandez Mancera wrote:
> >> Maintaining a modular IPv6 stack offers image size and memory savings
> >> for specific setups, this benefit is outweighed by the architectural
> >> burden it imposes on the subsystems on implementation and maintenance.
> >> Therefore, drop it.
> >>
> >> Change CONFIG_IPV6 from tristate to bool. Remove all Kconfig
> >> dependencies across the tree that explicitly checked for IPV6=m. In
> >> addition, remove MODULE_DESCRIPTION(), MODULE_ALIAS(), MODULE_AUTHOR()
> >> and MODULE_LICENSE().
> >>
> >> This is also replacing module_init() by device_initcall(). It is not
> >> possible to use fs_initcall() as IPv4 does because that creates a race
> >> condition on IPv6 addrconf.
> >>
> >> Finally, modify the default configs from CONFIG_IPV6=m to CONFIG_IPV6=y
> >> except for m68k as according to the bloat-o-meter the image is
> >> increasing by 330KB~ and that isn't acceptable. Instead, disable IPv6 on
> >> this architecture by default. This is aligned with m68k RAM requirements
> >> and recommendations [1].
> >
> > AI has spotted:
> >
> >> diff --git a/arch/m68k/configs/amiga_defconfig b/arch/m68k/configs/amiga_defconfig
> >> index 31d16cba9879..de088071dde4 100644
> >> --- a/arch/m68k/configs/amiga_defconfig
> >> +++ b/arch/m68k/configs/amiga_defconfig
> >> @@ -64,7 +64,6 @@ CONFIG_NET_IPIP=m
> >>   CONFIG_NET_IPGRE_DEMUX=m
> >>   CONFIG_NET_IPGRE=m
> >>   CONFIG_NET_IPVTI=m
> >> -CONFIG_NET_FOU_IP_TUNNELS=y
> >>   CONFIG_INET_AH=m
> >
> > Is CONFIG_NET_FOU_IP_TUNNELS=y removed intentionally? This option
> > provides FOU/GUE encapsulation for IP tunnels and has 'depends on
> > NET_IPIP || NET_IPGRE || IPV6_SIT' as its Kconfig dependency. With IPv6
> > disabled, IPV6_SIT becomes unavailable, but CONFIG_NET_IPIP=m and
> > CONFIG_NET_IPGRE=m are both still present in the defconfig, so the
> > dependency remains satisfiable.
> >
> > Since CONFIG_NET_FOU_IP_TUNNELS has no 'default y', removing it from the
> > defconfig means FOU/GUE encapsulation for IP tunnels will be silently
> > disabled by default on m68k. The commit message describes only disabling
> > IPv6 on m68k, not removing IPv4 FOU tunnel support.
> >
>
> I noticed that when running
>
> ./scripts/config --disable CONFIG_IPV6
>
> for the m68k, the script was adding CONFIG_LWTUNNEL=y and CONFIG_NET_FOU=y.
>
> CONFIG_LWTUNNEL was selected by multiple IPV6 features. I do not think
> it makes sense to keep it for m68k given the information there is on
> http://www.linux-m68k.org/faq/platinfo.html.

Dunno about lwtunnel...

> CONFIG_NET_FOU was something IPV6_FOU required, probably it should be
> just dropped from the config instead of explicitly turn it off as it
> turns off FOU_IP_TUNNELS too. It will be selected by FOU_IP_TUNNELS too
> anyway.

... but CONFIG_NET_FOU seems to be just a gatekeeping symbol
for the tristate symbol IPV6_FOU, so FOU is still a module., which is good.



Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
