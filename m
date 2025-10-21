Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02DD72877FC;
	Tue, 21 Oct 2025 21:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761080498; cv=none; b=tAJyMoBVVeOJ7eR4b+lrCKQExK6TrCqMa6iAi3+T+qa3j3dZCCmt36CuSwbXq8cfF64CQAV7EW7Jyw/H3YnOasNx0A1Uj+kI/ihOd4k09T1g4bceVHxO3lWhNMopFznlDQE2X9i0IgxsQ3ln3YP3fGmXYnI+WF+kEXXOXABeYSc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761080498; c=relaxed/simple;
	bh=caHDjsJ9RUTloNaBqadwe2PgBd+49tVloshXUhPynKk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Qbgv/PeHO+G7FhxQA36aYEv0KXbiv9KIdrfgyuEilBr+ywzdnPzWXd6Zugz7y5LJ5i6b3ow9/mHbB9JBYsiWWkacklZTWjqkqmnD/r7jiLbE0PgYxLgb03qsaJ4b/DTNF7jZnLfUtuNzxRQobFbEkeHrIBxtn6T9LieYHN8b2/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BKHCzy+4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BKHCzy+4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A412C4CEFD;
	Tue, 21 Oct 2025 21:01:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761080497;
	bh=caHDjsJ9RUTloNaBqadwe2PgBd+49tVloshXUhPynKk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BKHCzy+4D6Bz3nVh4w0iU/tj4Z8F7hvhKy4V+wLEZ7C+vvKwuOSWXanBt3p4Fs4mC
	 5MRu+LlTwV2vh04d5JzXHt1E0VScZ0H5Rjy2lDkM3ytzEPMx7DW61lMQJP+27VabNY
	 Usee8W6XKRg1uAg+ppd5JIoDc0eu3low1mxWc/L6aQh7wFGgZmgXuUdwlEdbDMRJM/
	 UijTQZEBAAMZgNkMq+IzQ5/mdAnk56rU4XncQN051fMFzGpu/H3JhcKGlzIPKrnFoZ
	 2tcF3bOW88fd/U4Dfw1IHlUnKuJc29jDTALSk6yshSMdKfqQySsuk6hgf0Xr0bdxzI
	 gL+ECEUUsLJHA==
Message-ID: <d667eb93-6ced-4b36-963c-e6906413aee9@kernel.org>
Date: Wed, 22 Oct 2025 06:01:37 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v25 07/20] block/mq-deadline: Enable zoned write
 pipelining
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20251014215428.3686084-1-bvanassche@acm.org>
 <20251014215428.3686084-8-bvanassche@acm.org>
 <08ce89bb-756a-4ce8-9980-ddea8baab1d1@kernel.org>
 <a1850fbc-a699-4e73-9fb7-48d4734c6dd3@acm.org>
 <136efbd2-babc-4f07-871f-f1464a2ec546@kernel.org>
 <f8c1581f-5337-4473-b2a0-b1e1a9ee206e@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <f8c1581f-5337-4473-b2a0-b1e1a9ee206e@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/25 03:28, Bart Van Assche wrote:
> On 10/17/25 10:31 PM, Damien Le Moal wrote:
>> Maybe we need to rethink this, restarting from your main use case and why
>> performance is not good. I think that said main use case is f2fs. So what
>> happens with write throughput with it ? Why doesn't merging of small writes in
>> the zone write plugs improve performance ? Wouldn't small modifications to f2fs
>> zone write path improve things ?
> 
> F2FS typically generates large writes if the I/O bandwidth is high (100
> MiB or more). Write pipelining improves write performance even for large
> writes but not by a spectacular percentage. Write pipelining only
> results in a drastic performance improvement if the write size is kept
> small (e.g. 4 KiB).

But you are talking about high queue dpeth 4K write pattern, right ? And if yes,
BIO merging in the zone write plugs should generate much larger commands anyway.
Have you verified that this is working as expected ?

> 
>> If the answers to all of the above is "no/does not work", what about a different
>> approach: zone write plugging v2 with a single thread per CPU that does the
>> pipelining without to force changes to other layers/change the API all over the
>> block layer ?
> 
> The block layer changes that I'm proposing are small, easy to maintain
> and not invasive. Using a mutex when pipelining writes only as I
> proposed in a previous email is a solution that will yield better
> performance than delegating work to another thread. Obtaining an
> uncontended mutex takes less than a microsecond. Delegating work to
> another thread introduces a delay of 10 to 100 microseconds.
> 
>> Unless you have a neat way to recreate the problem without Zoned UFS devices ?
> 
> This patch series adds support in both the scsi_debug and null_blk
> drivers for write pipelining. If the mq-deadline patches from this 
> series are reverted then the attached shell script sporadically reports
> a write error on my test setup for the mq-deadline test cases.

I am not trying to check the correctness of your patches. I was wondering if
there is an easy way to recreate the performance difference you are seeing with
zoned UFS device easily. E.g. the 4 K write case you are describing above.



-- 
Damien Le Moal
Western Digital Research
