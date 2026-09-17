Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07EDB36F433;
	Thu, 17 Sep 2026 02:49:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789613399; cv=none; b=g36r3L2WGysw+0uuqgaYiFWQ3EyE03563ssqA8eXxL605JyA96fPrRBZQA5cLSQ51j5DGtzfy2r4e7VTaOLCTzGHPQqV3rxPbjJZmjrg4XSHzRt2iOZBqewEij2rKOY1OS/Rx1qS8kz/T0IDPzWUZUzcwHmYkVnZlXBVzUyArUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789613399; c=relaxed/simple;
	bh=vuWMn5WTrbjuQYpu8JqY1EuAvH+36n6O1zsCHlPVzPk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ufsBEbr5eu1NfkIGrcwda+da7vUhhooLHvp6bbNi9s9UQRECIPYbDbYwWXmD4kTVXxHGy6iVth8bmQ/EJ/GK8GWS3upw9Jcbq1ElMXQLawG4UvH5+ds5w8UwV+JJC3RbIkRbV7a6XgxDtE35JbHOnP9YRrltSfhRr428snggSa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jE6za9iv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jE6za9iv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AAF01F000FF;
	Thu, 17 Sep 2026 02:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789613377;
	bh=baIkMOgl8feCE5sFB4bHggBY8B1LnrmQuwR+ThEfif4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jE6za9iv8ISRlK7OQjojSvJeV4gg8aRRWf3SLGMzWPyqS6FmFfvUv0QVEpKRvEgdQ
	 mgm/oA1/XueC96i4Klsf/Fm4t8IBgHvpspVGjQ4KnDLRbt0NxKut3cTnf8b1vDHIOl
	 2lEFlXyzkMzzgp2z2Pcx9xd6SWfxNZsrYs4k/iDlfFz8ZLwFm+tJqKkZj+TcoNzVod
	 0eOfrlsbIDeLj+dcc28bChZ276oazED8fe67lSrgrcU/Fnaw/W0inez8nWbuS6ziBw
	 koqCbzYZjwCLUA23UxOZLQQMLotTL10Jd09rnJEXAvV9QjGdyR6f26YuyuV9XCsuTM
	 50QxQtaNC2tqg==
Message-ID: <c724c4ac-b447-45fc-869c-0eb8d10a702a@kernel.org>
Date: Thu, 17 Sep 2026 09:49:28 +0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/2] block: fix zones_cond out-of-bounds write on zone
 report
To: ZHOU Jiaxiang <me@fxti.xyz>, Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, "Martin K . Petersen" <mkp@kernel.org>,
 linux-scsi@vger.kernel.org
References: <20260916135822.32584-1-me@fxti.xyz>
 <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <7815D1B293A8F55E+20260916135822.32584-2-me@fxti.xyz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2026/09/16 20:58, ZHOU Jiaxiang wrote:
> blk_revalidate_disk_zones() sizes the zones_cond array from the disk
> capacity and zone size, but the index used by blk_revalidate_zone_cond()
> comes from the device-driven report_zones() walk and is never checked
> against the array size. A device reporting more zones than fit the
> array makes blk_zone_set_cond() write out of bounds.
> 
> One way to reach this is a zone count exceeding 32 bits: both
> blk_revalidate_zone_args.nr_zones and struct zoned_disk_info.nr_zones
> are unsigned int, so a disk advertising more than UINT_MAX zones (e.g.
> 2^32 + 1024 zones of one 512-byte logical block) gets its zone count
> truncated to a small value, undersizing the array while the report
> walk keeps counting upward.
> 
> Check the index against the array size before storing the zone
> condition, and refuse to revalidate when the zone count does not fit
> 32 bits.
> 
> Fixes: 6e945ffb6555 ("block: use zone condition to determine conventional zones")
> Signed-off-by: ZHOU Jiaxiang <me@fxti.xyz>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>

This review stands if this is applied as a fix to the current code. However,
applying this will create a conflict with the changes in this area that are
queued in block/for-bext.

Jens,

How do you want to proceed? Applying this as a fix and do a rebase of
block/for-next? Or rebase this on block/for-next ?

-- 
Damien Le Moal
Western Digital Research
