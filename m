Received: from 002.mia.mailroute.net (002.mia.mailroute.net [199.89.3.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF9C3277030;
	Fri, 28 Feb 2025 19:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.5
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740770424; cv=none; b=UBrq9CJ8I3x5jwCzdE+iCDjw5JdF+DkP+VjSNamS27F2Fy2Oo6RsdTfQUyns96mNiFh5EIZlkbK6RNh1tA775G4+aKMk/9chPYRYJCb6tvhvut4TYTioOwrGUPYU704m2Fte0nYryDfKTvt+4F0nau9eMpw+KcJeq9uK3WInkf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740770424; c=relaxed/simple;
	bh=y8iZHFfgfCXmyfClwlNFB2+zP4av8fAnEWq5Jj7fCc8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NvpIXZFJHLSDRjfq6jiW9/JrItuEgfVBvfB4rkBLoJdv3QlccTHWpshZgbc8gap3YSD7JMUrnv1eUiHTwKTgI8BRMLcTwGSLDAvlz/wsLd9LJ+CWvXEQQOD7yWfCQAjoGlgLqAy4DB9Z9e693Y0T2J65KrfPo8RmCWfXxPpx6Y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=PjOXS/Fx; arc=none smtp.client-ip=199.89.3.5
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="PjOXS/Fx"
Received: from localhost (localhost [127.0.0.1])
	by 002.mia.mailroute.net (Postfix) with ESMTP id 4Z4J242R6Dzmhb81;
	Fri, 28 Feb 2025 19:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1740770410; x=1743362411; bh=ijqd47QKXGOVwTEi1MWq3e8j
	LsHYg4U3JJwxKiy6Sug=; b=PjOXS/Fxfg0tjQZrZ0JbYpPXzCAUMc04MjT8DQrM
	eA69NisCMokjX6Nw0EaWCf3Tafi32+f/5nvrkZXdQWqisJ2Jh22ahQ6OVZBnNaFs
	bsxvEAsY7THxzXW5w3I3j46VKSHK1Fv3q0u832yDfPCd8m6Qsm90jjyr/OWijCJS
	5I4/cU+nqGaBCOYe0xuLUvUNoDtsDQgoBnrt+81CDM5t+P0kI9nTxmCiFrPM8LiW
	HPz8mXslEiq9YIMzgsmAmDA279kBMtKvyphXfjy+qhWJObXOk2yLA/8w5qgak+yq
	KJI8r5qpOFC4NaQ5m3wp90x5pU17A+hgn5pZZS8oqDNr1Q==
X-Virus-Scanned: by MailRoute
Received: from 002.mia.mailroute.net ([127.0.0.1])
 by localhost (002.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cSwXOBJPq-ym; Fri, 28 Feb 2025 19:20:10 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 002.mia.mailroute.net (Postfix) with ESMTPSA id 4Z4J1z4YzCzmhZ9Y;
	Fri, 28 Feb 2025 19:20:07 +0000 (UTC)
Message-ID: <51ec6f40-c62a-418b-a538-082e3ad887cb@acm.org>
Date: Fri, 28 Feb 2025 11:20:06 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/6] scsi: ufs: exynos: Move phy calls to .exit() callback
To: Peter Griffin <peter.griffin@linaro.org>, alim.akhtar@samsung.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 krzk@kernel.org
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 willmcvicker@google.com, tudor.ambarus@linaro.org, andre.draszik@linaro.org,
 ebiggers@kernel.org, kernel-team@android.com
References: <20250226220414.343659-1-peter.griffin@linaro.org>
 <20250226220414.343659-6-peter.griffin@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250226220414.343659-6-peter.griffin@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/25 2:04 PM, Peter Griffin wrote:
> +static void exynos_ufs_exit(struct ufs_hba *hba)
> +{
> +	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
> +
> +	phy_power_off(ufs->phy);
> +	phy_exit(ufs->phy);
> +}
> +
> +

For future patches, please follow the convention that is used elsewhere
in the kernel and separate functions with a single blank line instead of
two.


Thanks,

Bart.
