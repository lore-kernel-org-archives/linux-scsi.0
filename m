Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C73DA4E1C8E
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 13:13:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789650813; cv=none; b=nhzwPC9SRkuZw/Eu14rXRof0NdXT2OduGsBjBI3cHr4qtXNmpDA4hHVegviWbFl3vpYi6TwvnAdadycrasHSMATKvRdlUg95YnrHwMiFlEAvVZj4Visk/2l3svr3kR1YjsQLc1fbg6SZ/UGTRX8CZM77xSr4ODLFijpDx0EodNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789650813; c=relaxed/simple;
	bh=q6qWbuPTImrdX1ZmsjSnnv7xddRb7BF34Mw6yXokUFU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aJuu46UHEaXt6i22nahjM2kghEw8IKCbpt7zMhXc4aROKprPo7Eks9EiRci5DMQ7isPQz6YuK0IrakqhhxyWuQzfIgFDUBSniBiGUSUAyXYmEc9vx7vFVNSTF+LN5LBUuDIsFzxEWaI+STl8hDq2nHppdMLqtxZCs/kTMGwgBVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NkX9uUx2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NkX9uUx2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BB4B1F00893;
	Thu, 17 Sep 2026 13:13:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789650812;
	bh=crgSj9qj3KXwvbLhyhhAhoC7KJOTRcShZQmd9hrKo/U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=NkX9uUx2CyPirW4clQ2lIYjSpoZ+rpvOlbmObV9q36NQL4S2dER+fwyh4BjsUOo2L
	 jU+4QSykBW9iLZt+u7FniThwF//DSFqcJMh08NETJ4hKsyW72h9EShEv8tyvcbtymH
	 234VI0ksu08XcVSdShJEYWFjQb+IZFaQd3BxlTDAqUjsziG3anVwaCrJE76LrXPQLd
	 NIHi9SzpCykVKUVw0jHX1vNWZQdpczYvn5NQD9m+MSlzdnqLQSekJITHcKSg1mKUdB
	 q2bziV5fVlWOoH+1eIKCp0Wq7q4GSak6Q6rWmWONieAl4LYgAnF6WpS5+uYeuaoX1c
	 iflrinUoTfvDQ==
Message-ID: <aab12a4d-9895-4f90-9911-856699bc9094@kernel.org>
Date: Thu, 17 Sep 2026 20:13:29 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 3/6] scsi: scsi_debug: Advance the write pointer over
 the data written
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260917125445.1376493-8-cassel@kernel.org>
 <20260917125445.1376493-11-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260917125445.1376493-11-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/17 19:54, Niklas Cassel wrote:
> resp_write_dt0() and resp_write_scat() advance the write pointer of a
> sequential write required zone by the transfer length of the command
> before looking at what do_device_access() returned. It does not always
> move that much data: it returns -1 when the data direction of the
> command does not match the operation, and a short byte count when the
> data-out buffer is smaller than the transfer length, both of which an
> initiator can produce with SG_IO. The first terminates the command, the
> second completes it with GOOD status and a residual.
> 
> The zone state then describes more data than is on the medium, and a
> write at the position where the data really ends is terminated with
> UNALIGNED WRITE COMMAND, because the write pointer has moved beyond it.
> The zone has to be reset before it can be written to again.
> 
> Advance the write pointer over the data that was written instead. As
> do_device_access() does not write a partial physical block, what it
> reports is a whole number of physical blocks, so the write pointer is
> left on a physical block boundary, which is where a write can end.
> 
> resp_write_same() does not need the same treatment, as it writes with
> memmove() and cannot fail part way through.
> 
> Assisted-by: LLM
> Fixes: f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

OK. So you read my mind :)

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

-- 
Damien Le Moal
Western Digital Research
