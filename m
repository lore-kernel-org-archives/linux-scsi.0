Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2C9C4B4027;
	Wed,  7 Oct 2026 13:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791379763; cv=none; b=epZq+5pOTJtYYX26xMAbfjiFQ3uw63/+mQ7WaENY5C+cK4Vpcinly0pdrM/m56z5fm1+P6vsIxpz3PfZoP4QQOrHPqKyBbJj+a5RTKfFt+Ks6PXPQ8iIrIGFgQTNvXI0Ium5DDpMjkP0VR3O04NHy5bDwCe4o8uyXE3J4sAMbgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791379763; c=relaxed/simple;
	bh=agSyOQP+etchArNsyhzXz0faD25YVBk44nsdUJsoCNc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DQjkGwGiPH5vIS8ySbM0k9yT0GRn5Gd7zR0FwgrH4WAo7MRRFV0uH+A+IvuIr3T6S3DHBoM2Ykjb2GIP1e+iOEMqQrmpp2Qb7TcMoJyDublb9dsfcv+m8lFaZTAmqqJscXyq4FK7Qb2Tnkz14CHzUIkdR+egq1S9XECvdiNp8nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 5D5A368AFE; Wed,  7 Oct 2026 15:29:05 +0200 (CEST)
Date: Wed, 7 Oct 2026 15:29:05 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v3 1/7] block: fail reads to offline zones early
Message-ID: <20261007132905.GA31906@lst.de>
References: <20261007082344.1049179-1-dlemoal@kernel.org> <20261007082344.1049179-2-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261007082344.1049179-2-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Wed, Oct 07, 2026 at 05:23:38PM +0900, Damien Le Moal wrote:
> Any BIO targeting an offline zone of a zoned block device will fail,
> including read commands. So there is no point in issuing read BIOs.
> Fail these read operations early if we ever see one.

Sashiko things this can race with zone updates.  Which is real, at least
sorta.  Maybe we should just do this in the drivers instead where we
are under freeze protection?  A bit uglier due to duplication, but not
really any more complicated.  And drivers right now would basically
just be sd and zloop anyway.

