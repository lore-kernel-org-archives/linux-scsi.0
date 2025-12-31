Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC0742857F0;
	Wed, 31 Dec 2025 15:07:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767193632; cv=none; b=W7BiEtp2nsjTyHvwIQm+0l0/wFgPTxY7VO9dlcsMK0yRH3Hxv/nUIt3wgp7L7uvIqyRCvBZXGtclSVukBOB4adD0SgBrujhXd2lwzXn8B6FIhrwqRUFPsAk6iqWuSyb52Anvlvuymn2UEK9bAlrp4NYP2Z7ry7YzNYCBbjZGoHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767193632; c=relaxed/simple;
	bh=LeKiLhibiiQEEtdamNHzv7LtPY4KWX88L2UEK2ZMxIo=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DztW/1Qr7bZvj/aWGJfDW8BLgD10PwqlR4up1eBn9nuAvabx/651BcUm4b0eKtdVyVLYFN6UDT35JufTsFXlLymoASZwlpnRQHnuFe10esC5ZFS/iZxcysu2r7zlXIeXeTQ1eNKN7Z1CBhjiyTsIfWpyI7fcMKCnDE2cePrZFGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=HcQafveB; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="HcQafveB"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2eba3;
	Wed, 31 Dec 2025 23:07:03 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: markus.elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	jianhao.xu@seu.edu.cn,
	justin.tee@broadcom.com,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	paul.ely@broadcom.com,
	zilin@seu.edu.cn
Subject: Re: [PATCH v2 1/3] scsi: lpfc: Fix memory leak in lpfc_config_port_post()
Date: Wed, 31 Dec 2025 15:07:00 +0000
Message-Id: <20251231150700.359356-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <8ab71d11-ef77-4181-a5d5-e785576c85be@web.de>
References: <8ab71d11-ef77-4181-a5d5-e785576c85be@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74f2baa603a1kunm28ec3adb1ab5fa
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaHxkZVh8eH0hNQxkeQ0oaTFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=HcQafveBUadtPr/7SFr24gq1Isc4Vnj84gUgI5Abm5amHn6wDQ/zsT5P2uty4JVLhxihqbsC8kVc2/6I4IY/lHBufAC038uEgMKbRSB0mv5pIqm88v+/oRalxUt3iPu04zdJGQBiAQRxLyivDaELvfFOSWnB787FtORRhZR7zrE=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=tIw4Ok7mKBl8iHoANVZB8J0r7TBF+yR762PfYNmT1ew=;
	h=date:mime-version:subject:message-id:from;

On Tue, Dec 30, 2025 at 05:01:32PM+0100, Markus Elfring wrote:
> …
> > +++ b/drivers/scsi/lpfc/lpfc_init.c
> …
> > @@ -550,8 +549,7 @@ lpfc_config_port_post(struct lpfc_hba *phba)
> >  	if (phba->intr_type == MSIX) {
> >  		rc = lpfc_config_msi(phba, pmb);
> >  		if (rc) {
> > -			mempool_free(pmb, phba->mbox_mem_pool);
> > -			return -EIO;
> > +			goto out_free;
> >  		}
> 
> You may omit curly brackets here.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.19-rc3#n197

Hi Markus,

Thanks for the review.

I missed this one during the refactoring. I will remove the unnecessary 
braces in v3.

Best regards,
Zilin Guan
