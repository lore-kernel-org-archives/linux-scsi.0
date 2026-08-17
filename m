Received: from m16.mail.163.com (m16.mail.163.com [117.135.210.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0E9D5733E;
	Mon, 17 Aug 2026 03:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=117.135.210.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936695; cv=none; b=uPNFL+acnPvOiTAJUS1gK6lcZiq2i62Ib+HbzwGP60dVot8trfarLdgoWA58c0wyBIFvfm6xqoqjcKB0JsFx4EAhUzCHzJu7m0vm0oIm495lpGXnWP8504hcsrFGL5KMeydLTv7Q+UfsXLpXorLdM7b4bVAHniiLir56kPWqVcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936695; c=relaxed/simple;
	bh=XQK3ojxIFI4ijEgHCLcUdi+EbdurZ/lM55BFimmyf1I=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=kw0CBZCxUTOFE6BHlTCtBmDI2e1iyXr6MIYMx4FAKlPCQQ+/nhAZ+sTu7CE+w193AgodkF/29YbfZWlyBRdvHDDTK9K4MBeLDz7PfMBgUEXegvK3xlBvwVqbdVvTpv03Ym+3t/ewJDzONwkM4YhIiXyd0K+fYYr8bQGxhgczW5s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn; spf=pass smtp.mailfrom=163.com; dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b=L56NGwWH; arc=none smtp.client-ip=117.135.210.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kylinos.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=163.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=163.com header.i=@163.com header.b="L56NGwWH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-Id:MIME-Version; bh=XQ
	K3ojxIFI4ijEgHCLcUdi+EbdurZ/lM55BFimmyf1I=; b=L56NGwWHEWreW5sFVm
	oTfFBWkix1kPjjvHl4FfFOfcP472gCn8LV5tjDP2BXCKRUn1GfjdyH2nlXlIXqCE
	SXgjNEU0o4DE0yzHOOb+8TiwdQuCsWS39NDnlFlYS9kjlqVlntNVnmD88bKv/S2F
	4dQmbMW6cTRNkyXJDqjRS+j20=
Received: from localhost.localdomain (unknown [])
	by gzga-smtp-mtada-g0-4 (Coremail) with SMTP id _____wBnBUAzfYJqUrffQA--.20354S2;
	Mon, 17 Aug 2026 11:17:09 +0800 (CST)
From: Yang Xiuwei <yangxiuwei@kylinos.cn>
To: yangxiuwei@kylinos.cn
Cc: James.Bottomley@HansenPartnership.com,
	axboe@kernel.dk,
	bvanassche@acm.org,
	csander@purestorage.com,
	fujita.tomonori@lab.ntt.co.jp,
	io-uring@vger.kernel.org,
	linux-scsi@vger.kernel.org,
	martin.petersen@oracle.com,
	rc@rexion.ai
Subject: Re: [PATCH v3 0/2] scsi: bsg: io_uring passthrough TOCTOU and mapping
Date: Mon, 17 Aug 2026 11:17:07 +0800
Message-Id: <20260817031707.367136-1-yangxiuwei@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
References: <20260817013959.165425-1-yangxiuwei@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wBnBUAzfYJqUrffQA--.20354S2
X-Coremail-Antispam: 1Uf129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UbIYCTnIWIevJa73UjIFyTuYvjxUbsjjDUUUU
Sender: yangxiuwei2025@163.com
X-CM-SenderInfo: p1dqw55lxzvxisqskqqrwthudrp/xtbC6henOGqCfTc4hQAA39

Hi,

sashiko noted a sense buffer overflow on the io_uring path:
Link: https://lore.kernel.org/linux-scsi/20260817015247.B9CF61F000E9@smtp.kernel.org/

Agreed. Completion copies scmd->sense_len without capping to
max_response_len. Setting sense_len at submit does not help; the
midlayer overwrites it with the real sense length.

I will add a fix as 3/3 in v4 (store max_response_len in the PDU and
cap the copy like the ioctl path).

Thanks,
Yang Xiuwei

