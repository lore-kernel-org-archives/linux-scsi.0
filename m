Received: from mailout3.samsung.com (mailout3.samsung.com [203.254.224.33])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B24E38B15B
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 15:26:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.33
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789140387; cv=none; b=Fys8SYz+fBMZfV4j7uBG/nJHYMABKol9h2wAxMcEkLhycWNfZF+jokNFyQaidRXbphNjDAlVDrprXBhwEt/2PdUtjlQJ3xKNT/NoG+hHirAEhYkITWHZUDTh6zXZXz4dRiMg1QbZRGvyfFFaI9SaAzDTYmpPRo43Waa8Svej7Sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789140387; c=relaxed/simple;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:From:In-Reply-To:
	 Content-Type:References; b=IjI3gZMCUnbcnK6TfNFHNp784hfohuGy7AMDuMokL7wdQ1E5rkTH7Ly8SnniZizu1nF8kaPCyu+rbeb5fa8c+ZEWXuldLbBjXE9jtDUiUM6Lfin4wXBY/0wDcsdIWyUPxjtk9IQuJQqgvbNm6BGQz9sWE0VkxAEdvgH49ym5fcQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=lpk5c0Ay; arc=none smtp.client-ip=203.254.224.33
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="lpk5c0Ay"
Received: from epcas5p4.samsung.com (unknown [182.195.41.42])
	by mailout3.samsung.com (KnoxPortal) with ESMTP id 20260911152620epoutp038334f5361d02f168979e71713ad341bd~UTbJs_8pu0973109731epoutp03C
	for <linux-scsi@vger.kernel.org>; Fri, 11 Sep 2026 15:26:20 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout3.samsung.com 20260911152620epoutp038334f5361d02f168979e71713ad341bd~UTbJs_8pu0973109731epoutp03C
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1789140380;
	bh=gm1y3HjSbfjetP2qj6SkQ/PvAerOiP935sq/jHQIUpg=;
	h=Date:Subject:To:Cc:From:In-Reply-To:References:From;
	b=lpk5c0Ayq7gsxcvMiiNEkF25LoM+hK07D+2nZihTK7p0G5aYMGnbdCAdi0mFxa36/
	 N8z9VPS8dLrtt0v3x6743wki2Etr00dRUhPcL/ePrhQHbI5BNJsPTpKJdS9wsPw7wG
	 8hWKocYMvhZtfuP2XoKS8OjgT1WEVwDDiWP8xGHM=
Received: from epsnrtp01.localdomain (unknown [182.195.42.153]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPS id
	20260911152619epcas5p4e052c42a46dfc242e3f1b6791b28f0ab~UTbI3Mq2f3161131611epcas5p4E;
	Fri, 11 Sep 2026 15:26:19 +0000 (GMT)
Received: from epcas5p3.samsung.com (unknown [182.195.38.91]) by
	epsnrtp01.localdomain (Postfix) with ESMTP id 4hhJKl0Y8sz6B9m5; Fri, 11 Sep
	2026 15:26:19 +0000 (GMT)
Received: from epsmtip1.samsung.com (unknown [182.195.34.30]) by
	epcas5p4.samsung.com (KnoxPortal) with ESMTPA id
	20260911152618epcas5p4083afd5b157676f9af47292e16782212~UTbHvb9o32346223462epcas5p4p;
	Fri, 11 Sep 2026 15:26:18 +0000 (GMT)
Received: from [107.122.10.194] (unknown [107.122.10.194]) by
	epsmtip1.samsung.com (KnoxPortal) with ESMTPA id
	20260911152617epsmtip136290beb98362cfc02b9125b72997132~UTbGqVnz82637526375epsmtip1q;
	Fri, 11 Sep 2026 15:26:17 +0000 (GMT)
Message-ID: <d2a3a486-ff05-4296-a9f9-240cecda6705@samsung.com>
Date: Fri, 11 Sep 2026 20:56:16 +0530
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: add tests for file system on devices using protection
 information v5
To: Christoph Hellwig <hch@lst.de>, Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, "Martin K. Petersen"
	<martin.petersen@oracle.com>, Kanchan Joshi <joshi.k@samsung.com>, John
	Garry <john.g.garry@oracle.com>, "Darrick J. Wong" <djwong@kernel.org>,
	linux-scsi@vger.kernel.org
Content-Language: en-US
From: Anuj Gupta/Anuj Gupta <anuj20.g@samsung.com>
In-Reply-To: <20260911070831.1760646-1-hch@lst.de>
Content-Transfer-Encoding: 7bit
X-CMS-MailID: 20260911152618epcas5p4083afd5b157676f9af47292e16782212
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
cpgsPolicy: CPGSC10-542,Y
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20260911070839epcas5p47f2a530a45e293ba4f18b6add13c8222
References: <CGME20260911070839epcas5p47f2a530a45e293ba4f18b6add13c8222@epcas5p4.samsung.com>
	<20260911070831.1760646-1-hch@lst.de>

Reviewed-by: Anuj Gupta <anuj20.g@samsung.com>
