Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B8D21DFE0F
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:33:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736332434; cv=none; b=WxLcQyUWcGtL+7sXCjdeVGNLCK2sIYmmy0/Yxw8nvUctlOUFoUJkUcUg82efNJ00l2slDRQ/RX/EBNeQmFwVAyMbVZP0Sl/UNjv8nXUOgGcuiN2sAJaivE9ttXRn9V3Z9yJtVCUpTYvOBU0N1EUwLK3hX/ai5yWrGupoLzPnzSg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736332434; c=relaxed/simple;
	bh=OOC9L+Sp3RLpKA7SBWIiPpWKlwrmatxs9tO31j4qowk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0hvomgtmP2Wl01d0XnKFUFkZjMLtWqFrYQOMvy0vDvsHxlBVI1o7eHumpjFv6naFI1coEQSvrOlCyqQhT2biG9CYn9WlK1bAL2kWkx2rQMP8LtOmtSpje7BrZkMPNeVnInyQo1eU124XCl7XMy2KCms9guNFY8PTOmIt56L7kM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=jEhoTyPK; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="jEhoTyPK"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736332432;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Ssv5sraZs0pWcRroM+g30CQn3Ui595UuxeM0/77A8ks=;
	b=jEhoTyPKaSGKzSbxyfEemGw93XLw6cUcYdsSaafvudvShZQtTtV/V+5bL9k2t4yUXhN0RN
	Iq39jXUcxU0/L+hn9NzGYO2UFJklAFeToMqDyzzkC5/BEqoZW740w3vpXXnirw5L0ixjVj
	zxIHiiWSdZJtHZ+aty1Zrn4qAuoFFNc=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-622-Xkn6sEqxNDWEm0i-nMmU3A-1; Wed,
 08 Jan 2025 05:33:48 -0500
X-MC-Unique: Xkn6sEqxNDWEm0i-nMmU3A-1
X-Mimecast-MFC-AGG-ID: Xkn6sEqxNDWEm0i-nMmU3A
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 25F1A19560B0;
	Wed,  8 Jan 2025 10:33:46 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 0EC57195608D;
	Wed,  8 Jan 2025 10:33:39 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:33:34 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 04/10] block: add a store_limit operations for sysfs
 entries
Message-ID: <Z35UfgUewo9xei9C@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-5-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-5-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Jan 08, 2025 at 10:25:01AM +0100, Christoph Hellwig wrote:
> De-duplicate the code for updating queue limits by adding a store_limit
> method that allows having common code handle the actual queue limits
> update.
> 
> Note that this is a pure refactoring patch and does not address the
> existing freeze vs limits lock order problem in the refactored code,
> which will be addressed next.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>


Thanks,
Ming

