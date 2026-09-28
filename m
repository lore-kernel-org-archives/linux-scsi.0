Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2498C46EC64
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 08:15:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790583338; cv=none; b=SIETaY6PB0dDnGWuvIfOj1aEZmVOQq0agCkKO7PdqOMTGFHR91G5DUkFoxe8/u+PLTQhjivO5cRMazyLYA96uniux+x5fdLlLrvC+hqmasdvi+BbSHHznyHXN+rj8Q8cWXZxWW7x8VN1W2rKPFBOU2xA9r5QTzFT47E+Vr+hpuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790583338; c=relaxed/simple;
	bh=uQECqvXnanLoxuHvJQObG0k9kfa68ujSBU700X/MWzs=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=jeZdwaCTraCye9XFhNZlrvut0pbu+Gf8QPVQ92TsmvikZ6k/0baUDBLYEF2H+WV9SABSGw3nrgcN9/OrbeMQK/QSrbQko8BCZ2ERNBnRb9i/ZVZ0QlUOJW7Ohxj9xNVjOSBn8xbHoqQmOekAtnfDDpXK4EzSOq0S5KY71gxkLCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BQjrQqYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BQjrQqYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450A01F00899;
	Mon, 28 Sep 2026 08:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790583335;
	bh=4IR0oi4ezcM8n5WnMX+uwF+cYIyb/2PdO33RnRw4GaY=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To;
	b=BQjrQqYEy+dM8A8eqP1JM+CWMAiq/VzAbzwPPLKCqzC4YvmlQr8c4Q5aKTFHvtjGn
	 tAlUUx5VpjMpGU7hAGXzTVEDgTl/l7LZiemNjhRlTe+XUIeMMFtLfBr4oQd4sESFm4
	 rN62rc7qExYqaZI5O7I4llCaOsPdn00bGbVoI3ogS8PigmhOCd0NGUoLU24gaI2XpY
	 VmjFNuIb4sGtZmUddkpOm9opZhwbNcpTH653RXID6GPkNdfAbJDQY/UsdsOd+JO9uR
	 nD89AFMygs36oNKQodNgUiKA7C/xSWY5jP8vE5iVS4z05YmXpXUgOgjsCghvInf8BP
	 mA7A0+285h53w==
Message-ID: <95bf768d-b28f-4259-b812-1e14d80abc0f@kernel.org>
Date: Mon, 28 Sep 2026 10:15:32 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a write
From: Damien Le Moal <dlemoal@kernel.org>
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 John Garry <john.garry@linux.dev>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
 <1dac66aa-a4e6-4c79-a914-d5d2699c392f@kernel.org> <aroT_W6PzdiUeUBd@ryzen>
 <ef31de9c-a138-42ea-943d-979ee3a64919@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ef31de9c-a138-42ea-943d-979ee3a64919@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/28 9:51, Damien Le Moal wrote:
> On 2026/09/28 9:15, Niklas Cassel wrote:
>> On Mon, Sep 28, 2026 at 08:45:30AM +0200, Damien Le Moal wrote:
>>> On 2026/09/27 7:26, Niklas Cassel wrote:
>>>> A write whose data buffer is larger than its transfer length leaves a
>>>> residual that the initiator is entitled to be told about. resp_read_dt0()
>>>> and resp_write_tape() report it, but the write paths for a disk do not,
>>>> so such a write completes with GOOD status and a residual of zero while
>>>> a READ of the same length into the same buffer reports it correctly.
>>>
>>> I am not convinced this is correct. resid (residual count) is supposed to
>>> indicate the amount of data that was *not* transferred. So if the buffer size is
>>> larger that the command cdb transfer count, all data can be transferred and
>>> resid should be 0. Which would mean that for this case, the write processing is
>>> correct but the read side is not.
>>>
>>> The SBC and SPC specs are very silent about this though, I do not think that the
>>> resid is actually standardized. And I do not see a clear definition for it in
>>> the documentation/code comments.
>>
>> The definition is in Documentation/scsi/scsi_mid_low_api.rst,
>> under resid_len: "an LLD should set this unsigned integer to the requested
>> transfer length (i.e. 'request_bufflen') less the number of bytes that are
>> actually transferred".
>>
>> Also in include/scsi/sg.h: "resid; /* [o] dxfer_len - actual_transferred */".
>>
>> Both measure it against the buffer, not the CDB.
>>
>> That is also what iSCSI reports: RFC 7143 11.4.5.1 measures the residual
>> against the Expected Data Transfer Length, which the initiator sets from the
>> buffer.
>>
>> And it is what scsi_debug has always done for reads, in fill_from_dev_buffer().
>> This patch just does the same for writes.
> 
> Hmm. OK. But then that really should be set automatically by the sd/st/sr
> drivers and sg driver. scsi_debug emulates a device, which does not give the
> residual. So scsi_debug has no business setting that command residual at all,
> for any command.

Please ignore this rambling. scsi_debug emulates a scsi host (i.e. an adapter)
with logical units (devices) attached to it. And it is perfectly fine for a host
driver to set the residual. Your patch is fine and I think I need more coffee :)


-- 
Damien Le Moal
Western Digital Research
