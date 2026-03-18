Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AAB3B95EC
	for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 09:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773827466; cv=none; b=R2/+klhMVrrUOdzW4VqDuAsMf46XmQdM9bADTjxuH/Xhhd5cWXneaqvDEcUsRgWi5XdV7oUO+mk/ajZ6elF/6RsouzmBJG+4eUwE3pH8dDOe98x71JYciz6DgP/CSAcZ68kiON6b1Wo2xC56+83nWAQWo0ontdTtsvDWocGRDqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773827466; c=relaxed/simple;
	bh=rZ6XLqrSHLVYtGkiWq+/3mIvzZ8RhMzqjek4N8MpSH8=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:Cc:To:From:
	 References:In-Reply-To; b=Kz3ENeZPIFRBXrB9gXrYoAD2zJ3nDXfc+b8wkP+F9hrFiN5Q0PEFCI2TV0NlL3GiFB4q5UDq+a4VAdNtr9JKzEpUbOWwliZtTrD9wAuV8FV6sIlVBjsBrjyXtqbF1HbmgyPAFN9xanMBZprW4kBHn5vGKAtziiNR1eJk5mifFrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=ar4+CWE7; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="ar4+CWE7"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4852c9b4158so59296655e9.0
        for <linux-scsi@vger.kernel.org>; Wed, 18 Mar 2026 02:50:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1773827455; x=1774432255; darn=vger.kernel.org;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rZ6XLqrSHLVYtGkiWq+/3mIvzZ8RhMzqjek4N8MpSH8=;
        b=ar4+CWE7jmFpDlvhZEkRV98tby/YOxxwTNhJgUizrtWV7kLIAgZu/q9EunFsTeQIg6
         v99TRDiA88bWkWI8h2Y0EZJcG6CyXdyTjrHRJhT6znP38qjl2sWl2LK2NMN+0GnGT5J+
         /9X62r0U3fZbfSlsuf5MS2uBE+SqJ6gjtxJFMxsB7J9YVk8IPzM+/7NYZWwtZcj/PJUB
         ewBf+eoslgCl0G5dOVwpf7OSVK5ZGDiYIzXOYai4fzU0YWiuwmCPh3lWcEr5YH8MdjkY
         z8Gj8r+jUhgsam6JOTZ6Ud6CRYXjURDTJrjiNw1r9DF8tICLr7dinLyTowXUfuyrK86n
         qZew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773827455; x=1774432255;
        h=in-reply-to:references:from:to:cc:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rZ6XLqrSHLVYtGkiWq+/3mIvzZ8RhMzqjek4N8MpSH8=;
        b=DdJ1jgLVB6OUZCewQO4F4GGBdYIuAIh1Q5cYgSPxUbnWXgMbYCMftUADwHgT4xZYGF
         hMo0qyvC6K60/z0TH8PA3bmQwHnqvu59QSyw2mV1XBLj+r+EMvJR7eK9X6TuzjyvhTdk
         ogiJhTR7Spoxad9wBXnf1ZRwK+3yLm+oUS3vEWTwsrkGxa4oL3ev+AGIPX84/6OfGWuP
         XZMNRMKVvz71laqNQWjvPTHqTSmmRowPsLdxiQN3crNpHnpb+hmUtuuNUztJzwA8V4Ax
         aDgJR3/sejeNiIiw7L4f9jzije91yYx2vok9kSyNLxnUeD8rKc68JSDllnitEd6GfpXh
         TcLg==
X-Forwarded-Encrypted: i=1; AJvYcCVgnFnAvsjzfZ19POXI/jplk3+R1ipiTPm4lMogGDAC93VKoXkx+7m78S6/2UoykRDaxqnaUJC2vBBg@vger.kernel.org
X-Gm-Message-State: AOJu0YyRc+uOK4/okX0RmF+aHiwrvG5f2XJFaNvXbA5k/0+xw/oNkaxz
	hvzm8hnBziIteiBjQkooJ+7+NxhK3+SaOymWGLbmAvEU+xTYl8ZyWYw5CISsK1MkmFo=
