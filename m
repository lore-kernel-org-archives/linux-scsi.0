Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E97A136672;
	Thu,  4 Dec 2025 01:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764812389; cv=none; b=fsMhXamEd6xupz/mmbSrVp0shv1Iy2vd2evKFbF3ZvMnuWYL6Keo4X7Flw+wBq1SyxAnWG4mr1btxyBQj2+LllY5oVhtAgcoEX1UeZbrhB5E0+jls7I8/93yYDkVb3nDzhgP6/KB5V/IIiPTF3SsQVbXBVe3EWEJK6WkUMhhtNY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764812389; c=relaxed/simple;
	bh=Nw48KlbCfVFYDqI139mj+mIBjh8i/nvLyR64ZHUy61o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WR3FJnC2bzjgxyk3Ri463VutkkoZ4FLHIPDBy9kt/zSSaRdR+6igsibRjnMwbITCaJg4QTbAp+pGd0GFcft2LVRoe+g0mqztjrXzkvDVGjiEtFqsC6cyO7fhME/MXZybwx1shTbP8SqJ5rVOqo7jLAXXQoeEpX49O8KmZRchj44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TPucq6oV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TPucq6oV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6119CC4CEF5;
	Thu,  4 Dec 2025 01:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764812387;
	bh=Nw48KlbCfVFYDqI139mj+mIBjh8i/nvLyR64ZHUy61o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=TPucq6oVQRWq9648XUeGE8LwmBBP34HHtaV9NmsR+QaNrqwJvCro6xnxqKOzUPDI1
	 PKLQha2hH0hbSexx2tTq2mbOU8crMl8tqbbdf6ag1Y03iwkxvV9WKLXyIIRxWxC8fB
	 2G9GMWFrhe2PjcvjO+VFLUhMKbvp5t5XB1QzsMH0cB/Zof44HPT9yGLOBnTQxpQz+e
	 99+u6xFHsmrKVFUI5OuuyWjPS2pFkqsGGx65XZblXfJJsBdFbFz+/8Eo0uw83u6hNd
	 d+fg6o6OzSAGh9CccqWUoJ/9qfLWJMV47DvG37ugCdB67UaQ987SVPZgzKoPGjBUGZ
	 fjhVEfcyZ3Ecw==
Date: Wed, 3 Dec 2025 17:39:45 -0800
From: Luis Chamberlain <mcgrof@kernel.org>
To: sw.prabhu6@gmail.com
Cc: James.Bottomley@hansenpartnership.com, martin.petersen@oracle.com,
	linux-scsi@vger.kernel.org, bvanassche@acm.org,
	linux-kernel@vger.kernel.org, kernel@pankajraghav.com,
	Swarna Prabhu <s.prabhu@samsung.com>,
	Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 1/2] scsi: sd: fix write_same16 and write_same10 for
 sector size > PAGE_SIZE
Message-ID: <aTDmYXli5gDjgcgp@bombadil.infradead.org>
References: <20251203230546.1275683-2-sw.prabhu6@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251203230546.1275683-2-sw.prabhu6@gmail.com>

On Wed, Dec 03, 2025 at 11:05:46PM +0000, sw.prabhu6@gmail.com wrote:
> From: Swarna Prabhu <sw.prabhu6@gmail.com>
> 
> The WRITE SAME(16) and WRITE SAME(10) scsi commands uses
> a page from a dedicated mempool('sd_page_pool') for its
> payload. This pool was initialized to allocate single
> pages, which was sufficient as long as the device sector
> size did not exceed the PAGE_SIZE.
> 
> Given that block layer now supports block size upto
> 64K ie beyond PAGE_SIZE, adapt sd_set_special_bvec()
> to accommodate that.
> 
> With the above fix, enable sector sizes > PAGE_SIZE in
> scsi sd driver.
> 
> Signed-off-by: Swarna Prabhu <s.prabhu@samsung.com>
> Co-developed-by: Pankaj Raghav <p.raghav@samsung.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>

Just missing the Cc stable # v6.15 tag. Other than that:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
