Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FEB17745
	for <linux-scsi@vger.kernel.org>; Mon, 29 Jun 2026 01:18:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782695896; cv=none; b=C+WL/kXjmYyRNaIhzBIQzkO3l3KytqbKoV74IOB7lFIsyNqU2Enjzf91sZ9k2rC7bI3Tl6Q0Q2iyPTyALGZED21fANdLwSekeg7N/FjGpDjZXvPYOQEGPsbE58LeUDh7z4tBWfyS8qr1BQ6WBAehxdiUvfvYvOLrTOHoaz2NbKs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782695896; c=relaxed/simple;
	bh=FAxSvtdshfkiJ1HR9NdRVIqZNmb5ki1HYsQEqnQDjys=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kxO4rbppgB53wW3DBDT70UQKnOOiSj7AjTK04wBtfRtSJXtlQ4qEi7rQLPRdAlKChrkbCox2v7EXxTPG/ebVOIUrQ8GHq28VHgM7EzGbhyiMyMg4z6buBxandCUlG/Grw5rcpJx4u0AlbUplnWIM20cwT4cVomKxW/rrLGRQ9JM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=h/xBnhvo; arc=none smtp.client-ip=117.135.210.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="h/xBnhvo"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=FA
	xSvtdshfkiJ1HR9NdRVIqZNmb5ki1HYsQEqnQDjys=; b=h/xBnhvoIlo5loUlXl
	qLBXKyYO8Oxh7VqJtDuFtmomJUsMKWTNXurPHiwbXVlRAfUJgTbJ/P3nCXR6NIuK
	7cI5DCL6u4CtCe6ZB9f9RyTu5b2d+QmEYYF6ma1L4+7EmJlp/N13MVgbBNp/CKAw
	/Mzoyx4VafxcCn+9Z3oDN4BmY=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g1-2 (Coremail) with SMTP id _____wD3vK6Gx0Fq2hKtGQ--.48295S2;
	Mon, 29 Jun 2026 09:16:54 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: dlemoal@kernel.org
Cc: James.Bottomley@HansenPartnership.com,
	hare@suse.de,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	p.raghav@samsung.com,
	sw.prabhu6@gmail.com,
	tom.leiming@gmail.com
Subject: Re: [PATCH v1 2/4] scsi: sd: unify sd_probe() error cleanup through out_put
Date: Mon, 29 Jun 2026 09:16:53 +0800
Message-Id: <20260629011653.2238665-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <00c16485-fc4b-43bd-a420-89b3b5eebaeb@kernel.org>
References: <20260623100159.4018066-1-yangxiuwei@kylinos.cn> <20260623100159.4018066-3-yangxiuwei@kylinos.cn> <00c16485-fc4b-43bd-a420-89b3b5eebaeb@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wD3vK6Gx0Fq2hKtGQ--.48295S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUYeOJDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6gb9jmpBx4bU3QAA38

---

Hi Damien,

On Sat, Jun 27, 2026 at 06:54:44AM +0900, Damien Le Moal wrote:
> device_unregister() is called here and in the next error path too. So what about
> a "goto out_unregister;" to avoid repeating this pattern ?

I tried that too, but out_unregister cannot fall through to out_free_index:
scsi_disk_release() already calls ida_free(). So it needs a second
goto out_put after unregister, which is why v1 kept the explicit paths.

If that out_unregister + goto out_put pattern is fine here, I will use
it in v2.

Thanks,
Yang Xiuwei

