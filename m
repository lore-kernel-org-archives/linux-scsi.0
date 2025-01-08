Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39C0F20B20
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331671; cv=none; b=D/gUf5F044WEZ7YFVh+SP7dQxXEpu0HVTzws/N9KzmyFuyfMEoycN3Z9MdSqDZJudLGQtlnG7qHPqyUVpVGEUwr7tsi/d+ksWKMacZnQte/H0Vht7OrEfnKZxaF/Lj7bk3FvzvlUTjjY8rC8MLqjRObz7kyqb7N6rEOwMFNlGOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331671; c=relaxed/simple;
	bh=SZRkOKOx+ENflBZ1H7C1E/cttuMo1yopB9yRtYHiQMk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=S7+s6+8XKnp7UMLDQOvNq6sdvCxWIROYZEMj6XhNabCJI4TsK+RjaQqQRUKspaRBvnLZDBZusPHFYt3v3p+d+tee6YC42QSgWxJdWsfebq8IBN0SU6msRdM3Ax7gNuAPrGbMtKy62ayq+SuUWwY3hdzqHBI7km03/8OeieKCQ0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Dvae0cCG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Dvae0cCG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736331668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=AtbgMJMmVloW99gtaVlJcbuQAdmISbo7ifiFkzYXC5U=;
	b=Dvae0cCGGfbZDLvw8jwtVQR+/HvK2LjMx+Vkp1YRrRGdWDj3CIys1JpCr35jAJuMRE8c4U
	Bk2kcB+GhuJXn8G5ryDdFEtTrhhr6TJUCUHLb2y97S1ja8+0dZmVw2F77hpAEf5NO9l2A0
	KufPBgOb5+WPkdEec6+W7XIDF32cLh8=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-484-njvCHczuOeCFbIZmFXbyJA-1; Wed,
 08 Jan 2025 05:21:04 -0500
X-MC-Unique: njvCHczuOeCFbIZmFXbyJA-1
X-Mimecast-MFC-AGG-ID: njvCHczuOeCFbIZmFXbyJA
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07B1F19560BD;
	Wed,  8 Jan 2025 10:21:03 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 230CB1956053;
	Wed,  8 Jan 2025 10:20:56 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:20:51 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 02/10] block: add a queue_limits_commit_update_frozen
 helper
Message-ID: <Z35Rg9IQyiKpvMPv@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-3-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-3-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Wed, Jan 08, 2025 at 10:24:59AM +0100, Christoph Hellwig wrote:
> Add a helper that freezes the queue, updates the queue limits and
> unfreezes the queue and convert all open coded versions of that to the
> new helper.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

