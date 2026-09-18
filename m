Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8135F3859D7
	for <linux-scsi@vger.kernel.org>; Fri, 18 Sep 2026 09:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723610; cv=none; b=mJaBqNHNLdmmomh7lRPml0XAWEEl3UiSSaYUcntziF/dojgsJMY3LNsrkXpZlw3YdP/T7femZt49NYymV89yDmNMtzipXvPCvcR4ErIyg9d3tOTde4NaxFHGTzSvENw4oQwQfs1PX9C4JJw66X0zDOHsfah4nxT/9gGNzKgT9IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723610; c=relaxed/simple;
	bh=NcT0edn5Hh6sGcazFXdJmlIVzx0UQ4v7e3TC9wJS+qw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jrAPD0kMnVUEIXO9h+w6o52oNaAuWj8j6ll8SRRm3UGUG3KIiZcNAHe3nYAAWE2FHGBiRm383fmMUHYTzrrdXjxbR8A/1xvtImbAk+wlEDx8HvED9m3ZK3zBA30jO/d3sQeyf58TniQ8JHTqThInBrosXid2Rlx85KnyDFrir1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GM0bEtNg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GM0bEtNg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612E01F000FF;
	Fri, 18 Sep 2026 09:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789723609;
	bh=dfg26xIbqNSEIuifg+ZnaXT1R/Q/4Ny4ZcICa+zT48A=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=GM0bEtNgRqqp8uqp0uyn2hfNkO3JS0noyol9FSmtrQM/ETvjJ0UA0O5+u/511EOgY
	 3PtyWexS5gxQ51FAH534wKD8scFcaOp3AlLhrwjtqcLtIDj9Ggw1m1qoK7CZWKjT7H
	 BgNwJ2nZD89O8kZGIUE0xOg/EEeVDYTcabqv5jGxGC9LwRikVUUt8AX4GG3gnjNV2G
	 hz9dVgXRBSfzvwphdFjlPskb/WSlZ11RCfjNXFmiDVlQJwMNGirlSFcEwc6YbifZm6
	 zEi/d2fmLDNOb42/rTkipG3+Y5O+VqZh43eoJtbCPIqhUjLHnFTICZMVTr5Udr5RB4
	 CHKwVOQq1CNig==
Message-ID: <7bb73c96-fc2a-4cbe-ba17-b68646393922@kernel.org>
Date: Fri, 18 Sep 2026 16:26:45 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/10] scsi: scsi_debug: Make atomic writes and ZBC
 emulation mutually exclusive
To: Niklas Cassel <cassel@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>
References: <20260918062910.1709791-12-cassel@kernel.org>
 <20260918062910.1709791-14-cassel@kernel.org>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20260918062910.1709791-14-cassel@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/18 13:29, Niklas Cassel wrote:
> There are no SMR drives that support atomic writes. Emulating a device
> that supports both is emulating something that a user cannot encounter,
> rather than the drives that exist, and it means maintaining the zone
> handling of a command that no zoned device implements.
> 
> Nothing in the standards forbids the combination. For what would be by
> far the most common case, a host managed SMR drive whose logical block
> size equals its physical block size, there is no problem in the two
> features being combined: the drive vendor only has to give atomic
> writes an alignment that makes sense with regards to ZBC, for instance
> equal to the physical block size. This is therefore a choice not to
> complicate scsi_debug, rather than a restriction that the standards
> impose.
> 
> Refuse the combination at initialisation. If SMR drives that support
> atomic writes ever become a thing, this can be changed back.
> 
> Suggested-by: Damien Le Moal <dlemoal@kernel.org>
> Assisted-by: LLM
> Signed-off-by: Niklas Cassel <cassel@kernel.org>

Looks good.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
