Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22DC38F82
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:40:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736332834; cv=none; b=ekgebWXmXVt3vA3SyLS8jCg6h0Ow6oPxmQRHAeQh0Je59wJMIh/fEkRxHTJvovhI+g5xqfLpCSEWsC9EJg56uS7bmb5QmLNEasFk4XbvW7VfUcZvMME5QrL+KoRyMA7RVHc4YpFe80XGsWQssPHCgiGT6F2rFXfy/wJIxAMCJwU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736332834; c=relaxed/simple;
	bh=+OSJrIpuk1LorWqyP0gD6snCmMEnSOnh/jJlUxU8Llk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=i+wZEcAfpaaLL/97+zFlAlWlzuPOUU/74ZK/wUCCL/CzO+pQC9nqX2mC2aROkJ9A76e7R78CYhAx/5Y90V8McKDrEbHAHvlgCP4EGCnWc23eDLzG0twu2kdOwfOtv/M2+gV6t5/ic2m3YaLmaBybyfmwEBuoaUQ/qI6dNKczmfE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Zbt8daSI; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Zbt8daSI"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736332832;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=FGBmseaRn70oadM25K2yW+V13wFXPvE/hJMxeGOTtEk=;
	b=Zbt8daSIOM3dv0wf5H76ZaneoHEMY9MMyI9kRy/AMvVJZCH9vF5+/k6VUyf4qpFwMuXrUE
	IQ865K23OfbFdXv2Hx3s6wi9kUqcfRsvk6qwM7LqjfRBr4m3Wz+f2RiDxWEOdCpRAg6xaW
	OaMZzzHl9ZyuPGWaRseKb6Qz7WsMvZk=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-447-Pe9XkdCQNzaj77ggO4HxXg-1; Wed,
 08 Jan 2025 05:40:28 -0500
X-MC-Unique: Pe9XkdCQNzaj77ggO4HxXg-1
X-Mimecast-MFC-AGG-ID: Pe9XkdCQNzaj77ggO4HxXg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 3B89D1956059;
	Wed,  8 Jan 2025 10:40:27 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 607071956053;
	Wed,  8 Jan 2025 10:40:20 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:40:15 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 07/10] nbd: fix queue freeze vs limits lock order
Message-ID: <Z35WD6VcPJSMiQpN@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-8-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-8-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Jan 08, 2025 at 10:25:04AM +0100, Christoph Hellwig wrote:
> Match the locking order used by the core block code by only freezing
> the queue after taking the limits lock using the
> queue_limits_commit_update_frozen helper.
> 
> This also allows removes the need for the separate __nbd_set_size helper,
> so remove it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks, 
Ming

