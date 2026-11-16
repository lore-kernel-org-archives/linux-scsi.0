Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=213.95.11.211
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811334;
	b=c60eODAjGmHdv4hDrrf9c6Uwz1TbTjq9Og5TmYszrVrj4uB2+G9RUtjcTcDjTWCWUvFs
	 ANjUAY7z+eGHrMFwK7c6Peeev5eit0e1+7ZYHgYXGSLml5e4GHR23ff0HOwIOaflWKBKW
	 OoP6H8gSDFVPlKrW9tcKmXVeA85/ZxZiTE54omH/+BEdn6Dj+eLS0KLkgFQvSEVwzpWve
	 ftDMjLBEVVXMqIeU/qwUqTxtE9KtAU7BaEEr5qm2EmakGHnz10x95/M1Wp47N+li9DDzQ
	 R/GJWJM3f1Ufnvn/RtW/zQO1++qsEaY0JfOzh80ucPhbiNMCq7pu4UC/cCshmpGgneQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811334;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:User-Agent;
	bh=IL9jNf7cAy6i233np7VhfF5f6auI4Urx3D1S6lEoa3g=;
	b=Gbyl7mwGw7emMGE8P2mb+HE0gpqtC3gzVcgwuhsutlDvzZjJE5SYky2Pra9gsXCqTjX/
	 2mTSpv3OLq87XJNv801I7u0NJzprOwL880jWXmIz2ul1Raaow1I4K/Ya0wFwKs9d1Rwmy
	 QJu+BVxDgU0YZLn8KvWL1zaI90meimGB+Hogo2NnF8UySEfGC4pFDckkKsaI5i+ZRBWC+
	 OXNe5lvod35aXof24v4XkXoaBD2FtJG4+i6kBQRdncWI0xKfB42/x87xJb9i2IL6AAWmY
	 JRQ5D37aUZwaOLr75/gp255e13q6A7bKJKqJd7gL/gEppo7U2ImgheQo3AVDUOgpqgw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=lst.de;
	spf=pass smtp.mailfrom=lst.de;
	arc=none smtp.remote-ip=213.95.11.211
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F794606A31C;
	Mon, 16 Nov 2026 06:42:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8F794606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 77DBA68B05; Mon, 16 Nov 2026 07:42:09 +0100 (CET)
Date: Mon, 16 Nov 2026 07:42:09 +0100
From: Christoph Hellwig <hch@lst.de>
To: Damien Le Moal <dlemoal@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org,
	"Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v10 07/13] zloop: fix zone reporting consistency
Message-ID: <20261116064209.GB2896@lst.de>
References: <20261115233327.941586-1-dlemoal@kernel.org> <20261115233327.941586-8-dlemoal@kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261115233327.941586-8-dlemoal@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Mon, Nov 16, 2026 at 08:33:21AM +0900, Damien Le Moal wrote:
> In zloop_report_zones(), filling the write pointer and condition of a zone
> descriptor separately outside of the zone wp_lock can lead to an
> inconsistent zone report with a write pointer potentially not being
> consistent with the condition being reported. Avoid such inconsistency by
> filling both fields while holding the zone wp_lock.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

