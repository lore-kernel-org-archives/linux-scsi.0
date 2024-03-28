Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EBD1241E1;
	Thu, 28 Mar 2024 06:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711605777; cv=none; b=El4E1LIyiQDY/QtVYmKjepIvQgBPy/jM36kw+Nixd8bkQkqPb5z7dR1akmtPZMc4i3aqMaH+pgyb/xJvCn79h8QoSpenN4yZGT1Xn17LGoU+Ysic0vv//HxuZz3uYeegr+s/wHm1P2tErcSjnqgJ7wPHm1XgpmTFfQV00ldxd0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711605777; c=relaxed/simple;
	bh=xf7kJzpeIm6RcIL/MDwpH6pOPcv0ZcyQXGWenvh9/gQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iQS05jU8P8uptPbCXGzcWoYcQZ4saAcDhwuvOEuG0r9tZ6apwlcmfbvpRrkHIjlLjoIvcryX8z6a52/a0lN9q/5QPR/FdOK/2gql7jovDVA7rFbgVUe8CxLxCzonQXEA4NVoMNR4gh/lAjUEDNR8wiGWjW2qOVbP7Mu/Agl5LnQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EzCaLu8L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EzCaLu8L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8232AC433F1;
	Thu, 28 Mar 2024 06:02:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711605776;
	bh=xf7kJzpeIm6RcIL/MDwpH6pOPcv0ZcyQXGWenvh9/gQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=EzCaLu8Lf2JkTeziR6DDJy0IexFP5KRtpIE1EZbBCPbqHXE3sAaq9JTh++pc+CGF7
	 dB8zL8+s6h/sM1j5U1u5hZ+X723x/gax8GBAbZ3zKevsoqobe8imoNef97yIh5Xlti
	 oLPMy4TJl9DpCdK959syCd9RsBhFRhy7s1DKBo6CBzFFY0mtXTF2QSWHjPJOH5yDzu
	 SwL4GdZc+oj2AjweuFTaGEVpjRH5wIyFUMdWL/F0LXPgXuB2t55+77XEeEhvlfph4Q
	 TED88fWEHIly4kme/2VmXT1WctvbmmUHodo5KmExtObyw1Mx7n8jB9R5xrLfzFKEHN
	 +TSptpRMkbyoA==
Message-ID: <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
Date: Thu, 28 Mar 2024 15:02:54 +0900
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
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240328054652.GA16237@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 14:46, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 02:28:40PM +0900, Damien Le Moal wrote:
>> That was my thinking initially as well, which is why I did not have the
>> grace period. However, getting a reference on a plug is a not done under
>> disk->zone_wplugs_lock and is thus racy, albeit with a super tiny time
>> window: the hash table lookup may "see" a plug that has already been
>> removed and has a refcount dropped to 0 already. The use of
>> atomic_inc_not_zero() prevents us from trying to keep using that stale
>> plug, but we *are* referencing it. So without the grace period, I think
>> there is a risk (again, super tiny window) that we start reusing the
>> plug, or kfree it while atomic_inc_not_zero() is executing...
>> I am overthinking this ?
> 
> Well.  All the lookups fail (or should fail) when BLK_ZONE_WPLUG_UNHASHED
> is set, probably even before even trying to grab a reference.  So all> the lookups for a zone that is beeing torn down will fail.  Now once
> the actual final reference is dropped, we'll now need to clear
> BLK_ZONE_WPLUG_UNHASHED and lookup can happe again.  We'd have a race
> window there, but I guess we can plug it by checking for the right
> zone number?  If we it while it already got reduce that'll still fail
> the lookup.

But that is the problem: "checking the zone number again" means referencing the
plug struct again from the lookup context while the last ref drop context is
freeing the plug. That race can be lost by the lookup context and lead to
referencing freed memory. So your solution would be OK for pre-allocated plugs
only. For kmalloc-ed() plugs, we still need the rcu grace period for free. So we
can only optimize for the pre-allocated plugs...

-- 
Damien Le Moal
Western Digital Research

