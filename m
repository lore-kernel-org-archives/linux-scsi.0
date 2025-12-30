Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0DFBC2EA;
	Tue, 30 Dec 2025 06:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767075618; cv=none; b=adgiiR6ZHr3/b7BcfcSuOzBe+e5FlPrS51603cWeYuSd2NcSIFXF3jAubljSVNyI5d5qY6k/3YHCEQaa5923CzHMTQGcanFcdxdrp5KyHM7/ZzuOFc1DwdDkQ/B2P7ItqXz1P3BrhYoz5iH1yld8LPy6FAcHBRdC+u/zKO0Klb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767075618; c=relaxed/simple;
	bh=lyPDHkzl3zST1jJLUq1s0vCDx+yZx7BMKtxXHHExYTU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ulxxC5WgYD+V8wfoZ7nfAY21YtxqBOu0jXgtSBhgKH4d/STlcLwxFCyeYTrEErYgktiWXgYDqxf7tF9s3tCs3IkyX2FIWXhw0xVZ2s7Mg3guSLUFWEPg2gT6/3rPgOXwTeMKHPGuJVNDoWcq4wb7qqqWjmZxH7EFTY6wQBMslZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=O+VXWRmP; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="O+VXWRmP"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2efdb9a45;
	Tue, 30 Dec 2025 14:20:09 +0800 (GMT+08:00)
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
Subject: Re: [PATCH 1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Tue, 30 Dec 2025 06:20:08 +0000
Message-Id: <20251230062008.1021449-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
References: <149a576a-6a21-48c6-b121-b20c6173f7cb@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b6de9fa7803a1kunm918b95ef14c696
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaGUsZVkxITk9LGU8dSRlCSFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=O+VXWRmPzu57IJC23dj9OONuG29IzOiXRWICjy2S/8lmRVUgT1pX44jMw0v9spmt9poe8PLH3W++4CYEkMCwXk6dmQ+xN5bzKWRgtx/YXFKLHtU6ImRM+39WSqrwVM3b6sxyfSo5N6cznz//YIuK6dBpXzhdXP1Y1KgZXGLNR3U=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=0m+SUCyRE4GwCYd+/7AWNBUXIDMJ9s+91wUtPzkAUfc=;
	h=date:mime-version:subject:message-id:from;

On Mon, Dec 29, 2025 at 10:09:04AM +0100, Markus Elfring wrote:
> …
> > Fix this by adding mempool_free() in the error path.
> 
> Please avoid duplicate source code here.
> https://elixir.bootlin.com/linux/v6.19-rc2/source/drivers/scsi/lpfc/lpfc_init.c#L563-L564

Thanks for pointing this out. I will use a goto label to unify the error 
handling logic and avoid code duplication in v2.

> See also:
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc3#n262
> 
> Regards,
> Markus

Regarding the stable kernel rules, do you consider this bug severe enough 
to warrant a Cc: stable tag? Since this error path is unlikely to be 
triggered during normal operation and the leak is small, I didn't think 
it was critical enough to bother the stable maintainers.

Thanks,
Zilin Guan
