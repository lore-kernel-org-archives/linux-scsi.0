Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E8291D0B8B
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 23:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728431470; cv=none; b=uFG6+cPUCTrEA5jvQw6Ork5WYJs0LAucS4kz4Z/nmTx6g9QgwvJ9r3/XTXgTN1kbQAqtjoZrMfHAVpg85zAlS713OJScAhbBoYBgmQYSBPX1jodps4KZy0MWQKuzvpf5Hd4dYtlwTN45hHVajO2bWW6xa7mH5D7wTxsq01hZKWQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728431470; c=relaxed/simple;
	bh=gNObwegqbdfQPg6bLDmkLUGIRbczUt+PWhYJYR8um6U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kfeI72FPws0lf/7QZsNKOfztu2fl/M5wQObcoU1wqLv3ZVPgXm1oc/MvCDLuZ7LX5etzz1YTy5DgdsCFGwF/8uYbsNVZ48nXoXr5z/6+t0QwmP7WvM7F7yOWkLDzUzC+nZQXtTc5PXJZHnCZWbCLjCZSKzX22sM52408jDA+u/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C43LSt9P; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C43LSt9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FD09C4CEC7;
	Tue,  8 Oct 2024 23:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1728431470;
	bh=gNObwegqbdfQPg6bLDmkLUGIRbczUt+PWhYJYR8um6U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=C43LSt9PzXPsCz+/5P6p2NBph4cAXPWx9dnkRdI1zuHIl/Dezfm6dSkXBdQsazyl7
	 y7oBBrtlzIP5Jbo+UuPSpDBV5wZYJ8lDP+Qe/WLdRoAHhBcXWNGMtvXbbML8CYrPgi
	 +P6rqeDUvWGmEZvNdne6TNX3tVgAXJ5p7T8ojw7qY5SK4BeWjRjHnxVfIkzjuolcuE
	 4XWjaoqm/QX7UE8M0oYKZjioEUElR1oFOIp0+SR3ihjt0WxuKR0cM1sDqhLZTRYciv
	 W7mw3xM8825VqKI5XZ6cWiwWjzHAogNAVs1rIQb/Pd81w1Z8IgmQSq34+UJf9138LV
	 GKhwCReIRmWdQ==
Message-ID: <65d71369-aed3-4ffa-837b-b845fcf94e2b@kernel.org>
Date: Wed, 9 Oct 2024 08:51:08 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Randy Dunlap <rdunlap@infradead.org>, Bart Van Assche
 <bvanassche@acm.org>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
 <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
 <a07e83ae-bec7-4738-8c79-328492dbce79@acm.org>
 <ac20fa78-4837-49ed-90c2-49bc3cde9b47@infradead.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <ac20fa78-4837-49ed-90c2-49bc3cde9b47@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/24 08:26, Randy Dunlap wrote:
> 
> 
> On 10/8/24 4:05 PM, Bart Van Assche wrote:
>> On 10/8/24 4:00 PM, Randy Dunlap wrote:
>>> It sure would be nice to know what changed between v2 and v3 of your patches
>>> (or vN .. vN+1 any time).
>>
>> Hi Randy,
>>
>> The changelog is available in the cover letter:
>> https://lore.kernel.org/linux-scsi/20241008205139.3743722-1-bvanassche@acm.org/
> 
> Oh, I see. Thanks.
> I didn't receive that email...

I did not either.

Bart,

Please always send the full series of patches, including the cover letter for
context.

-- 
Damien Le Moal
Western Digital Research
