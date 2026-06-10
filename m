Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4AB2296BBA;
	Wed, 10 Jun 2026 16:47:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781110022; cv=none; b=YJa2QXKVnPWowH/hbH1u2M5xLF+RJvxwlXwsHEUeWjLdHPkI4l3rs8GtXmaOL9Fwrq9eoKaWP67OnM+9yHzz9gzQrATm7fvQW5Mue6eVmiKIoACpPG/mDq4tw7kMqSnDE1VfMZf30WHDY5C3COy1nHa7EykKIa9rof0pf04sa4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781110022; c=relaxed/simple;
	bh=aZlhauMybcsLl8kIgbp5wNtOt4YG3oeBwviWuHyGg7I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DLPESm8eX24cvnx+cwnjl/qC20QJWme10uKVaQQYjZeriQQXyotYk5QpK6kgnQdAqu3ca3A62jj/n+kLVt7+onSeayglLN8kA2PlsuOf7CjW8WU8dvED0F/6DwGeMrFGPCtPFnxtxxPofWld2azqyk/zA41CNp/xTvNmx4N4D8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=thCDfpWr; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="thCDfpWr"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4gbBWl74F5z1XLyhV;
	Wed, 10 Jun 2026 16:46:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1781110014; x=1783702015; bh=aZlhauMybcsLl8kIgbp5wNtO
	t4YG3oeBwviWuHyGg7I=; b=thCDfpWrWI/ywSQ9tYY8WHHnXW/IEBFUm/tBjyF/
	49Hy4Tj0FhF5Bp3qG5huP/npVKLKBsFieGtulviHRwlb5IRbs0u1Hf7eJT6tf8Yk
	ZnMNlwKb+PWqU3SVEzd5DylNPHO3v8bMwjxDog2cMEOGaHRAruHf6RRH9Huyd25N
	ysE9oz/mmtf2XPIbsoybAfj4NVuven6cHOMgjVGvFoSIbgUETk9I18lByyUVM0MI
	j8i/+QOsE+wmYum5FWC3LKzK3kgaCQSg+nAxE1gJpGumdisMi+kL41Jm2ns9FZG8
	eM96OighqxovL8j2uBHSt7wkkzyJKyK8+6XkJ71tcpyiGg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ltPV2J_RGYQF; Wed, 10 Jun 2026 16:46:54 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4gbBWZ6ZBdz1XLyhT;
	Wed, 10 Jun 2026 16:46:50 +0000 (UTC)
Message-ID: <1f4a26be-4985-448f-955d-00e4f697224c@acm.org>
Date: Wed, 10 Jun 2026 09:46:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: mediatek: Implement get_hba_nortt callback for
 RTT capability
To: ed.tsai@mediatek.com, alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
 peter.wang@mediatek.com, alice.chao@mediatek.com, naomi.chu@mediatek.com,
 chun-hung.wu@mediatek.com
References: <20260609103856.676222-1-ed.tsai@mediatek.com>
 <20260609103856.676222-3-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260609103856.676222-3-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/9/26 3:38 AM, ed.tsai@mediatek.com wrote:
> Implement the get_hba_nortt callback to handle platform-specific RTT
> capability differences:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

