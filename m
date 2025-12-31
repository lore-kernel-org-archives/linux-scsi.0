Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73E1257851;
	Wed, 31 Dec 2025 14:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767192988; cv=none; b=Gyq+D63zcrXOvC7zjlCRBuj1WtSRhHeFGH+stZOC9XKjX8kXyPH+TJhfCdCf68YNSK5RJSq0eUo6BdExs5blPGfAuk+zBGsPBc5Dqjv0oaHaH9FjDA2DGaIsFek4ZwlQiZ0gvIJeCTwAtGQ517Zn4Oq89o66YmUVFpW/Pbs5e+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767192988; c=relaxed/simple;
	bh=6ajYzC4hs+ZO06F+/KqmI03T1pwEPpbYXttGvxVHH8o=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=m5wwNED/ylBkAdaZBO4WrU7cm2HKa4RGaS6GatvBbfcNOY+PO2wftUwBzH75ytbmidG6SbXzMScrvL8CKQMyAz4z//+WO+ENBGiyTgBRNw+TtdU+p6vLG12sptEY1sOTKhddztG0NNg615TD87X0w1LtM3sd2480zpwM6AGaJ7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=P6001xpN; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="P6001xpN"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f2b2ea40;
	Wed, 31 Dec 2025 22:56:12 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: markus.elfring@web.de
Cc: James.Bottomley@HansenPartnership.com,
	don.brace@microchip.com,
	jianhao.xu@seu.edu.cn,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	storagedev@microchip.com,
	zilin@seu.edu.cn
Subject: Re: [PATCH] scsi: hpsa: Fix memory leak in hpsa_undo_allocations_after_kdump_soft_reset()
Date: Wed, 31 Dec 2025 14:56:10 +0000
Message-Id: <20251231145610.351954-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <667efc45-7970-4064-8357-0c1d9acf3d66@web.de>
References: <667efc45-7970-4064-8357-0c1d9acf3d66@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b74e8ca4403a1kunm539a406a1aadac
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlDTE5PVkNNQh1JQk1KTB1PSFYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=P6001xpNjv1ekZs5qCo4QhroVtPj/YRB6J9AhIzbbczTP1IRYQeqiK9hybkt+5kxS+Lmuejl7GpCSYY69OP3SSQ9ZaUByQXG+neN7RSZj0wbVpFKeFV120F6bnbDfbyl256SRAxofLwwGQfx48d+qlzdEmG6L+jRUxV4N/mOqPA=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=YY/kcNGYje9HRxp5VhtEZjkh1hHFf2YIexdwHT16FOg=;
	h=date:mime-version:subject:message-id:from;

On Tue, Dec 30, 2025 at 01:09:14PM +0100, Markus Elfring wrote:
> …
> > +++ b/drivers/scsi/hpsa.c
> > @@ -8212,6 +8212,8 @@ static void hpsa_undo_allocations_after_kdump_soft_reset(struct ctlr_info *h)
> >  		h->monitor_ctlr_wq = NULL;
> >  	}
> >  
> > +	kfree(h->reply_map);		/* init_one 1 */
> > +	h->reply_map = NULL;		/* init_one 1 */
> 
> I find this reset statement redundant here.
> 
> 
> >  	kfree(h);				/* init_one 1 */
> >  }
> 
> 
> Regards,
> Markus

Hi Markus,

Thanks for the review.

I originally added the NULL assignment to maintain consistency with the 
existing code style in this function, but I agree it is redundant here.

I will remove it in v2.

Best regards,
Zilin Guan
