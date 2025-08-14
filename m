Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25660253B73
	for <linux-scsi@vger.kernel.org>; Thu, 14 Aug 2025 21:24:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755206699; cv=none; b=jnazJFaJyatCnr49Kx0pgT3kvI+3z7zyQgPmUKfodpsEsvpYGGSkui96xydXj7FPnN9gHbxVn/UD+vnkpOn4NqzlpSqiBx664rQFvRz7ggCt6V6usqEL0NwCnaKJ2/hIp3D8/87siqqB2nEft5su16u6LPKP3TmBA7MYbzKLIpk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755206699; c=relaxed/simple;
	bh=njf10Z9bQ0rh/OpeNy+KCuZum9DEIc3upPlvq9ed6BE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pzMc+hNABO3zcmhehq5uxN1r38hUX9zfNAgnH2xUfPX3UgU0a5rUgqHFE7WZLW6Q40ax6CS44jCfLkKaYYOqkJ2gxI4TjO2ou0sA7GGUVyuAHGQvsUAAqy3BvvKVgTFKjIfU1eySddGITaryYkcCGVMP9hRm96lULyeq/3aTUjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pKgVu2lv; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pKgVu2lv"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4c2ytx0jbJzm0yTk;
	Thu, 14 Aug 2025 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755206696; x=1757798697; bh=njf10Z9bQ0rh/OpeNy+KCuZu
	m9DEIc3upPlvq9ed6BE=; b=pKgVu2lv+4aJfgxHMJ5NVZktMMI8IhFQe9n425AU
	dTyqaDjN5ec6xpIjfvvQRiEE+eQFKdyxiyUiFoxKII2fAq5qp6oGQm/X5aNMZw1t
	RrwGKexsflFUJKQrmzWdcvNatSmH6wFuL5EBF1gocTRkzay01+yX4QQw6O5w77bo
	DsWMY/YLSj2urDx2haF0CwulHDP6WVR9hR5ghF1QV60KZFekDVdfv0lZepi/dEsp
	e6I8J6uABhBcRTtS3rTJlwV8Gdoqd/CGvJXbGj3x2665XBnKWINzDPQn1YfMTecB
	VnAgZgD+bTGlfy9Ufzg+Wpz+rjTe9aFOqDit1E/nDeoqSA==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id xIoexVI1FrYt; Thu, 14 Aug 2025 21:24:56 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4c2yts1Ys4zm0yTq;
	Thu, 14 Aug 2025 21:24:52 +0000 (UTC)
Message-ID: <f56d5c4b-5a26-4f89-af3b-32e4d8583b69@acm.org>
Date: Thu, 14 Aug 2025 14:24:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/9] scsi: sd: Explicitly specify .ascq =
 SCMD_FAILURE_ASCQ_ANY for ASC 0x3a
To: "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc: michael.christie@oracle.com, dgilbert@interlog.com
References: <20250814182907.1501213-1-emilne@redhat.com>
 <20250814182907.1501213-3-emilne@redhat.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250814182907.1501213-3-emilne@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/14/25 11:29 AM, Ewan D. Milne wrote:
> This patch
> changes the retry behavior, we no longer retry 3 times on ASC 0x3a
> if a nonzero ASCQ is ever returned.

Hmm ... my understanding is that this patch makes read_capacity_10()
retry if ASC == 0x3a and ASCQ != 0 and also that without this patch
these retries don't happen. Did I perhaps misunderstand something?

Bart.
