Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAC3214A94
	for <linux-scsi@vger.kernel.org>; Thu,  9 Jan 2025 08:15:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736410510; cv=none; b=D/lTM17SpJaRaVoOi6FNWyrw+zafxgWXX5zUwnjjhq+qdUTD0Vv0rB1w/8REu9tchK3qwVm8qOKytc6C/twJqGI7P3Izm7sPF5XOxu2i5aMbQ6GgJzBAkvFCeecTvR40XZvBCXBTNg83a4kV/7vXL2I6gMD2zJgtJVz7QW5dJxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736410510; c=relaxed/simple;
	bh=yVw6vDK4v5v9oDe/aIrkKFm0EdKERDBvvVESA471VSs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KyPPT0t4hWWYkJzVkMJSYv9VsVQewrlJe5B2ZDH3f3hUaZTgd+kRvAXtuxk9O5aipkWX2mUGIV6mdM1gS3ODXtrBqhaMN3NYoCr7+k0dQ44I8x0/ILLABOsoC9X8qkosFGE15qF4OW9yb024QuFuCu4RyNa3+Ho2/HoR+2/UNYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=eTIgXNA8; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="eTIgXNA8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736410506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=8z5CkXWyMi/D4Z3NOATWeozJt2iBFHFltpjHR+p5wAU=;
	b=eTIgXNA8UaCdkyfvq1wIBC2PyggzDNgj2PFzP3gd9aIjKgHP4DoNwqD6ZSdwEvurL3Ypb/
	ytKQH0eaoSzLTH64+/Jq2T5Eo49H1N550RYL8rlgDKXtZwwpfnwBePXASnuv1cWKnbleZU
	XOwjS+8lo6iDx5dnI3ymD8rFAI2T/do=
Received: from mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-498-8fCmwubBOUKYHjEKZt6joQ-1; Thu,
 09 Jan 2025 03:15:03 -0500
X-MC-Unique: 8fCmwubBOUKYHjEKZt6joQ-1
X-Mimecast-MFC-AGG-ID: 8fCmwubBOUKYHjEKZt6joQ
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-02.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1FFD91955DD7;
	Thu,  9 Jan 2025 08:15:01 +0000 (UTC)
Received: from fedora (unknown [10.72.116.139])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 6724519560AA;
	Thu,  9 Jan 2025 08:14:53 +0000 (UTC)
Date: Thu, 9 Jan 2025 16:14:48 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 03/11] block: check BLK_FEAT_POLL under q_usage_count
Message-ID: <Z3-FePovuu2dEbfG@fedora>
References: <20250109055810.1402918-1-hch@lst.de>
 <20250109055810.1402918-4-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250109055810.1402918-4-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On Thu, Jan 09, 2025 at 06:57:24AM +0100, Christoph Hellwig wrote:
> Otherwise feature reconfiguration can race with I/O submission.
> 
> Also drop the bio_clear_polled in the error path, as the flag does not
> matter for instant error completions, it is a left over from when we
> allowed polled I/O to proceed unpolled in this case.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

