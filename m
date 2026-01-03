Received: from mail-m155101.qiye.163.com (mail-m155101.qiye.163.com [101.71.155.101])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22B5516EB42;
	Sat,  3 Jan 2026 15:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.71.155.101
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767453922; cv=none; b=slbb0XYWn6HNKNGIO1LPI+NVPYi5vzp2Y2ODvsuqsfPdCaC6HpRNKr4dN4MzuhFtAqPjV8uyqOPG/Cy4iS/Ct5j80iYCFc1co242+WYM058e8uO/nMxWoibVHoEKCACJinV4OEDYNcMuAh2YaZ7inArWEOIqhxGBmNcPqpuEqkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767453922; c=relaxed/simple;
	bh=bE5UDyojxw+NY4qB0EBDcxSalY9rWjUSyAwgqPmWuEk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=gvCBzTIiq0RO1wI2AuDcAzbZzmVpgty20dyUIphfTA0fizeexMshSx2dXiWNJ7ic1f4YxB37zV5m+DDis6IlprJ0lm9OhdZ+XjtanMueoBG9a4jMrWbvBucpwliz7/Z//dSzFaadVC3PWx3wZvvm1hbIKh/cD6TpV0yyoMCgQXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=fmw4orBE; arc=none smtp.client-ip=101.71.155.101
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="fmw4orBE"
Received: from LAPTOP-N070L597.localdomain (unknown [222.191.246.242])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2f5d2e62f;
	Sat, 3 Jan 2026 23:25:14 +0800 (GMT+08:00)
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
Date: Sat,  3 Jan 2026 15:25:14 +0000
Message-Id: <20260103152514.304387-1-zilin@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <411ef9b1-ff0c-4f68-8af8-f3a478ca0d7d@web.de>
References: <411ef9b1-ff0c-4f68-8af8-f3a478ca0d7d@web.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9b847674fb03a1kunm0432afc426a850
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZSh9JVkxNS0JDQxhIHUMeHVYeHw5VEwETFhoSFy
	QUDg9ZV1kYEgtZQVlJSUlVSkJKVUlPTVVJT0lZV1kWGg8SFR0UWUFZT0tIVUpLSUhOQ0NVSktLVU
	tZBg++
DKIM-Signature: a=rsa-sha256;
	b=fmw4orBElBuvq+MkDehw+cJj57SKzN+gbOR8JGmNJrmINE8qeK+b8vaS48UKLgtxEmnt9R0GnCb1InZ9txDAMxaAvTKnjviSPp/p74/0mxHoarHknd9UeUb3Wld+PJPa+tOuTbJIdgBwSlFMZeXJnhbiSC7LFqvpxlKzqz4MLEc=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=yJHzCraHpobGXhQI+SGY7bQQw2yqDMyYxAr7F8i3FXs=;
	h=date:mime-version:subject:message-id:from;

On Sat, Jan 03, 2026 at 02:30:36PM +0100, Markus Elfring wrote:
> You presented interesting development ideas.
> Will any related concerns become relevant here?
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/researcher-guidelines.rst?h=v6.19-rc3#n5
> 
> Did your analysis approach get a corresponding name?
> 
> Regards,
> Markus

We are aware of these ethics requirements and strictly respect them.
For example, we responsibly disclose our findings (i.e., bugs, in the 
form of patches), and we will make our paper and code public after 
publication. However, we cannot disclose our tool at this moment because 
our research is still ongoing.

Regards,
Zilin Guan
