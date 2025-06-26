Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03D0F5C96;
	Thu, 26 Jun 2025 00:15:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750896913; cv=none; b=Tc2KD5Sqh+97FhwDo6tSvMzyxYkV9WHkF5+YX+jkl/PkmnP2ZovlC2Ucqxt6jSgFkqBwTySY1hYnl47/AKVYIGdeCJeyH7L1PC73JdpIDqBP6OonFQpsLLZrqkKDcsBB1KCX7/eF6KW106cKCn2qKw8C4Vwc21rz1WJYUJh4W30=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750896913; c=relaxed/simple;
	bh=I9O5STmyKmax2NYFHWAQYzdQJXZONsWgI3b6zcEkMGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=V6wddtSWfSE36UNl44Dc8hkCXCdS+867Wt6Xm/XZhuOmjbj749sbBLAvEhnA7xCwSgF9ucDiMAVHxlNepk8rTw1YhkJPn7BrLh0aHba1BtgMJMUec+pOausfF09eveGKWFmh7QSwg1MBMd3euG6vz0QOGTtPbVa5fFfTSAiHS4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gEdVyGhZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gEdVyGhZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF694C4CEEA;
	Thu, 26 Jun 2025 00:15:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750896912;
	bh=I9O5STmyKmax2NYFHWAQYzdQJXZONsWgI3b6zcEkMGA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gEdVyGhZmsWSgyBiJiWKiKk7Xdpzmm/2iYHDFbgmiZ+mxC2bKR/TWkuZjv++8XMb6
	 scfTIEtsqIPg2qNwIxaTl3cvvNa457EHWAhnMsQAqx1jTHf2M8xu/iqMddxC2YvGek
	 91asSRK0mjYM7vvIsuVv21oPmu5YnIpjZGxlb+twIA6vkuR5wGNsnyc8IqbzBcGI43
	 hCLM/i83RM9NSdTmTJclvjEowYHiW6lIDMeP6fDtqdw7EtEhVuBI8kD7qgpg/oq/4H
	 z+s9YNqTtMV54H3D/QA/k5dOMb72Nq/8G6GtuVICCzlmzanmsLjCOoOucgR7ZczGGe
	 r1KqDHD/0h4nA==
Message-ID: <92be4ac8-df7c-440f-af6c-df611ecddb76@kernel.org>
Date: Thu, 26 Jun 2025 09:15:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v18 05/12] blk-zoned: Add an argument to
 blk_zone_plug_bio()
To: Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
 Christoph Hellwig <hch@lst.de>
References: <20250616223312.1607638-1-bvanassche@acm.org>
 <20250616223312.1607638-6-bvanassche@acm.org>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20250616223312.1607638-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 6/17/25 07:33, Bart Van Assche wrote:
> Prepare for preserving the order of pipelined zoned writes per zone.

I do not understand why that is needed. And the commit message does not explain
anything.

I suspect it is to handle the case where a submitter changes CPU when issuing
writes to a zone. But if that is the case, you should be able to hide that
explicit CPU choice within the blk-zoned code instead of exposing it through the
API. E.g.: plug the bio and schedule the BIO work to run on the CPU you want.



-- 
Damien Le Moal
Western Digital Research
