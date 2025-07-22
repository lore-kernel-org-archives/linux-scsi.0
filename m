Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF272DC33E;
	Tue, 22 Jul 2025 09:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753177219; cv=none; b=XX7B/4H9hoU/7xdiopIeaBxWM8/iWY6KerKPvMCHkzWV5dT6/BYjoZAIMCVy9jrLyPTX6ubAyWL5FbsSi7+BlTccpMeFjiiOcMr9ao8DtM2F/yRsJ3/4tgWurXawwYF50j4+5UD08aclzy0sxkmivnYLYlDTSTOyQiK8JVQHIWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753177219; c=relaxed/simple;
	bh=Nh4ME8UuH4zpUuzMLeAoqyTWMO2++nKd2192zum8wsY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZeZdsK9hYJGrs3U0SejUy61Nu/8iUiQnB3vkAYGScrAWf1WgKrst0QH0FgyXPOlwe1rGbDwadj/z3/ty05fPlQh0kFgdr+0bKzHVnue36I0eEPdQqcK4hH9r/kZ4tmUE0lMLeKo9vfotzHA+gyyFXGugpTYDNOVS5mvb4R13xXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KIAcz3lE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KIAcz3lE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E2CC4CEEB;
	Tue, 22 Jul 2025 09:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753177219;
	bh=Nh4ME8UuH4zpUuzMLeAoqyTWMO2++nKd2192zum8wsY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=KIAcz3lE5nemZH4gjTyc229OvqwGqg2p6DsrqIwz5+WE6AlmoEZ6B5sj5+52FlqS6
	 NzciI7ENdoRR6G4YrbtIYI/EMNi93Rx7xK52xT2UvH5JTaFeVV6igkPM2DqzZYe4gV
	 9kBUGm6PYqWLJCxRqb/GYsoteI0T/wZFqZ75VI1PPtD25m0bYwHw6EdwhnL0+cKA2q
	 ssWlPCS8HTiP4m0A3+rwv/m5agz4pCkJhynAb4ZDz+qicUG+EihM9y0bgX0OFa6G8x
	 DEEMauVWd/mwuncxOtIu2h1q1VQTgsUapmt7BR14b+nFyS0TYIteq1JFzKUBkRTy4K
	 rLEvwqn3GxY8w==
Message-ID: <75412b1b-3f39-4f6a-93ce-823c15a19bf3@kernel.org>
Date: Tue, 22 Jul 2025 18:37:50 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 08/19] scsi: detect support for command duration limits
To: Friedrich Weber <f.weber@proxmox.com>,
 Mira Limbeck <m.limbeck@proxmox.com>, Niklas Cassel <nks@flawful.org>,
 Jens Axboe <axboe@kernel.dk>, "Martin K. Petersen"
 <martin.petersen@oracle.com>, "James E.J. Bottomley" <jejb@linux.ibm.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 megaraidlinux.pdl@broadcom.com, mpi3mr-linuxdrv.pdl@broadcom.com
Cc: Bart Van Assche <bvanassche@acm.org>, Christoph Hellwig <hch@lst.de>,
 Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
 linux-ide@vger.kernel.org, linux-block@vger.kernel.org,
 Niklas Cassel <niklas.cassel@wdc.com>
References: <20230511011356.227789-1-nks@flawful.org>
 <20230511011356.227789-9-nks@flawful.org>
 <3dee186c-285e-4c1c-b879-6445eb2f3edf@proxmox.com>
 <6fb8499a-b5bc-4d41-bf37-32ebdea43e9a@kernel.org>
 <2e7d6a7e-4a82-4da5-ab39-267a7400ca49@proxmox.com>
 <b1d9e928-a7f3-4555-9c0a-5b83ba87a698@kernel.org>
 <a927b51b-1b34-4d4f-9447-d8c559127707@proxmox.com>
 <54e0a717-e9fc-4534-bc27-8bc1ee745048@kernel.org>
 <72bf0fd7-f646-46f7-a2aa-ef815dbfa4e2@proxmox.com>
 <3b2a6cfe-5bf3-4818-8633-c200d8e6f122@kernel.org>
 <4cb58e56-d9e2-4868-84ad-8b7253148228@proxmox.com>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <4cb58e56-d9e2-4868-84ad-8b7253148228@proxmox.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/22/25 6:32 PM, Friedrich Weber wrote:
> On 14/07/2025 04:48, Damien Le Moal wrote:
>> On 7/10/25 5:41 PM, Friedrich Weber wrote:
>>> Thanks for looking into this, it is definitely a strange problem.
>>>
>>> Considering these drives don't support CDL anyway: Do you think it would
>>> be possible to provide an "escape hatch" to disable only the CDL checks
>>> (a module parameter?) so hotplug can work for the user again for their
>>> device? If I see correctly, disabling just the CDL checks is not
>>> possible (without recompiling the kernel) -- scsi_mod.dev_flags can be
>>> used to disable RSOC, but I guess that has other unintended consequences
>>> too, so a more "targeted" escape hatch would be nice.
>>
>> Could you test the attached patch ? That should solve the issue.
>>
> 
> Thanks for the patch! The user tested it on top of a 6.15.6 kernel and
> with the SAS3008 HBA, and indeed:
> 
> - under 6.15.6, hotplug fails with the log messages mentioned in my
> first message,
> - with your patch on top, hotplug works again.

OK. Will post a proper patch then (tomorrow).
Thanks for testing.


-- 
Damien Le Moal
Western Digital Research
