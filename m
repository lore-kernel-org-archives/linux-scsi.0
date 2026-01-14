Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45539339B4E;
	Wed, 14 Jan 2026 18:45:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768416304; cv=none; b=Sf8O1zxS34qvpJTGT3J2nl9BNDOtV3sh4a8MeYBSH2AMHvPpvR0btd3TdOHymJLox/d+mH8dzt2ytH9uAfy1u5AIDzj83a5C0A0AeIKn8a8CV3bWCj/W1wiSayLzeZJk1Rt04oaDgQr1sANi69l89RwunUOpl8T3qpQ3GmWu5FM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768416304; c=relaxed/simple;
	bh=bMymUs+O/5UOcoxAv9q1fwdIIJzCE9BopK7FUY1gQ9A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AUreCXJxN5ExYeePy6eMhchE9H16Hxzjncwy4ymx+cLnLFLbUa8JFJz4DxJfD32YumJHEgYQu3dTKCYU/7gUCD9xNdZwlM98hDR1cL6fZEvI9tReek2r0jImzhe1eCsdddJcxEBrjcHnbEzXyiCbfl6pH2Nmk549a9O6K3xVu0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=3ADvw6ri; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="3ADvw6ri"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4drw5p4sfkz1XM0p5;
	Wed, 14 Jan 2026 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1768416300; x=1771008301; bh=bMymUs+O/5UOcoxAv9q1fwdI
	IJzCE9BopK7FUY1gQ9A=; b=3ADvw6ric/ZO7GZQI82meuEPExf+FCEdP0UMrUs6
	GSm44RsjZvEV5W6FRi0SEp+Ihz73nXi/IGdehBiRL8mNeazQdyqZ/GQhLD6sIBUB
	L9FxUXASoqcb8rn+eaSFYWsav5MfWNalPbS1keuj1WGBeUPI9/jw7L+hfv/sdw34
	9wzle8lL0bItLzheqRTunEt8ykDioiLt/KF4hcKcHmeVb65LOOvXynNxZeXBGH1J
	NfJP2VOZ9A9aqqm0/PwYP0U1AAUEVXE8zwYIHVkp9I3ZidtMiydczKbubtX9A9Th
	iSDf1qMJcFFo5cBNCxK4BWNpxY+xRfhw9BtIXAAykvpIWw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id KfrL4izFLC9j; Wed, 14 Jan 2026 18:45:00 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4drw5j0zTLz1XM6J4;
	Wed, 14 Jan 2026 18:44:56 +0000 (UTC)
Message-ID: <14f96dc6-bcea-4343-82c8-f321e6367aba@acm.org>
Date: Wed, 14 Jan 2026 10:44:55 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] scsi: ufs: exynos: call phy_notify_state() from
 hibern8 callbacks
To: Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 kernel-team@android.com, andre.draszik@linaro.org, willmcvicker@google.com,
 tudor.ambarus@linaro.org, jyescas@google.com
References: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260109-ufs-exynos-phy_notify_pmstate-v3-1-7eb692e271af@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/9/26 4:40 AM, Peter Griffin wrote:
> Notify the ufs phy of the hibern8 link state so that it can program the
> appropriate values.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
