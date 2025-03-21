Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C698022FDE2;
	Fri, 21 Mar 2025 20:10:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742587838; cv=none; b=RzRak0NIO7sRzd57yQStr5TIQVED/ai/3L/uKm3v49gOWJNzqHaOO4Pn8YbA+1z5jOjXslJGrkqFaYyrTa0dM8DVyJfEShjXpZppv8f3kdnhgrqI1zDeGpexRgWVeVAQ/6XtCMOrZl3X0jUQRRzBBrzTFG/uFuPLZiiOAGsNb2w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742587838; c=relaxed/simple;
	bh=ExX4HzIXt1eLoL7kgSQzUTPK0LokgibMRw5hn9r+UAE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qbmavbHpySe/thyIEICfFaPNKqMCvbqBPVW7zbE213wRdCHNTyb5LWOBx3oF6cqOGtUi3g3hPNCwpUJCxcwvf/9DpaCQfptuJfzMAE8AqcIhT9O/ycJY3qNdNaccYlpUq0TWo6f//pJ6i43VGu7HCUBODC8O5oUcuq24ObFmNXk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=BeX9sO6k; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="BeX9sO6k"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4ZKD8W4Ty3zm8Stx;
	Fri, 21 Mar 2025 20:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1742587833; x=1745179834; bh=NntvXvtWhzJ6OcqXMIfgs9i0
	GrnRvBUhZKhhcyppfos=; b=BeX9sO6k4WzpXNtsHcsp6DjnpMY0Zih21JisnYN0
	KFhaiOHHFGhm5T6dCGbULAsNlImXcz92dNL6FIlVdSkmIHfifpRzGM4PLKeHDZGs
	WDGwckOK0/Y2eXq7eGrFkhrNVdasSm7N1cYsgweCHk3gub9JIy8S+56uPNeMZc7q
	S68CoHQIbFKziQ14d4cVlCOL9j/WY0Z0h1T+dCgGcuQdVs1TxlnoJY2w4d5qqXB5
	Y1AZlQryhEsnJ+7cpTzfw3pU/3mAaiSgn4N0NCQgXsyNDzSkmyNG9NTIMt3uyEVr
	3MRSjIvE9gkEcFozIOkSJTKNdzeCO01xO2Rog5ncVgFwGA==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id wZ0MmdshLZIg; Fri, 21 Mar 2025 20:10:33 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4ZKD891S2jzm0Q6C;
	Fri, 21 Mar 2025 20:10:16 +0000 (UTC)
Message-ID: <8d5fd977-b600-492c-b888-2318130f46ec@acm.org>
Date: Fri, 21 Mar 2025 13:10:14 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/7] ufs-exynos stability fixes for gs101
To: Peter Griffin <peter.griffin@linaro.org>,
 Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Krzysztof Kozlowski <krzk@kernel.org>,
 Chanho Park <chanho61.park@samsung.com>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
 Eric Biggers <ebiggers@kernel.org>, willmcvicker@google.com,
 kernel-team@android.com, tudor.ambarus@linaro.org, andre.draszik@linaro.org,
 stable@vger.kernel.org
References: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250319-exynos-ufs-stability-fixes-v2-0-96722cc2ba1b@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/19/25 8:30 AM, Peter Griffin wrote:
> This series fixes several stability issues with the upstream ufs-exynos
> driver, specifically for the gs101 SoC found in Pixel 6.
> 
> The main fix is regarding the IO cache coherency setting and ensuring
> that it is correctly applied depending on if the dma-coherent property
> is specified in device tree. This fixes the UFS stability issues on gs101
> and I would imagine will also fix issues on exynosauto platform that
> seems to have similar iocc shareability bits.
> 
> Additionally the phy reference counting is fixed which allows module
> load/unload to work reliably and keeps the phy state machine in sync
> with the controller glue driver.

Although these patches are somewhat outside my area of expertise, the
patches look good to me, hence:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
