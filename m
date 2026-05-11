Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519DC2FE071;
	Mon, 11 May 2026 20:26:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778531218; cv=none; b=JGPVzkcDmzX2YBzGUlahuLGSPSM2FnJwrvEAPSHd89Wt55kK1ht2gFu1/7tBM87V44vnxsvmmSNqdNLSajQ9gS4bMEFGpxxU66zQFKCUohP0Cxx3uXren8iF+5vjgO+Rb4x4kGZtWjAo+Nqo6Oiefxx2e/mems3ByVQgzHh08mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778531218; c=relaxed/simple;
	bh=ueAEeem7oLKiA9H0f9Uw/vFDeBbVIZ3ZHzIl10JTPCQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fICN/CXRW7UIypr72Zy0s9iSxznNHAWDRpw5SYDVuGg9vGOmicnRSw7QUfH6IWjrjG0RY6RUiBXyE9qLQS+xY5mw035F3k4K4j4up3Z8OeA/DUjv8uDKfDJK75gkJgPZcJoGZ0xYwLfUlYMzWWRePYDZqgQMAhvv3sSGecg8HP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pe0gbrgS; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pe0gbrgS"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4gDrqM4lJmzlgwNJ;
	Mon, 11 May 2026 20:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1778531211; x=1781123212; bh=P9awFGfvCcW4xgOEqM2x9TzT
	GnXXxuDOsRPKIFAGTxQ=; b=pe0gbrgS1JNTkXN3xlZ+XtKFx9v7PFSpQ0XsEPDN
	PYIkY/OJSwHfgrw15aynlIJ1kcU1B0rtxqilKryUoLq05o2ukTe03sD8sLOa41D1
	S0xR9FV1lueymFLZ13clIJGk+odD1D/8ojCiMdmt8OhS/nN6OsPXphdm6/pCmEYf
	/NPLxX2qX9yovcJhVBdmP6Ctj+IWChdHVw9olWKl5EOlllqgmfazo4heatbmbwlt
	3T2T9THsN4tq7n50sMSAlMAx+69Oz2cZbe+iBeh561BAg3FhhHTMXyyzpWpJNhOd
	6DdWu91mHB0CWzQq9K39uin0KTCjsCnw6WY7YaLxYTav/A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id ts5CI3-UmrTQ; Mon, 11 May 2026 20:26:51 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4gDrqF00Wnzlfvq4;
	Mon, 11 May 2026 20:26:48 +0000 (UTC)
Message-ID: <ed4d2821-b8d8-46e7-84b0-d6d283e86a11@acm.org>
Date: Mon, 11 May 2026 13:26:47 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] scsi: scsi_transport_srp: Move long delayed work on
 system_dfl_long_wq
To: Marco Crivellari <marco.crivellari@suse.com>,
 linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: Tejun Heo <tj@kernel.org>, Lai Jiangshan <jiangshanlai@gmail.com>,
 Frederic Weisbecker <frederic@kernel.org>,
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
 Michal Hocko <mhocko@suse.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20260507143410.337267-1-marco.crivellari@suse.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260507143410.337267-1-marco.crivellari@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/7/26 7:34 AM, Marco Crivellari wrote:
> Currently the code enqueue work items using {queue|mod}_delayed_work(),
> using system_long_wq. This workqueue should be used when long works are
> expected and it is a per-cpu workqueue.
> 
> The function(s) end up calling __queue_delayed_work(), which set a global
> timer that could fire anywhere, enqueuing the work where the timer fired.
> 
> Unbound works could benefit from scheduler task placement, to optimize
> performance and power consumption. Long work shouldn't stick to a single
> CPU.
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
