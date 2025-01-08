Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09BFA1F8682
	for <linux-scsi@vger.kernel.org>; Wed,  8 Jan 2025 10:19:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736331591; cv=none; b=ZjhUOnKiGlz+4Bqrtrx+LCa9jNddmAeTasfpn/+8rZrcUkLMAsHipPU2fNpOUO73IRKC73+Uf0uJ3SLEpWUW9Bdm8OIc5/kwgPaN03frczk/sWqfiSbHL7/JCd8nVYBgDDesL/Mx9FmUYJD81ukGm6Yfnj2ssezN5omN5OloZlQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736331591; c=relaxed/simple;
	bh=GjRjA4AToLr1VYBj6uwHz9x3uKpULdku4+2U5lrOR04=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sKQvTRqo32hcoc6TJc+TElDv23ev8zjUoOju/8HTr2IIcMOgmlbxkBpYtNHBXNF6izVS1Eo4El3LcTRuDh9QJbSRq3l2BT+ysKyT0L0BlKpVJawn/ORrBOyaHe8YbysfIaMCOlb3LFlCXhvYDzuee1BP2tUB6Jo4+MpLhUCBXDM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cjB00GHp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cjB00GHp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1736331588;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=u/2KSdc12WgjZkHVfUJEDj5QbQ8qveiZeeuKVBc+PgA=;
	b=cjB00GHph2RvzDk62980Qsvy7npoFHHoh2VHkDbIPKEVPwX0VCfNlRBSJaRyf5/eCD08Wk
	52GTIqm7Q6aAWWEhQd7OwGqW2HJJyUgQAmaQPgA10JvGRCvojkCe3uQILlfQ/PK8tyQElO
	Jxn3moNlmwMAIF3oYEJ7Qds76WZMLeQ=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-675-ZvBQQE5qPc602emy9OkUMw-1; Wed,
 08 Jan 2025 05:19:45 -0500
X-MC-Unique: ZvBQQE5qPc602emy9OkUMw-1
X-Mimecast-MFC-AGG-ID: ZvBQQE5qPc602emy9OkUMw
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EB3621944B2E;
	Wed,  8 Jan 2025 10:19:42 +0000 (UTC)
Received: from fedora (unknown [10.72.116.74])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 687A819560AA;
	Wed,  8 Jan 2025 10:19:35 +0000 (UTC)
Date: Wed, 8 Jan 2025 18:19:30 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Damien Le Moal <dlemoal@kernel.org>,
	Nilay Shroff <nilay@linux.ibm.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, nbd@other.debian.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net
Subject: Re: [PATCH 01/10] block: fix docs for freezing of queue limits
 updates
Message-ID: <Z35RMhj-tyy_nSDF@fedora>
References: <20250108092520.1325324-1-hch@lst.de>
 <20250108092520.1325324-2-hch@lst.de>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250108092520.1325324-2-hch@lst.de>
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

On Wed, Jan 08, 2025 at 10:24:58AM +0100, Christoph Hellwig wrote:
> queue_limits_commit_update is the function that needs to operate on a
> frozen queue, not queue_limits_start_update.  Update the kerneldoc
> comments to reflect that.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> Reviewed-by: Damien Le Moal <dlemoal@kernel.org>
> Reviewed-by: Nilay Shroff <nilay@linux.ibm.com>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,
Ming

