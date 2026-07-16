Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA8A141E6CC
	for <linux-scsi@vger.kernel.org>; Thu, 16 Jul 2026 12:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784205688; cv=none; b=oQDaRyF+v8F3IUfH7HEJD9QFpPknKhv33/7x27YLGhCqmoKYdVM09L42Of1YLPp+t5fGwzkc8VVrSIhcQ5TZOzc7l6ZfBnBy9QWbp+7U5my5G377+BCA//OapOWmr19Tmr8MpYp108Wq2fzFZBafs06x4rklj1wv7CxKmiRJJGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784205688; c=relaxed/simple;
	bh=938/F1N2FwNWpoCKQp7OStj5ZJBLidiPmTJI3mQN58s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZkDv2mfZvSB4ZL3Ixtr8XHYtW3Dsy81mg33IvlzJsZNEDvZbeOIkDlRXiQnaNz1ooqIOzoJ0kKYQlDLTKsTyWRVUeLpUzcaUYSmTlHDE0Fl5qhHThys1atUz/vjSXFLtZRHdbOnVLmLbMKROoLNSHYnyKsUvXpp03Ray4aZNoq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=fozibS7L; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=6mvBb2xC; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="fozibS7L";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="6mvBb2xC"
Date: Thu, 16 Jul 2026 14:41:22 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1784205684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=938/F1N2FwNWpoCKQp7OStj5ZJBLidiPmTJI3mQN58s=;
	b=fozibS7LKatXjUzAtE4P2nhnhuIYx3fciFM8bPIA/isssqALgS/TaEYQb9aDx3VgO8+ZMM
	3qjjBBIUlGeMkxcJEC8ZmodNbuPZ2X0fvvpg3SiKt3GTqDWOSt09Il2IyUcSi0lIB4sh33
	PZ8WTjn2mCIczt1HCf6Yo4cvKdFh+s2g5I5gf6ynawWd2S1VpZ4DsQyo1R+Q5KdB4LMcJJ
	gbTymxFnsvI+REBk2XOGv7/uRccTe7nSZJcKysPFbZ3T2pAQ5hKOMncBO7P42bPCidpTfy
	fCYTv7ZJBM0hlHRxuPqAg936GF6N3iWAuVBjag3lm7DO5CHdZNnS9dMlx8xJTw==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1784205684;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=938/F1N2FwNWpoCKQp7OStj5ZJBLidiPmTJI3mQN58s=;
	b=6mvBb2xC25EW0p+dvsTHo1ucazTRFnRLAifvJEhgjjiaSJD0X9+J3an/wrHyHUWeQbA2zz
	pfOlfb3RT7MVBaDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org,
	Neil Armstrong <neil.armstrong@linaro.org>,
	=?utf-8?B?5a2Z6a2BIChLdWkgU3VuKQ==?= <kui.sun@unisoc.com>,
	=?utf-8?B?QW5kcsOp?= Draszik <andre.draszik@linaro.org>,
	Gregory CLEMENT <gregory.clement@bootlin.com>
Subject: Re: [PATCH] ufs: core: Revert "Delegate the interrupt service
 routine to a threaded IRQ handler"
Message-ID: <20260716124122.edYnUovp@linutronix.de>
References: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <b70eb60a01f971bed68c42c5b555929db5f835df.1784135511.git.bvanassche@acm.org>

On 2026-07-15 10:12:28 [-0700], Bart Van Assche wrote:
> Fixes: 3c7ac40d7322 ("scsi: ufs: core: Delegate the interrupt service routine to a threaded IRQ handler")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

This fixes the PREEMPT_RT fallout I was looped in, so

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
