Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9523F1DF740
	for <linux-scsi@vger.kernel.org>; Mon, 28 Oct 2024 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730146232; cv=none; b=kukOAFlHyTI4k/eRlsbBLN2+LMsttA++m+jFcZhKuS+D/GWVJeyubk8iU7nsPblK7bXyonymJiulXcJ9apJN3jhE5OyS0Bjy+ydAAdb9YYJMglCWHN7MqDRoPowP16RPCxiBS0Ha56HeqeV/IMBw80EF8LUZcqPAx3amcChpBwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730146232; c=relaxed/simple;
	bh=5xUb2C43mljvLzVy55BGSd/q9cFuxWz5g0oOjBJqOVk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GM6s4h9lxCh4Rt4Smq+QLq4bAdZ7GgM39VGD21ydm8N/vwO3pOXaFJM2/S3J2OtpzUQFZpNcJqK0CyJWUK2awTP6rjSKzPwoxo4qRTbsjcupoiFUxFblU3+dGwA5+s/K8KcXzbPOyEG/+vngokDJbXP6YHbKm2/EAHfpuYNzFlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=U2vKgTv1; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="U2vKgTv1"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4Xckyt0GpjzlgT1M;
	Mon, 28 Oct 2024 20:10:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1730146228; x=1732738229; bh=5xUb2C43mljvLzVy55BGSd/q
	9cFuxWz5g0oOjBJqOVk=; b=U2vKgTv1/fRcXQGnx3nua/1WeTcBJRl7sCxnzSwU
	RdiGvJwJEDjfHdrP3RoxTRLZWftXqpzHJSSXbNj3YsYopnPwa+rvk8ON9NFhO3Z8
	rgRWq8TxnSlc78xuUAtsxKse0FyayDYE3bOk2qRA8A58IA0tAvLw+JOpxBdz9rca
	zry9d9xV81fT8jqaDgnyZc5LY2kmnPws8ddghet1QVTvT9UvO0EgND0oNYnhlKzq
	qizK8c3WtJJalTTi3C3sdk4UjUOb/Chuqcjz+A/ZU0f8N0UeIddqehw7g/KZMnGN
	wIrbLGTOU/gx0U83sxplJQOkh8Q0FqLVy0YBKQTtSP0Z4g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 81TD8ZXTbozZ; Mon, 28 Oct 2024 20:10:28 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4Xckyq2p7XzlgVnY;
	Mon, 28 Oct 2024 20:10:27 +0000 (UTC)
Message-ID: <38872318-f2dc-4af6-b64c-10bb107e8015@acm.org>
Date: Mon, 28 Oct 2024 13:10:25 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [EXT] Re: [PATCH v2] ufs: core: Add WB buffer resize support
To: Bean Huo <beanhuo@micron.com>, Bean Huo <huobean@gmail.com>,
 Huan Tang <tanghuan@vivo.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "opensource.kernel@vivo.com" <opensource.kernel@vivo.com>
References: <20241026004423.135-1-tanghuan@vivo.com>
 <e992d83526fe722af8cef1b9ca737c8d0646417a.camel@gmail.com>
 <04e443d0-2968-4d63-b05e-ddb7b2aa5680@acm.org>
 <SA6PR08MB101635BB17A5B1B2B13363344DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <SA6PR08MB101635BB17A5B1B2B13363344DB4A2@SA6PR08MB10163.namprd08.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 10/28/24 1:04 PM, Bean Huo wrote:
> Even though I don't think it's necessary to enable a Sysfs node entry
> for this configuration.

Right, a motivation of why this functionality should be available
in sysfs is missing. An explanation should be added in the patch
description.

Thanks,

Bart.

