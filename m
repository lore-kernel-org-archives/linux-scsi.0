Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6867417B4FE;
	Tue, 10 Sep 2024 23:02:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726009343; cv=none; b=aYfJoGSYer9ocKdz//Ia0e9mzvdzCatc5OLG7yv+a+lN7po+Db3pyb9ENZr0ielEyRq69Z6joT9eSwSNv70XBdadm/+w6hPRN1JIJL5txf+HKJSJZnPWcJQ934wFZtpl8buA1KHkggSOjPS2fGgDnii7jg13b4W2N5uH330o4zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726009343; c=relaxed/simple;
	bh=BIYdIemb/WL/BM+LvvVr/a4fGnsrxpvabZqZ7muh97o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MTEEHVPIJLU/T619Lukr31YamO87edFWr0Sz7pVeOW9PnZXeCawCRyy5kuk47HzNPed21Y0KSciXEthLAbn0at6Sfe175EOVNuXeleQeC3WNb5AT8urNuzFsuyMMLwejcOa56K5DeCq2EqJY7Vf6f1ybtVfKEhnDWAV2irI/RmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DX0nTJjc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DX0nTJjc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56154C4CEC3;
	Tue, 10 Sep 2024 23:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1726009342;
	bh=BIYdIemb/WL/BM+LvvVr/a4fGnsrxpvabZqZ7muh97o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=DX0nTJjcLQFoXRQ0sReddB4B0hoFkxGA4wbIIn9u+TWdHKL2nKnY9oYYRTChJH8qY
	 N6JKuOW1RetNDdqyL4b4EX0uDmQ25oNnwEJqHqWLVjvp8G+pfS74DRo8xBSf2LamDn
	 67q/IZY6iIZSE3HV3xLKrWn12oZfgo7nrFVrEPUZX1mRacsYNj4H87JqPXwINUEX2X
	 ftr89Q38wJDrLfRt4jRPwN0a7Hqt1nHj3sklVYaUJdbrvDJ6xLLjIWwg+UqW4Dlo/w
	 VnXSWmJNubandBv3GNIaof1o87Et3P0B4bqpU3sarI+X56OmLW+N1uHPYwv6bS8Qxc
	 CliaGl3vN9cUg==
Date: Tue, 10 Sep 2024 17:02:18 -0600
From: Keith Busch <kbusch@kernel.org>
To: Christoph Hellwig <hch@lst.de>
Cc: Keith Busch <kbusch@meta.com>, axboe@kernel.dk,
	martin.petersen@oracle.com, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	sagi@grimberg.me
Subject: Re: [PATCHv3 03/10] scsi: use request helper to get integrity
 segments
Message-ID: <ZuDP-ncB0EXrS9Xg@kbusch-mbp.dhcp.thefacebook.com>
References: <20240904152605.4055570-1-kbusch@meta.com>
 <20240904152605.4055570-4-kbusch@meta.com>
 <20240910153217.GC23805@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240910153217.GC23805@lst.de>

On Tue, Sep 10, 2024 at 05:32:17PM +0200, Christoph Hellwig wrote:
> 
> although I'd be tempted to just remove the BUG_ON below (or move
> it into blk_rq_map_integrity_sg) and the ivecs variable entirely.

Right, I actually have more follow up's doing that. We just need to
change blk_rq_map_integrity_sg() first to take a request instead of a
request_queue + bio. I thought I might be getting carried away with the
"cleanups" though, so was saving that for later. I can definitely add
that into the series now though.
