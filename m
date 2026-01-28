Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0256D275AE3
	for <linux-scsi@vger.kernel.org>; Wed, 28 Jan 2026 06:54:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769583276; cv=none; b=JoxARsbTSr6G5x3de+cY+k8IBnHH5aliPxs5XYc7cZw0nmX+Lwg0kMCIrdfPXRcC99hK+X6y3LJVh16kkQNQhgVVkC8gmsPEJXAbj3RlfpsoQ3bEGHbGWpqv27c+b5RqCG2HZ58+7lwLMSfRxzpzt4iRTmFFqVK9bht91QXiO0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769583276; c=relaxed/simple;
	bh=c6mVKayqobUSgqyLIYXCBhvhSJL4jSQ5a3ggZ08JffY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lCEBLRX3KL7GeRWc4pxamFy2mcaZZoECpQGO6V/6Wwn6csvamJB3qcSpj+j/cAYC/5CqK2jZgIa/NetjASkrbjuNo6kxT50SEItLwtiVhRzQHiN6YVLy6umIDkdD0DoFPc2vYDAuFGNOwH5jD7XIIiL9tg9Cq9Ly16GCiKR0sF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=fZP8AIQb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fZP8AIQb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8ZqNjMclPY8YJu3dzyChLI3jmgD0k8Bx9DjDyWmCbJM=; b=fZP8AIQbjvK2EAzEU0l81JynvT
	tlOsnDLZEORrIIAHax0LVe9sFCnrd4qfoft5RQ5/187NHLtHukGdOoeZzl1m3amYI1rPmLA1CnfYb
	GbJdcvRSGGqhJINO6giXKclddE2R3hksOuHkkjqZizk20GJgsFLObNejR3RWHomVkY3N1SSNRSw2A
	OnmjxTM2NuDfRAz/q5iyh4emrM52VdJWSxMAa64Qz+4SxsGZuhnJulOUDy96KPlWWA2EwwOTi6P3H
	L49bZMfK4bESTPV+DisEuNiQQDYI+39Bs5gmYKbGY39xeeDRag++m80uveTaXT//tQlMzRUhWCVSY
	2zcuUdGA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vkzRh-0000000FYCD-0hkS;
	Wed, 28 Jan 2026 06:54:33 +0000
Date: Tue, 27 Jan 2026 22:54:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: sg: Add warning message in source code about
 non-idempotent SG_IO
Message-ID: <aXmyqfCzBBeV8Jj2@infradead.org>
References: <20260127180427.471487-1-emilne@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260127180427.471487-1-emilne@redhat.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Jan 27, 2026 at 01:04:27PM -0500, Ewan D. Milne wrote:
>  	case SG_IO:
> +		/*
> +		 * WARNING:
> +		 *
> +		 * This ioctl() uses an interruptible wait for I/O completion.
> +		 * As a result, if it is interrupted by a signal (e.g. SIGSTOP)
> +		 * the result will be discarded and the syscall will be retried.
> +		 * Caution should be used with issuing commands that are not
> +		 * idempotent (e.g. COMPARE AND WRITE, or commands to a sequential

overly long line.

But I don't think a comment in the source code is helpful for
applications anyway.

Maybe we need a proper man page for this ioctl or some other kind of
official user facing documentation?
