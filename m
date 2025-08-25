Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4934A21FF29;
	Mon, 25 Aug 2025 01:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756086961; cv=none; b=hTKESHzJ6YmzgX1+Sug13nJSaljJn7euKxGixUWzWLeB8EMXTQo5ssUbXftfGeETJHlvw4iUFhvPTlRHxAHO7mMv6mnUVjBaME5ZH2+/CY6KlLwPPFkfFClXcQBUcJIwYzYkbLkbJPtvbEgK7vh1IVaSkv1K8FKoK8VC1BxGFBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756086961; c=relaxed/simple;
	bh=ZPgC9y2c4hXPz7N3gvX5ECV2a+8bjzwIuZU2gXOQjFI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t33JGdPKX4Pw13tpFLqmvARScVjSlYTqXkxMjsb+ISRllipn18JwWv+mFG6TdGApzU+Hi9U2PMpF9ErKf8QFSlG3RuaHOqFcxXqVihiBtrk2dKMStQSoHH/6blLrw9zmGfaySYMLHzw5TLVygmMit7FrOPl40rZt5oUsD2RuDOQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6fNnOel; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6fNnOel"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA01BC4CEEB;
	Mon, 25 Aug 2025 01:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756086960;
	bh=ZPgC9y2c4hXPz7N3gvX5ECV2a+8bjzwIuZU2gXOQjFI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C6fNnOelTWhnNW9IAdzHc+EdnWwqSNrz4uA/n+uJr2T8QQY6F+IDhbQsENPbJSAGw
	 96t6E5FjHuSpiIUfGmcL82W6fAGPKCt3AZgtXzbYPXUOpq/zvc24zdg7W+dJbejVgn
	 okMqDlYejIoRR6CPlaEKmRvHqyu/rU6HP/3nSckulu98Fl7q2F+VTkaOIM/wOBWqBf
	 e4YrBt8T0veIL4KByFQzAIK4vzPvVxKpWa9ckjTGKXFvcFB9BLu1Nk+0Z7JYe1xroK
	 ai+EbkWSwqco/INoRX1Gv5sLNZ0U17k9dTuOIXWsH28bY/VMV31QNWhHGqOdkQNB1a
	 tzNupP0rtVFTg==
Message-ID: <392d911c-7b71-4d58-b07f-8e215c65b3c8@kernel.org>
Date: Mon, 25 Aug 2025 10:53:12 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/3] scsi: sd: Fix build warning in
 sd_revalidate_disk()
To: Abinash Singh <abinashsinghlalotra@gmail.com>, bvanassche@acm.org
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com
References: <20250824180218.39498-1-abinashsinghlalotra@gmail.com>
 <20250824180218.39498-3-abinashsinghlalotra@gmail.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250824180218.39498-3-abinashsinghlalotra@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 8/25/25 3:02 AM, Abinash Singh wrote:
> A build warning was triggered due to excessive stack usage in
> sd_revalidate_disk():
> 
> drivers/scsi/sd.c: In function ‘sd_revalidate_disk.isra’:
> drivers/scsi/sd.c:3824:1: warning: the frame size of 1160 bytes is larger than 1024 bytes [-Wframe-larger-than=]
> 
> This is caused by a large local struct queue_limits (~400B) allocated
> on the stack. Replacing it with a heap allocation using kmalloc()
> significantly reduces frame usage. Kernel stack is limited (~8 KB),
> and allocating large structs on the stack is discouraged.
> As the function already performs heap allocations (e.g. for buffer),
> this change fits well.
> 
> Signed-off-by: Abinash Singh <abinashsinghlalotra@gmail.com>
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Looks good, but please move this patch as patch 1 in the series to make sure it
can be easily backported. And please add:

Fixes: 804e498e0496 ("sd: convert to the atomic queue limits API")
Cc: stable@vger.kernel.org

before your signed-off.

-- 
Damien Le Moal
Western Digital Research
