Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABE25473C;
	Mon,  6 Jan 2025 01:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736127056; cv=none; b=XMuz6QHOxHhPJpZlEUSMZ46srdRm5PY8o4S9yxsCax4fRPm0AIJnIKQsB+OV8ab66ij3U4POQWdIr69L5pD9gJeja/V8vKDLNlNnX7BIXImk3MBbgYcLYDKDXXR3Uy3jvW/hrZuwW5/4uWEuAdnm3sndNATf16hNoxP/y90AFnI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736127056; c=relaxed/simple;
	bh=BIbWI+1u8bELhggh3Fq4iD4hAlrRcc0Moppw2wrlcKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GMbz0VfSvmWGSNB+P5TXW5OKyhNTwZHHaYIYbAepDcJloNcyo2keMzKsNoEr5ZdcWWnB48Cd/K9g4S9NB1LXNcdPyaNAKjdTUy9miZk73JV8qIUp7DPMbsYnSSLckPrdw6FXzLbn/IdPYNocjr0XRf/MHakn3edwCkt6vxzs0ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nK11cOG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nK11cOG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D25C7C4CED0;
	Mon,  6 Jan 2025 01:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736127055;
	bh=BIbWI+1u8bELhggh3Fq4iD4hAlrRcc0Moppw2wrlcKY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nK11cOG4sSQ94mr3e+9pLynrt2puWZxSai75yFBblIB3WOdv6KPeBDpJfXo556ElO
	 3XDz3xzvN6/ZOcpmtHJSDr4ZtlhZem7FZ8hf4ZeArLFeErtHQtpPyV2A+c7EAyIX2c
	 CCqW2NG/nLy+sjqqjBI5oj1zweV0BtVBB+JXcpICR02WyH0OsoXw40Uqfi3MvfJvre
	 kTzatCPYV+gYs2vMOH9diRVE64Mzj+HHBoH3tgqAss2Chcwj7TsQlkXePIXgmoVufB
	 8a+edr/0giMg9DvkUaN+OtPUnz8q1qDeWqAh0WPiTh8oAOKJWtZrQTqpo1jZW/Hlj6
	 fPePpLdc2D4sA==
Message-ID: <1231beed-7c85-4c72-970c-a0f9d155f99d@kernel.org>
Date: Mon, 6 Jan 2025 10:30:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: avoid to send scsi command with ->queue_limits lock
 held
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>, Nilay Shroff <nilay@linux.ibm.com>
References: <20241231042241.171227-1-ming.lei@redhat.com>
 <770947cc-6ce9-4ef0-8577-6966c7b8d555@kernel.org> <Z3srsii5EhZmnU9D@fedora>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <Z3srsii5EhZmnU9D@fedora>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/6/25 10:02 AM, Ming Lei wrote:
> On Sat, Jan 04, 2025 at 04:17:47PM +0900, Damien Le Moal wrote:
>> On 12/31/24 13:22, Ming Lei wrote:
>>> Block request queue is often frozen before acquiring the queue
>>> ->limits_lock.
>>
>> "often" is rather vague. What cases are we talking about here beside the block
>> layer sysfs ->store() operations ? Fixing these is easy and does not need this
>> change.
> 
> Is it really necessary to make freeze lock to depend on ->limits_lock?

Yes, because you do not want to have requests in-flight when applying new limits.

> 
> sd_revalidate_disk() is really one special case, so I think this patch
> does correct thing.
> 
>>
>> Furthermore, this change almost feels like a layering violation as it replicates
>> most of the queue limits structure inside sd. This introducing a strong
>> dependency to the block layer internals which we should avoid.
> 
> No.
> 
> block layer is common library, which is storage abstraction, so it is
> pretty reasonable for storage drivers to depend block layer. You can
> look at it from another way, if any related queue limits change, the
> current storage driver need corresponding change too, with or without
> this change.

Of course block device driver layers like SCSI depend on the block layer. But
that dependency is at a high level API/function level. My concern is that your
patch mimics too much the block layer implementation internals instead of
relying on a high level API like we do now.

-- 
Damien Le Moal
Western Digital Research
