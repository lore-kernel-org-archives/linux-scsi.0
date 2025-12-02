Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68DCE2FD668;
	Tue,  2 Dec 2025 05:58:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764655116; cv=none; b=RHSuDqdt4mzH6GvygwtASPEpjLBvcHthRed+Gv2jRdvbt5VElb2QI/vwz9sXdYXdzOn6gPQF/gNCURmCwkdhr4nz0WCtS+esTV+TDew1zGwM4VnSuE5k7YYohzyTDoAf3kPq51+IQNiN9C8wIVa9N5me5F/v/mPV1ANa/p2Gc7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764655116; c=relaxed/simple;
	bh=I5XhOGyy7HsNCYy/ZSbUElK5TTrgMsaBOYhfIGFf3CI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=D1kgefDsRk/1OeBfpvUmfeRtU/Km1h1JCoYHE2b7Qpv4eWYG+5LpBl79FbuO3dkYehX0/GZDuLLD7N/D3f48GexZPFY5N9HNQSv99/UyAQSYPhkIJH5OQZQp0Iwl1jmpsLTIpO/3zePpK/XWUNSsBKjqrw9HIC46aCoGwvzxZ58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 080AB68AA6; Tue,  2 Dec 2025 06:58:32 +0100 (CET)
Date: Tue, 2 Dec 2025 06:58:31 +0100
From: Christoph Hellwig <hch@lst.de>
To: Stefan Hajnoczi <stefanha@redhat.com>
Cc: linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	"James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@kernel.dk>,
	Sagi Grimberg <sagi@grimberg.me>,
	Mike Christie <michael.christie@oracle.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	linux-nvme@lists.infradead.org
Subject: Re: [PATCH v3 1/4] scsi: sd: reject invalid pr_read_keys()
 num_keys values
Message-ID: <20251202055831.GA15965@lst.de>
References: <20251201214329.933945-1-stefanha@redhat.com> <20251201214329.933945-2-stefanha@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201214329.933945-2-stefanha@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Dec 01, 2025 at 04:43:26PM -0500, Stefan Hajnoczi wrote:
> +	/*
> +	 * Each reservation key takes 8 bytes and there is an 8-byte header
> +	 * before the reservation key list. The total size must fit into the
> +	 * 16-bit ALLOCATION LENGTH field.
> +	 */
> +	if (check_mul_overflow(num_keys, 8, &data_len) ||
> +	    check_add_overflow(data_len, 8, &data_len) ||

Using data_len for the throw away key size is a little confusing,
but then again I guess compared to all the surrounding code that's
harmless :)

So:

Reviewed-by: Christoph Hellwig <hch@lst.de>

