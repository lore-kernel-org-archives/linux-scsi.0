Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.102])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B59BD3DA5DB
	for <linux-scsi@vger.kernel.org>; Wed,  1 Jul 2026 12:24:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.102
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782908691; cv=none; b=OJ+AFw32deSanZ8HAXgR2JHm4/9eln14j64oCKic9ikBl1Un1SBpabInvfyBNG4U6Eu3uIpR5NhbqNiACNYNwbZ3h7ijXEPxatIe/23VMSDl5hbiU2OZ4V7hzQGb8O6AZrzgMU4PUWisXl96vTC+O5sX59GvwRLBaiwzcDse1K0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782908691; c=relaxed/simple;
	bh=QDOIQLG5JvlJbb9ZiEHnk2DlDbYU90BQVj7unXmMjTA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gPvRuR+z4COMBiju5MLchv+IbsaFV04/VfLKbcKRLtJeyGCugyRYEa0/ayE2VRogQbJLLFYhBrRjhpUCBilzlPQGvgap7/OVn3ybsDupJPLO6SK49bZnGiejfYSyChtlJndTPsmmFsFhtdqfkmIxEP2f3CrIRDqbO3pVtYIM6EM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=SlsKxUrX; arc=none smtp.client-ip=188.68.63.102
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="SlsKxUrX"
Received: from mors-relay-2502.netcup.net (localhost [127.0.0.1])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4gqzhw2zq9z6696;
	Wed,  1 Jul 2026 14:24:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1782908656;
	bh=QDOIQLG5JvlJbb9ZiEHnk2DlDbYU90BQVj7unXmMjTA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SlsKxUrXzv4UgHg5eaOp5YR9cIUlKnVrhp7PowhIVr7apKjvxQDIzi5hei+meRYAy
	 lBalUeBHym2Ef51UFlLEGZMIRAH7DoxkfX+FRS260pOHvNKv2+Vmsog78rBJRdKOIv
	 560CFngoduD/Yih/QQ2f+sdIIHzZdxtHyIM2UuqN3URaSBxwR8CS+IuQD0poQrfpBm
	 BwrD3dHmnTMfRPPp3OfuqBVmjzZ2CBXFvisebOZcCTJWbjlBb9y//Pde9LcU+0t9Xl
	 3kN4wBetYMVp4PWl9WR7r//G5QlcAunzquzz55TOzgkuOI5ateaFPCxZ6vHQd8B/Jk
	 2JzxD+f+vDYFA==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-2502.netcup.net (Postfix) with ESMTPS id 4gqzhw2G4Sz4xcT;
	Wed,  1 Jul 2026 14:24:16 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4gqzht52Pxz8tdx;
	Wed,  1 Jul 2026 14:24:14 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 752A260320;
	Wed,  1 Jul 2026 14:24:13 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <49954999-5c2e-4fa7-9674-736e5f7b4216@leemhuis.info>
Date: Wed, 1 Jul 2026 14:24:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
To: me@magik.net, Mats.topstad@intility.no, mail@danielfernau.com
Cc: Mira Limbeck <m.limbeck@proxmox.com>, chandrakanth.patil@broadcom.com,
 kashyap.desai@broadcom.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, megaraidlinux.pdl@broadcom.com,
 regressions@lists.linux.dev, shivasharan.srikanteshwara@broadcom.com,
 sumit.saxena@broadcom.com, Friedrich Weber <f.weber@proxmox.com>
References: <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
 <1cbf0f3e-4d6b-40ce-9d7b-3e9ea7e8f03e@proxmox.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <1cbf0f3e-4d6b-40ce-9d7b-3e9ea7e8f03e@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178290865395.618223.3172970517507401683@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 752A260320
X-NC-CID: WrnxfbG0iNO4kp7bzfQXndwL2si8EGz+VJK/r3EhymUF4TO9y/A=

On 7/1/26 13:09, Mira Limbeck wrote:
> We've seen some similar looking logs, but since they didn't mention
> `prp` at all, we haven't responded here before.

Thx for chiming in here.

> Instead we sent a mail
> to the linux-scsi list [0], but got no response so far.
> 
> In our case the issue was first introduced by commit:
> 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP")

Any reason why you didn't CC the author and the committer of that
change? Even if the bug is in the driver that might have been a good
idea, but before doing that, let's do something else first:

> This is similar to an issue we previously reported with the mpt3sas
> driver [1].
> 
> At least for our tests and one of our users we can say with certainty
> that reducing the queue sectors back to the previous value fixed the
> issue. In our tests this was done manually, and for one of our users
> with their root on the disks, it was handled via udev rules.
> 
> echo 1280 > /sys/block/<dev>/queue/max_sectors_kb
You also in your [0] mentioned that 12da89e8844a ("block: open code
bio_add_page and fix handling of mismatching P2P ranges") fixed things
in v7.0. Make me wonder if that is the case for the others affected by
this. Hence:

Lukasz, Mats, Daniel, have you checked if 7.1 or 7.2-rc2 are still affected?

Ciao, Thorsten

> [0]
> https://lore.kernel.org/all/d171cc76-bf25-48ce-b482-d344669dfc24@proxmox.com/
> [1]
> https://lore.kernel.org/all/7a0cfc66-3131-4b94-87f2-cbb96595ebb6@kernel.org/
