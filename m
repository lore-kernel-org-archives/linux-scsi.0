Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDF451F09AD
	for <linux-scsi@vger.kernel.org>; Tue, 13 May 2025 13:42:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747143755; cv=none; b=LQrqL4oXaREDM6Oyj8tDuFkHfi853Cm5yPSY0zbXyzh9uha4bQ07yD9CXjiPkJSyTuvNnVf0Syo/SAK5JHag/dkZo/GK5Zp9Df7wNqNCqt8LuvMQMWqmM/XNw10npbGspDG3L7FieIlJw4PiemYgp4IlV/MeZz5r69LBcJNdUms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747143755; c=relaxed/simple;
	bh=FAZmxHO4IKWe93G8q0zzOL5FUKSBW0etydiFxL2hXMI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bh1WCqSP9p7HGTUfnjVkYbMRTJxXQi7YY28X98QSkd7A7Od2f0Em5O2qe7SMHQCOiNpxg5CQO7unmPe4MlFbqkS3CNugNgh7yytvleA6zKQUEp2ddVah2bsxzdvtC0N5RyMtqaQIBF4xl+qF9wnn2YEWYhFSSkUb0y4lX4x+tkk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=jyMZn4d6; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="jyMZn4d6"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4Zxd2J36WtzlvhyL;
	Tue, 13 May 2025 13:42:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1747143748; x=1749735749; bh=FAZmxHO4IKWe93G8q0zzOL5F
	UKSBW0etydiFxL2hXMI=; b=jyMZn4d6If179WZDQr/8wk76e894KWNZSb8posyk
	+KsT/SBvWSr2VsZovoJRLwUGzl+ujbF/6790AQ/kqrxycuvBQU4yyvaWC8RAqLbg
	tShp00nHJqjsWAWz+wsJ9ltKLV5SI8WvDJLhciYC8YoQRnJPM2w57x9DzBNLEKY1
	C9L509lTQL/RN49O67q9DmsfFYdcRvU3/gV26lnLRObhy/lIaqq6Gs5+jTUaOM6z
	lvsGVMyLYjlLA00qjvKe4rN0zurbfqmY2w2iZNcYkMXz5NgudXbNp0uU9Qvsj5ZA
	krf15ldNWpNrsvoKFFof1OMKvvD2TgFVUCwxlB9Z+/h8lA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mazkmqSRCX3y; Tue, 13 May 2025 13:42:28 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4Zxd1q15hSzlgqV1;
	Tue, 13 May 2025 13:42:06 +0000 (UTC)
Message-ID: <4420fcd0-5125-43b1-89ff-c3e5edad2939@acm.org>
Date: Tue, 13 May 2025 06:42:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] ufs: core: support updating device command timeout
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com,
 yi-fan.peng@mediatek.com, qilin.tan@mediatek.com, lin.gui@mediatek.com,
 tun-yu.yu@mediatek.com, eddie.huang@mediatek.com, naomi.chu@mediatek.com,
 ed.tsai@mediatek.com
References: <20250510080345.595798-1-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250510080345.595798-1-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/10/25 1:01 AM, peter.wang@mediatek.com wrote:
> V2:
> - Change minimun value to 1ms

For future patch submissions, please include the changelog below the
triple dash (---) such that it doesn't appear in the kernel changelog.

Thanks,

Bart.
