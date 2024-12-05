Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C456D193
	for <linux-scsi@vger.kernel.org>; Thu,  5 Dec 2024 03:33:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733369598; cv=none; b=lQLYV2NZ8j9kibjsF+HpBoHirwd6IEi1AP+How9cLvZxW+QU42HwsHpKRq0Y+w7H7hhzQZUC+PEZXN7rnCLGNyHHnZFcnVtr3ACOHFKIcmLJQdYXzfoN6SfOunOHhvzIPGrIaSg2+r4gpuK/kbEjrV/jw/B7jFXHNq9eTi5hohI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733369598; c=relaxed/simple;
	bh=aZSHbvKaR037fK5Fzz85rRcDmEDSSMgQsguisMjf2gY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Bl5KBHM3GuYILbzUlG6KlZ4UFwyvEqQSU8i3cJudpTxYaLLrzORhv0bPZcV6yiXCR41f8MbrftT1MpRBEDPOrfOatZ3Mr1NDiWoa5nwQXmsb6KOpwCkmJLh49S1YxsLcQNtDId1v5RTUug3wf1NMwFTsL1QFtQijOk02rnro8GU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QxYnv0+X; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QxYnv0+X"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4Y3fz42nJrz6ClY8w;
	Thu,  5 Dec 2024 03:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1733369406; x=1735961407; bh=aZSHbvKaR037fK5Fzz85rRcD
	mEDSSMgQsguisMjf2gY=; b=QxYnv0+XacYMtd2jbUjGpRcf9TNbmEy4xL34AGNX
	i4jAgdz1loWimYQE5yxReCdkoSLywaJc5ANzQnX5k/3KcLc9rbgJl9VTMVg6/Kiv
	J9wCN+EW84ZBVt/ByqY63ACjoFbgAgzu4la/ZY+RSrTccpBn1xol0y0xlJhfuZvS
	HTEb0DHp5NxCBPgHkNnAhNoDhotHs9oTwDtXbroRynKOi0JR4YDhhPySXQ0O0hWV
	uxmYAYA14eYMCQOrfheWI8oYsfIz1ySHDL2bpEmIOarQXfZ6+3f+MYCHBJTnpm1x
	QhMr4kaDn+XFO1Esw2hwRaeNUXT2eSbrExFP5F6hsgv9eA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6p_3MLTD4XXT; Thu,  5 Dec 2024 03:30:06 +0000 (UTC)
Received: from [192.168.43.227] (220-135-57-31.hinet-ip.hinet.net [220.135.57.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4Y3fz10j9nz6CmM6d;
	Thu,  5 Dec 2024 03:30:04 +0000 (UTC)
Message-ID: <e4dd503f-be9a-44c2-861b-ed642d5c80d6@acm.org>
Date: Thu, 5 Dec 2024 11:30:02 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 0/5] Replace the "slave_*" function names
To: Randy Dunlap <rdunlap@infradead.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org
References: <20241022180839.2712439-1-bvanassche@acm.org>
 <69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <69d7efec-1f69-419e-a300-84ff347eaa46@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/5/24 8:57 AM, Randy Dunlap wrote:
> Can we expect to see this merged for 6.13-rcN soonish?

Thanks for the reminder Randy. I'm currently traveling and I plan to
rebase and repost this patch series next week.

Bart.

