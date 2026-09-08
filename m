Received: from mailout2.samsung.com (mailout2.samsung.com [203.254.224.25])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9778454DACD
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:33:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.25
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788877995; cv=none; b=U5qYIu8xYL4OAo7pvQTumh660rahVUYL1MW8cFn7CuKKNKWI0BKd2TEv2xqiygz85M1eh8c6fJDb7lxjXNV+BT5XKqLr89oib8jB7W9G4jhAoz+RPY28+tzUEyrZOQmllFdvigevL5weKcW5I/5QN25iPf4DaB7bveqAiQKfT6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788877995; c=relaxed/simple;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=g3rQSeG8xT8PfHbj0x5twtfWT3Di9JdHlvNfDq/5KY2ngCO+2muyvrMlKRY6AqF/qZH8AuaOmVGZzbfZcvrWEDk9EO4RM09Sedie9UH3/nLmt1oK6vvI29wR9t848Yc7BSqC1OQ2NaNMt6dLa1pU9SalTZg18wmHwD5rj3y9RUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=B1dWASRq; arc=none smtp.client-ip=203.254.224.25
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="B1dWASRq"
Received: from epcas5p3.samsung.com (unknown [182.195.41.41])
	by mailout2.samsung.com (KnoxPortal) with ESMTP id 20260908143253epoutp0265896ffcc9f5e8741201207db0b5b947~TXwoU-GOk3230632306epoutp02d
	for <linux-scsi@vger.kernel.org>; Tue,  8 Sep 2026 14:32:53 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.samsung.com 20260908143253epoutp0265896ffcc9f5e8741201207db0b5b947~TXwoU-GOk3230632306epoutp02d
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1788877973;
	bh=MPy2dmqKlCsrw5okIZFwkiGzwVi0bWXg1j0NfWvMFRQ=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=B1dWASRqHgAYGUgnoLdk0cLZ8jPWKq00OIijI7JX7Ktx2Wz3VzSziJsHcKy8J6dDf
	 e/8OUx5VQIMIi3n46HT4DANWaWwWh3lb87Z+K1EnsRRKai7XlkFRYEQS66dySAbtiH
	 4GhLXWUjIEk64Ql3GHBFEEaUx75adKhgi5oYozvk=
Received: from epsnrtp04.localdomain (unknown [182.195.42.156]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPS id
	20260908143253epcas5p2fb6c352b02216c1a284504aafe11ab9e~TXwnvV8ss1588015880epcas5p29;
	Tue,  8 Sep 2026 14:32:53 +0000 (GMT)
Received: from epcas5p4.samsung.com (unknown [182.195.38.89]) by
	epsnrtp04.localdomain (Postfix) with ESMTP id 4hfRHS48bdz6B9m8; Tue,  8 Sep
	2026 14:32:52 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260908143251epcas5p4012ebad47066cbd6a6e4d366a2be4e3e~TXwl5C1AQ2685526855epcas5p4L;
	Tue,  8 Sep 2026 14:32:51 +0000 (GMT)
Received: from [107.122.11.51] (unknown [107.122.11.51]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260908143250epsmtip1781a12c46893e70998e0d8238d709e80~TXwk2aLn10129801298epsmtip1R;
	Tue,  8 Sep 2026 14:32:50 +0000 (GMT)
Message-ID: <17c35363-c946-405b-9275-96bf1dcd89b3@samsung.com>
Date: Tue, 8 Sep 2026 20:02:49 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] common: add a _sysfs_block_integrity_path helper
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Anuj Gupta <anuj20.g@samsung.com>, John Garry
	<john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Kanchan Joshi <joshi.k@samsung.com>
In-Reply-To: <20260907075822.749818-4-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260908143251epcas5p4012ebad47066cbd6a6e4d366a2be4e3e
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260907075854epcas5p232e94b9385fc90e12950ee111dbfcb08
References: <20260907075822.749818-1-hch@lst.de>
	<CGME20260907075854epcas5p232e94b9385fc90e12950ee111dbfcb08@epcas5p2.samsung.com>
	<20260907075822.749818-4-hch@lst.de>

Reviewed-by: Kanchan Joshi <joshi.k@samsung.com>
