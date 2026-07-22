Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118FA361978
	for <linux-scsi@vger.kernel.org>; Wed, 22 Jul 2026 15:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784735772; cv=none; b=IFElQKgn02nuFZGX9/tDCNb74D0y5ckiDbjtoyD1SCahonVqUkGBtcBjywl+agWYDJSSp7JVptPY2U4wQu0z7Sev0Mwqjv1bzvoJBT+HSg5n+6uY5qmNHRWJk06OzARkXJKhbJnlOiIhcELSzMkFph+zr4WUq7nV/fJnb5ZHdg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784735772; c=relaxed/simple;
	bh=lLa1D3HQSxq0apfhBHq9PSK9iirNjNQkuLmYZVYCHRg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=cvQd0z9lGIZ93CEEE2AGr5JbUFDnUq+f1FL8NtcruQ877prPfXaxpIm6mJiC4DbuE/41PkOSRnGc+culOw2ntwqUFN7kmYO/jAq7H6kzQ9r98kDONKCBHEuFuwQYtZZiTuHCIV5qhXJ8TEPflKNXKorlOsen7ZU37/S9RYkhxpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=C/m4f3ZT; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="C/m4f3ZT"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784735755;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNC9hlPHsYhQt2/JTvX0yu4hFLcVsF38K0QULETCs1c=;
	b=C/m4f3ZTr7p65uNBUJMvO7VSJIEmAA08Ry+waMRpeZsWrJy31UWMwQGkrOHhaERTyJreB/
	H/k8Nssd3fRfkyKvheph0eWvhqbbTa7MQUzNKqP9NwxHU8o4SodPXB5YcGRqzphCqLc8zS
	jD+ev8AH5QKj+jXkuXu1OXeJMK7yf8E=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sashiko-reviews@lists.linux.dev,  Chris Mason <clm@fb.com>,
  linux-scsi@vger.kernel.org,  ksummit@lists.linux.dev
Subject: Re: How to fix problems with the sashiko review model
In-Reply-To: <dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
	(James Bottomley's message of "Wed, 22 Jul 2026 07:58:48 -0400")
References: <20260722041257.1557-1-pengpeng@iscas.ac.cn>
	<20260722042744.5C1B01F000E9@smtp.kernel.org>
	<dcadf40a07a616de931c484bbe68f4b3f1f83b80.camel@HansenPartnership.com>
Date: Wed, 22 Jul 2026 15:55:51 +0000
Message-ID: <7ia45x27dnnc.fsf@castle.c.googlers.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Migadu-Flow: FLOW_OUT

James Bottomley <James.Bottomley@HansenPartnership.com> writes:

Hi James!

> There doesn't seem to be a Sashiko list, so I added ksummit as the most
> likely one to catch attention.

We actually have one: sashiko@lists.linux.dev 

> We got this review in SCSI on this
> thread:
>
> https://lore.kernel.org/linux-scsi/20260722041257.1557-1-pengpeng@iscas.ac.cn/
>
> But this part of the review
>
> On Wed, 2026-07-22 at 04:27 +0000, sashiko-bot@kernel.org wrote:
> [...]
>> > +
>> > +	reply_len = mpi_reply->MsgLength * 4;
>> > +	if (reply_len < event_offset || reply_len > ioc->reply_sz)
>> > +		return false;
>> > +
>> > +	event_data_len = le16_to_cpu(mpi_reply->EventDataLength) *
>> > 4;
>> 
>> [Severity: High]
>> Is there a Time-of-Check to Time-of-Use window here since mpi_reply
>> is read directly from shared DMA memory?
>> 
>> The validation function reads bounds from mpi_reply, but after
>> validation passes, mpt3sas_scsih_event_callback() re-reads fields
>> like EventDataLength and NumEntries directly from the same DMA-backed
>> memory.
>> 
>> Could a malicious device mutate these fields in the window between
>> validation and use to bypass the checks introduced by this patch?
>
> Is wrong.  Hardware may never be presumed to be malicious (well, except
> if it's virtual hardware provided by an untrusted host to a
> confidential guest, but that's a very small list of drivers or it's a
> USB or thunderbolt device designed to attack or exfiltrate data from an
> unattended system).  It may be buggy, but we never presume bugs until
> someone finds a device exhibiting the bug in the field (so we don't
> proactively fix them).
>
> The bigger part of this is that I was looking into how to fix this
> (which might interest a broader swathe of developers than just SCSI). 
> I think the fault is in the review prompts:
>
> https://github.com/masoncl/review-prompts
>
> And what I need to do is to add an additional drivers.md file to
> kernel/subsystems explaining this?  If that's right I can send a pull
> request, but I thought I'd check here because the audience is much
> bigger than if it were to get discussed in the github PR.

I like the idea to inject the security threat model document from the
kernel source tree, I'll add it.

Thanks
