Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FC31BC3C;
	Fri, 14 Mar 2025 01:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741916130; cv=none; b=QwtlVknxQH6x6GgfAriiWVfBZ3vc26iVX0yRNVpXB49l0FiM1uNHMJQsbxW6E5Vt78q4Hsw1WA7cmMsuR1ZNw0C/xMpB1++JShDXuBEYGqP2cELHbtgb4pNNlGoro7Tru7xX6tpwQWyJ77op+4Yw27Syjr4Ed8K4VlNqHUZioDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741916130; c=relaxed/simple;
	bh=+rXvagmmqnv+l1UF0oIBQjSTsbM1a0sIGXjE1qIXr7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BXT7QDJethYGRJVBXtYDYuS8e4HUCnDofVcfl1lkhD+4OkurNhyN2GHfiUE0+SKPfDbYujX8El5U7H61LBPgMlf6ZH5bDfU2fQCkGMfkxN/gWyzM/WRXklprmDquXHOZKwHlR0x5+ysXco95S4Gyo8e/MlhOJ79f+JXv6VOMJEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=J2IhqacH; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="J2IhqacH"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4ZDRl2732Czm0ySj;
	Fri, 14 Mar 2025 01:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1741916125; x=1744508126; bh=+rXvagmmqnv+l1UF0oIBQjST
	sbM1a0sIGXjE1qIXr7I=; b=J2IhqacHlqBBmWr+s+RnzzGoZQFtYCYAJrt1nV3F
	JIEs/XHa3NkxZrFnE+dYHnkh3+YJjMs70l+/Xj+k8b0Y9OPN7EY0Txb0H57vRDpf
	k1zt3OnJbFPvi/r5iIrks3+MX88Jo127ICbZJVuV82qnfqEY1fBrQL5j0Vuj01mn
	WC2iltIwQkfz+fUXHUy/LhVktFR0Uj/Dwb8ualGN/l8BF5T6JUDAghdITklZVY2t
	fazRHpED7gnbYmGbsXMZnkaqhajCT6+a2otLz/vSMxu0N6FQWbTVcxJp+NEVV/Lr
	kgUhwi6pP/CgswDJDPt+sPJRJjy4hEuOgjxhKJXs9xa4OQ==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2e4iigJ2aOgj; Fri, 14 Mar 2025 01:35:25 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4ZDRkt0bzbzm0djt;
	Fri, 14 Mar 2025 01:35:16 +0000 (UTC)
Message-ID: <0238dfce-49c2-43f0-9c71-556c7c5ffc75@acm.org>
Date: Thu, 13 Mar 2025 18:35:15 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v3 09/19] scsi: core: increase/decrease target_busy
 without check can_queue
To: JiangJianJun <jiangjianjun3@huawei.com>, jejb@linux.ibm.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
Cc: hare@suse.de, linux-kernel@vger.kernel.org, lixiaokeng@huawei.com,
 hewenliang4@huawei.com, yangkunlin7@huawei.com
References: <20250314012927.150860-1-jiangjianjun3@huawei.com>
 <20250314012927.150860-10-jiangjianjun3@huawei.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250314012927.150860-10-jiangjianjun3@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/13/25 6:29 PM, JiangJianJun wrote:
> This is preparation for a genernal target based error handle strategy
> to check if to wake up actual error handler.

I don't like this change because it slows down the hot path for LLD
drivers that do not set starget->can_queue. Why is this change
necessary? What are the alternatives?

Thanks,

Bart.
