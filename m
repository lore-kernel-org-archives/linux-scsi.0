Received: from mout.web.de (mout.web.de [217.72.192.78])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0E074A0C;
	Sat, 10 Jan 2026 06:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.72.192.78
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768028119; cv=none; b=KLshahVwBtYv1d287WnVAmy+F7uJ/bh5m9f/jRe2Cc2LVE914qlT8fosFp8eex7+NbmQxwn6cAg/HcGlcm7djUqjWpHO8QlNmU9otT8ljdvY4xQ+d+3BLCVmRKpWjVBs9Te/kCvxuBn2oWF6ZMfsT8ri0rILmeWGpj66QeuLEOc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768028119; c=relaxed/simple;
	bh=kmMbNJeGfqf4pqg+LDS4j427jcIK6sh8JtGbR6ADf+E=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=kseURx0Nt7aPhNQMdjLcYHJLaQoQ6cH8eXBJqYnC/s/8GPAkyk6CRxVFi/6PCB4dXsfqJea8/qgDdG2t1SbGECLfWMSMARdYpnK71ZFK4Szf3a7SAYA4cOq94o5PxTmQQUyeYfB+i5KKOWX0J1cXzTS+87KJhfBSFnYN+WgI/8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=ll2TKMNM; arc=none smtp.client-ip=217.72.192.78
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="ll2TKMNM"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1768028116; x=1768632916; i=markus.elfring@web.de;
	bh=kmMbNJeGfqf4pqg+LDS4j427jcIK6sh8JtGbR6ADf+E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=ll2TKMNMox7hunViephiHQm/4sjvFPT+uEDfS2qeHIP7j2+rM8zWrdIKgbXnk1/X
	 z3lgqu0hxcjuR6QC1ZibQ+P4SVa+j9SrZvTceJHPZRzFxxZIGUKPaY05xUNnGs81O
	 g86a20oX4MWJLAIB/mTWFeDkFZ/rq+gBpEP8Ok2bZcU0tAuGaOLRyPaXw2GdyAxhj
	 w2M/bYUcv3wxCiR+GC/Zut+fiIzfoiqNQkEIY7VdIdC0ZekoxDLKrF/tAIR8en2gp
	 Iw/bMJ0HxAhIosiNnF4P3WGy4FlBUuFwuxjZnWQOVcGxZJLLY/7VDbva7L73J2gEk
	 vNSYOOA3qal5mcpOmg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.92.231]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MDv9a-1vWj7X3ghg-000uFf; Sat, 10
 Jan 2026 07:55:15 +0100
Message-ID: <f29e2dbc-9a37-4e45-9d4b-c52526b7d0c5@web.de>
Date: Sat, 10 Jan 2026 07:55:14 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: Haoxiang Li <lihaoxiang@isrc.iscas.ac.cn>, linux-scsi@vger.kernel.org,
 storagedev@microchip.com, Don Brace <don.brace@microchip.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: stable@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
 kernel-janitors@vger.kernel.org
References: <20260108073251.315271-1-lihaoxiang@isrc.iscas.ac.cn>
Subject: Re: [PATCH v2] hpsa: fix a memory leak in hpsa_find_cfgtables()
Content-Language: en-GB, de-DE
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20260108073251.315271-1-lihaoxiang@isrc.iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:ob7yID7AgB+fRZoCMWn1w+PXMmjJm3c4/kwUw2mnfBpdKqYWur/
 ColePTLH7uppR9R2jtmpHwIAgEiKiQFKO6ptn2Fs6cqjo7W1Ra1ahQ758r+L4Cte8kKBsPj
 X+2SyNWrtvbimufNA7LZU8U6Dd9FqsoUS7ARxTZu4s058EhvkNDTo6R5MN2NCK+QtZQK/TW
 moohyOljujpRbL8jT3qVA==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:/HSmV9HNyXw=;Fs04tmG4DPBbUE+wfDpjrfpID44
 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
 SLCcg2tDTxDyFYSI8=

> If write_driver_ver_to_cfgtable() fails, add iounmap() to
> release the memory allocated by remap_pci_mem().

How do you think about to avoid a bit of duplicate source code here?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/coding-style.rst?h=v6.19-rc4#n526

See also once more:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst?h=v6.19-rc4#n659


> Found by manual static code review.

Can such information indicate a contradiction?

Regards,
Markus
