Received: from out30-71.freemail.mail.aliyun.com (out30-71.freemail.mail.aliyun.com [115.124.30.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 972C72AD20;
	Sat, 31 Jan 2026 10:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769856430; cv=none; b=aEseR1a8I/Hjf8CE7xSMBkbgLoo/Vp0KWc5pZ2otYshpFz17GudmAbj1DCITsnYkWeE0eGZMumU1EzGTEFTCh1xwLBUdwIMSWDSFPZBR57KQn/y7R/rNFryxj0TpmWOlPijLL7Ehm3Zx6Wd925slqXuN3NHrmx8PlMeiWKVMDf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769856430; c=relaxed/simple;
	bh=YrNXlgG9itNtlTe98c5WuYPHZjs2coYzNe4Uwg5FRII=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Y/OALJYiCsuVDsZKeh2hT9yyNrsbl6qHb2zWpY6lBTexzAcoz+Y2ntaOqFPOrJ1M8mDivJTF/D1SXk4ao3QSncyqkMBM9H1e/o/5Rus6Hg77bzKGF98x+e60Q2Qqx9YDpWOWZ2iSxLA1/5UVrOE/xNv9gxU7kLZmNPlu9RnlwpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com; spf=pass smtp.mailfrom=aliyun.com; dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b=LYccEN8u; arc=none smtp.client-ip=115.124.30.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=aliyun.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aliyun.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=aliyun.com header.i=@aliyun.com header.b="LYccEN8u"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=aliyun.com; s=s1024;
	t=1769856426; h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	bh=v7en+wdUXpgRn8EvkLYpJKw6maDD0Rvto5ETIPT3RKM=;
	b=LYccEN8ugLZm+pdYVc1FFT9vUbh+gskQHoZZ+2jrQAKTYulR/tR/uaRl7wg9AAwrRPGjFpf8hvHxTQmNxiq8ZMT63XoKaNgCiQkN+I+u1EmnsyR3a4ZqychdsBbUg6Kwj9x28xpbv1go6PcR2GXxSXjdJfTjDhcWUQQFRIJ8WAM=
Received: from LAPTOP-RK2E6KJ3.localdomain(mailfrom:wdhh6@aliyun.com fp:SMTPD_---0WyDRtut_1769856422 cluster:ay36)
          by smtp.aliyun-inc.com;
          Sat, 31 Jan 2026 18:47:04 +0800
Date: Sat, 31 Jan 2026 18:47:02 +0800
From: Chaohai Chen <wdhh6@aliyun.com>
To: Jason Yan <yanaijie@huawei.com>
Cc: john.g.garry@oracle.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, dlemoal@kernel.org,
	johannes.thumshirn@wdc.com, mingo@kernel.org, cassel@kernel.org,
	tglx@kernel.org, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: libsas: Fix dev_list race conditions with proper
 locking
Message-ID: <aX3dpqtLmgNVaQEg@LAPTOP-RK2E6KJ3.localdomain>
References: <20260129093859.1418749-1-wdhh6@aliyun.com>
 <e59ff23b-81d3-41b7-ac25-ab886a3379bf@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e59ff23b-81d3-41b7-ac25-ab886a3379bf@huawei.com>

On Fri, Jan 30, 2026 at 04:27:11PM +0800, Jason Yan wrote:
> Hi,
> 
> 在 2026/1/29 17:38, Chaohai Chen 写道:
> > Multiple functions in libsas were accessing port->dev_list without
> > proper locking, leading to potential race conditions that could cause:
> > - Use-after-free when devices are removed during list traversal
> > - List corruption from concurrent modifications
> > - System crashes from accessing freed memory
> 
> libsas events are processed in orderd workqueue. Do you have a crash log?
No crash log. I noticed the missing locks while watching the code. But
there are tow queues, event_q and disco_q which may cause conflicts.
And I think the dev_ist_lock is designed to prevent conflicts.
> 
> Thanks,
> 祝一切顺利

--
Chaohai Chen
