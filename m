Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EAE646C4B0
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 07:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790581883; cv=none; b=EfA1ixiJGVUmkI01C9/c2/ytmqUb/1wDRzQIkWZliCwK5I6PF27rn8BRiyAyL0E5dcnz7I3Za+pDnnWhodT0/6OYpBnPSOEQQ0xuXTlh7xD5xS3xDghJoGzH7Zq9GrzmKvHzZ1/W5fd7IxCKVvE2Fd4qY7dQ7EN6XYCjXB9KgtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790581883; c=relaxed/simple;
	bh=AKOMnUyjYtiq9vIFDyMKx8o9FWhF3dGE5QJf+5QT9GY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VHNTn6B18S+C88498NBH9teNS93xFSBO/I0PrR27XptS8qK5K/moVWGGnLQAWPmo4+dItMTxAZ3IQFlD6fcZob0ERq4aVJqYHmnCXCzIHc6xrVkBaQefvOhBK45CV0gMsc3aIMHnktXqoIHmn7CU6ZFRX80BlFtkkuRWkWvchGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cfczyd7Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cfczyd7Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFED21F000FF;
	Mon, 28 Sep 2026 07:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790581881;
	bh=1jFDf6c/MQGMThCwHDxCeb9z/dgE/+dkqTIccZ6uT6I=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cfczyd7YybfBQWdlLcWnX7ygIU0ulVXQikNaO621srXphfw5PVpiS5Qs8Jo6sMSPN
	 3zgjW8FjQ8Rq6lf7gXgFaSzVs4jURD469zX/vECgA4nIF33sQZxIHLxeuXFWFuAFPQ
	 FsjMEkgnrhnsoSHQ65+M5Xj81vv5FF929J6ijpCpzTKtYohR92FNrW3H9TYkrXDnjX
	 yp4Fmxn22Gboxpb3sYkh4eKKKS26lm65x+GEC/w0JcqZzEiyDTFXqtbrft+avwp0IP
	 PZf/+yOsTPFkUzulZvIYEnuLFQQR39jEibdE80vihMXJ9ezrKt/iQ8lsgazOJgXWow
	 gpJjt2Qw207Tw==
Message-ID: <ef31de9c-a138-42ea-943d-979ee3a64919@kernel.org>
Date: Mon, 28 Sep 2026 09:51:19 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 05/11] scsi: scsi_debug: Report the residual of a write
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 John Garry <john.garry@linux.dev>
References: <20260927052650.567035-13-cassel@kernel.org>
 <20260927052650.567035-18-cassel@kernel.org>
 <1dac66aa-a4e6-4c79-a914-d5d2699c392f@kernel.org> <aroT_W6PzdiUeUBd@ryzen>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <aroT_W6PzdiUeUBd@ryzen>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/28 9:15, Niklas Cassel wrote:
> On Mon, Sep 28, 2026 at 08:45:30AM +0200, Damien Le Moal wrote:
>> On 2026/09/27 7:26, Niklas Cassel wrote:
>>> A write whose data buffer is larger than its transfer length leaves a
>>> residual that the initiator is entitled to be told about. resp_read_dt0()
>>> and resp_write_tape() report it, but the write paths for a disk do not,
>>> so such a write completes with GOOD status and a residual of zero while
>>> a READ of the same length into the same buffer reports it correctly.
>>
>> I am not convinced this is correct. resid (residual count) is supposed to
>> indicate the amount of data that was *not* transferred. So if the buffer size is
>> larger that the command cdb transfer count, all data can be transferred and
>> resid should be 0. Which would mean that for this case, the write processing is
>> correct but the read side is not.
>>
>> The SBC and SPC specs are very silent about this though, I do not think that the
>> resid is actually standardized. And I do not see a clear definition for it in
>> the documentation/code comments.
> 
> The definition is in Documentation/scsi/scsi_mid_low_api.rst,
> under resid_len: "an LLD should set this unsigned integer to the requested
> transfer length (i.e. 'request_bufflen') less the number of bytes that are
> actually transferred".
> 
> Also in include/scsi/sg.h: "resid; /* [o] dxfer_len - actual_transferred */".
> 
> Both measure it against the buffer, not the CDB.
> 
> That is also what iSCSI reports: RFC 7143 11.4.5.1 measures the residual
> against the Expected Data Transfer Length, which the initiator sets from the
> buffer.
> 
> And it is what scsi_debug has always done for reads, in fill_from_dev_buffer().
> This patch just does the same for writes.

Hmm. OK. But then that really should be set automatically by the sd/st/sr
drivers and sg driver. scsi_debug emulates a device, which does not give the
residual. So scsi_debug has no business setting that command residual at all,
for any command.

> 
> 
> Let me clarify the commit message in v10 to actually reference
> Documentation/scsi/scsi_mid_low_api.rst.
> 
> 
> Kind regards,
> Niklas


-- 
Damien Le Moal
Western Digital Research