X-Gm-Gg: ATEYQzw6U7qin+p+3C8WB0IZEWNqwWE4irob2vAKwb8ufw24/Lj1QagjFm8ENM5+RIF
	5G2HDx+gaG6SNiuUs6o8bsac331BqgvqBo5EQyxf/eIqIbrnWL2l7t3pgeDwn3dUufDmvTRwJyk
	VXAQZxHnpX4V9SglmeMOTACdskspKFshYKDznWNbdcXgniTgYdYu+uhaO+thQIWG4ejmAh5FvPo
	54UvUhNUlgXr0uJUbEYxtET9VZ98a/JVI31jPjEPiC4yTdu1Iy4IZ4jP8iRVw4gyxqzy7/BYEOU
	o88wScadIbQpQ04tBJ8vVh1eZFuCtz7TVsuTGFFRqQHTjXZUsvGzfRB7sPNxZ2uACQFYcDazUK7
	lPUE0T+TEdNyxeE9HajEIv19gzuijqVYhyC9wbVdvB5WSTIhZVGqUm5Y//dNsqq+q8KFWdXooA3
	/OKZtn4S71KUoNwCxQLkc=
X-Received: by 2002:a05:600c:4612:b0:485:40db:d40c with SMTP id 5b1f17b1804b1-486f442e710mr28542555e9.3.1773827454803;
        Wed, 18 Mar 2026 02:50:54 -0700 (PDT)
Received: from localhost ([189.99.238.44])
        by smtp.gmail.com with ESMTPSA id 00721157ae682-79a715f8b61sm13492337b3.44.2026.03.18.02.50.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 02:50:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Mar 2026 06:50:51 -0300
Message-Id: <DH5TCPI2CFJ2.ZBO1LQWYQUCO@suse.com>
Subject: Re: [PATCH 01/10 net-next v3] ipv6: convert CONFIG_IPV6 to built-in
 only and clean up Kconfigs
Cc: =?utf-8?b?UmljYXJkbyBCLiBNYXJsacOocmU=?= <rbm@suse.com>, "Krzysztof
 Kozlowski" <krzk@kernel.org>, "Geert Uytterhoeven" <geert@linux-m68k.org>,
 "Jason Gunthorpe" <jgg@ziepe.ca>, "Leon Romanovsky" <leon@kernel.org>,
 "Selvin Xavier" <selvin.xavier@broadcom.com>, "Andrew Lunn"
 <andrew+netdev@lunn.ch>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, "Jakub Kicinski" <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, "Ido Schimmel" <idosch@nvidia.com>, "Petr
 Machata" <petrm@nvidia.com>, "Simon Horman" <horms@kernel.org>, "Saurav
 Kashyap" <skashyap@marvell.com>, "Javed Hasan" <jhasan@marvell.com>,
 <GR-QLogic-Storage-Upstream@marvell.com>, "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "Nilesh Javali" <njavali@marvell.com>,
 "Manish Rangankar" <mrangankar@marvell.com>, "Varun Prakash"
 <varun@chelsio.com>, "Alexander Aring" <aahringo@redhat.com>, "David
 Teigland" <teigland@redhat.com>, "Andreas Gruenbacher"
 <agruenba@redhat.com>, "Nikolay Aleksandrov" <razor@blackwall.org>, "David
 Ahern" <dsahern@kernel.org>, "Pablo Neira Ayuso" <pablo@netfilter.org>,
 "Florian Westphal" <fw@strlen.de>, "Phil Sutter" <phil@nwl.cc>, "David
 Howells" <dhowells@redhat.com>, "Marc Dionne" <marc.dionne@auristor.com>,
 "Marcelo Ricardo Leitner" <marcelo.leitner@gmail.com>, "Xin Long"
 <lucien.xin@gmail.com>, "Jon Maloy" <jmaloy@redhat.com>, "Bjorn Andersson"
 <bjorn.andersson@oss.qualcomm.com>, "Arnd Bergmann" <arnd@arndb.de>, "Shawn
 Guo" <shawnguo@kernel.org>, "Eric Biggers" <ebiggers@kernel.org>, "Michal
 Simek" <michal.simek@amd.com>, "Luca Weiss" <luca.weiss@fairphone.com>,
 "Sven Peter" <sven@kernel.org>, "Lad Prabhakar"
 <prabhakar.mahadev-lad.rj@bp.renesas.com>, "Kuninori Morimoto"
 <kuninori.morimoto.gx@renesas.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Kuan-Wei Chiu" <visitorckw@gmail.com>,
 "Herbert Xu" <herbert@gondor.apana.org.au>, "Ryota Sakamoto"
 <sakamo.ryota@gmail.com>, "Kuniyuki Iwashima" <kuniyu@google.com>, "Kir
 Chou" <note351@hotmail.com>, "David Gow" <david@davidgow.net>, "Vikas
 Gupta" <vikas.gupta@broadcom.com>, "Bhargava Marreddy"
 <bhargava.marreddy@broadcom.com>, "Rajashekar Hudumula"
 <rajashekar.hudumula@broadcom.com>, =?utf-8?q?Markus_Bl=C3=B6chl?=
 <markus@blochl.de>, <linux-kernel@vger.kernel.org>,
 <linux-m68k@lists.linux-m68k.org>, <linux-rdma@vger.kernel.org>,
 <oss-drivers@corigine.com>, <linux-scsi@vger.kernel.org>,
 <gfs2@lists.linux.dev>, <bridge@lists.linux.dev>,
 <netfilter-devel@vger.kernel.org>, <coreteam@netfilter.org>,
 <linux-afs@lists.infradead.org>, <linux-sctp@vger.kernel.org>,
 <tipc-discussion@lists.sourceforge.net>
