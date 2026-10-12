Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D1EA48CD78;
	Mon, 12 Oct 2026 14:37:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791815857; cv=none; b=VZTA4zkSaGC7Kl1O5ruJoBxR+z2pN+xIwlNOfxZGjjm8L0vFgLjCcZOaQp+ItRenZiS45XY0EB0B8GpqDKjgYxc+W1ThB17ge1wtQ00Dr3lWl9UjY5XU0JLhqCqk6imfss/SH5tLVMybO0Dm8bey9ryZO6r689Qs1A47s1Yi5/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791815857; c=relaxed/simple;
	bh=mlQXwaRIC9Se3yKnOTbhk3tBc7IU1xA+v/EnEoVYRVs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b9T2Eci4cDgXzzmrg0rDZXUOomSyD7lbOpggbQl+JAATSN7mPaNGH3hcty71Ke0j2QPjnqm8Y4fyRTaa+19oeYScIklhbWpn5SiBtLVJIrtqlGO0o9q6LpcWB0rg8bDpbJJuiINtXeINNA5/MyE5L1yuoTxUJqy77zUmA68gh0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 14904227A88; Mon, 12 Oct 2026 16:37:33 +0200 (CEST)
Date: Mon, 12 Oct 2026 16:37:32 +0200
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v5 8/9] scsi: sd_zbc: always revalidate zones for disks
 supporting head depopulation
Message-ID: <20261012143732.GD8609@lst.de>
References: <20261012130121.1902634-1-dlemoal@kernel.org> <20261012130121.1902634-9-dlemoal@kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261012130121.1902634-9-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks generally good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I think the Sashiko warning about the non-atomic bitfields is valid,
but probably not sensible to address here.  It would be great if
someone could do a pass and convert the gazillions of scsi 1-bit
bitfields to proper atomic bitops, though..

