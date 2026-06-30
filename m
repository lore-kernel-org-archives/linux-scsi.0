Received: from relay.yourmailgateway.de (relay.yourmailgateway.de [188.68.63.166])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5373F39E3
	for <linux-scsi@vger.kernel.org>; Tue, 30 Jun 2026 10:32:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=188.68.63.166
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782815526; cv=none; b=fwwsTYXlE0kM8Og46MZrhFPXvKcq9COJeJ7zHNEUhPhXXwr2RWJpAlb5zC0CBoZjV4tzKhxSfhLlcx/aai/oPb3ZAmGJCi5XWnwuVLMNJyiCHeEzdEHVdEI6q0h2QUqA324Xe6gtgshLSNsBhehpIOP1ZOaN7XPHu037jeZ2Wlg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782815526; c=relaxed/simple;
	bh=dMKciSBThW0e2xkPZQlDrg/wfU9MCZS/KNgoTfIDdKg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5isRgmaiz5RolgZCj2rtm/57SHs/dZXYhrmvepsvmqeQF2Sxw5f3vdI3nQQE4liogsbzV/QDpeprXQA7QlfrB9nqO3McWS9H6VldFyf7mNieyeTCxbO1YcE4IxhkxnzkwhaA1QWPU6w4eRaXL9L5FASwXw4kwOktWrllA7/6Ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info; spf=pass smtp.mailfrom=leemhuis.info; dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b=fMyjjTFK; arc=none smtp.client-ip=188.68.63.166
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=leemhuis.info
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=leemhuis.info header.i=@leemhuis.info header.b="fMyjjTFK"
Received: from mors-relay-8202.netcup.net (localhost [127.0.0.1])
	by mors-relay-8202.netcup.net (Postfix) with ESMTPS id 4gqK7g5T7Sz47qr;
	Tue, 30 Jun 2026 12:26:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=leemhuis.info;
	s=key2; t=1782815199;
	bh=dMKciSBThW0e2xkPZQlDrg/wfU9MCZS/KNgoTfIDdKg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fMyjjTFK2GcceH+HI+4s/b8NR7Yswy3WNWLbwMz7BOyWrPXQcTPHkGRrUlSQHBSxc
	 3exK5a2S/rxtxdlhsluULW3Vf/5b1YunxQ2fjv5bM2B3y3k5hQPip/4asYRtXBZ7+U
	 abx2C8jJMY+nEJWzPDODr+ShiP1f6W726X8bQSJFPeNeQezZT3dOIQcp60pSYuYq2P
	 9ivFTlHFTOfqmu6H4qnkisfWvQbBRII34OQ6VUgtEJiDR3/pXXe8c6gq4F4eZvrtxb
	 xOpuqzHmv3pb/nb+xHJGhsFZMHgtv6y8RKaVJodmqTorTNIRHrvSDQ9iwkgqvrirV6
	 VCpG6pUSkBXuw==
Received: from policy01-mors.netcup.net (unknown [46.38.225.35])
	by mors-relay-8202.netcup.net (Postfix) with ESMTPS id 4gqK7g4jjRz47qh;
	Tue, 30 Jun 2026 12:26:39 +0200 (CEST)
X-Virus-Scanned: Debian amavisd-new at policy01-mors.netcup.net
X-Spam-Flag: NO
X-Spam-Score: -2.901
X-Spam-Level: 
Received: from mxe9fb.netcup.net (unknown [10.243.12.53])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by policy01-mors.netcup.net (Postfix) with ESMTPS id 4gqK7f4TgJz8tfK;
	Tue, 30 Jun 2026 12:26:38 +0200 (CEST)
Received: from [IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f] (unknown [IPv6:2a02:8108:8984:1d00:a0cf:1912:4be:477f])
	by mxe9fb.netcup.net (Postfix) with ESMTPSA id B2DB46037D;
	Tue, 30 Jun 2026 12:26:37 +0200 (CEST)
Authentication-Results: mxe9fb;
        spf=pass (sender IP is 2a02:8108:8984:1d00:a0cf:1912:4be:477f) smtp.mailfrom=regressions@leemhuis.info smtp.helo=[IPV6:2a02:8108:8984:1d00:a0cf:1912:4be:477f]
Received-SPF: pass (mxe9fb: connection is authenticated)
Message-ID: <b8fcdb5e-f2be-4bd0-914d-d03e87af9630@leemhuis.info>
Date: Tue, 30 Jun 2026 12:26:36 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: megaraid_sas: fix PRP list out-of-bounds write
To: "Martin K. Petersen" <martin.petersen@oracle.com>, me@magik.net
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "megaraidlinux.pdl@broadcom.com" <megaraidlinux.pdl@broadcom.com>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 Mats Topstad / Intility AS <Mats.topstad@intility.no>,
 Daniel Fernau <mail@danielfernau.com>
References: 
 <GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net>
 <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
From: Thorsten Leemhuis <regressions@leemhuis.info>
Content-Language: de-DE, en-US
In-Reply-To: <yq15x5lowt9.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-PPP-Message-ID: <178281519817.745337.5466260878205555068@mxe9fb.netcup.net>
X-Rspamd-Server: rspamd-worker-8404
X-Rspamd-Queue-Id: B2DB46037D
X-NC-CID: J/fvpLEl0oyuy9951LYTB1aCKdUOiN/U2rz1xrvOmS8W2ZJUiFM=

On 4/21/26 04:47, Martin K. Petersen wrote:
> 
>> megasas_make_prp_nvme() builds NVMe PRP lists in cmd->sg_frame,
>> which is a DMA-pool allocation sized by instance->max_chain_frame_sz.
> 
> Broadcom: Please comment and review!

Martin, do you know if someone there ever looked into this regression
and the proposed fix? I'm wondering because Daniel and Mats reported
problems under the same subject line (in new threads), but also didn't
get a reply. So together with the one from Lukasz aka "me" we afaics
have three reports now:

https://lore.kernel.org/all/GPhsSM0vkgyIrs0DIZ62qeUZX7X4RxwQXVKiuvMx-lHQVSPDxpztUyQOGS0xikqvJ-Z94hMV-dW_5KN_0CX2hsfV7kTf_t0MTf6vdAAaSEc=@magik.net/
https://lore.kernel.org/all/0CFE3F49-179D-4735-86E2-B6C1EE2FDD2A@danielfernau.com/
https://lore.kernel.org/all/4FE725D3-0702-425C-AAC5-4E0AF86E5EA1@intility.no/

Side note: I still wonders if we somehow could fix this by reverting
something, but none of the reports afaics references which change
introduced the problem. And given that the problem already exists in
6.18 a clean and quick revert is unlikely anayway. :-/

Ciao, Thorsten
