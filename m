Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAB862877E2
	for <linux-scsi@vger.kernel.org>; Wed, 24 Sep 2025 21:56:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758751014; cv=none; b=TYbxydoIX8nl1a/1qmhJ7Vb/2BIobz4bs2agxXF+9Hlco7qRNw/WtnHusRb3ipIE6o5ryQNceVEC6BUaZE7Qng8R6mj/t/WEbprMjAINFGqnBBBcSucUBjs+Vaus1ZE1Nn0LUUyhfYaniwADjJsYeGZ4Au7J7DqcGjbgH8icWy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758751014; c=relaxed/simple;
	bh=iTxN2750e5bpeTaQ7TppbltNZbKzod9SZvI8svLvVuY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JXlQnqcHphMuVLOy1oDhU7Y3FAclY15MkkvPiu723sFMEc0kcJ9z6ZTQsfkn4oCJM35Z+6Otn+lrd4TtkP04EiTsePWDGzUshz6kLOwB1PPW6xRJ1ripj3sqQZ8tXzHj/fIwSxgNY1e0yTgQDU9nxvQv5fpWCV+ASITI56MkQtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=HAVMVUFU; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="HAVMVUFU"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cX9fr0D3qzm1742;
	Wed, 24 Sep 2025 21:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1758751009; x=1761343010; bh=iTxN2750e5bpeTaQ7TppbltN
	ZbKzod9SZvI8svLvVuY=; b=HAVMVUFU9qKgB7YhwD6kr6ks8apZY3ypNrC0tF17
	7bqbPI3lM69NE3rOjtAUeZdOzFXPiyy1WLL3s/bvQdqrpjnV9l2W4bUhOrGBECGa
	wSWzZFC7P4t8BZUzdonbQ4YprYgXe/ligU3YhHXWf19dMVteAbupGwkUgyhTSURY
	poSa/bssx6VYLaFNBof9GQmR/bR+Ef5+0Z95IihqPmPp7k2lFNqR5hB2SUTRmj0i
	uQv35kBSfQqEXIX/CcozMS+yxcOO4TEWvGEBUZyJYPl0f4MoFm9nsttXgV8yRyrm
	vMRx+6fJTvvTnlUTtH/u6JyUqXN8DTHK8rYvrAsTYl7VSQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cj1dUvO3LjJw; Wed, 24 Sep 2025 21:56:49 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cX9fZ33Bbzm0yVD;
	Wed, 24 Sep 2025 21:56:37 +0000 (UTC)
Message-ID: <0835ae8a-2abd-4438-871b-e7e4c98bf965@acm.org>
Date: Wed, 24 Sep 2025 14:56:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] ufs: host: mediatek: Adjust sync length for
 FASTAUTO mode
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250924094527.2992256-1-peter.wang@mediatek.com>
 <20250924094527.2992256-5-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250924094527.2992256-5-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/25 2:43 AM, peter.wang@mediatek.com wrote:
> Set the sync length for FASTAUTO G1 mode in the UFS Mediatek
> driver. This ensures the sync length meets minimum values
> for high-speed gears, improving stability during power mode
> changes.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
