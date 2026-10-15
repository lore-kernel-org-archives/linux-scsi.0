Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31B6924E4C6;
	Thu, 15 Oct 2026 17:53:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792086826; cv=none; b=b6rXUsCZ/5IJveX5tyPhTy2hGewo1tjFUKf1ooDFD3l7n4Uk/l6F9Y+snYXQ57VoQbfuezaa+xjeHQ5a3ktEe22TPIiB8OCJyWJQAP01lhP2TLk2qyaiRh358COOqMC1wHqwJnrVQaqIb3bRmkNnmdhwJFL933EqsOL3941Qa4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792086826; c=relaxed/simple;
	bh=6ouyzi+6xfKJ6vTTHo8bMZVzVa3a2wXe8A2g8j92zS8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RHex7/ik3r9PvWqNQw67AEk2D00BwxNRa+dQscV8yoEpcCQ07qKSPrMijBWc6f2sj9VZwTwc7OEagykM16FaBIr4Zd4zaoAdgbTEIPSmvjsQRlo9VtPkA7T6dpGs0ERStlR7TTuzCzjpUgIspmrySMsIeCxuU8TWoVswjT4prHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ZFJEFDm+; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ZFJEFDm+"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4j5G030ZMtz1XM5kD;
	Thu, 15 Oct 2026 17:53:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1792086815; x=1794678816; bh=6ouyzi+6xfKJ6vTTHo8bMZVz
	Va3a2wXe8A2g8j92zS8=; b=ZFJEFDm+vWJC73f/Ayw/TKnlIkRruVEjZgK3jmjn
	CdQYF+seW9WrF/RpDPt+bMdgkJ4K8awra9k11J0yFMfkA6dsh+yFikCbbPkrTfU8
	jnkmRbvX+ZRR9IVBtcGBECVNLzMScwy6hO6lyyXnT7TXV25FShaFGBJF5gGexxLG
	LphVUMZzupUSF/H6rvZv0go6QCL3kWlHUlgYcnG1wG6lSGIVKAdXURDqgiqfic3i
	H844fCZcxw/Ee60rh544JBi5vjDWdntrdC9hmj2KSO/Wv+EIjU/C8X92r9aIjrQD
	dc15oT3dhtr+wrQPms710hDg9LPm+nDhuQOZ/Od/R/cYzw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id qxIIrw2SzjBH; Thu, 15 Oct 2026 17:53:35 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4j5Fzz0Jj9z1XM4Tl;
	Thu, 15 Oct 2026 17:53:34 +0000 (UTC)
Message-ID: <7ec5c2b3-daba-4a85-9c37-65edc79c0cd5@acm.org>
Date: Thu, 15 Oct 2026 10:53:32 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] scsi: ufs: Fix UIC result byte and BSG request
 handling
To: Stanley Jhu <stanleyjhu@google.com>, "Martin K. Petersen"
 <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: Alim Akhtar <alim.akhtar@samsung.com>, Bean Huo <beanhuo@micron.com>,
 Peter Wang <peter.wang@mediatek.com>, Brian Kao <powenkao@google.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261015001855.3450573-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20261015001855.3450573-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/14/26 5:18 PM, Stanley Jhu wrote:
> ufs-bsg fixes for issues found by fuzzing /dev/bsg/ufs-bsg* with
> syzkaller on QEMU's emulated UFS host controller and in review of v1,
> plus a fix for peer DME retries.

For the series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

