Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB3A53FD124;
	Mon,  2 Mar 2026 14:12:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772460732; cv=none; b=lIw2c+q56p72WAWNG0wZlXZFENfbjbKlh5A1M1y1jMzlmHSEo0xAlvr4KfMnTH8qNpLlCpmujv3KMwrbxPK6yAsOshAE4QZJoz7UP6lYome11h3QPLCp6KtZLX0mkLyWRfLRQoYIGPV6HHS0SLCetxJYBMQYXQb1KOjwfDiYlgY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772460732; c=relaxed/simple;
	bh=w2YDu5rMtbMMxT3t2H4bsBgwmSSKVHaJSN2ub4jHoRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dawW05awCGXvyIOCbaKGHoQsONbv2nL/Vr5R9IgQYSWXgK6HK2zXUV6GYlCecNiOZa15t1xMPOUcXLLFXkvhrnO3YWyTqJyRl6CHiZExTBRwc5A2TwTXXLoRTgB5KomiinuBchE565NuNtGR6ceP0Fm4Su6g8wOXDH6989TrORk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 97D8C68B05; Mon,  2 Mar 2026 15:12:06 +0100 (CET)
Date: Mon, 2 Mar 2026 15:12:06 +0100
From: Christoph Hellwig <hch@lst.de>
To: John Garry <john.g.garry@oracle.com>
Cc: hch@lst.de, kbusch@kernel.org, sagi@grimberg.me, axboe@fb.com,
	martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
	hare@suse.com, jmeneghi@redhat.com, linux-nvme@lists.infradead.org,
	linux-scsi@vger.kernel.org, michael.christie@oracle.com,
	snitzer@kernel.org, bmarzins@redhat.com, dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/19] nvme: switch to libmultipath
Message-ID: <20260302141206.GA23439@lst.de>
References: <20260225154007.1033735-1-john.g.garry@oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225154007.1033735-1-john.g.garry@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Feb 25, 2026 at 03:39:48PM +0000, John Garry wrote:
> This switches the NVMe host driver to use libmultipath. That library
> is very heavily based on the NVMe multipath code, so the change over
> should hopefully be straightforward. There is often a direct replacement
> for functions.

Given how little code this removes while adding the new libmultipath
dependency and abstractions I can't say I like this at all.

