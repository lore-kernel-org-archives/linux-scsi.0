Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E30573955CD
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 05:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791781487; cv=none; b=XloHeig5Jp+pdzcM0C3j2lUNNiGHRNF9UhEoR2D7LZKSfedIfLfiWl9M6xlOg+wZjoPr9TcqZlg6Hv4kDYDcOpCs4mBdkuAy3Ix5PFizlPzp7weMk52XDJGa+6yS7GH6rnAAfneP59lssEIRS7/50wQNko8LqoWCalM8ckoX1oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791781487; c=relaxed/simple;
	bh=hM0kcQ0Bc9evwWdypFNCcRX0uxxLlGvOfY77UoX8Jik=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=rXwpiGhiHA65Lhp94yk6mLKODl2o3plIIgNbdVnJ00eExXMSYCpPrg7zTe8g2t4VO0HFbM7YTsl74TISIkXfwtk0mZdZxq5MtDrPuDWFpDiaYcoHUhqt9Hai5wdURtxYCwYqjPrL4G1pKhO2dUl8EdX5mwhnTcew0dIEiHOOLL8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=qT+hvZv5; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="qT+hvZv5"
Received: from epcas5p1.samsung.com (unknown [182.195.41.39])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20261012050442epoutp0439dc8189b1aebd5f2f149154fded5cf7~dr8PnvO8B1172411724epoutp04J
	for <linux-scsi@vger.kernel.org>; Mon, 12 Oct 2026 05:04:42 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20261012050442epoutp0439dc8189b1aebd5f2f149154fded5cf7~dr8PnvO8B1172411724epoutp04J
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1791781482;
	bh=ALLXBF2fii6mp0sYwu704G5nVrutLfZ10mu+goZbHCw=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=qT+hvZv5Sw/oFlQYZveAMhMOjvuKPmmYW45u/MTxSR1XXAAxisxD6vM0fO+i/7n4+
	 o2j+AJBKPivY7V7rCjO0GyzPwbOwPlf9++ZnoyMOWBNPG5C+pyts9whfCgaBgGzXGr
	 Bf3qqPgBJxWWvtRkRIfU4dAlciPo8itOGjjjiAF0=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p3.samsung.com (KnoxPortal) with ESMTPS id
	20261012050442epcas5p357194c275463fc6da707b7ba117a5694~dr8PP7B0n0435004350epcas5p3l;
	Mon, 12 Oct 2026 05:04:42 +0000 (GMT)
Received: from epcas5p1.samsung.com (unknown [182.195.38.94]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4j35493vK9z6B9mV; Mon, 12 Oct
	2026 05:04:41 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20261012050440epcas5p4bc98c046573d77f938d1b1dc0cf55283~dr8NnsvyP2093520935epcas5p4n;
	Mon, 12 Oct 2026 05:04:40 +0000 (GMT)
Received: from INBRO002756 (unknown [107.122.3.168]) by epsmtip1.samsung.com
	(KnoxPortal) with ESMTPA id
	20261012050438epsmtip1e0cc5a2939cc28011ce7569fb967f3b6~dr8MFWnIG2662026620epsmtip1B;
	Mon, 12 Oct 2026 05:04:38 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Stanley Jhu'" <stanleyjhu@google.com>, "'Martin K. Petersen'"
	<mkp@kernel.org>, "'James E.J. Bottomley'"
	<James.Bottomley@HansenPartnership.com>, "'Jonathan Corbet'"
	<corbet@lwn.net>
Cc: "'Bart Van Assche'" <bvanassche@acm.org>, "'Shuah Khan'"
	<skhan@linuxfoundation.org>, "'Randy	Dunlap'" <rdunlap@infradead.org>,
	"'Jeuk Kim'" <jeuk20.kim@samsung.com>, "'Bean Huo'" <beanhuo@iokpp.de>,
	<linux-scsi@vger.kernel.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <20261011103319.820657-1-stanleyjhu@google.com>
Subject: RE: [PATCH] scsi: ufs: docs: Describe how to test with QEMU
Date: Mon, 12 Oct 2026 10:34:37 +0530
Message-ID: <000001dd5a07$2fb3b400$8f1b1c00$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQD8jgR9uCSeo84oHFaWDTAnHIriAAHNcAceuKxxLYA=
Content-Language: en-us
X-CMS-MailID: 20261012050440epcas5p4bc98c046573d77f938d1b1dc0cf55283
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-543,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20261011103324epcas5p3005f6e64695166fb2d5fd2f788f7f47c
References: <CGME20261011103324epcas5p3005f6e64695166fb2d5fd2f788f7f47c@epcas5p3.samsung.com>
	<20261011103319.820657-1-stanleyjhu@google.com>



> -----Original Message-----
> From: Stanley Jhu <stanleyjhu@google.com>
> Sent: Sunday, October 11, 2026 4:03 PM
> To: Martin K. Petersen <mkp@kernel.org>; James E.J. Bottomley
> <James.Bottomley@HansenPartnership.com>; Jonathan Corbet
> <corbet@lwn.net>
> Cc: Bart Van Assche <bvanassche@acm.org>; Alim Akhtar
> <alim.akhtar@samsung.com>; Shuah Khan <skhan@linuxfoundation.org>;
> Randy Dunlap <rdunlap@infradead.org>; Jeuk Kim
> <jeuk20.kim@samsung.com>; Bean Huo <beanhuo@iokpp.de>; linux-
> scsi@vger.kernel.org; linux-doc@vger.kernel.org; linux-
> kernel@vger.kernel.org
> Subject: [PATCH] scsi: ufs: docs: Describe how to test with QEMU
> 
> QEMU emulates a UFS host controller and logical units, but the kernel tree
> does not mention it, so developers without UFS hardware have no
> documented way to exercise the UFS core.
> 
> Add a short section with the required kernel options, an example QEMU
> command line, and what the emulation does not cover.
> 
> Signed-off-by: Stanley Jhu <stanleyjhu@google.com>
> ---
Thanks Stanley!
This helps

Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>

