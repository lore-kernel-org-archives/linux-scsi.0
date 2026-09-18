Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D3321AA1D5
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723759; cv=none; b=EF3K7KgC1HtGz9Ol2icIcl3lUQPnyws3K5hfx5/bByLIlgxmA3Fi8okx2bgJyhkguB/sApqoUyDqjTuXAb2hWSW7TlUsEblYWElaZE2pVvgz+hmjNCDFLp5fwxiauXf5OOl36HFe1/Mu2SbwRxbD8ivW1+gIX1ScXmMly1TqS+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723759; c=relaxed/simple;
	bh=bSGfo06pDLq+U7tY/OIYnKl+vplF47PNnxZTfkKc37w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdc4Z3tg93z3GG7NycZibqFOqMIWLOzpDpEnVoGHjIuXV38vAYnoY0dXJkWK7lhhnqFyoWM0CJUqZrRjeA2SqF42YWWDSUNJwf/NJ5VzNJLrIYvnXEavz0uu8zqB9dZMFBwI8dW102RMCxjjSK7A85op5B0f/MGxxF5GXesQZKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PejxZtXc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PejxZtXc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70C281F000FF;
	Fri, 18 Sep 2026 09:29:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723757;
	bh=MV4v+azVDaNtREBuET44nGSqN+/VtC6x7Sj81/aXjso=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PejxZtXcKtyBmElKEMiDifLz4h59V/b0xZbr6ihhxU36iWJhjU4NFxnWdRbPVFf3y
	 lu4GiKAuz2O1sDooabmYgBCePb/LVkXqjZlDnarsrrL1W1rsqj4izXB2REoP+nPVQP
	 lP5o/8/XfYs5mnUGEdkucYSl6FBq3Rb6habAIxgKQFukUM5uEaETdQYyLrJmweMpqF
	 uJQTtq9Q3zVowzeyaSNRUZ4LuEr+YQWy7GiDyGdR8SVfrTNvKcey4hP6bivTuKMnMO
	 W2EeWTVFS85dOOhqvb48y3Kp027zdbY1dxhEAz9EWGcF3406Y2QUUx112FCVEth31U
	 Vn5hDxLNySy/A==
Message-ID: <8e1f5759-e797-4363-9b45-b6303502a568@kernel.org>
Date: Fri, 18 Sep 2026 16:29:14 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/10] scsi: scsi_debug: Evaluate scsi_debug_lbp() only
 once
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-16-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-16-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> corrupt_lbas(), resp_write_dt0() and resp_write_same() call
> scsi_debug_lbp() to decide whether to take the zone metadata lock, and
> then call it again to decide whether to read or write the provisioning
> map that the lock protects.
> 
> The result is not a constant. scsi_debug_lbp() is false while the
> fake_rw module parameter is set, and fake_rw can be written at any time,
> both as a module parameter and through its driver attribute in sysfs.
> The two calls can therefore disagree, and the later one can decide to
> touch the provisioning map after the earlier one decided not to take the
> lock that protects it.
> 
> Call it once and use the result throughout.
> 
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
