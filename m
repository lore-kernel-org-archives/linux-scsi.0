Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 506391E89C;
	Sat,  3 Jan 2026 13:34:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767447297; cv=none; b=mYI9E68vwh2lnwzZrVmQyfOEbOYP3mRLTkX8XzjlDzmpvHog3a/Dt26AHO0R2Lq7Te1llLvrAqRgQp5J+CwCT9zEuPRHdNQa43VeEi/7wfaNpi3tavV3wHhlvlZEtJ3B5dZmaxJLU2eJYn0T6mkyNT1/Sq4fendja8Pv1RkH8ww=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767447297; c=relaxed/simple;
	bh=5Lnvc2py6X2WKN/xKVO+zNKY3TT4KmzXTHQCxGVFT7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BTOAyPLqs6Rt+bznwuKJkKXlN87ecdAqL5i0sszu7LGJDjxnI1GO0tTIlVN98nWol7zuGCMV/3EpCmk6XEafVCaf3+Jl/ENJu9vet9jVFBTNCIIkYq/pgPILvyZpcLCSDt51dsqfAgB1FGKobxN3B6iL18qx/BBTjJOnRGJW0fI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=aFm1kFYV; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="aFm1kFYV"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f5ccad28;
	Sat, 3 Jan 2026 21:34:40 +0800 (GMT+08:00)
From: Zilin Guan <zilin@seu.edu.cn>
To: zilin@seu.edu.cn
Cc: James.Bottomley@HansenPartnership.com,
	don.brace@microchip.com,
	jianhao.xu@seu.edu.cn,
	linux-kernel@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	markus.elfring@web.de,
	martin.petersen@oracle.com,
	storagedev@microchip.com
Subject: Re: [PATCH v2] scsi: hpsa: Fix memory leak in hpsa_undo_allocations_after_kdump_soft_reset()
Date: Sat,  3 Jan 2026 13:34:40 +0000
Message-Id: <20260103133440.213186-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20260103123910.169563-1-zilin@seu.edu.cn>
References: <20260103123910.169563-1-zilin@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b84113bb203a1kunmfc23bd04266498
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVlCHk0ZVkweHRoZGR5PTB8eQ1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=aFm1kFYVL/fIMk/ljGT6961P7lm4LDgsaYbYbGbONIQ5rSfshxgCl6fGs78cqEcWBIlN8quaIid6BCD2nJBRrzVnSYB3wWAZrAEQhxk9WU+Bsyoz/FhOXt9fGrc9eK2BMuuHO0z4dswXBXoNUQFFFTjAFYOFEHRhW4gcldKGDCs=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=Ldvugc/79mjOfj2iNkrz8lSPsS1qtN7qZkKh3K05Aaw=;
	h=date:mime-version:subject:message-id:from;

On Sat, Jan 03, 2026 at 12:39:10PM +0000, Zilin Guan wrote:
> Hi Markus,
> 
> Thank you for your review.
> 
> Regarding the alignment, it was an oversight caused by the inconsistency 
> between my editor configuration and the Linux kernel's style. I will 
> correct this in v3.

Apologies, please disregard my previous reply.

I realized that the perceived misalignment is actually a tab rendering 
artifact. I have verified that the indentation in v2 is correct and 
aligns perfectly with the surrounding code when applied.

Therefore, v2 is correct as-is and a v3 is not necessary.

Best regards,
Zilin Guan
