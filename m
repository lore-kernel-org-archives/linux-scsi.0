Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 011FA32C89;
	Thu, 28 Mar 2024 06:18:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711606730; cv=none; b=N0KsE0qfHvcO4aOfQ+LrV1ZLUm/kLEid3FsZPqSCRBQFovvfSKvehDrXGcPqMh0GPO1RpuADe3iz1tGcPlCf2J8oY8iWibQ4ULjsVDIPLtxAVe47C43Y6bJOSQwpCXEr1brRM0Mq9BSL5v8o552XCZPGc8K/KqK24jHVqXV/6Xc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711606730; c=relaxed/simple;
	bh=DcdBFLi2iHg0JyIcbXViXY0Ox+JVcwfx/2i+vA44zSk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lCA+PRxBcd5H7QESyADif0jwm6ULAOKyqoV5jnIRuLvjE7w4dzASb/KXBDNaFGdMuhSJ3RWyAiGsXKn5aIpJxRuEmxui7pmtAUf6JR5A7rjIb+QoDSkPA6SlCuIajr17V1Dlup9VWp5dmhRT3/innzzMzBQPGSVks5af1Q7wYIY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=uQfFncZM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="uQfFncZM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07767C433C7;
	Thu, 28 Mar 2024 06:18:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711606729;
	bh=DcdBFLi2iHg0JyIcbXViXY0Ox+JVcwfx/2i+vA44zSk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=uQfFncZMpRUXNDgCJ4gvVf62eY58ZK1vc6bGvNFNUixRkzy02qkO+00yLb85NwgY7
	 ihfYvifCzJ1UfQGmYFT336ENiG82JegY5aEprU6YEkm8hYC86RGoUS1mzefV4rxUm+
	 7h+vFsZttY1fcdsdf/5mRAi07l+e/OcJwhdm8B5xrnDwmRitY4MeH40ztRURVFb7iO
	 SFh6NsU9KE41dwZDU6T4d4miG+jxUsA9hwnUNwJROPlmTPUHSdRwKmmhpNihptKOby
	 26Tzf5alRmJ50wZJOpta9g+XsQFe9uXrVPuUuB6TeB/W2yDmUTIGzEtlb22RPPJ3Hz
	 s9YJhw3LEMV6w==
Message-ID: <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
Date: Thu, 28 Mar 2024 15:18:46 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de>
 <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
 <20240328054652.GA16237@lst.de>
 <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
 <20240328060357.GA16819@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240328060357.GA16819@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 15:03, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:02:54PM +0900, Damien Le Moal wrote:
>> But that is the problem: "checking the zone number again" means referencing the
>> plug struct again from the lookup context while the last ref drop context is
>> freeing the plug. That race can be lost by the lookup context and lead to
>> referencing freed memory. So your solution would be OK for pre-allocated plugs
>> only.
> 
> Not if it is done in the Rcu critical section.
> 
>> For kmalloc-ed() plugs, we still need the rcu grace period for free. So we
>> can only optimize for the pre-allocated plugs...
> 
> Yes, bt it can use kfree_rcu which doesn't need the rcu_head in the
> zwplug.

Unfortunately, it does. kfree_rcu() is a 2 argument macro: address and rcu head
to use... The only thing we could drop from the plug struct is the gendisk pointer.

-- 
Damien Le Moal
Western Digital Research

