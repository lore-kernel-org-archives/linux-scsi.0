Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A6587261C;
	Thu, 28 Aug 2025 13:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756387961; cv=none; b=MvDxCc9MjiCmaiidSJecx+4fquEt40/kxtwjHoX+K01CQVcfrik4/cureo65nranYbN+V5IXmNgQrcG3Ku/cGr2SjFsy8AhEuDKPGVAe8Fi9lMEyRyO+fCzUjbn8XJZV9JadAe6a8rT45EKkAL1y1OX7yPpFsPKhSKZVjl6remw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756387961; c=relaxed/simple;
	bh=OeKNbTw5D5uBCn/CUeyles28MY6Cqcp0NZN1ZxxsTW8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sv6Z6SBSdLG8DLFn3RZCLocRuGlW4ShnxwVr+LGIPAgwVD4Uolunn/lpPnz1BMBvqHT1JQRvCE9HqSaH3aL2ZvY25kA42BXJ3bLaQSwrSMc5WtPofmH95sj6xkBiFG/X86nLrMq3bJWoGrUOxy01TYseU+O8DGCutxorYch9eR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DKJnsYkY; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DKJnsYkY"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4cCMlV2kQwzlgqVc;
	Thu, 28 Aug 2025 13:32:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1756387956; x=1758979957; bh=+afyIWdnQS49DzHZvJJ1e6Fx
	Cvb+A3s5xWN45Dg3qq0=; b=DKJnsYkYSrnIOf6N6II4qRC5GxnLPbkpYsjfh4cM
	RM8dnf5HZBBaTt7Pk7fOUfivaY6uvlDKDtBDUbnvm9vo274q7nlIcwvDA/tBxdOW
	9gOU3W+lXZPTLsdaUwMBFTsmATQdQXhGNbCNQmZaHcj03caxJ660+0xwEaM/ZNrE
	g53Wfto5MRbHyas+qNH6TDk6ZqGSPnol8RkoElrdGZK/YoYiQMc+8aFXv9QgFNR1
	ICL3+7F4lsfysxT3POjSDv5ctjwPDo3wuF/aDLxmmTcEBR9PC8Dolm47rBno4tgo
	0waAmwALegaOs94bd34wlnFDjrz2xr1lrai02jvSihcddw==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id So-d6UAwmtsz; Thu, 28 Aug 2025 13:32:36 +0000 (UTC)
Received: from [172.20.6.188] (unknown [208.98.210.68])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4cCMlN6hSpzlgqyg;
	Thu, 28 Aug 2025 13:32:32 +0000 (UTC)
Message-ID: <d088a62e-03b6-4032-91f8-5f0bf4d1547b@acm.org>
Date: Thu, 28 Aug 2025 06:32:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v24 00/18] Improve write performance for zoned UFS devices
To: Hannes Reinecke <hare@suse.de>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
References: <20250827212937.2759348-1-bvanassche@acm.org>
 <c11bacd8-56d5-4df0-b053-3b618e454855@suse.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c11bacd8-56d5-4df0-b053-3b618e454855@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/28/25 4:23 AM, Hannes Reinecke wrote:
> Before we're doing yet another round here, have you checked whether
> the patchset from Yu Kuai ("PATCH RFC v2 00/10: block: fix disordered IO 
> in the case of recurse split") does help in your case, too?

Hi Hannes,

Thanks for having taken a look. Yu Kuai's patch series is independent of
this patch series. The patch series "PATCH RFC v2 00/10: block: fix
disordered IO in the case of recurse split" affects the order in which
split bios are submitted by RAID drivers and by dm-linear. None of these
drivers are used in the devices I care about (Android devices).

This patch series increases IOPS for small writes whether or not the
patch series "PATCH RFC v2 00/10: block: fix disordered IO in the case
of recurse split" is applied.

Does this answer your question?

Bart.
