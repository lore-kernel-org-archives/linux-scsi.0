Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85D251E0E13;
	Tue,  7 Jan 2025 10:05:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736244313; cv=none; b=kqL7T8qbkOdJXlVEAxQO0RS4tohIhCSejHVEgWlomOvdk411bfqv1DXATfJignS3KDp//HGEe84lhjiI7KkKy6iBvFqb9jKYvKRv5rNfjLfyYtg/E90GsO6BQAudecN/J6+xpWG9RMVCxEnpVjDVcoBj3VfPE+LiAL0+jlDDr+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736244313; c=relaxed/simple;
	bh=YfTW/VCU8RjS9S1lJNIo16WQ/Ki1VbCtrWDcuUTA3TE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QfaB/MaMQo6gaGRN6enymwsiONaX7Knyx1jw9Tuyb1G+fC2HHt/xNyHWWFoKCkgd3HdzMy32EIiDJ+f/26nUAQNqLYsyQVIqKdIa60m7BsxC+yJQnY5Pw0oWq2dM/LuEl6fkId+k3wGm+0gEfJXrwgVEY9C9FIkxH+ckE2mREU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=RuawTMIQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="RuawTMIQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7711C4CED6;
	Tue,  7 Jan 2025 10:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1736244313;
	bh=YfTW/VCU8RjS9S1lJNIo16WQ/Ki1VbCtrWDcuUTA3TE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=RuawTMIQ0dmGB+M6Kz6Ulhzj9Kj3RzFx6gq40uH7T2AYtb4YbVFFYdzDpOI61xMWv
	 a0Rx9IW+SkYVgpNmmia+ITJEY8nBaVd4DNp+DrBnYBLOI6lcdFrwH7G4j0MHToNdfB
	 YH51M77EAucAnSuGgpjjiOnvUqD/TM35Y9dTXp0IY91Fgr7LvEpyaNnO0A7zcrHGlP
	 WGB2SahGhi8YwkJ3vow5kuYxzHJsiU9jgZbyVzunVvsAq21txpymMlaN9DFP5V10uW
	 SMtAML03BcSQbxHVZsSS9Ml//mYsdH1pbgulfBMPNeIjKIZSac25BAaW4DeUJygpiO
	 jmv2gpOc0oX0g==
Message-ID: <68c4acb7-8d2f-4163-a0e2-c9c5395dcedb@kernel.org>
Date: Tue, 7 Jan 2025 19:05:10 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/8] block: add a queue_limits_commit_update_frozen helper
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, Nilay Shroff <nilay@linux.ibm.com>,
 linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
 nbd@other.debian.org, linux-scsi@vger.kernel.org,
 usb-storage@lists.one-eyed-alien.net
References: <20250107063120.1011593-1-hch@lst.de>
 <20250107063120.1011593-3-hch@lst.de>
From: Damien Le Moal <dlemoal@kernel.org>
Content-Language: en-US
Organization: Western Digital Research
In-Reply-To: <20250107063120.1011593-3-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/7/25 15:30, Christoph Hellwig wrote:
> Add a helper that freezes the queue, updates the queue limits and
> unfreezes the queue and convert all open coded versions of that to the
> new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>


-- 
Damien Le Moal
Western Digital Research
