Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDB0245019;
	Sun, 21 Dec 2025 10:00:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766311209; cv=none; b=NfYUPI1xTeCXFbY/3fJR71lSITmpY5sZBYOzE347J7msZnsBOJFfa91dFflGO72p4iPs6EHKfGmLA7GAbSRoBiRKqDkHF7RxfQWFjirqBfPL475A6of8U/E8aMfCR160zlruXgzI6v9jQoyuK8kRd1Zk3QBY8tG6DGE/Zaam1fA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766311209; c=relaxed/simple;
	bh=3gkq5R8z5oqeJXoC7e2rNhnROWWBbksf0tpbhMKwobo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OLOsNofo+SkxkJvD14to3Yp4Otx0S/cW/9MrNTyi7AZUH+vw5fVv405FBww55KHGknSfk/xbBr4utXcs2ez//TxU182A53QwzALURDZ65n/4yBVBqVMbzxsCTky2tM/9vvK6g6Str9jL3JuAw0NdJNHTNnHtYi2L2cRcs7omKcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Exv+EqVx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Exv+EqVx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73EB2C4CEFB;
	Sun, 21 Dec 2025 10:00:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766311206;
	bh=3gkq5R8z5oqeJXoC7e2rNhnROWWBbksf0tpbhMKwobo=;
	h=Date:Reply-To:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Exv+EqVx2rDGF2EWxiky66c9on/9JhxghL4N0zd+x6cbJWyN9ay3Y0IULgc4IMP53
	 1tCG/3Dfu3jCX2neh91Y3KmHGREr3/fft/G9/w6ZTtVROeANOma9JUr4EIZappKZN1
	 eQiuJKXywE8b4X+UM8/cWlKI/MFsmbbRDiHEy569Br7rNvuWlZrndJKOJEecmQ6OlG
	 MVoNyLZuGpTKhTK2SQsYcQTdb3E2jjmN3mj8pqJzdgK+0xU439tDfPRvOES5jqzXcT
	 M+rYXst/IwxNNSR1n2oceQyqYdoxGwVlGvEoVqTKoC1D2E1CNXgHCE8aI+kp3oP5ZE
	 RQIhEt2OJ3kwg==
Message-ID: <9817dbc0-0bb6-4e31-8413-c54b12ce952b@kernel.org>
Date: Sun, 21 Dec 2025 11:00:00 +0100
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
 <799f5069-36a1-4be7-8ee3-acb3a6cd44a2@kernel.org>
 <6be5a2cfdeb6af71f6bd676e71418393d78e93e0.camel@HansenPartnership.com>
Content-Language: en-US
From: Daniel Gomez <da.gomez@kernel.org>
Organization: kernel.org
In-Reply-To: <6be5a2cfdeb6af71f6bd676e71418393d78e93e0.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 21/12/2025 05.02, James Bottomley wrote:
> On Sun, 2025-12-21 at 04:30 +0100, Daniel Gomez wrote:
>> On 20/12/2025 05.27, James Bottomley wrote:
>>> On Sat, 2025-12-20 at 04:37 +0100, Daniel Gomez wrote:
> None of that answers the why question:  Given that EEXIST is used all
> over the kernel, for what appear to be fairly legitimate cases, why
> would we suddenly want it to become only for modules?  I get that we
> can, as you propose patches above, but why should we bother?  It seems
> to be a useful error code outside the module use case, so why the need
> to restrict it to being only for modules?

Because both the module loader and module_init() return through the same
(f)init_module() syscall path, we need to ensure consistency in what we report
back to userspace. The init_module(2) man page documents EEXIST as "a module
with this name is already loaded." When module_init() returns EEXIST for
a different reason, userspace tools following the documented behavior will
misinterpret it. We can't use the same error code for different meanings and
expect the caller to differentiate.
