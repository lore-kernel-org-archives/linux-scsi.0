Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C55FB2E6CD7;
	Mon,  3 Nov 2025 22:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762210282; cv=none; b=UbzUCfJPeRrbZHx0cUExz5CeRVTcp3UFr2BUs7bs91KD384S2eMxo/itvsK+R4gmpyIMgbccYk/Vb1lEAaXkFepanwvWqlJapcvNAw8wetAxD9+nUmPwMjusGR80mmlwJM5paVrMslQJpAbU4jXHV5diFKXbqoLJ940Qnrucd7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762210282; c=relaxed/simple;
	bh=+MRghoTidc+qlTKw3kb7aFeEYXb+o5vL9QO5Jyos7Uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIc4RDMuI5CM8ZxD4cB6HxjvqEbXp0roHFoCSPgHGDoV5670kPikq/zveC/sQVKHv8roKI9SVu+SzSW8+fiO+pDf3/fbVt0uASDs51vfkrzO2cXj0OOOTqaK8ajD1LzN6h3rZtuPzEvFHI62CG0PvL8efeantx36bpUs6oxpNMk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MDRx75kk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MDRx75kk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C5ACC116B1;
	Mon,  3 Nov 2025 22:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762210282;
	bh=+MRghoTidc+qlTKw3kb7aFeEYXb+o5vL9QO5Jyos7Uw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=MDRx75kknFqeD7byta0iT8As3D8wrn21+VlwkTsAbLuSmTrM0QIDS2SWD0BaPuqYK
	 /5XuMfifJqX4ke4mO7Njpj8CuohKlsnJeIC3psnCmzYp7Tu9t0Jgl4xfIKNEr+Poh/
	 2kLE+Wts61ELmEqBbb1rN2s/5uOYCuoG0jcUw1EkSdZRMzgOP6BIUabY7yAvCK354X
	 BbBDi7bF85ydWMdb0FyMFm9Nky4DtGUHPxG16P+zRE3PfsdzSw6hmfsLSjZsMCeuww
	 U9Tptzx1dnXB7DWSNRKpiebIruTwvVZBfGPlz7c9WNAJ7eeDwCbLqV99bPrCdQQOxU
	 ++s3aApcyb1tw==
Message-ID: <51db9579-f78d-4192-93fa-b252fe954d13@kernel.org>
Date: Tue, 4 Nov 2025 07:51:19 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: ATA PASS-THROUGH latency regression after exposing blk-mq
 hardware queues
To: Igor Pylypiv <ipylypiv@google.com>, Niklas Cassel <cassel@kernel.org>,
 John Garry <john.garry@huawei.com>
Cc: Jens Axboe <axboe@kernel.dk>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 linux-block@vger.kernel.org
References: <20251103170308.3356608-1-ipylypiv@google.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20251103170308.3356608-1-ipylypiv@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/4/25 02:03, Igor Pylypiv wrote:
> Hello,
> 
> I'm observing significant latency regressions for ATA PASS-THROUGH
> commands that started after commit 42f22fe36d51 ("scsi: pm8001:
> Expose hardware queues for pm80xx"). It looks like the libata's deferral
> logic that relies on returning SCSI_MLQUEUE_DEVICE_BUSY does not work
> correctly for blk-mq's multiple hardware queues.
> 
> Here's what I've figured out after some tracing:
> 
> ATA PASS-THROUGH commands get continously deferred because NCQ queue is
> not yet drained. At the same time, other hardware queues (other CPUs)
> keep issuing more data commands effectively preventing the NCQ queue
> from draining. Since NCQ queue is not getting drained, ATA PASS-THROUGH
> commands can get starved for a really long time e.g. ~5 minutes.

We already received a report of such issue, a while back. But being busy with
other things, it fell through the cracks.

Note that the issue is not just for passthrough commands, but rather for
commands which trigger ap->ops->qc_defer() returning true, that is (most of the
time) a non-NCQ command issued while NCQ commands are on-going. It just happen
that most pasthrough commands are non-NCQ.

I think it is time to address this command starvation issue...
> Reverting 42f22fe36d51 seems like a plausible workaround but I think that
> driver might still benefit from using multiple hardware queues e.g. to
> issue commands to different drives from other hardware queues. It seems
> like there should be a way to drain/freeze all hardware queues before
> issuing ATA PASS-THROUGH commands but I haven't yet figured out how to do
> that.

Yes, we need to remember the fact that a deferred command exists/was issued. But
that is not trivial to handle unless we introduce a workqueue in libata that
handle these, draining the queue when needed. But that would mean that we keep
on hand commands that are not being issued, which is something that the block
layer better handles (with a requeue).

So in the end, I think that the better solution is to look at the scsi & block
layers requeue path for deferred commands and make sure that these commands are
at the head of the dispatch queue, always, to ensure that the next time they are
issued, they are issued first and will eventually get a chance to run once all
on-going requests complete.

> If you have any ideas or suggestions on how to fix this issue and/or what
> things to try, please share. If you happened to have patches that would
> fix the issue I would gladly review and test the patches.

Let me see with Niklas how we can handle this. We'll send something soon.


-- 
Damien Le Moal
Western Digital Research
