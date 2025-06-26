Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 075A21DFE1;
	Thu, 26 Jun 2025 00:04:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896280; cv=none; b=BpH1+kfOn1il+87bPXwPcJfO5S2KjRhM5THU4fqjJY7v5EufRjscycpvRrUZsBdUu3xVfIyOl8RwRSFZ3DYaKxCQJ8/u78vjOYO/h8yhvzCDzngmTfurjZYtz1DFD06sf5m01xHPiUL8p3qtDjcT8aEUF+YMfbCKVsclA+8pzmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896280; c=relaxed/simple;
	bh=pfkjihzQhZFbd+FYR5ZoD9ohMKCD/qpTL0FxZeVgk4Y=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MwQXe5QPnkdEpnyKT/M80j4JCe8gqWcyD7xlSxiKeoRK/+jku4z4kQhTYabVTtgMCKenD3l4MjDbb6SppI58xIpdV1t41qdGIE59/e4zO+0qAGYMRduZS2FzQc8nmIcLdRSjlAsWXh1h673odJ11kn7VlSkWmTQ3IMMW8DQ9UVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fdU+F+3d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fdU+F+3d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37CA2C4CEEA;
	Thu, 26 Jun 2025 00:04:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750896279;
	bh=pfkjihzQhZFbd+FYR5ZoD9ohMKCD/qpTL0FxZeVgk4Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fdU+F+3dY+vc6QK2TL4xy+ZkWuI0DYYK21uacgx21JGpECF5frJFldgnLEFex5ZOr
	 /3M628V6Gn0C2jHX9grgP3mmO17MzV6cZ1zd4iIFCfIHCBYqYYcrlfs0bAIzIZjyBZ
	 tZztF7VsCi7HgCHKA63Yka5UhFo7WYeSPVpAG0ux8RGa+buCuSF455DygiF5+x1lha
	 PQF/yGV6N0+3HMjz1HKuyJsLY7gy8KTGHEr7NmLoOq3b2oRBAKdNODV7F1KuHFvoIM
	 9eF79ipNx0gfTnfVkbF6qQ3FuYyfRKfHxgkPgiIfuVQlVsQ0A46edDkqkjMJbVUfb9
	 pc+cPzSSQXelw==
Message-ID: <c22a7c1e-8d57-4d71-895b-fc2913404f0f@kernel.org>
Date: Thu, 26 Jun 2025 09:04:38 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 03/12] block: Support allocating from a specific
 software queue
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-4-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250616223312.1607638-4-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 07:33, Bart Van Assche wrote:
> A later patch will preserve the order of pipelined zoned writes by
> submitting all zoned writes per zone to the same software queue as
> previously submitted zoned writes. Hence support allocating a request
> from a specific software queue.

Why is this needed ? All you need to do is schedule the zone write plug BIO work
on a specific CPU. Then the request used will naturally come from the software
queue of that CPU, no ? Am I missing something ?


-- 
Damien Le Moal
Western Digital Research
