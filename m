Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C2A8224FA;
	Sun, 21 Dec 2025 03:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766287824; cv=none; b=nG0/izbMiJhPLAwuHPAGgkun+qEb/tXuNY+pSkzr9gLLWP9fWilt63TEW2q+EnDqbaCzLDGkjKjsXusGwR9n7AYT17ZY8kkI7SJRs8ha4LFO+iP8FrqgKApWH1bgx9v3CjhDnaAlBRtjbfwvIcWUbVrDTfZ3pxAMxYXENAbGBkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766287824; c=relaxed/simple;
	bh=213ARG2iDcjOtUajVDIH2Laug91k64/zHImj8Q3fSYo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=a9Ij6LaRjeOaZRBahoITcUptisejzrTeGiTNUcuq7yICXaT3jnl4Sq1UCcnkhvBE4feEXX4ID4/7ikv5axvwVcLRQsCNUqFVyw+dpPoUmQ6YyrDxrfB4A9YP8aXg/lRZCPTO7CGs6TheKI0X0u9U2XgWwXZMCjVKEUAocr9RD+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U5IsKXTH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U5IsKXTH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D0ECC113D0;
	Sun, 21 Dec 2025 03:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766287824;
	bh=213ARG2iDcjOtUajVDIH2Laug91k64/zHImj8Q3fSYo=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=U5IsKXTHqSsGJi3HgpPiB6AlfQZn0uS6xiSm5SxCZ5NMM6NZBQlTfe9b+IYr4TN+o
	 8Sn3L+7tZQ6EoR44jWELMP04HZgQtkDDtdNA0gB5Y3Jo5BM45tiQTvaTeJHTJg41Qr
	 1LLqP2yMC/DZt+OgAzs0SI/Ln5QbCGFnvLlacdqMCL4vRjk17KCvAbndst55x1MpaZ
	 wnh3eSNNRDmjQvEOnCpeRq7V5jJj3ypQJFvjMyABolRWqrNyqe9GuQlDwlkKId34Th
	 7IdFGmYiCSFj4fk2oriLgaCWH7cdQEsbFZtIeKbAhC2cNEr80xRMzHOQU62RX0DWAP
	 h/WxYroDRk6TA==
Message-ID: <799f5069-36a1-4be7-8ee3-acb3a6cd44a2@kernel.org>
Date: Sun, 21 Dec 2025 04:30:19 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: Daniel Gomez <da.gomez@kernel.org>
Subject: Re: [PATCH 0/2] scsi: target+fcoe: replace -EEXIST with -EBUSY in
 module_init() paths
To: James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Hannes Reinecke <hare@suse.de>
Cc: Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Sami Tolvanen <samitolvanen@google.com>, Aaron Tomlin <atomlin@atomlin.com>,
 Lucas De Marchi <demarchi@kernel.org>, linux-scsi@vger.kernel.org,
 target-devel@vger.kernel.org, linux-modules@vger.kernel.org,
 linux-kernel@vger.kernel.org, Daniel Gomez <da.gomez@samsung.com>
References: <20251220-dev-module-init-eexists-linux-scsi-v1-0-5379db749d54@samsung.com>
 <b1e372cacf08a758e06ce7504c6cfaf7778bc6f3.camel@HansenPartnership.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <b1e372cacf08a758e06ce7504c6cfaf7778bc6f3.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 20/12/2025 05.27, James Bottomley wrote:
> On Sat, 2025-12-20 at 04:37 +0100, Daniel Gomez wrote:
>> The error code -EEXIST is reserved by the kernel module loader to
>> indicate that a module with the same name is already loaded. When a
>> module's init function returns -EEXIST, kmod interprets this as
>> "module already loaded" and reports success instead of failure [1].
> 
> That reference doesn't sufficiently explain why this error code should
> be unique to modules.

It's unique only to the module initialization. You can find how it's used in the
kernel module code at module_patient_check_exists() in kernel/module/main.c [1].

In addition, init_module(2) man pages indicates this:

man 2 init_module | grep EEXIST
       EEXIST A module with this name is already loaded.

So, a module that is already loaded will be detected by the kernel module loader
and the EEXIST error will be returned. This will be detected by kmod as success
[2]. I think this functionality was added very early on in kmod by commit
5f35147 "libkmod-module: probe: add flag to stop loading on already loaded" [3].
Prior to that, module-init-tools had the same behavior [4]. Even in modutils
[5], we had back then in insmod/insmod.c:2088:

		case EEXIST:
			if (dolock) {
				/*
				 * Assume that we were just invoked
				 * simultaneous with another insmod
				 * and return success.
				 */
				exit_status = 0;
				goto out;
			}
			error("a module named %s already exists", m_name);
			goto out;

Link: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/module/main.c?h=v6.19-rc1#n3206 [1]
Link: https://github.com/kmod-project/kmod/blob/v34.2/libkmod/libkmod-module.c#L1088 [2]
Link: https://github.com/kmod-project/kmod/commit/5f3514731ef82084c1a24b15445e0f1352681a19 [3]
Link: https://git.kernel.org/pub/scm/utils/kernel/module-init-tools/module-init-tools.git/tree/modprobe.c#n1797 [4]
Link: https://cdn.kernel.org/pub/linux/utils/kernel/modutils/v2.4/modutils-2.4.27.tar.gz [5]

> EEXIST is used all over the kernel to indicate
> that something being attempted has already happened or does already
> exist and that seems perfectly logical .... please explain why you're

That is correct but not all are conflicts within the
module_init()/init_module(2) path. I have detected 40+ cases where this error
is returned and another 20+ where error is returned but in upper layers of
the module itself, not propagated back to userspace. So far, I've only sent just
a few + docs:

https://lore.kernel.org/all/20251220-dev-module-init-eexists-dm-devel-v1-1-90ed00444ea0@samsung.com 
https://lore.kernel.org/all/20251220-dev-module-init-eexists-keyring-v1-1-a2f23248c300@samsung.com
https://lore.kernel.org/all/20251220-dev-module-init-eexists-linux-acpi-v1-1-af59b1a0e217@samsung.com
https://lore.kernel.org/all/20251218-dev-module-init-eexists-modules-docs-v1-0-361569aa782a@samsung.com

> trying to push it back to being a single use case for modules alone.
> 
> Regards,
> 
> James
> 
> 
> 
