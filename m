Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AE424436E;
	Wed, 20 Mar 2024 17:45:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710956715; cv=none; b=oApJvS04FLb7OY5QQq+gxtvgIBCyntmm/9qnT9aQNVD5La5eyfjtSf7jitnXS3DICR2wzbQ+B7xWp9Eagabl/1cLPYDWqVYpP2KB0evSRqwtNP4F3MN4jqRsda9aQSu0+NxUncQQNXaGAvi/xlKA7nIcIWN5+eVXtgIQHQfe/00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710956715; c=relaxed/simple;
	bh=GJUmMn8O1+0Qgr33lDmKiGfqPuy300EzxWsX5/k8E1A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tLoiPcFqQDFIpVjvsanfC2bNvcPzmMrJUOT0Weprrcg82R1+XkmPS7tBJWuV3xLicFfta8/cYEXockI9U4FKgPwikX4lrwQWihQmjAuYywSE7K6448GWq2Z6vV0XHTdDaXL6KVhqVZS+sRNvI0VImZu/qsoHZPlz8HElH7Jgf3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Y79iFE/n; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Y79iFE/n"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4V0GFZ6wZlz6Cnk8y;
	Wed, 20 Mar 2024 17:45:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710956705; x=1713548706; bh=eBkDCxL+4cfPGdEIHqAohiUW
	a95UqvI7P/+B3TioUJE=; b=Y79iFE/nVdQz6k4kucX0uOkOSTMIyG9O4XFL5rFv
	HLZcDtmJDpXDjN+rvTaqkXUc0PTfCXBPreIDB/OF6pGT7hWRcRjub8jLOoiEADON
	050c3cYXDGvNp0UC/OpxHbEsroWL/wpAJTGVicVcGtWbiSnWoHS/ARTPJ81puMRr
	kLmrN/6f33c6aOBjOoMbGBaaqhHvdwFTpAJqE+SIK2JPcaqljyQLpEQi4NFvA9Ee
	VImb6t/RcXst5mIjpoROXCz/JAFM5gp1qmPcswXVk+QFuVJl5oms1BM+mSAPGruy
	1SuJffyoi5F0nUx36oZv9zHUsbL+jI7Ue5AVor3PXnoc9w==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 4d0ZRzNUMVk4; Wed, 20 Mar 2024 17:45:05 +0000 (UTC)
Received: from [100.96.154.173] (unknown [104.132.1.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4V0GFX6sRJz6Cnk8t;
	Wed, 20 Mar 2024 17:45:04 +0000 (UTC)
Message-ID: <bb98f997-b02b-4af6-8488-cb13f424ac44@acm.org>
Date: Wed, 20 Mar 2024 10:45:03 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: sg: Avoid sg device teardown race
Content-Language: en-US
To: Alexander Wetzel <alexander@wetzel-home.de>, dgilbert@interlog.com
Cc: linux-scsi@vger.kernel.org, stable@vger.kernel.org
References: <20240318175021.22739-1-Alexander@wetzel-home.de>
 <20240320110809.12901-1-Alexander@wetzel-home.de>
 <8b8e5aca-4b97-4662-9ae0-fc36db2436b4@acm.org>
 <c2454690-4cb4-41ac-b4f3-b1591ca472e7@wetzel-home.de>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c2454690-4cb4-41ac-b4f3-b1591ca472e7@wetzel-home.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/20/24 09:58, Alexander Wetzel wrote:
> While I'm not familiar with the code, I'm pretty sure kref_put() is 
> removing the last reference to d_ref here. Anything else would be odd, 
> based on my - really sketchy - understanding of the flows.

Please document this by adding a WARN_ON_ONCE() statement before the
kref_put() call that checks that the refcount equals one.

Thanks,

Bart.

