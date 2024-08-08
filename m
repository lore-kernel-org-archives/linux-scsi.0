Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905A23398E;
	Thu,  8 Aug 2024 19:09:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723144201; cv=none; b=rnUvsXuYTxWG6PoPjjB6He5r8jhja44CeRvO7M+G8rN8q2DK/xYHmOkp8kvsxCfLTjR88RLrYlsTa49Jtd/FO8fl5GY/6KsicNZRMMc/qD2X0EKDkIE04IaFGQVUlg4IE9vD/F91O6hsthu77LPydS/tX5DeburIv2LeF3Qcfmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723144201; c=relaxed/simple;
	bh=4InJsfp3moCvS4P2KrDgD5LUJ/naFpBgxZdnwp047OY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FZMTe6skH4Zx++gj7FD6Nya9oV94RyMEfgCPDbQE/Dvf3Ztk5sgbWbQkFjLXve6s+Da/wH+QZCQpnI3mwEB7F+n6CnIjkPxJfvtJ26FBP05n1T4/W0MBs4CE/j3+iy9dV74ehF4WkyEcvUrFklVi3VoppvgyP5dPBMBmLeAmVqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=lhXQ51Rc; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="lhXQ51Rc"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4WfxSQ6jrqz6ClY8v;
	Thu,  8 Aug 2024 19:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723144196; x=1725736197; bh=WSafhyqZ1i29asjxYVWb1Irs
	pNmIdocUNjodtln5IpE=; b=lhXQ51RcoXlsYey/eDZqfVcN5Vrq52D0dDJ9DwzI
	nowWMPcSMqrpvOiUP7CZ5NGtC4cElQckKDURFmJbm0t7ic1YyEini8l2pfVoObMf
	aygqyn4gd3XfpPEay4b2pp8HwdaVfQPodG8BtKDC3fPrxEYB6I2Uq9TB4i965UH8
	LoyhJYW1XEX5XHV3xj0fx4Qs2FoH8GSypBt34vrS+BAlrL73k77GHy28uyDNLbZ7
	vc4FCy55DBkkefRkZxWcCR2XRmwS4k8LY4iGwFe+r+wuem24WB/UN0bhrUgfTcv6
	PkiDyKxR9mVjjURjVNvbM82EmYkNMRY3KwJCsin8rYmegg==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id SV1VdbXjWsTv; Thu,  8 Aug 2024 19:09:56 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4WfxSL5Xz3z6ClY8t;
	Thu,  8 Aug 2024 19:09:54 +0000 (UTC)
Message-ID: <1cd0b145-431a-4d9f-979f-04d4063eeda8@acm.org>
Date: Thu, 8 Aug 2024 12:09:52 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: retry command SYNC CACHE if format in progress
To: Yihang Li <liyihang9@huawei.com>, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 prime.zeng@huawei.com, linuxarm@huawei.com
References: <20240808021719.4167352-1-liyihang9@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240808021719.4167352-1-liyihang9@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/7/24 7:17 PM, Yihang Li wrote:
> If formatting a suspended disk (such as formatting with different DIF
> type), the SYNC CACHE command will fail because the disk is in the
> formatting process, which will cause the runtime_status of the disk to
> error and it is difficult for user to recover it.
> 
> To solve the issue, retry the command until format command is finished.

How is the format command submitted to the SCSI disk? Is that command
perhaps submitted as a SCSI pass-through command (SG_IO ioctl)?

Should the sd driver perhaps be unbound while the format command is in
progress?

Thanks,

Bart.
