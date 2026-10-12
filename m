Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2670471CE4;
	Mon, 12 Oct 2026 14:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791816223; cv=none; b=t520Dox2gqbzk+x1KIQwwU9mA0qJJxpLxzV4uaz76ZG1E4cc5bXna3gENacwlfPoXtSKiq/Hr6LIJXR5PAVGFHElBksR4SUqSj3zY7vRwxUxKczBE9LU0EL90J+PAQ1xUKWYVnhnawGHlW0xiPnmlD7LS+aqD3dqnmb3ScCsAP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791816223; c=relaxed/simple;
	bh=X/JuCA82j7yYeDC6ewxVIyQ/X/1LIoHbGeSKVl36IiU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UaDH6mfW9pu8wLrsYbsdW/eKUYIYUpMjOnBrtB/hN1tUQ0DzonB0jUG2kbrtW5Kol4K7lMe6J2X71/ZJA++AYEaSxm8adSonnS9WspMqnrbydq7s9KI+8YQ5SKPy0VFx02+WnNPkd4D0nJQR4qdTRSOPCatCBR1Natc+1+Ipjao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 6AE3F227AA8; Mon, 12 Oct 2026 16:43:37 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:43:36 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 6/9] zloop: add degrade_element control command
Message-ID: <20261012144336.GG8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-7-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-7-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Oct 12, 2026 at 10:01:18PM +0900, Damien Le Moal wrote:
> @@ -2303,6 +2384,10 @@ static int zloop_ctl_show(struct seq_file *seq_file, void *private)
>  	seq_puts(seq_file, zloop_ctl_ops[1].name);
>  	seq_puts(seq_file, " id=%d\n");
>  
> +	/* Degrade element operation */
> +	seq_puts(seq_file, zloop_ctl_ops[2].name);
> +	seq_puts(seq_file, " id=%d,element_id=%d\n");

This should be a %u I think.

Otherwise looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
