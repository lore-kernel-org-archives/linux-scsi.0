Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D28A1F543F
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:41:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736332883; cv=none; b=dgkprRiH9JV1M8x5E7BQOJHvvIk8T2ybgwVCKrWJ4EnafSkOiaOnN+nCwvzIoPWRUwRCjoN6cbt/iUFGCy0nOyUl8Z915YQBevYGM+ORPRnU6C7G+g84r//UbAUsvBonxiQ2CvSo4JNTBH6sn7gL6Gva5boKap0eYywA4chA5KA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736332883; c=relaxed/simple;
	bh=j3zH+4LTcaDATlhFz+ie3ojNUJQ33RMN1IRvDzO94xM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nT+UDtmJ+WRgfT2MhWwe65cO9isemDzJUUcfBrPdz9nb0diOWrnFjiJS9uu9GgMqW/Lu8IH5lp1TAxf0Y6AMQ1IIoHP+wtqkm9/rX/LqXZ0WyPgpjur8BtsscFSpuVEN/9k0PAbSrtXVWBPvad9CI45Pt2h2XSYE5Xye3qoQdnE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=fm9+LeaI; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fm9+LeaI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736332881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=k8suUcFwm047THkxW2EWlIrmlU/5tS7q0mJJEpCt/ws=;
	b=fm9+LeaIpVTlS40VZVkPvoRHuRTgsUdIAK+QA2IL4yZ5tn8Nvnh9fZFmUdHtsR5kqSeNe6
	0iSdxkto9Tnmiyi2kWwxjPhNNodjKuFfTGSyOhLCIS6Vlouc7pF0vXcbEXEfA4QskU5xtx
	5to9jpH4uBTWbVehh7Bv67ah9gg9oD0=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-658-0XEfdVjYN2K8E-U3H8I21Q-1; Wed,
 08 Jan 2025 05:41:17 -0500
X-MC-Unique: 0XEfdVjYN2K8E-U3H8I21Q-1
X-Mimecast-MFC-AGG-ID: 0XEfdVjYN2K8E-U3H8I21Q
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 45B8219153DB;
	Wed,  8 Jan 2025 10:41:15 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3D08319560AA;
	Wed,  8 Jan 2025 10:41:08 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:41:03 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 08/10] usb-storage: fix queue freeze vs limits lock order
Message-ID: <Z35WP7rXeF3D9MZV@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-9-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-9-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 08, 2025 at 10:25:05AM +0100, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>
 
Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks, 
Ming

