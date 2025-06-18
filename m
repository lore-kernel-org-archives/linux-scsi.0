Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 584681FC0EA;
	Wed, 18 Jun 2025 05:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750225743; cv=none; b=fsxhuYSBkHpdvFINLByTj11YkceSVnerma7tO0U+fI6S6sUwD54QXL/j2hl5RURcKcRPOGh4rAyFN1r0Bq01aJs5cnmcw3CVPRPdRCoolWizA+LcL+dGwkrYl96bMHvyTht9GeOvU8XqJHpbrLNP9jWPr6HA6y+DmpizKF38rzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750225743; c=relaxed/simple;
	bh=LX1T9QBPtSDOnlfJZ4dAxSNH72poGKmVSSl6hs6fqV8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e5bZsJGc385c26toA9+Ux97Arj3iGRA1Njvm5v98tDOx24o/h7FyA050Hwc0kv6J1Uz9mx96WpSpShMEhw6zYed3IaHwFI6YzKYxmBhKGIxn+9rluHW/W8JOWDazGHxMJx5U/GuQTq0wAzqqiFthmjOnJkk1R3e6g1KKx/MSkio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 9090168D0E; Wed, 18 Jun 2025 07:48:56 +0200 (CEST)
Date: Wed, 18 Jun 2025 07:48:56 +0200
From: Christoph Hellwig <hch@lst.de>
To: Ming Lei <ming.lei@redhat.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
	linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
	"K. Y. Srinivasan" <kys@microsoft.com>,
	Haiyang Zhang <haiyangz@microsoft.com>,
	Wei Liu <wei.liu@kernel.org>, Christoph Hellwig <hch@lst.de>,
	"Ewan D. Milne" <emilne@redhat.com>,
	Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: storvsc: set max_segment_size as UINT_MAX
 explicitly
Message-ID: <20250618054856.GA28975@lst.de>
References: <20250616160509.52491-1-ming.lei@redhat.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250616160509.52491-1-ming.lei@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Jun 17, 2025 at 12:05:09AM +0800, Ming Lei wrote:
> Fixes: ec84ca4025c0 ("scsi: block: Remove now unused queue limits helpers")

That's not the correct fixes tag.  This got broken by:

commit b561ea56a26415bf44ce8ca6a8e625c7c390f1ea
Author: Ming Lei <ming.lei@redhat.com>
Date:   Sun Apr 7 21:19:31 2024 +0800

    block: allow device to have both virt_boundary_mask and max segment size

for which I explicitly warned about this kind of breakage.

So please, let's fix this properly instead of piling crap over crap.

