Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF04D481CE
	for <linux-scsi@vger.kernel.org>; Wed, 25 Sep 2024 16:49:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727282993; cv=none; b=cMX++QH/MzJkhFx5DoG4q6ZaP3aZ85WnwZ0r7+lUfyrgLUNGIvL1nyGrg4i7vflQmRXWvrLxJTxhT65Ektt08wRnbQZM7Zn1L4w14VjXe4BCgE9zpBBI+im3H4lNJxYmb+RSuZMNogkGFfcY5Bj+uzVNiM9MwYQPUSdGgRUOHr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727282993; c=relaxed/simple;
	bh=pW5mJRmQP7O665lo2fzBE0RZzSzmb+ucTVjHjKX321c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=THB9TYGNiNcVEgeXSshMHnXYOstfbDz4dM1NLjyYJvLvp8x1WpIJYEj6u/fhgk6jzPev+lMBNHV3UuEeAsTxHntj0mL7SAcrSOK9cRph3aUHik4waHhxYcov7YkqId7h+khbTx62B6/IEQltrvAAWSc+TaIIdKz8BVseioJpWqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3Bkq9HbX; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3Bkq9HbX"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XDN4Z4lRpz6ClY9Q;
	Wed, 25 Sep 2024 16:49:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1727282984; x=1729874985; bh=aoIJQ5MhiObxL7pikGsoI1ZJ
	dDV3AuLGWymzLJx4lOo=; b=3Bkq9HbX1dTOLg49btZVqXOEt7AQTA0ac89ZsCyp
	7YR1eRoLBc31JQejisIixFL4mWWHs+ec4OCQRu1Si8Ek+1fjlkx8cwqevtSoUbvl
	zzfzJw03HdAlnTyovvbjPMNqFHV0Amfn50IJlnYtIQ99m+aGZHWHSO7oTH1QHLkG
	WVIV7Lo8cQaTX7DuWGtyvNIhttR7RNNOPSHm8mzlnxCnnqlAkFSA9llyA88VcDCy
	aXcRlEEX5ObYb4zohkJNRB+aIhmcA9uFDj1YTwg8j3fbifndCwN8FFl/TcRJV1EI
	nSBm3/ryYFNcbFTciaBiMBXR4Du5LciY1MxNQlvFIkXmfA==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gA5KYz7Ednql; Wed, 25 Sep 2024 16:49:44 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XDN4M3CHcz6ClY9N;
	Wed, 25 Sep 2024 16:49:39 +0000 (UTC)
Message-ID: <949fb86d-6b61-4a1a-bc04-c05bb30522b9@acm.org>
Date: Wed, 25 Sep 2024 09:49:36 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] ufs: core: fix error handler process for MCQ abort
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, ed.tsai@mediatek.com,
 quic_nguyenb@quicinc.com
References: <20240925095546.19492-1-peter.wang@mediatek.com>
 <20240925095546.19492-3-peter.wang@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240925095546.19492-3-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/24 2:55 AM, peter.wang@mediatek.com wrote:
>   	case OCS_INVALID_COMMAND_STATUS:
>   		result |= DID_REQUEUE << 16;
> +		dev_warn(hba->dev,
> +				"OCS invaild from controller for tag %d\n",
> +				lrbp->task_tag);

Please change "invaild" into "invalid". Once that change has been made,
feel free to add:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
