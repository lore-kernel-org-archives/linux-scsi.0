Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5797E1F868A
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736332993; cv=none; b=f0qh2dIOAvpzSXBlqTwTIIakqawRVqJh0WPisr6kPgssRYyH0O5ZK8HzNZYYy3U7HZuZAQxBYwP4wn1jzwLHGbzfLIHI4G67DvYmIPk/ztlBTsQ21LBQCdcxe9hizGSZ8jyb5N7ySrfv2efSlHUxByG1yaTW8SVgvA3i1bNClsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736332993; c=relaxed/simple;
	bh=fHIqk2pWSYBiQzqYIBxmBCn/NkCybawmeeZVS2FAi/8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=arOCFSRGItys5eP7xgz+N42dA7nyiLAK/KPaIKYvTohFjTWctrziq9o83sydRq0Fo/Ng4UivkbNC5KzV1Kx0Yia9/Y40tCluOv2gz4qRoZSPhQGzfy2h/R6fTGOEVYfK0eFOz9fA0Gpy8fobN5tBiCqch/8a9Z/oDPSDJTKFGyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=WmqpqnEu; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="WmqpqnEu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736332990;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GLX9dDlTVgmbVGGd6/BeEkeXDnHYku8g8v3tdeUuyVA=;
	b=WmqpqnEu3yi7DlNhQr0mryhCoVIaiAwWm3eWnk2G2gkBQn8YOx35PGd2EJlARXBpmpBW2t
	9UUwOIfIHfb9k9zCujKHvsiH+QzZwHysL5eLJx/0kzkAaeWMEIZoKCA9HUfLAWs6G/s3Hl
	hpgMP2YDNKjsBnJZnXiZBuS6THkyWOk=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-370-IIXNRp38NQayN-I7ZSObOw-1; Wed,
 08 Jan 2025 05:43:08 -0500
X-MC-Unique: IIXNRp38NQayN-I7ZSObOw-1
X-Mimecast-MFC-AGG-ID: IIXNRp38NQayN-I7ZSObOw
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 61EBC1955BED;
	Wed,  8 Jan 2025 10:43:06 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9D150195608D;
	Wed,  8 Jan 2025 10:43:00 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:42:55 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 09/10] loop: refactor queue limits updates
Message-ID: <Z35Wrx1LxOScyNQK@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-10-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-10-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

On Wed, Jan 08, 2025 at 10:25:06AM +0100, Christoph Hellwig wrote:
> Replace loop_reconfigure_limits with a slightly less encompassing
> loop_update_limits that expects the aller to acquire and commit the
> queue limits to prepare for sorting out the freeze vs limits lock
> ordering.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

