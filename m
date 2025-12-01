Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5760F1E47C5;
	Mon,  1 Dec 2025 06:34:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764570861; cv=none; b=nx3k9CTUEBXYK+w8SmPVLuAsP2bOXCfHDGNEE4FuY6zXsXeVDAF4Y4tNDhiMWXd+Itflcce+hvyvSNfycnv/LoDj4qwQhkOL/Xl7yZz+4GQ++gAg8IY5/HI09phtHkJ9D5JZQ+9ED+1VvaGh5WJdhvqb51lFnR3qG8OrpFbt1nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764570861; c=relaxed/simple;
	bh=9fy2pdBLtxtN/URqI42dorbO/wX0U6FVflZmAtnWLRU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=dO7tCVgBdHBlKpoQTVS6Ada3J4cnkNC7gOY4N1yBQ/zl8pGHzgUzBXaZwy9KTrz7Mg443AsPVAun5nZ/4N/txzxS2VtgUbOO0Lgyx2dFxcoHzaPvZYLW7ckcIQYmNxlFWd6q7TAWubpf4MQSBsvgsbBj+w686xMSVWfkyAaCDmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 69E736732A; Mon,  1 Dec 2025 07:34:14 +0100 (CET)
Date: Mon, 1 Dec 2025 07:34:13 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Keith Busch <kbusch@kernel.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	linux-kernel@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	Christoph Hellwig <hch@lst.de>,
	Mike Christie <michael.christie@oracle.com>,
	linux-nvme@lists.infradead.org, Jens Axboe <axboe@kernel.dk>,
	linux-scsi@vger.kernel.org, Sagi Grimberg <sagi@grimberg.me>
Subject: Re: [PATCH v2 1/4] scsi: sd: reject invalid pr_read_keys()
 num_keys values
Message-ID: <20251201063413.GA19461@lst.de>
References: <20251127155424.617569-1-stefanha@redhat.com> <20251127155424.617569-2-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251127155424.617569-2-stefanha@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Thu, Nov 27, 2025 at 10:54:21AM -0500, Stefan Hajnoczi wrote:
> +	/*
> +	 * Each reservation key takes 8 bytes and there is an 8-byte header
> +	 * before the reservation key list. The total size must fit into the
> +	 * 16-bit ALLOCATION LENGTH field.
> +	 */
> +	if (num_keys > (USHRT_MAX / 8) - 1)
> +		return -EINVAL;
> +
> +	data_len = num_keys * 8 + 8;

Having the same arithmerics express here in two different ways is a bit
odd.

I'd expected this to be something like:

	if (check_mul_overflow(num_keys, 8, &data_len) || data_len > USHRT_MAX)
		return -EINVAL;

