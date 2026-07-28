Received: from esa.microchip.iphmx.com (esa.microchip.iphmx.com [68.232.153.233])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901A434041B
	for <linux-scsi@vger.kernel.org>; Tue, 28 Jul 2026 16:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=68.232.153.233
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785257499; cv=none; b=fhK3/bhn1jgySOH5sO3q6zUcqzgIOHgZIgKjOljnrqjNEE92MIAd5SDoctz0sCmFu/8Pl1xQY1+glhNm7d5vPCp5+CYILvkLMxuz4dU1ib0XskmflvweSqDIbzY6xhgWGsCxdK2GhcWxtrk5giz6FE+RbH4dvhlJUOn7FA02p+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785257499; c=relaxed/simple;
	bh=jMisEwyPeO80dfuYnBpdL3fGlYJ1eaFGzBGF8msZu/w=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=M9RKyK8z0PXtK92NPNrVcv5enbpoM3s/AzP96NVxQlsgF8efSVZ8gP6PWYTWhmEEzBuhZq/MXYAN+Y3wVIEBP5YAvq4GwNekkjutNR93Ary/MJytYOwqqhW43pJHvStXcL9e7SbuPjL0NAbguHxw34sqZnZcxK5VhjfNFt+838k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com; spf=pass smtp.mailfrom=microchip.com; dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b=A/U/NPFW; arc=none smtp.client-ip=68.232.153.233
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=microchip.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=microchip.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=microchip.com header.i=@microchip.com header.b="A/U/NPFW"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1785257501; x=1816793501;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=jMisEwyPeO80dfuYnBpdL3fGlYJ1eaFGzBGF8msZu/w=;
  b=A/U/NPFWBTjHE9Q8iIE7gfgqWrtLLkXg2RENzEEpIijkqqve3MCbxg9Y
   r5Kdct30mDJaaAEB355wVvXDasUsvlDUUF89lJy4hOVQQ9GGilE6oXnnt
   g8K/jsX94J8JQ20UjAlZS20aEiGBtmScY+z25tXFwYC2yuygLQdbZCpai
   1LCf+GdSimT9XsL6WVVzye0zwLF3na0kfesaIZovO/qsszLR11DQCFzFp
   19hVQB/LRY2sWZS7AJJ/OK4eF/c8laXh0IyKG7ZxqVFyNJ5ox90597pL8
   bRGg2Inyl+0KTVAftzxBU6LNvixDZYYd+Bih0vDWFs5+gupkQqowb+UOw
   g==;
X-CSE-ConnectionGUID: tixD0oCNTmKdZBW8XQuL8w==
X-CSE-MsgGUID: ZX0d9s52ShGf23AcZi4BFA==
X-IronPort-AV: E=Sophos;i="6.25,190,1779174000"; 
   d="scan'208";a="61290686"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO email.microchip.com) ([170.129.1.10])
  by esa3.microchip.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 28 Jul 2026 09:51:34 -0700
Received: from dks-rocky10u1-dev.pdev.net (10.10.85.11) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.58; Tue, 28 Jul 2026 09:51:30 -0700
From: David Strahan <david.strahan@microchip.com>
To: <sashiko-bot@kernel.org>
CC: <linux-scsi@vger.kernel.org>, David Strahan <david.strahan@microchip.com>
Subject: Re: [PATCH v1 2/4] smartpqi: add support for CCISS_BIG_PASSTHRU ioctl
Date: Tue, 28 Jul 2026 11:51:19 -0500
Message-ID: <20260728165119.23279-1-david.strahan@microchip.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260722220401.6357-3-david.strahan@microchip.com>
References: <20260722220401.6357-1-david.strahan@microchip.com> <20260722220401.6357-3-david.strahan@microchip.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: chn-vm-ex04.mchp-main.com (10.10.85.152) To
 chn-vm-ex01.mchp-main.com (10.10.85.143)

Re: commit 89c5d7119f80d6cae47c460c85b511017c1cd263
    [PATCH v1 2/4] smartpqi: add support for CCISS_BIG_PASSTHRU ioctl

Link: https://lore.kernel.org/linux-scsi/20260722220401.6357-3-david.strahan@microchip.com/

Sashiko AI review (https://sashiko.dev/#/patchset/20260722220401.6357-1-david.strahan@microchip.com?part=2):

> [High] Unbounded kmalloc of user-controlled size prevents large transfers
> and triggers page allocation warnings.
> [High] Missing 32-bit compat ioctl translation for CCISS_BIG_PASSTHRU.

Agreed on both. pqi_big_passthru_ioctl() doesn't bound iocommand.buf_size
before kmalloc(), and doesn't honor iocommand.malloc_size to split large
transfers across multiple SG entries.

For context, the userspace tooling we ship that issues this ioctl is
designed to keep buf_size within a bounded range, so this isn't an active
exposure via our own utilities today -- but the kernel-side bound is
still missing for any other caller, and is worth closing.

There's also no compat_ioctl for 32-bit callers -- scsi_ioctl() checks
in_compat_syscall() and returns -EINVAL cleanly when hostt->compat_ioctl
is unset, so this is a supportability gap, not a safety issue.

We would like to let this patch stand as posted and address these in a
follow-up patch rather than hold up the series.