To: "Krzysztof Kozlowski" <krzysztof.kozlowski@oss.qualcomm.com>, "Fernando
 Fernandez Mancera" <fmancera@suse.de>, <netdev@vger.kernel.org>
From: =?utf-8?b?UmljYXJkbyBCLiBNYXJsacOocmU=?= <rbm@suse.com>
X-Mailer: aerc 0.21.0-120-g22b95d38161f
References: <20260317140141.5723-1-fmancera@suse.de>
 <20260317140141.5723-2-fmancera@suse.de>
 <69dd007c-16d3-44c2-bc30-4e7f5a95addb@oss.qualcomm.com>
In-Reply-To: <69dd007c-16d3-44c2-bc30-4e7f5a95addb@oss.qualcomm.com>

On Wed Mar 18, 2026 at 3:51 AM -03, Krzysztof Kozlowski wrote:
> On 17/03/2026 15:00, Fernando Fernandez Mancera wrote:
>> Maintaining a modular IPv6 stack offers image size savings for specific
>> setups, this benefit is outweighed by the architectural burden it
>> imposes on the subsystems on implementation and maintenance. Therefore,
>> drop it.
>>=20
>> Change CONFIG_IPV6 from tristate to bool. Remove all Kconfig
>> dependencies across the tree that explicitly checked for IPV6=3Dm. In
>> addition, remove MODULE_DESCRIPTION(), MODULE_ALIAS(), MODULE_AUTHOR()
>> and MODULE_LICENSE().
>>=20
>> This is also replacing module_init() by device_initcall(). It is not
>> possible to use fs_initcall() as IPv4 does because that creates a race
>> condition on IPv6 addrconf.
>>=20
>> Finally, modify the default configs from CONFIG_IPV6=3Dm to CONFIG_IPV6=
=3Dy
>> except for m68k as according to the bloat-o-meter the image is
>> increasing by 330KB~ and that isn't acceptable. Instead, disable IPv6 on
>> this architecture by default. This is aligned with m68k RAM requirements
>> and recommendations [1].
>>=20
>> [1] http://www.linux-m68k.org/faq/ram.html
>>=20
>> Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
>> Tested-by: Ricardo B. Marli=C3=A8re <rbm@suse.com>
>
> That's a Kconfig/defconfig only patch, so build system. You cannot test
> it in a meaning of testing code. Building code is not testing.

Should I have sent 9 emails instead of 1 to the whole series?

>
>> Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
>
> You removed important parts of Ack. It was not provided like that.
>
> Best regards,
> Krzysztof

