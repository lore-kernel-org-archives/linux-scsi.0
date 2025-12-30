Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59564EAE7;
	Tue, 30 Dec 2025 09:05:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767085524; cv=none; b=TEgthTkxMrMFTbHu9tRBo1MdhfV/iwpp+x8CCTGmzPXPouAv7w23P7mTOi9oihS9+WwtqdVVBxXRIpTVyJAg/Ee+QYy0eo8HlufZoXVoxuhHF4I2kOsrvx/9rg/G1kVEmwh1bvi1SMmRCJlk0s5f+UC2t65nYq4w0SCsEjzIfIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767085524; c=relaxed/simple;
	bh=k4sY50FPfbD6ZwKrhpzEFPocG7d6UVIuDlgVJBKldUg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iEq4R0S6Z8xTXX3azWTzR33W5xaoUOz22+qTMb5CIUMEJAuqHFAXSQYN9EAcNgdz8CeiUQn7tLUtGm+jJOIXqht/NZZplEaTIGJym91s//rsbJ6GpiaOPgTG93aAwTL3l2RwL3/xVWrq6S3HfYJrxUhABY25BFUwiwnl3L2EnT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=HlYUCGc1; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="HlYUCGc1"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f039f0d3;
	Tue, 30 Dec 2025 17:05:15 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: markus.elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	jianhao.xu@seu.edu.cn,
	justin.tee@broadcom.com,
	kernel-janitors@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	zilin@seu.edu.cn
Subject: Re: [1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Tue, 30 Dec 2025 09:05:13 +0000
Message-Id: <20251230090513.1129573-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <c8d2af7e-5ddf-4de2-ac1a-8a938280a0f4@web.de>
References: <c8d2af7e-5ddf-4de2-ac1a-8a938280a0f4@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6e81219603a1kunme6964aec155fe2
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZHkhKVkwfT0wZTB9KGUJJTFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=HlYUCGc1d4I5+0292lImEq5hWAK0xkD3m3KEeNXHZMsWCWVMs1hIhv++dbw+ackE4Vsr3mQWlzdfoaaSk5iP+phCa996vnI/qBGHMCTbza8eCMGSd777F4xAIjMh84t1HK1cCzTPUQfbqZSAQ+PY1KVEDSUKuZWpFAL0EUkLjFo=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=4LtuWVYthvZLOJHpGm4Ova5Rkdy7vwIEppXmzTtoxMo=;
	h=date:mime-version:subject:message-id:from;

> I suggest to take another look at information from previous discussions on
> severity filters.
> ...
> It seems that basic data processing was not hindered so far by the affected
> function implementation.
> ...
> The tag “Fixes” is also an indication for related development considerations,
> isn't it?

Thanks for the clarification.

I agree that the "Fixes" tag provides sufficient context for tracking. 
Given that the bug does not impact basic functionality, I will rely 
on the "Fixes" tag and leave the backporting decision to the stable 
maintainers' discretion, rather than explicitly adding the "Cc: stable".

I will send out v2 with the code refactoring (using goto) shortly.

Regards,
Zilin Guan
