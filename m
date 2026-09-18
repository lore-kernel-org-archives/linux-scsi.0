Received: from mta0.migadu.com (out-68.mta0.migadu.com [91.218.175.68])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 329F44A64E6
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 08:19:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.68
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789719578; cv=none; b=ksn6H244DXuQUi/MkT6t3mbuHPuI85ITh5bcm63SSC/k6N9R8VgxoE70ON3Afj1y0DIemsx5WKJyIx9bm55NPOZ8dColBv/Q0SSHBP1AtNHfe7ksxAfzUsmK3qiWCXG86E2KuYv+pX3ioQtrQvJYo8QmG2unRikb8ZZ4wWw39WE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789719578; c=relaxed/simple;
	bh=ZyD+Bn02+vKwIiaP4CLwmNxroavZeli7Ll2GLUcHURw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dVaqxo5JZgp4AQq9IIWtqregBpHEebuVnuZG35XUPSO4d8J1OXyhjXucMnGXw+7ctafhpgqFkbX7g+2w9Co58QvNbDb/SCLhxo0b4+J8rcjZSdSl7i1u6dpzqxKy080FNt9Lb0IXRDrCDwZjqVrirspOiWoIyB38zNi2FFpOvnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=DQ9+1bz3; arc=none smtp.client-ip=91.218.175.68
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="DQ9+1bz3"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=ZyD+Bn02+vKwIiaP4CLwmNxroavZeli7Ll2GLUcHURw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789719571; v=1; x=1790324371;
 b=DQ9+1bz3p2wHP9DCza0xguJwsXpjStY6hfPtlLkji9r/jwdR/7E4MrBpbWRWB+YAA9EqSZJj
 HW1Gefl/GyInggK7G3AO514K2IPTXJUFGa5qU1l4TMCw5mTBhG9Nr2HsSpTMREqipuZfHq+YChT
 M9XHPPluwkuW0pyDzKdsizJM=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta11.migadu.com with ESMTPS id 3b41385f3795bd80;
	Fri, 18 Sep 2026 08:19:31 +0000
X-Mizu-Trace-ID: 3b41385f3795bd80
X-Migadu-Flow: FLOW_OUT
Message-ID: <84ad8a55-1bd1-415f-a60f-fc0c00a1a545@linux.dev>
Date: Fri, 18 Sep 2026 09:19:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 10/10] scsi: scsi_debug: Validate the access parameters
 of WRITE ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-22-cassel@kernel.org>
 <d9971f1c-6e8c-4e6b-889e-bb8d6449b451@linux.dev> <aqzuE6cV8TpVxJ5L@ryzen>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqzuE6cV8TpVxJ5L@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/18/26 08:53, Niklas Cassel wrote:
>>> Call check_device_access_params(). The zone checks that it ends with are
>>> unreachable, as atomic writes and ZBC emulation are mutually exclusive.
>> These are quite verbose commit messages ... LLM-generated, by chance?
> Yes, hence the Assisted-by tag just a few lines further down:

I didn't know which part was :)

> 
>>> Assisted-by: LLM
>>> Fixes: 84f3a3c01d70 ("scsi: scsi_debug: Atomic write support")
>>> Signed-off-by: Niklas Cassel<cassel@kernel.org>
> The commit message does point out two actual problems resulting from the
> missing check_device_access_params() call in resp_atomic_write() (which
> exists in all other resp_write_*() functions):
> 
> - Fails to repect the write protect module parameter, so resp_atomic_write()
>    fails to generate the proper sense data in this case.
> 
> - Fails to check if the command will write past that device capacity, so
>    resp_atomic_write() fails to generate the proper sense data in this case.
> 
> The generated sense data differs in the two cases.
> 
> I suppose we could drop:
> 
>    As a consequence a WRITE ATOMIC (16) past the end of the device is not
>    terminated with LOGICAL BLOCK ADDRESS OUT OF RANGE. do_device_access()
>    reduces the LBA modulo the size of the store, so the command writes
>    somewhere else on the medium instead. A WRITE ATOMIC (16) also writes to
>    a device whose wp module parameter is set, which every other write
>    refuses with DATA PROTECT.
> 
> 
>  From the commit message, as I suppose it might be a bit overly verbose to
> mention the exact sense data that each missing check would generate.
> If someone cares about that, they can just look at the mk_sense_buffer()
> calls in check_device_access_params().

I don't really care too much. I personally just find these LLM-generated 
commit messages laborious to read.

