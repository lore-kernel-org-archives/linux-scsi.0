Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F8129A1
	for <linux-scsi@vger.kernel.org>; Mon, 16 Jun 2025 03:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.50.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750044758; cv=none; b=IS2bZbfQU49WQSeN5ZBmJxoUSVLQgB44Im2Tbm+hwVdBMX1kRGoWLP47JaXDs3nnyQuO7Kha66wDJN9Yun2vscx7gSARztTGop4TWUXYlLONZzeZTJTfTz4Sa/Usqmjolc30Fh0v7PGQliPiABsxPzYIg2eV35jgsyivp36zFYo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750044758; c=relaxed/simple;
	bh=z2p7lelAG+/s77akAEWM1/km6AvVmjJQfCm8642ruA8=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Cc:Content-Type; b=bdT8NV/Or/VOrfce/fobH+a1Jy19tUNahdWL1oU+tE7Hh7lpyFSzc2FdomrbJ0IJRoGbhgjmYcSQZQoanGGykKMLHvt2kJXaYpMWwAn8lwprdTjNAZUCytWnuLfxXLdgUu9yJbA76w6C0oI4wH+/onSItw/lVbLN6Jd8YUY1eoM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Suicloix; arc=none smtp.client-ip=90.155.50.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Suicloix"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
	Cc:Subject:From:To:MIME-Version:Date:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=WuWffCBqH7kU2PXQ7VGuUqCqRqjUluWUJ68dugiEQPA=; b=Suicloix5bP+MxYGhRWU05FMtX
	xzSGAqAEStKlglPZPaB7KAey15ZSM8flgnvQwTDnrTxEW0u6EWSUKzauHJ0EP2Fbm86js6P7WNEQm
	UF0QlV6bi0NYrRsBfcDzR9T2Lx+Rg7UEVATyBs59wNqOJFkjKrIN+aRsx3sxH6/sLMC/M38wyrF6l
	W5cm3XvdirOAsfqi/Evy12ouXj1/AUybDUrrvuPic53eG2ahk+WnVV2fxSaIC8Wa/1BKwYwfRr0z4
	rUmP6ccG/bwUSXpxCJ4Ys1UBI3Nb15XIvIEJsAYMiSRNwfp9eb/nhupWFtlKQnQ6Dj5JoYKBpqnEp
	5Qa2RVKQ==;
Received: from [50.53.25.54] (helo=[192.168.254.17])
	by casper.infradead.org with esmtpsa (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uR0aG-0000000FViU-2cad;
	Mon, 16 Jun 2025 03:32:32 +0000
Message-ID: <a2c85ac4-234a-4355-b7bc-953c835ae40a@infradead.org>
Date: Sun, 15 Jun 2025 20:32:30 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Content-Language: en-US
To: linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
From: Randy Dunlap <rdunlap@infradead.org>
Subject: mpi3mr: warning: variable 'scratch_pad0' set but not used
Cc: Ranjan Kumar <ranjan.kumar@broadcom.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

Hi,

A build (sparc32 allmodconfig target hosted on x86_64) with W=1 reports:

drivers/scsi/mpi3mr/mpi3mr_fw.c: In function 'mpi3mr_issue_reset':
drivers/scsi/mpi3mr/mpi3mr_fw.c:1644:54: warning: variable 'scratch_pad0' set but not used [-Wunused-but-set-variable]
 1644 |         u32 host_diagnostic, ioc_status, ioc_config, scratch_pad0;

In looking at the source code: (line 1696++)

	scratch_pad0 = ((MPI3MR_RESET_REASON_OSTYPE_LINUX <<
	    MPI3MR_RESET_REASON_OSTYPE_SHIFT) | (mrioc->facts.ioc_num <<
	    MPI3MR_RESET_REASON_IOCNUM_SHIFT) | reset_reason);
	writel(reset_reason, &mrioc->sysif_regs->scratchpad[0]);

it does look possible that the writel() call should be
	writel(scatch_pad0, &mrioc->sysif_regs->scratchpad[0]);

as it is in some other places.

Thoughts?  Is the compiler confused?
CONFIG_CC_VERSION_TEXT="sparc-linux-gcc (GCC) 15.1.0"

Thanks.
-- 
~Randy

