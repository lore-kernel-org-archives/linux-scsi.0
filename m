Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [194.59.206.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826DC316192
	for <linux-scsi@vger.kernel.org>; Wed,  1 Apr 2026 07:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=194.59.206.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775027016; cv=none; b=UmPNEbU8iZxTB9TH8HquRpv1/umbPItDTAtKnreFjQZ0Oj2922/I8I6uoXbNIVUqQlzXRpEhqBcanXAGSO+s3jpr72XfcsSrRaDyYfQburfhAiXTTQa0Kov8/RpypyOGPYJUkNLdxtdk9u1OVYelaQWGZp2QqtMOgyY1LuoCDTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775027016; c=relaxed/simple;
	bh=N8OOutGUwf3lWaTcFhd6/6UsVcM+PoDIr5qT5pP9Eqg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pwCs1qcUbuuMxISwI1U9irF8ycMMWdz4IVMrLusg7Zjlu7NOaQBqhwF2Fws0XBiQlP8eqCNRsxa0wGm6fp+CGWFaB8OscYrxTeE5lsh0K9fsc+G95nOLVQpFCpjDv6Z1AmXG7omrUrIBTccPdKKzXaAFGnVyx3E0jh9ibp4NpX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=WbxzmIWR; arc=none smtp.client-ip=194.59.206.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="WbxzmIWR"
Received: from relay02-mors.netcup.net (localhost [127.0.0.1])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4flwsl4mZDz4642;
	Wed,  1 Apr 2026 09:02:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1775026955;
	bh=N8OOutGUwf3lWaTcFhd6/6UsVcM+PoDIr5qT5pP9Eqg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=WbxzmIWRr0Qb4JoirbZZlVymL/cy1xgW1Hnr6Smfz6BNQ3xhH97bAuspBiGs+HV7a
	 Rl4bmQ29EjV/lVWJSvOKHYK8xKkiRorQ4mUPke5miN4WngMTPDBiYYxKb1aErpY0ny
	 hWgY17GYal6BxzU01rc1rw+VxC7S3Wc9QAMKSlhVjpVbmAQ6UnG9Hh9zKlMR1a1D+h
	 SAIR5IDC0rCcwF9xhk7zC274B53RahmJ/iug0736N4ymtkNYh+KweE1hbNAWzoc3R/
	 QEyaJtnsglkaW/nH5boDK5ehfbptiPDwn58S5YxD4Fr1W35kngk2m69t+9Ry1C9Pek
	 Dcs0KR8hxlYLw==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by relay02-mors.netcup.net (Postfix) with ESMTPS id 4flwsl43pWz7wPW;
	Wed,  1 Apr 2026 09:02:35 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.898
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4flwsj73SNz8sbW;
	Wed,  1 Apr 2026 09:02:33 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id 10046635A4;
	Wed,  1 Apr 2026 09:02:27 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <509b53c2-775f-43ad-8fec-7b59902083d1@leemhuis.info>
Date: Wed, 1 Apr 2026 09:02:26 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
To: me@magik.net, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: 
 <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: 
 <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <177502694743.3974264.8477848332488991285@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: 10046635A4
X-NC-CID: k90a3Lvilgz3jbbyqlnB/I0phzfYRM0q9LeUGwQ+li9kLHXJQz8=

On 3/27/26 04:20, me@magik.net wrote:
> megasas_make_prp_nvme() builds NVMe PRP lists in cmd->sg_frame,
> which is a DMA-pool allocation sized by instance->max_chain_frame_sz.
> [...]
> Before this patch, 6.19.10 crashed repeatedly during boot and normal
> disk I/O. After applying it, the system boots cleanly and completes 4GB
> direct-I/O reads without crashes.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Lukasz Magiera <me@magik.net>

You CCed the regression list, but this lacks a Fixes: tag, which makes
me wonder: what change caused the problem? That tag would also help the
stable team to see where this needs to be applied, so it most likely is
needed.

> [...]

Ciao, Thorsten
