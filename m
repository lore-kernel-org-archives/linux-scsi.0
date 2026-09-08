Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDF61D86FF;
	Tue,  8 Sep 2026 00:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788827543; cv=none; b=jpqr1WeU6zllp8XckFcfqFVC2kUBjgkDdgRsMWxhiwUsM+BCJg9KSgAWpgDUAHBdR6YA10r/Rv6WdZHr+sP2pXybLKmcoZ7g31BZxEa8cLTAifWtmZ3HzA3CPYhqGVPSENm62JT3IMqZ3M3Cj87uqLBXHwnjDJUXw/pVLZaZAfA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788827543; c=relaxed/simple;
	bh=SgLBHpeYx96TBMWawXhkUXnL9XZmAcnqcfCDrNNhirk=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=eEE2bC1gi1iFcOMVXKNwjM5uXFgw+SVRnGSjNpamBILw03LK9PRcPvObW0vsuW4dQ0uw+kLICU0gP+XT9dWs2HvwoFOQHUuSK9AvOdUcMWy2My6drcOEkr2OLa3lFNviMBi92nDvv8gtotdfk44P0F6ADAAsKQCnXvnitlC3jnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Fq3qcWd9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Fq3qcWd9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49B4A1F00A3A;
	Tue,  8 Sep 2026 00:32:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788827541;
	bh=DCTW8mWT/1n1EavcifwQLUMz/p2cv9F1O2f8Z9E2G6E=;
	h=Date:Subject:To:References:From:In-Reply-To;
	b=Fq3qcWd9jnfA4BeoMs0hwDzxfRO9oE17+IsFOJE92abCwgYb9hWfMT5pSTsvhqmFs
	 Of1C2/a/cEfxNd/5Ze8NkjsgcUk91eBYlXBl7CZ/gOiH4RVDxmRgVg3gK84N83MFc5
	 TlYwMESGPBNZugMJJiXZCLKaKC1inltafL+KLAR3lklSxOjM8LOZ+PReuNSRrUM1Ld
	 jShn5j2xaDTPvI0aRPp3HU2gjCmNarbMxWr86OgvMPxb0gednRjMbHM+Pf+fJUHSQK
	 34gSvTRnkwnyeMOT431kE2ANbY/RNlHjTC3V8hWOO389RbszvRCtDqJmbf0W+0A/zs
	 dL1UPQsvhY5Uw==
Message-ID: <0286eace-11b2-4513-9ad2-a919d9927783@kernel.org>
Date: Tue, 8 Sep 2026 09:32:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 07/40] scsi: core: use 16-bits defined sense codes
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
 Niklas Cassel <cassel@kernel.org>, linux-usb@vger.kernel.org,
 Alan Stern <stern@rowland.harvard.edu>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-s390@vger.kernel.org,
 Heiko Carstens <hca@linux.ibm.com>
References: <20260907024343.1046387-1-dlemoal@kernel.org>
 <20260907024343.1046387-8-dlemoal@kernel.org>
 <83caa7a0-27bc-4b10-8578-ed7afbd36030@acm.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <83caa7a0-27bc-4b10-8578-ed7afbd36030@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/8/26 05:03, Bart Van Assche wrote:
> On 9/6/26 7:43 PM, Damien Le Moal wrote:
>> No functional change intended, with the exception of a correction of the
>> array any_sense_failure_defs in scsi_lib_test_any_sense() which
>> erroenously sets result to SCMD_FAILURE_RESULT_ANY instead of
>> SAM_STAT_CHECK_CONDITION and does not sets sense_key to
>> SCMD_FAILURE_SENSE_KEY_ANY.
> Is this perhaps a fix for patch 4 that should be squashed into patch 4?

Not really. Patch 4 only does renaming, so I did not fix this there.
I did the correction here, but that could go either way, or I can add another
patch just for this, but that seems overkill since the problem never actually
causes any issue since the mistake makes that particular test pass all the time.



-- 
Damien Le Moal
Western Digital Research
