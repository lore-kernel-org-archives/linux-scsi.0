Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B2B195;
	Fri, 12 Apr 2024 00:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712881168; cv=none; b=dBnfvUuUJh00f0tMPBIMAZUDt1BEnYoDp6UMXCDHBYKKutc5WU8xttHlakXYRzDXkb1V6dU/O8zURB9yHhvxCTX1erxgIGh4Dox+PAOfqYErJJO8dlrBRj3iFgSzul2Fy/WUdLcsu6sfLoFm2IfmfoZ8X5O+KiM+8KnBlTryZsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712881168; c=relaxed/simple;
	bh=XIw1C5UrfJZG7RekgDhJXcNJ8d9mFC4P1pP8HtXGvKE=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:References:
	 In-Reply-To:Content-Type; b=sKKsXJPYHzYXQLHDyAF9B/u3asy11MFYtKaC00ZPwjWGguy8AlLC0FsrsoPyvvnm99QZpjpoPLNWN1X1WV82PN/IRrzhIVBXswotX1yNavVy0O/NjF4VATy2nd9718ZOhXhwS+CMoRNJen7JjRP15OtHr02EXVSbYxVDSC349z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANXhkrFb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANXhkrFb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 627AFC072AA;
	Fri, 12 Apr 2024 00:19:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1712881168;
	bh=XIw1C5UrfJZG7RekgDhJXcNJ8d9mFC4P1pP8HtXGvKE=;
	h=Date:Subject:From:To:References:In-Reply-To:From;
	b=ANXhkrFbziMQWEQ1uraEfPHEwqJP8AETkc3u7Bs+JkPvZrwr2UF4sFqUPI2wP+UwT
	 +KEJlXJrzwh+4EZ8kiBkoIGD0as4PEcBSnu+3zJeLosS04voma1EtWHe4t0EOtAPwA
	 RykPhXj/bmpGzhFkG8mR2Ao79QVCcAZgFzi71JhnjJ2vJXs+246lJCgBq5Imlu5b98
	 zysVsHrSVQbbK1EL4o4rHUIlTNYW6DuWxRxDvItGhJYk0Vv5+NrCyF+jHPuIgHtf9e
	 3iBb/z4yKrRjdQS2ceaFf2tn9GLkFMS+UWHkTGrhreYnEZT5LHNlU+KnQqVVpDKMYk
	 61RsqFYGpfEog==
Message-ID: <b7f17167-0312-4548-9aa8-e6b08df67f80@kernel.org>
Date: Fri, 12 Apr 2024 09:19:25 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 00/28] Zone write plugging
From: Damien Le Moal <dlemoal@kernel.org>
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20240408014128.205141-1-dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20240408014128.205141-1-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/8/24 10:41, Damien Le Moal wrote:
> The patch series introduces zone write plugging (ZWP) as the new
> mechanism to control the ordering of writes to zoned block devices.
> ZWP replaces zone write locking (ZWL) which is implemented only by
> mq-deadline today. ZWP also allows emulating zone append operations
> using regular writes for zoned devices that do not natively support this
> operation (e.g. SMR HDDs). This patch series removes the scsi disk
> driver and device mapper zone append emulation to use ZWP emulation.

Jens,

If you are OK with this series, can we get it queued please ?
I have a couple more patches I would like to send on top of this and the longer
it soaks in linux-next the better I think.

-- 
Damien Le Moal
Western Digital Research

