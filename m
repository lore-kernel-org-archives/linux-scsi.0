Received: from mail-m49198.qiye.163.com (mail-m49198.qiye.163.com [45.254.49.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3FB1D54FA;
	Sun,  4 Jan 2026 05:53:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767506012; cv=none; b=KeSzus9/kxBC2dwTKMVvMMUKYU12p9pJysKT6oR3axfi6ASiSjnvAhey8i7YI96Ow1gK+XXlqM2kQnjQJC6zcYe94sTAqhTzDGEFCAExpTOjGB7H7asNsCX6LG2CvNL5bVvOHz7bBo1pPIC4fJe0C+Mmnk7dvYjF9xiiqanpc28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767506012; c=relaxed/simple;
	bh=4LrZ8hQxlRtFCWg8+bUw2t4e0MNPKFq7f0WBm2xAsJw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=OflNXr2ZXWdBn5fqnZ0o2pGm2/EQcuh44zdmuhW2pW2vwU6xYvj96cvMkbS+2gGhxmod6bTij7pF1Olkci77pZV/iM7/QP1O5b8LjC/rDiVr7Ad/C8HfxVRVrZnMvg5peA15L5SA2lSCtBLalAISY8O9KSD9yNNmOvekhtPOFYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=jaLh/5kY; arc=none smtp.client-ip=45.254.49.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="jaLh/5kY"
Received: from LAPTOP-N070L597.localdomain (unknown [58.241.16.34])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f66d159a;
	Sun, 4 Jan 2026 12:37:40 +0800 (GMT+08:00)
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
Subject: Re: [v3 0/3] scsi: lpfc: Fix multiple memory leaks in error paths
Date: Sun,  4 Jan 2026 04:37:39 +0000
Message-Id: <20260104043739.50700-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <3d1aa2f6-37fb-48f3-936e-95c779a8e7ff@web.de>
References: <3d1aa2f6-37fb-48f3-936e-95c779a8e7ff@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b874bf32903a1kunmcc4b27c42caad3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkaSUpPVk9CT0NNGR4dTh5IT1YeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlOQ1VJT0pVSk1VSE9ZV1kWGg8SFR0UWUFZT0tIVUpLSUJNS0pVSktLVUtZBg
	++
DKIM-Signature: a=rsa-sha256;
	b=jaLh/5kYMXdrrBJ0WUnZOMcsXrbgVz/9NGzVFhL/Bcjr75r/wB+7OwP++3U3iKlX1mOp2wMcg/2Uh0Ckzj1LzAEY6mfn2Jxond6J/ipLnvNGfSY6FiVwHh1kWoGrMh//A+CINIuASK6N6rBrvxv6aPhbcJJSTT+N2k33VT6C9M4=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=P39iIpwBpfgP5dp0WRJCdzTe3dvhW3yG7O+Cx7juK5s=;
	h=date:mime-version:subject:message-id:from;

On Sat, Jan 03, 2026 at 04:54:39PM +0100, Markus Elfring wrote:
> Do the researcher guidelines indicate a need to point research activities out
> in more explicit ways?

No, as our research does not constitute "active research on developer 
behavior", but rather consists of "good faith contributions". It is 
governed by and conducted in full compliance with both the Linux Kernel's 
Researcher Guidelines and the relevant security conference guidelines for 
vulnerability disclosure (e.g., IEEE S&P: https://sp2026.ieee-security.org/cfpapers.html).

I appreciate your engagement, but we must stay on point. Your frequent 
questions unrelated to the technical content of many my patches are 
causing distractions and creating noise in the discussion. Therefore, 
I will no longer respond to off-topic inquiries in this public channel.

Regards,
Zilin Guan
