Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706983AB5B2;
	Fri, 29 May 2026 07:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=193.142.43.55
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780038247; cv=none; b=AUg1d0ltoEaLOobf0kMkj4afnhaATFJJr9ZEgQrA8/BHm7/dQ/nV3TqaqAcKY2LVzGYY+9TxeME9QOnQ1ofEyDoCr2C0eywE4PmmMb4TSa4/l7aHBa2fs0yBS+XURi+grcGFPKDrgkox5lZoOoRrr0cUqc9/7OvgoaqPWx+cItA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780038247; c=relaxed/simple;
	bh=v7sX+ULYT5bCj9o9c0kVdTQQZkubq/TBTjiGXqtMynM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=B50aYDZ93moEggTt7ahbb88Q2PQ6KQTO18v+00DCs6gQQA+33z5NpBEZ2dTFO9A5BzwkWyrracxJ8drQMXnz0CznEcUdn3ffGA+9DCt17oJ2zSCFrdbvf7wL7L5oOSzgyD4CifaBI7ebZx6P7Ig8W/aWclUm93UpznvsSJHUspQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de; spf=pass smtp.mailfrom=linutronix.de; dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=ym2KkiJT; dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b=QHDxbAiV; arc=none smtp.client-ip=193.142.43.55
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linutronix.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linutronix.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="ym2KkiJT";
	dkim=permerror (0-bit key) header.d=linutronix.de header.i=@linutronix.de header.b="QHDxbAiV"
Date: Fri, 29 May 2026 09:04:03 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1780038244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7sX+ULYT5bCj9o9c0kVdTQQZkubq/TBTjiGXqtMynM=;
	b=ym2KkiJT8yxfe0+7nEzMH2D7BFEsvlBxWuvKUzpj5vquXtXt5AZO6UrKunp3e/FkMDaK0l
	+EYK8QvqoyfnFMwSJi5r8vFXQ4KOGMp/aSlOXdY5uHxHt3xNX7bPYqThVy09B9CqrpWtCt
	7dgapZ78Q5fdAq7fPKqQAz38Ls4bYWUx1Wt97Dmj+WgvArDXoyT0LP5u5ciGWgQ79mfEGy
	aMYg0Q08gDQyNnO/kgttXYWfZaPqgqvRzVggtzlQRzSWf6ZvHNI7+pJXWIKA70eDrmiZC4
	ZaTcN+3Lqkt3EQvECAIwRygIzm45Lx9OVvWjRg14ABoWN/XResx3KZM9fD+BoQ==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1780038244;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=v7sX+ULYT5bCj9o9c0kVdTQQZkubq/TBTjiGXqtMynM=;
	b=QHDxbAiV/UdeiPePRE9mQXXZuSv9ahUCAaQXZUJ/Z2D0YuxYo+GW+IEux4PPxDsgPqT9Ph
	RwNBvz075PtTDTBQ==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dawei Feng <dawei.feng@seu.edu.cn>
Cc: ram.vegesna@broadcom.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, kees@kernel.org, tglx@kernel.org,
	linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org, jianhao.xu@seu.edu.cn,
	stable@vger.kernel.org, Zilin Guan <zilin@seu.edu.cn>
Subject: Re: [PATCH] scsi: elx: efct: fix resource leak in
 efct_xport_initialize()
Message-ID: <20260529070403.yEv7faft@linutronix.de>
References: <20260529040115.2735213-1-dawei.feng@seu.edu.cn>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260529040115.2735213-1-dawei.feng@seu.edu.cn>

On 2026-05-29 12:01:15 [+0800], Dawei Feng wrote:
> Fixes: 4df84e846624 ("scsi: elx: efct: Driver initialization routines")
> Cc: stable@vger.kernel.org
> Signed-off-by: Zilin Guan <zilin@seu.edu.cn>
> Signed-off-by: Dawei Feng <dawei.feng@seu.edu.cn>

Based on inspection, it looks like the right thing to do.

Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Sebastian
